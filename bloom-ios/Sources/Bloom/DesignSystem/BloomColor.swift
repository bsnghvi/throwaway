import SwiftUI

/// Bloom palette. Every token has light + dark variants and is resolved by
/// the current `ColorScheme` at render time. Tokens are intentionally
/// semantic (`primary`, `surface`, `nhsGreen`) rather than literal — views
/// must reach for these names, never raw hex.
public enum BloomColor {
    // MARK: - Surfaces

    public static let background = adaptive(
        light: hex(0xFFF9F4),
        dark: hex(0x14110F)
    )

    public static let surface = adaptive(
        light: hex(0xFFFFFF),
        dark: hex(0x1E1A17)
    )

    public static let surfaceElevated = adaptive(
        light: hex(0xFFFDFB),
        dark: hex(0x2A2522)
    )

    // MARK: - Brand

    public static let primary = adaptive(
        light: hex(0xC9527A),
        dark: hex(0xE07896)
    )

    public static let primarySubtle = adaptive(
        light: hex(0xF8DEE6),
        dark: hex(0x3A2027)
    )

    public static let secondary = adaptive(
        light: hex(0x5E8B7E),
        dark: hex(0x82B0A3)
    )

    public static let secondarySubtle = adaptive(
        light: hex(0xDDEAE4),
        dark: hex(0x223330)
    )

    public static let accent = adaptive(
        light: hex(0xE8A87C),
        dark: hex(0xF0B98B)
    )

    // MARK: - Text

    public static let textPrimary = adaptive(
        light: hex(0x1F1A1C),
        dark: hex(0xF5EFEC)
    )

    public static let textSecondary = adaptive(
        light: hex(0x4B4244),
        dark: hex(0xC8BDB9)
    )

    public static let textTertiary = adaptive(
        light: hex(0x8A7F82),
        dark: hex(0x8E827E)
    )

    // MARK: - Lines

    public static let border = adaptive(
        light: hex(0xEBE0DC),
        dark: hex(0x352E2B)
    )

    // MARK: - Trust marks

    /// Used wherever Bloom cites NHS-sourced content. Matches the NHS brand
    /// blue (#005EB8) per https://service-manual.nhs.uk/design-system/styles/colour.
    public static let nhsGreen = adaptive(
        light: hex(0x005EB8),
        dark: hex(0x4A8FD6)
    )

    // MARK: - Helpers

    private static func adaptive(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        return Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .vibrantDark]) != nil
            return isDark ? NSColor(dark) : NSColor(light)
        })
        #else
        return light
        #endif
    }

    private static func hex(_ value: UInt32) -> Color {
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        return Color(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if DEBUG
struct BloomColor_Previews: PreviewProvider {
    private struct Swatch: View {
        let name: String
        let color: Color

        var body: some View {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 56, height: 32)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
                Text(name).font(.system(size: 14, weight: .medium))
                Spacer()
            }
        }
    }

    private static let entries: [(String, Color)] = [
        ("background", BloomColor.background),
        ("surface", BloomColor.surface),
        ("surfaceElevated", BloomColor.surfaceElevated),
        ("primary", BloomColor.primary),
        ("primarySubtle", BloomColor.primarySubtle),
        ("secondary", BloomColor.secondary),
        ("secondarySubtle", BloomColor.secondarySubtle),
        ("accent", BloomColor.accent),
        ("textPrimary", BloomColor.textPrimary),
        ("textSecondary", BloomColor.textSecondary),
        ("textTertiary", BloomColor.textTertiary),
        ("border", BloomColor.border),
        ("nhsGreen", BloomColor.nhsGreen)
    ]

    static var previews: some View {
        Group {
            grid.preferredColorScheme(.light)
            grid.preferredColorScheme(.dark)
        }
    }

    private static var grid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(entries, id: \.0) { name, color in
                    Swatch(name: name, color: color)
                }
            }
            .padding(20)
        }
        .background(BloomColor.background)
    }
}
#endif
