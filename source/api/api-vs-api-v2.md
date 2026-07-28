# API vs API-v2

When to use the classic Madek API versus API-v2. Endpoint schemas live in the
API Browser / Swagger UI — not on this page.

## Comparison

| | **API** (`api`) | **API-v2** (`api-v2`) |
|--|-----------------|------------------------|
| Style | JSON / **JSON-ROA** | JSON + **OpenAPI** / Swagger |
| Path | `/api` | `/api-v2` |
| Docs | [API Browser](https://zhdk.medienarchiv.ch/api/browser) *(example)* | [Swagger UI](https://zhdk.medienarchiv.ch/api-v2/api-docs/index.html#/) *(example)* |
| Deploy | Always on | Optional — `api_v2: False` by default in deploy |
| Auth | Session, Basic, Token | Session, Token (+ CSRF on mutations) |
| Scopes | Single surface | `--http-resources-scope ADMIN\|USER\|ALL` |
| Maturity | Mature resource set | Still evolving (schemas/permissions/pagination caveats in README); often enable admin-first |

## Guidance

- Prefer **classic API** for existing integrations (including
  [madek-exporter](https://github.com/Madek/madek-exporter)) and JSON-ROA clients.
- Use **API-v2** when you want OpenAPI tooling, admin-scoped access, or new
  work that targets `/api-v2` — and confirm the instance has api-v2 enabled.
- The **webapp** is not a substitute for either API; browsers use session
  cookies against webapp/auth. Machine clients should use token/Basic as
  documented in [Authentication](auth.md).

See [API overview](index.md) and [Consumers](consumers.md).
