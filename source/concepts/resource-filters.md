# Resource filters (concept)

How Madek thinks about filtering indexes of media resources.

Filtering combines several dimensions in one `filter_by` chain
(`datalayer` media-resource filters):

- **Search** — free text (often mapped onto meta-data “any” match)
- **Meta-data** — typed filters per MetaKey / MetaDatum
- **Media files** — e.g. media type / file properties
- **Permissions** — public view, entrusted, visibility helpers
  (`entrusted_to_*`, public flags, …)

The **dynamic filter bar** builds efficient facet queries
(`FilterBarQuery`) for configured contexts/MetaKeys
(`AppSetting.contexts_for_dynamic_filters`). The webapp presenter
`DynamicFilters` drives the UI.

Permissions always constrain what a given user may see; filters never grant
extra access beyond [permissions](permissions.md).

**Architecture / JSON and SQL detail:**
[Resource filters](../architecture/resource_filters.md)
