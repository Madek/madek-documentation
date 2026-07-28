# Developer rules

Principles for developing Madek (webapp, admin-webapp, shared datalayer).

## Basics

Prefer simplicity, stability, and maintainability over one-off UI cleverness.
Front-end stack details: [Frontend](frontend.md). Admin: [Admin interface](admin-interface.md).

## Principles

### Progressive Enhancement and Resource-oriented Client Architecture

Follow [ROCA][] and progressive enhancement for major views: server-rendered
HTML that stays usable; rich behaviour layered with React decorators bound to
URLs (see [UI React](ui/react.md)).

Some flows (e.g. batch edit) may be JS-heavy when progressive enhancement would
cost more than it helps — coordinate exceptions with the team.

### Architecture and code quality

Quality is enforced primarily through review ([Submit and review](../project/submit-and-review.md))
plus CI lint/format jobs. Tooling config changes should be coordinated.

### Rails hooks

Use ActiveRecord callbacks sparingly and keep them **idempotent and local** to
the model’s invariants.

**Prefer hooks for**

- Deriving persisted attributes at create time (e.g. `MediaFile`  
  `before_create :set_media_type`)
- Cleaning side effects after destroy (`after_commit … on: :destroy` to delete
  stored files)
- Narrow, documented follow-ups (`after_touch` collecting conversion profiles)

**Avoid in hooks**

- Remote HTTP / encoding jobs that belong in an explicit controller or service
  call (call Zencoder/preview creation from the upload flow, not from a surprise
  `after_save`)
- Permission or policy decisions (keep those in policies / permission helpers)
- Cross-aggregate workflows that are hard to test in isolation (prefer explicit
  service objects / concerns invoked from controllers)

Good references: `datalayer/app/models/media_file.rb`, upload concerns under
`webapp/app/controllers/modules/media_entries/`.

[Submit and review]: ../project/submit-and-review.md
[ROCA]: http://roca-style.org/
