# Translation

> Rails Guide: [Rails Internationalization (I18n) API](http://guides.rubyonrails.org/i18n.html)

Every String (snippet of text) in the Madek Webapp is not embedded in the source
code directly. Instead, they are all collected in a "YAML" file under a certain
`key`, which is used to reference that string from the source code.

There can be one of those files per language, enabling translation of Madek into
different languages.  
The default language is German (`de`), the file can be seen here:
<https://github.com/Madek/madek-webapp/blob/madek-v3/locale/de.yml>  
Other languages: [English (`en`)](https://github.com/Madek/madek-webapp/blob/madek-v3/locale/en.yml)

Tip: It is possible to search for a specific `key` on github to see where it is
used in the source code.  
Ex.: <https://github.com/Madek/madek-webapp/search?utf8=✓&q=sitemap_my_archive>

# Translator Guidelines

- Format: `the_key: "The text"`
- The key may only consist of lowercase letters underscores (optionally a number at the end)
- After the key comes a colon and a space (`: `)
- The Text is enclosed between programmer's double quotes (`"`), and contain
    anything except line breaks and those same quotes.
    *Note:* `"` rarely appears in product copy anyhow since typographically
    correct quotes should be used for each language.

Start a new translation by copying `de.yml` or `en.yml` to a new file.  
Examples: `fr.yml` for French; `de-ch.yml` for Swiss German

Recommended Editor: [Atom](https://atom.io)

- has support for YAML out of the box
- even better when "Indent Guides" and "Show Invisibles" is set to true in
    "Atom > Settings"

# Usage in source code

Ruby:

```rb
I18n.locale = 'de'
string = t(:the_key_name)
string = I18n.t(:the_key_name) # when the short helper is not available
```

JavaScript/CoffeeScript:

```js
t = require('app/assets/lib/string-translation.coffee')('de')
string = t('the_key_name')
```

# Rules for developers

Reasoning: keep it simple and consistent to make search and replace more easy later.

- Ruby: Always use symbols for keys.
- Ruby/JS: **Never build a key dynamically** (for example by defining a 'base key'
  and then appending some specific name at the end inside a `map`).

```rb
# BAD:
section = 'foo'
[{ id: 'bar', n: 1}, { id: 'baz', n: 2}].map do |id, n|
  puts t("#{section}_#{id}") + ': ' n
end
# GOOD:
[{ title: t(:foo_bar), n: 1}, { title: t(:foo_baz), n: 2}].map do |title, n|
  puts title + ': ' n
end
```
