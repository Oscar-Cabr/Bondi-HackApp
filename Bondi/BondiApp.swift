
import ClerkKit
import ClerkKitUI
import SwiftData
import SwiftUI

@main
struct BondiApp: App {
    private let container: ModelContainer = {
        let schema = Schema([InvestmentRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("SwiftData: no se pudo crear el ModelContainer — \(error)")
        }
    }()

    init() {
        Clerk.configure(publishableKey: AppConfig.clerkPublishableKey)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .prefetchClerkImages()
                .environment(Clerk.shared)
                .modelContainer(container)
        }
    }
}
