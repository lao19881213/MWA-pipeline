#!/bin/bash

# Calibrates an observation using Andre's calibrate tool

# Edit / add to these options for your supercomputer

source $MWABASH/bashrc_append
export OMP_NUM_THREADS=20
    
scheduler="slurm"
ncpus=20

rootdir=/scratch2/mwasci
datadir=$rootdir/blao/data
#codedir=$rootdir/code
queuedir=$MWABASH/queue

# Andre provides models for various calibrators
modeldir=$MWA_CODE_BASE/anoko/mwa-reduce/models

if [[ $1 ]] && [[ $2 ]] && [[ $3 ]]
then
    obsnum=$1
    proj=$2
    calibrator=$3
    if [[ $calibrator == "hyda" ]]
    then
        calmodel=model-hyda-21comp.txt
    elif [[ $calibrator == "hera" ]]
    then
        calmodel=model-hera-14comp.txt
    elif [[ $calibrator == "3c444" ]]
    then
        calmodel=model-3C444-10comp.txt
    elif [[ $calibrator == "pica" ]]
    then
        calmodel=model-pica-35comp.txt
    else
        calmodel=model-$calibrator-point-source.txt
    fi
    if [[ ! -e $modeldir/$calmodel ]]
    then
        echo "No calibrator model available for $calibrator in $modeldir."
        cd $modeldir
        callist=`ls *-point-source.txt | sed "s/model-//g" | sed "s/-point-source.txt//g"`
        echo "Available calibrators are: $callist"
        exit 1
    fi

    if [[ ! -d $datadir/${proj} ]]
    then
        mkdir $datadir/${proj}
    fi
    cd $queuedir
    if [[ -d $datadir/${proj}/${obsnum}/${obsnum}.ms ]]
    then
        cat cal_body.template | sed "s;OBSNUM;${obsnum};g" | sed "s;PROJ;${proj};g" | sed "s;DATADIR;${datadir};g" | sed "s;MODELDIR;${modeldir};g" | sed "s;CALMODEL;${calmodel};g" | sed "s;NCPUS;${ncpus};"  > cal_${obsnum}.sh
    else
        echo "$datadir/${proj}/${obsnum}/${obsnum}.ms doesn't exist!"
    fi
    bash cal_${obsnum}.sh
else
    echo "Give me an observation number, a project ID, and the name of your calibrator, e.g. calibrate.sh 1012345678 G0001 hyda ."
    exit 1
fi

exit 0
