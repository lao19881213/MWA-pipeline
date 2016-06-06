#!/bin/bash 

# Cotter the data


aprun="mpirun -np -1 "
cd /home/lbq/lbq/mwasci/mwa_data/G0008/1146605464
make_metafits.py -g 1146605464
if [[ -e 1146605464_flags.zip ]]
then
    unzip 1146605464_flags.zip
    flagfiles="-flagfiles 1146605464_%%.mwaf"
fi
$aprun cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1146605464.metafits -o 1146605464.ms
if [[ -d 1146605464.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
