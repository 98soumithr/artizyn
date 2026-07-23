# Data model and migrations

**Why this document exists.** Coding agents generate destructive migrations without
hesitation — dropping a column, renaming a table, altering a type in place. On a local
database that is an inconvenience. On a client's production database with real data and no
recent backup, it is unrecoverable. Migrations are the one category of generated code where
a mistake cannot be fixed by reverting a commit.

---

## Hard rules

1. **Every schema change is a migration file.** No manual DDL against any environment, ever, including a quick fix in production.
2. **A human reads every migration before it runs anywhere.** No exceptions, no matter how small the change appears. This is the single most important rule in this document.
3. **Migrations are append-only.** Once a migration has run in staging or production it is never edited. Fix forward with a new migration.
4. **Every migration has a tested down path**, or is explicitly marked irreversible with the reason recorded in the file.
5. **Back up before every production migration.** Verify the backup completed before proceeding. See the runbook.
6. **Destructive operations are a separate, deliberate deploy** — never bundled with a feature.

Destructive means: `DROP TABLE`, `DROP COLUMN`, `TRUNCATE`, `ALTER COLUMN` narrowing a type
or adding `NOT NULL` to a populated column, or any `UPDATE`/`DELETE` without a `WHERE`.

## AGENTS.md rules for this project

Copy into the PROJECT hard rules section at Phase 3:

```
- Migrations live in {{PATH}}. Never modify an existing migration file — add a new one.
- Never run a migration against any environment. Generate the file and stop.
- Never generate a DROP, TRUNCATE, or type-narrowing ALTER without stating the data-loss
  consequence and asking first.
- Every migration includes a down path, or states why it is irreversible.
```

## Expand / contract

The pattern that makes schema changes safe against running code. Renaming a column in one
step breaks every deployed instance the moment the migration lands.

**Expand** — add the new structure. Old and new coexist. Deployable independently.
**Migrate** — backfill, in batches, resumable. Application writes both.
**Contract** — remove the old structure. Separate deploy, after the new path is proven.

Renaming `user.name` to `user.full_name`:

1. Add `full_name`, nullable.
2. Deploy code writing both fields, reading `name`.
3. Backfill `full_name` in batches.
4. Deploy code reading `full_name`, still writing both.
5. Verify in production over a real usage window.
6. Drop `name`. Separate deploy.

Slower than a rename, and it is the difference between a routine change and an outage.

## Backfills

Batched with a bounded size, resumable from where it stopped, idempotent so a re-run is
safe, and logged with progress. Never a single `UPDATE` across a large table — it locks,
and it cannot be resumed if it fails halfway.

Backfills for large tables run as a script, not as a migration.

## Review checklist

Before any migration reaches staging:

- [ ] Read line by line by a human
- [ ] Destructive operations identified, and separated from feature changes
- [ ] Down path exists and has been tested locally
- [ ] Locking impact assessed against production table size
- [ ] Indexes added concurrently where the engine supports it
- [ ] Backfill is batched, resumable, idempotent
- [ ] Running application code tolerates both old and new schema
- [ ] Tested against a restored copy of production data, not an empty database

That last item catches most of what the others miss. An empty database makes every migration
look fast and safe.

## Production procedure

```
1. Announce the window if downtime is possible
2. Back up. Verify the backup file exists and its size is plausible.
3. Note the current migration version — this is the rollback target
4. Run the migration
5. Verify: row counts, a sample query, application health check
6. Monitor errors for 15 minutes
7. If failed: restore from backup, or run down if the failure is clean and down is tested
```

Record the backup location and migration version in the deploy log before starting. In an
incident, nobody remembers them.

## Seed data

`seeds/dev.{{ext}}` — realistic volumes, deterministic, safe to re-run.
`seeds/test.{{ext}}` — fixtures for the frozen suite. Cross-feature tests depend on these
being stable, so treat changes as test changes.

Never seed production. Never copy production data to dev unless it is anonymized — see the
security baseline, G1.

## In the ADR

Phase 2 must state: the migration tool and version, where migrations live, how they are
applied per environment, who may apply them to production, the backup mechanism and its
retention, and whether zero-downtime is a requirement.
