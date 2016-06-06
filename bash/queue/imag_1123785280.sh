#!/bin/bash 

# Calibrate the data and imaging



aprun="mpirun -np 1 "

datadir=/scratch/blao/mwasci/mwa_data
proj=G0008
obsnum=1123785280
calmodel=model-3C444-10comp.txt
modeldir=/scratch/blao/mwasci/mwa-reduce/models
ncpus=20
tgt_obsnum=1123785280
calnotxt=`echo $calmodel | sed "s/.txt//"`

cd /scratch/blao/mwasci/mwa_data/G0008/1123785280
# Hack to work around broken PYTHONPATH lookup
if [[ ! -d mwapy ]]
then
    mkdir mwapy
    mkdir mwapy/pb
    cd mwapy/pb
    for beammatrix in ${MWASCI}/mwapy/pb/*atrix.fits
    do
        ln -s $beammatrix
    done
    cd ../../
fi

# Only run if the solutions don't already exist, and are not zero-size
if [[ ! -s ${obsnum}_${calnotxt}_solutions.bin ]]
then
    $aprun ${LIBPATH}/mwapipeline/bin/calibrate -j ${ncpus} -m ${calmodel} -minuv 20 -applybeam ${obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin
fi

# Apply the solutions (uncomment the line below when asked to)
$aprun ${LIBPATH}/mwapipeline/bin/applysolutions ../${tgt_obsnum}/${tgt_obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin

cd ../${tgt_obsnum}
# Really fast clean (uncomment the line below when asked to)
$aprun ${LIBPATH}/mwapipeline/bin/wsclean -name ${tgt_obsnum}_shallow -size 1000 1000 -niter 4000 -threshold 0.01 -pol xx -smallinversion -j ${ncpus} -stopnegative ${tgt_obsnum}.ms

rm -rf mwapy

