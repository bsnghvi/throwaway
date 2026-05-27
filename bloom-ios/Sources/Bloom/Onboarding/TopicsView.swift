import SwiftUI

/// Step 4 of onboarding. 20 topic chips in a flow-wrap layout. 3-5 are
/// pre-selected based on stages (seeded by `StageSelectorView` when the
/// user advances). User can toggle freely; Continue is always enabled.
public struct TopicsView: View {
    @ObservedObject var store: OnboardingStore

    public init(store: OnboardingStore) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            OnboardingHeader(
                step: .topics,
                title: "What would you like to learn about?",
                subtitle: "We've pre-picked a few based on your stage. Tap to add or remove."
            )

            ScrollView {
                FlowLayout(spacing: BloomSpacing.xs) {
                    ForEach(OnboardingStore.allTopics, id: \.self) { topic in
                        TopicPill(
                            label: topic,
                            isSelected: store.state.topics.contains(topic)
                        ) {
                            store.toggleTopic(topic)
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
                continueEnabled: true,
                onBack: { store.back() },
                onContinue: { store.advance() }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background.ignoresSafeArea())
    }
}

/// Minimal flow-wrap layout that places children left-to-right with
/// wrapping. Used for the topics chip cloud.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let layout = arrange(in: maxWidth, subviews: subviews)
        return CGSize(width: maxWidth.isFinite ? maxWidth : layout.totalWidth, height: layout.totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let layout = arrange(in: bounds.width, subviews: subviews)
        for placement in layout.placements {
            placement.subview.place(
                at: CGPoint(x: bounds.minX + placement.x, y: bounds.minY + placement.y),
                proposal: ProposedViewSize(placement.size)
            )
        }
    }

    private struct Arrangement {
        struct Placement {
            let subview: LayoutSubview
            let x: CGFloat
            let y: CGFloat
            let size: CGSize
        }
        let placements: [Placement]
        let totalWidth: CGFloat
        let totalHeight: CGFloat
    }

    private func arrange(in maxWidth: CGFloat, subviews: Subviews) -> Arrangement {
        var placements: [Arrangement.Placement] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widestRow: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                widestRow = max(widestRow, x - spacing)
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            placements.append(.init(subview: sub, x: x, y: y, size: size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        widestRow = max(widestRow, x - spacing)
        let totalHeight = y + rowHeight
        return Arrangement(placements: placements, totalWidth: widestRow, totalHeight: totalHeight)
    }
}

#if DEBUG
struct TopicsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = OnboardingStore()
        store.toggleStage(.pregnant)
        store.seedRecommendedTopicsIfNeeded()
        return Group {
            TopicsView(store: store)
                .preferredColorScheme(.light)
            TopicsView(store: store)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
