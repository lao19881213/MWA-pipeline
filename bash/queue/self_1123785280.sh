#!/bin/bash -l

# Calibrate the data

#SBATCH --account=mwasci
##SBATCH --reservation=workq
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --mem=64gb
#SBATCH --output=/home/blao/course/queue/self_1123785280.o%j
#SBATCH --error=/home/blao/course/queue/self_1123785280.e%j
#SBATCH --export=NONE

source /home/blao/course/bashrc_append
source /home/blao/course/profile_append

aprun="aprun -n 1 -d 20 -q "

datadir=/scratch2/mwasci/blao/data
proj=G0008
obsnum=1123785280
ncpus=20
# you could modify the submission script and template to change these more dynamically:
imsize=4000
scale=0.008

cd $datadir/$proj/$obsnum/

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

# Initial clean to first negative
$aprun wsclean -name ${obsnum}_initial -size ${imsize} ${imsize} -scale ${scale} -niter 4000 -threshold 0.01 -pol xx,yy,xy,yx -weight briggs -1.0 -stopnegative -smallinversion -joinpolarizations -j ${ncpus} ${obsnum}.ms

# Generate correct primary beam for this observation
$aprun beam -2014 -proto ${obsnum}_initial-XX-model.fits -ms ${obsnum}.ms -name beam

# Make a primary-beam corrected model, for use now in self-calibrating
$aprun pbcorrect ${obsnum}_initial model.fits beam ${obsnum}_initcor

# Set Q, U, V to zero
if [[ ! -d unused ]]
then
    mkdir unused
fi
mv ${obsnum}_initcor-Q.fits unused/
mv ${obsnum}_initcor-U.fits unused/
mv ${obsnum}_initcor-V.fits unused/

# "Uncorrect" the beam
$aprun pbcorrect -uncorrect ${obsnum}_initunc model.fits beam ${obsnum}_initcor

# FT the Stokes I model into the visibilities
$aprun wsclean -predict -name ${obsnum}_initunc -size ${imsize} ${imsize} -pol xx,yy,xy,yx -weight briggs -1.0 -scale ${scale} -smallinversion -j ${ncpus} ${obsnum}.ms

# Calibrate: by default, it will use the MODEL column, which now has the FT'd self-cal model
$aprun calibrate -j ${ncpus} -minuv 60 -applybeam ${obsnum}.ms ${obsnum}_self_solutions.bin
 
# Apply the calibration solutions
$aprun applysolutions ${obsnum}.ms ${obsnum}_self_solutions.bin

# Run a really deep clean (no threshold; this isn't actually recommended!)
$aprun wsclean -name ${obsnum}_deep -size ${imsize} ${imsize} -niter 50000 -pol XX,YY,XY,YX -weight briggs -1.0 -scale ${scale} -smallinversion -joinpolarizations -j ${ncpus} -mgain 0.85 -fitbeam ${obsnum}.ms

# Generate real Stokes images
$aprun pbcorrect ${obsnum}_deep image.fits beam ${obsnum}_deep

# Tidy up
rm -rf mwapy
