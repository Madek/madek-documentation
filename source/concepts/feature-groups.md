# Feature groups and explorative surfaces

Technical behaviour of configurable Explore surfaces and related
`app_settings`. End-user how-tos belong in
[User documentation](https://doku.madek.ch/).

In code/docs, “feature groups” maps to:

1. **Explore** blocks driven by **AppSetting** keys
2. **Sections** (keyword-linked UI labels/colours on show pages) — separate
   entity, configured under `/admin`

## Explore (system model)

Explore is for public and logged-in users. Subsections are configured in
`app_settings` and rendered by Explore presenters
(`webapp/.../presenters/explore/`).

- Main nav (“Explore”) and login/root page reuse the same building blocks
- Sidebar lists subsections; Explore itself shows a reduced overview

### Explore Teaser Entries

Pre-defined [MediaEntries][] in the [Collection][] given by
`app_settings.teaser_set_id` (limited list; not part of every subsection page).

### Explore Catalog

Catalog categories come from **`app_settings.catalog_context_keys`** (array of
ContextKey ids), not a bare `context_keys` column. Presenters load those
ContextKeys and expose Keyword values for filtered search that leaves Explore.

Localized titles: `catalog_titles` / `catalog_subtitles`.

### Explore Featured Content

Collection from **`app_settings.featured_set_id`**, with
`featured_set_titles` / `featured_set_subtitles`. Content is child resources of
that set.

### Explore Most Used Keywords / Vocabularies

Keyword and vocabulary sections on Explore / login (see
`explore_keywords_section`, `explore_vocabularies_section` presenters). Keywords
for core usage are typically tied to `madek_core:keywords`.

### Login page variants

| Login block | Same as |
|-------------|---------|
| Login Teaser Entries | Explore Teaser Entries (different limit / metadata) |
| Login Catalog | Explore Catalog |
| Login Featured Content | Explore Featured Content |
| Login Latest Media Entries | Latest [MediaEntries][] by `created_at` desc |

### Other AppSetting surfaces (related)

Not all “Explore” but same settings row: `contexts_for_dynamic_filters`,
`contexts_for_entry_edit` / `collection_edit`, validation/extra context lists,
branding/locale fields. See [Meta data config](../architecture/meta_data_config.md).

## Sections (admin entity)

`Section` (`datalayer`) belongs to a Keyword (and optional index Collection),
with localized labels. Managed in admin-webapp (`resources :sections`). Used to
extend keyword presentation on entry/collection show — distinct from Explore
catalog ContextKeys.

## Related technical concepts

### Entrusted

A resource that is not publicly viewable, but the user has view permissions
(directly or via a Group). See [Permissions](permissions.md).

### "My Madek" (system notes only)

Logged-in dashboard / home. Resource lists (drafts, entries, sets, favorites,
entrusted, groups) are user-facing — UI in User documentation. Technical note:
drafts appear only in “My Drafts”.

[MediaEntry]: ../architecture/entities.md#mediaentry
[MediaEntries]: ../architecture/entities.md#mediaentry
[Collection]: ../architecture/entities.md#collection
[Collections]: ../architecture/entities.md#collection
[ContextKey]: ../architecture/entities.md#contextkey
[Keyword]: ../architecture/entities.md#keyword
[Keywords]: ../architecture/entities.md#keyword
[MetaKey]: ../architecture/entities.md#metakey
