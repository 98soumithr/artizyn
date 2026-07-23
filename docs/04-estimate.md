# Estimate — Artizyn

**Basis:** system model v1.0, spec v1.1 (**not yet signed**)
**Track:** F
**Prepared by:** Soumith
**Date:** {{date}}

Sizes per process additions §3. **S = 0.5d** single entity, CRUD or read-only view, no integration · **M = 1.5d** multiple entities, derived values, or non-trivial state · **L = 3d** cross-domain, external integration, or complex permission logic.

XL is not a size. Every capability below is S, M or L; anything that would have been XL was split.

---

## 1. Capabilities

### Identity

| Capability | Size | Days | Note |
|---|---|---|---|
| Signup, login, logout, email confirmation, password reset | M | 1.5 | Supabase Auth handles the primitives; three user types and the post-signup routing to tier selection are ours |
| Profile records for artisan, client, syndic | S | 0.5 | Three thin tables over `profiles` |
| Permission layer — acting profile plus effective artisan resolution | L | 3 | Cross-cutting. Every artisan-scoped endpoint depends on it. Collaborator scoping is the complexity. |
| Collaborator invitation, acceptance, revocation | M | 1.5 | Token lifecycle, email, orphan `profile_id` until acceptance |
| Account suspension and its public-surface effects | S | 0.5 | Status flag; the surfaces read it |
| Row-level security policies | M | 1.5 | Second enforcement layer per NFR. Written once, tested per table. |
| **Subtotal** | | **8.5** | |

### Subscription

| Capability | Size | Days | Note |
|---|---|---|---|
| Stripe checkout session, three tiers, redirect flow | L | 3 | External integration. Hosted checkout keeps card data out of scope. |
| Webhook receipt, signature verification, state transitions | L | 3 | The reliability-critical piece. Idempotency, out-of-order events, replay. |
| Tier ceiling resolution — pure function, nine consumers | S | 0.5 | Small but must be the single owner (model §5) |
| Tier change and cancellation with effective dates | M | 1.5 | Proration is Stripe's; surfacing the effective date is ours |
| Payment-failure state and visibility suppression | M | 1.5 | AC-06. Touches every public surface. |
| Daily reconciliation sweep against Stripe | M | 1.5 | Covers webhooks that never arrive |
| Trial capability, built unused | S | 0.5 | Configured, switchable without a change request |
| **Subtotal** | | **11.5** | |

### ArtisanProfile

| Capability | Size | Days | Note |
|---|---|---|---|
| Company details, bio, SIRET, public profile page | M | 1.5 | |
| Trade selection with tier ceiling enforcement | M | 1.5 | AC-08. Reads Subscription's function. |
| Photo upload, ordering, tier ceiling enforcement | M | 1.5 | Supabase Storage, AC-09 |
| Commune and postal code capture, geocoding to coordinates | L | 3 | External integration. Failure must block save (AC-10 depends on coordinates existing). |
| Radius with tier ceiling | S | 0.5 | AC-10 |
| Declared badges | S | 0.5 | AC-11, declarative only |
| **Subtotal** | | **8.5** | |

### Availability

| Capability | Size | Days | Note |
|---|---|---|---|
| Availability blocks — create, delete, overlap predicate, public display | M | 1.5 | AC-12, all tiers |
| **Subtotal** | | **1.5** | |

### Demand

| Capability | Size | Days | Note |
|---|---|---|---|
| Project creation with photos, geocoding, secondary trade | M | 1.5 | |
| Edit at any time, edited marker, responder notification | M | 1.5 | AC-20. Notification fan-out on every edit. |
| Cancellation and its effect on artisan dashboards | S | 0.5 | AC-21 |
| Artisan selection, status transition, proposal lockout | M | 1.5 | AC-22. Transactional guard against the race in model §2. |
| Completion by artisan, and 14-day auto-close job | M | 1.5 | AC-24, AC-25. Scheduled task plus DST-correct arithmetic. |
| Client project list and detail views | S | 0.5 | |
| **Subtotal** | | **7** | |

### Matching

| Capability | Size | Days | Note |
|---|---|---|---|
| The matching rule — haversine, four conditions, secondary trade | L | 3 | The product. Single implementation, single owner. |
| `project_artisans` population and counters | M | 1.5 | AC-18, AC-18b |
| Zero-match detection and client notice | S | 0.5 | AC-14c |
| Re-evaluation sweep on artisan registration or change | L | 3 | AC-14d. Transactional status re-read; must not fire on cancelled projects. Indexing matters here. |
| Proposal submission with status guard | M | 1.5 | AC-19, uniqueness constraint |
| Artisan dashboard project list | S | 0.5 | |
| **Subtotal** | | **10** | |

### Messaging

| Capability | Size | Days | Note |
|---|---|---|---|
| Conversations scoped to project or offer, with the either-or constraint | M | 1.5 | |
| Messages, read state, thread view both sides | M | 1.5 | AC-37 |
| Attachments — upload, type and size validation, retrieval | M | 1.5 | AC-38, 10MB, images and PDF |
| Contact-detail disclosure predicate in every profile serialiser | L | 3 | AC-17, AC-23. Cross-cutting, revenue-critical, API-level enforcement per NFR. |
| **Subtotal** | | **7.5** | |

### Reputation

| Capability | Size | Days | Note |
|---|---|---|---|
| Review eligibility predicate and submission | M | 1.5 | AC-27, AC-28, AC-29. Three conditions, one owner shared with the invitation email. |
| Rating aggregate recalculation | S | 0.5 | Recalculated, not incremented (model §2) |
| Right of reply | S | 0.5 | AC-30, single response |
| Public display on profile, search cards, offer cards | S | 0.5 | AC-31 |
| Admin deletion with aggregate recalculation | S | 0.5 | AC-51 |
| **Subtotal** | | **3.5** | |

### Marketplace

| Capability | Size | Days | Note |
|---|---|---|---|
| Offer CRUD with tier ceiling and photo limit | M | 1.5 | AC-32, AC-33, AC-34 |
| Offer visibility tied to subscription state | S | 0.5 | AC-36 |
| Offer browse, filter by trade, city, price, rating | M | 1.5 | AC-35 |
| Artisan search with filters | M | 1.5 | AC-43 |
| Ranking function — banner selection, tier-80 positions, rating order, rotation | L | 3 | AC-44, AC-45, AC-46. Single implementation for banner and list (model §5). |
| Public artisan detail page | S | 0.5 | |
| Homepage | S | 0.5 | |
| **Subtotal** | | **9** | |

### Notification

| Capability | Size | Days | Note |
|---|---|---|---|
| Outbox table, transactional write, async dispatch, retry | L | 3 | Reliability foundation. Prevents an email outage rolling back a publication. |
| Ten immediate email types with French templates | M | 1.5 | Content from D-24; assembly and dispatch ours |
| Daily digest batching, 07:00 Paris, DST-correct | M | 1.5 | AC-18c. Since-last-dispatch, not since-midnight. |
| Review reminder scheduling with suppression | S | 0.5 | AC-26 |
| **Subtotal** | | **6.5** | |

### Reporting

| Capability | Size | Days | Note |
|---|---|---|---|
| Admin dashboard — artisans by tier, project and offer counts | S | 0.5 | AC-49 |
| Revenue read from Stripe | M | 1.5 | AC-49. External read, cached, never recomputed locally. |
| Matching volume mean and median by tier, rolling 30 days | M | 1.5 | AC-49b |
| Unmatched project list | S | 0.5 | AC-49c |
| Artisan dashboard aggregates | S | 0.5 | AC-47 |
| Support ticket list | S | 0.5 | |
| **Subtotal** | | **5** | |

### Cross-cutting delivery

| Capability | Size | Days | Note |
|---|---|---|---|
| PDF export for quotes and invoices | M | 1.5 | AC-48, tier 80+ |
| French localisation — all UI, emails, errors, dates, currency | M | 1.5 | AC-53. Content from D-22 to D-25; wiring and review ours. |
| Mobile responsive across all pages | L | 3 | AC-52. Every page, not a pass at the end. |
| Accessibility AA on the three named journeys | M | 1.5 | NFR. Signup, project publication, messaging. |
| Legal pages, robots.txt, sitemap | S | 0.5 | AC-54; text supplied by client |
| Time and period semantics — UTC storage, Paris display, DST-safe scheduling | M | 1.5 | Model §4. Written once, consumed everywhere. |
| **Subtotal** | | **9.5** | |

---

## 2. Capability subtotal

| Domain | Days |
|---|---|
| Identity | 8.5 |
| Subscription | 11.5 |
| ArtisanProfile | 8.5 |
| Availability | 1.5 |
| Demand | 7 |
| Matching | 10 |
| Messaging | 7.5 |
| Reputation | 3.5 |
| Marketplace | 9 |
| Notification | 6.5 |
| Reporting | 5 |
| Cross-cutting delivery | 9.5 |
| **Subtotal** | **88 days** |

---

## 3. Multipliers

Applied to the capability subtotal only, per process additions §3.

| Factor | Multiplier | Justification | Applies |
|---|---|---|---|
| Stack the team has not shipped before | ×1.4 | **Depends on the Phase 2 decision.** Not applied in the baseline; see §7 for the per-option delta. | Conditional |
| External integration with docs we have not read | +1 day each | Stripe Subscriptions, Supabase Auth, Supabase Storage, transactional email provider, geocoding provider = 5 | **+5 days** |
| Client's team maintains after handoff | ×1.15 | Confirmed. Documentation burden falls on us at Phase 7 and the stack must be one they can operate. | **×1.15** |
| Client has more than two approvers | ×1.2 | Unknown — no signatory identified (D-26). Not applied. | Not applied |
| Compliance requirement | ×1.3 | RGPD applies but is not GDPR-heavy: no health data, no card data stored, no cross-border transfer. Not applied. | Not applied |

**Calculation**

```
Capability subtotal                88.0
+ integrations (5 × 1 day)          5.0
                                   ─────
                                   93.0
× 1.15 (client maintains)          107.0  (106.95, rounded)
```

**Adjusted capability total: 107 days**

---

## 4. Fixed phase costs

Track F, per process additions §3.

| Phase | Days | Status |
|---|---|---|
| 0 Intake | 1 | Spent |
| 1 Spec | 2 | Spent |
| 1.5 System model | 1 | Spent |
| 2 Architecture / ADR | 1 | Pending |
| 3 Harness setup | 0.5 | Pending |
| 4 Scenarios | 2 | Pending |
| 6 Verification | 1 | Pending |
| 7 Handoff | 1.5 | Pending |
| 8 Harness feedback | 0.25 | Pending |
| **Subtotal** | **10.25** | 4 spent, 6.25 remaining |

Phase 5 is not a fixed cost — it is the capability total in §3.

**Note on Phase 4.** Two days is the process default. With 61 acceptance criteria, three test directories, and risk-weighted holdout depth on money, permissions and deletion, this is optimistic. Flagged rather than adjusted, since changing the process defaults belongs in Phase 8 calibration, not here.

**Note on Phase 6.** One day covers one verification pass. Eleven domains built as eleven features means several passes. Realistically 2–3 days. Same treatment — flagged, not silently inflated.

---

## 5. Contingency

20% on Track F, applied to capability total plus fixed phases.

```
107.0 + 10.25 = 117.25
× 0.20        =  23.45
```

**Contingency: 23.5 days**

This is not padding. It covers the 25 assumptions in spec §8 being wrong, and the client has seen every one with its cost attached. The largest single exposures:

| Assumption | If wrong |
|---|---|
| Collaborators are logins, not displayed names | ±3 days |
| Trade matching is exact plus client-nominated secondary | +2 days for an adjacency table |
| Straight-line distance is acceptable | +2 days and a recurring cost for drive-time |
| No automatic tier-downgrade enforcement | +2 days |
| No review dispute process | +2 days |
| Notifications are email only | +3 days for real-time |

---

## 6. Total

| Component | Days |
|---|---|
| Capabilities, adjusted | 107.0 |
| Fixed phase costs | 10.25 |
| Contingency (20%) | 23.5 |
| **Total** | **140.75 → 141 days** |

**At 5 working days per week: 28 working weeks.**

---

## 7. Per stack option

Handbook requires the estimate presented per stack option, so it can inform the ADR rather than follow it. Deltas apply to the capability subtotal before multipliers.

| Option | Capability delta | Adjusted total | Grand total | Note |
|---|---|---|---|---|
| **A — Next.js + TypeScript** | baseline | 107 | **141 days** | Assumes the team ships this already. If not, ×1.4 applies: 150 adjusted, **200 days** |
| **B — Django + HTMX** | +6 | 114 | **149 days** | Server-rendered; more work on the interactive surfaces (search filters, messaging, dashboards). Client's maintainer capability matters more than the 6 days. |
| **C — Vanilla JS SPA (as the brief proposed)** | +22 | 132 | **171 days** | No framework means hand-rolling routing, state, forms, validation, and rendering across 20-plus screens. **Not recommended.** The maintenance position after handoff is materially worse and the ×1.15 documentation multiplier understates it. |

The ×1.4 unfamiliar-stack multiplier is the single largest swing in this document — 59 days between a stack the team ships and one it does not. That is the question the ADR turns on, and it is a fact about your team, not about the frameworks.

---

## 8. Against the client's timeline

The brief asks for production-ready at end of week 10.

| | Weeks |
|---|---|
| Client's timeline | 10 |
| This estimate, one developer | 28 |
| This estimate, two developers on parallelisable work | 17–19 |

Ten weeks is not achievable for the signed scope at any plausible team size. The model's build order has hard sequencing — Matching cannot start before ArtisanProfile and Demand; Marketplace ranking cannot start before Reputation — so throwing people at it has limited effect.

**Three honest paths:**

**Extend.** 28 weeks single-developer, or 17–19 with two. This is the number to put in front of the client.

**Cut to a phase-one scope.** Direction 1 only — clients post, artisans respond, messaging, reviews, subscriptions. Defer the entire Marketplace domain (offers, browse, ranking, banner), collaborators, PDF export, and the reporting beyond basic stats. Rough recalculation: capabilities fall to about 62 days, total near **100 days, 20 weeks**. Still not ten, and the tier ladder loses its top two features.

**Reduce the tier structure.** Much of Subscription and every ceiling enforcement point exists to support three tiers. A single-price launch removes roughly 8 days directly and simplifies twelve enforcement points. Commercially unattractive, but it is the cheapest real reduction available.

**What I would put to the client:** the two-way marketplace at 28 weeks, or Direction 1 at 20 weeks with Direction 2 as a priced phase two. Ten weeks with this scope means either the scope moves or the date does.

---

## 9. Excluded

- Everything in spec §3, Périmètre explicitement exclu — 16 items
- Change requests under process additions §2
- Post-launch support beyond the agreed warranty period
- Delay caused by outstanding client dependencies — see `05-dependencies.md`, none of the 36 items yet received
- Content production: French copy, legal text, brand assets, tier comparison wording (D-14 to D-25)
- Hosting, Stripe fees, geocoding and email provider costs — client's recurring spend
- Marketplace seeding, artisan recruitment, go-to-market

---

## 10. Dependent on

Copied from spec §8. If one breaks, this estimate breaks — and the client has seen which.

The six largest exposures are tabulated in §5. Beyond those, the estimate assumes:

- All 36 client dependencies arrive on the needed-by dates in `05-dependencies.md`. **None have been requested yet.** Legal text (D-14 to D-17) is the classic cause of a finished build sitting undeployed.
- Geocoding and email providers are chosen at Phase 2, not discovered at Phase 5
- The matching rule (AC-14) survives client confirmation unchanged. It is the largest single capability and Phase 4 freezes it into tests.
- The eight ambiguities in system model §6 are resolved before Phase 4

---

## 11. At close

Record actual against estimate per capability in the house calibration file within one week of delivery.

This is the first project using these multipliers, so every number above is borrowed. The ×1.15 maintenance multiplier and the S/M/L day values in particular are process defaults, not ours. After five projects they become ours, and the handbook is right that this is the single highest-value thing available for margin.

**Specific items to check at close:** whether Phase 4 at 2 days was realistic against 61 ACs, whether Phase 6 at 1 day survived eleven domains, and whether the L = 3 days sizing held for the four genuinely cross-domain capabilities — the permission layer, the matching rule, the re-evaluation sweep, and contact-detail disclosure.
