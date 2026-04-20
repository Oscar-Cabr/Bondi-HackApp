import SwiftUI

extension Color {
    static let bondiNavy = Color(hex: "1A3A5C")
    static let bondiGreen = Color(hex: "4ADE80")
    static let bondiAmber = Color(hex: "F59E0B")
    static let bondiRed = Color(hex: "EF4444")
    static let bondiCard = Color(.secondarySystemBackground)
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
