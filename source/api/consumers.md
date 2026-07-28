# API consumers

Known consumers and integration patterns. Prefer linking to canonical repos
over duplicating client docs. Endpoint details: Swagger / API Browser.

## In-system: ApiClient

An **ApiClient** is a first-class Madek entity: machine identity that can hold
permission rows on media resources / vocabularies and authenticate to the
classic API (typically HTTP Basic). ApiClients do not log into the webapp UI.

See [Entities](../architecture/entities.md) and
[Permissions](../concepts/permissions.md).

## Desktop: madek-exporter

[Madek Exporter](https://github.com/Madek/madek-exporter) is a **desktop app**
for **macOS, Linux, and Windows** (Electron/JVM). It uses the **classic
JSON-ROA API** (not api-v2 by default). Auth patterns: Basic and/or Bearer
session token — see [Authentication](auth.md).

Treat exporter as an **external** consumer (separate repo), useful as a
reference integration.

## Display: madek-broadcaster (Presenter)

[madek-broadcaster](https://gitlab.zhdk.ch/birk/madek-broadcaster) — also called
**Presenter** / “Sender Medienarchiv der Künste” — is a kiosk presentation
client for **three monitors** (two landscape, one portrait). It consumes the
**classic Madek API** (`/api`) only (credentials via `MADEK_*` env). Treat it
as a known ZHdK display integration — the codebase is **technologically
outdated**; do not treat it as a reference for current Madek client stacks or
for API-v2.

## Other clients

Instance-specific sync scripts, WordPress oEmbed plugins, and ad-hoc tools may
also call `/api` or `/api-v2`. Document them where they live; do not assume a
central catalog here.

## Choosing a surface

See [API vs API-v2](api-vs-api-v2.md). New OpenAPI-first work may target api-v2
when the instance enables it; existing ROA clients stay on classic API.

See [API overview](index.md).
