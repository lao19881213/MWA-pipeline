#!/bin/bash 

# Cotter the data


aprun="mpirun -np -1 "
cd /home/lbq/lbq/mwasci/mwa_data/G0008/1146606064
make_metafits.py -g 1146606064
if [[ -e 1146606064_flags.zip ]]
then
    unzip 1146606064_flags.zip
    flagfiles="-flagfiles 1146606064_%%.mwaf"
fi
$aprun cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1146606064.metafits -o 1146606064.ms
if [[ -d 1146606064.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
