import SwiftUI

/// Horizontal snapping integer picker used for the pregnancy week
/// selector. Built on top of `ScrollView` + `ScrollPosition` (iOS 17+)
/// with a graceful iOS 16 fallback that uses a tappable strip.
public struct WheelPicker: View {
    private let range: ClosedRange<Int>
    private let label: (Int) -> String
    @Binding private var value: Int

    public init(
        range: ClosedRange<Int>,
        value: Binding<Int>,
        label: @escaping (Int) -> String = { "\($0)" }
    ) {
        self.range = range
        self._value = value
        self.label = label
    }

    public var body: some View {
        let values = Array(range)
        VStack(spacing: BloomSpacing.xs) {
            Text(label(value))
                .font(BloomFont.display)
                .foregroundStyle(BloomColor.primary)
                .animation(.spring(response: 0.3, dampingFraction: 0.85), value: value)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(values, id: \.self) { item in
                        Button {
                            value = item
                        } label: {
                            VStack(spacing: 4) {
                                Rectangle()
                                    .fill(item == value ? BloomColor.primary : BloomColor.border)
                                    .frame(width: 2, height: item == value ? 32 : 16)
                                Text("\(item)")
                                    .font(BloomFont.caption)
                                    .foregroundStyle(item == value ? BloomColor.primary : BloomColor.textTertiary)
                            }
                            .frame(width: 32, height: 56)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(label(item))
                    }
                }
                .padding(.horizontal, BloomSpacing.l)
            }
            .frame(height: 64)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Number picker")
        .accessibilityValue(label(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if value < range.upperBound { value += 1 }
            case .decrement:
                if value > range.lowerBound { value -= 1 }
            @unknown default:
                break
            }
        }
    }
}

#if DEBUG
struct WheelPicker_Previews: PreviewProvider {
    private struct Demo: View {
        @State private var week = 14
        var body: some View {
            VStack {
                WheelPicker(range: 1...42, value: $week, label: { "Week \($0)" })
            }
            .padding()
            .background(BloomColor.background)
        }
    }

    static var previews: some View {
        Demo()
    }
}
#endif
