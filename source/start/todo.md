> Filled 2026-07-28 against Madek ~v4.11. Checklists below marked done.

# Start here — chapter todos

Living tracker (not published). Goal: remove `*TODO:*` from published pages
by filling them from [Madek/Madek](https://github.com/Madek/Madek).

**Compared against:** local umbrella ~Madek-v4.11 (submodules); branch may differ
from `master`. Re-check SHAs before marking `verified`.

| Page | Doc status | Gap vs Madek | Action to clear TODO |
|------|------------|--------------|----------------------|
| [index.md](../index.md) | `legacy` (no inline TODO) | Hub looks fine; external links need spot-check | Confirm User-Doku / Wiki / API Browser / Swagger / Featurescape still valid |
| [madek-at-a-glance.md](madek-at-a-glance.md) | `stub` | Surfaces table OK; **Components**, **Upload→Preview→Publish**, **Other lifecycles** are TODO | Fill from SoT below; then delete `*TODO:*` lines |

---

## Diff: docs vs current Madek

### Surfaces (already in docs — OK)

| Surface | Madek today | Doc match? |
|---------|-------------|------------|
| Webapp | submodule `webapp`, proxy catch-all `/` | yes |
| `/admin` | submodule `admin-webapp`, prefix `/admin` | yes |
| API / API-v2 | `api` → `/api`; `api-v2` → `/api-v2` (**optional**, `api_v2: False` in deploy by default) | partial — mention api-v2 is optional |

### Components & request flow (missing — fill this)

Madek services (`.gitmodules` + reverse proxy):

| Service | Local port (behind proxy `:3100`) | Path | Notes |
|---------|-----------------------------------|------|-------|
| Reverse proxy | 3100 | `/` | `config/settings.yml`, `integration-tests/reverse-proxy/conf/httpd_example.conf` |
| Webapp | 3101 | `/` | Rails UI |
| API | 3102 | `/api` | JSON-ROA |
| Admin-webapp | 3103 | `/admin` | |
| API-v2 | 3104 | `/api-v2` | OpenAPI; often not in local CI httpd templates |
| Auth | 3105 | `/auth` | Sign-in UI + systems |
| Mail | — | no HTTP front door | Polls `emails` table; SMTP from `smtp_settings` |
| Datalayer | — | shared lib / migrations | Nested into services; not a runtime HTTP service |
| `storage/` | — | file dir | **Not** a service submodule (only `.gitkeep`) |

Typical request: client → Apache reverse proxy → path backends (`/auth`, `/api`, `/admin`, `/api-v2`, else webapp).

**SoT:** umbrella `config/settings.yml`, `integration-tests/reverse-proxy/conf/httpd_example.conf`, `deploy/defaults.yml`, each `*/deploy/.../reverse-proxy.conf`.

### Upload → Preview → Publish (missing — fill this)

| Step | SoT |
|------|-----|
| Upload UI | `webapp/app/javascript/react/views/My/Uploader.jsx` |
| Create / previews / publish | `webapp/app/controllers/modules/media_entries/upload.rb` |
| MediaFile + `create_previews!` | `datalayer/app/models/media_file.rb` (ImageMagick for image/pdf; Zencoder for audio/video) |
| Zencoder jobs | `datalayer/app/lib/zencoder_requester.rb`, `zencoder_job.rb` |
| Draft vs published | `media_entries.is_published` (default `false`); default scope published |
| Permissions touchpoint | unpublished: creator-centric; many actions need published (`webapp/.../media_entry_policy.rb`) |

Lifecycle to document: upload → store original → internal thumbs and/or Zencoder → draft (`is_published=false`) → explicit publish.

### Other lifecycles

Defer unless needed; keep user workflows in User-Doku. Optional later: transfer responsibility (ties to notifications), session uberadmin toggle.

---

## Checklist (clear TODOs)

- [x] Write **Components and request flow** (table + 2–3 sentences); link [Architecture](../architecture/index.md)
- [x] Write **Upload → Preview → Publish** from SoT above (technical only)
- [x] Note api-v2 optional / mail worker / no storage service
- [x] Optional one-liner: desktop client → [API consumers](../api/consumers.md) / madek-exporter
- [x] Remove all `*TODO:*` from `madek-at-a-glance.md`
- [x] Spot-check `index.md` external links
- [x] Set status `verified` + date in [UPDATE-PROCESS.md](../../UPDATE-PROCESS.md)
