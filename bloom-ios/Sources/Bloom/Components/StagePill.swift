import SwiftUI

/// Large multi-select card representing a life-stage option (e.g.
/// "Pregnant", "Toddler & Beyond"). Tapping toggles the selection;
/// selected state shows a brand-pink border and tinted background.
public struct StagePill: View {
    private let icon: String
    private let title: String
    private let subtitle: String?
    private let isSelected: Bool
    private let onTap: () -> Void

    public init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: BloomSpacing.m) {
                ZStack {
                    Circle()
                        .fill(isSelected ? BloomColor.primary : BloomColor.primarySubtle)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(isSelected ? Color.white : BloomColor.primary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(BloomFont.bodyEmphasis)
                        .foregroundStyle(BloomColor.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(BloomFont.caption)
                            .foregroundStyle(BloomColor.textSecondary)
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(isSelected ? BloomColor.primary : BloomColor.border)
            }
            .padding(BloomSpacing.m)
            .frame(maxWidth: .infinity)
            .frame(minHeight: BloomSpacing.minTapTarget + BloomSpacing.l)
            .background(isSelected ? BloomColor.primarySubtle : BloomColor.surfaceElevated)
            .overlay(
                RoundedRectangle(cornerRadius: BloomRadius.large, style: .continuous)
                    .stroke(
                        isSelected ? BloomColor.primary : BloomColor.border,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: BloomRadius.large, style: .continuous))
        }
        .buttonStyle(StagePressStyle())
        .accessibilityLabel(title)
        .accessibilityHint(subtitle ?? "")
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isSelected ? Text("Selected") : Text("Not selected"))
    }
}

private struct StagePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#if DEBUG
struct StagePill_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: BloomSpacing.s) {
            StagePill(icon: "heart.fill", title: "Trying to conceive", subtitle: "Planning a family", isSelected: false, onTap: {})
            StagePill(icon: "figure.stand", title: "Pregnant", subtitle: "Awaiting a baby", isSelected: true, onTap: {})
        }
        .padding()
        .background(BloomColor.background)
    }
}
#endif
