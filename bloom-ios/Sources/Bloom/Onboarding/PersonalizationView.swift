import SwiftUI

/// Step 3 of onboarding. Adapts based on `store.selectedStages`:
/// - shows a pregnancy-week wheel + optional due-date picker when
///   `pregnant` is selected
/// - shows a child-age input (in months) when any postnatal stage is
///   selected
/// - if only `tryingToConceive` is selected, the coordinator skips this
///   view entirely (handled in `OnboardingStore.shouldSkip`)
public struct PersonalizationView: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    @State private var showsDuePicker = false

    public var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                step: .personalization,
                title: "A little more about you",
                subtitle: "We'll personalise content to your timeline."
            )

            ScrollView {
                VStack(spacing: BloomSpacing.l) {
                    if store.state.selectedStages.contains(.pregnant) {
                        pregnancyCard
                    }
                    if store.state.selectedStages.contains(where: { $0.isPostnatal }) {
                        childAgeCard
                    }
                }
                .padding(.horizontal, BloomSpacing.l)
                .padding(.top, BloomSpacing.m)
                .padding(.bottom, BloomSpacing.xl)
            }

            OnboardingFooter(
                backTitle: "Back",
                continueTitle: "Continue",
                continueEnabled: true,
                onBack: { store.back() },
                onContinue: { store.advance() }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background.ignoresSafeArea())
    }

    // MARK: - Cards

    private var pregnancyCard: some View {
        BloomCard {
            VStack(alignment: .leading, spacing: BloomSpacing.m) {
                Text("How many weeks pregnant?")
                    .font(BloomFont.h2)
                    .foregroundStyle(BloomColor.textPrimary)

                WheelPicker(
                    range: 1...42,
                    value: Binding(
                        get: { store.state.weekPregnant ?? 12 },
                        set: { store.setWeekPregnant($0) }
                    ),
                    label: { "Week \($0)" }
                )

                Divider().background(BloomColor.border)

                VStack(alignment: .leading, spacing: BloomSpacing.xs) {
                    Text("Due date (optional)")
                        .font(BloomFont.label)
                        .foregroundStyle(BloomColor.textSecondary)

                    DatePicker(
                        "Due date",
                        selection: Binding(
                            get: { store.state.dueDate ?? defaultDueDate },
                            set: { store.setDueDate($0) }
                        ),
                        in: Date()...Date(timeIntervalSinceNow: 60 * 60 * 24 * 300),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(BloomColor.primary)
                    .accessibilityLabel("Due date")
                }
            }
        }
    }

    private var childAgeCard: some View {
        BloomCard {
            VStack(alignment: .leading, spacing: BloomSpacing.m) {
                Text("How old is your child?")
                    .font(BloomFont.h2)
                    .foregroundStyle(BloomColor.textPrimary)

                Text("Enter age in months (e.g. 18 for an 18-month-old).")
                    .font(BloomFont.caption)
                    .foregroundStyle(BloomColor.textSecondary)

                Stepper(
                    value: Binding(
                        get: { store.state.childAgeMonths ?? 12 },
                        set: { store.setChildAgeMonths($0) }
                    ),
                    in: 0...120
                ) {
                    HStack {
                        Text("Age:")
                            .font(BloomFont.body)
                        Text("\(store.state.childAgeMonths ?? 12) months")
                            .font(BloomFont.bodyEmphasis)
                            .foregroundStyle(BloomColor.primary)
                    }
                }
                .tint(BloomColor.primary)
                .accessibilityLabel("Child age in months")
            }
        }
    }

    private var defaultDueDate: Date {
        Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
    }
}

#if DEBUG
struct PersonalizationView_Previews: PreviewProvider {
    static var previews: some View {
        let store = OnboardingStore()
        store.toggleStage(.pregnant)
        store.toggleStage(.toddler)
        return Group {
            PersonalizationView(store: store)
                .preferredColorScheme(.light)
            PersonalizationView(store: store)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
