import SwiftUI

/// Shared header chrome for every step ≥ 2. Renders progress bar + title +
/// optional subtitle and gives the screen a consistent look.
struct OnboardingHeader: View {
    let step: OnboardingStep
    let title: String
    let subtitle: String?

    init(step: OnboardingStep, title: String, subtitle: String? = nil) {
        self.step = step
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: BloomSpacing.m) {
            ProgressBar(progress: Double(step.displayNumber) / Double(OnboardingStep.total))
                .padding(.top, BloomSpacing.s)

            VStack(alignment: .leading, spacing: BloomSpacing.xs) {
                Text(title)
                    .font(BloomFont.h1)
                    .foregroundStyle(BloomColor.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                    .fixedSize(horizontal: false, vertical: true)
                if let subtitle {
                    Text(subtitle)
                        .font(BloomFont.body)
                        .foregroundStyle(BloomColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, BloomSpacing.l)
        .padding(.top, BloomSpacing.m)
    }
}

/// Sticky footer with Back / Continue actions. Sticks to the bottom 40%
/// of the screen so one-handed reach is comfortable.
struct OnboardingFooter: View {
    let backTitle: String
    let continueTitle: String
    let continueEnabled: Bool
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        HStack(spacing: BloomSpacing.s) {
            BloomButton(backTitle, variant: .text, size: .regular, action: onBack)
                .frame(maxWidth: 110)
            BloomButton(continueTitle, isEnabled: continueEnabled, action: onContinue)
        }
        .padding(.horizontal, BloomSpacing.l)
        .padding(.vertical, BloomSpacing.m)
        .background(
            BloomColor.background
                .opacity(0.96)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
