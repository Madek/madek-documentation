# MetaData Configuration

Madek implements a configurable [MetaData][] system,
which needs to be set up by administrators/editorial staff.

This configuration pertains the kind of [MetaData][] that can be entered,
*who* can enter or see [MetaData][],
as well as how it is displayed in the `webapp`,
as well as which [MetaKey][]s are "required".

Note that because all of this configuration is dynamic,
any changes to the could lead to *editorial* challenges. See "Validation" below.

> NOTE: the default values for these settings might look weird.
> This is for historical reasons – to enable upgrades from version 2.
> Many of these settings where either implicit or even hardcoded,
> the default just match them and make them implicit.
> **Feel free to just delete them and start fresh**

### Simple Example

Assuming that a Madek instance has the requirement that all MediaEntries
have a valid title and
are marked as "belonging to a specific institutional unit".

1. Create a [Vocabulary][] `institution`
1. Create a [MetaKey][] `institution:unit` of type `Keywords`
1. Create a [Context][] `summary`
1. Add [MetaKey][]s `madek_core:title` and `institution:unit` to this Context,
   set both to `require: true`
1. Configure [AppSetting][]:
    - `context_for_entry_summary` to `summary`
    - `context_for_collections_summary` to `summary`
    - `contexts_for_resource_edit` to `summary`
    - `contexts_for_validation` to `summary`

Now Entries can not be published or changed later on if those "fields" are missing.
MediaEntries and Collections will show this MetaData on their detail views.


## Vocabularies

There is 1 built-in [Vocabulary][], `madek_core`.
It already contains (built-in) [MetaKey][]s,
which are commonly used and/or needed by the Application/Business logic
(like a "Title" for display or "Copyright" for legal purposes).

More Vocabularies with [MetaKey][]s can be created as needed for any instance.
Their purpose is to "group" those [MetaKey][]s by topic/use case/external mapping/etc,
and allow to set permissions to view and "fill in" related MetaData.

## Contexts

`Contexts` allow grouping of [MetaKey][]s, for "non-topical" uses,
namely display of [MetaData][] in the `webapp` as well as validation of required keys.
A "MetaKey in a Context" is called a [ContextKey][] and has additional attributes
specific to it's **usage**.

### "required" attribute

Note that the "required" attribute of [ContextKey][]s is
**only enforced by the `webapp` if the [Context][] is configured for [validation][#validation]**.

Setting the "required" attribute on [ContextKey][]s that are not enforced
by the `webapp` can still be useful for certain workflows:

- For exporting to other systems that have their own requirements,
  a custom [Context][] can be used to validate them.

- <mark>For An [ApiClient][] that provides a specialized data-entry UI,
  a custom [Context][] can be used to configure available and required "fields".</mark>

## AppSettings

It can be configured where to show which kind of [MetaData][],.
Note that this makes it possible to "hide" certain Data from the Interface,
for this reason there is always an option to list **all** [MetaData][] *by [Vocabulary][]*,
e.g. inside the "All Data" Tab of the Detail view.

### Editing

- `AppSettings: contexts_for_resource_edit`: Contexts used in the edit formn, each as a tab.

- the same settings is used for editing Entries and Collections,
  the Settings of MetaKeys (i.e. `enabled_for_entries?`) still apply

- ***Important:*** it is possible to configure MetaKeys for editing, but not for display,
  for example by using different Contexts for these settings.

```figure
        ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓          
        ┃           Resource Edit View           ┃          
╔═══════╩━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╩═══════╗  
║ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  ║  
║  Edit Entry: (madek_core:title)                        ║  
║ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  ║  
║ ┌──┬───┬───┬───┬───┬───┐                               ║  
║ │1 │ 2 │ 3 │ 4 │ 5 │ … │                               ║  
║ ├──┴───┴───┴───┴───┴───┴─────────────────────────────┐ ║  
║ │               ▲                                    │ ║  
║ │ ┌──(media ─┐  ┗━━━━━━━━━━━━━━━━━━━┓                │ ║  
║ │ │ preview) │                      ▼                │ ║  
║ │ │          │              contexts_for_            │ ║  
║ │ │          │              resource_edit            │ ║  
║ │ │          │                                       │ ║  
║ │ └──────────┘                                       │ ║  
║ └────────────────────────────────────────────────────┘ ║  
╚════════════════════════════════════════════════════════╝  
```

### Display

#### MediaEntry Detail View

- `AppSettings: context_for_entry_summary`
    - **1** [Context][], the most important [MetaData][], e.g. show top right
- `AppSettings: contexts_for_entry_extra`
    - up to 4 more [Context][]s to show on bottom

```figure
        ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓          
        ┃         MediaEntry Detail View         ┃          
╔═══════╩━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╩═══════╗  
║ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐                          ║  
║   Title (madek_core:title)                             ║  
║ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘                          ║  
║ ┌─────────────────────────┬──────────────────────────┐ ║  
║ │                         │                          │ ║  
║ │                         │  ┌────────────────────┐  │ ║  
║ │   ┌ ─ ─ ─ ─ ─ ─ ─ ┐     │  │                    │  │ ║  
║ │    context_for_         │  │                    │  │ ║  
║ │   │entry_summary  │     │  │  (media preview)   │  │ ║  
║ │    ─ ─ ─ ─ ─ ─ ─ ─      │  │                    │  │ ║  
║ │                         │  └────────────────────┘  │ ║  
║ │                         │                          │ ║  
║ ├─────────────────────────┴──────────────────────────┤ ║  
║ │                                                    │ ║  
║ │                                                    │ ║  
║ │                                                    │ ║  
║ │          ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐           │ ║  
║ │             contexts_for_entry_extra               │ ║  
║ │          └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘           │ ║  
║ │                                                    │ ║  
║ │                                                    │ ║  
║ └────────────────────────────────────────────────────┘ ║  
╚════════════════════════════════════════════════════════╝  
```

### Collections Detail View

- `AppSettings: context_for_
collection_summary`
    - **1** [Context][], the most important [MetaData][], e.g. show top right


```figure
        ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓          
        ┃         Collection Detail View         ┃          
╔═══════╩━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╩═══════╗  
║ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐                          ║  
║   Title (madek_core:title)                             ║  
║ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘                          ║  
║ ┌─────────────────┬──────────────────────────────────┐ ║  
║ │                 │                                  │ ║  
║ │ ┌─────────────┐ │    ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐     │ ║  
║ │ │             │ │                                  │ ║  
║ │ │   (media    │ │    │context_for_           │     │ ║  
║ │ │  preview)   │ │     collection_summary           │ ║  
║ │ │             │ │    │                       │     │ ║  
║ │ └─────────────┘ │     ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─      │ ║  
║ │                 │                                  │ ║  
║ ├─────────────────┴──────────────────────────────────┤ ║  
║ │  ┌───────────────────────────────────────────────┐ │ ║  
║ │  │                                               │ │ ║  
║ │  │                                               │ │ ║  
║ │  │                 (Collection                   │ │ ║  
║ │  │                  Children)                    │ │ ║  
║ │  │                                               │ │ ║  
║ │  │                                               │ │ ║  
║ │  └───────────────────────────────────────────────┘ │ ║  
║ └────────────────────────────────────────────────────┘ ║  
╚════════════════════════════════════════════════════════╝  
```

## Indexes, "List view Mode"

- `AppSettings: contexts_for_list_details`
    - in Resource Indexes, in "List view Mode", additional [MetaData][] is shown

```figure
        ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓          
        ┃       Resource Index, List View        ┃          
╔═══════╩━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╩═══════╗  
║ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ ║  
║ ┣───────────────┬────────────────────────────────────┫ ║  
║ ┃ ┌───────────┐ │   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  ┃ ║  
║ ┃ │(thumbnail)│ │      contexts_for_list_details     ┃ ║  
║ ┃ └───────────┘ │   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  ┃ ║  
║ ┣───────────────┼────────────────────────────────────┫ ║  
║ ┃ ┌───────────┐ │   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  ┃ ║  
║ ┃ │(thumbnail)│ │      contexts_for_list_details     ┃ ║  
║ ┃ └───────────┘ │   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  ┃ ║  
║ ┣───────────────┼────────────────────────────────────┫ ║  
║ ┃ ┌───────────┐ │   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  ┃ ║  
║ ┃ │(thumbnail)│ │      contexts_for_list_details     ┃ ║  
║ ┃ └───────────┘ │   └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  ┃ ║  
║ ┣───────────────┼────────────────────────────────────┫ ║  
║ ┗━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ ║  
╚════════════════════════════════════════════════════════╝  
```


# Indexes, "Dynamic Filters"

- `AppSettings: contexts_for_dynamic_filters`
    - in Resource Indexes, build [DynamicFilters](./resource_filters#dynamicfilters)
      from theses Contexts

Note: For a consistent user experience this setting should match the
`context_for_show_summary`/`context_for_show_extra` contexts as close as possible,
in simple cases it can be the same contexts.
However, this setting is separated so that "expensive" [MetaKey][]s can be excluded
from the DynamicFilters for performance reasons.

## Validation

`AppSettings: contexts_for_validation`

One or more [[Context][]]s can be configured as "used for validation".
This checks the "required" setting of a [MetaKey][] inside those [Context][]s
whenever MetaData is updated and ensures that a value is set.

### Important
Requiring a [MetaKey][] does not immediately affect the existing [MetaData][]!
Rather, the validation will be enforced the next time it is *updated*.



[Admin]: ./entities/#admin
[ApiClient]: ./entities/#apiclient
[AppSetting]: ./entities/#appsetting
[Collection]: ./entities/#collection
[Concerns]: ./entities/#concerns
[Context]: ./entities/#context
[ContextKey]: ./entities/#contextkey
[Copyright]: ./entities/#copyright
[CustomURL]: ./entities/#customurl
[Entrusted Resource]: ./entities/#entrusted-resources
[Favoritable]: ./entities/#favoritable
[FilterSet]: ./entities/#filterset
[Group]: ./entities/#group
[InstitutionalGroup]: ./entities/#institutionalgroup
[IoInterface]: ./entities/#iointerface
[IoMapping]: ./entities/#iomapping
[Keyword]: ./entities/#keyword
[License]: ./entities/#license
[MediaEntries]: ./entities/#mediaentry
[MediaEntry]: ./entities/#mediaentry
[MediaFile]: ./entities/#mediafile
[MetaData]: ./entities/#metadata
[MetaDatum]: ./entities/#metadatum
[MetaDatumValue]: ./entities/#metadatumvalues
[MetaKey]: ./entities/#metakey
[Owner]: ./entities/#owner
[People]: ./entities/#person
[Permission]: ./entities/#permission
[Permissions]: ./entities/#permissions
[Person]: ./entities/#person
[Preview of Sets]: ./entities/#preview-of-sets
[Preview]: ./entities/#preview
[Previewable]: ./entities/#previewable
[Privacy Status]: ./entities/#privacy-status
[Private Resources]: ./entities/#private-resources
[Public Resources]: ./entities/#public-resources
[Relations]: ./entities/#relations
[Responsibility]: ./entities/#responsibility
[UsageTerm]: ./entities/#usageterm
[User]: ./entities/#user
[Vocabulary]: ./entities/#vocabulary
[ZencoderJob]: ./entities/#zencoderjob
