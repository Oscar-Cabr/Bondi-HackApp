import FoundationModels

@Generable
struct BondExplanation {
    @Guide(description: "Una sola oración muy clara para alguien sin conocimientos financieros.")
    var simpleSummary: String

    @Guide(description: "Explicación del bono en 2-3 oraciones, sin jerga financiera, en español neutro.")
    var whatItMeans: String

    @Guide(description: "Ejemplo concreto usando los números reales del bono. Usa 'tú' o 'vos' según contexto LATAM.")
    var concreteExample: String

    @Guide(description: "Nivel de riesgo explicado en una oración, en términos simples.")
    var riskSummary: String
}
