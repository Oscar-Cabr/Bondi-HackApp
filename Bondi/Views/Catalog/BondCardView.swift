import SwiftUI

struct BondCardView: View {
    let bond: Bond

    var body: some View {
        HStack(spacing: 16) {
            Text(bond.countryFlag)
                .font(.system(size: 36))

            VStack(alignment: .leading, spacing: 4) {
                Text(bond.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("\(bond.yieldAnnual, specifier: "%.1f")% anual · \(bond.monthsToMaturity) meses")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Text("Desde $\(Int(bond.minInvestmentUSD))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    RiskBadge(riskLevel: bond.riskLevel)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.caption)
        }
        .padding(16)
        .background(Color.bondiCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct RiskBadge: View {
    let riskLevel: Bond.RiskLevel

    private var color: Color {
        switch riskLevel {
        case .low: return .bondiGreen
        case .medium: return .bondiAmber
        case .high: return .bondiRed
        }
    }

    private var dots: String {
        (0..<3).map { $0 < riskLevel.filledDots ? "●" : "○" }.joined()
    }

    var body: some View {
        HStack(spacing: 4) {
            Text(dots)
                .foregroundStyle(color)
                .font(.caption2)
            Text("Riesgo \(riskLevel.rawValue)")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}
