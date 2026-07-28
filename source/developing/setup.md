# Local development setup

How to bring up a local Madek development environment from the
[Madek umbrella](https://github.com/Madek/Madek). There is no single “start all”
script — compose services from the umbrella plus each submodule’s README/`bin`.

## Prerequisites

- **asdf** (or compatible) for language versions
- **PostgreSQL 15**
- System build tools (and Xcode CLT on macOS)
- Apache httpd if you use the integration reverse proxy locally

## Tool versions

| Location | Notes |
|----------|--------|
| Umbrella `.tool-versions` | ruby `3.3.6`, python `3.11.6` (also used by deploy) |
| `webapp/.tool-versions` | Own ruby/node (e.g. ruby 3.2.x, node 20.x) |
| `api-v2/.tool-versions` | Clojure, Java, ruby — differs again |

Install versions **per service directory**. Do not assume one global ruby/node/java
for the whole umbrella.

## Bootstrap outline

1. Clone the umbrella and init submodules (`git submodule update --init --recursive`).
2. Prepare the database from **datalayer** (`datalayer/bin/setup` / `db:prepare` —
   migrations live in datalayer).
3. Bootstrap Rails apps: `webapp/bin/setup`, `admin-webapp/bin/setup` (bundle +
   `db:prepare`).
4. Start Clojure services with their bins (`auth`/`api`/`api-v2`/`mail`:
   `bin/clj-run`, `bin/clj-dev`, `bin/dev-run-backend` as documented per README).
5. Start the reverse proxy for a unified front door:
   `integration-tests/bin/run-reverse-proxy` using
   `integration-tests/reverse-proxy/conf/httpd_example.conf`.

Optional: umbrella `.mux.yml` helps with git/datalayer panes; services may have
their own mux configs.

## Local ports (behind proxy `:3100`)

| Port | Service |
|------|---------|
| 3100 | Reverse proxy (`madek_external_base_url`) |
| 3101 | webapp |
| 3102 | api (`/api`) |
| 3103 | admin-webapp (`/admin`) |
| 3104 | api-v2 (`/api-v2`) |
| 3105 | auth (`/auth`) |

Shared settings: umbrella `config/settings.yml`.

**Gotcha:** a standalone `api/config/settings.yml` often binds API to port
**3100**. Behind the umbrella proxy, API is **3102** and the proxy owns 3100.

## Next steps

- [Testing](testing.md) — how to run specs locally and what CI expects
- [Madek at a glance](../start/madek-at-a-glance.md) — component map
- Per-service READMEs under each submodule for service-specific flags
