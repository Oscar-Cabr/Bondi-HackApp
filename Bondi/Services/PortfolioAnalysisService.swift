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

    // Use Any? to store LanguageModelSession without @available on a stored property.
    // Accessing a type that doesn't exist on the running OS as a stored property
    // causes a crash at class instantiation time — Any? avoids this entirely.
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

        guard Self.isAvailable else {
            await appendAnimated(
                "Apple Intelligence no está disponible en este dispositivo. " +
                "Activalo en Ajustes → Apple Intelligence para usar el análisis de portafolio."
            )
            return
        }

        if #available(iOS 26.0, *) {
            session = LanguageModelSession(
                instructions: systemInstructions(for: investments)
            )
            await sendPrompt(initialPrompt(for: investments))
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

    private func sendPrompt(_ prompt: String) async {
        guard !isLoading else { return }
        isLoading = true

        let idx = appendStreamingPlaceholder()

        if #available(iOS 26.0, *), let session {
            do {
                let stream = session.streamResponse(to: prompt)
                for try await partial in stream {
                    messages[idx].content = partial.content
                }
                messages[idx].isStreaming = false
            } catch {
                // Fallback to animated template on any model error
                messages[idx].isStreaming = false
                let fallback = errorFallback(for: prompt)
                await animateContent(into: idx, text: fallback)
            }
        }

        isLoading = false
    }

    // MARK: Animated text (for fallback & unavailable)

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
            try? await Task.sleep(for: .milliseconds(30))
        }
        messages[idx].isStreaming = false
        isLoading = false
    }

    private func appendStreamingPlaceholder() -> Int {
        messages.append(ChatMessage(role: .assistant, content: "", isStreaming: true))
        return messages.count - 1
    }

    // MARK: Prompts

    private func systemInstructions(for investments: [InvestmentRecord]) -> String {
        let totalInvested = investments.reduce(0) { $0 + $1.amountUSD }
        let totalCurrent  = investments.reduce(0) { $0 + $1.currentValueUSD }
        let returnPct     = totalInvested > 0
            ? (totalCurrent - totalInvested) / totalInvested * 100 : 0

        let bondLines = investments.map { inv in
            "  • \(inv.bondCountryFlag) \(inv.bondName) (\(inv.bondCountry)): " +
            "$\(String(format: "%.2f", inv.amountUSD)) al \(String(format: "%.1f", inv.bondYieldAnnual))% anual, " +
            "vence en \(inv.monthsRemaining) mes\(inv.monthsRemaining == 1 ? "" : "es")."
        }.joined(separator: "\n")

        return """
            Eres un asistente educativo de Bondi que ayuda a entender datos de inversión en bonos soberanos.
            Explicas los datos del portafolio del usuario de forma clara, sin jerga financiera.
            No das recomendaciones financieras personalizadas; solo describes y explicas lo que muestran los datos.
            Usa español neutro. Máximo 4 oraciones por respuesta salvo que pidan más detalle.
            Responde siempre en español.

            DATOS DEL PORTAFOLIO:
            Total invertido: $\(String(format: "%.2f", totalInvested)) USD
            Valor actual: $\(String(format: "%.2f", totalCurrent)) USD
            Rendimiento acumulado: \(String(format: "%.2f", returnPct))%
            Inversiones activas:
            \(bondLines.isEmpty ? "  (sin inversiones aún)" : bondLines)
            """
    }

    private func initialPrompt(for investments: [InvestmentRecord]) -> String {
        if investments.isEmpty {
            return "El usuario aún no tiene inversiones. Salúdalo y explica en 2-3 oraciones qué hace Bondi y cómo puede empezar a invertir desde $5."
        }
        return "Describe brevemente los datos del portafolio: en qué países está invertido, cuál es el rendimiento general y cuándo vence la próxima inversión. Sé amigable y claro."
    }

    private func errorFallback(for prompt: String) -> String {
        "No pude procesar esa consulta en este momento. Intentá reformularla o probá de nuevo."
    }
}
