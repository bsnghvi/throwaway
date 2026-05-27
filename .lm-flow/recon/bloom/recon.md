# Recon: Bloom — Flo Health / Motherhood Diaries / NHS reference baseline

## TL;DR
- Bloom is a conversational parenthood companion iOS app for women 22-42 (trying-to-conceive through first 5 years of motherhood)
- Combines NHS-grade authoritative content with Motherhood Diaries lived-experience tone
- Core surface is conversational AI ("Ask Bloom") with cited NHS / Motherhood Diaries sources
- Six core journeys: Onboarding, Today/Home, Conversational AI, Article Reader, Track (symptom logging), Profile
- Design language: warm rose / sage / aubergine palette, Playfair Display + DM Sans, premium soft-rounded aesthetic similar to Flo Health + Linear.app

## Reference products studied
- **Flo Health** (flo.health) — Today home concept, medically-verified content approach, premium dark/light aesthetic, symptom logging UX, week-by-week tracker, "Secret Chats" conversational AI
- **Motherhood Diaries** — content pillars (Preconception, Pregnancy, Labour & Birth, Postnatal Health, Kid's Mental Health), warm community-led voice, lived-experience articles
- **NHS guidance** — gold-standard citation source for medical claims

## Inferred information architecture (5-tab bottom nav)
1. Home — Today's insight, week tracker, explore-by-topic bento grid, recent conversations
2. Chat — conversation list + active chat with cited responses
3. Library — article reader, topic exploration
4. Track — symptom + mood + sleep + baby movement / feeding logger
5. Profile — settings, stage info, conversation/article/log stats

## API surface (anticipated)
| Method | Purpose | Notes |
|---|---|---|
| POST /chat | Generate cited AI response | Returns response text + array of source references (NHS / MD article IDs) |
| GET /content/article/{id} | Article body | NHS or MD-sourced; markdown + metadata + reviewer |
| POST /log/symptom | Log a daily entry | Symptom set, mood, optional note |
| GET /track/calendar | Heat-map data | Days with entries within date range |
| GET /me/profile | Profile + stage + due-date | Initial onboarding writes; profile screen reads |
| POST /me/topics | Save user topics | Subscribed topic tags |

## State & realtime
- No realtime requirements for v1. Chat is request/response. Local-first design: per the brief, "Your data never leaves your device" — local-first state, no analytics phoning home.

## Auth & tenancy
- Single-tenant app per user (per device). No server-side accounts in v1 — local-first. Anonymized opt-in telemetry only if user grants permission later.

## UI/UX patterns worth stealing
- Flo's stage badge in header (e.g., "Week 14 — Second Trimester" in a soft sage pill)
- iMessage-style chat bubbles with a citation footer that expands inline
- Bento-grid topic exploration with warm illustrations / subtle gradients
- Symptom chips with soft-icon + label, tap to toggle on/off
- Heat-map calendar for streak motivation (without gamifying)

## Risks if we copy this
- NHS attribution / fair use — must be careful with how NHS content is reproduced. Citation links + verbatim short excerpts are likely fine; reformatting / paraphrasing risks reputational issues.
- iOS / native: no headless validation possible without iOS Simulator + Xcode. Validate-feature in the flow assumes web; iOS validation will require manual or a separate iOS UI test pipeline.
- Premium aesthetic requires custom illustration, not stock — additional design budget.

## Open questions
- Backend deployment: local-only first (Core Data, no server), or always-on backend for LLM proxy + content delivery? V1 recommendation: local LLM proxy with content packaged in app bundle.
- Localization: UK English primary; brief implies UK focus (NHS). Future English-US adaptation.
- Conversational AI: which LLM provider? Anthropic Claude with NHS + MD content as retrieval corpus is the natural fit.

## Evidence index
- Source: Bloom design brief provided 2026-05-27 (user prompt). Not a live competitor recon — brief is itself the "specification of intent" that recon would normally produce.
