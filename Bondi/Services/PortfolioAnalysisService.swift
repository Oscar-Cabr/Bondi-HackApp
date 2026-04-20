import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class PortfolioAnalysisService {

    // MARK: Chat message

    struct ChatMessage: Identifiable {
        let id = UUID()
        enum Role { case user, assistant }
        let role: Role
        var content: String
        var isStreaming: Bool = false
    }

    // MARK: State

    private(set) var messages: [ChatMessage] = []
    private(set) var isLoading = false
    var inputText = ""

    private var investmentsSnapshot: [InvestmentRecord] = []
    private var fallbackRotation = 0

    // Stored as Any? because LanguageModelSession is iOS 26+ only.
    private var _session: Any?

    @available(iOS 26.0, *)
    private var session: LanguageModelSession? {
        get { _session as? LanguageModelSession }
        set { _session = newValue }
    }

    // MARK: Availability

    private static var isAvailable: Bool {
        if #available(iOS 26.0, *) {
            return SystemLanguageModel.default.availability == .available
        }
        return false
    }

    // MARK: Start

    func start(investments: [InvestmentRecord]) async {
        guard messages.isEmpty else { return }
        investmentsSnapshot = investments

        guard Self.isAvailable else {
            await appendAnimated(
                "Apple Intelligence no está disponible en este dispositivo. " +
                "Activalo en Ajustes → Apple Intelligence."
            )
            return
        }

        if #available(iOS 26.0, *) {
            session = makeSession()
            await sendPrompt(initialPrompt())
        }
    }

    // MARK: Send user message

    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isLoading else { return }
        inputText = ""
        messages.append(ChatMessage(role: .user, content: text))

        guard Self.isAvailable, #available(iOS 26.0, *) else {
            await appendAnimated("Apple Intelligence no está disponible en este momento.")
            return
        }
        await sendPrompt(text)
    }

    // MARK: Core streaming

    @available(iOS 26.0, *)
    private func makeSession() -> LanguageModelSession {
        LanguageModelSession(instructions: systemInstructions())
    }

    private func sendPrompt(_ prompt: String) async {
        guard !isLoading else { return }
        isLoading = true

        let idx = appendStreamingPlaceholder()

        if #available(iOS 26.0, *) {
            let result = await attemptStream(prompt: prompt, into: idx)

            switch result {
            case .success:
                isLoading = false
                return

            case .assetsMissing:
                // Safety/language model assets not available on this device.
                // Retrying won't help — fall back directly with a real data-backed reply.
                messages[idx].isStreaming = false
                await animateContent(into: idx, text: dataBackedFallback(for: prompt))
                return

            case .other:
                // Possibly poisoned session → retry once with fresh session.
                session = makeSession()
                let retry = await attemptStream(prompt: prompt, into: idx)
                if case .success = retry {
                    isLoading = false
                    return
                }
                messages[idx].isStreaming = false
                await animateContent(into: idx, text: dataBackedFallback(for: prompt))
                return
            }
        }

        isLoading = false
    }

    enum StreamResult {
        case success
        case assetsMissing      // Apple Intelligence assets not downloaded / catalog error
        case other              // Generic error — may be transient
    }

    @available(iOS 26.0, *)
    private func attemptStream(prompt: String, into idx: Int) async -> StreamResult {
        guard let session else { return .other }
        messages[idx].content = ""
        messages[idx].isStreaming = true

        do {
            let stream = session.streamResponse(to: prompt)
            for try await partial in stream {
                messages[idx].content = partial.content
            }
            messages[idx].isStreaming = false
            return messages[idx].content.isEmpty ? .other : .success
        } catch {
            logModelError(error, prompt: prompt)
            messages[idx].isStreaming = false
            return classify(error)
        }
    }

    private func classify(_ error: Error) -> StreamResult {
        let description = String(describing: error).lowercased()
        let assetMarkers = [
            "modelcatalog",
            "unifiedassetframework",
            "sensitivecontentanalysisml",
            "modelmanagerservices",
            "no underlying assets"
        ]
        if assetMarkers.contains(where: description.contains) {
            return .assetsMissing
        }
        return .other
    }

    private func logModelError(_ error: Error, prompt: String) {
        print("╭─ [PortfolioAnalysis] Model error ────────────")
        print("│  prompt: \(prompt.prefix(100))…")
        print("│  error:  \(error)")
        print("│  type:   \(type(of: error))")
        print("╰───────────────────────────────────────────────")
    }

    // MARK: Data-backed fallback (no AI required, uses the actual portfolio)

    private func dataBackedFallback(for prompt: String) -> String {
        let lowered = prompt
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
        let investments = investmentsSnapshot

        // ─── 1. Social / meta intents ────────────────────────────
        if matches(lowered, any: [
            "hola", "holis", "buenas", "hey", "que tal", "que hay",
            "buen dia", "buenos dias", "buenas tardes", "buenas noches"
        ]) {
            if investments.isEmpty {
                return "¡Hola! Cuando hagas tu primera inversión voy a poder contarte cómo va tu portafolio."
            }
            return "¡Hola! Tenés \(investments.count) inversión\(investments.count == 1 ? "" : "es") activa\(investments.count == 1 ? "" : "s"). Preguntame lo que quieras sobre ellas."
        }

        if matches(lowered, any: ["chau", "adios", "nos vemos", "hasta luego", "hasta pronto"]) {
            return "¡Dale, cualquier cosa estoy acá! Podés volver cuando quieras revisar tu portafolio."
        }

        if matches(lowered, any: ["gracias", "genial", "perfecto", "entendido", "dale", "copiado", "barbaro"]) {
            return "¡De nada! Si querés saber algo más de tu portafolio, estoy acá."
        }

        if matches(lowered, any: [
            "que puedo hacer", "que puedo preguntar", "ayuda", "help",
            "opciones", "que sabes", "que haces", "como funcion",
            "que preguntas", "ejemplos"
        ]) {
            return """
            Te puedo contar:
            • Cuánto invertiste en total y cuánto vale hoy
            • En qué países tenés inversiones
            • Cuál bono vence primero y cuánto vas a cobrar
            • Cuál rinde más y cuál menos
            • El rendimiento promedio de tu portafolio
            • Detalles de un bono o país específico
            También te explico qué son los bonos, cómo funciona Bondi, qué es el rendimiento, los impuestos, el riesgo, etc.
            """
        }

        if matches(lowered, any: ["quien sos", "quien eres", "como te llamas", "tu nombre"]) {
            return "Soy el asistente de Bondi. Estoy acá para ayudarte a entender tus inversiones en bonos soberanos."
        }

        // ─── 2. Educational (no portfolio data needed) ───────────
        if matches(lowered, any: [
            "que es un bono", "que son los bonos", "explicame los bonos",
            "explica bonos", "definicion de bono", "que significa bono"
        ]) {
            return "Un bono soberano es un préstamo que le hacés a un país. El gobierno te devuelve tu dinero en una fecha pactada y además te paga intereses por haberlo prestado. En Bondi invertís en bonos en dólares de países de Latinoamérica."
        }

        if matches(lowered, any: ["que es bondi", "como funciona bondi", "para que sirve bondi"]) {
            return "Bondi es una app para invertir en bonos soberanos de Latinoamérica desde tu celular, en dólares y desde montos chicos. Usa la red Stellar para hacerlo simple y con comisiones bajas."
        }

        if matches(lowered, any: ["que es rendimiento", "que es el yield", "que es la tasa", "que es el interes"]) {
            return "El rendimiento (o tasa) es el porcentaje anual que te paga el bono. Por ejemplo, 10% anual significa que por cada $100 invertidos recibís $10 al año en intereses."
        }

        if matches(lowered, any: ["que es vencimiento", "que significa vencer", "que es madurez"]) {
            return "El vencimiento es la fecha en que el emisor del bono te devuelve el capital invertido. Hasta ese momento recibís los intereses pactados."
        }

        if matches(lowered, any: ["impuesto", "impuestos", "tax", "afip", "sat", "declar"]) {
            return "Los impuestos dependen del país donde residas fiscalmente. En general, los intereses y las ganancias de capital pueden estar sujetos a impuesto a las ganancias. Te recomiendo consultar con un contador de tu país."
        }

        if matches(lowered, any: ["stellar", "blockchain", "cripto", "red", "onchain"]) {
            return "Bondi usa la red Stellar para liquidar las transacciones. Esto hace que las operaciones sean rápidas (segundos), baratas (fracciones de centavo) y transparentes."
        }

        if matches(lowered, any: ["kyc", "verifica", "identidad", "documento", "dni", "pasaporte"]) {
            return "El KYC es el proceso de verificación de identidad que pide la regulación. En Bondi se hace en pocos minutos desde la app, subiendo tu documento y una selfie."
        }

        if matches(lowered, any: ["comisi", "fee", "costo", "cuanto cobran"]) {
            return "Las comisiones de Bondi están diseñadas para ser transparentes y competitivas. La red Stellar cobra fracciones de centavo por transacción."
        }

        if matches(lowered, any: ["moneda", "dolar", "dolares", "peso", "usd"]) {
            return "Todas las inversiones en Bondi están denominadas en dólares (USD). Esto te protege de la devaluación de las monedas locales de Latinoamérica."
        }

        if matches(lowered, any: ["como invert", "como compro", "como pongo plata", "como agrego", "como empiezo"]) {
            return "Para invertir: entrá al catálogo, elegí un bono que te guste, ingresá el monto en dólares y confirmá con Face ID. Tu inversión queda registrada al instante."
        }

        if matches(lowered, any: ["default", "impago", "puede no pagar", "y si no paga"]) {
            return "Cuando un país no puede pagar un bono se llama 'default'. Es un riesgo real aunque poco frecuente en economías estables. Por eso diversificar entre varios países ayuda a reducir ese riesgo."
        }

        // ─── 3. Portfolio data required ──────────────────────────
        guard !investments.isEmpty else {
            return "Todavía no tenés inversiones. Cuando hagas la primera voy a poder ayudarte a entenderla. Mientras tanto podés preguntarme cómo funcionan los bonos."
        }

        let total = investments.reduce(0) { $0 + $1.amountUSD }
        let current = investments.reduce(0) { $0 + $1.currentValueUSD }
        let gain = current - total
        let countries = Array(Set(investments.map(\.bondCountry))).sorted()
        let nextMaturity = investments.min(by: { $0.monthsRemaining < $1.monthsRemaining })
        let last = investments.max(by: { $0.monthsRemaining < $1.monthsRemaining })
        let best = investments.max(by: { $0.bondYieldAnnual < $1.bondYieldAnnual })
        let worst = investments.min(by: { $0.bondYieldAnnual < $1.bondYieldAnnual })
        let biggest = investments.max(by: { $0.amountUSD < $1.amountUSD })
        let avgYield = investments.map(\.bondYieldAnnual).reduce(0, +) / Double(investments.count)

        // Specific country mentioned → describe that country's investments
        for country in countries {
            let normalized = country
                .lowercased()
                .folding(options: .diacriticInsensitive, locale: .current)
            if lowered.contains(normalized) {
                let countryInvs = investments.filter { $0.bondCountry == country }
                let countryTotal = countryInvs.reduce(0) { $0 + $1.amountUSD }
                let names = countryInvs.map(\.bondName).joined(separator: ", ")
                return "En \(country) tenés \(countryInvs.count) inversión\(countryInvs.count == 1 ? "" : "es") (\(names)) por un total de $\(fmt(countryTotal))."
            }
        }

        if matches(lowered, any: ["pais", "paises", "diversif", "donde invert", "geograf", "distribuc"]) {
            if countries.count == 1 {
                return "Tu portafolio está 100% en \(countries[0]). Cuando sumes bonos de otros países vas a ver la distribución acá."
            }
            return "Tenés inversiones en \(countries.count) países: \(countries.joined(separator: ", ")). Diversificar entre países ayuda a bajar el riesgo."
        }

        if matches(lowered, any: [
            "vence", "proximo", "cuando termina", "cuando cobro",
            "plazo", "madura", "madurez", "primer cobro", "cuando recibo"
        ]) {
            if let n = nextMaturity {
                return "La próxima inversión que vence es \(n.bondName) (\(n.bondCountry)) en \(n.monthsRemaining) mes\(n.monthsRemaining == 1 ? "" : "es"). Te va a devolver aproximadamente $\(fmt(n.expectedReturnAtMaturity))."
            }
        }

        if matches(lowered, any: ["ultimo", "mas lejos", "mas tarde", "que vence despues"]) {
            if let l = last {
                return "El bono que vence más tarde es \(l.bondName) (\(l.bondCountry)) en \(l.monthsRemaining) meses."
            }
        }

        if matches(lowered, any: [
            "ganan", "rendi", "ganas", "beneficio", "retorno",
            "cuanto llevo", "cuanto gane", "como voy", "pnl"
        ]) {
            let sign = gain >= 0 ? "+" : ""
            let pct = total > 0 ? (gain / total) * 100 : 0
            return "Invertiste $\(fmt(total)) y hoy valen $\(fmt(current)). Diferencia: \(sign)$\(fmt(gain)) (\(sign)\(String(format: "%.2f", pct))%)."
        }

        if matches(lowered, any: ["mejor", "mas alt", "mayor", "mas rend", "cual rinde", "top", "estrella"]) {
            if let b = best {
                return "El bono con mayor rendimiento en tu portafolio es \(b.bondName) (\(b.bondCountry)) al \(String(format: "%.1f", b.bondYieldAnnual))% anual."
            }
        }

        if matches(lowered, any: ["peor", "menor", "mas baj", "menos rend", "menos rinde"]) {
            if let w = worst {
                return "El bono con menor rendimiento es \(w.bondName) (\(w.bondCountry)) al \(String(format: "%.1f", w.bondYieldAnnual))% anual."
            }
        }

        if matches(lowered, any: ["promedio", "media", "average", "tasa promedio"]) {
            return "El rendimiento promedio de tu portafolio es \(String(format: "%.2f", avgYield))% anual."
        }

        if matches(lowered, any: [
            "cuanto invert", "total invert", "cuanto tengo",
            "cuanto puse", "monto", "capital", "cuanto es"
        ]) {
            return "En total tenés $\(fmt(total)) invertidos, distribuidos en \(investments.count) bono\(investments.count == 1 ? "" : "s")."
        }

        if matches(lowered, any: ["valor actual", "cuanto vale", "cuanto valen", "hoy cuanto"]) {
            return "Tu portafolio vale hoy aproximadamente $\(fmt(current))."
        }

        if matches(lowered, any: ["mayor inversion", "mas grande", "donde tengo mas", "posicion mas grande"]) {
            if let big = biggest {
                return "Tu mayor inversión es \(big.bondName) (\(big.bondCountry)) con $\(fmt(big.amountUSD))."
            }
        }

        if matches(lowered, any: ["riesgo", "seguro", "peligro", "que tan seguro", "puede perder"]) {
            return "Invertís en bonos soberanos de \(countries.joined(separator: ", ")). El riesgo principal es que el país no pueda pagar al vencimiento, aunque los bonos soberanos suelen considerarse de menor riesgo que los corporativos. Diversificar entre países ayuda a reducirlo."
        }

        if matches(lowered, any: [
            "cuantas", "cuantos bonos", "cuantas inversiones",
            "cantidad de", "cuantas tengo"
        ]) {
            return "Tenés \(investments.count) inversión\(investments.count == 1 ? "" : "es") activa\(investments.count == 1 ? "" : "s") en este momento."
        }

        if matches(lowered, any: ["lista", "mostrame", "todos", "listar", "enumera", "cuales son"]) {
            let lines = investments.map { inv in
                "• \(inv.bondCountryFlag) \(inv.bondName) — $\(fmt(inv.amountUSD)) al \(String(format: "%.1f", inv.bondYieldAnnual))% · vence en \(inv.monthsRemaining) meses"
            }.joined(separator: "\n")
            return "Tus inversiones actuales:\n\(lines)"
        }

        if matches(lowered, any: ["vender", "retirar", "sacar", "como salgo"]) {
            return "Los bonos se mantienen hasta su vencimiento para recibir el capital más los intereses. Si necesitás liquidez antes, podés consultar las opciones de venta en el detalle de cada bono."
        }

        if matches(lowered, any: ["comprar mas", "invertir mas", "agregar", "sumar"]) {
            return "Para sumar más inversiones, andá al catálogo y elegí el bono que te interese. Podés empezar desde montos chicos y diversificar entre países."
        }

        // ─── 4. Unknown question → rotating summary ──────────────
        return rotatingSummary(
            investments: investments,
            total: total,
            current: current,
            countries: countries,
            nextMaturity: nextMaturity,
            best: best,
            avgYield: avgYield
        )
    }

    private func rotatingSummary(
        investments: [InvestmentRecord],
        total: Double,
        current: Double,
        countries: [String],
        nextMaturity: InvestmentRecord?,
        best: InvestmentRecord?,
        avgYield: Double
    ) -> String {
        fallbackRotation += 1
        let n = investments.count
        let countryList = countries.joined(separator: ", ")

        switch fallbackRotation % 4 {
        case 0:
            let nextMat = nextMaturity.map { "\($0.bondName) en \($0.monthsRemaining) meses" } ?? "—"
            return """
            Tenés \(n) inversión\(n == 1 ? "" : "es") por un total de $\(fmt(total)) en \(countries.count == 1 ? "un país" : "\(countries.count) países") (\(countryList)). Valor actual: $\(fmt(current)). Próximo vencimiento: \(nextMat).
            """
        case 1:
            if let b = best {
                return "El rendimiento promedio de tu portafolio es \(String(format: "%.1f", avgYield))% anual. El más alto es \(b.bondName) al \(String(format: "%.1f", b.bondYieldAnnual))% anual."
            }
            return "El rendimiento promedio de tu portafolio es \(String(format: "%.1f", avgYield))% anual."
        case 2:
            let lines = investments.map { inv in
                "• \(inv.bondCountryFlag) \(inv.bondName) — $\(fmt(inv.amountUSD)) al \(String(format: "%.1f", inv.bondYieldAnnual))%"
            }.joined(separator: "\n")
            return "Tus inversiones actuales:\n\(lines)"
        default:
            if let n = nextMaturity {
                return "Tu próximo cobro es \(n.bondName) en \(n.monthsRemaining) mes\(n.monthsRemaining == 1 ? "" : "es"). Te devolverá aproximadamente $\(fmt(n.expectedReturnAtMaturity)) sobre los $\(fmt(n.amountUSD)) invertidos."
            }
            return "Tenés $\(fmt(total)) invertidos en total."
        }
    }

    private func matches(_ text: String, any keywords: [String]) -> Bool {
        keywords.contains { text.contains($0) }
    }

    private func fmt(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    // MARK: Animated text

    private func appendAnimated(_ text: String) async {
        let idx = appendStreamingPlaceholder()
        await animateContent(into: idx, text: text)
    }

    private func animateContent(into idx: Int, text: String) async {
        let words = text.components(separatedBy: " ")
        var accumulated = ""
        for (i, word) in words.enumerated() {
            accumulated += (i == 0 ? "" : " ") + word
            messages[idx].content = accumulated
            try? await Task.sleep(for: .milliseconds(25))
        }
        messages[idx].isStreaming = false
        isLoading = false
    }

    private func appendStreamingPlaceholder() -> Int {
        messages.append(ChatMessage(role: .assistant, content: "", isStreaming: true))
        return messages.count - 1
    }

    // MARK: Prompts — NEUTRAL framing (no financial terms in context)

    private func systemInstructions() -> String {
        """
        Eres un asistente que lee una tabla con filas y la describe en español.
        Cada fila tiene: país, nombre, cantidad, porcentaje anual, meses restantes.
        Tu trabajo es responder preguntas del usuario sobre esa tabla en 2-4 oraciones.
        Describe solo lo que está en la tabla. No hagas cálculos complejos ni des opiniones.
        Responde siempre en español neutro y amigable.
        """
    }

    private func tableBlock() -> String {
        guard !investmentsSnapshot.isEmpty else {
            return "La tabla está vacía."
        }
        let rows = investmentsSnapshot.map { inv in
            "- \(inv.bondCountryFlag) \(inv.bondCountry) | \(inv.bondName) | " +
            "\(String(format: "%.2f", inv.amountUSD)) | " +
            "\(String(format: "%.1f", inv.bondYieldAnnual))% por año | " +
            "termina en \(inv.monthsRemaining) mes\(inv.monthsRemaining == 1 ? "" : "es")"
        }.joined(separator: "\n")
        return """
            Tabla actual del usuario (país | nombre | cantidad | porcentaje anual | plazo restante):
            \(rows)
            """
    }

    private func initialPrompt() -> String {
        if investmentsSnapshot.isEmpty {
            return """
            \(tableBlock())
            Saluda al usuario en 2 oraciones y cuéntale que cuando tenga filas en esta tabla podrás ayudarlo a entenderla.
            """
        }
        return """
        \(tableBlock())
        En 3 oraciones, describe lo que muestra la tabla: de qué países son las filas, cuál es la suma total de la columna "cantidad" y cuál es la fila que termina antes.
        """
    }

}
