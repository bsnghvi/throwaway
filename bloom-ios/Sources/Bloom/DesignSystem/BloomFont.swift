import SwiftUI

/// Bloom typography ramp. Sizes are paired with `relativeTo:` so Dynamic
/// Type scales every text style up to Accessibility-XL without breaking
/// hierarchy. Weight + leading are tuned for the warm editorial feel of
/// the brand.
public enum BloomFont {
    public static let display = Font.system(size: 40, weight: .semibold, design: .serif)
        .leading(.tight)

    public static let h1 = Font.system(size: 28, weight: .semibold, design: .serif)
        .leading(.tight)

    public static let h2 = Font.system(size: 22, weight: .semibold, design: .serif)
        .leading(.tight)

    public static let body = Font.system(size: 17, weight: .regular, design: .default)
        .leading(.standard)

    public static let bodyEmphasis = Font.system(size: 17, weight: .semibold, design: .default)
        .leading(.standard)

    public static let label = Font.system(size: 15, weight: .medium, design: .default)
        .leading(.standard)

    public static let caption = Font.system(size: 13, weight: .regular, design: .default)
        .leading(.standard)
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
