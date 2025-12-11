![Vale Linting](https://github.com/bartificer/taming-the-terminal/workflows/Linting/badge.svg)
![Publish](https://github.com/bartificer/taming-the-terminal/workflows/Publish/badge.svg)
![Latest Version](https://img.shields.io/github/v/tag/bartificer/taming-the-terminal?sort=semver)

# Creating the TTT publications

This repository contains all the content of the Taming the Terminal tutorial as well as the scripts that are needed to build the output.

All builds run inside a contained Docker environment for maximum reproducibility.

## Book information

Please note this book is written in British English

Instructions on how to build the ebooks are in the INSTALLATION.md file.

Under Releases you will find all the ebook versions of this tutorial.

| Format          | Description                              |
| --------------- | ---------------------------------------- |
| ttt.epub        | ePub without audioplayer (best for Apple Books) |
| ttt-audio.epub  | ePub with inline audioplayer             |
| <s>ttt.mobi</s> | Kindle version - not available for now\* |
| ttt-kindle.epub | ePub for newer Kindles \*\*              |
| ttt.pdf         | PDF with pages in A4 size                |
| ttt-us.pdf      | PDF with pages in Letter size            |
| ttt-A5.pdf      | PDF with pages in A5 size                |
| ttt_html.zip    | single page HTML version with assets     |

Note, for the HTML version you need to download the ttt_all.zip. This zip not only contains the 4 output formats, but also the images for the HTML version.

\* As of 2020-09-10 this version will not be provided, because the Amazon plugin to build it is no longer available. If a new solution is available, this version will be added again.
  For now if you require a Mobi format, download ttt.pdf and use <a href="https://www.zamzar.com" target="_blank" rel="noopener noreferrer">a free service like Zamzar</a> to convert it to Mobi and then follow <a href="https://www.amazon.com/gp/sendtokindle/email" target="_blank" rel="noopener noreferrer">Amazon's instructions to email the book to your Kindle</a>.

\*\* Update 2025-12-08: Newer Kindles can handle regular ePubs.

### Reading on a Kindle

If you have an Amazon Kindle, download the `ttt-kindle.epub` file and use one of these options:

#### Send to Kindle (recommended)

Use Amazon’s “Send to Kindle” feature:

- Go to the Send to Kindle page in your Amazon account, or  
- Use the Send to Kindle desktop app, or  
- Email the file as an attachment to your `...@kindle.com` address.

Amazon will convert the EPUB for you and it will appear on your Kindle like any other book.

#### Copy over USB

Connect your Kindle to your computer with a USB cable, then:

- Open the Kindle’s `documents` folder  
- Copy `ttt-kindle.epub` into that folder  
- Safely eject the Kindle

The book should appear in your library a few seconds later.

## Quick Start

Install Docker Desktop (macOS):

Download from https://www.docker.com/products/docker-desktop/

or

```shell
brew install --cask docker
```

Start Docker Desktop, then run:

```shell
make build
```

This generates everything into:

- `output/` — all ebook and PDF formats  
- `docs/` — website version used by GitHub Pages  

## Project Documentation

For detailed information, consult:

- [**INSTALLATION.md**](INSTALLATION.md) — How to install & configure the project
- [**TROUBLESHOOTING.md**](TROUBLESHOOTING.md) — Common problems and fixes  
- [**DEVELOPER.md**](DEVELOPER.md) — Internal structure & build architecture
- [**RELEASE.md**](RELEASE.md) — Release procedure & GitHub Actions flow
- [**CONTRIBUTING.md**](CONTRIBUTING.md) — Guidelines for contributors

Older information, kept for reference:

- **Conversion.md** - how the original HTML files are converted to Asciidoc
- **Additional.md** - some extra information on the choice for Asciidoc

## License

© Bart Busschots / Taming The Terminal contributors. See the repository license for details.

[![License: CC BY-NC-ND 4.0](docs/assets/creativecommons.org_by-nc-nd_4.0_88x31.png)](https://creativecommons.org/licenses/by-nc-nd/4.0/)
