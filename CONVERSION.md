# Information on the conversion

This file contains all the instructions and information on how the original HTML files were converted to Markdown and ultimately to Asciidoc.

Since this information is now (December 2025) no longer needed for adding new episodes, the information is removed from the INSTALLATION file and kept here for reference.

## How it works

Download the HTML file of the episode and convert it to Markdown using the tttconvert code.
Then, convert the Markdown to Asciidoctor using Kramdoc.
Once you've set up all the necessary tools, you can simply build all three versions using the command

`bundle exec rake book:build`

To get there you need:

- Ruby as a separate install (because you don't want to mess up your System folder)
- various gems
- bundler
- rake
- asciidoctor
- asciidoctor-epub3
- asciidoctor-pdf
- clone the GitHub repository

## Prepare your environment

### Install NodeJS

Install NodeJS version 12.x.x or later. Follow the instructions on [nodejs.org](https://nodejs.org/en/).

### Install Ruby on macOS

Ruby is default part of macOS but every `gem install <some package>` will lead to an attempt to update the system framework. Not a good idea.

Follow the instructions at: [GoRails.com](https://gorails.com/setup/osx/10.15-catalina)

just the part 'Installing Ruby'

### Install Kramdoc

Install Kramdoc using

```shell
gem install kramdown-asciidoc
```

more information at [Convert Markdown to AsciiDoc](https://matthewsetter.com/technical-documentation/asciidoc/convert-markdown-to-asciidoc-with-kramdoc/)

### Clone the git repository

Clone the repository

```shell
git clone https://github.com/bartificer/taming-the-terminal.git
```

### Install necessary Ruby gems

switch to the root directory of the git repository you just cloned and run

```shell
bundle install
```

This installs all Ruby gems in the `Gemfile`.

### Install the dependencies for the tttconvert program

```shell
cd tttconvert
npm install
```

### Install the QR code library

```shell
npm install
```

## Compile

### Prepare the files

The original episodes are HTML pages on Bart's website. They need to be converted first to AsciiDoctor file before they can be processed further. This section explains how to do that for a new episode.

1. Download the HTML page from Bart's website, use Safari and download it as 'page source'. Save in the `sourcefiles` directory (create this if it's not present).
   This ensures the correct naming convention and the original links to the images and other assets.

2. Convert HTML to Markdown

   ```shell
   cd tttconvert
   ./tttconvert.sh xx
   # xx is the number of episode,
   # leave blank to convert all files
   ```

   This app also downloads the images. Output is in `convert2` and `convert2/assets`.

3. Convert to Asciidoctor

   ```shell
   cd ../convert2
   kramdoc --format=GFM --output=tttXX.adoc tttXX.md
   ```

4. Copy the Asciidoctor files + assets to the book

   ```shell
   cd ../convert2
   cp tttXX.adoc ../book  # XX is the file you want to copy
   cp -r assets/tttXX ../book/assets
   ```

5. Make the QR code

   - open book/tttXXX.adoc
   - copy the link to the podcast to the file `publish/mp3_files
   - run the script

   ```shell
   cd ../scripts
   ./generate_qrcode.sh
   ```

6. Cleanup

   - add the new tttXX.adoc file to `book/ttt-contents.adoc`
   - if necessary, rename the QR code file to match the TTT_XX.png naming convention
   - open the `book/tttXX.adoc` file and fix the episode box, the reference to the QR code and miscellaneous changes.

### Build the files

Test if your setup works by running

```shell
bundle exec rake book:build
```

or simply

```shell
bundle exec rake
```

because `book:build` is the default.

When it finishes, the output looks like this:

```shell
Generating contributors list

Converting to HTML...
 -- HTML output at output/ttt.html
Sync the assets

Converting to EPub...
 -- Epub output at output/ttt.epub

Converting to PDF A4... (this one takes a while)
 -- PDF output at output/ttt.pdf

Converting to PDF US... (this one takes a while)
 -- PDF output at output/ttt-us.pdf
```

and no other errors, there should be a PDF in A4-size, a PDF in Letter-size, an HTML file and an ePub file in the `output` directory.
Assets are already synced by the build script.

