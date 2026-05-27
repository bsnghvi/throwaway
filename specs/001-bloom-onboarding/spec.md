# Feature Specification: bloom-onboarding

**Branch:** `001-bloom-onboarding`
**Status:** Draft
**Architecture:** `.lm-flow/architecture/bloom-onboarding.md`
**Synthesis:** `.lm-flow/personas/bloom-onboarding/synthesis.md`

## Summary

The onboarding flow is the first impression of Bloom. It introduces users to the product, captures their parenting stage and personalization details, lets them pick topic interests, and confirms Bloom's privacy stance. Five screens, slide-up transitions, premium warm aesthetic with full light + dark mode support.

By the end of this feature, the app boots into onboarding on first launch, walks the user through 5 steps with persistent progress (background-safe), and on completion sets a `@AppStorage` flag that future launches respect. Future features (Home, Chat, Library, Track, Profile) will read the onboarding state to personalize content.

## User Journeys

### Journey 1 — First-time user completes onboarding (Pregnant)
**As a** newly-pregnant user **I want to** complete onboarding **so that** Bloom is personalized to my stage and interests.

**Steps:**
1. Cold-launch the app.
2. Tap "Get started" on Welcome.
3. Select "Pregnant" on stage selector; tap Continue.
4. Slide the week wheel to 14; pick a due date; tap Continue.
5. Tap 5 topic chips (e.g., Morning Sickness, Sleep Training, Birth Preparation, Mental Health, Nutrition); tap Continue.
6. Read the 3 privacy promises; tap "Start my journey".

**Success criteria:**
- After completing, the placeholder Home screen is visible.
- `@AppStorage` keys reflect: `onboarding.completed=true`, `user.stage="pregnant"`, `user.weekPregnant=14`, `user.topics` contains 5 items.
- Force-quit and re-open: lands directly on Home (does not redo onboarding).

### Journey 2 — Returning multi-stage user (Pregnant + has a Toddler)
**As a** user pregnant again with an existing toddler **I want to** select both stages **so that** Bloom mixes content for me.

**Steps:**
1. Tap "Get started".
2. On stage selector, tap "Pregnant" AND "Toddler & Beyond".
3. Continue → Personalization shows BOTH a week wheel (for pregnancy) and a child-age input (for the toddler).
4. Enter 22 weeks pregnant + child age 18 months; Continue.
5. Pick topics that span both stages.
6. Confirm privacy; finish.

**Success criteria:**
- Both stages persisted.
- Both inputs collected in the same Personalization step.
- Topic list flows in 18+ tags and supports tapping any combination.

### Journey 3 — Resume after backgrounding
**As a** distracted parent **I want to** background the app halfway through onboarding **so that** I resume where I left off when I come back.

**Steps:**
1. Start onboarding, get to step 3 (Personalization).
2. Background the app (home gesture).
3. Re-open the app 10 minutes later.

**Success criteria:**
- App opens directly to step 3 (Personalization), not step 1.
- Stage selection from step 2 is preserved.
- Continue/back nav still works correctly.

## Functional requirements

FR-1. **Multi-select stage.** The stage selector accepts 1 to 5 selections. "Continue" is disabled until at least one is selected.

FR-2. **Adaptive personalization.** The personalization step shows controls only for the selected stages: pregnancy week wheel (1-42, default 12) + optional due date when "Pregnant" is selected; child age input (months OR years, integer) when any postnatal stage is selected; if only "Trying to Conceive" is selected, this step is skipped entirely.

FR-3. **Topic chips.** At least 18 topics, displayed in a flow-wrap layout. Tapping a chip toggles its selected state. 3-5 are pre-selected based on the stages chosen (stage-to-topic mapping defined in `OnboardingStore.recommendedTopics(for:)`).

FR-4. **Privacy step.** Three promises shown as icon+text cards (data on device, NHS-sourced, deletable). A single primary CTA "Start my journey" completes onboarding.

FR-5. **Progress indicator.** Visible from step 2 onward. Shows a filled bar reflecting `currentStep / 5` width.

FR-6. **Persistence.** Every transition persists `currentStep`, `selectedStages`, `weekPregnant`, `dueDate`, `childAgeMonths`, and `topics` to `@AppStorage`. On app launch, if `onboarding.completed` is true → skip to Home; else resume from saved `currentStep`.

FR-7. **Transitions.** Step-to-step transitions are slide-up (matching iOS, 0.35s ease-out). The progress bar smoothly animates between steps.

FR-8. **Accessibility.** All interactive elements ≥ 44pt tap targets. VoiceOver labels on every button, chip, and card. Dynamic Type supported up to Accessibility XL — no text truncation, no layout breakage.

FR-9. **Color contrast.** All text meets WCAG AA contrast minimum; body text meets AAA.

FR-10. **Dark mode.** Each screen has a fully designed dark variant. Background, surfaces, text colors all derive from the design tokens.

## Non-functional requirements

NFR-1. **Performance.** Cold launch to Welcome screen < 800ms on iPhone 15 Pro. Step transitions < 300ms.

NFR-2. **Code organization.** Source code lives under `bloom-ios/Sources/Bloom/`. Split into `DesignSystem/`, `Components/`, `Models/`, `Onboarding/`.

NFR-3. **No third-party deps.** SwiftUI standard library only. No Lottie, no Swift Package dependencies in v1.

## Persona dissent record

This spec was generated from a multi-persona synthesis. Disagreements resolved:

- **UX Designer vs Software Engineer (Welcome illustration):** Resolved with `Canvas`-drawn abstract motif. No asset dependency now; Phase 3 may upgrade to Lottie if time allows.
- **Product Manager vs UX Designer (minimum topic count):** Resolved with no minimum; pre-select 3-5 based on stage so users tapping through still get a sensible default.
- **Head of Sales vs UX Designer (newsletter CTA on Privacy):** Resolved by dropping the newsletter CTA. Privacy step's role is trust.

Source files:
- Architecture: `.lm-flow/architecture/bloom-onboarding.md`
- Personas synthesis: `.lm-flow/personas/bloom-onboarding/synthesis.md`
- Spec generated 2026-05-27.
