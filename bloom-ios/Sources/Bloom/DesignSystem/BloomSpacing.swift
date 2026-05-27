import CoreGraphics

/// 4-point spacing grid used across the Bloom UI. Reach for these named
/// values instead of writing raw numbers — they keep vertical rhythm
/// consistent and make global density tweaks a one-line change.
public enum BloomSpacing {
    public static let xxs: CGFloat = 4
    public static let xs: CGFloat = 8
    public static let s: CGFloat = 12
    public static let m: CGFloat = 16
    public static let l: CGFloat = 20
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 48
    public static let huge: CGFloat = 64

    /// Smallest tap-target dimension the design system guarantees. Used
    /// internally by pills and icon buttons to enforce Apple's 44pt rule.
    public static let minTapTarget: CGFloat = 44
}
