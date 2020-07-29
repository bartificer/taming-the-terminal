#!/bin/bash

# grep the urls from the files
grep blubrry convert2/*.md | cut -d= -f2 | grep -v 'data-external' | grep -v 'src' | cut -d'?' -f1 | cut -d'"' -f2 | sort |uniq
