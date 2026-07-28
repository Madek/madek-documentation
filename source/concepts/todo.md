> Filled 2026-07-28 against Madek ~v4.11. Checklists below marked done.

# Concepts & system — chapter todos

Living tracker (not published). Goal: replace stub `*TODO:*` pages and clear
`<mark>` warnings where Madek already defines behaviour.

**SoT:** [Madek/Madek](https://github.com/Madek/Madek) — mainly `datalayer`, `webapp`,
`admin-webapp`, `mail`.

| Page | Doc status | Gap vs Madek | Action to clear TODO / marks |
|------|------------|--------------|------------------------------|
| [permissions.md](permissions.md) | `stub` | Empty | Write ACL model from SoT |
| [uberadmin.md](uberadmin.md) | `stub` | Empty | Distinguish admins table / uberadmin mode / admin-webapp / api-v2 admin |
| [notifications.md](notifications.md) | `stub` | Empty | Document narrow real scope (not a full platform) |
| [resource-filters.md](resource-filters.md) | `stub` | Concept only | Short overview; detail stays on architecture page |
| [media-types.md](media-types.md) | `legacy` + `<mark>` | Types still `image/audio/video/document`; PDF special-cased in code | Reconcile marks with `MediaFile`; keep or drop “document→pdf” advice |
| [embeds.md](embeds.md) | `legacy` | Not re-checked | Spot-check oEmbed vs webapp |
| [feature-groups.md](feature-groups.md) | `legacy` | Still talks Explore/`app_settings`; code also has **Section** | Diff keys vs `AppSetting` + Sections |

---

## Diff: docs vs current Madek

### Permissions (stub → fill)

**Actions** (`PERMISSION_TYPES` in `datalayer/app/models/permissions/`):

| Resource | Actions |
|----------|---------|
| MediaEntry | `get_metadata_and_previews`, `get_full_size`, `edit_metadata`, `edit_permissions` |
| Collection | `get_metadata_and_previews`, `edit_metadata_and_relations`, `edit_permissions` |
| Vocabulary | `view`, `use` |

**Subjects:** User (or Delegation: `user_id XOR delegation_id`), Group, ApiClient.  
**Public flags** on resource rows (e.g. `media_entries.get_metadata_and_previews`).  
**Entrusted:** `datalayer/app/models/concerns/entrust.rb` — has view via user/group/api_client permission rows.  
**Policies:** `webapp/app/policies/` + `shared/media_resources/media_resource_policy.rb` (Viewable / Editable / Manageable).

Cross-link [Entities](../architecture/entities.md); UI sharing → User-Doku.

### Uberadmin (stub → fill)

Three different “admin” surfaces — docs must not conflate them:

| Concept | SoT | Meaning |
|---------|-----|---------|
| `admins` table | `datalayer/app/models/admin.rb` | User is an admin |
| Uberadmin **mode** | `POST /session/uberadmin`; `session[:uberadmin_mode]`; `authorization_setup.rb` → FakeUberadminPolicy | Per-request ACL bypass in **webapp** |
| Admin UI | `admin-webapp` under `/admin` | Config: users/groups, vocabularies, app_settings, sections, SMTP, reencode, … |
| API-v2 admin | `/api-v2/admin` | Separate Clojure routes; requires `admins` row; scope `ADMIN\|USER\|ALL` |

### Notifications (stub → fill)

Current system is **narrow**:

| Piece | SoT |
|-------|-----|
| Models | `notification`, `notification_case`, `notification_case_user_setting`, `email`, `smtp_setting` |
| Wired case | `transfer_responsibility` only (`NotificationCase::EMAIL_TEMPLATES`) |
| Templates | `datalayer/app/lib/email_templates/transfer_responsibility.rb` |
| Digests | `concerns/notifications/periodic_emails.rb` (daily/weekly) |
| Delivery | `mail` service polls `emails` (`trials=0`) — does **not** create notifications |
| Gate | beta-tester notifications group for transfer_responsibility |

Do **not** document a broad notification platform without new cases.

### Resource filters (concept stub)

| Concept | SoT |
|---------|-----|
| `filter_by` | `datalayer/app/models/concerns/media_resources/filters/filters.rb` |
| Filter bar facets | `datalayer/app/queries/filter_bar_query.rb` |
| UI | `webapp/.../dynamic_filters.rb` |
| Config | `AppSetting.contexts_for_dynamic_filters` |

Write 1 short conceptual section; link [architecture/resource_filters.md](../architecture/resource_filters.md).

### Media types (legacy marks)

Still: `image` / `audio` / `video` / `document`. PDF handled via `media_type == 'document' and extension == 'pdf'` (`media_file.rb`). `<mark>` about renaming document→pdf remains a product decision — either keep as known debt or soften wording; don’t invent a migration that isn’t planned.

### Feature groups / Explore

Docs name “feature groups”; code uses **Explore AppSettings** + **Section**:

- `AppSetting`: `catalog_context_keys`, `featured_set_id`, teaser/featured titles, `contexts_for_*`
- Explore presenters: `webapp/app/presenters/presenters/explore/`
- Sections: `datalayer/app/models/section.rb` (keyword extension / labels)

Diff page keys vs current `AppSetting` attributes; mention Sections if still relevant.

### Embeds

Spot-check `webapp` oEmbed controller/routes/views + specs; update only if contract drifted.

---

## Checklist (clear TODOs)

- [x] Fill `permissions.md` → remove `*TODO:*`
- [x] Fill `uberadmin.md` (three admin surfaces) → remove `*TODO:*`
- [x] Fill `notifications.md` (transfer_responsibility + mail worker) → remove `*TODO:*`
- [x] Expand `resource-filters.md` concept blurb → remove `*TODO:*`
- [x] Resolve or refresh `<mark>` on `media-types.md`
- [x] Diff `feature-groups.md` vs AppSetting / Section
- [x] Spot-check `embeds.md`
- [x] Update [UPDATE-PROCESS.md](../../UPDATE-PROCESS.md) statuses
