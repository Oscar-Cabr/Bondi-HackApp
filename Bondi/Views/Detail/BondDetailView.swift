import SwiftUI

struct BondDetailView: View {
    let bond: Bond

    @State private var investmentAmount: Double = 50
    @State private var showInvestmentSheet = false
    @State private var explainer = BondExplainerService()
    @State private var isAIExpanded = false

    private var projectedReturn: Double {
        bond.projectedReturn(for: investmentAmount)
    }

    var body: some View {
        ZStack {
            Color.bondiSoftBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    bondHeader

                    VStack(alignment: .leading, spacing: 20) {
                        statsRow
                        aiExplanationSection
                        Divider().opacity(0.5)
                        simulatorSection

                        Button("Invertir ahora") { showInvestmentSheet = true }
                            .buttonStyle(BondiPrimaryButtonStyle(icon: "arrow.up.circle.fill"))
                            .padding(.top, 12)
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(edges: .top)
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

    private var bondHeader: some View {
        Group {
            if let imageName = bond.heroImageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .frame(height: 280, alignment: .bottom)
                    .clipped()
                    .overlay(
                        Color.bondiGreen
                            .opacity(0.18)
                            .blendMode(.multiply)
                            .allowsHitTesting(false)
                    )
                    .overlay(alignment: .bottomLeading) {
                        HStack(spacing: 10) {
                            Text(bond.countryFlag)
                                .font(.system(size: 36))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(bond.name)
                                    .font(.bondiTitle3)
                                    .foregroundStyle(.white)
                                Text(bond.country)
                                    .font(.bondiSubheadline)
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [.black.opacity(0.7), .clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                    }
            } else {
                HStack(spacing: 16) {
                    Text(bond.countryFlag)
                        .font(.system(size: 52))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bond.name)
                            .font(.bondiTitle2)
                            .foregroundStyle(Color.bondiNavy)
                        Text(bond.country)
                            .font(.bondiSubheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(label: "Rendimiento", value: "\(String(format: "%.1f", bond.yieldAnnual))%")
            StatCard(label: "Plazo", value: "\(bond.monthsToMaturity)m")
            StatCard(label: "Riesgo", value: bond.riskLevel.rawValue)
        }
    }

    private var aiExplanationSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            aiSectionHeader

            if isAIExpanded {
                aiExplanationContent
                    .padding(.top, 12)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity
                    ))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.bondiGreen.opacity(0.22),
                            Color.bondiCardLight.opacity(0.85),
                            Color.bondiCardMedium.opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.bondiGreen.opacity(0.55), Color.bondiGreenLight.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.bondiGreen.opacity(0.18), radius: 14, y: 6)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isAIExpanded)
    }

    @ViewBuilder
    private var aiExplanationContent: some View {
        switch explainer.state {
        case .idle:
            EmptyView()

        case .failed:
            Text("No se pudo generar la explicación.")
                .font(.bondiCallout)
                .foregroundStyle(.secondary)

        case .streaming(let text):
            StreamingTextCard(text: text, isStreaming: true, isAI: false)

        case .ready(let text):
            StreamingTextCard(text: text, isStreaming: false, isAI: true)

        case .fallback(let text):
            StreamingTextCard(text: text, isStreaming: false, isAI: false)
        }
    }

    private var aiSectionHeader: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                isAIExpanded.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                Label("¿Qué significa esto?", systemImage: "sparkles")
                    .font(.bondiHeadline)
                    .foregroundStyle(Color.bondiNavy)

                Spacer()

                if case .ready = explainer.state {
                    HStack(spacing: 4) {
                        Image(systemName: "apple.intelligence")
                            .font(.caption2)
                        Text("Apple Intelligence")
                            .font(.bondiCaption2.weight(.bold))
                    }
                    .foregroundStyle(Color.bondiGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.bondiGreen.opacity(0.18))
                    .clipShape(Capsule())
                }

                Image(systemName: "chevron.down")
                    .font(.bondiSubheadline.weight(.semibold))
                    .foregroundStyle(Color.bondiNavy.opacity(0.6))
                    .rotationEffect(.degrees(isAIExpanded ? 0 : -90))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var simulatorSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Simulador")
                .font(.bondiHeadline)
                .foregroundStyle(Color.bondiNavy)

            HStack(spacing: 8) {
                ForEach([5, 10, 25, 50, 100], id: \.self) { preset in
                    let selected = investmentAmount == Double(preset)
                    Button("$\(preset)") {
                        investmentAmount = Double(preset)
                    }
                    .font(.bondiSubheadline.weight(.semibold))
                    .foregroundStyle(selected ? Color.bondiSoftBackground : Color.bondiGreenLight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(selected ? Color.bondiGreen : Color.bondiCardLight.opacity(0.55))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(selected ? Color.clear : Color.bondiGreen.opacity(0.3), lineWidth: 1)
                    )
                }
            }

            Slider(value: $investmentAmount, in: 5...500, step: 5)
                .tint(Color.bondiGreen)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Si invierto $\(Int(investmentAmount))")
                        .foregroundStyle(.secondary)
                        .font(.bondiSubheadline)
                    Text("En \(bond.monthsToMaturity) meses recibiré:")
                        .foregroundStyle(.secondary)
                        .font(.bondiSubheadline)
                }
                Spacer()
                Text("$\(projectedReturn, specifier: "%.2f")")
                    .font(.bondiNumeric)
                    .foregroundStyle(Color.bondiGreen)
            }
            .padding()
            .background(Color.bondiCardLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)
        }
    }
}

private struct StreamingTextCard: View {
    let text: String
    let isStreaming: Bool
    let isAI: Bool

    @State private var cursorVisible = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            (Text(text) + cursorText)
                .font(.bondiCallout)
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

private struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.bondiNumericSmall)
                .foregroundStyle(Color.bondiNavy)
            Text(label)
                .font(.bondiCaption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.bondiNavy.opacity(0.03), radius: 5, y: 2)
    }
}
