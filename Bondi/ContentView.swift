//
//  ContentView.swift
//  Bondi
//
//  Created by Andrés Rodríguez Montes de Oca on 20/04/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView(onComplete: { hasCompletedOnboarding = true })
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
