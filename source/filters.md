# MediaResource filters

## Implementation

Each of the 3 types of media resources, namely `MediaEntry`, `Collection` and `FilterSet` implements a class method `filter_by`. This method defines its own `SQL` generation logic and behaves as any other `ActiveRecord` scope method, and thus it's also chainable.

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
    { "key": "content_type", "value": "image/jpeg" },
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

String matching via `match` is case-insensitive.

### `media_files` filter

```json
{
  "media_files": [
    { "key": "content_type", "value": "image/jpeg" },
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
