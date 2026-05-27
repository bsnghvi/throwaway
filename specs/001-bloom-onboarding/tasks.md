# Tasks: bloom-onboarding

Each task block follows the schema parseable by the `pgm-sync` skill.

## Phase 1 — Foundation

### T1 — Project scaffold + Swift Package
**Acceptance:** `swift build` succeeds from `bloom-ios/`. `Package.swift` declares an `iOS(.v16)` platform and a single `Bloom` library product.
**Files:** `bloom-ios/Package.swift`, `bloom-ios/README.md`
**Depends on:** none
**Size:** s

### T2 — Design tokens (colors)
**Acceptance:** `BloomColor` provides light + dark variants for: `background`, `surface`, `surfaceElevated`, `primary`, `primarySubtle`, `secondary`, `secondarySubtle`, `accent`, `textPrimary`, `textSecondary`, `textTertiary`, `border`, `nhsGreen`. Compiles. Preview shows a palette grid.
**Files:** `bloom-ios/Sources/Bloom/DesignSystem/BloomColor.swift`
**Depends on:** T1
**Size:** s

### T3 — Design tokens (typography, spacing, radii, shadows)
**Acceptance:** `BloomFont` exposes named text styles (display, h1, h2, body, caption, label). `BloomSpacing` exposes 4-64 pt grid. `BloomRadius` exposes small/medium/large/pill/card. `BloomShadow` exposes warm-tinted card shadow.
**Files:** `bloom-ios/Sources/Bloom/DesignSystem/{BloomFont,BloomSpacing,BloomRadius,BloomShadow}.swift`
**Depends on:** T1
**Size:** s

### T4 — Primitive components: BloomButton, BloomCard
**Acceptance:** Both have variants (primary, secondary, text-only for button) and tap-feedback animation. Each has a preview.
**Files:** `bloom-ios/Sources/Bloom/Components/{BloomButton,BloomCard}.swift`
**Depends on:** T2, T3
**Size:** m

### T5 — Primitive components: pills, progress, wheel, illustration
**Acceptance:** `StagePill`, `TopicPill`, `ProgressBar`, `WheelPicker`, `IllustrationView` all render and have previews. `WheelPicker` uses native SwiftUI `Picker`-style or a custom horizontal `ScrollView` snapping behavior.
**Files:** `bloom-ios/Sources/Bloom/Components/{StagePill,TopicPill,ProgressBar,WheelPicker,IllustrationView}.swift`
**Depends on:** T2, T3
**Size:** m

## Phase 2 — Onboarding flow

### T6 — Models + store
**Acceptance:** `UserStage` is a `CaseIterable` enum with 5 cases. `OnboardingState` is `Codable`. `OnboardingStore` is `ObservableObject`, persists to `@AppStorage`, exposes `advance()`, `back()`, `commit()`, `recommendedTopics(for:)`.
**Files:** `bloom-ios/Sources/Bloom/Models/{UserStage,OnboardingState,OnboardingStore}.swift`
**Depends on:** T1
**Size:** m

### T7 — WelcomeView
**Acceptance:** Renders wordmark + tagline + "Get started" button. Tap advances the store. Preview-passes light + dark.
**Files:** `bloom-ios/Sources/Bloom/Onboarding/WelcomeView.swift`
**Depends on:** T4, T6
**Size:** s

### T8 — StageSelectorView
**Acceptance:** Renders 5 stage cards with icons + labels. Multi-select toggles work. Continue disabled when zero selected. Continue advances the store.
**Files:** `bloom-ios/Sources/Bloom/Onboarding/StageSelectorView.swift`
**Depends on:** T4, T5, T6
**Size:** m

### T9 — PersonalizationView
**Acceptance:** Adapts based on `store.selectedStages`. Pregnant → week wheel + optional due-date picker. Postnatal → child-age input. TryingToConceive only → step is skipped (coordinator skips).
**Files:** `bloom-ios/Sources/Bloom/Onboarding/PersonalizationView.swift`
**Depends on:** T5, T6
**Size:** m

### T10 — TopicsView
**Acceptance:** 18+ topic chips in flow-wrap layout. 3-5 pre-selected per stage. Continue enabled regardless of count.
**Files:** `bloom-ios/Sources/Bloom/Onboarding/TopicsView.swift`
**Depends on:** T5, T6
**Size:** m

### T11 — PrivacyView
**Acceptance:** Three icon+text promise cards. "Start my journey" CTA flips `onboarding.completed`.
**Files:** `bloom-ios/Sources/Bloom/Onboarding/PrivacyView.swift`
**Depends on:** T4, T6
**Size:** s

### T12 — OnboardingCoordinator + App entry
**Acceptance:** App checks `onboarding.completed`. If false, shows `OnboardingCoordinator` which switches view based on `store.currentStep`. If true, shows `HomeStubView`. Step-to-step transitions slide-up.
**Files:** `bloom-ios/Sources/Bloom/{App,Onboarding/OnboardingCoordinator,Home/HomeStubView}.swift`
**Depends on:** T7, T8, T9, T10, T11
**Size:** m

## Phase 3 — Polish

### T13 — Welcome canvas motif + animations
**Acceptance:** Welcome screen has a soft animated bloom-petal motif rendered with `Canvas`. Step transitions are slide-up 0.35s ease-out. Button tap feedback animation.
**Files:** `bloom-ios/Sources/Bloom/Components/IllustrationView.swift`, screen views
**Depends on:** T12
**Size:** m

### T14 — Accessibility pass
**Acceptance:** Every interactive element has a VoiceOver label. Tap targets ≥ 44pt verified. Dynamic Type Accessibility-XL doesn't truncate. Color contrast verified on text in both modes.
**Files:** all screens + components
**Depends on:** T12
**Size:** m

### T15 — README + build-instructions
**Acceptance:** `bloom-ios/README.md` explains how to open in Xcode, how to wire into an iOS app target, the design-token reference, and the implementation map of files-to-features.
**Files:** `bloom-ios/README.md`
**Depends on:** T1
**Size:** s
