#!/bin/bash

# Calibrates an observation using Andre's calibrate tool

# Edit / add to these options for your supercomputer
if [[ "${HOST:0:4}" == "gala" ]]
then
    computer="galaxy"
    group="courses02" # Would normally be mwasci; courses02 is reserved for MWA data reduction workshop 23-24/02/16
    standardq="courseq" # Would normally be workq; courseq is reserved for MWA data reduction workshop 23-24/02/16
    hostmem="64" #GB
    qsub="sbatch"
    copyqsub="sbatch -M zeus"
    copyq="copyq"
    scheduler="slurm"
    ncpus=20
    scratch=/scratch2
else
    computer="epic"
    group="astronomy818"
    standardq="routequeue"
    hostmem="20gb"
    scheduler="pbs"
    scratch=/scratch
fi

rootdir=$scratch/$group
datadir=$rootdir/$USER
codedir=$rootdir/code
queuedir=$HOME/queue

# Andre provides models for various calibrators
modeldir=$MWA_CODE_BASE/anoko/mwa-reduce/models

if [[ $1 ]] && [[ $2 ]] && [[ $3 ]] && [[ $4 ]]
then
    obsnum=$1
    proj=$2
    calibrator=$3
    target=$4
    if [[ $calibrator == "hyda" ]]
    then
        calmodel=model-hyda-21comp.txt
    elif [[ $calibrator == "hera" ]]
    then
        calmodel=model-hera-14comp.txt
    elif [[ $calibrator == "3c444" ]]
    then
        calmodel=model-3c444-10comp.txt
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
        cat cal_${scheduler}.template  | sed "s;PROJ;${proj};g" | sed "s;HOSTMEM;${hostmem};g" | sed "s;GROUP;${group};g"  | sed "s;STANDARDQ;${standardq};g" | sed "s;DATADIR;$datadir;g" | sed "s;OUTPUT;cal_${obsnum};" | sed "s;QUEUEDIR;${queuedir};" | sed "s;NCPUS;${ncpus};" > cal_${target}.sh
        cat cal_body.template.sh | sed "s;OBSNUM;${obsnum};g" | sed "s;PROJ;${proj};g" | sed "s;DATADIR;${datadir};g" | sed "s;MODELDIR;${modeldir};g" | sed "s;CALMODEL;${calmodel};g" | sed "s;NCPUS;${ncpus};" | sed "s;TARGET;${target};g" >> cal_${target}.sh
    else
        echo "$datadir/${proj}/${obsnum}/${obsnum}.ms doesn't exist!"
    fi
    $qsub cal_${target}.sh
else
    echo "Give me an observation number, a project ID, and the name of your calibrator, and the target obs e.g. calibrate.sh 1012345678 G0008 3C444 1123793080"
    exit 1
fi

exit 0
