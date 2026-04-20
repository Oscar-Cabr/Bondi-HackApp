import ClerkKit
import ClerkKitUI
import SwiftUI

struct PortfolioView: View {
    @Environment(Clerk.self) private var clerk
    private let investments = MockData.investments

    private var totalInvested: Double { investments.reduce(0) { $0 + $1.amountUSD } }
    private var totalCurrent: Double { investments.reduce(0) { $0 + $1.currentValueUSD } }
    private var totalReturn: Double { totalCurrent - totalInvested }
    private var totalReturnPercent: Double { totalInvested > 0 ? totalReturn / totalInvested * 100 : 0 }

    private var greeting: String {
        if let first = clerk.user?.firstName, !first.isEmpty {
            return "Hola, \(first)"
        }
        return "Valor total"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance card
                    VStack(spacing: 8) {
                        Text(greeting)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                        Text("$\(totalCurrent, specifier: "%.2f")")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(.white)
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.right")
                            Text("$\(totalReturn, specifier: "%.2f") (\(totalReturnPercent, specifier: "%.2f")%)")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.bondiGreen)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color.bondiNavy)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)

                    // Active investments
                    SectionHeader(title: "Mis inversiones")

                    if investments.isEmpty {
                        ContentUnavailableView(
                            "Sin inversiones aún",
                            systemImage: "chart.pie",
                            description: Text("Explora el catálogo y realiza tu primera inversión")
                        )
                    } else {
                        VStack(spacing: 10) {
                            ForEach(investments) { investment in
                                InvestmentRow(investment: investment)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Upcoming maturities
                    SectionHeader(title: "Próximos vencimientos")

                    VStack(spacing: 10) {
                        ForEach(investments.sorted { $0.bond.maturityDate < $1.bond.maturityDate }) { investment in
                            MaturityRow(investment: investment)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Mi Portafolio")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    UserButton()
                        .environment(\.clerkTheme, .bondi)
                }
            }
        }
    }
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

private struct InvestmentRow: View {
    let investment: Investment

    var body: some View {
        HStack(spacing: 12) {
            Text(investment.bond.countryFlag).font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(investment.bond.name).font(.subheadline.bold())
                Text("Invertido: $\(investment.amountUSD, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(investment.currentValueUSD, specifier: "%.2f")").font(.subheadline.bold())
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up.right").font(.caption2)
                    Text("\(investment.returnPercent, specifier: "%.2f")%").font(.caption)
                }
                .foregroundStyle(Color.bondiGreen)
            }
        }
        .padding()
        .background(Color.bondiCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct MaturityRow: View {
    let investment: Investment

    var body: some View {
        HStack(spacing: 12) {
            Text(investment.bond.countryFlag).font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(investment.bond.name).font(.subheadline.bold())
                Text(investment.bond.maturityDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("$\(investment.expectedReturnAtMaturity, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundStyle(Color.bondiGreen)
        }
        .padding()
        .background(Color.bondiCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
