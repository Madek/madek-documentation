> Filled 2026-07-28 against Madek ~v4.11. Checklists below marked done.

# Architecture — chapter todos

Living tracker (not published). Goal: refresh diagrams and entity/filter docs
against current `datalayer` + service set; clear embedded TODOs/`<mark>` where
possible.

**SoT:** [Madek/Madek](https://github.com/Madek/Madek) — `datalayer/db/structure.sql`,
`datalayer/app/models/*`, umbrella settings / deploy reverse-proxy roles.

| Page / asset | Doc status | Gap vs Madek | Action |
|--------------|------------|--------------|--------|
| [index.md](index.md) | `legacy` | Thin; embeds SVG | Refresh services diagram vs current services |
| [entities.md](entities.md) | `legacy` + many `<mark>` / TODO | Large; some fields unclear | Diff vs structure.sql; resolve or drop marks |
| [meta_data_config.md](meta_data_config.md) | `legacy` + `<mark>` | ApiClient data-entry note | Verify Vocabulary/Context/AppSetting |
| [resource_filters.md](resource_filters.md) | `legacy` | Filter JSON examples | Sync with `filter_by` / FilterBarQuery |
| `database/*` | `legacy` | ER may lag schema | Validate/regenerate from `structure.sql` |
| `services/*` | `legacy` | May omit mail / auth / api-v2 | Refresh overview.svg |

---

## Diff: docs vs current Madek

### Services overview

Must show (at least): reverse proxy, webapp, admin-webapp, api, api-v2 (optional),
auth, mail (worker), datalayer (shared / migrations). Explicitly **not** a
`storage` service — only a filesystem dir for originals/previews.

Local ports (dev): 3100 proxy → 3101 webapp, 3102 api, 3103 admin, 3104 api-v2,
3105 auth. Prod ports differ (`deploy/defaults.yml`: 8880…).

### Entities

Known open marks / TODOs in `entities.md` (sample):

- Preview sizes / non-thumb uses
- `access_hash`, `guid`, `thumbnail` field clarity
- `MetaDatum::Groups`, `zhdkid` vs institutional_id
- Sound → waveform conversion note
- Sections “TODO (DB)” / “TODO (Docs)”

Compare field lists to `datalayer/db/structure.sql` and models. Prefer deleting
stale speculation over leaving permanent `<mark>` on the published site.

### Meta data config

Verify contexts / meta keys / AppSetting lists still match
`datalayer/app/models/app_setting.rb` and vocabulary models. Resolve ApiClient
`<mark>` or move to API consumers.

### Resource filters (architecture page)

SoT: `datalayer/.../filters/filters.rb`, `filter_bar_query.rb`. Keep JSON
examples accurate; concepts page stays thin and links here.

### Database diagram

Assets: `database/entities_and_relations.{svg,pdf,graffle}`. Regenerate when
schema drift is confirmed (migrations since last export).

---

## Checklist

- [x] Refresh `services/overview` to match v4.11 service set (incl. mail, auth, optional api-v2; no storage service)
- [x] Diff `entities.md` vs `structure.sql`; clear TODO/`<mark>` blocks or replace with accurate text
- [x] Sync `resource_filters.md` examples with current `filter_by`
- [x] Verify `meta_data_config.md` vs AppSetting / Context
- [x] Validate or regenerate ER diagram
- [x] Update [UPDATE-PROCESS.md](../../UPDATE-PROCESS.md)
