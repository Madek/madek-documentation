# User Manual

**Looking for the User Manual?** see [**Madek Help** (Madek Hilfe) by ZHdK's
Madek Support Team](https://wiki.zhdk.ch/madek-hilfe/doku.php)

---

See menu for Table of Contents.  
Sections in 'implementation' only concern Developers.

---

Below is the designated area for some yet-unsorted stuff,
should be cleaned up before a release.


---

## TMP

## Featurescape

[in PDF Form here](manual/Featurescape_2.pdf)

(Maintained by S. Schumacher)

---

## Branches

- `master`: on production
- `staging`: on staging
- `next`: collect for staging

---

# External Contributors

(for non-technical staff the same process applies)

- Contributions from external people can be send via pull requests
- Because of our workflow regarding git and continuous testing,
  we can't use the big green merge button


## How to merge

```bash
# edit this to match the situation:
TARGET='master'
USER_SHORT='cw'
USER_GITHUB='niknoilich'

cd madek
git checkout -b ${USER_SHORT}_${TARGET} ${TARGET}
git pull https://github.com/${USER_GITHUB}/madek.git ${TARGET}
# should had no conflicts
git push --set-upstream origin ${USER_SHORT}_${TARGET}
# test in CI, if success:
git checkout ${TARGET}
git merge ${USER_SHORT}_${TARGET}
git push origin ${TARGET}
```

---
