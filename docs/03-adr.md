# ADR-001: Stack and architecture — Artizyn

**Status:** proposed — awaiting signature
**Date:** ____________
**Decided by:** ________________________ ← **A NAMED PERSON. Not the model.**

> Every technical decision below is complete. Three items remain blank because they are facts about people rather than architecture: the signature, the client maintainer's capability (§Maintenance implication), and the named production deployer. None blocks Phase 3.

---

## Context

**Project shape** (system model v1.0):
- 11 domains, 20 entities, no dependency cycles
- 5 external integrations: Stripe Subscriptions, Supabase Auth, Supabase Storage, transactional email, geocoding
- 61 acceptance criteria across two marketplace directions
- Expected scale at launch: low hundreds of artisans, region-limited to PACA

**Product characteristics that constrain the architecture**, in order of weight:

1. **Acquisition is organic search.** Artisan profiles, offer listings and search results are the channel. A `.fr` marketplace competing on queries like "plombier Marseille" needs server-rendered, indexable pages. This is a product requirement, not a preference.

2. **Every significant query is geographic.** The matching rule (spec §11) and the ranking function (AC-44 to AC-46) both filter on distance. At a few hundred artisans, haversine in application code is adequate. At a few thousand, the distance filter belongs in the database — bounding-box prefilter then haversine, or PostGIS. The architecture must keep the query layer close to Postgres rather than abstracted behind an ORM that resists raw SQL.

3. **The transactional core is small; the surface area is large.** Genuinely stateful work is limited to Stripe webhook handling, the matching re-evaluation sweep, and the notification outbox. The remaining nine domains are CRUD with permission checks across roughly 20 screens. The architecture should optimise for building many screens consistently, not for algorithmic complexity.

**Client constraints:**
- Hosting: Vercel + Supabase, named in the brief. All accounts owned by the client from day one.
- Maintainer after handoff: the client's own team (spec §15)
- Maintainer's technical capability: **not established at time of decision.** See §Maintenance implication.
- Compliance: RGPD. No health data, no card data stored, no cross-border transfer.
- Timeline: 10 weeks requested; 141 days / 28 weeks estimated. **Timeline conversation outstanding with the client.**

**Implementation by coding agent.** The build is executed by Claude Code against frozen tests. This changes one input materially: the ×1.4 unfamiliar-stack multiplier in `04-estimate.md` §3 does not apply, because it prices a human team's ramp-up. The estimate holds near its 141-day baseline for any of the three options, and build-speed differences between them largely collapse.

**What that does not change:** who maintains this at month eight. That remains the decisive constraint, and it is why a stack decision is still required rather than arbitrary.

---

## Options considered

Full analysis in `02-stack-options.md`.

| Option | Grand total | Reversibility | Server-rendered by default | Maintainer fit |
|---|---|---|---|---|
| **A — Next.js 15 + TypeScript + Supabase** | 141 days | ~60% survives | Yes | Good if TypeScript, poor if Python |
| B — Django 5 + HTMX + Postgres | 149 days | ~70% survives | Yes | Good if Python, poor if TypeScript |
| C — Vanilla JS SPA + serverless | 171 days | ~40% survives | **No** | Realistically only the author |

---

## Decision

**Chosen: Option A — Next.js 15 (App Router) + TypeScript + Supabase.**

**Exact versions.** Claude Code reads this block at Phase 3 to configure the harness, and at Phase 5 to reject any dependency not listed here.

```
Language:            TypeScript 5.7 (strict mode)
Runtime:             Node.js 22 LTS
Framework:           Next.js 15.x, App Router
Database:            PostgreSQL 15 (Supabase-hosted)
ORM / query layer:   Drizzle ORM 0.38.x
Auth:                Supabase Auth (@supabase/ssr 0.5.x)
Storage:             Supabase Storage
Payments:            Stripe Subscriptions (stripe 17.x, Node SDK)
Hosting:             Vercel (production and staging)
CSS:                 Tailwind CSS 3.4.x
Forms & validation:  react-hook-form 7.x + zod 3.x
Email provider:      Resend (resend 4.x)
Email templates:     react-email 3.x
Geocoding provider:  API Adresse (Base Adresse Nationale)
Error tracking:      Sentry (@sentry/nextjs 8.x)
Testing:             Vitest 2.x (unit, integration) + Playwright 1.49.x (end-to-end)
PDF generation:      @react-pdf/renderer 4.x
Dates:               date-fns 4.x + date-fns-tz 3.x
Scheduled work:      Vercel Cron
```

**Drizzle rather than Prisma.** Drizzle composes with raw SQL rather than resisting it, which matters because the matching rule and the ranking function both need hand-written geographic queries (constraint 2). Prisma's generated client is more ergonomic for CRUD and materially worse at the two queries this product depends on.

**API Adresse rather than Google Geocoding.** The French government's official address API: free, no key, no practical rate limit, authoritative for French postal codes and communes — which is exactly and only what this product geocodes. Google would cost per lookup and be less accurate for French addresses. **This closes dependency D-08 and removes its recurring cost entirely.**

**Option C is declined on the record.** It was the brief's own proposal (§7, "Vanilla JS SPA (or React)"), so declining it explicitly to prevent it resurfacing at Phase 5. Two reasons, in order:

1. **It cannot serve the acquisition requirement without becoming Option A.** A client-rendered SPA does not produce indexable pages. Adding server rendering to a hand-rolled SPA means rebuilding what Next.js already is, less well.
2. **It is the hardest artefact to hand over.** A framework-less codebase has house conventions rather than documented ones — a new maintainer must learn ours, where with Next.js they can read the framework's documentation. Against a client whose own team maintains this, that is decisive.

Build cost is no longer the objection, given agent implementation. Maintainability and search visibility are.

---

## Rationale

The product's acquisition channel is organic search, which requires server-rendered indexable pages — this alone eliminates Option C and leaves A and B. Between those, three project-specific facts favour A.

The client already owns Vercel and Supabase accounts, and Next.js is native to that pairing: Supabase's SSR helpers, Vercel's cron and function primitives, and the Stripe Node SDK are all first-class, so none of the five integrations involves fighting the platform. Option B would mean departing from hosting the brief specified and the client has already provisioned.

TypeScript's value here is concentrated where this product is most fragile. The system model identifies twelve duplicate-computation risks (§5), and the two worst — the tier-ceiling function and the contact-disclosure predicate — are each consumed in roughly a dozen places. Shared types between server and client turn a whole class of "one caller used it wrong" bug into a compile error. Given the disclosure predicate protects the entire subscription revenue model, that is worth more than the six days Option B would save elsewhere.

Supabase's Postgres remains directly queryable, satisfying the geographic constraint. Drizzle keeps raw SQL available for the matching and ranking queries without abandoning type safety for the CRUD that makes up most of the build.

**The honest counterargument.** Django's admin would absorb most of the Reporting domain — roughly 5 of the 5.5 days estimated — and Python is easier to hire mid-level for in France. If the client's maintainer turns out to be a Python developer, Option B becomes the right answer and this ADR should be superseded rather than argued with. That is the single fact that would change this decision.

---

## Maintenance implication

**Who operates this after handoff:** the client's own team (spec §15).

**Their capability: ⚠ not established.** Dependency D-27 identified a decision-maker, not a maintainer. This decision was taken without it, and that is recorded here deliberately rather than glossed over.

**If they are a TypeScript or JavaScript developer:** they can operate this. Next.js is conventional, extensively documented, and represents the largest hiring pool in French web development. Framework upgrades are the main ongoing burden.

**If they are a Python developer:** they cannot realistically maintain this without ramp-up, and every change routes back to us — contradicting the client's stated intent of owning the platform. **Raise this before Phase 3.** Switching stacks costs nothing now and roughly 25 days at Phase 5.

**If there is no maintainer** — the most likely real answer, and the one Phase 7 must be written for. Handover documentation is written to the capability level stated in this section, so this blank has a direct cost at Phase 7.

**Framework churn as a handover risk.** Next.js majors move roughly annually. A client who touches this rarely returns in eighteen months to a framework a version behind, with a Supabase client library that has also moved. `docs/limitations.md` must state this plainly rather than leaving them to discover it.

---

## Reversibility

**Survives a frontend change** — roughly 60% of the build:
- The Postgres schema in full
- All business logic, **provided it stays in `src/domains/` modules** rather than inside route handlers or server components. This is the single condition the number depends on, and it is an `AGENTS.md` hard rule below.
- Drizzle schema definitions and migrations
- The matching rule, ranking function, tier-ceiling function and disclosure predicate — all pure functions over the schema

**Discarded** — roughly 25 days:
- App Router routes and server components
- React component library and Tailwind styling
- The react-hook-form and zod form layer
- Playwright end-to-end tests, which are route-coupled

**The expensive direction is Supabase, not Next.js.** Supabase Auth is woven into the permission layer (system model §4) and Storage into the photo pipeline across ArtisanProfile, Demand, Marketplace and Messaging. Replacing either means revisiting Identity and ArtisanProfile substantially — 15 to 20 days, against roughly 25 for a full frontend replacement, but touching far more domain code.

**Cheapest reversals:** email provider (Resend behind one adapter, under a day), geocoding (one adapter, under a day), error tracking (configuration only).

**Practical consequence:** keep Supabase behind adapters at the Identity and Storage boundaries even though nothing requires it today. This is the constraint most likely to matter at month eighteen and costs almost nothing to observe now.

---

## Operational decisions

**Migrations**
- Tool: Drizzle Kit (`drizzle-kit generate`)
- Location: `drizzle/migrations/`, committed to the repository
- Who may apply to production: the named production deployer below, manually, after review
- **Hard rule: never run a migration against any environment.** Generate the file; a person reviews the SQL; a person applies it. House rule, not negotiable. Appears in `AGENTS.md`.
- Down migrations written for every schema change and tested on staging before the up migration reaches production

**Environments**

| | Local | Staging | Production |
|---|---|---|---|
| Hosting | Local Node + Supabase local dev | Vercel preview | Vercel production |
| Database | Supabase local (Docker) | Separate Supabase project | Production Supabase project |
| Stripe | Test mode | Test mode | Live mode |
| Email | Console log | Resend test domain | Resend, client's sending domain |
| Deploy | — | Automatic on merge to `main` | Manual promotion from staging |

- **Staging is mandatory from Phase 5.** Each finished feature deploys there; the client clicks through a working application well before the end.
- Named production deployer: ⚠ **to be named before the first production deploy.** Not required for Phase 3.
- The production database is never used for testing. Staging seed data comes from dependency D-33.

**Backups**
- Mechanism: Supabase automated daily backups, Pro plan, 7-day point-in-time recovery
- Retention: 7 days rolling, plus a manual snapshot before any migration touching `projects`, `reviews`, `messages` or `artisans`
- Restore procedure: documented in `docs/runbook.md` at Phase 7, written as steps a non-expert can follow
- **Last tested on: ⚠ must be tested and dated before handover.** An untested backup is not a backup, and Phase 7's gate is that a stranger can operate this.

**Error tracking**
- Sentry, `@sentry/nextjs`. Account is dependency D-09.
- Separate projects for staging and production
- Alerts to: ⚠ **to be named.** Must be a client address by handover, not ours.
- Sensitive-data scrubbing enabled: no email addresses, phone numbers, message content or Stripe identifiers in error payloads. RGPD.

**Logging**
- Library: `pino` 9.x, structured JSON
- Destination: Vercel log drains in production; stdout locally
- Retention: 7 days (Vercel Pro default). Longer retention is a client cost decision, not a technical one.
- **Never logged:** message content, attachment contents, client contact details, Stripe secrets, Supabase service keys. The disclosure predicate exists to protect contact details; logging them defeats it.
- **Logged for every matching run:** project ID, artisan count matched, execution duration. This is the only diagnostic for the product's core mechanism.

**Uptime monitoring**
- Tool: Better Stack (free tier covers a 3-minute interval, exceeding the NFR's 5-minute requirement)
- Probes: homepage, artisan search, an artisan profile page, `/api/health`
- Alerts to: ⚠ **to be named.** Nobody currently owns the pager. Must be a client contact by handover.

**Geocoding**
- Provider: **API Adresse** (Base Adresse Nationale)
- Granularity: **postal code, never commune.** Marseille covers 240 km² across 16 postal codes; commune-level resolution produces multi-kilometre error at radius boundaries in both directions (system model §11).
- Cost: free, no API key, no practical rate limit. **Closes dependency D-08 at no recurring cost.**
- Caching: postal-code-to-coordinate pairs cached locally. PACA has roughly 950 postal codes, so after the first weeks nearly every lookup is local.
- Failure behaviour: geocoding failure blocks the save with an explicit message. A profile or project without coordinates cannot participate in matching, so a partial save is worse than a refusal.
- **Needed by Phase 4**, when the frozen tests encode the matching rule.

**Transactional email**
- Provider: **Resend**, templates via `react-email`
- Sending domain: a subdomain of the client's `.fr` domain, dependency D-13. SPF, DKIM and DMARC records required — without them account confirmations land in spam and signup silently fails.
- Cost: free to 3,000 emails/month, then approximately $20/month. The free tier suffices at launch volumes.
- **Outbox pattern is mandatory** (system model §4): every notification is a row written in the same transaction as its triggering event, dispatched asynchronously with three retries. An email provider outage must never roll back a project publication.
- All ten email types French-only. Copy is dependency D-24.

**Scheduled work — Vercel Cron**

| Job | Schedule | Purpose |
|---|---|---|
| Notification dispatch | Every 5 minutes | Drains the outbox |
| Daily digest | 07:00 Europe/Paris | AC-18c. Scheduled in Paris local time, not fixed UTC — DST moves it twice a year. |
| Project auto-close | Hourly | AC-25, 14 days from `selected_at` |
| Review reminder | Daily, 09:00 Paris | AC-26, 7 days after completion, suppressed if a review exists |
| Stripe reconciliation | Daily, 03:00 Paris | Catches webhooks that never arrived |

**Known constraint — the re-evaluation sweep.** AC-14d re-scans every open unmatched project whenever an artisan registers or changes trades or radius. Vercel caps function execution (60s on Pro for standard functions). Trivial at launch volumes; as unmatched projects accumulate this is the most likely place to hit a ceiling.

*Mitigation, decided now rather than discovered at Phase 5:* the sweep runs as a queued background job rather than inline with the artisan's save, processes in batches of 100 projects, and is idempotent so a timeout resumes rather than restarts. Indexed on `projects(status, skill_id)` and `projects(status, secondary_skill_id)`.

**Admin action logging**
- **Decision: build it.** Half a day now; impossible retroactively.
- Table `admin_actions`: `id`, `admin_profile_id`, `action`, `target_type`, `target_id`, `reason`, `created_at`
- Covers artisan suspension and reactivation (AC-50) and review deletion (AC-51) — the two irreversible admin actions
- No acceptance criterion requires this. It is here because a client will eventually ask why an artisan was suspended or a review removed, and without a log the answer is somebody's memory. Recorded as a deliberate addition beyond scope, at our cost, not as a change request.

**Who pays after handoff**

The client, for everything. All accounts are in their name from day one.

| Service | Monthly, at launch |
|---|---|
| Vercel Pro | ~$20 |
| Supabase Pro | $25 |
| Resend | $0 (free tier) |
| API Adresse | $0 |
| Sentry | $0 (free tier) |
| Better Stack | $0 (free tier) |
| Domain `.fr` | ~$1 |
| **Total** | **~$46/month** |

Stripe takes its transaction percentage from subscription revenue separately.

**This figure belongs in the handover package**, and the client should see it before signature rather than at month one.

---

## Consequences

**Makes easy**
- Indexable server-rendered pages by default — the acquisition requirement, at no extra cost
- Shared types across twelve duplicate-computation risks, turning a class of bug into a compile error
- Native fit with the client's existing Vercel and Supabase accounts; five integrations with first-class SDKs
- Raw SQL where the geographic queries need it, without abandoning type safety elsewhere
- The largest hiring pool in French web development, if the client's team turns over

**Makes hard**
- Supabase Auth and Storage are the expensive reversal, and they touch the permission layer and photo pipeline. Adapters at those boundaries are a standing requirement.
- Serverless execution limits constrain the re-evaluation sweep. Mitigated above, but it remains the first place to hit a ceiling.
- Next.js majors move roughly annually. A client who touches this rarely returns to a framework a version behind. Must be stated plainly in `docs/limitations.md`.
- Unusable by a Python maintainer without ramp-up. If that is what the client has, this ADR is wrong and should be superseded before Phase 3.

---

## Cross-references for Claude Code

Rules that must appear in `AGENTS.md` at Phase 3. Each traces to a specific failure it prevents.

1. **Column-scoped writes on `artisans`.** Three domains write this table: Subscription owns tier and Stripe columns, ArtisanProfile owns company and geographic columns, Reputation owns rating aggregates. Never write a whole row. *(A Stripe downgrade racing a profile save otherwise produces radius 80 on tier €35 — invalid, undetectable, violates AC-10.)*

2. **Single owners, no exceptions.** Rating aggregates from `src/domains/reputation/` only. Tier ceilings from Subscription's pure function only. The matching rule implemented exactly once. Distance via one haversine helper. Review eligibility via one predicate, shared by the form and the invitation email. *(System model §5, twelve risks.)*

3. **Contact-detail disclosure in every profile serialiser, never per endpoint.** One predicate. *(AC-17 and AC-23 are the same rule on two surfaces. This protects the subscription revenue model and is the highest-value target for Phase 6 security review.)*

4. **Never trust an artisan, tenant, profile or role identifier arriving in a request.** Resolve the effective artisan through the permission layer on every artisan-scoped request. *(System model §4.)*

5. **Timestamps stored UTC, displayed Europe/Paris.** All scheduled work is scheduled in Paris local time. *(The 07:00 digest is a moving UTC hour; a fixed UTC cron drifts twice a year at DST.)*

6. **Business logic lives in `src/domains/{domain}/` and must not import from `src/app/` or `src/components/`.** Dependency direction is `app → domains → db`, never the reverse. *(This is the condition the 60% reversibility figure depends on.)*

7. **Test files are read-only.** Do not create, edit, delete or skip any file under `tests/`. If a test appears wrong, stop and report it — that is a specification defect and a person decides it.

8. **No dependency not listed in the versions block above.** If something appears necessary, stop and ask.

9. **Every notification goes through the outbox.** No domain composes or sends email directly.

10. **Never log message content, contact details, or secrets.**

---

## Sign-off

By signing, I confirm this stack decision was taken against the constraints recorded above, and that I accept the maintenance and reversibility consequences stated — including that the client maintainer's capability was not established at the time of this decision.

**Name and role:** ______________________________

**Signature:** ______________________________

**Date:** ______________
