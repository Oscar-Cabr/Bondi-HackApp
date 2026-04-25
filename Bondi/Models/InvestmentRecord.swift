import Foundation
import SwiftData

@Model
final class InvestmentRecord {
    var id: UUID
    var investedAt: Date

    var bondId: String
    var bondName: String
    var bondCountry: String
    var bondCountryFlag: String
    var bondYieldAnnual: Double
    var bondMaturityDate: Date
    var bondRiskLevel: String

    var amountUSD: Double
    var feeUSD: Double

    init(
        id: UUID = UUID(),
        investedAt: Date = .now,
        bond: Bond,
        amountUSD: Double,
        feeUSD: Double
    ) {
        self.id = id
        self.investedAt = investedAt
        self.bondId = bond.id
        self.bondName = bond.name
        self.bondCountry = bond.country
        self.bondCountryFlag = bond.countryFlag
        self.bondYieldAnnual = bond.yieldAnnual
        self.bondMaturityDate = bond.maturityDate
        self.bondRiskLevel = bond.riskLevel.rawValue
        self.amountUSD = amountUSD
        self.feeUSD = feeUSD
    }


    var currentValueUSD: Double {
        let elapsed = Calendar.current.dateComponents([.day], from: investedAt, to: .now).day ?? 0
        let years = Double(elapsed) / 365.0
        return amountUSD * (1 + bondYieldAnnual / 100.0 * years)
    }

    var returnUSD: Double { currentValueUSD - amountUSD }

    var returnPercent: Double {
        amountUSD > 0 ? returnUSD / amountUSD * 100 : 0
    }

    var expectedReturnAtMaturity: Double {
        let months = max(0, Calendar.current.dateComponents(
            [.month], from: investedAt, to: bondMaturityDate
        ).month ?? 0)
        let years = Double(months) / 12.0
        return amountUSD * (1 + bondYieldAnnual / 100.0 * years)
    }

    var monthsRemaining: Int {
        max(0, Calendar.current.dateComponents([.month], from: .now, to: bondMaturityDate).month ?? 0)
    }

    var isMatured: Bool { bondMaturityDate <= .now }
}
