#!/bin/bash -l

# Cotter the data

#SBATCH --account=mwasci
##SBATCH --reservation=workq
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --mem=64gb
#SBATCH --output=/home/blao/course/queue/cot_1146606064.o%j
#SBATCH --error=/home/blao/course/queue/cot_1146606064.e%j
#SBATCH --export=NONE

source /home/blao/course/bashrc_append
source /home/blao/course/profile_append

aprun="aprun -n 1 -d 20 -q "
cd /scratch2/mwasci/blao/data/G0008/1146606064
make_metafits.py -g 1146606064
if [[ -e 1146606064_flags.zip ]]
then
    unzip 1146606064_flags.zip
    flagfiles="-flagfiles 1146606064_%%.mwaf"
fi
$aprun cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1146606064.metafits -o 1146606064.ms
if [[ -d 1146606064.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
