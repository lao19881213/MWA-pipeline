#!/bin/bash 

# Cotter the data


aprun="mpirun -np 1 "
cd /scratch/blao/mwasci/mwa_data/G0008/1123785280
python $LIBPATH/mwapipeline/bin/make_metafits.py -g 1123785280
if [[ -e 1123785280_flags.zip ]]
then
    unzip 1123785280_flags.zip
    flagfiles="-flagfiles 1123785280_%%.mwaf"
fi
$aprun $LIBPATH/mwapipeline/bin/cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1123785280.metafits -o 1123785280.ms
if [[ -d 1123785280.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
