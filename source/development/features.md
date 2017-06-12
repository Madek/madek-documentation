# Features

<mark todo>
Temporary list, to be moved to a "Manual/Guide" section.
</mark>

# "My Madek"

A dashboard for a logged in Madek User.

- is considered the "home page" when a user is logged in
    - the root page redirects
    - <mark untested>its also reachable via main nav ("My Archive")</mark>
- offers actions in header:
    - New Set
    - Import/Upload

The dashboard has various "Subsections".
They are listed in the sidebar,
the dashboard itself shows a reduced view of its contents.

## "My Drafts"

Resources-List, shows all drafts (MediaEntries) that
were <mark unclear>created by</mark> the user.
***This is the only place where draft are listed!***

## "My Entries"

Resources-List, shows all MediaEntries where the User is *responsible* for.

## "My Sets"

Resources-List, shows all Sets where the User is *responsible* for.

## "My latest Imports"

Resources-List, shows all MediaEntries were *created* by the user.

## "My Favorite Entries"

Resources-List, shows all MediaEntries that were *favorited* by the user.

## "My Favorite Sets"

Resources-List, shows all Sets that were *favorited* by the user.

## "My Keywords"

List of *Madek-Core* Keywords that were *used* by the user,
along with how often they were used.

Limited to 200, ordered by usage count.

## "My entrusted Entries"

Resources-List, shows all MediaEntries that were *entrusted* to the user.

## "My entrusted Sets"

Resources-List, shows all Sets that were *entrusted* to the user.

## "My Groups"

View on dashboard: List of Users Goups <mark question>which?</mark>

Subsection view: Group Management Interface

- list all internal, system and external Groups
- Create, Edit, Delete internal groups

# "Explore"

A explore section for public as well as a logged in user. It consists of predefined, configurable (`app_settings` in DB) subsections, which serve as entry points for explorative navigation across the selected media content.

- is reachable via main nav ("Explore")
- is integrated in the root page (login page)

The explore has various "Subsections".
They are listed in the sidebar,
the explore itself shows a reduced view of its contents.

## ["Explore Teaser Entries"][]

This is a collection of pre-defined [MediaEntries]. They are all inside of a specific [Collection] defined in DB as `app_settings.teaser_set_id`. The amount is limited to *12*. They are NOT part of the individual subsection pages.

## ["Explore Catalog"][]

This is a selection of pre-defined ContextKeys (DB: `context_keys`), where `context_id = 'upload'` and `meta_key_id IN app_settings.context_keys`.

### "Explore Catalog Category"

This is a further sub-section which contains values, normally [Keywords], for the particular [MetaKey] of that [ContextKey] (`context_keys.meta_key_id`). Click on a particular [Keyword] triggers a filtered search for that [Keyword]. One leaves the explore section this way.

## ["Explore Featured Content"][]

This is a collection of pre-defined content, which may consists of [MediaEntries], [Collections] (Ruby: `collection.child_media_resources`). The specific collection is defined in DB as `app_settings.featured_set_id`.

## "Explore Most Used Keywords"

This section consists of a list of limited number of [Keywords] for the [MetaKey] `madek_core:keywords` sorted in descendent order according to their usage count (most used first).

## "Login Teaser Entries"

Same as ["Explore Teaser Entries"][] except for the limit and missing meta data like title and authors.

## "Login Catalog"

Same as ["Explore Catalog"][].

## "Login Featured Content"

Same as ["Explore Featured Content"][].

## "Login Latest Media Entries"

This section consists of a limited list of the latest [MediaEntries] (sorted in descendant manner by `media_entries.created_at`).

# Concepts

## entrusted

A resource that is not publicly viewable,
but the user has view permissions (either directly or via a Group).

[MediaEntry]: /architecture/entities/#mediaentry
[MediaEntries]: /architecture/entities/#mediaentry
[Collection]: /architecture/entities/#collection
[Collections]: /architecture/entities/#collection
[Context]: /architecture/entities/#context
[ContextKey]: /architecture/entities/#contextkey
[Keyword]: /architecture/entities/#keyword
[Keywords]: /architecture/entities/#keyword
[MetaKey]: /architecture/entities/#metakey
[MetaKeys]: /architecture/entities/#metakey

["Explore Teaser Entries"]: #explore-teaser-entries
["Explore Catalog"]: #explore-catalog
["Explore Featured Content"]: #explore-featured-content
