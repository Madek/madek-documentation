# Madek at a glance

Short orientation for the technical Madek system. Prefer links over
duplicating other pages.

## Surfaces

Madek is used through three main surfaces:

| Surface | Role |
|---------|------|
| **Webapp** | Primary end-user UI (help and how-tos: [User documentation](https://doku.madek.ch/)) |
| **`/admin`** | Admin / Uberadmin surface — *system model* and *dev guide* live here in this docs site; day-to-day operation belongs in User documentation / Wiki |
| **API** / **API-v2** | Machine integration — orientation in [API](../api/index.md); endpoint reference only via Swagger / API Browser |

An optional desktop app for macOS/Linux/Windows
([madek-exporter](https://github.com/Madek/madek-exporter)) talks to the classic
API; the display kiosk / **Presenter**
([madek-broadcaster](https://gitlab.zhdk.ch/birk/madek-broadcaster)) also uses
**classic `/api` only** (legacy stack). See [API consumers](../api/consumers.md).

## Naming

Domain, code, and API keep model names; the webapp UI sometimes differs:

| Domain / code / API | Webapp UI |
|---------------------|-----------|
| `Collection` | **Set** |
| `MediaEntry` | MediaEntry |

Detail: [Entities](../architecture/entities.md). End-user wording:
[User documentation](https://doku.madek.ch/).

## Components and request flow

Madek is an umbrella of services behind a reverse proxy. In local/dev the
proxy listens on **port 3100** (`madek_external_base_url`) and routes by path.

| Component | Role | Typical local port | Path prefix |
|-----------|------|--------------------|-------------|
| Reverse proxy | Front door | 3100 | `/` |
| **webapp** | Main Rails UI | 3101 | `/` (catch-all) |
| **api** | JSON / JSON-ROA API | 3102 | `/api` |
| **admin-webapp** | Admin UI | 3103 | `/admin` |
| **api-v2** | JSON + OpenAPI API (optional in deploy) | 3104 | `/api-v2` |
| **auth** | Sign-in UI and auth systems | 3105 | `/auth` |
| **mail** | Background worker: sends rows from `emails` via SMTP | — | no HTTP front door |
| **datalayer** | Shared models and DB migrations | — | not an HTTP service |
| **storage/** | Local filesystem for originals/previews | — | **not** a service submodule |

A typical browser request: client → reverse proxy → `/auth`, `/api`, `/admin`,
or `/api-v2` when matched, otherwise **webapp**. Production uses the same path
split with different ports (`deploy`).

See also [Architecture — services overview](../architecture/index.md).

## Technical lifecycles

### Upload → Preview → Publish

1. **Upload** — webapp creates a `MediaEntry` with `is_published: false` and
   stores the original as a `MediaFile`.
2. **Previews** — `MediaFile#create_previews!`: image/PDF via ImageMagick
   internally; audio/video via Zencoder jobs (`ZencoderJob`).
3. **Draft** — unpublished entries are outside the default published scope;
   the creator can still work on them (policy is creator-centric until publish).
4. **Publish** — explicit action sets `is_published = true`; normal
   [permissions](../concepts/permissions.md) and listing rules apply.

UI entry points include the React uploader and
`MediaEntries::Upload` controller concerns. Metadata editing and sharing touch
the same entry before/after publish; details live under Concepts and Entities.

### Other lifecycles

- **Transfer responsibility** — changes responsible entity and can enqueue
  notifications; see [Notifications](../concepts/notifications.md).
- **Uberadmin mode** — admins can toggle a per-session ACL bypass in the
  webapp; see [Uberadmin](../concepts/uberadmin.md).

User-facing workflows stay in [User documentation](https://doku.madek.ch/).

## Related concepts

- [Permissions](../concepts/permissions.md)
- [Feature groups](../concepts/feature-groups.md)
- [Uberadmin](../concepts/uberadmin.md)
- [Notifications](../concepts/notifications.md)
- [Resource filters](../concepts/resource-filters.md)
- [Entities](../architecture/entities.md)
