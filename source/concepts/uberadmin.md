# Uberadmin (`/admin`)

Madek has several “admin” concepts. They must not be conflated.

## 1. Admin membership (`admins` table)

A user listed in `admins` (`datalayer` `Admin` model) is an **admin** of the
instance. That alone does **not** bypass resource ACLs in the webapp.

## 2. Uberadmin mode (webapp session)

Admins can enable **uberadmin mode** for the current webapp session
(`POST /session/uberadmin`, `session[:uberadmin_mode]`). While active,
`AuthorizationSetup` uses `FakeUberadminPolicy` / `scope.all` so ACL checks
pass for that request.

- Requires membership in `admins` **and** the session flag
- Scope: **webapp** policies only (not a global DB superuser flag)
- Specs: e.g. `webapp/spec/features/app/admin-mode_uberadmin_spec.rb`

Relation to normal [permissions](permissions.md): uberadmin mode temporarily
ignores them; it does not rewrite permission rows.

## 3. Admin UI (`admin-webapp` → `/admin`)

The dedicated admin Rails app (proxied at `/admin`) is the configuration UI:
users/groups, vocabularies, `app_settings`, sections, SMTP, media reencode,
notification cases, and related instance setup.

- **Dev guide:** [Admin interface](../developing/admin-interface.md)
- **Day-to-day operation:** [User documentation](https://doku.madek.ch/) or
  [Medienarchiv Wiki](https://wiki.zhdk.ch/medienarchiv/doku.php)

## 4. API-v2 admin routes

`/api-v2/admin` is a separate Clojure surface. Access requires an `admins`
row; resources can be limited with `--http-resources-scope ADMIN|USER|ALL`.
This is not the same process as admin-webapp.

See [Madek at a glance — surfaces](../start/madek-at-a-glance.md#surfaces) and
[API vs API-v2](../api/api-vs-api-v2.md).
