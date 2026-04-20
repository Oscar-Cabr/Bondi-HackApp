import SwiftUI

struct BondDetailView: View {
    let bond: Bond
    @State private var investmentAmount: Double = 50
    @State private var showInvestmentSheet = false

    private var projectedReturn: Double {
        bond.projectedReturn(for: investmentAmount)
    }

    private var aiExplanation: String {
        "El gobierno de \(bond.country) promete devolverte tu dinero en \(bond.monthsToMaturity) meses con un extra de \(String(format: "%.1f", bond.yieldAnnual))% anual. Es como prestarle dinero a un país: rendimiento predecible y sin necesidad de ser experto en finanzas. \(bond.issuerDescription)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 16) {
                    Text(bond.countryFlag)
                        .font(.system(size: 52))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bond.name)
                            .font(.title2.bold())
                        Text(bond.country)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                // Stats row
                HStack(spacing: 12) {
                    StatCard(label: "Rendimiento", value: "\(String(format: "%.1f", bond.yieldAnnual))%")
                    StatCard(label: "Plazo", value: "\(bond.monthsToMaturity)m")
                    StatCard(label: "Riesgo", value: bond.riskLevel.rawValue)
                }

                Divider()

                // AI Explanation
                VStack(alignment: .leading, spacing: 10) {
                    Label("¿Qué significa esto?", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundStyle(Color.bondiNavy)

                    Text(aiExplanation)
                        .font(.body)
                        .padding()
                        .background(Color.bondiNavy.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Divider()

                // Simulator
                VStack(alignment: .leading, spacing: 14) {
                    Text("Simulador")
                        .font(.headline)

                    // Preset amounts
                    HStack(spacing: 6) {
                        ForEach([5, 10, 25, 50, 100], id: \.self) { preset in
                            Button("$\(preset)") {
                                investmentAmount = Double(preset)
                            }
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(investmentAmount == Double(preset) ? Color.bondiNavy : Color.bondiCard)
                            .foregroundStyle(investmentAmount == Double(preset) ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    Slider(value: $investmentAmount, in: 5...500, step: 5)
                        .tint(Color.bondiNavy)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Si invierto $\(Int(investmentAmount))")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Text("En \(bond.monthsToMaturity) meses recibiré:")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("$\(projectedReturn, specifier: "%.2f")")
                            .font(.title3.bold())
                            .foregroundStyle(Color.bondiGreen)
                    }
                    .padding()
                    .background(Color.bondiCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // CTA
                Button(action: { showInvestmentSheet = true }) {
                    Label("Invertir ahora", systemImage: "arrow.up.circle.fill")
                        .font(.headline)
                        .foregroundStyle(Color.bondiNavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.bondiGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showInvestmentSheet) {
            InvestmentView(bond: bond, initialAmount: investmentAmount)
        }
    }
}

private struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundStyle(Color.bondiNavy)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.bondiCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
