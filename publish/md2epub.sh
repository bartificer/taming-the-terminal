#!/bin/bash

# Create an ePub from the Markdown files

cd ../convert2
pandoc --defaults ../tttconvert/pandoc.defaults
cd -
