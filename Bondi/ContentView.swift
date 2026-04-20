//
//  ContentView.swift
//  Bondi
//
//  Created by Andrés Rodríguez Montes de Oca on 20/04/26.
//

import ClerkKit
import ClerkKitUI
import SwiftUI

private enum AuthSheet: Identifiable {
    case signUp
    case signIn

    var id: Int {
        switch self {
        case .signUp: return 0
        case .signIn: return 1
        }
    }
}

struct ContentView: View {
    @Environment(Clerk.self) private var clerk
    @AppStorage("hasSeenPreSignUpOnboarding") private var hasSeenPreSignUpOnboarding = false
    @State private var authSheet: AuthSheet?

    var body: some View {
        ZStack {
            if clerk.user != nil {
                MainTabView()
                    .transition(.opacity)
            } else {
                LandingView(
                    onStart: { authSheet = .signUp },
                    onSignIn: { authSheet = .signIn }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: clerk.user?.id)
        .onChange(of: clerk.user?.id) { _, newValue in
            if newValue == nil {
                hasSeenPreSignUpOnboarding = false
            }
        }
        .sheet(item: $authSheet) { sheet in
            switch sheet {
            case .signUp:
                SignUpFlowView(
                    showOnboarding: !hasSeenPreSignUpOnboarding,
                    onOnboardingComplete: { hasSeenPreSignUpOnboarding = true }
                )
            case .signIn:
                AuthView(mode: .signIn)
                    .environment(\.clerkTheme, .bondi)
            }
        }
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            CatalogView()
                .tabItem { Label("Explorar", systemImage: "magnifyingglass") }

            PortfolioView()
                .tabItem { Label("Portafolio", systemImage: "chart.pie.fill") }

            AccountView()
                .tabItem { Label("Cuenta", systemImage: "wallet.bifold.fill") }
        }
        .tint(Color.bondiNavy)
    }
}

#Preview {
    ContentView()
        .environment(Clerk.shared)
}
