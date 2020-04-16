#!/bin/bash

asciidoctor-epub3 \
--out-file ttt.epub \
--destination-dir output \
--base-dir ../book \
--verbose \
--trace \
../book/ttt-spine.adoc
