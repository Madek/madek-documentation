*This is a generic description which applies to all countries which have
signed and implemented the [1886 Berne Convention on copyright](https://en.wikipedia.org/wiki/Berne_Convention)*
*This is **not** about trade- and other marks nor about patents.*

Every "Creative Work" (encoded by a [MediaFile][])
can have one or more authors in a legal sense

**IF** the the Work falls into the **public domain**,
none of the following is relevant!
There MAY still be authors in an historic/cultural/moral/ sense but as far as
copyright law (and this "algorithm") is concerned, the "public" now "owns" all
the rights, similar to Air.
Conditions for the public domain also differ by country, but generally

- all authors are dead for more than 70-90 years
- the work has been published for more than 70-90 years
- if the author(s) relinquished his rights by declaring the work to be
  in the public domain and it was created in a country that allows this
  (for example the USA, but not Germany).

Any of those authors has *"the right to copyrights"*
**IF** the "creative contribution" was significant

      - which is defined per kind of media…, e.g.
          - Photos always apply if made by human!
          - Fonts not "different" enough from just Alphabet "Letters"
          - Music, Film, etc: "I know it when I see it"

This decision can *NOT* be made programmatically, we have to rely
on the user to correctly tell us the `copyrighted` status, which can be true
or false (when it's in the public domain) or `null` if unknown.

There are actually several distinct rights the author(s) has by law,
the German term "Urheberrechte" is more clear in this sense:

- "commercial rights", aka "what the term *copy*-right means"
    - publishing (to the public)
    - copying
    - distributing copies (to the public)
- "moral rights"
    - being named as the author
    - not having the work destroyed/defaced
    - visiting the work (some countries)
    - get payed a share if the work is sold for profit (some countries)
- several more…

The only two to "transfer the right of executing" any of the "copyright rights"
is by **LAW** or in form of a **LICENSE**. A License **MUST** specify

- the (list of) WORKs
- the list RIGHTS being licensed
- to WHOM
- WHERE
- WHEN
- under which CONDITIONS
- BOOL: exclusive or not
- BOOL: can be sub-licensed

A **LAW** usually specifies the same properties.
While it's not a License in the legal sense, both can be technically
handled in the same way: a thing that transfers rights to a work to one more
entities, with the above properties.

A **LICENSE** also has a SOURCE property, which is either

- a specific LAW, or
- a specific contract between the author(s) and one more third parties
- a License "for the public", published with the work (Free Software, CreativeCommons)


Which RIGHTS can be licensed also depends on the country:
The commercial right can always be licensed, but many countries restrict
licensing of some moral rights ('like being named').

Note: Reading this list it becomes clear that simple copyleft licenses
like BSD, MIT or WTFPL define almost the absolute minimum of a valid license.

There is 1 Swiss **LAW** that is very important in the context of Madek
(actually a chain of several laws up to the federal level…):
For all Works created at the ZHdK by employees (as part of their work)
or students (as part of their studies), the commercial rights are transferred
to the ZHdK (this applies to all almost all Universities).

The ZHdK bylaws state about these rights

- they can be used by the university in any way
- the creator can negotiate terms for own usage by case
- conditions of usage for third parties
    - e.g. publishing for PR, caption must include "(c) ZHdK, Name of Creator"
- "sub-licensed" on a department-level, they can alter conditions
    - e.g. caption must include "(c) Department Design ZHdK, Name of Creator"
    - a department *could* also put all students works under CC-BY-NC-SA


TL;DR:
There is no Model "Copyright", but a 'copyrighted' attribute on MediaFiles.
A Model "License" would be enough to represent all the ways to transfer rights.

For the user, the UI could stay roughly the same but allow more options.
There can be some specific hints if we know about the context from Metadata
about the File or the User (e.g. Link to the official University explanation
about the above situation when the User is a student or employee).

The current schema could be migrated from the MetaData, but would require
manual intervention because right now the field 'Copyright' is just a string,
and has no consistent usage.
It is mostly used like `if (copyrighted==true) then creator.name else 'Public Domain'`,
but for the ZHdK-Works mentioned above it is often:
`if (license.where(source: 'special-zhdk-rules') then 'ZHdK' else creator.name`.
(Option: leave the old field, but don't allow it to be used for new entries (deprecation))
