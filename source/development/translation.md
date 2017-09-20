# Translation

Every String (snippet of text) in the Madek Webapp is not embedded in the source
code directly. Instead, they are stored with a certain `key`,
which is used to reference that string from the source code.

Example: `home_banner_welcome_title` → "Hello World!"

These translations are stored in a table/spread sheet in the repository.
It can be viewed at and downloaded from GitHub.
Current version: [`translations.csv`](https://github.com/Madek/madek-webapp/blob/master/config/locale/translations.csv)  
*(The "Raw" button points to the downloadable file)*

There can be one column per language, enabling translation of Madek into
different languages.  
The default language is German (`de`).

Tip: It is possible to search for a specific `key` on github to see where it is
used in the source code.  
Ex.: <https://github.com/Madek/madek-webapp/search?utf8=✓&q=sitemap_my_archive>

# Translator Guidelines

Edit translations or start a new one by opening the `translations.csv` file in a
spreadsheet editor (LibreOffice, Google Docs, Excel).  

This file is found in the `madek-webapp` repository under [`config/locale/translations.csv`](https://github.com/Madek/madek-webapp/blob/master/config/locale/translations.csv).
After editing it with an editor, it needs to be exported to `csv` again and checked into the repository.

# Usage in source code

## Ruby:

> Rails Guide: [Rails Internationalization (I18n) API](http://guides.rubyonrails.org/i18n.html)

```rb
I18n.locale = 'de'
string = t(:the_key_name)
string = I18n.t(:the_key_name) # when the short helper is not available
```

## JavaScript/CoffeeScript:

```js
t = require('app/assets/javascripts/lib/string-translation.coffee')('de')
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
