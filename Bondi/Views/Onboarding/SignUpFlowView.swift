import ClerkKitUI
import SwiftUI

/// Flow for creating a new account:
/// 1. Educational onboarding (3 slides) — only the first time on the device.
/// 2. Clerk's `AuthView` in sign-in-or-up mode (Clerk auto-detects based on email).
///
/// Presented as a sheet from `LandingView`'s "Crear mi cuenta" CTA.
struct SignUpFlowView: View {
    let showOnboarding: Bool
    let onOnboardingComplete: () -> Void

    @State private var didFinishOnboarding: Bool

    init(showOnboarding: Bool, onOnboardingComplete: @escaping () -> Void) {
        self.showOnboarding = showOnboarding
        self.onOnboardingComplete = onOnboardingComplete
        self._didFinishOnboarding = State(initialValue: !showOnboarding)
    }

    var body: some View {
        ZStack {
            if didFinishOnboarding {
                AuthView()
                    .environment(\.clerkTheme, .bondi)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity
                    ))
            } else {
                OnboardingView(onComplete: {
                    onOnboardingComplete()
                    withAnimation(.easeInOut(duration: 0.4)) {
                        didFinishOnboarding = true
                    }
                })
                .transition(.asymmetric(
                    insertion: .opacity,
                    removal: .opacity.combined(with: .move(edge: .leading))
                ))
            }
        }
    }
}
