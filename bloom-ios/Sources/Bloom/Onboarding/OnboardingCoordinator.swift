import SwiftUI

/// Routes the user to the correct step view based on `store.state.currentStep`.
/// Renders a slide-up transition between steps (FR-7).
public struct OnboardingCoordinator: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            BloomColor.background.ignoresSafeArea()

            content
                .id(store.state.currentStep)
                .transition(stepTransition)
        }
        .animation(.easeOut(duration: 0.35), value: store.state.currentStep)
    }

    @ViewBuilder
    private var content: some View {
        switch store.state.currentStep {
        case .welcome:
            WelcomeView(store: store)
        case .stage:
            StageSelectorView(store: store)
        case .personalization:
            PersonalizationView(store: store)
        case .topics:
            TopicsView(store: store)
        case .privacy:
            PrivacyView(store: store)
        }
    }

    /// Slide-up insertion paired with slide-down removal so the new step
    /// rises into place while the old one drops away.
    private var stepTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
}

#if DEBUG
struct OnboardingCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCoordinator(store: OnboardingStore())
    }
}
#endif
