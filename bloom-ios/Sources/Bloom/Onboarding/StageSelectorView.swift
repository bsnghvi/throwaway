import SwiftUI

/// Step 2 of onboarding. Multi-select among the 5 life stages.
/// Continue is disabled until at least one stage is selected (FR-1).
public struct StageSelectorView: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                step: .stage,
                title: "Where are you on your journey?",
                subtitle: "Choose all that apply. You can change this anytime."
            )

            ScrollView {
                LazyVStack(spacing: BloomSpacing.s) {
                    ForEach(UserStage.allCases) { stage in
                        StagePill(
                            icon: stage.iconName,
                            title: stage.title,
                            subtitle: stage.subtitle,
                            isSelected: store.state.selectedStages.contains(stage)
                        ) {
                            store.toggleStage(stage)
                        }
                    }
                }
                .padding(.horizontal, BloomSpacing.l)
                .padding(.top, BloomSpacing.m)
                .padding(.bottom, BloomSpacing.xl)
            }

            OnboardingFooter(
                backTitle: "Back",
                continueTitle: "Continue",
                continueEnabled: !store.state.selectedStages.isEmpty,
                onBack: { store.back() },
                onContinue: {
                    store.seedRecommendedTopicsIfNeeded()
                    store.advance()
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background.ignoresSafeArea())
    }
}

#if DEBUG
struct StageSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StageSelectorView(store: OnboardingStore())
                .preferredColorScheme(.light)
            StageSelectorView(store: OnboardingStore())
                .preferredColorScheme(.dark)
        }
    }
}
#endif
