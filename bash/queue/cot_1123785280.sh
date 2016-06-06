#!/bin/bash

cd /scratch2/mwasci/blao/data/G0008/1123785280
make_metafits.py -g 1123785280
if [[ -e 1123785280_flags.zip ]]
then
    unzip 1123785280_flags.zip
    flagfiles="-flagfiles 1123785280_%%.mwaf"
fi
cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1123785280.metafits -o 1123785280.ms
if [[ -d 1123785280.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
