import ClerkKit
import ClerkKitUI
import SwiftData
import SwiftUI

struct PortfolioView: View {
    @Environment(Clerk.self) private var clerk
    @Query(sort: \InvestmentRecord.investedAt, order: .reverse)
    private var investments: [InvestmentRecord]
    @State private var showAnalysis = false

    private var totalInvested: Double { investments.reduce(0) { $0 + $1.amountUSD } }
    private var totalCurrent: Double { investments.reduce(0) { $0 + $1.currentValueUSD } }
    private var totalReturn: Double { totalCurrent - totalInvested }
    private var totalReturnPercent: Double { totalInvested > 0 ? totalReturn / totalInvested * 100 : 0 }

    private var upcomingMaturities: [InvestmentRecord] {
        investments
            .filter { !$0.isMatured }
            .sorted { $0.bondMaturityDate < $1.bondMaturityDate }
    }

    private var greeting: String {
        if let first = clerk.user?.firstName, !first.isEmpty {
            return "Hola, \(first) 👋"
        }
        return "Mi portafolio"
    }

    var body: some View {
        NavigationStack {
            Group {
                if investments.isEmpty {
                    emptyState
                } else {
                    portfolioContent
                }
            }
            .navigationTitle(greeting)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            showAnalysis = true
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "sparkles")
                                    .font(.subheadline)
                                Text("Análisis IA")
                                    .font(.subheadline.bold())
                            }
                            .foregroundStyle(Color.bondiGreen)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.bondiGreen.opacity(0.12))
                            .clipShape(Capsule())
                        }

                        UserButton()
                            .environment(\.clerkTheme, .bondi)
                    }
                }
            }
            .sheet(isPresented: $showAnalysis) {
                PortfolioAnalysisView(investments: investments)
            }
        }
    }

    // MARK: Empty state

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Sin inversiones aún", systemImage: "chart.pie")
        } description: {
            Text("Explorá el catálogo y realizá tu primera inversión desde $5.")
        }
    }

    // MARK: Portfolio content

    private var portfolioContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                balanceCard
                    .padding(.horizontal)

                SectionHeader(title: "Mis inversiones")
                VStack(spacing: 10) {
                    ForEach(investments) { record in
                        InvestmentRow(record: record)
                    }
                }
                .padding(.horizontal)

                if !upcomingMaturities.isEmpty {
                    SectionHeader(title: "Próximos vencimientos")
                    VStack(spacing: 10) {
                        ForEach(upcomingMaturities) { record in
                            MaturityRow(record: record)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: Balance card

    private var balanceCard: some View {
        VStack(spacing: 8) {
            Text("Valor total")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))

            Text(totalCurrent, format: .currency(code: "USD"))
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: 4) {
                Image(systemName: totalReturn >= 0 ? "arrow.up.right" : "arrow.down.right")
                Text(totalReturn, format: .currency(code: "USD"))
                Text("(\(totalReturnPercent, specifier: "%.2f")%)")
            }
            .font(.subheadline)
            .foregroundStyle(totalReturn >= 0 ? Color.bondiGreen : Color.bondiRed)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.bondiNavy)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Subviews

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
    let record: InvestmentRecord

    var body: some View {
        HStack(spacing: 12) {
            Text(record.bondCountryFlag).font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.bondName).font(.subheadline.bold())
                Text("Invertido: \(record.amountUSD, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(record.currentValueUSD, format: .currency(code: "USD"))
                    .font(.subheadline.bold())
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up.right").font(.caption2)
                    Text("\(record.returnPercent, specifier: "%.2f")%").font(.caption)
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
    let record: InvestmentRecord

    var body: some View {
        HStack(spacing: 12) {
            Text(record.bondCountryFlag).font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.bondName).font(.subheadline.bold())
                Text(record.bondMaturityDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(record.expectedReturnAtMaturity, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .foregroundStyle(Color.bondiGreen)
                Text("\(record.monthsRemaining)m restantes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.bondiCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
