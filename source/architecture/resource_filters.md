# ResourceFilters

Internal spec for filtering collections in Madek.

Each of the 3 types of media resources, namely `MediaEntry`, `Collection` and `FilterSet` implements a class method `filter_by`.
This method defines its own `SQL` generation logic and behaves as any other `ActiveRecord` scope method, and thus it's also chainable.

## Full usage example

```json
{
  "search": "something",
  "meta_data": [
    { "key": "madek_core:authors",
      "value": "6e4da213-2f4d-41a6-9eb0-c961d74f717e" },
    { "key": "media_content:type",
      "match": "architektur" },
    { "key": "any",
      "match": "india",
      "type": "MetaDatum::Text" },
    { "key": "any",
      "match": "china" },
    { "key": "madek_core:keywords" },
    { "not_key": "media_object:patron" }
  ],
  "media_files": [
    { "key": "media_type", "value": "image/jpeg" },
    { "key": "extension", "value": "jpg" }
  ],
  "permissions": [
    { "key": "public",
      "value": true },
    { "key": "responsible_user",
      "value": "8631ffff-f601-451e-bce7-f3696d18addf" },
    { "key": "entrusted_to_user",
      "value": "f3d3174c-11b2-43e3-80dc-5925665c5a37" },
    { "key": "entrusted_to_group",
      "value": "30a6baf1-010f-444a-87f0-dc78be983014" }
  ]
}
```

```ruby
MediaEntry.filter_by({…})
```

## Filter attributes/keys

There are different "types" of attributes resources can be filtered by.  
All of these are combined together using logical `AND`.

* `meta_data`
* `media_files`
* `permissions`
* `search`

### `meta_data` filter

```json
{
  "meta_data": [
    { "key": "madek_core:authors",
      "value": "6e4da213-2f4d-41a6-9eb0-c961d74f717e" },
    { "key": "media_content:type",
      "match": "architektur" },
    { "key": "any",
      "match": "india",
      "type": "MetaDatum::Text" },
    { "key": "any",
      "match": "china" },
    { "key": "madek_core:keywords" },
    { "not_key": "media_object:patron" }
  ]
}
```

There are the following usage options:

1. for a specific `key` use an `uuid` as the `value` in case of a concrete related resource
2. for a specific `key` use an arbitrary string via `match` to match in the respective DB column, depending on the type of the related resource, e.g. `people.searchable` or `keywords.term`, etc.
3. use `any` as `key` with an arbitrary string via `match` to trigger a text-based match for any meta datum of a specific `type`
4. use `any` as `key` with an arbitrary string via `match` to trigger a text-based match across all meta data
5. use `key` without `value` or `match` to filter media resources, which have some meta datum for a specific `meta_key_id`
6. use `not_key` without `value` or `match` to exclude media resources, which don't have any meta datum for a specific `meta_key_id`

All the filter options inside `meta_data` are combined using the logical `AND`.

Only the meta_data is searched, where the respective meta_keys belong to public vocabularies, which are visible by the logged in user.

String matching via `match` is case-insensitive.

### `media_files` filter

```json
{
  "media_files": [
    { "key": "media_type", "value": "image/jpeg" },
    { "key": "extension", "value": "any" }
  ]
}
```

There are 2 usage options:

1. use an arbitrary string via `value` for a specific media_file attribute `key`. The value is matched *exactly*. The media file attributes basically correspond to the columns of the `media_files` table in DB.
2. use `any` as value of `value` to match anything inside a column.

All the filter options inside `media_files` are combined using the logical `AND`.

### `permissions` filter

```json
{
  "permissions": [
    { "key": "public",
      "value": true },
    { "key": "responsible_user",
      "value": "8631ffff-f601-451e-bce7-f3696d18addf" },
    { "key": "entrusted_to_user",
      "value": "f3d3174c-11b2-43e3-80dc-5925665c5a37" },
    { "key": "entrusted_to_group",
      "value": "30a6baf1-010f-444a-87f0-dc78be983014" }
  ]
}
```

There are 4 usage options:

1. use an `uuid` as `value` for `key` = `responsible_user`
2. use an `uuid` as `value` for `key` = `entrusted_to_user`
3. use an `uuid` as `value` for `key` = `entrusted_to_group`
4. use `true`/`false` as `value` for `key` = `public`

All the filter options inside `permissions` are combined using the logical `AND`.

### `search` filter

```json
{
  "search": "THE_SEARCH_STRING"
}
```

The 'search' filter allows a single string which allow a case-insensitive search
over all MetaData.

It is internally handled like a `meta_data` filter that matches on any key,
so the above example is equivalent to this:

```json
{
  "meta_data": [{ "key": "any", "match": "THE_SEARCH_STRING" }]
}
```


---

# DynamicFilters

Building on the Filters mentioned above, Madek can also generate a list
of "possible Filters" including counts.
This is used to provide a familiar "filter-browsing" workflow for working with lists.

## Presenter

For a *scope* (listing) of MediaEntries, Collections, FilterSets or MediaResources
"DynamicFilters" Presenter outputs a list of "possible" Filters *for each kind
of Filter*.

Dynamic because:

- always for a specific resource type (e.g. only MediaEntries have MediaFiles to filter for)
- considers the current scope (already including Permissions checks), might even be pre-filtered by a specific view like `Person#show` or `FilterSet#show`)
- builds 'meta_data' sections for the currently configured [Vocabularies][]/[MetaKeys][]

For [Permissions][]:

- `responsible_user`
- `get_meta_data_and_previews` Permissions for [Users][] (multiple),
  [Groups][] (multiple), and [Public][Permissions] (true/false).

For MetaData, they are MetaKeys that are used on MetaData in *scope*,
grouped by Vocabularies.
MetaKeys of type Keyword also contain their associated terms by usage (in *scope*).

Simplified example:

```yaml
dynamic_filters:
  media_files:                # type of Filter
    - uuid: media_files       # name of this section (only for UI)
      children:
        - uuid: media_type  # a key for this filter
          children:
            - uuid: image     # a value for this filter
        - uuid: extension
          children:
            - uuid: jpg
  meta_data:
    - type: Vocabulary
      uuid: 'madek_core' # 1 vocabulary = 1 section
      children:
        - type: MetaKey:
          uuid: 'madek_core:keywords'
          children:
            - type: Keyword
              label: 'oil'
              count: 7        # usage counts (where implemented)
```


## Decorator

![](https://drive.switch.ch/public.php?service=files&t=22743f99ea1499c454751ca16deef1eb&download)

The `SideFilter` Decorator (using the UI Component of the same name)
builds a tree-like view from the DynamicFilters Presenter ("accordion nav").
Initially every section tree is "closed", because "unfolding" every possible filter
at once would take a very long time (`SQL` query).

## Interaction

When the user selection, it is opened.  
Contents are fetched async if needed.
Same applies to any children (like Keywords)

Selecting a leaf of the tree adds this value as a filter
and reloads the resource list.

If at least one value is selected for a key, a 'delete' icon next to
the key can be selected to remove all children.

If a filter key is marked `multi: true`, more than one value can be
added at the same time. It is also possible to select the key itself
to filter for "any value" (checkbox on right).

If a Polybox instance is marked (`saveable: true`), it can be saved as a
FilterSet. This functionality is only implemented for non-prefiltered lists
(it works on 'MediaEntry#index', not on 'Person#show').

## Usage Examples

- 'MediaEntry-', 'Collection-' and 'FilterSet-#index' Views all show
  a title and a Polybox for their index.

- 'Person#Show' shows basic information about the Person,
  and a Polybox with a pre-filtered listing (indepent of any filter that might
  be applied by the user), showing only related Resources.


[MediaEntry]: <./entities/#mediaentry>
[Collection]: <./entities/#collection>
[FilterSet]: <./entities/#filterset>
[Permissions]: <./entities/#permissions>
