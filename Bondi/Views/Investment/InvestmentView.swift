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
                        .font(.bondiSubheadline.weight(.medium))
                        .foregroundStyle(Color.bondiGreenLight)
                    }
                }
            }
        }
    }

    private var amountView: some View {
        VStack(spacing: 24) {
            HStack {
                Text(bond.countryFlag).font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(bond.name).font(.bondiHeadline).foregroundStyle(Color.bondiNavy)
                    Text("\(String(format: "%.1f", bond.yieldAnnual))% anual · \(bond.monthsToMaturity) meses")
                        .font(.bondiCaption).foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(Color.bondiCardLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.18), radius: 10, y: 4)

            HStack(spacing: 8) {
                ForEach([5, 10, 25, 50, 100], id: \.self) { preset in
                    let selected = amount == Double(preset)
                    Button("$\(preset)") { amount = Double(preset) }
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

            VStack(spacing: 2) {
                Text("$\(Int(amount))")
                    .font(.bondiNumericLarge)
                    .foregroundStyle(Color.bondiNavy)
                    .monospacedDigit()
                Text("USD")
                    .foregroundStyle(.secondary)
                    .font(.bondiSubheadline.weight(.semibold))
                    .tracking(2)
            }
            .padding(.vertical, 20)

            Slider(value: $amount, in: 5...500, step: 5)
                .tint(Color.bondiGreen)

            HStack {
                Text("Recibirás en \(bond.monthsToMaturity) meses:")
                    .font(.bondiSubheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("$\(expectedReturn, specifier: "%.2f")")
                    .font(.bondiNumeric)
                    .foregroundStyle(Color.bondiGreen)
            }
            .padding()
            .background(Color.bondiCardLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.18), radius: 10, y: 4)

            Spacer()

            Button("Revisar inversión") { step = .review }
                .buttonStyle(BondiPrimaryButtonStyle(icon: "arrow.right"))
        }
        .padding()
    }

    private var reviewView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text(bond.countryFlag).font(.title2)
                        Text(bond.name).font(.bondiHeadline).foregroundStyle(Color.bondiNavy)
                        Spacer()
                    }

                    Divider().opacity(0.4)

                    VStack(spacing: 12) {
                        SummaryRow(label: "Monto invertido", value: "$\(String(format: "%.2f", amount))")
                        SummaryRow(label: "Fee Bondi (1%)", value: "- $\(String(format: "%.2f", fee))", isNegative: true)
                        Divider().opacity(0.4)
                        SummaryRow(label: "Total debitado", value: "$\(String(format: "%.2f", totalDebited))", isBold: true)
                    }
                    .padding()
                    .background(Color.bondiCardLight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.18), radius: 10, y: 4)

                    VStack(spacing: 10) {
                        HStack {
                            Text("Rendimiento esperado")
                                .font(.bondiSubheadline)
                                .foregroundStyle(Color.bondiNavy)
                            Spacer()
                            Text("+ $\(String(format: "%.2f", expectedReturn - amount))")
                                .font(.bondiSubheadline.weight(.semibold))
                                .foregroundStyle(Color.bondiGreen)
                        }
                        HStack {
                            Text("Recibirás:")
                                .font(.bondiHeadline)
                                .foregroundStyle(Color.bondiNavy)
                            Spacer()
                            Text("$\(String(format: "%.2f", expectedReturn))")
                                .font(.bondiNumericSmall)
                                .foregroundStyle(Color.bondiGreen)
                        }
                        HStack {
                            Text("Fecha estimada:")
                                .font(.bondiSubheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(bond.maturityDate, style: .date)
                                .font(.bondiSubheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.bondiCardLight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.18), radius: 10, y: 4)
                }
                .padding()
            }

            Button(isProcessing ? "Procesando..." : "Confirmar con Face ID") {
                confirmWithBiometrics()
            }
            .buttonStyle(BondiPrimaryButtonStyle(icon: "faceid"))
            .disabled(isProcessing)
            .opacity(isProcessing ? 0.7 : 1)
            .padding()
        }
    }

    private var successView: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.bondiGreen)
                .shadow(color: Color.bondiGreen.opacity(0.3), radius: 20, y: 10)

            VStack(spacing: 8) {
                Text("¡Inversión exitosa!")
                    .font(.bondiTitle)
                    .foregroundStyle(Color.bondiNavy)
                Text("Invertiste $\(String(format: "%.2f", amount)) en \(bond.name)")
                    .font(.bondiBody)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                Text("Recibirás")
                    .font(.bondiSubheadline)
                    .foregroundStyle(.secondary)
                Text("$\(String(format: "%.2f", expectedReturn))")
                    .font(.bondiNumericLarge)
                    .foregroundStyle(Color.bondiGreen)
                    .monospacedDigit()
                Text(bond.maturityDate, style: .date)
                    .font(.bondiSubheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Ver mi portafolio") { dismiss() }
                .buttonStyle(BondiPrimaryButtonStyle(icon: "chart.pie.fill"))
                .padding()
        }
    }

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
                .font(.bondiSubheadline.weight(isBold ? .semibold : .regular))
                .foregroundStyle(Color.bondiNavy)
            Spacer()
            Text(value)
                .font(isBold ? .bondiNumericSmall : .bondiSubheadline)
                .foregroundStyle(isNegative ? .secondary : Color.bondiNavy)
        }
    }
}
