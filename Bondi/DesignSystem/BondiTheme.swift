import SwiftUI

extension Color {
    
    static let bondiNavy = Color(hex: "ECFDF5")
    
    static let bondiCardLight = Color(hex: "064E3B")
    static let bondiCard = Color(hex: "064E3B")
    
    static let bondiSoftBackground = Color(hex: "022C22")
    static let bondiSoftBackgroundDarker = Color(hex: "022C22")
    
    static let bondiGreen = Color(hex: "4ADE80")
    static let bondiGreenLight = Color(hex: "86EFAC")
    static let bondiAmber = Color(hex: "F59E0B")
    static let bondiRed = Color(hex: "EF4444")
    static let bondiBlueLight = Color(hex: "3B82F6")
    
    static let bondiCardDark = Color(hex: "022C22")
    static let bondiCardMedium = Color(hex: "064E3B")
    static let bondiMeshBase = Color(hex: "022C22")
    static let bondiMeshDark1 = Color(hex: "064E3B")
    static let bondiMeshDark2 = Color(hex: "047857")
    static let bondiMeshDark3 = Color(hex: "065F46")
}

extension Font {
    static let bondiLargeTitle = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let bondiTitle = Font.system(.title, design: .serif).weight(.bold)
    static let bondiTitle2 = Font.system(.title2, design: .serif).weight(.semibold)
    static let bondiTitle3 = Font.system(.title3, design: .serif).weight(.semibold)

    static let bondiHeadline = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bondiSubheadline = Font.system(.subheadline, design: .rounded)
    static let bondiBody = Font.system(.body, design: .rounded)
    static let bondiCallout = Font.system(.callout, design: .rounded)
    static let bondiCaption = Font.system(.caption, design: .rounded)
    static let bondiCaption2 = Font.system(.caption2, design: .rounded)
    static let bondiButton = Font.system(.headline, design: .rounded).weight(.semibold)

    static let bondiNumeric = Font.system(.title2, design: .serif).weight(.bold)
    static let bondiNumericLarge = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let bondiNumericSmall = Font.system(.headline, design: .serif).weight(.semibold)
}


struct BondiPrimaryButtonStyle: ButtonStyle {
    var icon: String? = nil
    var fullWidth: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.label
                .font(.bondiButton)
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .foregroundStyle(Color.bondiSoftBackground)
        .frame(maxWidth: fullWidth ? .infinity : nil)
        .padding(.vertical, 16)
        .padding(.horizontal, fullWidth ? 0 : 22)
        .background(
            LinearGradient(
                colors: [Color.bondiGreenLight, Color.bondiGreen],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.bondiGreenLight.opacity(0.45), lineWidth: 0.8)
        )
        .shadow(color: Color.bondiGreen.opacity(0.32), radius: 18, y: 8)
        .scaleEffect(configuration.isPressed ? 0.98 : 1)
        .opacity(configuration.isPressed ? 0.92 : 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct BondiSecondaryButtonStyle: ButtonStyle {
    var fullWidth: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bondiButton)
            .foregroundStyle(Color.bondiGreenLight)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, 14)
            .padding(.horizontal, fullWidth ? 0 : 22)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.bondiCardLight.opacity(0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.bondiGreen.opacity(0.45), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct BondiChipButtonStyle: ButtonStyle {
    var isSelected: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bondiSubheadline.weight(.semibold))
            .foregroundStyle(isSelected ? Color.bondiSoftBackground : Color.bondiGreenLight)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.bondiGreen : Color.bondiCardLight.opacity(0.6))
            )
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.clear : Color.bondiGreen.opacity(0.35),
                        lineWidth: 1
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        if hex.count == 6 { hex = "FF" + hex }
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            .sRGB,
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255,
            opacity: Double((int >> 24) & 0xFF) / 255
        )
    }
}
