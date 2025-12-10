# Release Procedure for Taming the Terminal

This document describes how to prepare and publish a new release.

## 1. Create a new episode

- write the content, in Asciidoc
- create audiofile
  - top and tail the audio file
  - check naming convention
  - add to final location
- first run of proofreading to fix code blocks, checking if all images are visible, fix oddities in markup
- first build to check if there are obvious errors (`make build`)
- thorough proofreading episode
- fix Vale errors

## 1. Pre‑release Checks

1. Make sure all issues are fixed for this release, committed and pushed
1. For new episodes:
  1. Use the information in **README-podcast-creation.md** to produce the proper audio file and add it to the episode
  1. Make sure the podcast file has the correct intro and outro
  1. Make sure the podcast file has the correct name
  1. Make sure the podcast file is uploaded to the correct location
1. check if the audio file link is added to `publish/mp3_files`

```shell
make check
```

- verify (mostly checked and fixed by the script)
  - All episodes included  
  - TOC correct  
  - MP3 mappings correct
  - QR codes created
  - URLs valid  

## 2. Build the Release

1. Update the version in 'release.json'
1. Commit the change
1. Push the commit
1. Tag the latest commit with the same version prefixed with 'v', so if 'release.json' contains '1.2', the tag must be 'v1.2'.
1. Push the tag
1. Check that the build script runs and builds a new version

Tagging triggers GitHub Actions.

```shell
make build
```

Artifacts appear in:

```shell
output/
docs/
```

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

## 6. Subsequent steps to take to make the release public

### Steps to update the book in Apple Book Store

Book is published using Apple Books Publishing Portal and is tied to Allison Sheridan's Apple ID [authors.apple.com/...](https://authors.apple.com/epub-upload/start#update-upload)

1. Choose "Previously submitted book"
1. Choose an "updated book file..."
1. Choose an "updated sample file..."
   - Even though the book is free, they like a sample file so we have submitted the entire book as the sample.
1. Choose an "updated cover image..."
   - Only necessary if the cover changes - which it might since we're changing the logo to a more modern, flat design

## Other steps

1. tweet new release?
1. send out new newsletter?
