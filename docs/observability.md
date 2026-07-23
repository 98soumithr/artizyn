# Observability

Decided at Phase 2, wired at Phase 3, handed over at Phase 7.

**Why this document exists.** When a client says "it's broken," you need to know what
happened without asking them to reproduce it. Without error tracking you are debugging from
a screenshot and a description. This is also what makes the post-launch triage in the SOP
workable — classifying something as bug or change requires knowing what actually occurred.

Three components, all of them cheap, none of them optional on Track F.

---

## 1. Error tracking

Sentry, or equivalent. Free tiers cover typical agency project volume.

Captures every unhandled exception with stack trace, request context, and user identifier.
Alerts on a new error type, and on a spike in an existing one.

**Never send to error tracking:** passwords, tokens, card numbers, full personal records.
Configure scrubbing before the first deploy, not after the first leak.

## 2. Structured logging

Logs are JSON, one event per line, with a consistent shape:

```json
{"ts":"...","level":"info","event":"deal.closed","request_id":"...","user_id":"...","deal_id":"...","duration_ms":42}
```

**Levels** — `error`: needs a human. `warn`: degraded but handled. `info`: business events worth reconstructing. `debug`: local only, never production.

**A request ID on every log line**, propagated through the request and returned in the
response header. This is what turns "something failed at 14:32" into a complete trace, and
it costs almost nothing to add at the start and a great deal to retrofit.

**Log at minimum:** every request with method, path, status, duration; every external call
with target, status, duration; every auth event; every permission denial; every state change
to a core entity.

**Never log** secrets, tokens, passwords, full card numbers, or complete personal records.

## 3. Uptime monitoring

An external check hitting a health endpoint every few minutes, alerting on failure.

`GET /health` returns 200 with database reachability and version. It must not require
authentication, and must not leak internal detail.

---

## Rules

1. Error tracking is live in staging before the first production deploy, so the pipeline is proven before it matters.
2. Every log line carries a request ID.
3. Scrubbing rules are configured before any real data flows.
4. Alerts go to a named person. An alert nobody owns is noise.
5. `docs/runbook.md` states where logs live, how to search them, and what the three most common errors mean.

## Phase 3 checklist

- [ ] Error tracking project created, DSN in environment variables
- [ ] Scrubbing configured and verified with a test event containing a fake secret
- [ ] Structured logger wired, request ID middleware in place
- [ ] `/health` endpoint returning dependency status
- [ ] Uptime monitor pointed at `/health`, alerting to a named person
- [ ] Verified end to end: trigger a deliberate error in staging, confirm it arrives with context and no secrets

## In the ADR

State the error tracking service, the logging library and destination, log retention, the
uptime monitor, who receives alerts, and who pays for these after handoff.

## At handoff

The client receives access to error tracking and monitoring, or an explicit statement that
these remain with us under a retainer. Leaving this ambiguous means an outage nobody is
watching, and a difficult conversation about whose responsibility that was.
