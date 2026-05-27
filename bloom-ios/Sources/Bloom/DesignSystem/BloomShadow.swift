import SwiftUI

/// Warm-tinted shadows applied to elevated surfaces. The pink-tinged
/// shadow color is what gives Bloom cards their signature soft feel —
/// neutral gray drop shadows look medical, not maternal.
public struct BloomShadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public static let card = BloomShadow(
        color: Color(.sRGB, red: 0.78, green: 0.40, blue: 0.50, opacity: 0.10),
        radius: 18,
        x: 0,
        y: 8
    )

    public static let button = BloomShadow(
        color: Color(.sRGB, red: 0.78, green: 0.40, blue: 0.50, opacity: 0.18),
        radius: 8,
        x: 0,
        y: 4
    )

    public static let subtle = BloomShadow(
        color: Color(.sRGB, red: 0.30, green: 0.20, blue: 0.20, opacity: 0.06),
        radius: 6,
        x: 0,
        y: 2
    )
}

public extension View {
    func bloomShadow(_ shadow: BloomShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
