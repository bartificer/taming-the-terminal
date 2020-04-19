# Creating the TTT publications

## How it works

Once you've set up all the necessary tools, you can simply build all three versions using the command

`bundle exec rake book:build`

To get there you need:
* Ruby as a separate install (because you don't want to mess up your System folder)
* various gems
* bundler
* rake
* asciidoctor
* asciidoctor-epub3
* asciidoctor-pdf
* clone the GitHub repository

## Prepare your environment

### Install Ruby on macOS

Ruby is default part of macOS but every 'gem install <some package>' will lead to an attempt to update the system framework. Not a good idea.

Follow the instructions at: https://gorails.com/setup/osx/10.15-catalina

just the part 'Installing Ruby'

### Clone the git repository

Clone the repository 

```
git clone https://github.com/hepabolu/ttt.git
```

### Install necessary Ruby gems

switch to the root directory of the git repo you just cloned and run

```
gem install
```

This installs all Ruby gems in Gemfile

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
* `colophon.adoc` holds some boilerplate text. It needs to be update to proper information
* `index.asc` is empty, it's just there because the spine docs refer to it. Not sure if we need to fill it.


## Bugfixes and workaround

This section contains some notes on bugfixes and workarounds that have been applied to get it working

### Fake second paragraph

https://github.com/asciidoctor/asciidoctor/issues/2860
Worked around by adding a secord paragraph either by separating the last (few) sentence(s) or by adding an invisible second paragraph consisting of a single space.

```
+++&nbsp;+++
```

Books doesn't like this, so I had to surround it with ifdefs:

```
ifndef::backend-epub3[]
+++&nbsp;+++
endif::[]
```

### Backticks problems

Somehow there is a bug in `asciidoctor` that causes backticks to be passed through rather than marking the conversion to monospace.

### Color coding in ePub

Rouge is used as source code highlighter in PDF and HTML, but it doesn't work in ePub. Only Pygments is supported in ePub, but this has no good support for shell scripts. Somehow the color coding in Books actually looks to be just black & white.

**UPDATE**: it looks like the attribute for the styling in the spine is not honored. It should be added as an attribute on the commandline like

```
-a pygments-style=manni
```

src: https://asciidoctor.org/docs/asciidoctor-epub3/#prepare-an-asciidoc-document


### Highlights in source code

It is not possible to highlight specific parts of the source code, so all references to e.g. <strong> must be removed from the snippet or it will show up verbatim in the output file.

### Keyboard shortcuts

Asciidoctor supports the HTML5 keyboard shortcuts, so change any reference to keyboard shortcuts to the HTML5 keyboard counterparts. 
Note, the commandkey (CMD) can be used as `{commandkey}`.
For the shortcuts to show up properly in the VScode previewer, eacht document needs an `:experimental:` option in the header.

Rather than `Ctrl` write `Control`, because that's what it says on the key cap.
