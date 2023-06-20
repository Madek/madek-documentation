# Embeds & Co.

Madek supports the following ways to deliver content to third-party systems:

  - [oEmbed](#oembed)
  - [Open Graph protocol](#open-graph-protocol)

## oEmbed

Official specification: <http://oembed.com>

- Supported Entities: `MediaEntry`
- Supported (Madek) Media Types: `image`, `audio`, `video`
- Configuration: none

### Walkthrough

A complete walkthrough to
- explain how it works in general
- show dataflow between WordPress and Madek
- give hints how to implement an "oEmbed consumer"

> Scenario: User wants to embed a Madek MediaEntry in a CMS (e.g. WordPress).  
> Wordpress is the "oEmbed consumer", while Madek is the "provider".  
> Example `URL`: https://madek.example.com/entries/myvideo

1.  User instructs CMS to embed content by giving it's `URL`.  
    (In case of WordPress it can be an URL on its own line (autodetection) or
    by using the `[embed]` syntax.)

2.  The consumer needs to find out the `API_ENDPOINT` of the provider.  
    If the `URL` matches it's internal configuration of known oEmbed providers
    it can be used directly (step 4); otherwise a "Discovery" is tried (step 3).

    Example snippet how a [WordPress plugin](https://github.com/Madek/madek-wordpress-oembed-plugin) sets this config:

    ```php
    wp_oembed_add_provider('https://madek.example.com/entries/*', 'https://madek.example.com/oembed');
    ```

3.  *Find `API_ENDPOINT` via Discovery*:  
    Consumer fetches the MediaEntry's URL in HTML format (just as a browser would)
    and finds a _oEmbed discovery link_ in the HTML `<head>`, the `API_ENDPOINT`
    is the `href` of the `link`.

    ```html
    <link
      rel="alternate"
      type="application/json+oembed"
      title="My Video oEmbed Profile"
      href="https://madek.example.com/oembed?url=%2Fentries%2Fmyvideo"
    >
    ```

4.  Get "embed code" from provider: the `API_ENDPOINT` is called with the `url`
    and possibly more parameters. WordPress will use the `maxwidth` param if
    the width of the current theme is know, e.g.

    WordPress Request:  
    `GET https://madek.example.com/oembed?url=%2Fentries%2Fmyvideo&maxwidth=839`

    oEmbed API Response:

    ```json
    {
      "version": "1.0",
      "type": "video",
      "width": 839,
      "height": 526,
      "title": "My Video",
      "author_name": "The Author",
      "provider_name": "Example Madek",
      "provider_url": "https://madek.example.com",
      "html": "<iframe width=\"839\" height=\"526\" frameborder=\"0\" allowfullscreen src=\"https://madek.example.com/entries/123456789/embedded?height=526&width=839\" ></iframe> "
    }
    ```

5.  The CMS uses the data from the API response to display the embedded content.
    The most simple way is to insert the `html` string into the page content.
    This is what WordPress does if the provider is known (internal config).
    If "Discovery" was used then the `html` content is run through a "security filter",
    e.g. `<iframe>`s are sandboxed:

    ```html
      <iframe
        class="wp-embedded-content" sandbox="allow-scripts" security="restricted" data-secret="XYZ"
        width="840" height="527" frameborder="0" src="https://test.madek.zhdk.ch/entries/123456789/embedded?maxheight=527&amp;maxwidth=840#?secret=XYZ"
      ></iframe>
    ```

### Automatic tests

oEmbed support is automatically tested in different parts of Madek:
- [embedded view tests](https://github.com/Madek/madek-webapp/blob/master/spec/features/embed_player/embed_player_spec.rb): checks content, sizes and styling (also wrapped inside a WordPress layout) as well as Discovery links.
- [oEmbed integration test](https://github.com/Madek/madek-webapp/blob/master/spec/features/oembed_spec.rb): ensures the API endpoint adheres to the oEmbed specification

## Open Graph protocol

Official specification: <http://ogp.me>

- Supported Entities: `MediaEntry`
- Configuration: can be disabled in deploy config (enbaled by default)

Adds the following metadata to the `<head>` of resource pages:
- the canonical URL (UUID-based)
- title
- description (subtitle or description)
- provider (site name)
- previews of type `image`, `audio` and `video`

Clients can use this metadata to show some kind of preview for a Link/URL.
Facebook also provides debugging tools for the [share dialog](https://developers.facebook.com/tools/debug/sharing/) and the [Open Graph](https://developers.facebook.com/tools/debug/og/object/);
as well as an [API to query "like counts" and "share counts"](https://developers.facebook.com/tools/explorer/).

Known working clients:

- Facebook ("share dialog", "Messenger", …)
- Telegram
- Slack

### Example

head content for a video entry:

```html
<meta property="og:type" content="article">
<meta property="og:locale" content="de_DE">
<meta property="og:site_name" content="Example Madek">
<meta property="og:url" content="https://madek.example.com/entries/123456789">
<meta property="og:title" content="My Video">
<meta property="og:description" content="Description of my Video">
<meta property="og:image" content="https://madek.example.com/media/333333333">
<meta property="og:image:type" content="image/jpeg">
<meta property="og:video" content="https://madek.example.com/media/444444444">
<meta property="og:video:type" content="video/mp4">
<meta property="og:video:width" content="620">
<meta property="og:video:height" content="348">
<meta property="og:video" content="https://madek.example.com/media/555555555">
<meta property="og:video:type" content="video/webm">
<meta property="og:video:width" content="620">
<meta property="og:video:height" content="348">
<meta property="og:video" content="https://madek.example.com/media/666666666">
<meta property="og:video:type" content="video/mp4">
<meta property="og:video:width" content="1920">
<meta property="og:video:height" content="1080">
<meta property="og:video" content="https://madek.example.com/media/777777777">
<meta property="og:video:type" content="video/webm">
<meta property="og:video:width" content="1920">
<meta property="og:video:height" content="1080">
```
