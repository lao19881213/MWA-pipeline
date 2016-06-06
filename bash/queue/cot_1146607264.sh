#!/bin/bash 

# Cotter the data


aprun="mpirun -np 1 "
cd /home/lbq/lbq/mwasci/mwa_data/G0008/1146607264
python /home/lbq/lbq/mwasci/mwapipeline/bin/make_metafits.py -g 1146607264
if [[ -e 1146607264_flags.zip ]]
then
    unzip 1146607264_flags.zip
    flagfiles="-flagfiles 1146607264_%%.mwaf"
fi
$aprun /home/lbq/lbq/mwasci/mwapipeline/bin/cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1146607264.metafits -o 1146607264.ms
if [[ -d 1146607264.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
