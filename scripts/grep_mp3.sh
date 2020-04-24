#!/bin/bash

# grep the urls from the files
grep media.blubrry book/*.adoc | cut -d: -f2- | cut -d= -f3- | grep -v 'controls' | cut -d+ -f1 | cut -d\" -f2 | grep -v 'url-mp3'
