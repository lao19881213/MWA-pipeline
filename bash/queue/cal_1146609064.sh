datadir=/scratch2/mwasci/blao/data
proj=G0008
obsnum=1146609064
calmodel=model-3C444-10comp.txt
modeldir=/group/mwasci/code/anoko/mwa-reduce/models
ncpus=20
calnotxt=`echo $calmodel | sed "s/.txt//"`

cd /scratch2/mwasci/blao/data/G0008/1146609064
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
    calibrate -j ${ncpus} -m ${modeldir}/${calmodel} -minuv 20 -applybeam ${obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin
fi

# Apply the solutions (uncomment the line below when asked to)
# applysolutions ${obsnum}.ms ${obsnum}_${calnotxt}_solutions.bin

# Really fast clean (uncomment the line below when asked to)
#wsclean -name ${obsnum}_shallow -size 1000 1000 -niter 4000 -threshold 0.01 -pol xx -smallinversion -j ${ncpus} -stopnegative ${obsnum}.ms

rm -rf mwapy

