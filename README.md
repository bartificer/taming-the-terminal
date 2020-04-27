![Vale Linting](https://github.com/hepabolu/ttt/workflows/Linting/badge.svg)

# Creating the TTT publications

## How it works

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

### Install Ruby on macOS

Ruby is default part of macOS but every 'gem install <some package>' will lead to an attempt to update the system framework. Not a good idea.

Follow the instructions at: [GoRails.com](https://gorails.com/setup/osx/10.15-catalina)

just the part 'Installing Ruby'

### Clone the git repository

Clone the repository

```
git clone https://github.com/hepabolu/ttt.git
```

### Install necessary Ruby gems

switch to the root directory of the git repository you just cloned and run

```
gem install
```

This installs all Ruby gems in the `Gemfile`.

### Build the files

Test if your setup works by running

```
bundle exec rake book:build
```

When it finishes output like this:

```
fatal: No names found, cannot describe anything.
Generating contributors list
Converting to HTML...
 -- HTML output at ttt.html
Converting to EPub...
 -- Epub output at ttt.epub
Converting to PDF... (this one takes a while)
 -- PDF output at ttt.pdf
```

and no other errors, there should be a PDF, an HTML file and an ePub file in the `output` directory.

**Note**: to have the screenshots visible in the HTML file, copy the `assets` folder from `book/assets` to `output/assets`

## Book setup

Every episode is put in its own file in `book`. All images are in
`book/assets/ttt<nr of episode>`.

`ttt-spine.adoc`, `ttt-epub-spine.adoc` and `ttt-contents.adoc` hold the general information to pull the content together in one output file.

For now:

- `colophon.adoc` holds some boilerplate text. It needs to be update to proper information
- `index.asc` is empty, it's just there because the spine docs refer to it. Not sure if we need to fill it.

Note: language is British English!

## Bug fixes and workaround

This section contains some notes on bug fixes and workarounds that have been applied to get it working

### Fake second paragraph

See: [Asciidoctor git repository](https://github.com/asciidoctor/asciidoctor/issues/2860)
Worked around by adding a second paragraph either by separating the last (few) sentence(s) or by adding an invisible second paragraph consisting of a single space.

```
+++&nbsp;+++
```

Books doesn't like this, so I had to surround it with `ifdef`s:

```
ifndef::backend-epub3[]
+++&nbsp;+++
endif::[]
```

### Backticks problems

Somehow there is a bug in `asciidoctor` that causes backticks to be passed through rather than marking the conversion to `monospace`.

### Color coding in ePub

`Rouge` is used as source code highlighter in PDF and HTML, but it doesn't work in ePub. Only `Pygments` is supported in ePub, but this has no good support for shell scripts. Somehow the color coding in Books actually looks to be just black & white.

**UPDATE**: it looks like the attribute for the styling in the spine is not honored. It should be added as an attribute on the command line like

```
-a pygments-style=manni
```

Source: [Prepare an asciidoc document](https://asciidoctor.org/docs/asciidoctor-epub3/#prepare-an-asciidoc-document)

### Highlights in source code

It is not possible to highlight specific parts of the source code, so all references to e.g. `<strong>` must be removed from the snippet or it will show up verbatim in the output file.

### Keyboard shortcuts

Asciidoctor supports the HTML5 keyboard shortcuts, so change any reference to keyboard shortcuts to the HTML5 keyboard counterparts.
Note, the command key (CMD) can be used as `{commandkey}`.
<s>For the shortcuts to show up properly in the VScode previewer, each document needs an `:experimental:` option in the header.</s>
I added a document with variables to each document so this is automatically taken care of.

<s>Rather than `Ctrl` write `Control`, because that's what it says on the key cap.</s>
I changed my mind, `Ctrl` is much more common than 'control'.

NB. with

```
&#8594; &rarr;  →      Right arrow
&#8592; &larr;  ←      Left arrow
&#8593; &uarr;  ↑      Up arrow
&#8595; &darr;  ↓      Down arrow
```

it's possible to create `kbd:[&larr;]` arrow keys. However, ePub doesn't support the second column definitions, PDF doesn't support the Unicode definitions for the up and down arrows. So I've decided to skip them entirely and just use the words 'up', 'down' etc.
