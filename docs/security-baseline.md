# Security baseline

Applies to every project. Reviewed at Phase 2 (choices), enforced at Phase 4 (tests),
verified at Phase 6 (findings), confirmed at Phase 7 (handoff).

**Why this document exists.** Coding agents produce authentication and authorization code
that looks correct and reads well. Session handling, token validation, and permission
checks are exactly the code where "looks right" and "is right" diverge, because the failure
is invisible until someone exploits it. This checklist exists because reviewing generated
auth code without a checklist does not work.

Mark each item **applies** or **N/A with reason**. "N/A" without a reason is not permitted.

---

## A. Authentication

| # | Requirement | Status |
|---|---|---|
| A1 | Passwords hashed with bcrypt, scrypt, or Argon2. Never MD5, SHA-1, SHA-256, or plain. Never a custom scheme. | |
| A2 | Session tokens generated with a cryptographic RNG. Never `Math.random()`, timestamps, or sequential IDs. | |
| A3 | Session cookies: `HttpOnly`, `Secure`, `SameSite=Lax` or stricter. | |
| A4 | Sessions expire. Absolute maximum stated, idle timeout stated. | |
| A5 | Logout invalidates server-side, not only the client cookie. | |
| A6 | Password reset tokens are single-use, expiring (≤1 hour), and invalidated on use. | |
| A7 | Login failures return an identical message and comparable timing for unknown-user and wrong-password. | |
| A8 | Rate limiting on login, password reset, and any OTP endpoint. State the limit. | |
| A9 | If JWT: signature verified on every request, algorithm pinned (reject `alg: none`), expiry checked. | |
| A10 | If third-party auth (Auth0, Clerk, Supabase, Firebase): token verified server-side. A client-supplied user ID is never trusted. | |

## B. Authorization

| # | Requirement | Status |
|---|---|---|
| B1 | Every endpoint that returns or mutates data checks authorization. List any deliberate exceptions. | |
| B2 | Authorization is checked server-side. Hiding a UI element is not authorization. | |
| B3 | Object-level checks: fetching record `id` verifies the caller may see *that* record, not merely that they are logged in. (IDOR — the most common defect in generated code.) | |
| B4 | Role checks derive from server state, never from a client-supplied role, header, or JWT claim that the client can set. | |
| B5 | Multi-tenant: every query is scoped by tenant. State the enforcement mechanism — middleware, RLS, or repository layer. | |
| B6 | Admin functions are separately gated, not merely "role != user". | |
| B7 | Default deny. A new endpoint without an explicit rule is inaccessible, not public. | |

## C. Input and output

| # | Requirement | Status |
|---|---|---|
| C1 | Database access is parameterized. No string-concatenated SQL anywhere, including migrations and admin scripts. | |
| C2 | Input validated at the boundary against a schema, with type, range, and length. | |
| C3 | Output encoded for its context. No `dangerouslySetInnerHTML`, `innerHTML`, or `v-html` on user-controlled data. | |
| C4 | File uploads: extension allowlist, MIME verified from content, size cap, stored outside the web root, filenames randomized. | |
| C5 | No user input reaches a shell, `eval`, or a dynamic import. | |
| C6 | Redirect targets validated against an allowlist. No open redirects. | |
| C7 | Errors returned to clients carry no stack traces, SQL, or file paths. Full detail goes to logs only. | |

## D. Secrets and configuration

| # | Requirement | Status |
|---|---|---|
| D1 | No secrets in the repository, in any branch, at any point in history. | |
| D2 | Secrets supplied by environment variables or a secret manager. `.env.example` lists names with placeholder values only. | |
| D3 | Every secret documented in `docs/environment.md`: what it is, where to obtain it, what breaks without it. | |
| D4 | Distinct credentials per environment. Production secrets never present in dev or staging. | |
| D5 | Rotation procedure documented in the runbook. | |
| D6 | Debug mode, verbose errors, and dev tooling disabled in production. | |

## E. Transport and headers

| # | Requirement | Status |
|---|---|---|
| E1 | HTTPS enforced. HTTP redirects to HTTPS. | |
| E2 | HSTS set. | |
| E3 | Security headers: `X-Content-Type-Options: nosniff`, `X-Frame-Options` or CSP `frame-ancestors`, `Referrer-Policy`. | |
| E4 | CSP present for any app rendering user content. State the policy. | |
| E5 | CORS lists explicit origins. Never `*` alongside credentials. | |

## F. Dependencies

| # | Requirement | Status |
|---|---|---|
| F1 | Audit gate green in CI (`npm audit` / `pip-audit` / equivalent). No high or critical. | |
| F2 | Lockfile committed. | |
| F3 | Every dependency in the diff exists, is the package intended, and is listed in the ADR. Agents hallucinate package names and typosquats are real. | |
| F4 | Dependency update procedure documented for the maintainer. | |

## G. Data protection

| # | Requirement | Status |
|---|---|---|
| G1 | Personal data inventoried: what is stored, why, how long. | |
| G2 | Sensitive fields encrypted at rest where required. State which. | |
| G3 | Logs contain no passwords, tokens, card numbers, or full personal records. | |
| G4 | Backups exist, are tested, and their restore path is documented. | |
| G5 | Deletion path exists where regulation requires it (GDPR erasure, and similar). | |

## H. Operational

| # | Requirement | Status |
|---|---|---|
| H1 | Rate limiting on expensive and abusable endpoints beyond auth. | |
| H2 | Audit log for security-relevant events: login, permission change, deletion, admin action. | |
| H3 | Client informed in writing of their security responsibilities after handoff. | |

---

## Per-project-type additions

**Handles payments** — never store raw card data; use the provider's hosted fields or tokenization; verify webhook signatures; make payment webhooks idempotent; log transaction IDs and never card details.

**Handles health data** — BAA in place before any PHI is touched; encryption at rest and in transit; access logging on every PHI read; explicit minimum-necessary access rules.

**Public sign-up** — email verification before privileged actions; abuse and enumeration protection on registration; CAPTCHA or equivalent where automated registration is plausible.

**File sharing** — signed, expiring URLs; authorization checked on download, not only on the listing; virus scanning where users share files with each other.

**Public API** — per-key rate limits; key rotation; documented scopes; versioning that does not break existing consumers.

---

## Where this connects to the SDLC

**Phase 1** — security requirements enter the spec as testable NFRs. "Passwords are hashed" is not an acceptance criterion; "a database dump exposes no usable password" is.

**Phase 2** — the ADR names the authentication approach, the authorization enforcement point, and the secret storage mechanism. These are architectural, and changing them later is expensive.

**Phase 4** — items marked applies get scenarios in `tests/holdout/`. At minimum: access another tenant's record by ID, call an endpoint without a session, call an admin endpoint as a normal user, submit oversized and malformed input. These are the tests that catch B3, which is the defect agents produce most often.

**Phase 6** — the reviewer runs the security prompt below against this checklist.

**Phase 7** — the completed checklist is part of the handoff package. The client receives it, which is both good practice and evidence of what was covered if the relationship later sours.

---

## Phase 6 security review prompt

Run in a fresh session, separate from the general verification pass. Security review has a
different failure mode to correctness review and does not share attention well with it.

```
<spec>
{{SPEC — auth, roles, and NFR sections}}
</spec>

<baseline>
{{THIS CHECKLIST, WITH APPLIES/N-A MARKED}}
</baseline>

<diff>
{{FULL DIFF}}
</diff>

You are performing a security review of code written by another agent. Assume it contains
at least one authorization defect, because generated authentication and authorization code
usually does — it is fluent, conventional-looking, and wrong in ways that only surface under
adversarial use.

Your value is that you are reading it as an attacker rather than as its author.

<task>
Work through every checklist item marked "applies" and find where the implementation
fails it.
</task>

<priority>
Examine these first, in this order. They are ranked by how often generated code fails them:
1. Object-level authorization (B3) — for every endpoint taking an ID, trace whether the
   caller's right to that specific record is verified. Missing checks here are the most
   common serious defect.
2. Trusting client-supplied identity (A10, B4) — any user ID, role, or tenant read from
   a request body, query parameter, or a header the client controls.
3. Endpoints with no authorization check at all (B1, B7).
4. Query construction (C1) — any string interpolation into SQL.
5. Secrets in the diff (D1).
</priority>

<output_format>
## Critical — exploitable now
For each: checklist ID, file and line, the concrete attack (state it as steps an attacker
takes), and the fix.

## High — exploitable under plausible conditions
Same structure.

## Checklist items not satisfied
Table: ID | Requirement | Evidence from the diff | Severity

## Endpoint authorization audit
Table: Endpoint | Authenticated? | Object-level check? | Evidence

## Could not verify from the diff alone
</output_format>

<constraints>
Report only. Do not write fixes, do not modify files.
Cite file and line for every finding. If you cannot cite it, it belongs under "could not
verify" rather than in the findings.
Describe each attack concretely. "Potential authorization issue" is not actionable;
"a user with any valid session can GET /api/deals/{id} for any id, including other
tenants' deals" is.
Do not issue an overall verdict or approval. A human decides that from your findings.
</constraints>
```
