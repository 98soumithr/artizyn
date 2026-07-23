# Documentation index

Artifacts in the order they are produced. Each is a gate; nothing proceeds until the
previous one is complete and signed where required.

| File | Phase | Produced by | Signed by |
|---|---|---|---|
| `00-intake.md` | 0 | Claude + client answers | — |
| `01-spec.md` | 1 | Claude, human-edited | **Client** |
| `02-system-model.md` | 1.5 | Claude, human-reviewed | — |
| `04-estimate.md` | 1.6 | Engineering | — |
| `03-adr.md` | 2 | **Human, not the model** | Engineering lead |
| `05-dependencies.md` | 0, ongoing | Project lead | — |
| `changes/CR-NNN.md` | ongoing | Project lead | Client, per CR |
| `runbook.md` | 7 | Claude, verified | — |
| `environment.md` | 7 | Claude, verified | — |
| `limitations.md` | 7 | Claude, verified | — |

## Standing references

Not per-project artifacts — these apply to every project and are read, not written.

| File | Read at | Purpose |
|---|---|---|
| `definition-of-done.md` | Before every PR | The single pre-PR checklist |
| `security-baseline.md` | Phase 2, 4, 6, 7 | Security checklist and the Phase 6 security prompt |
| `migrations.md` | Phase 2, any schema change | Migration rules and production procedure |
| `environments.md` | Phase 2, 3, 7 | Local/staging/production, deploy and rollback |
| `observability.md` | Phase 2, 3 | Error tracking, logging, uptime |

## Phase 3 setup

```bash
./scripts/init-stack.sh          # detects stack from the ADR
./scripts/init-stack.sh python   # or state it explicitly
```

Installs the matching preset from `presets/`, enables the stack-dependent CI jobs.
Idempotent — re-run to switch stack. Refuses to guess when the ADR is ambiguous.

Track (P / L / F): {{SET AT INTAKE}}
