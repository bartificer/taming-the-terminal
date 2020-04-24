#!/bin/bash

_qrcode='../node_modules/qrcode/bin/qrcode'

cat  ../publish/mp3_files | while read file
do
    BN=`basename ${file}`
    PNG=`echo ${BN} | cut -d_ -f1-2`.png

    # coloring the QRcode to have the same color as the red in the monospace in the PDF

    ${_qrcode} -o ../book/assets/qrcodes/${PNG} -t png -w 150 -d 9F0E36  ${file} < /dev/null
done
