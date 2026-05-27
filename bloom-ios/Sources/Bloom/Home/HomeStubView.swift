import SwiftUI

/// Placeholder home screen used after onboarding completes. Real Home is
/// a future feature; this stub confirms the onboarding hand-off worked
/// and shows the captured profile so QA can sanity-check persistence.
public struct HomeStubView: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BloomSpacing.l) {
                VStack(alignment: .leading, spacing: BloomSpacing.xs) {
                    Text("You're set up.")
                        .font(BloomFont.h1)
                        .foregroundStyle(BloomColor.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    Text("Home and the rest of Bloom land in upcoming releases.")
                        .font(BloomFont.body)
                        .foregroundStyle(BloomColor.textSecondary)
                }

                BloomCard {
                    VStack(alignment: .leading, spacing: BloomSpacing.s) {
                        Text("Your profile")
                            .font(BloomFont.h2)
                            .foregroundStyle(BloomColor.textPrimary)

                        row("Stages", value: stages)
                        if let week = store.state.weekPregnant {
                            row("Pregnancy week", value: "Week \(week)")
                        }
                        if let date = store.state.dueDate {
                            row("Due date", value: Self.dateFormatter.string(from: date))
                        }
                        if let months = store.state.childAgeMonths {
                            row("Child age", value: "\(months) months")
                        }
                        row("Topics", value: topics)
                    }
                }

                BloomButton("Reset onboarding (debug)", variant: .secondary, size: .regular) {
                    store.reset()
                }
            }
            .padding(BloomSpacing.l)
        }
        .background(BloomColor.background.ignoresSafeArea())
    }

    private var stages: String {
        let titles = UserStage.allCases
            .filter { store.state.selectedStages.contains($0) }
            .map(\.title)
        return titles.isEmpty ? "—" : titles.joined(separator: ", ")
    }

    private var topics: String {
        store.state.topics.isEmpty ? "—" : store.state.topics.sorted().joined(separator: ", ")
    }

    @ViewBuilder
    private func row(_ key: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(key)
                .font(BloomFont.label)
                .foregroundStyle(BloomColor.textTertiary)
                .frame(width: 110, alignment: .leading)
            Text(value)
                .font(BloomFont.body)
                .foregroundStyle(BloomColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
}

#if DEBUG
struct HomeStubView_Previews: PreviewProvider {
    static var previews: some View {
        let store = OnboardingStore()
        store.toggleStage(.pregnant)
        store.setWeekPregnant(14)
        store.seedRecommendedTopicsIfNeeded()
        store.commit()
        return HomeStubView(store: store)
    }
}
#endif
