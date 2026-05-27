# Bloom iOS

SwiftUI library powering the Bloom onboarding flow. Five screens, premium
warm aesthetic, full light + dark mode, no third-party dependencies.

## Status

This package implements the `bloom-onboarding` feature end-to-end:
`Welcome → Stage → Personalization → Topics → Privacy → HomeStub`. Profile
state persists via `@AppStorage` / `UserDefaults` so a force-quit
mid-onboarding resumes at the saved step.

## Requirements

- Xcode 15 or newer
- iOS 16+ deployment target (the package also compiles on macOS 13+ so
  `swift build` works from a plain command line for CI / library checks)

## Quick verification

```sh
cd bloom-ios
swift build         # compiles the library against host SDK
swift test          # runs unit tests (requires Xcode-provided XCTest)
```

> The CLI swift toolchain bundled with Xcode Command Line Tools does not
> ship XCTest. Tests run cleanly inside Xcode (`Cmd-U`) or via
> `xcodebuild test -scheme Bloom` if a full Xcode install is present.

## Wiring into an app target

The package ships a `Bloom` library product. Add the package as a local
dependency to your iOS app target, then mount `BloomRootView()` at the
top of the scene graph:

```swift
import SwiftUI
import Bloom

@main
struct BloomAppEntry: App {
    var body: some Scene {
        WindowGroup {
            BloomRootView()
        }
    }
}
```

`BloomRootView` inspects the persisted onboarding state and branches
between `OnboardingCoordinator` (first launch / mid-flow resume) and
`HomeStubView` (post-completion placeholder). The stub view exposes a
debug "Reset onboarding" action that calls `OnboardingStore.reset()` —
remove it before shipping a real Home.

## Source layout

```
bloom-ios/
├── Package.swift                              # iOS 16 / macOS 13 platforms
├── Sources/Bloom/
│   ├── Bloom.swift                            # module anchor + version
│   ├── App.swift                              # BloomRootView entry
│   ├── DesignSystem/
│   │   ├── BloomColor.swift                   # 13 palette tokens (light + dark)
│   │   ├── BloomFont.swift                    # Dynamic-Type-scaling text styles
│   │   ├── BloomSpacing.swift                 # 4pt grid + minTapTarget
│   │   ├── BloomRadius.swift                  # small / medium / large / card / pill
│   │   └── BloomShadow.swift                  # warm-tinted shadows + .bloomShadow()
│   ├── Components/
│   │   ├── BloomButton.swift                  # primary / secondary / text
│   │   ├── BloomCard.swift                    # standard / flat surface tile
│   │   ├── StagePill.swift                    # multi-select life-stage card
│   │   ├── TopicPill.swift                    # interest chip
│   │   ├── ProgressBar.swift                  # animated progress fill
│   │   ├── WheelPicker.swift                  # snapping integer wheel
│   │   └── IllustrationView.swift             # Canvas-drawn bloom motif
│   ├── Models/
│   │   ├── UserStage.swift                    # 5 life stages (CaseIterable)
│   │   ├── OnboardingState.swift              # Codable snapshot of all collected data
│   │   └── OnboardingStore.swift              # ObservableObject + @AppStorage persistence
│   ├── Onboarding/
│   │   ├── OnboardingCoordinator.swift        # step → view router + slide-up transitions
│   │   ├── OnboardingChrome.swift             # shared header (progress bar) + footer
│   │   ├── WelcomeView.swift                  # step 1
│   │   ├── StageSelectorView.swift            # step 2
│   │   ├── PersonalizationView.swift          # step 3 (skipped for TTC-only)
│   │   ├── TopicsView.swift                   # step 4
│   │   └── PrivacyView.swift                  # step 5
│   └── Home/
│       └── HomeStubView.swift                 # placeholder post-onboarding screen
└── Tests/BloomTests/
    ├── PackageTests.swift                     # smoke test
    └── OnboardingStoreTests.swift             # store mutations, persistence, skip logic
```

## Design tokens

All design tokens are typed Swift constants. Reach for these names —
never raw hex / pt values — so a global tweak stays one line.

### Color (`BloomColor`)

| Token              | Light                  | Dark                   |
| ------------------ | ---------------------- | ---------------------- |
| `background`       | warm cream `#FFF9F4`   | deep umber `#14110F`   |
| `surface`          | white                  | `#1E1A17`              |
| `surfaceElevated`  | `#FFFDFB`              | `#2A2522`              |
| `primary`          | brand pink `#C9527A`   | softer pink `#E07896`  |
| `primarySubtle`    | `#F8DEE6`              | `#3A2027`              |
| `secondary`        | sage `#5E8B7E`         | brighter sage          |
| `secondarySubtle`  | `#DDEAE4`              | `#223330`              |
| `accent`           | warm peach `#E8A87C`   | `#F0B98B`              |
| `textPrimary`      | `#1F1A1C`              | `#F5EFEC`              |
| `textSecondary`    | `#4B4244`              | `#C8BDB9`              |
| `textTertiary`     | `#8A7F82`              | `#8E827E`              |
| `border`           | `#EBE0DC`              | `#352E2B`              |
| `nhsGreen`         | NHS blue `#005EB8`     | brightened `#4A8FD6`   |

### Typography (`BloomFont`)

All built on `Font.system(_:design:weight:)` text styles so every token
scales with iOS Dynamic Type up to Accessibility-XL.

| Token          | Underlying style |
| -------------- | ---------------- |
| `display`      | `.largeTitle` serif semibold |
| `h1`           | `.title` serif semibold      |
| `h2`           | `.title2` serif semibold     |
| `body`         | `.body` regular              |
| `bodyEmphasis` | `.body` semibold             |
| `label`        | `.subheadline` medium        |
| `caption`      | `.caption` regular           |

### Spacing (`BloomSpacing`)

`xxs` 4 · `xs` 8 · `s` 12 · `m` 16 · `l` 20 · `xl` 24 · `xxl` 32 · `xxxl` 48 · `huge` 64
plus `minTapTarget` 44.

### Radii (`BloomRadius`)

`small` 6 · `medium` 12 · `large` 20 · `card` 24 · `pill` 999.

### Shadows (`BloomShadow`)

Use as `.bloomShadow(.card)` / `.button` / `.subtle` — pink-tinted alphas
that read maternal rather than medical.

## File-to-feature map

| Feature concern                          | Where to look |
| ---------------------------------------- | ------------- |
| Reading or mutating saved profile        | `OnboardingStore` |
| Skipping personalization for TTC-only    | `OnboardingStore.shouldSkip(_:)` |
| Stage → recommended topics               | `OnboardingStore.recommendedTopics(for:)` |
| Adding a new design token                | files under `DesignSystem/` |
| Adding a new screen                      | a new view in `Onboarding/`, then a case in `OnboardingStep` and a branch in `OnboardingCoordinator.content` |
| Branching first-run vs returning users   | `BloomRootView` in `App.swift` |
| Adjusting transitions                    | `OnboardingCoordinator.stepTransition` |

## Accessibility

- Every interactive element has a VoiceOver label; CTAs add hints.
- All taps target at least 44pt (`BloomSpacing.minTapTarget` enforced
  by buttons, pills, and the wheel cells).
- Dynamic Type Accessibility-XL is supported: every text token is
  built on a `Font.TextStyle`, and labels avoid `lineLimit(1)` so long
  translations / large sizes wrap instead of truncating.
- Light + dark variants are defined for every color token; views derive
  colors exclusively from `BloomColor`.

## Known follow-ups

- Real Home screen replaces `HomeStubView`.
- Optional Lottie / `Canvas` upgrade for the welcome motif if a richer
  animation budget becomes available.
- `swift test` from the CLI requires a full Xcode install (XCTest is not
  in the bundled Command Line Tools toolchain).
