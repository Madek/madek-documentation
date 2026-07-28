# External contributors

Contributions from outside the core team are welcome via **GitHub pull
requests**. Because of Madek’s submodule + Cider-CI workflow, do **not** rely on
GitHub’s green “Merge” button alone — land through the review process in
[Submit and review](submit-and-review.md) and [Git reflow](git-reflow.md).

## Legal / security

- License: [GPL-3.0](https://github.com/Madek/Madek/blob/master/LICENSE) (umbrella)
- Security reports: [SECURITY.md](https://github.com/Madek/Madek/blob/master/SECURITY.md)

## How to merge (maintainer sketch)

```bash
# edit this to match the situation:
TARGET='master'
USER_SHORT='cw'
USER_GITHUB='contributor'

cd Madek
git checkout -b ${USER_SHORT}_${TARGET} ${TARGET}
git pull https://github.com/${USER_GITHUB}/Madek.git ${TARGET}
# resolve conflicts if any
git push --set-upstream origin ${USER_SHORT}_${TARGET}
# wait for CI (all-tests / good-to-merge as applicable), then:
git checkout ${TARGET}
git merge ${USER_SHORT}_${TARGET}
git push origin ${TARGET}
```

Same idea applies when the contribution is in a **submodule** rather than the
umbrella — open the PR on the submodule repo and bump the SHA in the umbrella.
