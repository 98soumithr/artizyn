# System model — Artizyn

Derived from spec v1.1.
**Spec status: not yet signed.** Decisions taken under delegated authority from the client; specification pending written confirmation. If the matching rule (AC-14) or the tier rules change on confirmation, §2, §3 and §5 need rework.

---

## 1. Domain map

Nine domains. A screen is not a domain — several capabilities the brief presented as features are views over a domain that owns the data.

| Domain | Capabilities it owns | Views that consume it |
|---|---|---|
| **Identity** | Account creation, authentication, email confirmation, password reset, profile records, account suspension, collaborator invitation and revocation, permission resolution | Every authenticated page; admin moderation screen |
| **Subscription** | Tier state, Stripe customer and subscription records, checkout sessions, webhook reconciliation, payment-failure state, tier-limit resolution, trial capability | Artisan subscription page; every tier-limited action; admin revenue panel |
| **ArtisanProfile** | Company details, bio, SIRET, trades held, photos, declared badges, commune and postal code, service radius, geocoded coordinates | Public artisan page; search results; featured banner; offer cards; proposal display |
| **Availability** | Availability blocks per artisan | Public artisan page; artisan dashboard |
| **Demand** | Projects, project photos, secondary trade, edit and cancel lifecycle, selection of an artisan, completion state and auto-close, zero-match state | Client project list; project detail; artisan dashboard; admin unmatched list |
| **Matching** | The single matching rule; `project_artisans` rows; recipient and response counters; re-evaluation of unmatched projects on artisan change | Artisan dashboard; project detail counters; admin volume metrics |
| **Marketplace** | Offers, offer photos, offer lifecycle and visibility, search and filter over artisans and offers, result ranking, featured banner selection and rotation | Offers list; offer detail; artisan search; homepage |
| **Messaging** | Conversations, messages, attachments, read state, contact-detail disclosure on selection | Client and artisan inboxes; project detail; offer detail |
| **Reputation** | Reviews, right of reply, rating average and count, review eligibility, admin review deletion | Public artisan page; search results; offer cards; artisan dashboard; admin |
| **Notification** | Email composition and dispatch, daily digest batching, reminder scheduling, delivery retry | No UI — consumed by every domain |
| **Reporting** | Admin aggregate metrics: artisans by tier, revenue, project and offer counts, matching volume by tier, unmatched projects | Admin dashboard only |

Eleven, not nine. **Notification and Reporting are read-only consumers** — they own no entity another domain writes and exist to prevent every other domain composing its own emails and computing its own totals.

**Explicitly not domains:**

- *Artisan dashboard* — a view over Matching, Demand, Reputation, Subscription
- *Admin dashboard* — a view over Reporting
- *Weekly digest email* — a view over Notification
- *Featured banner* — a capability of Marketplace, not a thing of its own
- *Tier limits* — resolved by Subscription and enforced at each writer, never re-derived

---

## 2. Entity read/write map

R = reads · W = writes · RW = both. Blank = no access.

Columns abbreviated: Id=Identity, Sub=Subscription, AP=ArtisanProfile, Av=Availability, Dem=Demand, Mat=Matching, Mkt=Marketplace, Msg=Messaging, Rep=Reputation, Not=Notification, Rpt=Reporting.

| Entity | Id | Sub | AP | Av | Dem | Mat | Mkt | Msg | Rep | Not | Rpt |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `users` | W | | | | | | | | | | |
| `profiles` | W | | R | | R | R | R | R | R | R | R |
| `artisans` | R | **W** | **W** | | | R | R | R | **W** | R | R |
| `skills` | | | R | | R | R | R | | | | R |
| `artisan_skills` | | R | W | | | R | R | | | | |
| `artisan_photos` | | R | W | | | | R | | | | |
| `collaborators` | W | R | | | | | | R | | R | R |
| `availability_blocks` | | | | W | | | R | | | | |
| `clients` | W | | | | R | | | R | R | | |
| `syndics` | W | | | | R | | | R | R | | |
| `projects` | | | | | **W** | **W** | | R | R | R | R |
| `project_photos` | | | | | W | | | | | | |
| `project_artisans` | | | | | R | W | | | | R | R |
| `proposals` | | | | | R | **W** | | R | | R | R |
| `offers` | | R | R | | | | W | R | | | R |
| `offer_photos` | | | | | | | W | | | | |
| `conversations` | | | | | R | | R | W | | R | R |
| `messages` | | | | | | | | W | | R | R |
| `reviews` | | | | | R | | | | W | R | R |
| `support_tickets` | R | | | | | | | | | R | R |

### Single writer, multiple readers — shared services

These are the values every other domain must read rather than compute. Each is a candidate for a service module named in `AGENTS.md`.

| Entity / value | Sole writer | Readers |
|---|---|---|
| `artisan_skills`, `artisan_photos` | ArtisanProfile | Subscription (limit checks), Matching, Marketplace |
| `artisans.subscription_tier`, `subscription_status` | Subscription | ArtisanProfile, Marketplace, Matching, Reporting |
| `artisans.latitude`, `longitude`, `service_radius_km` | ArtisanProfile | Matching only |
| `artisans.rating_average`, `rating_count` | Reputation | ArtisanProfile, Marketplace, Reporting, artisan dashboard |
| `project_artisans` | Matching | Demand, Notification, Reporting |
| `availability_blocks` | Availability | Marketplace |
| `offers` | Marketplace | Subscription (limit checks), Messaging |
| `conversations`, `messages` | Messaging | Notification, Reporting |
| `reviews` | Reputation | Demand, Notification, Reporting |

### Multiple writers — consistency risks

Three entities have more than one writer. Each is a real risk, not a formality.

**`artisans` — written by Subscription, ArtisanProfile, and Reputation.**

Three domains write disjoint column groups: Subscription owns tier and Stripe state, ArtisanProfile owns company and geographic fields, Reputation owns the rating aggregates.

*Concrete failure:* a Stripe webhook downgrades `subscription_tier` to `t35` at the same moment the artisan saves a profile edit that includes `service_radius_km = 80`. A naive full-row update from either side reverts the other's write. Radius 80 on tier `t35` violates AC-10 and the record is now invalid with nothing to detect it.

*Fix:* column-scoped updates only — each domain updates its own columns and never writes a whole row. Enforce as an `AGENTS.md` hard rule naming the column groups. Rating aggregates additionally recalculated from `reviews` rather than incremented, so a lost update self-heals on the next review.

**`projects` — written by Demand and Matching.**

Demand owns the lifecycle: status, selection, completion, edit and cancel. Matching writes `zero_match_notified_at` only.

*Concrete failure:* a client cancels a project in the same moment the matching re-evaluation sweep (AC-14d) finds a newly-registered artisan covering it. The sweep writes `zero_match_notified_at`, creates `project_artisans` rows, and queues a client email about a project that no longer exists. The artisan sees a cancelled job in their dashboard.

*Fix:* the re-evaluation sweep re-reads `projects.status` inside the same transaction as its writes and skips anything not `open`. Matching's write scope on `projects` is exactly one column, stated as a rule.

**`proposals` — written by Matching, read by Demand and Messaging.**

Listed as Matching's write because proposal creation is gated on the matching relationship: a proposal is only valid if a `project_artisans` row exists and `projects.status` is `open`.

*Concrete failure:* two artisans submit proposals as the client selects a third. Without a guard, proposals arrive against an `in_progress` project, violating AC-22, and the client sees offers she can no longer act on.

*Fix:* proposal creation validates project status inside the transaction that inserts. Unique constraint on `(project_id, artisan_id)` already prevents duplicate submissions.

### Ambiguity in the grid

`proposals` sitting under Matching rather than Demand is the call I'm least sure of. The argument for Matching: creation is gated on the matching relationship and status, so the invariant lives there. The argument for Demand: a proposal is part of a project's lifecycle and Demand already owns that lifecycle.

**This is the row to review.** If it belongs to Demand, the dependency direction between Demand and Matching inverts and §3 changes.

---

## 3. Dependency graph

Domain level only.

- **Subscription** depends on **Identity** — a subscription belongs to an authenticated artisan profile
- **ArtisanProfile** depends on **Identity** — profile fields hang off a `profiles` row
- **ArtisanProfile** depends on **Subscription** — trade count, photo count and radius ceiling are all tier-derived (AC-08, AC-09, AC-10)
- **Availability** depends on **Identity** — blocks belong to an artisan
- **Demand** depends on **Identity** — a project has an author profile
- **Matching** depends on **ArtisanProfile** — needs coordinates, radius and trades
- **Matching** depends on **Demand** — needs a published project with coordinates and trade
- **Matching** depends on **Subscription** — only active subscriptions receive (matching rule condition 1)
- **Marketplace** depends on **ArtisanProfile** — search and cards render profile data
- **Marketplace** depends on **Subscription** — offer count limits, ranking tier, banner eligibility, visibility on lapse
- **Marketplace** depends on **Reputation** — ranking sorts on rating average; cards display it
- **Marketplace** depends on **Availability** — profile pages show availability
- **Messaging** depends on **Demand** — a project-scoped conversation needs a project
- **Messaging** depends on **Marketplace** — an offer-scoped conversation needs an offer
- **Messaging** depends on **Demand** for contact disclosure — reads `selected_artisan_id` to decide whether contact details unlock (AC-23)
- **Reputation** depends on **Demand** — review eligibility reads project status, author, and selected artisan
- **Notification** depends on **every** domain that emits an event
- **Reporting** depends on **every** domain that holds a countable

**Cycles:** none at domain level.

Two near-cycles worth naming:

*Marketplace → Reputation → Demand → Identity.* Long but acyclic. Marketplace never writes anything Reputation reads.

*ArtisanProfile ⇄ Subscription* is the one that looks circular and is not. ArtisanProfile reads tier to resolve limits; Subscription reads `artisan_id` to attach Stripe records. Both write `artisans`, disjoint columns. Direction is ArtisanProfile → Subscription for limit resolution; nothing flows back. Tier limits must be a pure function exposed by Subscription, taking a tier and returning ceilings. If ArtisanProfile ever hard-codes `t35 → 1 trade`, the boundary is broken and the cycle becomes real.

### Build order (topological)

```
1. Identity                    — auth, profiles, collaborators, permissions
2. Subscription                — Stripe, tier state, limit resolution
3. ArtisanProfile              — company data, trades, photos, geocoding, radius
4. Availability                — independent once ArtisanProfile exists
5. Demand                      — projects, photos, edit/cancel, selection, completion
6. Matching                    — the rule, project_artisans, counters, re-evaluation
7. Messaging                   — conversations, messages, attachments, disclosure
8. Reputation                  — reviews, right of reply, rating aggregates
9. Marketplace                 — offers, search, ranking, featured banner
10. Notification               — email, digest batching, reminders
11. Reporting                  — admin aggregates
```

**Parallelisable after Identity and Subscription land:** Availability alongside ArtisanProfile; Demand alongside ArtisanProfile.

**Not parallelisable:** Matching after both ArtisanProfile and Demand. Marketplace after Reputation, since ranking sorts on rating. Reporting last — it reads everything.

**Notification is deliberately late but referenced throughout.** Every earlier domain emits events; a stub interface exists from Identity onward and the real implementation lands at step 10. Building it early means rewriting it as each domain's event needs emerge.

---

## 4. Cross-cutting concerns

### Authentication and permissions

Applies. Single definition, no exceptions.

Every request resolves to an **acting profile** and, for artisan-scoped requests, an **effective artisan account**. For a titulaire these are the same artisan. For a collaborator, the acting profile is the collaborator and the effective artisan is their employer.

Authorisation asks two questions in order, at every endpoint:

1. Does the acting profile have access to the effective artisan account?
2. Is this action permitted to this profile's `user_type`?

**Collaborators are refused** subscription management, tier changes, cancellation, collaborator invitation and removal, and review responses (AC-41, AC-30). Everything else an artisan may do, they may do.

Tenancy is never read from the request body. An artisan ID arriving in a payload is treated as an assertion to verify, never a fact. Stated as an `AGENTS.md` hard rule.

Suspension (`profiles.status = suspended`) removes the artisan from all public surfaces — search, banner, offers, profile page — while leaving authenticated access intact (AC-50).

### Time periods and timezones

Applies, and it is the concern most likely to produce inconsistent numbers if left loose.

**Single definition, used by every capability without exception:**

- All timestamps stored in UTC, `timestamptz`
- All timestamps displayed in **Europe/Paris**, format `JJ/MM/AAAA`, including in emails
- **Auto-close** (AC-25): 14 days measured from `projects.selected_at`, evaluated in UTC. A project selected at 23:30 Paris on 1 March auto-closes on 15 March, not 16 — the boundary is 14×24 hours, not calendar days
- **Review reminder** (AC-26): 7 days from `completed_at`, same arithmetic, one reminder only, suppressed if a review already exists
- **Daily digest** (AC-18c): batched per artisan, dispatched at **07:00 Europe/Paris**, covering `project_artisans` rows created since the previous dispatch. Not since midnight — since last dispatch, or a failed run silently drops matches
- **Monthly revenue** (AC-49): calendar month in Europe/Paris, read from Stripe, never recomputed locally
- **Matching volume** (AC-49b): rolling 30 days from the moment the dashboard is rendered, not calendar month, and labelled as such on screen
- **Availability blocks** are date-only, inclusive of both ends, no time component, interpreted in Europe/Paris

DST is the trap here. France shifts twice a year and 07:00 Paris is a moving UTC target. The digest scheduler works in Paris local time, not a fixed UTC hour.

### Notifications

Applies. Single owner: the Notification domain. No other domain composes or sends email.

Every notification is a row in an outbox table, written in the same transaction as the event that caused it, then dispatched asynchronously. This makes retry possible and prevents an email service outage rolling back a project publication.

**Immediate:** account confirmation, password reset, payment receipt, collaborator invitation, project modified (to artisans who responded, AC-20), zero-match notice to the client (AC-14c), coverage-found notice (AC-14d), review invitation (AC-24, AC-25), review reminder (AC-26).

**Batched daily at 07:00 Paris:** new matching projects (AC-18c).

Three retries with widening intervals; final failure logged and surfaced to admin. No notification is ever sent twice — dispatch is idempotent on the outbox row.

### Audit logging

**Not required by the spec.** No acceptance criterion asks for it and it is not in scope.

Recording it as an explicit decision rather than an omission: admin actions with irreversible effect — suspension (AC-50) and review deletion (AC-51) — are the ones a client will eventually ask about. Adding a minimal admin action log now is roughly half a day; adding it after a dispute is expensive and retroactive coverage is impossible. **Flagged for the Phase 2 ADR**, not built without a decision.

### Multi-tenancy

Applies in a restricted sense. There is no organisational tenancy — no client company boundary. The only shared-account structure is artisan-plus-collaborators.

Every artisan-scoped query filters on the effective artisan account resolved by the permission layer, never on an identifier from the request. Row-level security in Supabase enforces this as a second layer, so an application-layer mistake does not become a data leak.

### Contact-detail disclosure

Not in the handbook's standard list, but it behaves as a cross-cutting concern here and needs one definition.

A **single predicate** decides whether a viewer may see another party's surname, phone, email or precise address:

> Disclosure is permitted if a project exists where the viewer is the author and `selected_artisan_id` is the other party, or where the viewer is the selected artisan and the other party is the author.

Enforced in every serialiser that emits a profile, not per endpoint. AC-17 and AC-23 are both consequences of this one rule, and the non-functional requirement demands it hold at the API level, not merely in the UI.

Getting this wrong in one endpoint disintermediates the platform and removes the reason artisans subscribe. It is the highest-value target for Phase 6 security review.

---

## 5. Duplicate computation risk

Values displayed in more than one place. Each must have exactly one computing owner. **This table drives `tests/cross-feature/` at Phase 4.**

| Value | Displayed in | Computed where — single owner |
|---|---|---|
| **Artisan rating average and count** | Public profile, search results, featured banner, offer cards, proposal display, artisan dashboard, admin list | **Reputation.** Recalculated from `reviews` on every insert and delete, persisted to `artisans`. Never derived at read time, never averaged in a view or a query. |
| **Tier ceilings** — trades, photos, offers, radius, collaborators | Signup, profile editor, photo uploader, offer editor, collaborator page, subscription page, and every server-side enforcement point | **Subscription.** A pure function from tier to ceilings. Nine enforcement points read it; none restates the numbers. AC-08, AC-09, AC-10, AC-33, AC-40 all depend on identical values. |
| **Match set for a project** | Artisan dashboards, client-side recipient count (AC-18), artisan-side recipient count (AC-18b), admin unmatched list (AC-49c), re-evaluation sweep (AC-14d) | **Matching.** One rule implementation, one function. Computed at publication into `project_artisans`; every reader counts rows rather than re-evaluating the rule. A second implementation anywhere means the count and the dashboard disagree. |
| **Recipient count** | Client project detail, artisan project view | **Matching.** `COUNT(project_artisans)`. Both surfaces read the same query. |
| **Response count** | Artisan project view (AC-18b), client project detail | **Matching.** `COUNT(proposals)` for the project. |
| **Distance artisan↔project** | Matching rule, and any future "X km away" display | **Matching.** Single haversine helper. If a display ever computes its own distance, a client sees 23km on a job an artisan never received. |
| **Subscription status effective for display** | Search visibility, offer visibility, profile visibility, artisan's own subscription page, admin revenue | **Subscription.** One predicate resolving Stripe state plus period end into visible or hidden. AC-06 and AC-36 are the same rule applied to different surfaces. |
| **Monthly revenue** | Admin dashboard | **Reporting, reading Stripe.** Never summed from local subscription rows. Two sources of truth on revenue produce a discrepancy nobody can reconcile. |
| **Matching volume per artisan per month** | Admin dashboard (AC-49b), by tier | **Reporting.** Derived from `project_artisans.matched_at` joined to tier at time of render. Note: tier is read *current*, not historical — an artisan who downgraded mid-month appears under their current tier. Stated so the number is interpreted correctly. |
| **Result ranking position** | Artisan search, offers list, featured banner | **Marketplace.** One ranking function: banner selection, then tier-80 positions 1–3, then rating-descending. Two implementations means the banner and the list disagree about who is featured. |
| **Availability state for a date** | Public profile, artisan dashboard | **Availability.** One overlap predicate over `availability_blocks`. |
| **Review eligibility** | Client project detail, review form, review invitation email | **Reputation.** One predicate: status `completed`, viewer is author, target is `selected_artisan_id`, no existing review. The email must not use a looser rule than the form, or clients receive invitations that fail on submission. |

---

## 6. Ambiguities

Items the specification does not resolve. These go back to the client — I have not chosen for them.

**1. Ranking within a tier band when several artisans qualify.** AC-44 gives positions 1–3 to tier-80 artisans and says rotation applies if more than three match. Rotation per render is specified for the banner (AC-46) but not for the ranked positions. Random per render, round-robin by last-shown timestamp, or rating-ordered? Round-robin is fairest and needs a persisted counter; random is simplest and occasionally shows the same artisan repeatedly.

**2. Whether tier-100 artisans appear in the ranked list at all.** AC-45 says they occupy the banner and not positions 1–3. It does not say whether they appear at position 4 onward among "all other matching artisans," or are excluded from the list entirely. Excluded means a tier-100 artisan is invisible to anyone who ignores banners. Included means they appear twice on one page.

**3. Effect of an artisan's trade or radius change on already-published open projects.** AC-14d covers a *new* artisan registering. It does not cover an existing artisan widening their radius or adding a trade — does the sweep pick that up too? Treating them identically is more useful and slightly more work.

**4. Whether a paused offer counts against the tier ceiling.** AC-33 limits active offers. `offers.status` has `paused`. A tier-35 artisan with one paused offer — may they publish another? If yes, the ceiling is on active rows and an artisan can hold unlimited paused drafts.

**5. Conversation persistence after project cancellation.** AC-21 removes a cancelled project from artisan dashboards. Conversations reference `project_id`. Does the thread survive and remain readable, or disappear? Losing message history a client may need is worse than showing a cancelled label.

**6. Whether a client may review after cancelling.** Cancellation is permitted at any time, including after selection (AC-21, AC-22). If a client selects an artisan, work begins, then the project is cancelled — review eligibility requires status `completed`, so no review is possible. That may be intended, or it may be a route by which a client avoids leaving a review they promised.

**7. Whether collaborators appear on the public profile.** The tier tables sell "up to 10 collaborators" as a visible company-scale signal. The spec only gives them logins. If the client expects staff names displayed publicly, that is an additional, small capability nobody has specified.

**8. Admin action logging.** Flagged in §4. Not required by any AC; irreversible admin actions argue for a minimal log. Decision belongs in the Phase 2 ADR.

---

## 7. Review note for the project lead

The handbook asks you to review the read/write grid personally, because a wrong ownership call reads as entirely reasonable and surfaces months later as two screens disagreeing about a number.

**Where I am least confident, in order:**

1. **`proposals` under Matching rather than Demand** (§2, flagged). Inverting it changes the dependency graph and the build order. This is the single row most worth your disagreement.

2. **`artisans` with three writers.** Column-scoped updates are the right fix, but it depends on a rule holding across every future change. An alternative is splitting the rating aggregates into their own table, removing Reputation as a writer entirely — cleaner boundary, one more join on every search query.

3. **Notification as a domain rather than infrastructure.** Treating it as a domain gives one owner for the digest and reminder logic, which are genuinely stateful. The cost is that every domain now depends on it, which is why it appears late in the build order with a stub interface earlier.

4. **Contact-detail disclosure as a cross-cutting concern.** Not in the handbook's standard list. I added it because it appears in two ACs, a non-functional requirement, and is the mechanism protecting the entire revenue model. If it lives in one serialiser rather than as a stated concern, someone will eventually write an endpoint that forgets it.
