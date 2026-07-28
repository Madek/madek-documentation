# The Madek Documentation

Read it here: <https://madek.readthedocs.org/>

## Run locally

Clone the repo and check out the `pr/doc-update` branch:

```bash
git clone git@github.com:Madek/madek-documentation.git
cd madek-documentation
git checkout pr/doc-update
```

Requires [MkDocs](https://www.mkdocs.org/):

```bash
pip install mkdocs
```

Then from the repo root:

```bash
bin/run.sh serve   # local preview (http://127.0.0.1:8000)
bin/run.sh build   # build static site into ./build
bin/run.sh check   # strict build (fails on warnings)
bin/run.sh clean   # remove ./build
```
