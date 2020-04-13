#!/bin/bash
NR=$1
node index.js ../sourcefiles/TTT\ Part\ ${NR}\ of*.html --output ../convert2/ttt${NR}.md
