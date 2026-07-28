# Branches

On the [Madek umbrella](https://github.com/Madek/Madek) remote today, the
primary long-lived branch is:

- **`master`** — integration / production line; branch protection and
  `good-to-merge` target this branch

Historical docs and [Git reflow](git-reflow.md) still describe **`next`** /
**`staging`** as collect/staging lines and use `$next` in personal/feature
branch naming. Those names remain useful as *conventions* for short-lived
branches even when dedicated long-lived remotes are not present. Confirm
current remotes with `git branch -r` before assuming `origin/staging` or
`origin/next` exist.

Hotfixes typically target `master` directly (see git-reflow).

See also [Submit and review](submit-and-review.md).
