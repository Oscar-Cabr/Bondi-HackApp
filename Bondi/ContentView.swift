//
//  ContentView.swift
//  Bondi
//
//  Created by Andrés Rodríguez Montes de Oca on 20/04/26.
//

import SwiftUI

enum AppRoute {
    case landing
    case onboarding
    case main
}

struct ContentView: View {
    @State private var route: AppRoute = .landing

    var body: some View {
        ZStack {
            switch route {
            case .landing:
                LandingView(
                    onStart: {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            route = .onboarding
                        }
                    },
                    onSignIn: {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            route = .main
                        }
                    }
                )
                .transition(.opacity.combined(with: .move(edge: .leading)))

            case .onboarding:
                OnboardingView(onComplete: {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        route = .main
                    }
                })
                .transition(.opacity)

            case .main:
                MainTabView()
                    .transition(.opacity)
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
        }
        .tint(Color.bondiNavy)
    }
}

#Preview {
    ContentView()
}
