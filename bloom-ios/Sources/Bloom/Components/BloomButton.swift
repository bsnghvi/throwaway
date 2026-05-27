import SwiftUI

/// Bloom's primary call-to-action button. Three variants:
///
/// - `.primary`   – filled brand-pink pill, used for the dominant action.
/// - `.secondary` – outlined version of primary, for alternative actions.
/// - `.text`      – text-only, no background; used for "Skip" / "Back".
///
/// The button respects a 44pt minimum tap target and ships a tap-feedback
/// animation that scales down by 4% while pressed.
public struct BloomButton: View {
    public enum Variant: Equatable {
        case primary
        case secondary
        case text
    }

    public enum Size: Equatable {
        case regular
        case large
    }

    private let title: String
    private let variant: Variant
    private let size: Size
    private let icon: String?
    private let isEnabled: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        variant: Variant = .primary,
        size: Size = .large,
        icon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: BloomSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(size == .large ? BloomFont.bodyEmphasis : BloomFont.label)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: variant == .text ? nil : .infinity)
            .frame(minHeight: minHeight)
            .background(background)
            .foregroundStyle(foreground)
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: BloomRadius.pill, style: .continuous))
        }
        .buttonStyle(PressFeedbackStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.45)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }

    private var minHeight: CGFloat {
        switch size {
        case .large: return 56
        case .regular: return BloomSpacing.minTapTarget
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .large: return BloomSpacing.xl
        case .regular: return BloomSpacing.m
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:
            BloomColor.primary
        case .secondary, .text:
            Color.clear
        }
    }

    private var foreground: Color {
        switch variant {
        case .primary: return .white
        case .secondary: return BloomColor.primary
        case .text: return BloomColor.textSecondary
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .secondary {
            RoundedRectangle(cornerRadius: BloomRadius.pill, style: .continuous)
                .stroke(BloomColor.primary, lineWidth: 1.5)
        }
    }
}

/// Press-down feedback for buttons: 4% scale and slight opacity drop.
private struct PressFeedbackStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#if DEBUG
struct BloomButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            preview.preferredColorScheme(.light)
            preview.preferredColorScheme(.dark)
        }
    }

    static var preview: some View {
        VStack(spacing: BloomSpacing.m) {
            BloomButton("Get started", action: {})
            BloomButton("Continue", variant: .secondary, action: {})
            BloomButton("Skip", variant: .text, size: .regular, action: {})
            BloomButton("Continue", icon: "arrow.right", isEnabled: false, action: {})
        }
        .padding(BloomSpacing.l)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background)
    }
}
#endif
