# Client dependencies — Artizyn

Opened at Phase 0. Reviewed weekly. Moves into the repository at `docs/05-dependencies.md` once it exists.

**Every item below is something only the client can supply.** Each is requested immediately, not when it becomes blocking. Needed-by dates derive from the topological build order in the system model (Phase 1.5) and are provisional until that exists.

---

## Register

| ID | What we need | Blocks | Needed by | Requested | Received | Days lost |
|---|---|---|---|---|---|---|
| **Accounts and credentials** |
| D-01 | Stripe account created, owned by client, in the client's legal entity name | All subscription work | Phase 3 | | | |
| D-02 | Stripe API keys — test and live, plus webhook signing secret | Subscription domain | Phase 3 | | | |
| D-03 | Stripe products and prices configured for the three tiers (35 €, 80 €, 100 €), monthly recurring | Subscription domain | Phase 5 | | | |
| D-04 | Supabase organisation created, owned by client; project provisioned | Everything — database, auth, storage | Phase 3 | | | |
| D-05 | Supabase service role key and anon key | Everything | Phase 3 | | | |
| D-06 | Vercel account, owned by client | Deployment, staging | Phase 3 | | | |
| D-07 | Transactional email service account (provider TBD at Phase 2) and API key | All email notifications, account confirmation | Phase 5 | | | |
| D-08 | Geocoding service account and API key (provider TBD at Phase 2) | **Matching — nothing works without coordinates** | Phase 4 | | | |
| D-09 | Sentry account and DSN | Error tracking | Phase 3 | | | |
| D-10 | Google Analytics property and measurement ID | Analytics | Phase 7 | | | |
| **Domain and DNS** |
| D-11 | `.fr` domain registered, owned by client | Deployment, email deliverability | Phase 3 | | | |
| D-12 | DNS access, or a named person able to add records within one working day | Domain pointing, email SPF/DKIM records | Phase 7 | | | |
| D-13 | Sending domain or subdomain nominated for transactional email, with DNS records applied | Email deliverability — without this, confirmation emails land in spam | Phase 5 | | | |
| **Legal and compliance content** |
| D-14 | CGU (conditions générales d'utilisation), final text in French | `/terms` page. **Site cannot go live without it.** | Phase 7 | | | |
| D-15 | CGV (conditions générales de vente) covering the subscription, final text in French | Subscription checkout, legal compliance | Phase 7 | | | |
| D-16 | Mentions légales — company name, SIRET, registered address, publication director, host details | Legal requirement for a French commercial site | Phase 7 | | | |
| D-17 | Politique de confidentialité (RGPD), final text in French | `/privacy` page, cookie handling | Phase 7 | | | |
| D-18 | Cookie consent policy — which categories are used and the client's position on consent | Cookie banner behaviour | Phase 7 | | | |
| D-19 | Named data controller and DPO contact, if appointed | RGPD compliance, privacy policy content | Phase 7 | | | |
| **Brand and content** |
| D-20 | Logo — vector format, and a square version for favicon and social cards | All pages | Phase 5 | | | |
| D-21 | Brand colours and typography, or confirmation we may propose them | UI throughout | Phase 5 | | | |
| D-22 | Homepage copy in French — headline, value proposition for artisans, value proposition for clients | Homepage | Phase 5 | | | |
| D-23 | Tier comparison copy — the client's own wording for what each subscription includes, since this is what they sell against | Subscription pages, artisan signup | Phase 5 | | | |
| D-24 | Transactional email copy in French — confirmation, password reset, payment receipt, new matching request, request modified, review invitation, review reminder, collaborator invitation | All notifications | Phase 5 | | | |
| D-25 | Contact page details — support email, phone if any, postal address | `/contact` | Phase 7 | | | |
| **Decisions and sign-off** |
| D-26 | Named signatory for the specification, with role | **Phase 1 gate — nothing proceeds without it** | Phase 1 | | | |
| D-27 | Named decision-maker for the build, reachable within one working day | Every open decision | Phase 1 | | | |
| D-28 | Ruling on the three departures from the brief's tier tables — Google Calendar deferral, calendar for all tiers, Tier 1 offers | Specification signature | Phase 1 | | | |
| D-29 | Ruling on the matching rule (the three-artisan scenario) | **Phase 4 — the frozen tests encode this rule** | Phase 1 | | | |
| D-30 | Tier 3 banner placement and rotation rule | Phase 4 test scenarios | Phase 4 | | | |
| D-31 | Admin dashboard contents beyond the four stated statistics | Phase 5 | Phase 5 | | | |
| D-32 | Launch seeding decision — free trial, promotional pricing, or manual artisan recruitment | Stripe configuration if a trial is required | Phase 3 | | | |
| **Testing and launch** |
| D-33 | Sample artisan data — 5 to 10 real profiles with genuine trades, towns and radii | Realistic matching tests, staging demonstration | Phase 5 | | | |
| D-34 | Test bank card details, or confirmation Stripe test mode is sufficient for acceptance | Subscription acceptance testing | Phase 5 | | | |
| D-35 | Named person available for acceptance testing on staging, with time allocated | Phase 7 recette | Phase 7 | | | |
| D-36 | Confirmation of who receives production error alerts after handoff | Phase 7 | Phase 7 | | | |

**Total days lost:** 0

---

## Rules

Every dependency is identified at Phase 0 and requested immediately, not when it becomes blocking.

Needed-by dates derive from the build order in the system model. They are provisional until Phase 1.5 exists.

**A dependency more than five days overdue triggers a written schedule notice** — not a complaint, a factual statement that the end date has moved by N days, sent at the time it happens rather than at delivery.

Days lost accumulates and appears in every status update. When the client asks why the date moved, the answer is this table.

---

## The four that will hurt

**D-08 — geocoding.** Matching is the product, and matching requires coordinates. Without a geocoding provider, no artisan can complete their profile and no job can be published. This is not a Phase 7 item; it needs settling at Phase 2 alongside the stack.

**D-14 to D-17 — legal text.** The site cannot go live without CGU, CGV, mentions légales and a privacy policy. Clients routinely leave these to the final week and then discover their lawyer needs three. Request them in week one. This is the most common cause of a finished build sitting undeployed.

**D-26 — the signatory.** No name appears anywhere in the brief. Phase 1's gate is a signed specification and there is currently nobody identified to sign it.

**D-01 to D-06 — accounts in the client's name.** These must be created by the client and owned by the client from day one, not created by us and transferred later. Transferring a Stripe account with live subscriptions is genuinely painful, and a Supabase project holding personal data of French users should never have been in our name.

---

## Note

Provider choices for D-07 (email) and D-08 (geocoding) are open until the Phase 2 ADR. Both carry a recurring cost the client pays after handoff, and both belong in the ADR's operational decisions block alongside migrations, backups, monitoring and who pays for them.
