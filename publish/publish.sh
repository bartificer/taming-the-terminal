#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Building the books"

book_dir="${DIR}/../book"
output_dir="${DIR}/../output"

version_string=${TRAVIS_TAG} || $(git describe --tags | cut -d- -f-2)
if [[ ${version_string} == '' ]] ; then
    version_string='1.0'
fi

date_string=$(date +"%Y-%m-%d")
compile_time=$(date +"%Y-%m-%d %k-%M-%S")

params="-a revnumber='${version_string}'   \
        -a revdate='${date_string}'        \
        -a compile_time='${compile_time}'  \
        --destination-dir='output'         \
        "

echo ${params}

echo "Generating contributors list"

git shortlog -es | sort | cut -f 2- | awk '{print $0,"\n"}' > ${book_dir}/contributors.txt

echo "Converting to HTML..."
bundle exec asciidoctor "${params}" ${book_dir}/ttt-spine.adoc --out-file=ttt.html
echo " -- HTML output at ${output_dir}/ttt.html"

echo "Sync the assets"
rsync -r --delete ${book_dir}/assets/* ${output_dir}/assets/

echo "Converting to EPub..."
bundle exec asciidoctor-epub3 "${params}" -a pygments-style=manni ${book_dir}/ttt-epub-spine.adoc --out-file=ttt.epub
echo " -- Epub output at ${output_dir}/ttt.epub"

#   echo "Converting to Mobi (kf8)..."
#   bundle exec asciidoctor-epub3 "${params}" -a ebook-format=kf8 ${book_dir}/ttt-spine.adoc`
#   echo " -- Mobi output at ${output_dir}/ttt.mobi"

echo "Converting to PDF... (this one takes a while)"
bundle exec asciidoctor-pdf "${params}" ${book_dir}/ttt-spine.adoc --out-file=ttt.pdf 2>/dev/null
echo " -- PDF output at ${output_dir}/ttt.pdf"


# asciidoctor-epub3 \
# --out-file ttt.epub \
# --destination-dir output \
# --base-dir ${BOOKDIR} \
# --verbose \
# --trace \
# ${BOOKDIR}/ttt-spine.adoc

# echo
# echo
# echo HTML conversion
# echo
# echo

# asciidoctor \
# --destination-dir output \
# --base-dir ${BOOKDIR} \
# --verbose \
# --trace \
# ${BOOKDIR}/ttt-spine.adoc
