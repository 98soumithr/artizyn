## Acceptance criteria

Closes: AC-

## Definition of Done

Full checklist: `docs/definition-of-done.md`

- [ ] Working suite green; manually exercised
- [ ] **No files under `tests/` modified**
- [ ] No unrequested scope; no dependency outside the ADR
- [ ] Derived values come from their owning shared service
- [ ] **Authorization checked on every new endpoint, including object-level**
- [ ] **No identity, role, or tenant read from client-controlled input**
- [ ] **Queries parameterized; no secrets in the diff**
- [ ] Errors handled and logged with context; nothing internal leaked to clients
- [ ] Linter clean; no debug output or scratch files

## Migrations

- [ ] N/A — no migration in this diff

If a migration is present:
- [ ] Read line by line by a human
- [ ] Down path present, or irreversibility stated with reason
- [ ] Destructive operations separated from feature changes
- [ ] Tested against production-shaped data, not an empty database

## Phase 6 findings

<!-- Reviewer agent output. Blocking items resolved or explicitly accepted with a reason. -->

## Unrequested scope

<!-- Anything not traced to an AC. Normally "none". -->
