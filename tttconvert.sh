#!/bin/bash

# convert all TTT HTML files to Markdown
# so we can get the entire set of shownotes together on GitHub
#
# This script assumes:
# - the webpages are downloaded with Safari (defines the naming convention)
# - the webpages are saved as 'Page Source'
#
# The latter preserves the external links
#
# This script generates:
# - a Markdown file for each HTML file in $SOURCEDIR
# - a TAP result file so it is obvious which files are converted and whether this was successfull
# - and index file that can be added to index.md

SOURCEDIR=../sourcefiles
OUTPUTDIR=../convert2
TAPFILE='tttconvert.tap'
INDEXFILE='tttconvert.index'
counter=0


# -------------------
# tapResult
#
# show ok or not ok based on parameter
# -------------------

function tapResult () {
    local RESULT=$1
    local TAPNR=$2
    local MSG=$3

    if [ "$RESULT" == "0" ]; then
        echo "ok $TAPNR - $MSG"
    else
        echo "not ok $TAPNR - $MSG"
    fi
}


# -------------------
# processAndTest
#
# process a file and write a tap result for the conversion
# -------------------

function processAndTest() {
    local INFILE="$1"
    local OUTFILE="$2"

    node index.js "${INFILE}" --output ${OUTPUTDIR}/${OUTFILE}

    local RESULT=`echo $?`
    counter=$[counter+1]
    tapResult $RESULT $counter "${OUTFILE}" >> "${TAPFILE}"
}


# -------------------
# generateIndex
#
# process the filename to an index that can be added to index.md
# -------------------
function generateIndex() {
    local INFILE="$1"
    local OUTFILE="$2"

    local NAME=$(echo "${INFILE}" | cut -d'/' -f 3 | cut -d':' -f 1)

    echo "[${NAME}](${OUTFILE})" >> "${INDEXFILE}"
}


# -------------------
# Download the zip files
# -------------------
function downloadZips() {
    mkdir  -p ${SOURCEDIR}/zip
    cd ${SOURCEDIR}/zip
    for f in $(grep 'ttt.*\.zip' ../*.html | cut -d'=' -f2 | cut -d'"' -f 2 | grep 'wp-content')
    do
        curl $f -O
    done

    cd -
}

# ===================
# Main program starts here

# downloadZips

# start the tapfile with the plan
tapplan=$(ls -l ${SOURCEDIR}/*.html | wc -l)
echo 0..${tapplan} > ${TAPFILE}

# start with an empty indexfile

echo -n > $INDEXFILE

for f in ${SOURCEDIR}/*.html
do
    TTTNO=$(echo $f | cut -d' ' -f 2)
    TTTMD=ttt${TTTNO}.md
    processAndTest "${f}" ${TTTMD}

    generateIndex  "${f}" ${TTTMD}
done
