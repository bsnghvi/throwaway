# Architecture: bloom-onboarding

## TL;DR
- Five-step onboarding flow for new Bloom users; collects life stage, personalization details (pregnancy week or child age), interests, and confirms data-privacy stance
- Stack: SwiftUI (iOS 16+), no third-party deps in v1, persistent state via `@AppStorage` + a lightweight `OnboardingStore` `ObservableObject`
- Premium feel: hero animations on welcome, smooth multi-step transitions, design-token-driven aesthetic
- Output: an `OnboardingResult` value (`UserStage`, optional pregnancy week / child age, set of topic interests) that bootstraps the Home screen via `AppCoordinator`

## Inputs
- Recon: `.lm-flow/recon/bloom/recon.md`
- Brief: Five onboarding screens (Welcome → Stage → Personalization → Topics → Privacy) all premium-feeling, warm palette, supports multi-select on stage, optional follow-ups based on stage
- Constraints:
  - SwiftUI only, no UIKit
  - iOS 16+ deployment target
  - All design tokens defined as `Color` / `Font` / spacing constants in `DesignSystem/`
  - Dark mode must work day one
  - 44×44 minimum tap targets (accessibility)
  - One-handed reachability: primary CTAs in bottom 40%

## Component diagram

```
flowchart TD
  OC[OnboardingCoordinator]
  WL[WelcomeView]
  SS[StageSelectorView]
  PV[PersonalizationView]
  TV[TopicsView]
  PR[PrivacyView]
  OC -->|step 1| WL
  OC -->|step 2| SS
  OC -->|step 3| PV
  OC -->|step 4| TV
  OC -->|step 5| PR
  WL --> OC
  SS --> OC
  PV --> OC
  TV --> OC
  PR -->|completes| OS[(OnboardingStore)]
  OS --> AC[AppCoordinator]
```

## Components

### DesignSystem (foundation)
- **Responsibility:** Expose Bloom palette, typography, spacing, radii, shadows as Swift constants — light + dark variants — used by every view.
- **Lives at:** `bloom-ios/Sources/Bloom/DesignSystem/`
- **Mirrors:** new ground (no existing system)
- **Depends on:** SwiftUI only
- **Surface:** `BloomColor`, `BloomFont`, `BloomSpacing`, `BloomRadius`, `BloomShadow` namespaces

### Components/Primitives (reusable building blocks)
- **Responsibility:** `BloomButton` (primary/secondary/text/icon variants), `BloomCard`, `StagePill`, `TopicPill`, `ProgressBar`, `WheelPicker` (week selector), `IllustrationView` (abstract bloom motif)
- **Lives at:** `bloom-ios/Sources/Bloom/Components/`
- **Depends on:** DesignSystem

### Models
- **Responsibility:** `UserStage` enum (5 cases), `OnboardingState` struct, `OnboardingStore` `ObservableObject`
- **Lives at:** `bloom-ios/Sources/Bloom/Models/`

### Onboarding screens (one per step)
- `WelcomeView`, `StageSelectorView`, `PersonalizationView`, `TopicsView`, `PrivacyView`
- Each: a SwiftUI `View` that observes the store, renders the step, calls `store.advance()` / `store.commit()` to progress
- **Lives at:** `bloom-ios/Sources/Bloom/Onboarding/`

### OnboardingCoordinator
- **Responsibility:** `View` that observes `OnboardingStore.currentStep` and switches to the right screen; handles slide-up transition between steps
- **Lives at:** `bloom-ios/Sources/Bloom/Onboarding/OnboardingCoordinator.swift`

### AppCoordinator (entry)
- **Responsibility:** Top-level `App.swift` checks if onboarding is complete; if not, shows `OnboardingCoordinator`; otherwise shows `HomeView` (out-of-scope for this feature — stub for now)
- **Lives at:** `bloom-ios/Sources/Bloom/App.swift`

## Data model
- Persisted to `@AppStorage` (UserDefaults under the hood) — no Core Data needed for v1:
  - `onboarding.completed: Bool`
  - `user.stage: String` (UserStage rawValue)
  - `user.weekPregnant: Int?`
  - `user.dueDate: Date?`
  - `user.childAgeMonths: Int?`
  - `user.topics: [String]` (encoded as JSON in a single key)

## External integrations
None for onboarding. (Future features will introduce LLM proxy + content APIs; not in scope here.)

## Sync vs async
All sync — no network calls in onboarding. Future stages bring in async chat / content APIs.

## Failure modes
- User backgrounds the app mid-onboarding → resume from last completed step (persist `currentStep` to `@AppStorage`)
- User force-quits without completing → onboarding shows from step 1 on next launch
- Selected stage is "Trying to Conceive" → no personalization-step inputs other than topic interests
- Multi-select stage (e.g., Pregnant + Toddler) → personalization step shows both inputs

## Test strategy
- Unit tests: `OnboardingStore` state transitions
- Snapshot tests: each onboarding screen in light + dark mode
- UI test: full onboarding flow happy path

## Phasing

### Phase 1 — Foundation
- Goal: Design tokens + component library skeleton + project scaffold
- Success criterion: `swift build` succeeds; design-token reference document renders in a preview

### Phase 2 — Onboarding flow
- Goal: Five screens wired through `OnboardingCoordinator`, persistence via `@AppStorage`, transitions between steps
- Success criterion: Run app in iOS Simulator; complete onboarding once and reopen — should skip to placeholder Home

### Phase 3 — Polish
- Goal: Animations (welcome motif, step transitions, button feedback), accessibility (VoiceOver, Dynamic Type), dark-mode pass
- Success criterion: VoiceOver-driven full flow completion; Dynamic Type at Accessibility-XL doesn't break any layout

## Open questions for the spec phase
- Multi-select stage UX: do we want a "primary stage" within the multi-select for content prioritization?
- Privacy step copy — the brief specifies three promises; do we want a fourth around "no advertising"?
- Topic selection minimum: zero allowed (just take defaults), or must select at least one?

## Evidence
- `.lm-flow/recon/bloom/recon.md`
- Bloom design brief (user prompt, 2026-05-27)
