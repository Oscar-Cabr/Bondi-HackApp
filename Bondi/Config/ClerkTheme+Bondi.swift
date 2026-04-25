import ClerkKitUI
import SwiftUI

extension ClerkTheme {
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
