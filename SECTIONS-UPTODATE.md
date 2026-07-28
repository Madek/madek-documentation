# Sections up to date with Madek git

Living tracker (not published MkDocs content). Answers: **which doc pages
match current Madek git?** Stricter than [UPDATE-PROCESS.md](UPDATE-PROCESS.md)
(workflow / fill checklists).

**Last checked:** 2026-07-28 (outdated-content refresh pass)  
**Compared against:** local umbrella `/Users/mradl/repos/Madek` (branch
`mr/854-split-sitemap`, not necessarily `master`). Refresh SHAs on each review.

---

## Pinned SoT (this review)

| Component | SHA (short) | Notes |
|-----------|-------------|--------|
| Umbrella [Madek/Madek](https://github.com/Madek/Madek) | `c007a96` | branch `mr/854-split-sitemap` |
| datalayer | `256c84406` | schema SoT: `db/structure.sql` |
| webapp | `088eeb229` | |
| admin-webapp | `358c6d0c5` | |
| api | `74da5aeb6` | |
| api-v2 | `43e36dce0` | |
| auth | `62de6a021` | |
| mail | `ea9aeac93` | |
| deploy | `68b2a8737` | |
| integration-tests | `b3e7abd76` | |
| documentation (submodule in umbrella) | `9f2225c90` | may lag this working tree |

Exporter (API consumers only): [Madek/madek-exporter](https://github.com/Madek/madek-exporter) — separate repo, not an umbrella submodule.

---

## Status vocabulary

| Status | Meaning |
|--------|---------|
| `current` | Spot-checked against named git SoT; content matches for its documented scope |
| `partial` | Accurate on covered topics, but known gaps vs git remain |
| `stale` | Existing prose not re-checked against this SoT, or known drift |
| `deferred` | Intentionally thin / out of scope |
| `n/a` | Hub / process page with little code SoT |

---

## Status table (by nav)

### Start here

| Page | Status | Git SoT | Last checked | Notes |
|------|--------|---------|--------------|-------|
| [source/index.md](source/index.md) | `n/a` | — | 2026-07-28 | Hub + external links only |
| [source/start/madek-at-a-glance.md](source/start/madek-at-a-glance.md) | `current` | settings; proxy; upload; UI Set naming | 2026-07-28 | |

### Concepts & system

| Page | Status | Git SoT | Last checked | Notes |
|------|--------|---------|--------------|-------|
| [source/concepts/media-types.md](source/concepts/media-types.md) | `current` | MediaFile | 2026-07-28 | |
| [source/concepts/embeds.md](source/concepts/embeds.md) | `current` | oembed controller; EMBED_* constants | 2026-07-28 | rich vs video types noted |
| [source/concepts/permissions.md](source/concepts/permissions.md) | `current` | permissions; entrust | 2026-07-28 | |
| [source/concepts/feature-groups.md](source/concepts/feature-groups.md) | `current` | AppSetting; Explore; Section | 2026-07-28 | catalog_context_keys fixed |
| [source/concepts/uberadmin.md](source/concepts/uberadmin.md) | `current` | Admin; uberadmin; admin-webapp | 2026-07-28 | |
| [source/concepts/notifications.md](source/concepts/notifications.md) | `current` | notification models; mail | 2026-07-28 | |
| [source/concepts/resource-filters.md](source/concepts/resource-filters.md) | `current` | filter_by | 2026-07-28 | |

### Developing Madek

| Page | Status | Git SoT | Last checked | Notes |
|------|--------|---------|--------------|-------|
| [source/developing/setup.md](source/developing/setup.md) | `current` | tools; bins; proxy | 2026-07-28 | |
| [source/developing/testing.md](source/developing/testing.md) | `current` | cider-ci; RSpec/Capybara per submodule | 2026-07-28 | |
| [source/developing/developer-rules.md](source/developing/developer-rules.md) | `current` | ROCA + hooks | 2026-07-28 | Refreshed intro |
| [source/developing/admin-interface.md](source/developing/admin-interface.md) | `current` | admin-webapp routes | 2026-07-28 | Rewritten |
| [source/developing/frontend.md](source/developing/frontend.md) | `current` | package.json browserify | 2026-07-28 | No Vite; bundles path |
| [source/developing/ui/framework.md](source/developing/ui/framework.md) | `current` | presenters | 2026-07-28 | Patterns still match ROCA |
| [source/developing/ui/react.md](source/developing/ui/react.md) | `current` | MediaResourcesBox | 2026-07-28 | |
| [source/developing/ui/polybox.md](source/developing/ui/polybox.md) | `current` | SideFilter | 2026-07-28 | |
| [source/developing/error-handling.md](source/developing/error-handling.md) | `current` | Errors::*; ErrorsController | 2026-07-28 | |
| [source/developing/translation.md](source/developing/translation.md) | `current` | translations.csv; i18n-translate.js | 2026-07-28 | |
| [source/developing/copyright.md](source/developing/copyright.md) | `current` | AppSetting notices; MetaData | 2026-07-28 | System model TL;DR fixed |

### API

| Page | Status | Git SoT | Last checked | Notes |
|------|--------|---------|--------------|-------|
| [source/api/index.md](source/api/index.md) | `current` | api / api-v2 | 2026-07-28 | |
| [source/api/auth.md](source/api/auth.md) | `current` | authentication | 2026-07-28 | |
| [source/api/consumers.md](source/api/consumers.md) | `current` | ApiClient; exporter | 2026-07-28 | |
| [source/api/api-vs-api-v2.md](source/api/api-vs-api-v2.md) | `current` | READMEs | 2026-07-28 | |

### Architecture

| Page | Status | Git SoT | Last checked | Notes |
|------|--------|---------|--------------|-------|
| [source/architecture/index.md](source/architecture/index.md) | `current` | services list | 2026-07-28 | Diagram lag documented |
| [source/architecture/entities.md](source/architecture/entities.md) | `current` | structure.sql + models; UI Set naming | 2026-07-28 | Gaps documented (Delegation, ConfidentialLink, Workflow, arcs); curated not full dump |
| [source/architecture/meta_data_config.md](source/architecture/meta_data_config.md) | `current` | AppSetting contexts_for_* | 2026-07-28 | Key names fixed |
| [source/architecture/resource_filters.md](source/architecture/resource_filters.md) | `current` | filter_by helpers | 2026-07-28 | Permission keys synced |
| `architecture/database/*` | `stale` | structure.sql | 2026-07-28 | ER art not regenerated; lag noted on index |
| `architecture/services/*` | `stale` | settings | 2026-07-28 | SVG may lag; text list on index is SoT |

### Project

| Page | Status | Git SoT | Last checked | Notes |
|------|--------|---------|--------------|-------|
| [source/project/branches.md](source/project/branches.md) | `current` | remotes | 2026-07-28 | |
| [source/project/git-reflow.md](source/project/git-reflow.md) | `current` | git scripts; branches | 2026-07-28 | `$next` default → master |
| [source/project/submit-and-review.md](source/project/submit-and-review.md) | `current` | cider-ci | 2026-07-28 | CI job names |
| [source/project/external-contributors.md](source/project/external-contributors.md) | `current` | LICENSE; SECURITY | 2026-07-28 | |
| [source/project/ops.md](source/project/ops.md) | `deferred` | — | 2026-07-28 | No runbooks |

---

## Entities notes

Inventory decisions applied 2026-07-28:

- **Documented:** Delegation, ConfidentialLink, Workflow, collection arcs, Responsibility+delegation
- **Pointer:** notifications/emails/smtp → Concepts; audited_* → appendix line
- **Historical:** License / MetaDatum::Licenses
- **Still curated:** not every `CREATE TABLE` has a section; ER SVG remains lagging

---

## How to update this file

1. Refresh submodule SHAs from the Madek umbrella.
2. Re-spot-check pages you change; set Status + Last checked.
3. Keep UPDATE-PROCESS for fill workflow; keep **this** file for git-parity.
