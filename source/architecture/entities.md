The business logic of the Madek application is modeled as
(Lists of) *Resources* and their *Attributes*, *Relations*, and *[Concerns][]*.

The `webapp` provides *Views* and *Actions* to operate on those (high-level)
Resources in user-centric fashion, while the `api` provides a RESTful interface
closer to their underlying database implementation.

Note that Relations are Attributes that relate to other Resources;
and Views are Actions that return an User Interface (or it's data).
The distinction is just for clarity.

A major component is the **[MetaData][]** Concern, which
implements an [RDF-based Schema](http://www.w3.org/TR/rdf11-concepts/)
and therefore shares many similarites with
[RDF Schema (RDFS)](http://www.w3.org/TR/rdf-schema/).

Relationship to RDF(S) terms is indicated where applicable,
Resources themselves correspond to
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

Webapp UI label: **MediaEntry** (same as the domain name).

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
- **Attributes:**
    - `is_published`: default `false` ("unpublished"), set to `true` via the `publish` action.
      Can only be changed once! *(That means there is no "unpublish" action)*
- **Relations:**
    - has exactly 1 [MediaFile][]
- **Concerns:**
    - [Responsibility][]
    - [Permissions][] (*as* `subject`)
    - [MetaData][] (*as* `subject`)
    - [Previewable][]
    - [Favoritable][]
    - [CustomURL][]
- **Views:** `index`, `show` (with tabs), `new` ("Upload"), meta-data edit routes
- **Actions:** `create` / upload, `publish`, `destroy`; cover updates via collection arcs


## [Collection][]

Webapp UI label: **Set**. Code, API, and tables remain `Collection` /
`collections` (e.g. `featured_set_id` still points at a Collection).

```figure
┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓
┃              ┃       ┃              ┃
┃              ┃──────▶┃  MediaEntry  ┃
┃  Collection  ┃──────▶┃      or      ┃
┃              ┃──────▶┃  Collection  ┃
┃              ┃       ┃              ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛
```

- **Relations:**
    - has 0 or more Resources *as* `child_media_resources`
      ("The Resources are *in* the Collection")
        - type of Resources has to be [MediaEntry][] or [Collection][]
        - implemented via arc tables:
          `collection_media_entry_arcs` (entry↔set; `cover`, `highlight`,
          `order`/`position`) and `collection_collection_arcs` (parent/child
          sets; `highlight`, order)
        - 0 or 1 [MediaEntry][] *as* `cover` (arc flag)
        - 0 or more Resources *as* `highlight`
    - may belong to a [Workflow][] (`collections.workflow_id` / master set)
- **Concerns:**
    - [Responsibility][]
    - [MetaData][] (*as* `subject`)
    - [Permissions][] (*as* `subject`)
    - [Previewable][]
    - [Favoritable][]
    - [CustomURL][]
- **Views:** `index`, `show`, `new`, meta-data edit by context / by vocabularies
  (`edit_meta_data_by_context`, `edit_meta_data_by_vocabularies`, plus batch variants)
- **Actions:** `create`, meta-data update, destroy (and relation edits)


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
- **Attributes:**
    - `filename`: String, original filename when uploaded
    - `extension`: String, e.g. 'jpg'
    - `content_type`: like mime-type, e.g. 'image/jpeg'
    - `media_type`: String (image|audio|video|document)
    - `height`, `width`: Dimensions in pixels (for images and videos)
    - `size`: the file size in bytes
    - `meta_data`: file meta data (EXIF, IPTC, etc), **NOT** [MetaData][]!
    - `guid`: String, content-addressing id used in on-disk paths under the
      file/thumbnail storage dirs (`guid.first` / `guid`)
    - *(removed)* `access_hash` — former Zencoder access helper; replaced by
      access tokens (`migrate/046_zencoder_access_tokens.rb`)
- **Relations:**
    - has exactly 1 [User][] *as* `uploader`
    - has exactly 1 [MediaEntry][]
    - has 0 or more [ZencoderJob][]s
    - has 0 or more [Preview][]s


## [Preview][]

- **Attributes:**
    - `filename`: String, internal filename (after conversion)
    - `height`, `width`, `content_type`, `media_type`:
       same meaning as in [MediaFile][], but pertains to the converted file
    - `thumbnail`: String, configured preview size label (`grand`, `large`,
      `maximum`, `medium`, `small`, `small_125`, `x_large`, …). See
      [Media types — sizes](../concepts/media-types.md#image--thumbnail-sizes).
      (`SELECT DISTINCT thumbnail FROM previews`)
- **Relations:**
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
- **Attributes:**
    - `label`: String, human-readable name
    - `description`: String
- **Relations:**
    - has 0 or more [MetaKey][]s
- **Concerns:**
    - [Permissions][] (*as* `resource`)
      - `actions` (all `subject`s): `view`, `use`

### "Core Vocabulary"

- Madek has 1 [built-in Vocabulary (`madek_core`)][madek_core_vocab_spec]
- defines some very common MetaKeys (Title, Authors, …)
- has to contain every [MetaKey][] used for internal logic!
    - Title: is also used outside of the [MetaData][] listing
    - Copyright/License: can be used for (public) visibility
    - *not to be confused with plain attributes (like `responsible_user`)*


## [MetaKey][]

- a dynamic meta data "property"
- *RDF:* Corresponds to a [`predicate`](http://www.w3.org/TR/rdf11-concepts/#dfn-predicate)

- **Attributes:**
    - `label`: String, name of the property
    - `description`: String, description for data input and output
    - `hint`: String, hint data input only
    - `admin_comment`: String, **internal** comment for Admins only
    - `position`: Number, order inside the [Vocabulary][]
        *Note: has no semantic meaning, only effect is displayed order in Admin UI)*
    - `meta_datum_object_type`: type of [MetaDatumValue][]
    - `is_enabled_for_{type}`: Bool,
      valid types: [MediaEntry][], [Collection][]
    - `keywords_alphabetical_order`: Bool, (when type is [Keyword][]s)
      signifies if they should be displayed in alphabetical order
    - `is_extensible_list`: Bool, (when type is [Keyword][]s)
      determines if additional [Keyword][]s may be created while editing [MetaData][]
- **Relations:**
    - belongs to exactly 1 [Vocabulary][] ("is in the Vocabulary")
    - belongs to 0 or more [MetaDatum][]s ("is the key for the datum")
    - belongs to 0 or more [Context][]s ("how the MetaKey is used in the Context")


## [Context][]

```figure
┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓       ┏━━━━━━━━━━━━━━┓
┃              ┃       ┃              ┃       ┃              ┃
┃              ┃──────▶┃              ┃       ┃              ┃
┃   Context    ┃──────▶┃  ContextKey  ┃──────▶┃   MetaKey    ┃
┃              ┃──────▶┃              ┃       ┃              ┃
┃              ┃       ┃              ┃       ┃              ┃
┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛       ┗━━━━━━━━━━━━━━┛
```


- groups [MetaKey][]s (as [ContextKey][]s) for display and editing purposes
- name in UI: "MetaKey(s) in Context"
- **Attributes:**
    - `label`: String, human-readable name
    - `description`: String
- **Relations:**
    - has 0 or more [MetaKey][]s *as* [ContextKey][]s
      ("specifies how the MetaKey is used in this Context")
    - can belong to 0 or 1 of each of these [AppSetting][]s:
      `ui_summary_context`, `ui_extra_contexts`, `ui_list_contexts`
      (Ex.: "This context is used as the 'Summary Context'")


## [ContextKey][]

- **Attributes:**
    - `label`, `description`, `hint`: String
        - same as the related [MetaKey][]!
        - optionally set to "specify" for this [Context][]
        - Warning: Admin must ensure semantic consistency!
    - `position`: Number, order inside the [Context][]
    - `is_required`: Bool, require a value (when edititing)
    - `length_max`, `length_min`: Number, require value of certain lengths (when edititing)
    - `input_type`: Number, ???
- **Relations:**
    - belongs to exactly 1 [Context][]
    - belongs to exactly 1 [MetaKey][]


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
- valid data-types for values, by sub-type (see [below](#metadatumvalues))

- **Attributes:**
    - `type`: type of [MetaDatumValue][]
    - `string`: the *Value* if it is a literal value (e.g. Text), *depends on `type`*
- **Relations:**
    - has exactly 1 [MetaKey][]
    - has exactly 1 Resource (valid types: [MediaEntry][], [Collection][])
    - has exactly 1 [User][] *as* "Creator" (`created_by_id`)
    - **Non-literal types have additional Attributes on their relations!**
      *(It stores which [User][] created the MD., as well as for every single value)*
          - i.e. (if `type=Keywords`) → has 1 or more `MetaDatum::Keywords`
              - which has exactly 1 [User][] *as* "Creator" (`created_by_id`)

### [MetaDatumValues][]

These are the valid `type`s for a [MetaDatum][].

Current live `meta_data.type` values (CHECK constraint):

- `MetaDatum::Text`: literal value (String)
- `MetaDatum::TextDate`: literal value (Date as String)
- `MetaDatum::Keywords`: [Keyword][]
- `MetaDatum::People`: [Person][]
- `MetaDatum::Roles`: roles join
- `MetaDatum::JSON`: JSON payload
- `MetaDatum::MediaEntry`: reference to another entry

Historical / legacy types (may still appear in old migrations or MetaKey
object-type enums, but not in the current `meta_data` type CHECK):
`MetaDatum::Groups`, `MetaDatum::Licenses`, `MetaDatum::Users`,
`MetaDatum::Vocables`.

Database note: STI + constraints; confirm with
`SELECT DISTINCT type FROM meta_data`


## [Person][]

- a generic (real-world) person (natural, fictional or juridical), group, or institution.
- *can* be linked to [MetaDatum][] of type `MetaDatumPerson`  (i.e. "Author")
- **Attributes:**
    - `first_name`, `last_name`, `pseudonym`: String
    - `date_of_birth`, `date_of_death`: Date
    - `is_bunch`: true if the entity should be considered plural,
      for example a group of people
- **Relations:**
    - has 0 or 1 [User][]s (for every User created a related [Person][] is also created.)
- **Concerns:**
    - [MetaData][] (as `value`)

## [Keyword][]

- Keyword/Term belonging to a specific MetaKey
- **Attributes:**
    - `term`: String
- **Relations:**
    - has exactly 1 [MetaKey][] as `creator`
    - has exactly 1 [User][] as `creator`
- **Concerns:**
    - [MetaData][] (as `value`)

## [Section][]

- Extension of `Keyword` (nullable 1:1 relation)
- For keywords which belong to the `MetaKey` configured in `AppSetting.section_meta_key_id`
- Have a color and a localized label which is shown in collection or media entry detail view 
- Can be linked to a "index collection"

## [Delegation][]

Named responsibility subject (not a login user). Members are Users and/or
Groups; optional supervisors; optional link to [Workflow][]s.

- **Attributes:** `name`, `description`, `admin_comment`, `notifications_email`,
  `notify_all_members`, `beta_tester_notifications`
- **Relations:** HABTM users, groups, supervisors; HABTM workflows; has many
  MediaEntries/Collections via `responsible_delegation_id`
- Managed in `/admin` (`resources :delegations`)
- See [Responsibility][] and transfer-responsibility
  [Notifications](../concepts/notifications.md)

## [ConfidentialLink][]

Time-limited, revocable token granting access to a polymorphic resource
(typically a MediaEntry) without a full user session.

- **Attributes:** `token`, `revoked`, `expires_at`, `description`
- **Relations:** belongs to creating [User][]; belongs to `resource`
  (polymorphic)
- Used for private embeds / share links (see also [Embeds](../concepts/embeds.md))

## [Workflow][]

Collaborative / structured upload workspace: common permissions and mandatory
meta-data configuration (`configuration` JSON), owners, optional Delegations,
and associated Collections (including a master collection, `is_master`).

- **Attributes:** `name`, `is_active`, `configuration`
- **Relations:** creator User; HABTM owners; HABTM delegations; has many
  Collections
- `finish` locks the workflow (`WorkflowLocker`)

## [License][] (historical)

Standalone `licenses` / `license_groups` tables and `MetaDatum::Licenses` are
**not** in the current live `meta_data` type CHECK. Default license *settings*
may still exist on AppSetting (`media_entry_default_license_*`). Prefer Keywords
/ text meta for rights statements unless an instance still carries legacy data.

---

# *[Private Resources][]*

- "Private" as in "Private API"
- quite literally, not exposed via the `api`.


## [User][]

- stores login credentials to directly log into the `webapp` (session than also valid for `api`)
- *can* be "Admin"
- **Attributes:**
    - `login`: String (alphanumeric characters, and `.`, `-`, `_` allowed)
    - `email`: String
    - `institutional_id` + `institution`: external/institutional identity
      (replaces older `zhdkid`-style fields)
    - `accepted_usage_terms_id`: FK to accepted [UsageTerm][] (see UsageTerm)
    - `password_sign_in_enabled`: whether local password login is allowed
    - `notes`, `autocomplete`, `searchable`, `settings`: supporting fields
- **Relations:**
    - has exactly 1 [Person][]
- **Concerns:**
    - [Permissions][] (as `subject`)

## [Group][]

- list of [User][]s
- is manually defined by a [User][]
- is managed by the [User][] who are members of the Group
- also the supertype of [AuthenticationGroup][] and [InstitutionalGroup][] (implemented in DB as `STI`-table),
  both relating to external authentication systems
- **Attributes:**
    - `name`: String
- **Relations:**
    - has 1 or more [User][]s as *members*
- **Concerns:**
    - [Permissions][] (as `subject`)
    - Historically could appear as MetaDatum value type `MetaDatum::Groups`
      (no longer a live `meta_data.type`)

## [AuthenticationGroup][]

- Subtype of [Group][]
- there is 1 "system" Group called "Signed-in Users" which all users automatically
  join on login (usefor for giving [Permissions][] to "everyone but public"/)
- additionally, there can be 1 for `AuthenticationGroup` for every external authentication method.
  - for example, instances using the "ZHdK" authentication system will have 1 "ZHdK" AuthenticationGroup.
- **Relations:**
    - has 1 or more [User][]s as *members*,
      always contains those that are using this particular authentication.

## [InstitutionalGroup][]

- Subtype of [Group][]
- managed by the same external authentication integrations that have their own [AuthenticationGroup][],
  can be used by them to create InstitutionalGroups and manage their [Users][]s according
  to their internal logic

- **Relations:**
    - has 1 or more [User][]s as *members*,
      which must have a User-ID from the same Directory.


## [ApiClient][]

- an API client. Can use the `api` but not log into `webapp`.
- **Attributes:**
    - `login`: String (alphanumeric characters, and `.`, `-`, `_` allowed)
    - `description`: String
    - `password`: String (saved as digest)
- **Relations:**
    - has 1 or more [User][]s as *administrative contact*
- **Concerns:**
    - [Permissions][] (as subject)


## [AppSetting][]

- instance-specific settings that is stored in the DB,
  so it can be altered at run-time (as opposed to configuration files,
  that can only be altered at deploy-time)

```
CREATE TABLE app_settings (
    id integer DEFAULT 0 NOT NULL,
    featured_set_id uuid,
    splashscreen_slideshow_set_id uuid,
    catalog_set_id uuid,
    site_title character varying DEFAULT 'Media Archive'::character varying NOT NULL,
    support_url character varying,
    welcome_title character varying DEFAULT 'Powerful Global Information System'::character varying NOT NULL,
    welcome_text character varying DEFAULT '**“Academic information should be freely available to anyone”** — Tim Berners-Lee'::character varying NOT NULL,
    teaser_set_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    brand_logo_url character varying DEFAULT '/assets/inserts/image-logo-zhdk.png'::character varying NOT NULL,
    brand_text character varying DEFAULT 'ACME, Inc.'::character varying NOT NULL,
    sitemap jsonb DEFAULT '[{"Medienarchiv ZHdK": "http://medienarchiv.zhdk.ch"}, {"Madek Project on Github": "https://github.com/Madek"}]'::jsonb NOT NULL,
    CONSTRAINT oneandonly CHECK ((id = 0))
);
```


## [Admin][]

- List of all [User][]s that have **administrative privileges** for the instance
- **Relations:**
    - has 0 or more [User][]s *as* `admin`


## [IoInterface][]

- a list of [IoMapping][]s
- **Attributes:**
    - `description`: String
- **Relations:**
    - has 1 or more [IoMapping][]s


## [IoMapping][]

- maps a [MetaKey][] to defined properties ("keys") from external standards
- used for import and export
    - Example: Maps "DublinCore Title" to "MadekCore Title"
- **Attributes:**
    - `meta_key_id` character varying NOT NULL,
    - `key_map` character varying,
    - `key_map_type` character varying,
- **Relations:**
    - has exactly 1 [MetaKey][] ("maps this MetaKey")
    - has exactly 1 [IoInterface][] ("is in this IoInterface")


## [CustomURL][]

- defines a "nice" URL *for* a Resource
- does not change path structure, only allows a user defined "name" instead of `id`
    - example: `/madek/entries/123456` → `/madek/entries/my_entry`
- **Attributes:**
    - `id`: String, alphanumeric, the "name" (**not a UUID**)
- **Relations:**
    - has exactly 1 [User][] *as* `creator` (inital creation by)
    - has exactly 1 [User][] *as* `updator` (last update by)
    - has exactly 1 Resource ([MediaEntry][], [Collection][])

## [ZencoderJob][]

External audio/video encoding job tied to a [MediaFile][].

- **Attributes (typical):** `zencoder_id`, `state` (default `initialized`),
  `error`, `notification`, `request`, `response`, `comment`
- **Relations:** belongs to exactly 1 [MediaFile][]

## [UsageTerm][]

Terms of use presented to users.

- Each instance has 0 or more usage-term versions (`title`, `version`, `intro`,
  `body`)
- The most recently created row is treated as the latest version
- Webapp enforces acceptance of the latest version on login (modal); acceptance
  is recorded via [User][] `accepted_usage_terms_id`



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

- List of all [MetaDatum][]s associated with a `subject` Resource
- in UI, only listed by [Context][]
- *RDF:* Corresponds to [`RDF Graph`](http://www.w3.org/TR/rdf11-concepts/#section-rdf-graph)


## [Responsibility][]

- **Relations:**
    - has exactly 1 [User][] *as* `creator`
    - responsible party is either a [User][] (`responsible_user_id`) **or** a
      [Delegation][] (`responsible_delegation_id`) — mutually exclusive on
      MediaEntry / Collection
- has super-permission **"Delete and Change owner"** (Löschen und Verantwortlichkeit übertragen)
- **implicitly has all the granular permissions** listed below (if applicable)
- Transfer of responsibility can enqueue notifications (see
  [Notifications](../concepts/notifications.md))


## [Favoritable][]

- specific Resources can be "favorited" by Users
- *Note: not implemented for [ApiClient][]s (but technically a [Collection][] could be used)*
- **Relations:**
    - has exactly 1 [User][]
    - has exactly 1 Resource ([MediaEntry][], [Collection][])

## [Previewable][]

Every [MediaEntry][] is "previewable" (in the UI) as an image.
The image can come from several sources:

- either by a compiled preview from the associated [MediaFile][]
    - images/PDF are compiled locally using ImageMagick
    - videos (and audio encodings) are processed with
      [zencoder](https://zencoder.com/); video framegrabs are used as image
      previews. There is no separate auphonic/waveform pipeline in-tree today.
- or a generic image, possibly representing the mime-type of the [MediaFile][]

A presenter like `Presenter::ResourceThumbnail` makes the decision which image is used.
The `MediaEntryController#preview` action is **only** tasked with serving the
specific compiled Previews (the generic thumbnail is separate).

Preview **size labels** and when they are generated: see
[Media types — sizes](../concepts/media-types.md#image--thumbnail-sizes).
Previews are not only UI thumbs — they also back embeds, oEmbed, and download
variants where configured.

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
The `subject` can be of type [User][] (or Delegation on user-permission rows),
[Group][] or [ApiClient][], as well as *"Public"*.

- For a single Permission:
    - **Attributes:**
        - (dynamic) 1 Bool per `action`
    - **Relations:**
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
  controller in `webapp` (as well any included modules) and/or inspecting the
  output of `rake routes`
- for Relations a human-readable yet consistent format is used to indicate cardinality:
    - "exactly 1" (`NOT NULL`, with `UNIQUE` constraint)
    - "0 or 1"
    - "0 or more"
    - "1 or more" (`NOT NULL`)

### Supporting tables (brief)

- **`edit_sessions`** — records that a [User][] edited a [MediaEntry][] or
  [Collection][] (exactly one of `media_entry_id` / `collection_id`); triggers
  propagate timestamps onto the resource.
- **`full_texts`** — search document (`text`) keyed by `media_resource_id`;
  GIN/trgm indexes support filtering.
- **`visualizations`** — per-user layout/control settings for a resource
  identifier (UI state, not core domain metadata).
- **Notifications / email** — `notifications`, `notification_cases`, `emails`,
  `smtp_settings`: see [Notifications](../concepts/notifications.md) (not
  duplicated here).
- **`audited_*`** — request/response/change audit tables; ops/compliance, not
  product entities.

`contexts.context_group_id` has been removed from the current schema.

This page is a **curated** model narrative, not a 1:1 dump of every
`CREATE TABLE` in
[`structure.sql`](https://github.com/Madek/madek-datalayer/blob/master/db/structure.sql).
The ER diagram under `database/` may lag the live schema — prefer
`structure.sql` + this page.



<!-- link definitions -->
<!-- internal -->
[Admin]: #admin
[ApiClient]: #apiclient
[AppSetting]: #appsetting
[AuthenticationGroup]: #authenticationgroup
[Collection]: #collection
[Concerns]: #concerns
[ConfidentialLink]: #confidentiallink
[Context]: #context
[ContextKey]: #contextkey
[Copyright]: #copyright
[CustomURL]: #customurl
[Delegation]: #delegation
[Entrusted Resource]: #entrusted-resources
[Favoritable]: #favoritable
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
[MetaDatumValue]: #metadatumvalues
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
[Section]: #section
[UsageTerm]: #usageterm
[User]: #user
[Vocabulary]: #vocabulary
[Workflow]: #workflow
[ZencoderJob]: #zencoderjob
<!-- external -->
[Decorator]: ../developing/ui/framework.md#decorators
[ResourceFilter]: ./resource_filters.md
[Presenter]: ../developing/ui/framework.md#presenters
[madek_core_vocab_spec]: https://github.com/Madek/madek-datalayer/blob/master/db/migrate/165_migrate_core_keys.rb
