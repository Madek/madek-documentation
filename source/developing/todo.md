> Filled 2026-07-28 against Madek ~v4.11. Checklists below marked done.

# Developing Madek — chapter todos

Living tracker (not published). Goal: replace setup/testing stubs and refresh
legacy guides against current webapp / admin-webapp / CI.

**SoT:** [Madek/Madek](https://github.com/Madek/Madek) — `webapp`, `admin-webapp`,
`datalayer`, `integration-tests`, `cider-ci.yml`, per-service READMEs.

| Page | Doc status | Gap vs Madek | Action |
|------|------------|--------------|--------|
| [setup.md](setup.md) | `stub` | Empty | Bootstrap guide from umbrella + per-service |
| [testing.md](testing.md) | `stub` | Empty | Map specs ↔ CI jobs |
| [developer-rules.md](developer-rules.md) | `legacy` + hooks TODO | Rails hooks section empty | Fill hooks guidelines or drop section |
| [admin-interface.md](admin-interface.md) | `legacy` | May predate current admin-webapp | Align with `/admin` stack |
| [frontend.md](frontend.md) | `legacy` | Asset pipeline story may be obsolete | Document Vite/React as-is |
| [ui/framework.md](ui/framework.md) | `legacy` + `[WIP]` | Patterns may drift | Verify MVP/decorator/atomic or trim |
| [ui/react.md](ui/react.md) | `legacy` + TODOs | Incomplete selection/URL change notes | Fill or delete TODO headings |
| [ui/polybox.md](ui/polybox.md) | `legacy` + HTML WIP | Confirm helpers; fix broken links | Clean WIP comments |
| [error-handling.md](error-handling.md) | `legacy` | — | Confirm error routes still match |
| [translation.md](translation.md) | `legacy` | — | Confirm CSV workflow |
| [copyright.md](copyright.md) | `legacy` | — | Verify vs datalayer / entities |

---

## Diff: docs vs current Madek

### Local setup (stub → fill)

There is **no** single umbrella “start everything” README. Document composition:

| Concern | SoT |
|---------|-----|
| Umbrella tools | `.tool-versions` — ruby `3.3.6`, python `3.11.6` (**deploy uses this too**) |
| Per-service tools | e.g. `webapp/.tool-versions` (different ruby/node), `api-v2/.tool-versions` (clojure/java) — **do not pretend one version** |
| Mux | `.mux.yml` (git + datalayer); service mux under auth/api-v2/mail/… |
| DB | PostgreSQL 15; migrations owned by `datalayer` (`datalayer/bin/setup`, `db:prepare`) |
| Rails bootstrap | `webapp/bin/setup`, `admin-webapp/bin/setup` |
| Clojure services | `*/bin/clj-run`, `clj-dev`, `dev-run-backend` |
| Local proxy | `integration-tests/bin/run-reverse-proxy` + `reverse-proxy/conf/httpd_example.conf` → ports **3100–3105** |
| Shared settings | umbrella `config/settings.yml` (`madek_external_base_url` → `:3100`) |

**Gotcha:** standalone `api/config/settings.yml` often uses port **3100**; behind umbrella proxy API is **3102**.

### Testing (stub → fill)

| Area | Specs | In umbrella `all-tests`? |
|------|-------|--------------------------|
| Webapp | `webapp/spec/`, JS under `app/javascript/spec/` | yes |
| API | `api/spec/` | yes |
| Auth | `auth/spec/` | yes |
| Admin | `admin-webapp/spec/` | yes |
| Datalayer | `datalayer/spec/` | via embedded / integrity |
| Integration | `integration-tests/spec/` | dedicated `integration-tests-*` jobs |
| API-v2 | `api-v2/spec/` | own cider-ci; **not** in umbrella `all-tests` deps |
| Mail | `mail/spec/` | good-to-merge; not always in `all-tests` |

Umbrella entry: `cider-ci.yml` (preflight, integration suites, lint, docs, `all-tests`, `good-to-merge`).  
Link [Submit and review](../project/submit-and-review.md).

### Developer rules / hooks TODO

Open item: “when to use Rails hooks”. Either:

- Document from real patterns in `webapp` (callbacks on MediaEntry/MediaFile, etc.), or
- Remove the empty TODO section until examples are curated.

Refresh ROCA / presenter conventions vs current Vite/React mix.

### Frontend / UI

- Prefer current `webapp/app/javascript`, vite configs, `package.json` over old asset-pipeline prose.
- `ui/react.md` has unfinished “changes that alter selected resources” TODOs — complete from current React selection code or delete.
- `ui/framework.md` still marked `[WIP]` — verify or demote.
- `ui/polybox.md` has commented WIP block and possible broken `./Filters/` link.

### Admin interface

Guide should match current `admin-webapp` (routes under `/admin`, AppSetting, Sections, SMTP, reencode, …). System model stays in [concepts/uberadmin](../concepts/uberadmin.md).

---

## Checklist (clear TODOs)

- [x] Write `setup.md` (tools, DB, proxy ports, per-service bootstrap) → remove `*TODO:*`
- [x] Write `testing.md` (table + CI map) → remove `*TODO:*`
- [x] Resolve hooks `*TODO:*` in `developer-rules.md`
- [x] Clear React / framework / polybox TODO & WIP markers
- [x] Refresh frontend + admin-interface against current stacks
- [x] Spot-check error-handling, translation, copyright
- [x] Update [UPDATE-PROCESS.md](../../UPDATE-PROCESS.md)
