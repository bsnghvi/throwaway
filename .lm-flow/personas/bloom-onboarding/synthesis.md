# Synthesis: bloom-onboarding

## Unanimous requirements
- Five-step flow with progress indicator visible from step 2 onward
- Skippable personalization step for "Trying to Conceive" users (no week/age input applies)
- Multi-select on the stage screen (parent of an older child while pregnant again is common)
- Dark mode parity from day one — every screen tested in both
- All primary CTAs in lower 40% of screen for one-handed use
- Persistence: backgrounding the app mid-onboarding never loses progress
- 44×44 minimum tap targets

## Tradeoffs to be resolved in spec
- **UX Designer:** Wants a custom animated bloom-petal illustration on the Welcome screen (premium first impression). **Software Engineer:** Worries about an SVG-rendering dependency; suggests an abstract `Canvas`-drawn motif using SF Symbols or basic shapes. **Resolution to be decided by /speckit-specify:** start with a `Canvas`-rendered abstract motif (no asset dep) but design tokens reserve a slot for a Lottie/PNG upgrade in Phase 3.
- **Product Manager:** Wants the topic selection to capture a *minimum of 3* topics to seed content recommendations. **UX Designer:** Hates forced minimums in onboarding; says "users will dishonestly tap whatever." **Resolution:** zero minimum, but show a "Recommended for you" set pre-selected based on stage so the user has a sensible default if they tap through.
- **Head of Sales:** Wants a soft signup-to-newsletter CTA on the Privacy step ("Stay updated on Bloom's roadmap"). **UX Designer:** Strongly opposed; says the Privacy step's role is trust, not capture. **Resolution:** drop the newsletter CTA; keep Privacy clean.

## Acceptance criteria (union)
- All five screens render correctly in light AND dark mode on iPhone 15 Pro
- Multi-select stage: tapping a stage card toggles its selected state; at least one must be selected to proceed
- Personalization step adapts based on selected stages
- Backgrounding the app mid-onboarding then re-opening returns to the same step
- Completing onboarding sets `onboarding.completed = true` and reveals Home (out of scope; show a stub)
- VoiceOver: every interactive element has a label; the flow is navigable end-to-end
- Dynamic Type: scaling to Accessibility XL does not cut off any text or break layouts

## Out of scope (explicit)
- Account creation / authentication (local-first v1)
- Actual chat / content / track / profile screens beyond a placeholder Home view
- Push notifications
- Localization beyond UK English

## User Journeys (required output for downstream validation)

### Journey 1 — First-time user completes onboarding (Pregnant)
**As a** newly-pregnant user **I want to** complete onboarding **so that** Bloom is personalized to my stage and interests.

**Steps:**
1. Launch the app (cold start)
2. Tap "Get started" on Welcome
3. Select "Pregnant" on stage selector; tap Continue
4. Slide the week wheel to 14; pick a due date; tap Continue
5. Tap 5 topic chips (e.g., Morning Sickness, Sleep Training, Birth Preparation, Mental Health, Nutrition); tap Continue
6. Read the 3 privacy promises; tap "Start my journey"

**Success criteria:**
- After completing, the placeholder Home screen is visible
- `@AppStorage` keys reflect: `onboarding.completed=true`, `user.stage="pregnant"`, `user.weekPregnant=14`, `user.topics` contains 5 items
- Force-quit and re-open: lands directly on Home (does not redo onboarding)

### Journey 2 — Returning multi-stage user (Pregnant + has a Toddler)
**As a** user pregnant again with an existing toddler **I want to** select both stages **so that** Bloom mixes content for me.

**Steps:**
1. Tap "Get started"
2. On stage selector, tap "Pregnant" AND "Toddler & Beyond"
3. Continue → Personalization shows BOTH a week wheel (for pregnancy) and a child-age input (for the toddler)
4. Enter 22 weeks pregnant + child age 18 months; Continue
5. Pick topics that span both stages
6. Confirm privacy; finish

**Success criteria:**
- Both stages persisted
- Both inputs collected in the same Personalization step
- Topic list flows in 18+ tags and supports tapping any combination

### Journey 3 — Resume after backgrounding
**As a** distracted parent **I want to** background the app halfway through onboarding **so that** I resume where I left off when I come back.

**Steps:**
1. Start onboarding, get to step 3 (Personalization)
2. Background the app (home gesture)
3. Re-open the app 10 minutes later

**Success criteria:**
- App opens directly to step 3 (Personalization), not step 1
- Stage selection from step 2 is preserved
- Continue/back nav still works correctly

## Brief for /speckit-specify

Build the **Bloom onboarding flow** — a 5-step SwiftUI experience that introduces new users to the app, captures their parenting stage and personalization details, lets them choose topic interests, and confirms Bloom's privacy posture. The flow must feel premium and warm: smooth slide-up transitions between steps, custom design tokens (warm rose, sage green, aubergine, creamy whites), Playfair Display headings paired with DM Sans body. Light AND dark mode must both work day one.

The five steps:
1. **Welcome** — Bloom wordmark, tagline "Your parenthood companion, always listening", a custom `Canvas`-drawn abstract bloom-petal motif (no asset dependencies), and a "Get started" primary button.
2. **Stage selector** — Five large tappable cards: Trying to Conceive, Pregnant, Newborn (0-6 months), Baby (6-24 months), Toddler & Beyond. Multi-select. At least one required to continue.
3. **Personalization** — Adapts based on selected stages. For Pregnant: a horizontal week wheel (1-42) + optional due-date picker. For any post-natal stage: a child age input. For Trying to Conceive: skip to Topics. Multi-stage users see both inputs.
4. **Topics** — A flowing grid of 18+ soft-pill tag chips. Pre-select 3-5 recommended based on stage. User can deselect or add. No minimum required.
5. **Privacy promise** — Three icon+text cards: "Your data never leaves your device", "All answers are sourced from NHS and verified experts", "You can delete everything, anytime." Plus a "Start my journey" CTA.

A persistent progress bar across steps 2-5 (Welcome has no bar). Backgrounding the app at any step preserves position. On completion, `@AppStorage` flag flips and a placeholder Home view is shown.

The spec must include a `## User Journeys` section with the three journeys above — these are the contract for post-merge validation.

Architecture lives at `.lm-flow/architecture/bloom-onboarding.md`. Components are split across `DesignSystem/`, `Components/`, `Models/`, and `Onboarding/`.
