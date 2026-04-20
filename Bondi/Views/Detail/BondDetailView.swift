import SwiftUI

struct BondDetailView: View {
    let bond: Bond

    @State private var investmentAmount: Double = 50
    @State private var showInvestmentSheet = false
    @State private var explainer = BondExplainerService()

    private var projectedReturn: Double {
        bond.projectedReturn(for: investmentAmount)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                bondHeader
                statsRow
                Divider()
                aiExplanationSection
                Divider()
                simulatorSection

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
        .task {
            await explainer.explain(bond: bond)
        }
        .onDisappear {
            explainer.reset()
        }
    }

    // MARK: - Header

    private var bondHeader: some View {
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
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(label: "Rendimiento", value: "\(String(format: "%.1f", bond.yieldAnnual))%")
            StatCard(label: "Plazo", value: "\(bond.monthsToMaturity)m")
            StatCard(label: "Riesgo", value: bond.riskLevel.rawValue)
        }
    }

    // MARK: - AI Explanation

    private var aiExplanationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            aiSectionHeader

            switch explainer.state {
            case .idle:
                EmptyView()

            case .failed:
                Text("No se pudo generar la explicación.")
                    .font(.callout)
                    .foregroundStyle(.secondary)

            case .streaming(let text):
                StreamingTextCard(text: text, isStreaming: true, isAI: false)

            case .ready(let text):
                StreamingTextCard(text: text, isStreaming: false, isAI: true)

            case .fallback(let text):
                StreamingTextCard(text: text, isStreaming: false, isAI: false)
            }
        }
    }

    private var aiSectionHeader: some View {
        HStack(spacing: 8) {
            Label("¿Qué significa esto?", systemImage: "sparkles")
                .font(.headline)
                .foregroundStyle(Color.bondiNavy)

            Spacer()

            if case .ready = explainer.state {
                HStack(spacing: 4) {
                    Image(systemName: "apple.intelligence")
                        .font(.caption2)
                    Text("Apple Intelligence")
                        .font(.caption2.bold())
                }
                .foregroundStyle(Color.bondiGreen)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.bondiGreen.opacity(0.12))
                .clipShape(Capsule())
            }
        }
    }

    // MARK: - Simulator

    private var simulatorSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Simulador")
                .font(.headline)

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
    }
}

// MARK: - Streaming Text Card

private struct StreamingTextCard: View {
    let text: String
    let isStreaming: Bool
    let isAI: Bool

    @State private var cursorVisible = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Text with blinking cursor appended while streaming
            (Text(text) + cursorText)
                .font(.callout)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .animation(.none, value: text)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bondiNavy.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.bondiNavy.opacity(isStreaming ? 0.25 : 0.12), lineWidth: 1)
        )
        .onAppear {
            guard isStreaming else { return }
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                cursorVisible = false
            }
        }
    }

    private var cursorText: Text {
        guard isStreaming else { return Text("") }
        return Text(cursorVisible ? "▋" : " ")
            .foregroundColor(Color.bondiGreen)
    }
}

// MARK: - Stat Card

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
