#!/bin/bash

# Downloads data via NGAS
# Then submits cotter job
# Data must be available on the archive!

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
    if [[ ! -d $datadir/${proj}/${obsnum}/${obsnum}.ms ]]
    then
        cat grab_body.template | sed "s;OBSNUM;${obsnum};g" | sed "s;PROJ;${proj};g"  | sed "s;DATADIR;${datadir};g" > grb_${obsnum}.sh
        cat cot_body.template | sed "s;OBSNUM;${obsnum};g" | sed "s;PROJ;${proj};g" | sed "s;DATADIR;${datadir};g" | sed "s;NCPUS;${ncpus};g" > cot_${obsnum}.sh
    fi
    echo "bash ${queuedir}/cot_${obsnum}.sh" >> grb_${obsnum}.sh
    bash grb_${obsnum}.sh
else
    echo "Give me an observation number and a project ID, e.g. grab_cot.sh 1012345678 G0001 ."
    exit 1
fi

exit 0
