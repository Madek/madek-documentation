# Admin interface development

Guide for working on the **admin-webapp** (proxied at `/admin`). System model
(who is admin, uberadmin mode, api-v2 admin): [Uberadmin](../concepts/uberadmin.md).
Day-to-day operation: User documentation / Wiki.

## Stack

| Piece | Notes |
|-------|--------|
| App | Separate Rails app submodule `admin-webapp` |
| Mount | Path prefix `/admin` (`config/routes.rb` `scope '/admin'`) |
| Data | Shared **datalayer** / same DB as webapp |
| Auth | Production uses Madek session/auth; **dev/test** may use `test_auth` sign-in routes under `/admin` |

Follow the same quality bar as [Developer rules](developer-rules.md) (ROCA where
applicable; review via [Submit and review](../project/submit-and-review.md)).

## Scope of `/admin`

Typical resources (non-exhaustive; see `admin-webapp/config/routes.rb`):

- Users, groups, people, api_clients, delegations
- Vocabularies, meta keys, contexts, context keys, keywords, roles
- App settings, sections, static pages, usage terms
- Media entries/files/previews, zencoder jobs (ops helpers)
- Notification cases, SMTP-related settings
- Io interfaces / mappings

## Conventions

- Base URL is always under `/admin/`.
- Prefer same-tab navigation (links should not open new tabs by default).

Local bootstrap: see [Local setup](setup.md) (`admin-webapp/bin/setup`, port
**3103** behind the reverse proxy).
