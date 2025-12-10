# Troubleshooting Guide for Taming the Terminal Builds

This file catalogs common Asciidoctor, EPUB, PDF, and Docker issues.

## 1. Asciidoctor Errors

### Missing anchors

Example:

```shell
invalid reference to unknown anchor
```

Fix:

- Ensure the episode file defines, usually at the top of the file:

```asciidoc
[[ttt38]]
```

- Use:

```asciidoc
xref:ttt38[Episode 38]
```

instead of `<<...>>`.

## 2. EPUB Errors

### RSC‑012 Missing fragment identifier

Occurs when a cross-reference points to a missing `[[anchor]]`.

Fix:

- Verify anchors exist.
- Ensure order of includes is correct.

## 3. PDF Issues

### Font not found

Ensure:

```asciidoc
pdf-fontsdir: "book/theme/fonts,GEM_FONTS_DIR"
```

## 4. Docker Problems

### node_modules appears on host

You forgot this volume:

```docker
- node_modules_cache:/workspace/node_modules
```

### Permission issues

Restart Docker Desktop.

## 5. Debugging

Enter shell with:

```shell
make shell
```

Then test commands manually.

## 7. Asciidoc bug fixes and workarounds

This section contains some notes on bug fixes and workarounds that have been applied to get it working.

### Fake second paragraph

See: [Asciidoctor git repository](https://github.com/asciidoctor/asciidoctor/issues/2860)
Worked around by adding a second paragraph either by separating the last (few) sentence(s) or by adding an invisible second paragraph consisting of a single space.

```asciidoc
+++&nbsp;+++
```

Books doesn't like this, so I had to surround it with `ifdef`s:

```asciidoc
ifndef::backend-epub3[]
+++&nbsp;+++
endif::[]
```

**Update 2020-05-01**: Since the audio section was converted to a sidebar, that counts as a second paragraph, so all the fake second paragraphs are deleted.

### Backticks problems

Somehow there is a bug in `asciidoctor` that causes backticks to be passed through rather than marking the conversion to `monospace`.

### Color coding in ePub

`Rouge` is used as source code highlighter in PDF and HTML, but it doesn't work in ePub. Only `Pygments` is supported in ePub, but this has no good support for shell scripts. Somehow the color coding in Books actually looks to be just black & white.

**UPDATE**: it looks like the attribute for the styling in the spine is not honored. It should be added as an attribute on the command line like

```
-a pygments-style=manni
```

Source: [Prepare an asciidoc document](https://asciidoctor.org/docs/asciidoctor-epub3/#prepare-an-asciidoc-document)

**UPDATE 2020-07-16**: Looks like Rouge _is_ supported now in ePub, _AND_ it gives better colour coding, so all ePub is now also switched to Rouge.

### Highlights in source code

It is not possible to highlight specific parts of the source code, so all references to e.g. `<strong>` must be removed from the snippet or it will show up verbatim in the output file.

**UPDATE 2020-07-16**: highlighting is supported by adding an attribute to the codeblock indicating the lines to be highlighted and by adding appropriate CSS to the various themes. All code blocks that have highlighting in the original html are now marked for highlighting in the Asciidoctor files as well.

### Line numbering in source code

Although Rouge supports line numbering in source code blocks, the implementation in Asciidoctor is very simple. The code is placed in 2 table cells, one with the line numbers, one with the code. It doesn't take into account the extra space needed when long code lines wrap to the next line.
After numerous attempts to fix the problem I got stuck because my code adjustments in the Asciidoctor code broke the functionality to add annotations in the code and I haven't found a way to preserve that functionality.
I therefore decided to skip the line numbering in code blocks that have long lines of mostly output. The highlighting does work, therefore it's still possible to point out the important lines.

**UPDATE 2020-07-29**: line numbering is removed altogether for the ePub version, because the epubcheck throws errors.

### Keyboard shortcuts

Asciidoctor supports the HTML5 keyboard shortcuts, so change any reference to keyboard shortcuts to the HTML5 keyboard counterparts.
Note, the command key (CMD) can be used as `{commandkey}`.
I added a document with variables to each document so this is automatically taken care of.

`Ctrl` is used for the 'Control' key, because it's much more commonly used than 'control'.

NB. with the codes in the following table it's possible to create `kbd:[&larr;]` arrow keys.

| Unicode   | HTML entity | Symbol | Name        |
| --------- | ----------- | ------ | ----------- |
| `&#8594;` | `&rarr;`    | →      | Right arrow |
| `&#8592;` | `&larr;`    | ←      | Left arrow  |
| `&#8593;` | `&uarr;`    | ↑      | Up arrow    |
| `&#8595;` | `&darr;`    | ↓      | Down arrow  |

However, ePub doesn't support the HTML entities definitions, PDF doesn't support the Unicode definitions for the up and down arrows. So I've decided to skip them entirely and just use the words 'up', 'down' etc.
