import ClerkKit
import ClerkKitUI
import SwiftUI

struct AccountView: View {
    @Environment(Clerk.self) private var clerk
    @State private var showAddFunds = false

    private var userName: String {
        clerk.user?.firstName ?? "Usuario"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bondiSoftBackgroundDarker.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        balanceCard
                            .padding(.horizontal)

                        addFundsButton
                            .padding(.horizontal)

                        bankingDetailsSection
                            .padding(.horizontal)

                        poweredBySection
                            .padding(.horizontal)

                        Spacer(minLength: 32)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Mi cuenta")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    UserButton()
                        .environment(\.clerkTheme, .bondi)
                }
            }
            .sheet(isPresented: $showAddFunds) {
                AddFundsSheet()
            }
        }
        .preferredColorScheme(.dark)
    }

    private var balanceCard: some View {
        VStack(spacing: 8) {
            Text("Saldo disponible")
                .font(.bondiCaption.weight(.semibold))
                .tracking(1.0)
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.7))

            Text(0.0, format: .currency(code: "MXN"))
                .font(.bondiNumericLarge)
                .foregroundStyle(.white)
                .monospacedDigit()

            Text("≈ \(0.0, specifier: "%.2f") USD")
                .font(.bondiCaption)
                .foregroundStyle(.white.opacity(0.75))
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

    private var addFundsButton: some View {
        Button("Depositar saldo") {
            showAddFunds = true
        }
        .buttonStyle(BondiPrimaryButtonStyle(icon: "plus.circle.fill"))
    }

    private var bankingDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Datos bancarios")
                .font(.bondiTitle3)
                .foregroundStyle(Color.bondiNavy)
                .padding(.bottom, 2)

            BankingDetailRow(
                icon: "building.columns.fill",
                label: "Banco",
                value: "STP (Sistema de Transferencias y Pagos)"
            )

            Divider().opacity(0.5)

            BankingDetailRow(
                icon: "arrow.left.arrow.right",
                label: "Red de transferencia",
                value: "SPEI"
            )

            Divider().opacity(0.5)

            BankingDetailRow(
                icon: "number.square.fill",
                label: "CLABE interbancaria",
                value: "646180157000000001",
                copyable: true
            )

            Divider().opacity(0.5)

            BankingDetailRow(
                icon: "globe",
                label: "SWIFT / BIC",
                value: "STPEMXM1",
                copyable: true
            )

            Divider().opacity(0.5)

            BankingDetailRow(
                icon: "person.fill",
                label: "Beneficiario",
                value: userName
            )
        }
        .padding()
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.bondiNavy.opacity(0.04), radius: 10, y: 4)
    }

    private var poweredBySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .foregroundStyle(Color.bondiGreen)
                    .font(.title3)
                Text("Infraestructura y seguridad")
                    .font(.bondiTitle3)
                    .foregroundStyle(Color.bondiNavy)
            }

            VStack(alignment: .leading, spacing: 10) {
                BulletItem(
                    icon: "arrow.triangle.2.circlepath",
                    text: "Conversión MXN ↔ cripto vía **Etherfuse**, sin salir de la app."
                )
                BulletItem(
                    icon: "checkmark.seal.fill",
                    text: "**KYC y cuenta bancaria** verificados por Etherfuse de forma segura."
                )
                BulletItem(
                    icon: "building.columns",
                    text: "Depósitos por **SPEI en tiempo real** con CLABE única, procesados por STP."
                )
                BulletItem(
                    icon: "cube.transparent",
                    text: "Activos en la red **Base** (L2 de Ethereum): abierta, auditada y verificable."
                )
                BulletItem(
                    icon: "lock.shield.fill",
                    text: "**Sin custodia**: tus bonos viven en tu wallet, no en servidores de Bondi."
                )
                BulletItem(
                    icon: "chart.line.uptrend.xyaxis",
                    text: "Stablebonds = **deuda gubernamental real** (CETES, T-Bills) tokenizada 1:1."
                )
            }
        }
        .padding()
        .background(Color.bondiCardLight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.bondiNavy.opacity(0.04), radius: 10, y: 4)
    }
}

private struct AddFundsSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bondiSoftBackgroundDarker.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Transferí desde cualquier banco mexicano usando tu CLABE única.")
                            .font(.bondiSubheadline)
                            .foregroundStyle(Color.bondiNavy.opacity(0.7))

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instrucciones SPEI")
                                .font(.bondiTitle3)
                                .foregroundStyle(Color.bondiNavy)

                            InstructionStep(number: 1, text: "Abrí tu app bancaria o portal de banca en línea.")
                            InstructionStep(number: 2, text: "Seleccioná \"Transferencia SPEI\" o \"Pago a terceros\".")
                            InstructionStep(number: 3, text: "Ingresá la CLABE interbancaria de tu cuenta Bondi.")
                            InstructionStep(number: 4, text: "Elegí el monto a depositar (mínimo $100 MXN).")
                            InstructionStep(number: 5, text: "Confirmá la transferencia. El saldo se refleja en segundos.")
                        }
                        .padding()
                        .background(Color.bondiCardLight)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.bondiNavy.opacity(0.04), radius: 10, y: 4)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tu CLABE")
                                .font(.bondiTitle3)
                                .foregroundStyle(Color.bondiNavy)

                            BankingDetailRow(
                                icon: "number.square.fill",
                                label: "CLABE interbancaria",
                                value: "646180157000000001",
                                copyable: true
                            )

                            BankingDetailRow(
                                icon: "building.columns.fill",
                                label: "Banco receptor",
                                value: "STP (Sistema de Transferencias y Pagos)"
                            )
                        }
                        .padding()
                        .background(Color.bondiCardLight)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.bondiNavy.opacity(0.04), radius: 10, y: 4)

                        Text("Los depósitos via SPEI son procesados por Etherfuse y acreditados en tu cuenta Bondi en tiempo real.")
                            .font(.bondiCaption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Depositar saldo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                        .font(.bondiSubheadline.weight(.medium))
                        .foregroundStyle(Color.bondiGreenLight)
                }
            }
        }
    }
}

private struct BankingDetailRow: View {
    let icon: String
    let label: String
    let value: String
    var copyable: Bool = false

    @State private var copied = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.bondiNavy)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.bondiCaption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.bondiSubheadline.weight(.semibold))
                    .foregroundStyle(Color.bondiNavy)
            }

            Spacer()

            if copyable {
                Button {
                    UIPasteboard.general.string = value
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copied = false
                    }
                } label: {
                    Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                        .foregroundStyle(copied ? Color.bondiGreen : Color.bondiNavy.opacity(0.5))
                        .font(.subheadline)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct BulletItem: View {
    let icon: String
    let text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(Color.bondiGreen)
                .font(.subheadline)
                .frame(width: 22, alignment: .center)
                .padding(.top, 1)
            Text(text)
                .font(.bondiSubheadline)
                .foregroundStyle(Color.bondiNavy)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct InstructionStep: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.bondiCaption.weight(.bold))
                .foregroundStyle(Color.bondiSoftBackground)
                .frame(width: 22, height: 22)
                .background(Color.bondiGreen)
                .clipShape(Circle())
            Text(text)
                .font(.bondiSubheadline)
                .foregroundStyle(Color.bondiNavy)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    AccountView()
        .environment(Clerk.shared)
}
