import LocalAuthentication
import SwiftData
import SwiftUI

struct InvestmentView: View {
    let bond: Bond
    @State private var amount: Double
    @State private var step: Step = .amount
    @State private var isProcessing = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    init(bond: Bond, initialAmount: Double) {
        self.bond = bond
        _amount = State(initialValue: initialAmount)
    }

    enum Step { case amount, review, success }

    private var fee: Double { amount * 0.01 }
    private var totalDebited: Double { amount + fee }
    private var expectedReturn: Double { bond.projectedReturn(for: amount) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bondiSoftBackground.ignoresSafeArea()
                
                Group {
                    switch step {
                    case .amount: amountView
                    case .review: reviewView
                    case .success: successView
                    }
                }
            }
            .navigationTitle(step == .amount ? "¿Cuánto invertir?" : step == .review ? "Confirmar" : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if step != .success {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { dismiss() }
                            .foregroundStyle(Color.bondiNavy)
                    }
                }
            }
        }
    }

    // MARK: Amount step
    private var amountView: some View {
        VStack(spacing: 24) {
            // Bond summary
            HStack {
                Text(bond.countryFlag).font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(bond.name).font(.headline).foregroundStyle(Color.bondiNavy)
                    Text("\(String(format: "%.1f", bond.yieldAnnual))% anual · \(bond.monthsToMaturity) meses")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(Color.bondiCardLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)

            // Preset amounts
            HStack(spacing: 6) {
                ForEach([5, 10, 25, 50, 100], id: \.self) { preset in
                    Button("$\(preset)") { amount = Double(preset) }
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(amount == Double(preset) ? Color.bondiNavy : Color.bondiCardLight)
                        .foregroundStyle(amount == Double(preset) ? .white : Color.bondiNavy)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.bondiNavy.opacity(0.04), radius: 4, y: 2)
                }
            }

            // Big amount display
            VStack(spacing: 2) {
                Text("$\(Int(amount))")
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.bondiNavy)
                Text("USD")
                    .foregroundStyle(.secondary)
                    .font(.headline)
            }
            .padding(.vertical, 20)

            Slider(value: $amount, in: 5...500, step: 5)
                .tint(Color.bondiGreen)

            // Projected return
            HStack {
                Text("Recibirás en \(bond.monthsToMaturity) meses:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("$\(expectedReturn, specifier: "%.2f")")
                    .font(.title3.bold())
                    .foregroundStyle(Color.bondiGreen)
            }
            .padding()
            .background(Color.bondiCardLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)

            Spacer()

            Button(action: { step = .review }) {
                Text("Revisar inversión")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
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
        }
        .padding()
    }

    // MARK: Review step
    private var reviewView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text(bond.countryFlag).font(.title2)
                        Text(bond.name).font(.headline).foregroundStyle(Color.bondiNavy)
                        Spacer()
                    }

                    Divider()

                    VStack(spacing: 12) {
                        SummaryRow(label: "Monto invertido", value: "$\(String(format: "%.2f", amount))")
                        SummaryRow(label: "Fee Bondi (1%)", value: "- $\(String(format: "%.2f", fee))", isNegative: true)
                        Divider().opacity(0.5)
                        SummaryRow(label: "Total debitado", value: "$\(String(format: "%.2f", totalDebited))", isBold: true)
                    }
                    .padding()
                    .background(Color.bondiCardLight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)

                    VStack(spacing: 10) {
                        HStack {
                            Text("Rendimiento esperado").foregroundStyle(Color.bondiNavy)
                            Spacer()
                            Text("+ $\(String(format: "%.2f", expectedReturn - amount))")
                                .foregroundStyle(Color.bondiGreen)
                                .fontWeight(.semibold)
                        }
                        HStack {
                            Text("Recibirás:").font(.headline).foregroundStyle(Color.bondiNavy)
                            Spacer()
                            Text("$\(String(format: "%.2f", expectedReturn))")
                                .font(.headline)
                                .foregroundStyle(Color.bondiGreen)
                        }
                        HStack {
                            Text("Fecha estimada:").foregroundStyle(.secondary)
                            Spacer()
                            Text(bond.maturityDate, style: .date).foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.bondiCardLight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.bondiNavy.opacity(0.03), radius: 10, y: 4)
                }
                .padding()
            }

            Button(action: confirmWithBiometrics) {
                HStack {
                    Image(systemName: "faceid")
                    Text(isProcessing ? "Procesando..." : "Confirmar con Face ID")
                }
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(Color.bondiNavy)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    ZStack {
                        if isProcessing {
                            Color.bondiGreen.opacity(0.5)
                        } else {
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
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: isProcessing ? .clear : Color.bondiGreen.opacity(0.45), radius: 20, y: 10)
            }
            .disabled(isProcessing)
            .padding()
        }
    }

    // MARK: Success step
    private var successView: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.bondiGreen)
                .shadow(color: Color.bondiGreen.opacity(0.3), radius: 20, y: 10)

            VStack(spacing: 8) {
                Text("¡Inversión exitosa!")
                    .font(.title.bold())
                    .foregroundStyle(Color.bondiNavy)
                Text("Invertiste $\(String(format: "%.2f", amount)) en \(bond.name)")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                Text("Recibirás").foregroundStyle(.secondary)
                Text("$\(String(format: "%.2f", expectedReturn))")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.bondiGreen)
                Text(bond.maturityDate, style: .date).foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: { dismiss() }) {
                Text("Ver mi portafolio")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
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
            .padding()
        }
    }

    // MARK: Biometrics
    private func confirmWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isProcessing = true
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Confirma tu inversión en \(bond.name)"
            ) { success, _ in
                DispatchQueue.main.async {
                    isProcessing = false
                    if success { saveAndConfirm() }
                }
            }
        } else {
            isProcessing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isProcessing = false
                saveAndConfirm()
            }
        }
    }

    private func saveAndConfirm() {
        let record = InvestmentRecord(
            bond: bond,
            amountUSD: amount,
            feeUSD: fee
        )
        modelContext.insert(record)
        try? modelContext.save()
        step = .success
    }
}

private struct SummaryRow: View {
    let label: String
    let value: String
    var isNegative: Bool = false
    var isBold: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(isBold ? .semibold : .regular)
                .foregroundStyle(Color.bondiNavy)
            Spacer()
            Text(value)
                .fontWeight(isBold ? .semibold : .regular)
                .foregroundStyle(isNegative ? .secondary : Color.bondiNavy)
        }
    }
}
