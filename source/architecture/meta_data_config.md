# MetaData Configuration

Madek implements a configurable [MetaData][] system that needs to be set up by administrators/editorial staff.

This configuration pertains the kind of [MetaData][] that can be entered,
who can enter or see [MetaData][],
as well as how it is displayed in the `webapp`,
as well as which [MetaKey][]s are mandatory.

Note that because all of this configuration is dynamic,
any changes to the could lead to *editorial* challenges. See "Validation" below.

> NOTE: the default values for these settings might look weird.
> This is for historical reasons – to enable upgrades from version 2.
> Many of these settings where either implicit or even hardcoded,
> the default just match them and make them implicit.
> **Feel free to just delete them and start fresh**

[MetaData][] is organized in two ways: Vocabularies and Contexts.

## Vocabularies

<!-- Vocabularies group [MetaKey][]s in terms of their content. -->
Every [MetaDatum][] is necessarily a member of one [Vocabulary][]. 
There is one built-in [Vocabulary][], `madek_core`, that 
already contains default [MetaKey][]s.
These are used and/or needed by the application and business logic
(like a "Title" for display or "Copyright" for legal purposes).

Additional Vocabularies with [MetaKey][]s can be created as needed 
for every application instance.
Their purpose is to group [MetaKey][]s by subject, use case, external mapping, etc.
and to allow to set permissions for viewing and editing of related [MetaData][].

## Contexts

`Contexts` allow to group [MetaKey][]s for 
display of [MetaData][] in the `webapp` as well as for the validation of required keys.
A MetaKey in a Context is called a [ContextKey][] and has additional attributes
such as field label or input type.

> NOTE: The "required" attribute of [ContextKey][]s is only enforced by the `webapp`
> if the [Context][] is configured for [validation][#validation].

> Setting the "required" attribute on [ContextKey][]s that are not enforced
by the `webapp` can still be useful for certain workflows:

> - For exporting to other systems that have their own requirements,
>  a custom [Context][] can be used to validate them.

> - <mark>For an [ApiClient][] that provides a specialized data-entry UI,
>  a custom [Context][] can be used to configure available and required fields.</mark>


### Simple Example

Assuming that a Madek instance has the requirement that all MediaEntries
have a valid title and are assigned to a specific institutional unit.

1. Create a [Vocabulary][] `institution`
1. Create a [MetaKey][] `institution:unit` of type `Keywords`
1. Create a [Context][] `required_fields`
1. Add [MetaKey][]s `madek_core:title` and `institution:unit` to this Context,
   set both to `required: true`
1. Configure [AppSetting][] `contexts_for_validation` to `required_fields`

Now Entries can not be published or changed later on if these declarations are missing.
To also show this data on the detail page in the `webapp`:

1. Create a [Context][] `summary`
1. Add [MetaKey][]s `madek_core:title` and `institution:unit` to this [Context][]
1. Configure [AppSetting][] `context_for_show_summary` to `summary`


## AppSettings

It can be configured where to show which kind of [MetaData][],.
Note that this makes it possible to hide certain data from the default interface.
For this reason there is always an option to list all [MetaData][] by [Vocabulary][],
e.g. inside the "All Data" Tab of the Detail view.


### Display

- `AppSettings: context_for_show_summary`
    - 1 [Context][], the most important [MetaData][], e.g. show top left on detail view
- `AppSettings: contexts_for_show_extra`
    - up to 4 more [Context][]s to show on detail view

```figure
        ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓          
        ┃ Resource Detail View (ex. MediaEntry)  ┃          
╔═══════╩━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╩═══════╗  
║ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐                          ║  
║   Title (madek_core:title)                             ║  
║ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘                          ║  
║ ┌─────────────────────────┬──────────────────────────┐ ║  
║ │                         │                          │ ║  
║ │                         │  ┌────────────────────┐  │ ║  
║ │   ┌ ─ ─ ─ ─ ─ ─ ─ ┐     │  │                    │  │ ║  
║ │    context_for_         │  │                    │  │ ║  
║ │   │show_summary   │     │  │  (media preview)   │  │ ║  
║ │    ─ ─ ─ ─ ─ ─ ─ ─      │  │                    │  │ ║  
║ │                         │  └────────────────────┘  │ ║  
║ │                         │                          │ ║  
║ ├─────────────────────────┴──────────────────────────┤ ║  
║ │                                                    │ ║  
║ │                                                    │ ║  
║ │                                                    │ ║  
║ │          ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐           │ ║  
║ │              contexts_for_show_extra               │ ║  
║ │          └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘           │ ║  
║ │                                                    │ ║  
║ │                                                    │ ║  
║ └────────────────────────────────────────────────────┘ ║  
╚════════════════════════════════════════════════════════╝  
```

### Indexes, "List View Mode"

- `AppSettings: contexts_for_list_details`
    - in the "List View Mode" of Resource Indexes additional [MetaData][] is shown

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


### Indexes, "Dynamic Filters"

- `AppSettings: contexts_for_dynamic_filters`
    - in Resource Indexes build [DynamicFilters](./resource_filters#dynamicfilters)
      from theses Contexts

> Note: For a consistent user experience this setting should match the
> `context_for_show_summary`/`contexts_for_show_extra` contexts as closely as possible,
> in simple cases it can be the same contexts.
> However, this setting is separated so that resource expensive [MetaKey][]s can be excluded
> from the DynamicFilters for performance reasons.

## Validation

`AppSettings: contexts_for_validation`

One or more [[Context][]]s can be configured as `contexts_for_validation`.
This checks the `required` setting of a [ContextKey][] inside those [Context][]s
whenever MetaData is updated and ensures that a value is set.

> Note: To set a [ContextKey][] to be `required` does not immediately affect the existing [MetaData][]!
> Rather, the validation will be enforced the next time it is edited.



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
