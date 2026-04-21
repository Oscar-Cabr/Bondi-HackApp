import SwiftUI

struct BondCardView: View {
    let bond: Bond

    var body: some View {
        HStack(spacing: 16) {
            Text(bond.countryFlag)
                .font(.system(size: 36))

            VStack(alignment: .leading, spacing: 4) {
                Text(bond.name)
                    .font(.bondiTitle3)
                    .foregroundStyle(Color.bondiNavy)

                Text("\(bond.yieldAnnual, specifier: "%.1f")% anual · \(bond.monthsToMaturity) meses")
                    .font(.bondiSubheadline)
                    .foregroundStyle(Color.bondiNavy.opacity(0.7))

                HStack(spacing: 8) {
                    Text("Desde $\(Int(bond.minInvestmentUSD))")
                        .font(.bondiCaption)
                        .foregroundStyle(Color.bondiNavy.opacity(0.7))
                    RiskBadge(riskLevel: bond.riskLevel)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color.bondiNavy.opacity(0.3))
                .font(.caption)
        }
        .padding(16)
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.bondiNavy.opacity(0.04), radius: 10, y: 4)
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
                .font(.bondiCaption2)
            Text("Riesgo \(riskLevel.rawValue)")
                .foregroundStyle(.secondary)
                .font(.bondiCaption)
        }
    }
}
