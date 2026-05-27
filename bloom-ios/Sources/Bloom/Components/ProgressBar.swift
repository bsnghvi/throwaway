import SwiftUI

/// Thin horizontal progress bar. Animates fill changes with a spring so
/// step transitions feel alive.
public struct ProgressBar: View {
    private let progress: Double
    private let trackHeight: CGFloat

    public init(progress: Double, trackHeight: CGFloat = 6) {
        self.progress = max(0, min(1, progress))
        self.trackHeight = trackHeight
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(BloomColor.primarySubtle)
                    .frame(height: trackHeight)
                Capsule()
                    .fill(BloomColor.primary)
                    .frame(width: max(trackHeight, geo.size.width * progress), height: trackHeight)
                    .animation(.spring(response: 0.4, dampingFraction: 0.85), value: progress)
            }
        }
        .frame(height: trackHeight)
        .accessibilityElement()
        .accessibilityLabel("Onboarding progress")
        .accessibilityValue(Text("\(Int(progress * 100)) percent"))
    }
}

#if DEBUG
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: BloomSpacing.m) {
            ProgressBar(progress: 0.2)
            ProgressBar(progress: 0.6)
            ProgressBar(progress: 1.0)
        }
        .padding()
        .background(BloomColor.background)
    }
}
#endif
