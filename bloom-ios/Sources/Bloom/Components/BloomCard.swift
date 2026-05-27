import SwiftUI

/// A rounded surface tile used to host content cards across Bloom. Wraps
/// content with the design system's surface color, card radius, and warm
/// shadow. Two variants:
///
/// - `.standard`  – on top of the background, picks up the warm card shadow.
/// - `.flat`      – no shadow, used inside scroll lists where elevation
///                   would feel busy.
public enum BloomCardStyle: Equatable {
    case standard
    case flat
}

public struct BloomCard<Content: View>: View {
    public typealias Style = BloomCardStyle

    private let style: BloomCardStyle
    private let padding: CGFloat
    private let content: Content
    private let onTap: (() -> Void)?

    public init(
        style: Style = .standard,
        padding: CGFloat = BloomSpacing.l,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.onTap = onTap
        self.content = content()
    }

    public var body: some View {
        let surface = content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(BloomColor.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: BloomRadius.card, style: .continuous))
            .modifier(ShadowModifier(style: style))

        Group {
            if let onTap {
                Button(action: onTap) { surface }
                    .buttonStyle(CardPressStyle())
                    .accessibilityAddTraits(.isButton)
            } else {
                surface
            }
        }
    }
}

private struct ShadowModifier: ViewModifier {
    let style: BloomCardStyle

    func body(content: Content) -> some View {
        switch style {
        case .standard:
            content.bloomShadow(.card)
        case .flat:
            content
        }
    }
}

private struct CardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#if DEBUG
struct BloomCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            preview.preferredColorScheme(.light)
            preview.preferredColorScheme(.dark)
        }
    }

    static var preview: some View {
        VStack(spacing: BloomSpacing.m) {
            BloomCard {
                VStack(alignment: .leading, spacing: BloomSpacing.xs) {
                    Text("Standard card").font(BloomFont.h2)
                    Text("With the warm pink shadow.")
                        .font(BloomFont.body)
                        .foregroundStyle(BloomColor.textSecondary)
                }
            }
            BloomCard(style: .flat) {
                Text("Flat card").font(BloomFont.h2)
            }
            BloomCard(onTap: {}) {
                Text("Tappable card").font(BloomFont.h2)
            }
        }
        .padding(BloomSpacing.l)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BloomColor.background)
    }
}
#endif
