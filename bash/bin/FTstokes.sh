#!/bin/bash

# Self-calibrates an observation using Andre's WSClean and calibrate tool

# Edit / add to these options for your supercomputer
source $MWABASH/bashrc_append

scheduler="slurm"
ncpus=20

rootdir=/scratch2/mwasci
datadir=$rootdir/blao/data
#codedir=$rootdir/code
queuedir=$MWABASH/queue

if [[ $1 ]] && [[ $2 ]]
then
    obsnum=$1
    proj=$2

    if [[ ! -d $datadir/${proj} ]]
    then
        mkdir $datadir/${proj}
    fi
    cd $queuedir
    if [[ -d $datadir/${proj}/${obsnum}/${obsnum}.ms ]]
    then
        cat FTstokes_body.template | sed "s;OBSNUM;${obsnum};g" | sed "s;PROJ;${proj};g" | sed "s;DATADIR;${datadir};g" | sed "s;NCPUS;${ncpus};" > FTstokes_${obsnum}.sh
    else
        echo "$datadir/${proj}/${obsnum}/${obsnum}.ms doesn't exist!"
    fi
    bash FTstokes_${obsnum}.sh
else
    echo "Give me an observation number and a project ID, e.g. selfcal.sh 1012345678 G0001"
    echo "Remember, this observation needs to have at least reasonable first-pass calibration before self-cal can be used."
    exit 1
fi

exit 0
