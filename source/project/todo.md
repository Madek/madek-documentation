> Filled 2026-07-28 against Madek ~v4.11. Checklists below marked done.

# Project — chapter todos

Living tracker (not published). Goal: keep process docs accurate vs umbrella
git/CI practice; keep Ops thin; clear the git-reflow `<mark>` TODO.

**SoT:** [Madek/Madek](https://github.com/Madek/Madek) — `dev/`, `cider-ci.yml`,
`bin/`, `SECURITY.md`, `LICENSE`, `deploy/`.

| Page | Doc status | Gap vs Madek | Action |
|------|------------|--------------|--------|
| [branches.md](branches.md) | `legacy` | Claims `master` / `staging` / `next` | Confirm against current remote branches / release practice |
| [git-reflow.md](git-reflow.md) | `legacy` + `<mark>TODO: init, release flow</mark>` | Incomplete | Fill from `dev/git-*` + tagging scripts or remove mark |
| [submit-and-review.md](submit-and-review.md) | `legacy` | Checklist may lag CI | Align with current cider-ci jobs (`all-tests`, integration, good-to-merge) |
| [external-contributors.md](external-contributors.md) | `legacy` | — | Point to LICENSE / SECURITY.md |
| [ops.md](ops.md) | `stub` | Empty how-tos | Add 1–2 runbooks when available; else leave deferred note without open TODO |

---

## Diff: docs vs current Madek

### Branches

Doc lists `master` (prod), `staging`, `next`. Verify on GitHub remotes before
changing. Release notes live under umbrella `config/releases/` (e.g. `4.11.0.md`).

### Git reflow

Open mark: init + release flow. SoT candidates:

- `dev/git-*` scripts
- `bin/git-check-submodule-consistency*`
- `bin/git-update-and-commit-datalayer-submodules`
- tagging / release scripts used by the team

Either document concrete steps or replace the mark with a short “see scripts in
`dev/` / `bin/`” pointer and link submit-and-review.

### Submit and review

Umbrella `cider-ci.yml`: preflight, integration suites, lint, docs build,
`all-tests`, `good-to-merge`. Note api-v2 / mail may sit outside `all-tests`
deps — don’t claim every submodule is in the same gate without checking.

### Ops

Policy: **no** full deploy handbook here. `deploy/` submodule + ansible remain
external. Page may stay intentionally thin:

- Extract concrete runbooks (e.g. block abusive IPs) when available
- Until then: keep examples list, remove dangling `*TODO:*` by stating
  “runbooks added as extracted” without a blocker TODO — or mark status
  `deferred` in UPDATE-PROCESS

---

## Checklist (clear TODOs / marks)

- [x] Confirm `branches.md` against remotes
- [x] Resolve `<mark>TODO: init, release flow</mark>` in `git-reflow.md`
- [x] Align `submit-and-review.md` with current CI job names
- [x] Thin refresh `external-contributors.md` (LICENSE, SECURITY)
- [x] Either add first ops runbook or rephrase `ops.md` so no open `*TODO:*`
- [x] Update [UPDATE-PROCESS.md](../../UPDATE-PROCESS.md)
