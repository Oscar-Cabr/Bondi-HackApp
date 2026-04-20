import Foundation

enum AppConfig {
    /// Clerk Publishable Key read from Info.plist (key: `ClerkPublishableKey`).
    /// The key is safe to ship — it's public by design. Never include the Secret Key.
    static var clerkPublishableKey: String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "ClerkPublishableKey") as? String,
            !value.isEmpty
        else {
            fatalError(
                "Missing `ClerkPublishableKey` in Info.plist. " +
                "Add it with your pk_test_... or pk_live_... value."
            )
        }
        return value
    }
}
