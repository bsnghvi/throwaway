import CoreGraphics

/// Corner radii tokens. `pill` returns a value larger than any expected
/// height so callers can apply it as a capsule.
public enum BloomRadius {
    public static let small: CGFloat = 6
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 20
    public static let card: CGFloat = 24
    public static let pill: CGFloat = 999
}
