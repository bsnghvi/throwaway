# Implementation Plan: bloom-onboarding

**Spec:** `specs/001-bloom-onboarding/spec.md`
**Tasks:** `specs/001-bloom-onboarding/tasks.md`

## Strategy

Three-phase implementation. Phase 1 builds the foundation (project scaffold + design tokens + reusable components) without producing user-visible flow. Phase 2 stacks the five onboarding screens on top and wires the coordinator. Phase 3 polishes (animations, accessibility, dark mode QA).

## Phase 1 — Foundation

Build the project skeleton plus design tokens plus the primitive component library. No actual onboarding screens yet — but every primitive needed by every screen exists and is preview-tested.

Output of phase 1:
- A buildable Swift Package at `bloom-ios/` (`swift build` succeeds on macOS)
- `DesignSystem/` complete: `BloomColor`, `BloomFont`, `BloomSpacing`, `BloomRadius`, `BloomShadow` — all with light + dark variants
- `Components/`: `BloomButton`, `BloomCard`, `StagePill`, `TopicPill`, `ProgressBar`, `WheelPicker`, `IllustrationView`
- Xcode previews for each primitive

## Phase 2 — Onboarding flow

Wire the five screens through an `OnboardingCoordinator`. Persist state via `@AppStorage`. Skipping/showing personalization step driven by stage selection.

Output of phase 2:
- `Models/UserStage.swift`, `Models/OnboardingState.swift`, `Models/OnboardingStore.swift`
- `Onboarding/WelcomeView.swift`, `StageSelectorView.swift`, `PersonalizationView.swift`, `TopicsView.swift`, `PrivacyView.swift`
- `Onboarding/OnboardingCoordinator.swift`
- `App.swift` entry-point that branches between onboarding and placeholder Home
- Persistence behavior matching FR-6

## Phase 3 — Polish

Animations, accessibility, dark mode QA, and the `Canvas`-drawn welcome motif.

Output of phase 3:
- Slide-up transitions between steps (FR-7)
- Welcome screen `Canvas` motif
- VoiceOver labels on every interactive element
- Dynamic Type validated at Accessibility XL
- Both light and dark snapshots produced for every screen

## Files this plan will touch

```
bloom-ios/
  Package.swift                                       (new)
  Sources/Bloom/
    App.swift                                         (new)
    DesignSystem/
      BloomColor.swift                                (new)
      BloomFont.swift                                 (new)
      BloomSpacing.swift                              (new)
      BloomRadius.swift                               (new)
      BloomShadow.swift                               (new)
    Components/
      BloomButton.swift                               (new)
      BloomCard.swift                                 (new)
      StagePill.swift                                 (new)
      TopicPill.swift                                 (new)
      ProgressBar.swift                               (new)
      WheelPicker.swift                               (new)
      IllustrationView.swift                          (new)
    Models/
      UserStage.swift                                 (new)
      OnboardingState.swift                           (new)
      OnboardingStore.swift                           (new)
    Onboarding/
      OnboardingCoordinator.swift                     (new)
      WelcomeView.swift                               (new)
      StageSelectorView.swift                         (new)
      PersonalizationView.swift                       (new)
      TopicsView.swift                                (new)
      PrivacyView.swift                               (new)
    Home/
      HomeStubView.swift                              (new — placeholder)
  README.md                                           (new)
```

## Risks

- iOS-only validation. The `validate-feature` skill expects a web app that can be driven via browser MCP. iOS apps require iOS Simulator + XCUITest — out of scope for this run. Validation will be limited to `swift build` success and manual smoke-test in Xcode by the user.
- `swift build` on the package alone proves compilation; it does not prove the app works as expected in an iOS app target. A real Xcode project (or `swift package init --type executable` with an iOS app product) is needed for the user to run it on Simulator.
- Phase 3 polish may exceed time budget; defer the welcome `Canvas` motif if needed.
