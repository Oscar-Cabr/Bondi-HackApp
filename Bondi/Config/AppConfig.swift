import Foundation

enum AppConfig {
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
