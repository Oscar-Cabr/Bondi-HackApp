import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class BondExplainerService {


    enum ExplainState {
        case idle
        case streaming(String)
        case ready(String)
        case fallback(String)
        case failed

        var isLoading: Bool {
            if case .streaming = self { return true }
            return false
        }

        var displayText: String? {
            switch self {
            case .streaming(let t), .ready(let t), .fallback(let t): return t
            default: return nil
            }
        }

        var isAIGenerated: Bool {
            if case .ready = self { return true }
            return false
        }
    }

    private(set) var state: ExplainState = .idle


    static var isAvailable: Bool {
        if #available(iOS 26.0, *) {
            return SystemLanguageModel.default.availability == .available
        }
        return false
    }


    func explain(bond: Bond) async {
        guard !state.isLoading else { return }

        if Self.isAvailable {
            await explainWithAI(bond: bond)
        } else {
            await animateFallback(bond: bond)
        }
    }

    func reset() { state = .idle }


    private func explainWithAI(bond: Bond) async {
        guard #available(iOS 26.0, *) else { return }

        state = .streaming("")
        do {
            let session = LanguageModelSession(instructions: Self.systemInstructions)
            let stream = session.streamResponse(to: Self.buildPrompt(for: bond))
            var accumulated = ""
            for try await partial in stream {
                accumulated = partial.content
                state = .streaming(accumulated)
            }
            state = .ready(accumulated)
        } catch {
            await animateFallback(bond: bond)
        }
    }


    private func animateFallback(bond: Bond) async {
        let template = Self.templateText(for: bond)
        let words = template.components(separatedBy: " ")
        state = .streaming("")
        var accumulated = ""
        for (i, word) in words.enumerated() {
            accumulated += (i == 0 ? "" : " ") + word
            state = .streaming(accumulated)
            try? await Task.sleep(for: .milliseconds(28))
        }
        state = .fallback(accumulated)
    }


    private static let systemInstructions = """
        Eres un asistente educativo de Bondi, app de inversión en bonos soberanos.
        Tu función es explicar en qué consiste un bono específico de forma clara y breve.
        Usa español neutro. Di "rendimiento" en lugar de "yield".
        Estructura tu respuesta en 4 párrafos cortos separados por una línea en blanco:
        1. Qué es (una oración).
        2. Cómo funciona la inversión (dos oraciones).
        3. Ejemplo con los números exactos del bono ($100 → $X en N meses).
        4. Nivel de riesgo (una oración).
        Sin títulos, sin bullets, sin advertencias legales.
        """

    private static func buildPrompt(for bond: Bond) -> String {
        let years = Double(bond.monthsToMaturity) / 12.0
        let example = 100.0 * (1 + bond.yieldAnnual / 100.0 * years)
        return """
            Explica este bono para un usuario nuevo:
            Nombre: \(bond.name)
            País: \(bond.country)
            Rendimiento: \(String(format: "%.1f", bond.yieldAnnual))% anual
            Plazo: \(bond.monthsToMaturity) meses
            Riesgo: \(bond.riskLevel.rawValue)
            Emisor: \(bond.issuerDescription)
            Referencia: $100 invertidos hoy → $\(String(format: "%.0f", example)) en \(bond.monthsToMaturity) meses.
            """
    }


    static func templateText(for bond: Bond) -> String {
        let years = Double(bond.monthsToMaturity) / 12.0
        let example = 100.0 * (1 + bond.yieldAnnual / 100.0 * years)
        return """
            \(bond.name) es deuda emitida por el gobierno de \(bond.country).

            Al invertir, le prestás dinero al Estado y este se compromete a devolvértelo al vencimiento con un \(String(format: "%.1f", bond.yieldAnnual))% de interés anual. \(bond.issuerDescription)

            Si invertís $100 hoy, en \(bond.monthsToMaturity) meses recibirás aproximadamente $\(String(format: "%.0f", example)).

            El riesgo es \(bond.riskLevel.rawValue.lowercased()): el emisor es el gobierno de \(bond.country), respaldado por el Estado.
            """
    }
}
