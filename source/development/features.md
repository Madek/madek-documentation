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


# Concepts

## entrusted

A resource that is not publicly viewable,
but the user has view permissions (either directly or via a Group).
