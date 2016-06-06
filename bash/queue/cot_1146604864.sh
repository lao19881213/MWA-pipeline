#!/bin/bash 

# Cotter the data


aprun="mpirun -np 1 "
cd /scratch/blao/mwasci/mwa_data/G0008/1146604864
python $LIBPATH/mwapipeline/bin/make_metafits.py -g 1146604864
if [[ -e 1146604864_flags.zip ]]
then
    unzip 1146604864_flags.zip
    flagfiles="-flagfiles 1146604864_%%.mwaf"
fi
$aprun $LIBPATH/mwapipeline/bin/cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1146604864.metafits -o 1146604864.ms
if [[ -d 1146604864.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
