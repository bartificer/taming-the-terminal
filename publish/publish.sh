#!/bin/bash

BOOKDIR=../book

asciidoctor-epub3 \
--out-file ttt.epub \
--destination-dir output \
--base-dir ${BOOKDIR} \
--verbose \
--trace \
${BOOKDIR}/ttt-spine.adoc

echo
echo
echo HTML conversion
echo
echo

asciidoctor \
--destination-dir output \
--base-dir ${BOOKDIR} \
--verbose \
--trace \
${BOOKDIR}/ttt-spine.adoc
