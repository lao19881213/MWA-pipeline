datadir=DATADIR
proj=PROJ
obsnum=OBSNUM
calmodel=CALMODEL
modeldir=MODELDIR
ncpus=NCPUS
tgt_obsnum=TARGET
calnotxt=`echo $calmodel | sed "s/.txt//"`

cd DATADIR/PROJ/OBSNUM
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

