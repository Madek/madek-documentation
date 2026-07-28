# Notifications

Technical model for Madek notifications and email delivery. User-facing
notification UI belongs in [User documentation](https://doku.madek.ch/).

## Scope today

The notification subsystem is **narrow**. The only wired email template case is
**`transfer_responsibility`** (`NotificationCase::EMAIL_TEMPLATES` in
`datalayer`). Do not assume a general-purpose event bus.

## Data model

| Piece | Role |
|-------|------|
| `notification_cases` | Case definitions (e.g. `transfer_responsibility`) |
| `notifications` | Per-user (or delegation) notification records |
| `notification_case_user_settings` | User preferences (including email frequency) |
| `emails` | Outbound mail queue rows (subject/body, `trials`, …) |
| `smtp_settings` | SMTP configuration for the mail worker |

## Trigger: transfer responsibility

When responsibility for a resource moves to another user/delegation,
`Notifications::TransferResponsibility` creates notification data and may
render an email via `EmailTemplates::TransferResponsibility`.

Delivery to the notification path is gated on **beta tester notifications**
(`beta_tester_notifications?` on user and/or delegation). Without that gate,
`notify!` does not enqueue the case.

## Digests

`Notifications::PeriodicEmails` aggregates pending notifications into
daily/weekly emails according to user settings.

## Delivery: mail service

The **mail** submodule does not create notifications. It polls `emails` rows
(typically `trials = 0`) and sends them using `smtp_settings`. See
[Madek at a glance — components](../start/madek-at-a-glance.md#components-and-request-flow).

Admin configuration of cases/SMTP lives under `/admin`
([Uberadmin](uberadmin.md)).
