#!/bin/bash -l

# Cotter the data


aprun="aprun -n 1 -d 20 -q "
#!/bin/bash

cd /scratch2/mwasci/blao/data/G0008/1146607264
make_metafits.py -g 1146607264
if [[ -e 1146607264_flags.zip ]]
then
    unzip 1146607264_flags.zip
    flagfiles="-flagfiles 1146607264_%%.mwaf"
fi
cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1146607264.metafits -o 1146607264.ms
if [[ -d 1146607264.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
