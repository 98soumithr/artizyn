# Environments and deployment

Defined at Phase 2, provisioned at Phase 3, documented at Phase 7.

**Why this document exists.** The SOP otherwise implies laptop to production. Real client
work needs a place to demonstrate before delivering, a place to test migrations against
realistic data, and an explicit rule about who may deploy where. Without staging, every
client demo happens in production and every migration is tested for the first time on live
data.

---

## The three environments

| | **Local** | **Staging** | **Production** |
|---|---|---|---|
| Purpose | Development | Client review, migration rehearsal, integration testing | Live |
| Data | Seed | Anonymized copy of production, or realistic seed | Real |
| Deploys from | — | `main`, automatic | Tagged release, manual |
| Who deploys | Anyone | Anyone | {{NAMED PERSON}} only |
| Third-party services | Sandbox / test keys | Sandbox / test keys | Live keys |
| Debug output | On | Off | Off |
| Monitoring | — | Errors only | Errors, uptime, alerting |
| Client access | No | Yes | Yes |

**Track L may run staging only**, with production created at delivery. Track F provisions
all three at Phase 3, before implementation begins.

Staging must match production in runtime version, database engine and version, and
environment variable names. A staging environment that differs from production in any of
those tests nothing useful.

## Rules

1. Production deploys are manual, from a tag, by one named person. Never automatic from a branch.
2. Every migration runs in staging first, against realistic data volume.
3. Test keys never reach production; live keys never reach staging or local. Distinct credentials per environment (security baseline D4).
4. Client demos happen in staging.
5. Production access is limited to the named deployer. Others receive logs, not shell access.
6. Every production deploy is recorded in the deploy log.

## Deploy log

`docs/deploy-log.md`, appended on every production deploy.

```
| Date | Version | Deployed by | Migration? | Backup ID | Rollback target | Notes |
|------|---------|-------------|------------|-----------|-----------------|-------|
```

Written *before* the deploy, not after. During an incident nobody remembers the rollback
target, and that is exactly when it is needed.

## Release procedure

```
1. Full suite green on main — working, holdout, cross-feature
2. Phase 6 verification complete, blocking findings resolved
3. Deploy to staging, smoke test
4. Migration rehearsed in staging if applicable
5. Tag the release
6. Record the row in the deploy log, including backup ID and rollback target
7. Back up production, verify the backup
8. Deploy
9. Health check, sample transaction, error rate for 15 minutes
10. Rollback if degraded — do not debug in production under pressure
```

## Rollback

Application: redeploy the previous tag.
Schema: run down, or restore from backup where down is untested or irreversible.

Rollback is the default response to a failed deploy. Debugging live under time pressure
produces second incidents.

## Provisioning checklist (Phase 3)

- [ ] Staging provisioned, matching production versions
- [ ] Production provisioned or scheduled
- [ ] Separate databases per environment
- [ ] Separate third-party credentials per environment
- [ ] Environment variables set in each, names matching `.env.example`
- [ ] Automatic backups enabled on production, retention stated
- [ ] Backup restore tested once — an untested backup is not a backup
- [ ] Error tracking receiving events from staging and production
- [ ] Uptime monitoring on production
- [ ] Deploy access restricted to the named person
- [ ] Client given staging access

## In the ADR

Phase 2 must state: hosting provider per environment, deploy mechanism, the named
production deployer, backup mechanism and retention, and who pays for what.

That last point matters commercially. Staging is a cost the client may not have budgeted
for, and it is far easier to raise at Phase 2 than at invoice.
