import SwiftUI
import Darwin

/// Abstract bloom-petal motif rendered with `Canvas` — five soft elliptical
/// petals arranged around a center, optionally slowly rotating. No asset
/// dependency; T13 will refine the animation curve.
public struct IllustrationView: View {
    private let isAnimated: Bool

    public init(isAnimated: Bool = false) {
        self.isAnimated = isAnimated
    }

    public var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30, paused: !isAnimated)) { context in
            let elapsed = context.date.timeIntervalSinceReferenceDate
            let rotation = isAnimated ? elapsed * 0.18 : 0
            Canvas { ctx, size in
                Self.draw(in: ctx, size: size, rotation: rotation)
            }
        }
        .accessibilityHidden(true)
    }

    private static func draw(
        in ctx: GraphicsContext,
        size: CGSize,
        rotation: Double
    ) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) * 0.32
        let petalCount = 5

        for i in 0..<petalCount {
            let angle = (Double(i) / Double(petalCount)) * .pi * 2 + rotation
            drawPetal(in: ctx, center: center, radius: radius, angle: angle, index: i)
        }

        let budRadius = radius * 0.28
        let budRect = CGRect(
            x: center.x - budRadius,
            y: center.y - budRadius,
            width: budRadius * 2,
            height: budRadius * 2
        )
        ctx.fill(Path(ellipseIn: budRect), with: .color(BloomColor.accent))
    }

    private static func drawPetal(
        in ctx: GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        angle: Double,
        index: Int
    ) {
        let cosA = CGFloat(Darwin.cos(angle))
        let sinA = CGFloat(Darwin.sin(angle))
        let petalCenter = CGPoint(
            x: center.x + cosA * radius * 0.55,
            y: center.y + sinA * radius * 0.55
        )

        let petalRect = CGRect(
            x: petalCenter.x - radius * 0.55,
            y: petalCenter.y - radius * 0.30,
            width: radius * 1.1,
            height: radius * 0.6
        )

        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: petalCenter.x, y: petalCenter.y)
        transform = transform.rotated(by: angle + .pi / 2)
        transform = transform.translatedBy(x: -petalCenter.x, y: -petalCenter.y)

        let petalPath = Path(ellipseIn: petalRect).applying(transform)
        ctx.fill(petalPath, with: .color(petalColor(index: index).opacity(0.85)))
    }

    private static func petalColor(index: Int) -> Color {
        switch index % 3 {
        case 0: return BloomColor.primary
        case 1: return BloomColor.accent
        default: return BloomColor.secondary
        }
    }
}

#if DEBUG
struct IllustrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IllustrationView(isAnimated: false)
                .frame(width: 240, height: 240)
                .padding()
                .background(BloomColor.background)
                .preferredColorScheme(.light)
            IllustrationView(isAnimated: false)
                .frame(width: 240, height: 240)
                .padding()
                .background(BloomColor.background)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
