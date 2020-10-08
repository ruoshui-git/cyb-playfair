#!/bin/sh

make run ARGS="encode Dragonball ABCDEFGHIKLMNOPQRSTUVWXYZ"
echo BTBFTSGFNVPV 
make run ARGS="decode BTBFTSGFNVPV ABCDEFGHIKLMNOPQRSTUVWXYZ"
echo DRAGONBALXLZ 
make run ARGS="encode WHITEHAT PLAYFIREXMBCDGHKNOQSTUVWZ"
echo ZGRUMDPV
make run ARGS="decode ZGRUMDPV PLAYFIREXMBCDGHKNOQSTUVWZ"
echo WHITEHAT
make run ARGS="encode AGOODFOODBOOKISACOOKBOOK PLAYFIREXMBCDGHKNOQSTUVWZ"
echo YDQEQGASQGDKVTMKLDQEVTDKVT
make run ARGS="decode YDQEQGASQGDKVTMKLDQEVTDKVT PLAYFIREXMBCDGHKNOQSTUVWZ"
echo AGOXODFOODBOOKISACOXOKBOOK
make run ARGS="encode TODAYISAGOODDAYTODIE OZAKDIREXMBCVGHYNPQSTUFWL"
echo UZMENRPDBKIMMENUIMBV
make run ARGS="decode UZMENRPDBKIMMENUIMBV OZAKDIREXMBCVGHYNPQSTUFWL"
echo TODAYISAGOODDAYTODIE