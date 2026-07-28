# Testing

How Madek tests are organized and how they relate to CI. Process for merging
and review: [Submit and review](../project/submit-and-review.md).

## Where specs live

| Area | Specs | How to run (typical) |
|------|-------|----------------------|
| **webapp** | `webapp/spec/`, JS under `webapp/app/javascript/spec/` | webapp cider-ci / local rspec |
| **admin-webapp** | `admin-webapp/spec/` | submodule `all-tests` |
| **api** | `api/spec/` | server running + `./bin/rspec` |
| **api-v2** | `api-v2/spec/` | `./bin/rspec` (own cider-ci) |
| **auth** | `auth/spec/` | `./bin/rspec` |
| **datalayer** | `datalayer/spec/` | via datalayer / embedded integrity |
| **mail** | `mail/spec/` | mail README (often with fake SMTP) |
| **integration-tests** | `integration-tests/spec/` | umbrella integration jobs + reverse proxy |

## RSpec and Capybara

Almost every Ruby service submodule with a `spec/` tree runs **RSpec**.
**Capybara** (browser feature specs, typically with **Selenium**) is only used
where there is a UI:

| Submodule | RSpec | Capybara | Notes |
|-----------|-------|----------|--------|
| **webapp** | yes (`rspec-rails`) | yes + `selenium-webdriver` | Large `spec/features/` |
| **admin-webapp** | yes (`rspec-rails`) | yes + `selenium-webdriver` | `spec/features/` |
| **auth** | yes | yes + `selenium-webdriver` | Sign-in UI features |
| **integration-tests** | yes | yes + `selenium-webdriver` | Cross-service browser flows |
| **api** | yes | no | Request / JSON-ROA specs |
| **api-v2** | yes | no | Request / OpenAPI-oriented specs |
| **datalayer** | yes (`rspec-rails`) | no | Models / DB concerns |
| **mail** | yes (`rspec-rails`) | no | Mail worker / SMTP fakes |
| **deploy** | — | — | No Ruby test Gemfile |

Feature specs live under `*/spec/features/` for the Capybara users above.

## Umbrella CI (`cider-ci.yml`)

Important meta-jobs:

| Job | Role |
|-----|------|
| `integration-tests-*` | Preflight + plain / release-info / cors suites |
| `all-tests` | Depends on lint, integration-tests, deploy container check, and submodule `all-tests` for **api**, **admin-webapp**, **auth**, **webapp** |
| `good-to-merge` | Branch-protection gate: umbrella `all-tests` plus recursive “merged to master” / good-to-merge of key submodules (includes **mail**, **integration-tests**, …) |

**Caveats**

- **api-v2** has its own cider-ci `all-tests` but is **not** listed in the
  umbrella `all-tests` dependency set — treat it as a separate gate when
  changing api-v2.
- **mail** is pulled into **good-to-merge**, not necessarily into umbrella
  `all-tests`.

Always check the current `cider-ci.yml` in the umbrella and in the submodule
you touch before assuming coverage.
