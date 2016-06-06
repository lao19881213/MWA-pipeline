#!/bin/bash -l

# Calibrate the data

#SBATCH --account=courses02
#SBATCH --reservation=courseq
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --mem=64gb
#SBATCH --output=/home/cou049/queue/cal_1123785280.o%j
#SBATCH --error=/home/cou049/queue/cal_1123785280.e%j
#SBATCH --export=NONE

aprun="aprun -n 1 -d 20 -q "

datadir=/scratch2/courses02/cou049
proj=G0008
obsnum=1123785280
calmodel=model-3c444-10comp.txt
modeldir=/group/mwasci/code/anoko/mwa-reduce/models
ncpus=20
tgt_obsnum=1123793080
calnotxt=`echo $calmodel | sed "s/.txt//"`

cd /scratch2/courses02/cou049/G0008/1123785280
# Hack to work around broken PYTHONPATH lookup
if [[ ! -d mwapy ]]
then
    mkdir mwapy
    mkdir mwapy/pb
    cd mwapy/pb
    for beammatrix in $MWA_CODE_BASE/MWA_Tools/mwapy/pb/*atrix.fits
    do
        ln -s $beammatrix
    done
    cd ../../
fi

# Only run if the solutions don't already exist, and are not zero-size
if [[ ! -s ${obsnum}_${calnotxt}_solutions.bin ]]
then
    $aprun calibrate -j ${ncpus} -m ${modeldir}/${calmodel} -minuv 20 -applybeam ${obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin
fi

# Apply the solutions (uncomment the line below when asked to)
$aprun applysolutions ../${tgt_obsnum}/${tgt_obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin

# Really fast clean (uncomment the line below when asked to)
cd ../${tgt_obsnum}
$aprun wsclean -name ${tgt_obsnum}_shallow -size 1000 1000 -niter 4000 -threshold 0.01 -pol xx -smallinversion -j ${ncpus} -stopnegative ${tgt_obsnum}.ms

rm -rf mwapy

