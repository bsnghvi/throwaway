import SwiftUI

/// Step 1 of onboarding. Wordmark, tagline, hero illustration, primary CTA.
public struct WelcomeView: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: BloomSpacing.l)

            VStack(spacing: BloomSpacing.l) {
                IllustrationView(isAnimated: true)
                    .frame(width: 220, height: 220)
                    .accessibilityHidden(true)

                Text("Bloom")
                    .font(BloomFont.display)
                    .foregroundStyle(BloomColor.primary)
                    .accessibilityAddTraits(.isHeader)

                Text("Calm, evidence-based guidance for every parenting stage.")
                    .font(BloomFont.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(BloomColor.textSecondary)
                    .padding(.horizontal, BloomSpacing.l)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: BloomSpacing.l)

            VStack(spacing: BloomSpacing.s) {
                BloomButton("Get started", icon: "arrow.right") {
                    store.advance()
                }
                Text("Takes less than a minute")
                    .font(BloomFont.caption)
                    .foregroundStyle(BloomColor.textTertiary)
            }
            .padding(.horizontal, BloomSpacing.l)
            .padding(.bottom, BloomSpacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background.ignoresSafeArea())
    }
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView(store: OnboardingStore())
                .preferredColorScheme(.light)
            WelcomeView(store: OnboardingStore())
                .preferredColorScheme(.dark)
        }
    }
}
#endif
