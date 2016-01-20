The business logic of the Madek application is modeled as
(Lists of) *Resources* and their *Attributes*, *Relations*, and *[Concerns][]*.

The `webapp` provides *Views* and *Actions*[^1] to operate on those (high-level)
Resources in user-centric fashion, while the `api` provides a RESTful interface
closer to their underlying database implementation.

[^1]: Note that the distinction between Views and Actions is just for clarity,
  technically Views are all Actions that translate to a `HTTP GET` request and
  return an UI.

A major component is the **[MetaData][]** Concern, which
implements an [RDF-based Schema](http://www.w3.org/TR/rdf11-concepts/)
and therefore shares many similarites with
[RDF Schema (RDFS)](http://www.w3.org/TR/rdf-schema/).  

Relationship to RDF(S) terms is indicated where applicable,  
*Resources* themselves correspond to
[RDFS Resources](http://www.w3.org/TR/rdf-schema/#ch_resource).

**Resource Defaults** (not separately listed):

- Attributes
    - `id`: [UUID v4](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29)
    - `created_at`: Date
    - `updated_at`: Date

---

# *[Public Resources][]*

- Public as in "Public API", for external application consumers
- therefore usable as part of "Linked-(Open-)Data"
- *RDF:* for every public resource, the `webapp` implements a permanent URL
  which is used as the [`IRI`](http://www.w3.org/TR/rdf11-concepts/#section-IRIs)
- Buzzwords: "Shareable", (potentially) "embeddable", "Permalink"


## [MediaEntry][]

```figure
┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓
┃              ┃       ┃              ┃
┃              ┃       ┃              ┃
┃  MediaEntry  ┃──────▶┃  MediaFile   ┃
┃              ┃       ┃              ┃
┃              ┃       ┃              ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛
```

- most important Resource in the App
- Attributes:
    - `is_published`: default `false` ("unpublished"), set to `true` via the `publish` action.  
      Can only be changed once! *(That means there is no "unpublish" action)*
- Relations:
    - has exactly 1 [MediaFile][]
- Concerns:
    - [Responsibility][]
    - [Permissions][](*as* `subject`)
    - [MetaData][](*as* `subject`)
    - [Previewable][]
    - [Favoritable][]
    - [CustomURL][]
- Views: `index`, `show` (with tabs), `new` ("Upload-Form"), `edit_meta_data`
- Actions: `update_cover` ("Upload"), `publish`, `destroy` (deletion)


## [Collection][]

```figure
┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓
┃              ┃       ┃  MediaEntry  ┃
┃              ┃──────▶┃      or      ┃
┃  Collection  ┃──────▶┃  Collection  ┃
┃              ┃──────▶┃      or      ┃
┃              ┃       ┃  FilterSet   ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛
```

- Relations:
    - has 0 or more Resources *as* `child_media_resources`
      ("The Resources are *in* the Collection")
        - type of Resources has to be [MediaEntry][] or [Collection][] or [FilterSet][]
        - 0 or 1 [MediaEntry][] *as* `cover`
        - 0 or more Resources *as* `highlight`
- Concerns:
    - [Responsibility][]
    - [MetaData][] (*as* `subject`)
    - [Permissions][](*as* `subject`)
    - [Previewable][]
    - [Favoritable][]
    - [CustomURL][]
- Views: `index`, `show`, `new`, <mark>`edit_meta_data`</mark>
- Actions: `create` ("Upload"), `publish`, `meta_data_update`, `destroy` (deletion)


## [FilterSet][]

A saved [Filter][].

- Attributes:
    - `definition`: the saved [Filter][] (in `JSON`-format).
- Derived Attributes:
    - 0 or more [MediaEntries][] that match the Filter `definition`.
- Concerns:
    - [Responsibility][]
    - [MetaData][] (*as* `subject`)
    - [Permissions][] (*as* `subject`)
    - [Previewable][]
    - [Favoritable][]
    - [CustomURL][]
- Views: `index`, `show`, <mark>`edit`</mark>
- Actions: `create`,`update`, `destroy` (deletion)


## [MediaFile][]

```figure
┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓
┃              ┃       ┃              ┃
┃              ┃──────▶┃              ┃
┃  MediaFile   ┃──────▶┃   Preview    ┃
┃              ┃──────▶┃              ┃
┃              ┃       ┃              ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛
```

- not operated on directly, only via related [MediaEntry][]
- Attributes:
    - `filename`: String, original filename when uploaded
    - `extension`: String, e.g. 'jpg'
    - `content_type`: like mime-type, e.g. 'image/jpeg'
    - `media_type`: String (image|audio|video|document)
    - `height`, `width`: Dimensions in pixels (for images and videos)
    - `size`: the file size in bytes  
    - `meta_data`: file meta data (EXIF, IPTC, etc), **NOT** [MetaData][]!
    - `access_hash`: String, <mark>???</mark>
    - `guid`: String, <mark>???</mark>
- Relations:
    - has exactly 1 [User][] as `uploader`
    - has exactly 1 [MediaEntry][]
    - has 0 or more [ZencoderJob][]s
    - has 0 or more [Preview][]s


## [Preview][]

- Attributes:
    - `filename`: String, internal filename (after conversion)
    - `height`, `width`, `content_type`, `media_type`:  
       same meaning as in [MediaFile][], but pertains to the converted file
    - <mark>`thumbnail`: String, one of the "configured sizes" for Previews,
      one of `large`, `maximum`, `medium`, `small`, `small_125`, `x_large`  
      (*Note: found with* `SELECT DISTINCT thumbnail FROM previews`)
- Relations:
    - belongs to exactly 1 [MediaFile][]


## [Vocabulary][]

```figure
┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓
┃              ┃       ┃              ┃
┃              ┃──────▶┃              ┃
┃  Vocabulary  ┃──────▶┃   MetaKey    ┃
┃              ┃──────▶┃              ┃
┃              ┃       ┃              ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛
```

- A List of [MetaKey][]s (in specified order)
- purpose: group [MetaKey][]s by semantics/topic and set visibility/permissions
- *RDF:* Corresponds to a `RDFS Vocabulary`
- Attributes:
    - `label`: String, human-readable name
    - `description`: String
- Relations:
    - has 0 or more [MetaKey][]s
- Concerns:
    - [Permissions][] (as resource)
      - `actions` (all `subject`s): `view`, `use`


### "Core Vocabulary"

- Madek has 1 [built-in Vocabulary (`madek_core`)][madek_core_vocab_spec]
- defines some very common MetaKeys (Title, Authors, …)
- has to contain every [MetaKey][] used for internal logic!
    - Title: is also used outside of the [MetaData][] listing
    - Copyright/License: can be used for (public) visibility
    - *not to be confused with plain attributes (like `responsible_user`)*

## [MetaKey][]

- Attributes:
    - `label`, `description`, `hint`: String
    - `position`: Number, order inside the [Vocabulary][]
    - `meta_datum_object_type`: type of [MetaDatumValue][]
    - `is_enabled_for_{type}`: Bool,  
      valid types: [MediaEntry][], [Collection][], [FilterSet][]
    - `is_extensible_list`: Bool <mark>???</mark>
    - `keywords_alphabetical_order`: Bool, (when type is [Keyword][]s)
      signifies if they should be displayed in alphabetical order
    - `is_extensible`: Bool, (when type is [Keyword][]s)
      determines if additional [Keyword][]s may be created while editing [MetaData][]
- Relations:
    - belongs to exactly 1 [Vocabulary][]


## [MetaDatum][]

```figure
┏━━━━━━━━━━━━━━┓       ┏MetaDatum━━━━━━┓
┃              ┃       ┃               ┃
┃              ┃       ┃    MetaKey    ┃
┃   Resource   ┃══════▶┃       │       ┃
┃              ┃       ┃       ▼       ┃
┃              ┃       ┃    value(s)   ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━━┛
```

- One or more values *for* a [MetaKey][]s *on* a `subject` Resource.
- *RDF:* Corresponds to a [`RDF Triple`](http://www.w3.org/TR/rdf11-concepts/#dfn-rdf-triple), where
    - `subject` is the related Resource
    - `predicate` is the related [MetaKey][]
    - `object` is a list of one or more *Value*s
    - and in place of the `IRI` the `UUID` is used (internally)
- valid data-types for values, by sub-type (implemented as STI + constraints)
    - `MetaDatum::Text`: literal value (String)
    - `MetaDatum::TextDate`: literal value (Date as String)
    - `MetaDatum::Keywords`: [Keyword][]
    - `MetaDatum::People`: [Person][]
    - `MetaDatum::Licenses`: [License][]
    - <mark>`MetaDatum::Groups`: [Group][]</mark>
- Attributes:
    - `type`: type of [MetaDatumValue][]
    - `string`: the *Value* if it is a literal value (e.g. Text), *depends on `type`*
- Relations:
    - has exactly 1 [MetaKey][]
    - has exactly 1 Resource (valid types: [MediaEntry][], [Collection][], [FilterSet][])
    - has exactly 1 [User][] *as* "Creator" (`created_by_id`)
    - **Non-literal types have additional Attributes on their relations!**  
      *(It stores which [User][] created the MD., as well as for every single value)*
          - i.e. (if `type=Keywords`) → has 1 or more `MetaDatum::Keywords`
              - which has exactly 1 [User][] *as* "Creator" (`created_by_id`)


## [Person][]

- a generic (real-world) person (natural, fictional or juridical), group, or institution.
- *can* be linked to [MetaDatum][] of type `MetaDatumPerson`  (i.e. "Author")
- Attributes:
    - `first_name`, `last_name`, `pseudonym`: String
    - `date_of_birth`, `date_of_death`: Date
    - `is_bunch`: true if the entity should be considered plural,
      for example a group of people
- Relations:
    - has 0 or 1 [User][]s (for every User created a related [Person][] is also created.)
- Concerns:
    - [MetaData][] (as value)

## [Keyword][]

- Keyword/Term belonging to a specific MetaKey
- Attributes:
    - `term`: String
- Relations:
    - has exactly 1 [MetaKey][] as `creator`
    - has exactly 1 [User][] as `creator`
- Concerns:
    - [MetaData][] (as value)


## [License][]

```
CREATE TABLE licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    is_default boolean DEFAULT false,
    is_custom boolean DEFAULT false,
    label character varying,
    usage character varying,
    url character varying,
    "position" double precision
);

CREATE TABLE license_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    "position" double precision,
    parent_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
```


---

# *[Private Resources][]*

- "Private" as in "Private API"
- quite literally, not exposed via the `api`.


## [User][]

- stores login credentials to directly log into the `webapp` (session than also valid for `api`)
- *can* be "Admin"
- Attributes:
    - `login`: String (alphanumeric characters, and `.`, `-`, `_` allowed)
    - `email`: String
    - `password`: String (saved as digest)
    - `usage_terms_accepted_at`: Date, see [UsageTerm][]s.
    - <mark>`zhdkid`: Number, …</mark>
    - `notes`: String, ???
    - `autocomplete`: String, ???
    - `contrast_mode`: Bool, if constrast mode should be enabled in UI

- Relations:
    - has exactly 1 [Person][]
- Concerns:
    - [Permissions][] (as subject)

## [Group][]

- list of [User][]s
- is manually defined by a [User][]
- Supertype of [InstitutionalGroup][] (implemented in DB as `STI`-table)
- Attributes:
    - `name`: String
- Relations:
    - has 1 or more [User][]s as *members*
- Concerns:
    - [Permissions][] (as subject)
    - Concerns:
        - <mark>[MetaData][] (as value)</mark>

## [InstitutionalGroup][]

- Subtype of [Group][]
- externally-defined and synced from a `LDAP`-Directory.
- Relations:
    - has 1 or more [User][]s as *members*,
      which must have a User-ID from the same Directory.


## [ApiClient][]

- an API client. Can use the `api` but not log into `webapp`.
- Attributes:
    - `login`: String (alphanumeric characters, and `.`, `-`, `_` allowed)
    - `description`: String
    - `password`: String (saved as digest)
- Relations:
    - has 1 or more [User][]s as *administrative contact*
- Concerns:
    - [Permissions][] (as subject)


## [Admin][]

- A [User][]s that has **administrative privileges** for an instance


## [IoInterface][]

- a list of [IoMapping][]s
- Attributes:
    - `description`: String
- Relations:
    - has 1 or more [IoMapping][]s


## [IoMapping][]

- maps a [MetaKey][] to defined properties ("keys") from external standards
- used for import and export
    - Example: Maps "DublinCore Title" to "MadekCore Title"
- Attributes:
    - `meta_key_id` character varying NOT NULL,
    - `key_map` character varying,
    - `key_map_type` character varying,
- Relations:
    - has exactly 1 [MetaKey][] ("maps this MetaKey")
    - has exactly 1 [IoInterface][] ("is in this IoInterface")


## [CustomURL][]

- defines a "nice" URL *for* a Resource
- does not change path structure, only allows a user defined "name" instead of `id`
    - example: `/madek/entries/123456` → `/madek/entries/my_entry`
- Attributes:
    - `id`: String, alphanumeric, the "name" (**not a UUID**)
- Relations:
    - has exactly 1 [User][] *as* `creator` (inital creation by)
    - has exactly 1 [User][] *as* `updator` (last update by)
    - has exactly 1 Resource ([MediaEntry][], [Collection][] or [FilterSet][])

## [ZencoderJob][]

<pre><mark>
CREATE TABLE zencoder_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_file_id uuid NOT NULL,
    zencoder_id integer,
    comment text,
    state character varying DEFAULT 'initialized'::character varying NOT NULL,
    error text,
    notification text,
    request text,
    response text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
</mark></pre>

## [UsageTerm][]

<mark>
- each instance has 0 or more U.
- the most recently created U. is considered as the "latest Version"
- application enforces acceptance of "latest Version"
    - when [User][] logs into the Webapp, a modal dialog is shown
    - on acceptance, [User][].`usage_terms_accepted_at` is updated
</mark>

<pre><mark>
CREATE TABLE usage_terms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    version character varying,
    intro text,
    body text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
</mark></pre>



# *[Concerns][]*

Functionality shared by and/or
pertaining to several different Resources is summarized as a *Concern*.

## [MetaData][]

```figure
┏━━━━━━━━━━━━━━┓       ┏MetaData━━━━━━━┓
┃              ┃       ┃               ┃
┃              ┃       ┃  Vocabulary   ┃
┃   Resource   ┃━━━━━━▶┃       │       ┃
┃              ┃       ┃       ▼       ┃
┃              ┃       ┃   MetaDatum   ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━━┛
```

- List of all [MetaDatum][]s associated with a `subject` Resource, grouped by [Vocabulary][]
- *RDF:* Corresponds to [`RDF Graph`](http://www.w3.org/TR/rdf11-concepts/#section-rdf-graph)


## [Responsibility][]

- Relations:
    - has exactly 1 [User][] *as* `creator`
    - has exactly 1 [User][] *as* `responsible`
- for [MediaEntry][], [Collection][], [FilterSet][], there is always exactly 1 **owner**
    - => **`responsible_user`**: [User][]
- has super-permission **"Delete and Change owner"** (Löschen und Verantwortlichkeit übertragen)
- **implicitly has all the granular permissions** listed below (if applicable)


## [Favoritable][]

- specific Resources can be "favorited" by Users
- *Note: not implemented for [ApiClient][]s (but technically a [Collection][] could be used)*
- Relations:
    - has exactly 1 [User][]
    - has exactly 1 Resource ([MediaEntry][], [Collection][] or [FilterSet][])

## [Previewable][]

Every [MediaEntry][] is "previewable" (in the UI) as an image.
The image can come from several sources:

- either by a compiled preview from the associated [MediaFile][]
    - images are compiled locally using `imagemagick`
    - videos are processed with [zencoder](https://zencoder.com/), a framegrab is used as image
    - <mark>sounds can be "converted" to waveform image, ala soundcloud (AsAService: [auphonic](https://auphonic.com))
- or a generic image, possibly representing the mime-type of the [MediaFile][]

A presenter like `Presenter::ResourceThumbnail` makes the decision which image is used.
The `MediaEntryController#preview` action is **only** tasked with serving the
specific compiled Previews (the generic thumbnail is )

<mark>TODO: sizes! (not Previews are not just used for thumbs; how to handle small
  originals)</mark>

### [Preview of Sets][]

> “Das Preview eines Sets kommt vom ‘Cover’, User-gewählter Entry (aus dem Set) der das Set visuell repräsentiert.
> Wenn kein ‘Cover' vorhanden ist, nehmen wir aus der Liste der Einträge, die direkt im Set liegen,
> sortiert nach der (mögl. gespeicherten) Sortierung des Sets, den ersten von dem wir eine visuelle Darstellung haben.
> Wenn so kein ‘Cover’ gefunden wird, nehmen wir das generische Preview für ein Set.”


## [Permissions][]

```figure
┏━━━━━━━━━━━━━━┓       ┏Permissions━━━━┓
┃              ┃       ┃               ┃
┃              ┃       ┃    action     ┃
┃   Resource   ┃━━━━━━▶┃       │       ┃
┃              ┃       ┃       ▼       ┃
┃              ┃       ┃    subject    ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━━┛
```

Permissions are a kind of ACL (Access-Controll-List)
on a specific **Resource**.  
A Permission allows an **`action`** for a **`subject`**.  
The `subject` can be of type [User][], [Group][] or [ApiClient][],
as well as *"Public"*.

- For a single Permission:
    - Attributes:
        - (dynamic) 1 Bool per `action`
    - Relations:
        - has exactly 1 Resource as `subject` ("Permissions are *on* this Resource")
        - has exactly 1 [User][] as `updator` (last changed by)


"Public" permissions apply to any request, logged in or not.
Permissions for Groups are applied to Users via group membership.

Example: When checking if Resource is visible to the [User][], we'll need to
combine the following:

- permissions for **Public**; *and, if a [User][] is logged in:*
- implicit **User** permissions ([Responsibility][])
- explicit **User** permissions
- permissions of all **Groups** the User is a member of


| subject/permission | data_and_preview            | edit_data                                        | fullsize                                 | edit_permissions              |
| :----------------  | :-------------------------: | :-------------:                                  | :-------------:                          | :----------------:            |
| **[MediaEntry][]**   | get metadata and previews   | edit metadata                                    | get full size                            | edit permissions              |
| ↳ [User][]           | ✔                           | ✔                                                | ✔                                        | ✔                             |
| ↳ [Group][]          | ✔                           | ✔                                                | ✔                                        | -                             |
| ↳ [ApiClient][]      | ✔                           | -                                                | ✔                                        | -                             |
| ↳ "public"         | ✔                           | -                                                | ✔                                        | -                             |
| *Beschreibung*     | betrachten                  | Metadaten editieren                              | Original exportieren & in PDF blättern   | Zugriffsberechtigungen ändern |
|                    |                             |                                                  |                                          |                               |
|                    |                             |                                                  |                                          |                               |
| **[Collection][]**     | get metadata and previews   | edit metadata **and relations**                  | -                                        | edit permissions              |
| ↳ [User][]           | ✔                           | ✔                                                | -                                        | ✔                             |
| ↳ [Group][]          | ✔                           | ✔                                                | -                                        | -                             |
| ↳ [ApiClient][]      | ✔                           | ✔                                                | -                                        | -                             |
| ↳ "public"         | ✔                           | -                                                | -                                        | -                             |
| *Beschreibung*     | betrachten                  | Metadaten editieren & Inhalte hinzufügen         | -                                        | Zugriffsberechtigungen ändern |
|                    |                             |                                                  |                                          |                               |
|                    |                             |                                                  |                                          |                               |
| **[FilterSet][]**    | get metadata and previews   | edit metadata **and filter**                     | -                                        | edit permissions              |
| ↳ [User][]           | ✔                           | ✔                                                | -                                        | ✔                             |
| ↳ [Group][]          | ✔                           | -                                                | -                                        | -                             |
| ↳ [ApiClient][]      | ✔                           | ✔                                                | -                                        | -                             |
| ↳ "public"         | ✔                           | -                                                | -                                        | -                             |
| *Beschreibung*     | betrachten                  | Metadaten editieren & Filtereinstellungen ändern | -                                        | Zugriffsberechtigungen ändern |


## [Entrusted Resource][]s

A Resource is "entrusted" to a User if they have "view" Permissions on the
Resource, either directly or via their membership in a Group.
Therefore, a Resource with "view" Permissions for "Public" can
never be "entrusted" because it is already public.

## [Privacy Status][]

- `public`: "Public" has "view" Permission
- `private`: No Person or Group has "view" Permission
- `shared`:
    - if User is the owner and any Person or Group has "view" Permission
    - if User is not the owner and has "view" Permission
      (directly or via Group membership)

## [Relations][]

- See <https://wiki.zhdk.ch/madek-hilfe/doku.php?id=relationship>

---

## Appendix/Editor Notes

How to edit these docs and keep them up to date:

- Resources and their Attributed can be found by going through the [SQL Structure](https://github.com/Madek/madek-datalayer/blob/master/db/structure.sql)
    - Tables → Resources
    - Columns → Attributes
        - Attributes of type UUID and/or join tables → Relations
- Actions (and Views) can be found by either looking in the corresponding
  controller in webapp (as well any included modules) and/or inspecting the
  output of `rake routes`
- for Relations a human-readable yet consistent format is used to indicate cardinality:
    - "exactly 1" (`NOT NULL`, with `UNIQUE` constraint)
    - "0 or 1"
    - "0 or more"
    - "1 or more" (`NOT NULL`)

### TODO (DB)
    - weg: contexts: **context_group_id uuid**

### TODO (Docs)

These docs are ***complete*** *([according to `structure.sql`](https://github.com/Madek/madek-datalayer/blob/master/db/structure.sql))*,
meaning everything present in the DB schema is also *mentioned* here.

Almost everything is also *explained* and put into a consistent structure
(or mentioned as an apparent error).
everything else is pasted below (either not important or still open questions).

```
CREATE TABLE edit_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    media_entry_id uuid,
    collection_id uuid,
    filter_set_id uuid,
    CONSTRAINT edit_sessions_is_related CHECK ((((((media_entry_id IS NULL) AND (collection_id IS NULL)) AND (filter_set_id IS NOT NULL)) OR (((media_entry_id IS NULL) AND (collection_id IS NOT NULL)) AND (filter_set_id IS NULL))) OR (((media_entry_id IS NOT NULL) AND (collection_id IS NULL)) AND (filter_set_id IS NULL))))
);

CREATE TABLE full_texts (
    media_resource_id uuid NOT NULL,
    text text
);


CREATE TABLE visualizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    resource_identifier character varying NOT NULL,
    control_settings text,
    layout text
);
```



<!-- link definitions -->
<!-- internal -->
[Admin]: #admin
[ApiClient]: #apiclient
[Collection]: #collection
[Concerns]: #concerns
[Copyright]: #copyright
[CustomURL]: #customurl
[Entrusted Resource]: #entrusted-resources
[Favoritable]: #favoritable
[FilterSet]: #filterset
[Group]: #group
[InstitutionalGroup]: #institutionalgroup
[IoInterface]: #iointerface
[IoMapping]: #iomapping
[Keyword]: #keyword
[License]: #license
[MediaEntries]: #mediaentry
[MediaEntry]: #mediaentry
[MediaFile]: #mediafile
[MetaData]: #metadata
[MetaDatum]: #metadatum
[MetaDatumValue]: #metadatumvalue
[MetaKey]: #metakey
[Owner]: #owner
[People]: #person
[Permission]: #permission
[Permissions]: #permissions
[Person]: #person
[Preview of Sets]: #preview-of-sets
[Preview]: #preview
[Previewable]: #previewable
[Privacy Status]: #privacy-status
[Private Resources]: #private-resources
[Public Resources]: #public-resources
[Relations]: #relations
[Responsibility]: #responsibility
[User]: #user
[UsageTerm]: #usageterm
[Vocabulary]: #vocabulary
[ZencoderJob]: #zencoderjob
<!-- external -->
[Decorator]: ../development/ui-framework/#decorators
[Filter]: filters/
[Presenter]: ../development/ui-framework/#presenters
[madek_core_vocab_spec]: https://github.com/Madek/madek-datalayer/blob/master/db/migrate/165_migrate_core_keys.rb
