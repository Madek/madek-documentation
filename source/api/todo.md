> Filled 2026-07-28 against Madek ~v4.11. Checklists below marked done.

# API — chapter todos

Living tracker (not published). Goal: replace stub pages; keep this section
**orientation only** (no endpoint tables — Swagger / API Browser remain SoT).

**SoT:** [Madek/Madek](https://github.com/Madek/Madek) `api`, `api-v2`, `auth`;
client patterns: [Madek/madek-exporter](https://github.com/Madek/madek-exporter)
(partial, for consumers / auth examples only).

| Page | Doc status | Gap vs Madek | Action |
|------|------------|--------------|--------|
| [index.md](index.md) | `legacy` | Hub OK; list exporter as known consumer | Small refresh |
| [auth.md](auth.md) | `stub` | Empty | Session / token / basic / CSRF differences |
| [consumers.md](consumers.md) | `stub` | Empty | ApiClient + exporter + patterns |
| [api-vs-api-v2.md](api-vs-api-v2.md) | `stub` | Empty | When to use which; api-v2 caveats |

---

## Diff: docs vs current Madek

### API vs API-v2 (stub → fill)

| | **API** (`api`) | **API-v2** (`api-v2`) |
|--|-----------------|------------------------|
| Style | JSON / **JSON-ROA** | JSON + **OpenAPI** / Swagger |
| Path | `/api` | `/api-v2` |
| Docs | API Browser | `/api-v2/api-docs/` |
| Deploy | Always on | Optional (`api_v2: False` default in deploy) |
| Auth | Session → Basic → Token; **session cannot mutate** (POST/PUT/DELETE → 405) | Session + Token; **CSRF** on mutating requests (`madek-anti-csrf-token` cookie = `x-csrf-token` header) |
| Scopes | Single surface | `--http-resources-scope ADMIN\|USER\|ALL` |
| Maturity | Mature resource set | README still lists schema/permission/pagination TODOs; often ship admin-first |

**SoT:** `api/README.md`, `api-v2/README.md`, `api/src/madek/api/authentication.clj`, `api-v2/.../authentication.clj`, `anti_csrf/`.

### Authentication (stub → fill)

| Mechanism | Where | Notes |
|-----------|-------|-------|
| Auth service UI | `auth/` at `/auth` | External auth systems / PKI; not the JSON API itself |
| Session cookie | `madek-session` → `user_sessions.token_hash` | Used by browser + some clients |
| API tokens | `api_tokens` read/write scopes | Bearer / token auth |
| HTTP Basic | ApiClient login/password or user (+ token fallback) | **API v1**; not in api-v2 wrap |
| CSRF (v2) | Cookie + header must match | Mutating requests only |

Exporter pattern (out-of-tree): Basic and/or session cookie / Bearer — see `madek-exporter/jvm_main/src/madek/exporter/utils.clj`.

### Consumers (stub → fill)

- **ApiClient** (in-system): can use API, not webapp login; permission tables for api_client. Documented in entities.
- **madek-exporter** (desktop): not mentioned in Madek READMEs; document as known external consumer of classic API.
- Other instance scripts / sync tools: link if known; don’t invent a full catalog.

Keep endpoint details out — link Swagger / Browser.

### Hub (`index.md`)

Already correct policy. Add one line listing exporter under consumers; mark ZHdK links as examples (already done).

---

## Checklist (clear TODOs)

- [x] Write `api-vs-api-v2.md` comparison table → remove `*TODO:*`
- [x] Write `auth.md` (mechanisms + pitfalls: session writes, CSRF, Basic v1-only) → remove `*TODO:*`
- [x] Write `consumers.md` (ApiClient + exporter) → remove `*TODO:*`
- [x] Light touch on `index.md` if needed
- [x] Update [UPDATE-PROCESS.md](../../UPDATE-PROCESS.md)
