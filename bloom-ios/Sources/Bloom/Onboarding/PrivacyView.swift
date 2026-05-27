import SwiftUI

/// Step 5 of onboarding. Three icon+text promise cards and a single
/// "Start my journey" CTA that flips `onboarding.completed`.
public struct PrivacyView: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    private struct Promise: Identifiable {
        let id: String
        let icon: String
        let title: String
        let body: String
    }

    private let promises: [Promise] = [
        Promise(
            id: "device",
            icon: "lock.shield.fill",
            title: "Your data lives on your device",
            body: "Nothing about your stage, week, or topics leaves your phone unless you explicitly opt in."
        ),
        Promise(
            id: "nhs",
            icon: "checkmark.seal.fill",
            title: "Sourced from the NHS",
            body: "Bloom only surfaces guidance you can trace back to NHS or other peer-reviewed authorities."
        ),
        Promise(
            id: "delete",
            icon: "trash.fill",
            title: "Deletable in one tap",
            body: "Wipe everything from Settings → Privacy. No \"sorry to see you go\" emails."
        )
    ]

    public var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                step: .privacy,
                title: "A quick word on privacy",
                subtitle: "Three promises before we start."
            )

            ScrollView {
                VStack(spacing: BloomSpacing.s) {
                    ForEach(promises) { promise in
                        BloomCard {
                            HStack(alignment: .top, spacing: BloomSpacing.m) {
                                ZStack {
                                    Circle()
                                        .fill(BloomColor.secondarySubtle)
                                        .frame(width: 44, height: 44)
                                    Image(systemName: promise.icon)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(BloomColor.secondary)
                                }
                                .accessibilityHidden(true)

                                VStack(alignment: .leading, spacing: BloomSpacing.xxs) {
                                    Text(promise.title)
                                        .font(BloomFont.bodyEmphasis)
                                        .foregroundStyle(BloomColor.textPrimary)
                                    Text(promise.body)
                                        .font(BloomFont.body)
                                        .foregroundStyle(BloomColor.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .accessibilityElement(children: .combine)
                            }
                        }
                    }
                }
                .padding(.horizontal, BloomSpacing.l)
                .padding(.top, BloomSpacing.m)
                .padding(.bottom, BloomSpacing.xl)
            }

            HStack(spacing: BloomSpacing.s) {
                BloomButton("Back", variant: .text, size: .regular) {
                    store.back()
                }
                .frame(maxWidth: 110)
                BloomButton("Start my journey", icon: "sparkles") {
                    store.commit()
                }
                .accessibilityHint("Completes onboarding and opens the home screen")
            }
            .padding(.horizontal, BloomSpacing.l)
            .padding(.vertical, BloomSpacing.m)
            .background(BloomColor.background.opacity(0.96).ignoresSafeArea(edges: .bottom))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background.ignoresSafeArea())
    }
}

#if DEBUG
struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrivacyView(store: OnboardingStore())
                .preferredColorScheme(.light)
            PrivacyView(store: OnboardingStore())
                .preferredColorScheme(.dark)
        }
    }
}
#endif
