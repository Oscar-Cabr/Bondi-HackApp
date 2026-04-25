import ClerkKitUI
import SwiftUI

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
