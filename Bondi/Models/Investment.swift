import Foundation

struct Investment: Identifiable {
    let id: UUID
    let bond: Bond
    let amountUSD: Double
    let feeUSD: Double
    let investedAt: Date

    var currentValueUSD: Double {
        let elapsed = Calendar.current.dateComponents([.day], from: investedAt, to: .now).day ?? 0
        let years = Double(elapsed) / 365.0
        return amountUSD * (1 + bond.yieldAnnual / 100.0 * years)
    }

    var returnUSD: Double { currentValueUSD - amountUSD }
    var returnPercent: Double { amountUSD > 0 ? returnUSD / amountUSD * 100 : 0 }
    var expectedReturnAtMaturity: Double { bond.projectedReturn(for: amountUSD) }
}
