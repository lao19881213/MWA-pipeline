#!/bin/bash -l
# Must have a "-l" or a "--login" after the shebang, on Galaxy

# Trivial command script for MWA DR workshop

# PBS systems use qsub ; Slurm uses sbatch
qsub="sbatch"

# Where the templates and created job scripts live
queuedir=$HOME/queue

# Regular expression
re='^[0-9]+$'

# Command-line arguments
if [[ $1 ]] && [[ $2 ]]
then
    if ! [[ $1 =~ $re ]]
    then
        echo "error: Not a number" >&2
        echo "$1 needs to be an integer number :)"
        exit 1
    else
        num=$1
    fi
    animal=$2
    cd $queuedir
# Using semicolons makes substituting directories easier
    cat will_be_modified.template | sed "s;NUM;$num;g" | sed "s;ANIMAL;$animal;g" > submitted_job.sh
    $qsub submitted_job.sh
else
    echo "Please give me a number as the first argument, and a random string as the second argument :)"
fi

exit 0
