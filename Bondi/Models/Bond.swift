import Foundation

struct Bond: Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let countryFlag: String
    let yieldAnnual: Double
    let maturityDate: Date
    let minInvestmentUSD: Double
    let riskLevel: RiskLevel
    let issuerDescription: String
    var heroImageName: String? = nil

    enum RiskLevel: String, CaseIterable, Hashable {
        case low = "Bajo"
        case medium = "Medio"
        case high = "Alto"

        var filledDots: Int {
            switch self {
            case .low: return 1
            case .medium: return 2
            case .high: return 3
            }
        }
    }

    var monthsToMaturity: Int {
        max(0, Calendar.current.dateComponents([.month], from: .now, to: maturityDate).month ?? 0)
    }

    func projectedReturn(for amount: Double) -> Double {
        let years = Double(monthsToMaturity) / 12.0
        return amount * (1 + yieldAnnual / 100.0 * years)
    }
}
