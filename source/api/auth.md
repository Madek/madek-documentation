# API authentication

How clients authenticate against Madek **API** and **API-v2**. Sign-in UX for
humans lives in the **auth** service (`/auth`). Request schemas:
[API Browser](https://zhdk.medienarchiv.ch/api/browser) /
[Swagger](https://zhdk.medienarchiv.ch/api-v2/api-docs/index.html#/)
*(ZHdK examples)*.

## Mechanisms

| Mechanism | API (v1) | API-v2 | Notes |
|-----------|----------|--------|-------|
| **Session cookie** | yes | yes | Cookie `madek-session` → `user_sessions.token_hash` |
| **API token** | yes | yes | `api_tokens` with read/write scopes |
| **HTTP Basic** | yes | no | ApiClient login/password, or user (+ token fallback) |
| **CSRF** | n/a for typical API clients | **required on mutating requests** | Cookie `madek-anti-csrf-token` must equal header `x-csrf-token` |

Auth wrappers: `api` tries session → basic → token; `api-v2` tries token →
session (no Basic wrap).

## Pitfalls

- **Session cannot mutate on classic API** — POST/PUT/DELETE with session auth
  return **405** (“Destructive methods not allowed for session
  authentication”). Use a token (or Basic) for writes.
- **API-v2 CSRF** — browser/session clients must fetch CSRF and send matching
  cookie + header on data-changing calls (see api-v2 README / auth-info docs).
- **Auth service ≠ API auth** — `/auth` handles interactive sign-in systems;
  APIs consume the resulting session or separate tokens/ApiClients.

## Client example patterns

[madek-exporter](https://github.com/Madek/madek-exporter) talks to the classic API
with either Basic (`login`/`password`) or a Bearer session token
(`jvm_main/.../utils.clj` `options-to-http-options`).

See [API overview](index.md) and [API vs API-v2](api-vs-api-v2.md).
