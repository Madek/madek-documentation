# Documentation update process

Living tracker for chapter-by-chapter content updates after the IA restructure
([TO-CLARIFY-V3.md](TO-CLARIFY-V3.md)). This file tracks **status**;
detailed SoT diffs and checklists live in per-chapter `todo.md` files
(not published MkDocs content).

**Git parity snapshot** (stricter “does this page match Madek git?”):
[SECTIONS-UPTODATE.md](SECTIONS-UPTODATE.md).

**Per-chapter todos (compare docs ↔ Madek, then clear published `*TODO:*`):**

| Chapter | Tracker |
|---------|---------|
| Start here | [source/start/todo.md](source/start/todo.md) |
| Concepts & system | [source/concepts/todo.md](source/concepts/todo.md) |
| Developing Madek | [source/developing/todo.md](source/developing/todo.md) |
| API | [source/api/todo.md](source/api/todo.md) |
| Architecture | [source/architecture/todo.md](source/architecture/todo.md) |
| Project | [source/project/todo.md](source/project/todo.md) |

**Repos (double-check against):**

| Repo | Role |
|------|------|
| [Madek/Madek](https://github.com/Madek/Madek) | Umbrella: `webapp`, `admin-webapp`, `api`, `api-v2`, `auth`, `datalayer`, `deploy`, `mail`, `integration-tests`, `documentation`. Note: `storage/` is not a service submodule. |
| [Madek/madek-exporter](https://github.com/Madek/madek-exporter) | Desktop client — SoT only for API consumers / client auth / optional “external client” surface |

---

## Workflow (per chapter)

1. Open the chapter [todo.md](#per-chapter-todos-compare-docs--madek-then-clear-published-todo) and the doc page(s).
2. Diff against the **SoT (Madek)** paths in the chapter todo; if **Exporter?** is yes/partial, also check [madek-exporter](https://github.com/Madek/madek-exporter).
3. Update the page (prefer cross-links; do not duplicate prose); remove published `*TODO:*` / `<mark>` when filled.
4. Tick the chapter-todo checklist; set **Status** and **Last reviewed** (ISO date) in the table below.
5. Smoke-check: `mkdocs build` (or `bin/run.sh check` if available).

### Status vocabulary

| Status | Meaning |
|--------|---------|
| `stub` | Placeholder / TODO only |
| `legacy` | Real content, not yet re-verified against current repos |
| `in_progress` | Actively being rewritten |
| `verified` | Checked against SoT; content matches current system |
| `deferred` | Intentionally thin / out of scope for now |

### Exporter rule

Use exporter as SoT only for:

- API consumer catalog
- Client authentication patterns
- Optional “desktop client” mention in at-a-glance

Exporter does **not** own permissions, DB schema, webapp UI, or deploy.

---

## Recommended chapter order (next content passes)

Dependency-aware sequence — update the status table as you go:

1. **Start:** `start/madek-at-a-glance.md` (surfaces + services from umbrella)
2. **Developing:** `developing/setup.md`, then `developing/testing.md`
3. **Concepts:** `permissions`, `uberadmin`, `notifications` (fill stubs first)
4. **API:** `api-vs-api-v2` → `auth` → `consumers` (exporter double-check)
5. **Architecture:** `entities` / services diagram refresh
6. **Legacy refresh sweep:** media-types, embeds, feature-groups, frontend/ui, project pages
7. **Ops:** only thin how-tos when extracted (`project/ops.md`; full ops stays deferred)

---

## Status table

Statuses after 2026-07-28 fill + outdated-content refresh against Madek ~v4.11.
Canonical git-parity table: [SECTIONS-UPTODATE.md](SECTIONS-UPTODATE.md).

### Start here

| Page | Status | Suggested todo | SoT (Madek) | Exporter? | Last reviewed | Notes |
|------|--------|----------------|-------------|-----------|---------------|-------|
| [source/index.md](source/index.md) | `legacy` | Re-check external links on next major release | Umbrella README; this repo scope | no | | Slim start page; keep hub-only |
| [source/start/madek-at-a-glance.md](source/start/madek-at-a-glance.md) | `verified` | Re-check on next major release | `config/settings.yml`; services; upload flow | partial | 2026-07-28 | Components + lifecycle filled |

### Concepts & system

| Page | Status | Suggested todo | SoT (Madek) | Exporter? | Last reviewed | Notes |
|------|--------|----------------|-------------|-----------|---------------|-------|
| [source/concepts/media-types.md](source/concepts/media-types.md) | `verified` | Re-check on next major release | `datalayer` `media_file` | no | 2026-07-28 | |
| [source/concepts/embeds.md](source/concepts/embeds.md) | `verified` | Re-check if oEmbed contract changes | oembed controller; EMBED_* | no | 2026-07-28 | |
| [source/concepts/permissions.md](source/concepts/permissions.md) | `verified` | Re-check on next major release | permissions; entrust; policies | no | 2026-07-28 | |
| [source/concepts/feature-groups.md](source/concepts/feature-groups.md) | `verified` | Re-check when Explore/AppSetting changes | AppSetting; Explore; Section | no | 2026-07-28 | catalog_context_keys |
| [source/concepts/uberadmin.md](source/concepts/uberadmin.md) | `verified` | Re-check on next major release | Admin; uberadmin; admin-webapp | no | 2026-07-28 | |
| [source/concepts/notifications.md](source/concepts/notifications.md) | `verified` | Re-check when new notification cases land | notification models; mail | no | 2026-07-28 | |
| [source/concepts/resource-filters.md](source/concepts/resource-filters.md) | `verified` | Re-check on next major release | filter_by | no | 2026-07-28 | |

### Developing Madek

| Page | Status | Suggested todo | SoT (Madek) | Exporter? | Last reviewed | Notes |
|------|--------|----------------|-------------|-----------|---------------|-------|
| [source/developing/setup.md](source/developing/setup.md) | `verified` | Re-check tool versions / ports on next release | `.tool-versions`; bins; proxy | no | 2026-07-28 | |
| [source/developing/testing.md](source/developing/testing.md) | `verified` | Re-check cider-ci deps when CI changes | cider-ci.yml | no | 2026-07-28 | |
| [source/developing/developer-rules.md](source/developing/developer-rules.md) | `verified` | Re-check on next major release | ROCA; hooks | no | 2026-07-28 | |
| [source/developing/admin-interface.md](source/developing/admin-interface.md) | `verified` | Re-check when admin-webapp routes change | admin-webapp | no | 2026-07-28 | Rewritten |
| [source/developing/frontend.md](source/developing/frontend.md) | `verified` | Re-check if bundler stack changes | package.json browserify | no | 2026-07-28 | Not Vite |
| [source/developing/ui/framework.md](source/developing/ui/framework.md) | `verified` | Re-check if presenter patterns change | presenters | no | 2026-07-28 | |
| [source/developing/ui/react.md](source/developing/ui/react.md) | `verified` | Re-check MediaResourcesBox behaviour | React decorators | no | 2026-07-28 | |
| [source/developing/ui/polybox.md](source/developing/ui/polybox.md) | `verified` | Re-check DynamicFilters | SideFilter | no | 2026-07-28 | |
| [source/developing/error-handling.md](source/developing/error-handling.md) | `verified` | Re-check on next major release | Errors::*; ErrorsController | no | 2026-07-28 | |
| [source/developing/translation.md](source/developing/translation.md) | `verified` | Re-check on next major release | translations.csv; i18n-translate.js | no | 2026-07-28 | |
| [source/developing/copyright.md](source/developing/copyright.md) | `verified` | Re-check AppSetting / meta keys | AppSetting notices | no | 2026-07-28 | |

### API

| Page | Status | Suggested todo | SoT (Madek) | Exporter? | Last reviewed | Notes |
|------|--------|----------------|-------------|-----------|---------------|-------|
| [source/api/index.md](source/api/index.md) | `verified` | Re-check on next major release | api / api-v2 docs | partial | 2026-07-28 | |
| [source/api/auth.md](source/api/auth.md) | `verified` | Re-check on next major release | authentication; CSRF | **yes** | 2026-07-28 | |
| [source/api/consumers.md](source/api/consumers.md) | `verified` | Re-check on next major release | ApiClient; exporter | **yes** | 2026-07-28 | |
| [source/api/api-vs-api-v2.md](source/api/api-vs-api-v2.md) | `verified` | Re-check when api-v2 maturity changes | READMEs; deploy | no | 2026-07-28 | |

### Architecture

| Page | Status | Suggested todo | SoT (Madek) | Exporter? | Last reviewed | Notes |
|------|--------|----------------|-------------|-----------|---------------|-------|
| [source/architecture/index.md](source/architecture/index.md) | `verified` | Optional SVG regen | settings; text service list | no | 2026-07-28 | Diagram lag noted |
| [source/architecture/entities.md](source/architecture/entities.md) | `verified` | Re-diff on major schema migrations | structure.sql; models | no | 2026-07-28 | Delegation/Workflow/arcs; curated |
| [source/architecture/meta_data_config.md](source/architecture/meta_data_config.md) | `verified` | Re-check AppSetting keys | AppSetting | no | 2026-07-28 | |
| [source/architecture/resource_filters.md](source/architecture/resource_filters.md) | `verified` | Re-check if filter_by keys change | filter_by | no | 2026-07-28 | |
| `architecture/database/*` | `legacy` | Regenerate ER when Graffle practical | structure.sql | no | | Lag noted on index |
| `architecture/services/*` | `legacy` | Refresh overview.svg art | settings | no | | Text list on index is SoT |

### Project

| Page | Status | Suggested todo | SoT (Madek) | Exporter? | Last reviewed | Notes |
|------|--------|----------------|-------------|-----------|---------------|-------|
| [source/project/branches.md](source/project/branches.md) | `verified` | Re-check remotes periodically | Umbrella branches | no | 2026-07-28 | |
| [source/project/git-reflow.md](source/project/git-reflow.md) | `verified` | Re-check tag scripts on release change | `dev/git-*`, `bin/git-*` | no | 2026-07-28 | |
| [source/project/submit-and-review.md](source/project/submit-and-review.md) | `verified` | Re-check if CI job keys change | cider-ci | no | 2026-07-28 | |
| [source/project/external-contributors.md](source/project/external-contributors.md) | `verified` | Re-check LICENSE / SECURITY links | LICENSE, SECURITY.md | no | 2026-07-28 | |
| [source/project/ops.md](source/project/ops.md) | `deferred` | Add runbooks when extracted | `deploy`; team practice | no | 2026-07-28 | |

---

## Progress snapshot

| Status | Count (approx.) |
|--------|-----------------|
| `stub` | none |
| `verified` / `current` | Nearly all nav pages after 2026-07-28 outdated-content pass — see [SECTIONS-UPTODATE.md](SECTIONS-UPTODATE.md) |
| `legacy` / `stale` | ER/services diagram assets only (text SoT on architecture index) |
| `in_progress` | none |
| `deferred` | ops runbooks / full Ops handbook |
| `partial` | none outstanding in SECTIONS-UPTODATE after entities inventory |

When a chapter reaches `verified`, set **Last reviewed** to the verification date and shorten **Suggested todo** to “re-check on next major release” or similar.
