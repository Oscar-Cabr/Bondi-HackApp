//
//  BondiApp.swift
//  Bondi
//
//  Created by Andrés Rodríguez Montes de Oca on 20/04/26.
//

import ClerkKit
import ClerkKitUI
import SwiftUI

@main
struct BondiApp: App {
    init() {
        Clerk.configure(publishableKey: AppConfig.clerkPublishableKey)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .prefetchClerkImages()
                .environment(Clerk.shared)
        }
    }
}
