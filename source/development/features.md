# Features

<style>
mark { background: rgba(255, 255, 0, 0.5); font-style: normal; font-weight: normal; white-space: pre; display: inline-block;  }

/* Mark todo in docs: */
mark[todo] { padding: 1em; font-family: monospace }
mark[todo]::before { content: '* * * TODO * * *' }
mark[unclear] { padding: 0.35em }

/* Mark todo in code: */
mark[untested] { background-color: #eee }
mark[future] { background-color: rgba(147, 38, 251, 0.43); font-family: monospace; padding-bottom: 1em }
mark[future]::before { content: '* * * NOT IMPLEMENTED * * *' }
</style>

<mark todo>
Temporary list, to be moved to a "Manual/Guide" section.
</mark>

# App Views

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

View on dashboard: List of Users Goups <mark unclear>which?</mark>

Subsection view: Group Management Interface

- list all internal, system and external Groups
- Create, Edit, Delete internal groups


## App Features

### Usage Terms

- admin can add usage terms
- if there are usage terms, any logged in user **must** accept them
  before any other action is allowed
- <mark future>admin can *edit existing usage terms*. This is for fixing small errors,
  not substantial changes, because it's acceptance won't be enforced again.</mark>
- admin can add *new usage terms*, then users have to accept these new terms

# Concepts

## entrusted

A resource that is not publicly viewable,
but the user has view permissions (either directly or via a Group).
