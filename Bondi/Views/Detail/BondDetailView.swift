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
        ZStack {
            Color.bondiSoftBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    bondHeader
                    statsRow
                    Divider().opacity(0.5)
                    aiExplanationSection
                    Divider().opacity(0.5)
                    simulatorSection

                    Button(action: { showInvestmentSheet = true }) {
                        HStack(spacing: 8) {
                            Text("Invertir ahora")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                            Image(systemName: "arrow.up.circle.fill")
                        }
                        .foregroundStyle(Color.bondiNavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [Color.bondiGreen, Color.bondiGreenLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                LinearGradient(
                                    colors: [.white.opacity(0.45), .clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color.bondiGreen.opacity(0.45), radius: 20, y: 10)
                    }
                    .padding(.top, 12)
                }
                .padding()
            }
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
                    .foregroundStyle(Color.bondiNavy)
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
                .foregroundStyle(Color.bondiNavy)

            HStack(spacing: 6) {
                ForEach([5, 10, 25, 50, 100], id: \.self) { preset in
                    Button("$\(preset)") {
                        investmentAmount = Double(preset)
                    }
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(investmentAmount == Double(preset) ? Color.bondiNavy : Color.bondiCardLight)
                    .foregroundStyle(investmentAmount == Double(preset) ? .white : Color.bondiNavy)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.bondiNavy.opacity(0.04), radius: 4, y: 2)
                }
            }

            Slider(value: $investmentAmount, in: 5...500, step: 5)
                .tint(Color.bondiGreen)

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
                    .font(.title2.bold())
                    .foregroundStyle(Color.bondiGreen)
            }
            .padding()
            .background(Color.bondiCardLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)
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
            (Text(text) + cursorText)
                .font(.callout)
                .foregroundStyle(Color.bondiNavy.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .animation(.none, value: text)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.bondiGreen.opacity(isStreaming ? 0.4 : 0.1), lineWidth: 1)
        )
        .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)
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
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.bondiNavy.opacity(0.03), radius: 5, y: 2)
    }
}
