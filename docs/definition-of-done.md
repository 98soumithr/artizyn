# Definition of Done

The single checklist read before opening a pull request. If an item is unchecked, the work
is not done — regardless of whether the feature demonstrably works.

Gates elsewhere in the SDLC catch these individually. This page exists so a developer has
one thing to read rather than five.

---

## Every pull request

**Correctness**
- [ ] Working suite green locally
- [ ] Every acceptance criterion in scope for this PR is implemented, and named in the PR description
- [ ] Manually exercised at least once — not merely test-green

**Frozen suite**
- [ ] No file under `tests/` modified, added, deleted, or skipped
- [ ] `git diff --name-only main...HEAD -- tests/` returns nothing

**Scope**
- [ ] Nothing in this diff that no acceptance criterion asks for
- [ ] No unrelated refactoring
- [ ] No dependency added outside `docs/03-adr.md`

**Architecture**
- [ ] Derived values come from their owning shared service (`docs/02-system-model.md`)
- [ ] Import direction respects the rules in `AGENTS.md`
- [ ] Period and timezone handling matches the single definition in the system model

**Security** — the four that generated code fails most often
- [ ] Every new endpoint checks authorization, including object-level (may this caller see *this* record?)
- [ ] No user ID, role, or tenant read from client-controlled input
- [ ] All queries parameterized
- [ ] No secrets, keys, or `.env` files in the diff

**Migrations**, if the diff contains one
- [ ] Read line by line by a human
- [ ] Down path present, or irreversibility stated with a reason
- [ ] Destructive operations separated from feature changes
- [ ] Tested against restored production-shaped data, not an empty database

**Errors and logging**
- [ ] Realistic failure modes handled — timeouts, absent records, malformed responses
- [ ] Errors logged with enough context to diagnose without reproducing
- [ ] Nothing returned to the client that leaks internals

**Hygiene**
- [ ] Linter clean
- [ ] No temporary files, scratch scripts, or commented-out code
- [ ] No `console.log` / `print` debugging left behind

---

## Feature complete (before Phase 6)

- [ ] Holdout suite green
- [ ] Cross-feature suite green — the same value is identical everywhere it appears
- [ ] Dependency audit clean, no high or critical
- [ ] Deployed to staging and exercised there

## Ready for delivery (before Phase 7)

- [ ] All acceptance criteria implemented and verified
- [ ] Phase 6 findings resolved, or explicitly accepted with a reason recorded
- [ ] Security baseline completed, every item marked applies or N/A-with-reason
- [ ] Handoff package complete, and every documented command actually executed
- [ ] Someone who did not build it cloned and ran it from the README alone
- [ ] Client dependency register closed or its outstanding items acknowledged in writing

---

## When something cannot be met

Say so in the PR, with the reason, and get an explicit accept. An unmet item that is
disclosed and accepted is a decision. An unmet item that is quietly skipped is a defect
someone finds later, and by then it is expensive and it is yours.
