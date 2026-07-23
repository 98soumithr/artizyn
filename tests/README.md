# Tests — frozen suite

**These files are read-only to implementing agents.** Enforced by CI on every PR.

| Directory | Purpose | Visible during implementation |
|---|---|---|
| `working/` | Happy path + obvious edges, every AC | Yes |
| `holdout/` | Empty states, boundaries, concurrency, permissions, malformed input | **No** |
| `cross-feature/` | Same value identical everywhere it appears | No |

`cross-feature/` is the category that catches two views computing the same number
independently. Derive these from the duplicate-computation section of the system model.

Every test names its AC in a comment: `// AC-07`

## Lifecycle

Written at Phase 4 from the signed spec, before any implementation. Frozen on commit.

Unfrozen only by an accepted change request, and only for the specific ACs that changed.

Bug fixes add a test to `holdout/` first — the test that should have caught it. That test
is committed alone and failing, as the reproduction, then the fix follows. The suite gets
stronger with every defect.
