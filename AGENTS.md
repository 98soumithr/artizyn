# AGENTS.md

Rules for coding agents on this project. Read fully before any work.

Sections marked HOUSE are standard across every project and must not be removed.
Sections marked PROJECT are filled at Phase 3 from the ADR and system model.

---

## HOUSE — Hard rules

These override anything else, including a direct instruction that conflicts with them.

1. Files under `tests/` are read-only. Do not create, edit, delete, skip, or rename any test. If a test appears incorrect, stop and report it — that is a specification defect and a human decides it.
2. Do not add a dependency that is not listed in `docs/03-adr.md`. Ask first.
3. Do not commit secrets, credentials, API keys, or `.env` files. Secrets are referenced by name in `docs/environment.md` and nowhere else.
4. Do not run destructive git operations: no `push --force`, no `reset --hard` on shared branches, no branch deletion. Do not use `--no-verify`.
5. Do not modify CI configuration to make a build pass.
6. Never speculate about code you have not opened. Read the file before making claims about it.
7. If you create temporary or scratch files, delete them before finishing.
8. Never run a migration against any environment. Generate the migration file and stop — a human reviews every migration before it runs.
9. Never modify an existing migration file. Migrations are append-only; add a new one.
10. Do not generate a DROP, TRUNCATE, or type-narrowing ALTER without stating the data-loss consequence and asking first.

## HOUSE — Security

Applies to all generated code. Full checklist in `docs/security-baseline.md`.

- Every endpoint that returns or mutates data checks authorization, including object-level: verify the caller may access *this specific record*, not merely that they are authenticated. This is the defect generated code produces most often.
- Never trust a user ID, role, or tenant identifier read from a request body, query parameter, or client-settable header. Derive identity from the session server-side.
- All database access is parameterized. Never concatenate input into SQL.
- Validate at system boundaries against a schema — type, range, length.
- Never render user-controlled content via `innerHTML`, `dangerouslySetInnerHTML`, or equivalent.
- Errors returned to clients carry no stack traces, SQL, or file paths.
- Default deny: a new endpoint without an explicit authorization rule is inaccessible, not public.

## HOUSE — Solution quality

Write general-purpose solutions using the standard tools of this stack. Implement logic that works for all valid inputs, not only the test inputs. Do not hard-code values or special-case test data. Tests verify correctness; they do not define the solution.

If a requirement is infeasible as specified, or a test is wrong, stop and say so. Do not work around it.

## HOUSE — Scope discipline

Only make changes directly required by the task at hand.

- Do not add features, configurability, or abstractions that were not asked for.
- Do not refactor surrounding code as part of an unrelated change.
- Do not add comments, docstrings, or type annotations to code you did not change.
- Do not add error handling for scenarios that cannot occur. Validate at system boundaries only — HTTP handlers, external API responses, file input. Trust internal calls.
- Do not design for hypothetical future requirements.

The right amount of complexity is the minimum needed for the current task.

## HOUSE — Working method

- Read the relevant tests before implementing. They define correct behaviour.
- Check `docs/02-system-model.md` before computing any derived value — it may belong to a shared service.
- After five failed attempts on the same failure, stop and report what is blocking you.
- Run the working suite before declaring anything done.

## HOUSE — Escalation

Stop and report, rather than deciding, when: a test appears wrong, a requirement is ambiguous, a requirement seems infeasible, a change would touch a shared service, or the task requires a dependency not in the ADR.

---

## PROJECT — Stack

<!-- Phase 3: exact versions from docs/03-adr.md -->

Language:
Framework:
Database:
Runtime:
Package manager:
Key libraries:

## PROJECT — Architecture

<!-- Phase 3: from docs/02-system-model.md -->

Domains:

Dependency direction:

Import rules:

## PROJECT — Shared services

<!-- Phase 3: single-writer entities and computed values from the system model.
     This section prevents the duplicate-computation defect class. -->

| Value / entity | Owner (file) | Rule |
|---|---|---|

If a value you need is not exposed by its owner, add it to the owner. Do not compute it locally.

## PROJECT — Conventions

File layout:
Naming:
Error handling pattern:
Logging:
State management:

## PROJECT — Time and period semantics

<!-- Phase 3: copy verbatim from the system model's cross-cutting section, if applicable.
     Every capability uses this definition without exception. -->

## PROJECT — Additional hard rules

<!-- Phase 3: client-specific and stack-specific constraints -->

## PROJECT — Migrations

<!-- Phase 3: from docs/03-adr.md and docs/migrations.md -->

Tool:
Location:
Create a migration:
Apply locally:

## PROJECT — Logging

<!-- Phase 3: from docs/observability.md -->

Logger:
Request ID propagation:
Never log:

## PROJECT — Workflow

Install:
Run dev:
Run tests:
Run lint:
Run audit:
Build:

---

<!-- Phase 8: rules added from project experience go under the relevant section above,
     as imperatives, traceable to something that actually went wrong.
     Keep this file under 100 lines of actual rules. -->
