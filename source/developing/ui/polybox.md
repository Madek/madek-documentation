# Polybox

## Layout Modes

Resource list can be viewed in different Layout Modes,
see [Styleguide](http://medienarchiv.zhdk.ch/styleguide?section=08+Combos#8.9.1).


## DynamicFilters

Madek implements a list of **Filters**, notably by (configured) [MetaData][].  
All possible cases are documented as JSON examples on the
[architecture resource filters](../../architecture/resource_filters.md) page
(and exercised by DynamicFilters / SideFilter in the webapp).

### Presenter

For a *scope* (listing) of MediaEntries, Collections or MediaResources
"DynamicFilters" Presenter outputs a list of "possible" Filters *for each kind
of Filter*.

Dynamic because:
- always for a specific resource type (e.g. only MediaEntries have MediaFiles to filter for)
- considers the current scope (already including Permissions checks), might even be pre-filtered by a specific view like `Person#show`)
- builds sections for the currenty configured [Vocabularies][]/[MetaKeys][]

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
  media_files: # type of Filter
    - uuid: media_files # name of this section
      children:
        - uuid: content_type # a key for this filter
          children:
            - uuid: image # a value for this filter
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
              count: 7 # counts where implemented
```


## Decorator

![](https://drive.switch.ch/public.php?service=files&t=22743f99ea1499c454751ca16deef1eb&download)

The `SideFilter` Decorator (using the UI Component of the same name)
builds a tree-like view from the DynamicFilters Presenter ("accordion nav").
Initially every section tree is "closed", because "unfolding" every possible filter
at once would take a very long time (`SQL` query).

## Interaction

Selecting a filter updates the list URL/config and reloads resources (see
[UI React](react.md) — URL + JSON fetch). Facet children may load asynchronously
when a section is opened. Multi-value keys and “any value” behaviour follow the
filter JSON contract on the architecture page.
