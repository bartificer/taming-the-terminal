#!/bin/bash
#
# Due to a bug in the asciidoctor-epub3 generator, the
# references to the podcasts are not added to the package.opf file
#
# let's fix that here

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf "${DIR}/../output/ttt"
mkdir -p "${DIR}/../output/ttt"
cd "${DIR}/../output/ttt"

unzip ../ttt.epub
cp ../ttt.epub ttt-fixed.epub

sed -i.BAK '/<\/manifest>/{
    r '${DIR}/../publish/external_resources.xml'
    a\
    <\/manifest>
    d
}' EPUB/package.opf

rm -rf */package.opf.BAK
zip -r ttt-fixed.epub EPUB/package.opf
mv ttt-fixed.epub ../ttt.epub
cd - > /dev/null
rm -rf "${DIR}/../output/ttt"
