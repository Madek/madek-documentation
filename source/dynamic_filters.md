# Polybox

## Layout Modes

Resource list can be viewed in different Layout Modes,
see [Styleguide]().


## DynamicFilters

Madek implements a list of **Filters**, notably by (configured) [MetaData][].  
All possible cases are [documented](./Filters/) as examples in `JSON` format.

### Presenter

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
        - uuid: content_type  # a key for this filter
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


[MediaEntry]: <./Entities/#mediaentry>
[Collection]: <./Entities/#collection>
[FilterSet]: <./Entities/#filterset>
[Permissions]: <./Entities/#permissions>
