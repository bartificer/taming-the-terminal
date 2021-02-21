#!/bin/bash
# where is this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# echo ${DIR}

# set the path to the qrcode app
_qrcode="${DIR}/../node_modules/qrcode/bin/qrcode"

# color red of the red in the monospace in the PDF
color_red='9F0E36'

# color blue of Bart's Jekyll theme (navbar background)
color_blue='00408d'

# get every line from the list of urls in mp3_files
cat  "${DIR}/../publish/mp3_files" | while read file
do
    BN=`basename ${file}`
    PNG=`echo ${BN} | cut -d_ -f1-2`.png

    # coloring the QRcode to have the same color as Bart's theme

    ${_qrcode} -o "${DIR}/../book/assets/qrcodes/${PNG}" -t png -w 150 -d ${color_blue}  ${file} < /dev/null
done
