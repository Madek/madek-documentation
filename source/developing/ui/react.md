# REST-full, isomorphic, progressively enhanced UI with Presenters and React

Primary example: decorator `MediaResourcesBox` (interactive “PolyBox”) under
`webapp/app/javascript/react/decorators/`. Bundling: [Frontend](../frontend.md).

## High-Level-Overview

> *NOTE:* This describes a specific "Decorator" inside Madek, but
it is conceptually build to behave like a single "View" in a "Single Page JS App",
and the overview can be read with that in mind to make sense outside of Madek.
>
> Also note that because it is build this way,
  it can **only be used** once per "Rails-View"!

* Component input is always bound to an **URL**
    - The URL returns data `{get: config: {}, resources: {}, …}`
    - Any URL parameters under keyword 'list' are merged onto data: `get.config`
    - Resulting data is the only input for rendering
    - GET on a route with this component:
        - html: fully rendered component, wrapped in a "hook" node that stores
          the input data as a `data-react-props` property.
        - json: returns just the data

* Interaction/Affordances
    - Any Button that changes the config is a link to the current URL with the
      respective config applied
    - Any Text input that changes config has a 'name' that matches the config key,
      so that a form submit result in a GET to the current page with the
      respective config applied
    - *NOTE:* for even better fallback, all buttons would need to be implemented as
      form input elements, so that the complete configuration is always built from
      a single form submit (can still be handled client-side by serializing form).

## Enhancements:

Running in client when JavaScript enabled (normal case)

### Initialization:
- `this.state.active` is set to `true`
- `get.config` is merged together from comp. state, props and defaults
- Component is re-rendered from the stored data from the "hook" node
- Per default, nothing happens because the data is the same
- Where changes are wanted, they are conditionally applied inside the component
  according to `this.state.active`
  (Example: `<input type="text"/>` vs. `<Autocomplete/>`)

### Re-Render

component is re-rendered whenever either:

- `this.state` is changed directly (handled by React) *or*
- URL params change (handled by listening to `history` and setting `this.state`)

### Handling Changes

#### Changes that alter *neither* the selected resources *nor* the URL:

- internal state that is not defined by url, like "selected" resources
- `this.state` is set und component re-renders

#### Changes that *don't* alter the selected resources, but the URL:

- can be handled without any network request
- Link is disabled in browser, but pushed into browser `history`!
- (The new config is then applied because the component listens to `history`)

#### Changes that alter selected resources (and the URL):

- Push the new URL into `history`, then load list data as JSON for that path
  (`json_path` / Accept JSON on the same ROCA route) and merge into box state
  (`nextState` in `MediaResourcesBox` / `mediaResourcesBoxState`)
- Show loading UI while pages or filter results arrive (`loadingNextPage`, etc.)
- Selection may be cleared or recalculated when the resource set changes

#### Changes that alter one or more *selected resources*:

- Selection lives in box state (`selectedResources`); actions (clipboard, batch
  destroy, …) POST/PATCH via `app-request` with the selected ids
- Batch edit and similar flows open dedicated modals/routes rather than
  mutating presenter JSON in place
- Prefer the current React decorators under
  `webapp/app/javascript/react/decorators/` over obsolete Backbone-style client
  models
