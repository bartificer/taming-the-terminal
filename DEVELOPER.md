# Developer Documentation

Repository architecture and build methodology.

## 1. Directory Layout

```
book/               # AsciiDoc files
book/assets/        # Images, QR codes
book/theme/         # PDF & EPUB themes
scripts/            # Build scripts
docs/               # Website output
output/             # Build output
website-static/     # Static site assets
Dockerfile
docker-compose.yml
Makefile
package.json
```

### Book setup

Every episode is put in its own file in the `book` directory. All images are in
`book/assets/ttt<nr of episode>`.

`ttt-spine.adoc` and `ttt-contents.adoc` hold the general information to pull the content together in one output file.

For now:

- `index.asc` is empty, it's just there because the spine docs refer to it. Not sure if we need to fill it. Because the entries are only visible in the PDF, the entire section is commented out.

Note: language is **_British English_**!

### Themes

Custom themes under:

```
book/theme/
```


## 2. Build system

Driven by:

- Dockerfile
- docker-compose.yml
- Makefile
- scripts/build-book.sh

## 3. Docker Architecture

The container includes:

- Ruby + Asciidoctor  
- Asciidoctor-pdf  
- Asciidoctor-epub3  
- epubcheck  
- Node.js + npm  
- QR code libraries  

`node_modules` is stored in:

```
docker volume: taming-the-terminal_node_modules_cache
```

## 4. Build Outputs

Generated in:

- `output/` (EPUB, PDF, HTML)
- `docs/` (website)

## 5. Build Scripts

### build-book.sh

- Creates contributor list  
- Builds HTML, EPUB, PDF  
- Runs epubcheck  
- Generates QR codes  
- Copies website assets  
- Creates zip archives  

### check_episodes.sh

- Ensures each episode is referenced  
- Validates MP3 entries  
- Validates URLs  
- Ensures newline at EOF  

## 6. Make Targets

```shell
make help
make check
make build
make docker-build
make npm-install
make shell
```

## 7. CI Pipeline

Triggered on tags:

- Validates repo  
- Builds all formats  
- Publishes GitHub Pages site  
- Uploads artifacts  
