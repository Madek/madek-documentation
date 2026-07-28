# Madek submit and review process

Process for submitting commits, reviewing them, and merging into the Madek
umbrella / submodules.

## Scope

Applies to submit requests and contracted work that produce commits merged into
Madek. A relaxed process applies to the core Madek team (below).

## Branches

Primary long-lived branch on the umbrella today: **`master`** (production /
branch protection / `good-to-merge`). Short-lived personal and feature branches
may still use a `$next`-style naming convention — see [Branches](branches.md)
and [Git reflow](git-reflow.md).

## Submitting

Work is submitted via GitHub pull request (and/or internal tickets). Rules of
thumb:

1. Keep a coherent unit of work (prefer reviewable commits; squash policy may
   vary by team).
2. Target the current integration branch (`master` unless agreed otherwise).
3. CI must be green for the relevant jobs — see umbrella `cider-ci.yml`:
   - **`all-tests`** — lint, integration suites, submodule tests for api /
     admin-webapp / auth / webapp
   - **`good-to-merge`** — branch-protection gate (includes mail /
     integration-tests recursive checks)

Cider-CI tree results remain the usual place to link test outcomes from a PR.

## Reviewing

A submitted change must be reviewed (architect or designee). The review
concludes with an accept/reject summary on the PR (or ticket).

## Merging

Accepted work is merged according to team git practice (fast-forward where
configured; see git-reflow). Prefer preserving author vs committer attribution
when squash/rebase policies require it.

## Relaxed process for the Madek core team

Core developers may land finished units directly and add review notes
afterwards when that is the agreed practice.

Core Madek team (contacts):

- Matus Kmit <matus.kmit@zhdk.ch>
- Max F. Albrecht
- Thomas Schank <thomas.schank@zhdk.ch>

See also [Testing](../developing/testing.md).
