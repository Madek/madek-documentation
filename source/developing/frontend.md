# Frontend development

How the Madek **webapp** front end is built today. UI patterns:
[UI framework](ui/framework.md), [UI React](ui/react.md), [UI Polybox](ui/polybox.md).

## Stack (current)

| Layer | Reality in `webapp` |
|-------|---------------------|
| JS entry | `app/javascript/` (`application.js`, React views/decorators, embedded-view) |
| Bundler | **Browserify** + watchify (`package.json` scripts) → `public/assets/bundles/` |
| UI | React presenters/decorators (ROCA-style URL-driven boxes) |
| CSS / static | Rails assets under `app/assets` plus checked-in / generated files under `public/assets` |

Local JS:

```bash
cd webapp
npm install
npm run watch    # or npm run build for production bundles
```

Rails also has `bin/precompile-assets` (and CI equivalents) for the full asset
pipeline. Bundles land in `public/assets/bundles/` (`bundle.js`,
`bundle-embedded-view.js`, `bundle-react-server-side.js`, …).

There is **no Vite** toolchain in the current webapp `package.json`.

## Ajax / client requests

Prefer the shared `app-request` helper used by React decorators over ad-hoc
jQuery patterns. Legacy jQuery plugins (e.g. fixed table headers) may still
exist in older views — initialize carefully if a table is shown after being
hidden.

## PDF display

PDFs are shown in two ways:

1. Converted JPG previews/thumbnails (`Preview`)
2. Embedded PDF via **pdf.js** (`MediaEntry#document` / document preview partials)

Permission note: view-level access (`get_metadata_and_previews`) covers image
previews; showing/downloading the original PDF needs **`get_full_size`**
(“download original”).

Authenticated raw-file access uses **`access_token`** query params (Zencoder /
media file download). `access_hash` remains only as a backwards-compatible
fallback in `MediaFilesController`.

Sources of interest: pdf.js assets under `app/assets`,
`media_entries/document` views and preview partials.
