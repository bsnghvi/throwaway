import SwiftUI

/// Bloom typography ramp. Every token is built on a `Font.TextStyle`
/// (e.g. `.largeTitle`, `.body`) so Dynamic Type scaling works for free —
/// at Accessibility-XL the text ramps up alongside iOS body settings.
///
/// Weight + design (serif for headlines, default for body) reinforces the
/// warm editorial brand feel.
public enum BloomFont {
    public static let display = Font.system(.largeTitle, design: .serif, weight: .semibold)
    public static let h1 = Font.system(.title, design: .serif, weight: .semibold)
    public static let h2 = Font.system(.title2, design: .serif, weight: .semibold)

    public static let body = Font.system(.body, design: .default, weight: .regular)
    public static let bodyEmphasis = Font.system(.body, design: .default, weight: .semibold)
    public static let label = Font.system(.subheadline, design: .default, weight: .medium)
    public static let caption = Font.system(.caption, design: .default, weight: .regular)
}

#if DEBUG
struct BloomFont_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Bloom display").font(BloomFont.display)
                Text("Heading 1").font(BloomFont.h1)
                Text("Heading 2").font(BloomFont.h2)
                Text("Body — the quick brown fox jumps over the lazy dog.").font(BloomFont.body)
                Text("Body emphasis").font(BloomFont.bodyEmphasis)
                Text("Label").font(BloomFont.label)
                Text("Caption").font(BloomFont.caption)
            }
            .padding(20)
            .foregroundStyle(BloomColor.textPrimary)
        }
        .background(BloomColor.background)
    }
}
#endif
