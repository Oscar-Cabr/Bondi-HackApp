import ClerkKitUI
import SwiftUI

extension ClerkTheme {
    /// Bondi brand theme applied to all Clerk prebuilt views (AuthView, UserButton, etc.).
    static let bondi = ClerkTheme(
        colors: .init(
            primary: .bondiGreen,
            danger: .bondiRed,
            success: .bondiGreen,
            warning: .bondiAmber,
            primaryForeground: .bondiNavy
        ),
        design: .init(
            borderRadius: 12.0
        )
    )
}
