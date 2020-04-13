#!/bin/bash

# Create an ePub from the Markdown files

CURRENTDIR=$(pwd)
SOURCEDIR=../../convert2

cp metadata.txt ${SOURCEDIR}
cp pandoc.css ${SOURCEDIR}

cd ${SOURCEDIR}
pandoc --defaults ${CURRENTDIR}/pandoc.defaults
cd -

if [ -f ${SOURCEDIR}/ttt.epub ] ; then
    echo The ePub can be found here: ${SOURCEDIR}/ttt.epub
fi
