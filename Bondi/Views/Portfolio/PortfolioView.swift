import ClerkKit
import ClerkKitUI
import SwiftData
import SwiftUI

struct PortfolioView: View {
    @Environment(Clerk.self) private var clerk
    @Query(sort: \InvestmentRecord.investedAt, order: .reverse)
    private var investments: [InvestmentRecord]
    @AppStorage("cashBalanceUSD") private var cashBalanceUSD: Double = 500
    @State private var showAnalysis = false

    private var totalInvested: Double { investments.reduce(0) { $0 + $1.amountUSD } }
    private var totalCurrent: Double { investments.reduce(0) { $0 + $1.currentValueUSD } }
    private var totalReturn: Double { totalCurrent - totalInvested }
    private var totalReturnPercent: Double { totalInvested > 0 ? totalReturn / totalInvested * 100 : 0 }
    private var totalEquity: Double { totalCurrent + cashBalanceUSD }

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
            ZStack {
                Color.bondiSoftBackground.ignoresSafeArea()
                
                Group {
                    if investments.isEmpty {
                        emptyState
                    } else {
                        portfolioContent
                    }
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
                                    .font(.bondiSubheadline)
                                Text("Análisis IA")
                                    .font(.bondiSubheadline.weight(.semibold))
                            }
                            .foregroundStyle(Color.bondiGreenLight)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.bondiCardLight.opacity(0.6))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.bondiGreen.opacity(0.4), lineWidth: 1)
                            )
                        }

                        UserButton()
                            .environment(\.clerkTheme, .bondi)
                    }
                }
            }
            .sheet(isPresented: $showAnalysis) {
                PortfolioAnalysisView(
                    investments: investments,
                    cashBalanceUSD: cashBalanceUSD
                )
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Empty state
    private var emptyState: some View {
        ContentUnavailableView {
            Label("Sin inversiones aún", systemImage: "chart.pie")
                .foregroundStyle(Color.bondiNavy)
        } description: {
            Text("Explorá el catálogo y realizá tu primera inversión desde $5.")
                .foregroundStyle(Color.bondiNavy.opacity(0.7))
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
            Text("Patrimonio total")
                .font(.bondiCaption.weight(.semibold))
                .tracking(1.0)
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.7))

            Text(totalEquity, format: .currency(code: "USD"))
                .font(.bondiNumericLarge)
                .foregroundStyle(.white)
                .monospacedDigit()

            HStack(spacing: 4) {
                Image(systemName: totalReturn >= 0 ? "arrow.up.right" : "arrow.down.right")
                Text(totalReturn, format: .currency(code: "USD"))
                Text("(\(totalReturnPercent, specifier: "%.2f")%)")
            }
            .font(.bondiSubheadline.weight(.semibold))
            .foregroundStyle(totalReturn >= 0 ? Color.bondiGreen : Color.bondiRed)

            Divider()
                .overlay(Color.white.opacity(0.12))
                .padding(.vertical, 4)

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("En bonos")
                        .font(.bondiCaption)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(totalCurrent, format: .currency(code: "USD"))
                        .font(.bondiNumericSmall)
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Disponible")
                        .font(.bondiCaption)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(cashBalanceUSD, format: .currency(code: "USD"))
                        .font(.bondiNumericSmall)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color.bondiCardMedium, Color.bondiSoftBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.bondiGreen.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.35), radius: 18, y: 8)
    }
}

// MARK: - Subviews
private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.bondiTitle3)
            .foregroundStyle(Color.bondiNavy)
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
                Text(record.bondName)
                    .font(.bondiHeadline)
                    .foregroundStyle(Color.bondiNavy)
                Text("Invertido: \(record.amountUSD, format: .currency(code: "USD"))")
                    .font(.bondiCaption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(record.currentValueUSD, format: .currency(code: "USD"))
                    .font(.bondiNumericSmall)
                    .foregroundStyle(Color.bondiNavy)
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up.right").font(.caption2)
                    Text("\(record.returnPercent, specifier: "%.2f")%")
                        .font(.bondiCaption.weight(.semibold))
                }
                .foregroundStyle(Color.bondiGreen)
            }
        }
        .padding()
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.18), radius: 8, y: 3)
    }
}

private struct MaturityRow: View {
    let record: InvestmentRecord

    var body: some View {
        HStack(spacing: 12) {
            Text(record.bondCountryFlag).font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.bondName)
                    .font(.bondiHeadline)
                    .foregroundStyle(Color.bondiNavy)
                Text(record.bondMaturityDate, style: .date)
                    .font(.bondiCaption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(record.expectedReturnAtMaturity, format: .currency(code: "USD"))
                    .font(.bondiNumericSmall)
                    .foregroundStyle(Color.bondiGreen)
                Text("\(record.monthsRemaining)m restantes")
                    .font(.bondiCaption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.18), radius: 8, y: 3)
    }
}
