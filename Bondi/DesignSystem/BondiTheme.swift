import SwiftUI

extension Color {
    // MARK: - Dark Theme Overrides (Hijacking previous variables)
    
    // Originally a dark navy, this is now your "almost white green" for text
    static let bondiNavy = Color(hex: "ECFDF5")
    
    // Originally white/light, these are now your dark green boxes
    static let bondiCardLight = Color(hex: "064E3B")
    static let bondiCard = Color(hex: "064E3B")
    
    // Originally soft green, now a deep, almost-black green for the app root background
    static let bondiSoftBackground = Color(hex: "022C22")
    static let bondiSoftBackgroundDarker = Color(hex: "022C22")
    
    // MARK: - Accent Colors (Kept bright for contrast on dark backgrounds)
    static let bondiGreen = Color(hex: "4ADE80")
    static let bondiGreenLight = Color(hex: "86EFAC")
    static let bondiAmber = Color(hex: "F59E0B")
    static let bondiRed = Color(hex: "EF4444")
    static let bondiBlueLight = Color(hex: "3B82F6")
    
    // MARK: - Landing Page Mesh & Hero Card (Shifted to deep greens)
    static let bondiCardDark = Color(hex: "022C22")
    static let bondiCardMedium = Color(hex: "064E3B")
    static let bondiMeshBase = Color(hex: "022C22")
    static let bondiMeshDark1 = Color(hex: "064E3B")
    static let bondiMeshDark2 = Color(hex: "047857")
    static let bondiMeshDark3 = Color(hex: "065F46")
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
