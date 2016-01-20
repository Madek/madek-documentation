**Entities** are all things that exist in the App.
Rails calls them "Models".
*Some* of the Entities are "Resources".

# Primary

## [MediaEntry][]

- most important [Resource][] in the App
- has 1 [MediaFile][]
    - has 1 [Preview][]
- has [MetaData][]

### Concerns:

- [MetaData][]
- [Permission][]s

### [Preview][]

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

### Preview of Sets

> “Das Preview eines Sets kommt vom ‘Cover’, User-gewählter Entry (aus dem Set) der das Set visuell repräsentiert.
> Wenn kein ‘Cover' vorhanden ist, nehmen wir aus der Liste der Einträge, die direkt im Set liegen, sortiert nach der (mögl. gespeicherten) Sortierung des Sets, den ersten von dem wir eine visuelle Darstellung haben.
> Wenn so kein ‘Cover’ gefunden wird, nehmen wir das generische Preview für ein Set.”



## [MediaFile][]

<mark>[TODO]</mark>

## [Collection][]

Formerly known as `Set`.

- is a [Resource][]
- is a [MediaResource][]
- has a list of [MediaEntries][]
- belongs to `creator`=[User][]

### Concerns:

- [MetaData][]
- [Permission][]s



## [FilterSet][]

A saved `filter`.

- has many [MediaEntries][], **NOT** through "normal" Relations,
  but because they `filter` matches them!

### Concerns:

- [Permission][]s


## [Person][]

- a generic (real-world) [Person][] (German: "Juristische Person")
- *can* be linked to (equal to) a [User][]
- *can* be linked to [MetaDatum][] of type `MetaDatumPerson`  (i.e. "Author")

### Relations

* [User][], rails-type: `has_one`, effectively enforced by unique constraint on index


## [User][]

- User with account/login

### Relations

* [`person`](#person), rails-type: `belongs_to`, null: `false`


## [Group][]

- list of [User][]s
- is manually defined by a [User][]
- not to be confused with [InstitutionalGroup][]

### Relations

* `users`: list of [User][]s, rails-type: `has_many`

### Notes

* Supertype of [`InstitutionalGroup`](#institutionalgroup), implemented as `STI`-table


# Secondary

## [InstitutionalGroup][]

An externally-defined [Group][], synced with an `LDAP`-Directory.

- has a list of [User][]s ("Members"),
  which by definition must have User-ID from the same Directory.

### Notes

* Subtype of [Group][], implemented as `STI` in the `groups` table

# Concerns

Entities that have similar relations to several [Resources][]s
are called Concerns.

## [Relation][]s

- <https://wiki.zhdk.ch/madek-hilfe/doku.php?id=relationship>

## "Entrusted Resources"

A Resource is "entrusted" to a User if they have "view" Permissions on the
Resource, either directly or via their membership in a Group.
Therefore, a Resource with "view" Permissions for "Public" can
never be "entrusted" because it is already public.

## "Privacy Status"

- `public`: "Public" has "view" Permission
- `private`: No Person or Group has "view" Permission
- `shared`:
    - if User is the owner and any Person or Group has "view" Permission
    - if User is not the owner and has "view" Permission
      (directly or via Group membership)


## [Permission][]s

Almost like [UNIX](https://en.wikipedia.org/wiki/File_system_permissions#Classes).
Notable Differences:

- 'owner' is not a 'Class' (it's more like *root*, for this thing)
- there is no 'execute', but 'fullsize'
- there is no 'write', but distinct 'edit_data' and 'edit_permissions'


### [Responsible][]

- for [MediaEntry][], [MediaSet][], [FilterSet][], there is always exactly 1 **owner**
    - => **`responsible_user`**: [User][]
- has super-permission **"Delete and Change owner"** (Löschen und Verantwortlichkeit übertragen)
- **implicitly has all the granular permissions** listed below (if applicable)

### Per-Subject

More granular permissions can be granted
**on** [MediaEntry][]s, [MediaSet][]s and [FilterSet][]s,
**for** [User][], [Group][]s, [APIClient][], as well as *"public"*.

"Public" permissions apply to any request, logged in or not.

Example: When checking if a [MediaResource][] is visible to the [User][], we'll need to
combine (`UNION`) the permissions of the following subjects:
- the **Public**; and, if the [User][] is logged in (there is a `current_user`), also
- the **User** itself
- *all* **Groups** the User is member of
- <mark>TODO: The implicit Permissions of the [Responsible][] are already handled by the [Permissions][] module (?)</mark>


| subject/permission | data_and_preview            | edit_data                                        | fullsize                                 | edit_permissions              |
| :----------------  | :-------------------------: | :-------------:                                  | :-------------:                          | :----------------:            |
| **[MediaEntry][]**   | get metadata and previews   | edit metadata                                    | get full size                            | edit permissions              |
| ↳ [User][]           | ✔                           | ✔                                                | ✔                                        | ✔                             |
| ↳ [Group][]          | ✔                           | ✔                                                | ✔                                        | -                             |
| ↳ [APIClient][]      | ✔                           | -                                                | ✔                                        | -                             |
| ↳ "public"         | ✔                           | -                                                | ✔                                        | -                             |
| *Beschreibung*     | betrachten                  | Metadaten editieren                              | Original exportieren & in PDF blättern   | Zugriffsberechtigungen ändern |
|                    |                             |                                                  |                                          |                               |
|                    |                             |                                                  |                                          |                               |
| **[MediaSet][]**     | get metadata and previews   | edit metadata **and relations**                  | -                                        | edit permissions              |
| ↳ [User][]           | ✔                           | ✔                                                | -                                        | ✔                             |
| ↳ [Group][]          | ✔                           | ✔                                                | -                                        | -                             |
| ↳ [APIClient][]      | ✔                           | ✔                                                | -                                        | -                             |
| ↳ "public"         | ✔                           | -                                                | -                                        | -                             |
| *Beschreibung*     | betrachten                  | Metadaten editieren & Inhalte hinzufügen         | -                                        | Zugriffsberechtigungen ändern |
|                    |                             |                                                  |                                          |                               |
|                    |                             |                                                  |                                          |                               |
| **[FilterSet][]**    | get metadata and previews   | edit metadata **and filter**                     | -                                        | edit permissions              |
| ↳ [User][]           | ✔                           | ✔                                                | -                                        | ✔                             |
| ↳ [Group][]          | ✔                           | -                                                | -                                        | -                             |
| ↳ [APIClient][]      | ✔                           | ✔                                                | -                                        | -                             |
| ↳ "public"         | ✔                           | -                                                | -                                        | -                             |
| *Beschreibung*     | betrachten                  | Metadaten editieren & Filtereinstellungen ändern | -                                        | Zugriffsberechtigungen ändern |



# Special

## [MediaResource][]

Either a [MediaEntry][] or a [Collection][] or a [FilterSet][] (polymorphic).

Formerly a "real" Model, now just a convention between
[Presenter][]s and [Decorator][]s (so they only exist in the UI).

A more technical definition: Anything that can be put in a [Collection][],
i.e. every Model for which there is a `collection_$something_arcs` table.


---

---

## Abstract

### [Resource][]

- distinct kind of thing (noun)
- *not* the "R" in "REST", but [REST is all about Resources](https://en.wikipedia.org/wiki/Representational_state_transfer#Software_architecture)
- it's also what ["MVC"](https://en.wikipedia.org/wiki/Model-View-Controller) and ["CRUD"](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) are about:
- most standardized part of the app
    - "resourceful" routes
    - "resourceful" model/view/controllers

[Collection]: #collection
[Concern]: #concern
[Copyright]: #copyright
[Decorator]: ../development/ui-framework/#decorators
[FilterSet]: #filterset
[Group]: #group
[InstitutionalGroup]: #institutionalgroup
[MediaEntries]: #mediaentry
[MediaEntry]: #mediaentry
[MediaFile]: #mediafile
[MediaResource]: #mediaresource
[MetaData]: #metadatum
[MetaDatum]: #metadatum
[Owner]: #owner
[People]: #person
[Permission]: #permissions
[Person]: #person
[Presenter]: ../development/ui-framework/#presenters
[Preview]: #preview
[Resource]: #resource
[User]: #user
[polymorph]: #polymorph
