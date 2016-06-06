#!/bin/bash -l

# Cotter the data

#SBATCH --account=courses02
#SBATCH --reservation=courseq
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --mem=64gb
#SBATCH --output=/home/cou049/queue/cot_1123793080.o%j
#SBATCH --error=/home/cou049/queue/cot_1123793080.e%j
#SBATCH --export=NONE

aprun="aprun -n 1 -d 20 -q "
cd /scratch2/courses02/cou049/G0008/1123793080
make_metafits.py -g 1123793080
if [[ -e 1123793080_flags.zip ]]
then
    unzip 1123793080_flags.zip
    flagfiles="-flagfiles 1123793080_%%.mwaf"
fi
$aprun cotter -j 20 $flagfiles -timeres 4 -freqres 40 *gpubox*.fits -edgewidth 80 -m 1123793080.metafits -o 1123793080.ms
if [[ -d 1123793080.ms ]] ; then rm *gpubox*fits *.zip *.mwaf ; fi
