#!/bin/bash 

# Calibrate the data



aprun="mpirun -np 1 "

datadir=/home/lbq/lbq/mwasci/mwa_data
proj=G0008
obsnum=1115292048
calmodel=model-PKS2356-61-point-source.txt
modeldir=/home/lbq/lbq/mwasci/mwa-reduce/models
ncpus=20
calnotxt=`echo $calmodel | sed "s/.txt//"`

cd /home/lbq/lbq/mwasci/mwa_data/G0008/1115292048
# Hack to work around broken PYTHONPATH lookup
if [[ ! -d mwapy ]]
then
    mkdir mwapy
    mkdir mwapy/pb
    cd mwapy/pb
    for beammatrix in /home/lbq/lbq/mwasci/mwasoft/mwapy/pb/*atrix.fits
    do
        ln -s $beammatrix
    done
    cd ../../
fi

# Only run if the solutions don't already exist, and are not zero-size
if [[ ! -s ${obsnum}_${calnotxt}_solutions.bin ]]
then
    $aprun /home/lbq/lbq/mwasci/mwapipeline/bin/calibrate -j ${ncpus} -m ${calmodel} -minuv 20 -applybeam ${obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin
fi

# Apply the solutions (uncomment the line below when asked to)
#$aprun applysolutions ${obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin

# Really fast clean (uncomment the line below when asked to)
#$aprun wsclean -name ${obsnum}_shallow -size 1000 1000 -niter 4000 -threshold 0.01 -pol xx -smallinversion -j ${ncpus} -stopnegative ${obsnum}.ms

rm -rf mwapy

