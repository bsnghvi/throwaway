import SwiftUI

/// Small selectable chip used in the topics flow-wrap. Toggle on tap.
/// Selected state fills with the brand pink; unselected stays neutral
/// with a thin border. 44pt min tap target enforced.
public struct TopicPill: View {
    private let label: String
    private let isSelected: Bool
    private let onTap: () -> Void

    public init(label: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.label = label
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(BloomFont.label)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, BloomSpacing.m)
                .padding(.vertical, BloomSpacing.s)
                .frame(minHeight: BloomSpacing.minTapTarget)
                .foregroundStyle(isSelected ? Color.white : BloomColor.textPrimary)
                .background(isSelected ? BloomColor.primary : BloomColor.surfaceElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: BloomRadius.pill, style: .continuous)
                        .stroke(
                            isSelected ? BloomColor.primary : BloomColor.border,
                            lineWidth: 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: BloomRadius.pill, style: .continuous))
        }
        .buttonStyle(TopicPressStyle())
        .accessibilityLabel(label)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

private struct TopicPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#if DEBUG
struct TopicPill_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TopicPill(label: "Sleep training", isSelected: true, onTap: {})
            TopicPill(label: "Nutrition", isSelected: false, onTap: {})
        }
        .padding()
        .background(BloomColor.background)
    }
}
#endif
