# Additional information

This document contains additional information that might be of interest to a few people but does not contain any information about the tutorial itself or how to compile it.

## Why asciidoctor?

The request was to build an ePub out of the episodes. That meant these requirements:

- keep the code blocks with source code highlighting
- keep the definition lists
- create a single ePub of all the separate chapters
- add a Table of Contents

At first the original HTML pages were converted to Github Flavor Markdown, basically with a slightly modified version of pbsconvert. The initial conversion from Markdown to an ePub was done with pandoc and pygments as source code highlighter.
From experience I know that Markdown doesn't support definition lists, and Bart explicitly mentioned once that he likes definition lists so it would be a shame to convert them all to a table markup which I did initially.
In hindsight, 3 weeks later, I found out I didn't look hard enough at Pandoc's documentation, it DOES support it.

Pygments, the source code highlighter does have support for Bash or shell scripts, but somehow most builtins are not color coded. Because the earlier episodes mostly use builtins, that would mean there is no color coding at all.
I came across an extension that added these builtins to Pygments, but I wasn't able to convert them to the language and plugin syntax Pandoc could understand.

In my search for a solution I came across the [Progit](https://github.com/progit/progit) eBook repository. They referred to their second version [Progit 2](https://github.com/progit/progit2) which mentioned that they switched to Asciidoc. Curious, I googled some more and came across the [Asciidoctor](https://asciidoctor.org) website.
It solved many of my problems:

- definition lists
- support for various source code highlighters, including Pygments, which also support shell scripts
- and the Progit 2 project had a script file that could generate and ePub as well as a PDF and single page HTML.

I converted an episode by hand, Markdown and Asciidoctor have very similar syntax, and ran it through the build script. Lo and behold there was nice color coding. And the switch to Rouge, another syntax highlighter was even easier and provided also color coding for the builtins.

The decision was made, TTT would be in Asciidoctor.

## Links

This section contains additional links that might be relevant to the publications:

- https://itunespartner.apple.com/books/articles/create-book-cover-art-2712
- https://help.apple.com/itc/booksassetguide/#/itc04314e64a
- https://blog.kotobee.com/publishing-amazon-ibookstore-10-things-watch/
- https://www.w3.org/publishing/epub32/epub-packages.html#elemdef-opf-package
- https://w3c.github.io/publ-epub-revision/epub32/spec/epub-packages.html#attrdef-item-fallback
- https://github.com/krisztianmukli/epub-boilerplate/blob/master/publish-ebook
- https://matthewsetter.com/writing-tools/npm-broken-link-checker/
