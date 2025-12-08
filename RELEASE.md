# Release Procedure for Taming the Terminal

This document describes how to prepare and publish a new release.

## 1. Pre‑release Checks

- use the information in **README-podcast-creation.md** to produce the proper audio file and add it to the episode
- check if the audio file link is added to `publish/mp3_files`

```shell
make check
```

- verify (mostly done by the script)
  - All episodes included  
  - TOC correct  
  - MP3 mappings correct  
  - URLs valid  
- update version info in `release.json`.

## 2. Build the Release

```shell
make build
```

Artifacts appear in:

```shell
output/
docs/
```

## 3. Tag the Release

```shell
git add .
git commit -m "Release vX.Y.Z"
git tag vX.Y.Z
git push
git push --tags
```

Tagging triggers GitHub Actions.

## 4. GitHub Actions Workflow

The CI pipeline:

1. Runs validation  
2. Builds book  
3. Uploads outputs as artifacts  
4. Publishes GitHub Pages site (`docs/`)  

## 5. Create GitHub Release

Attach:

- All PDFs  
- All EPUBs  
- `ttt_all.zip`  
- `ttt_html.zip`

Release complete!
