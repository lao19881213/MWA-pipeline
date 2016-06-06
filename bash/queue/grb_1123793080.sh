#!/bin/bash -l

# Queues up some data grabbing via obsdownload.py

#SBATCH --reservation=courseq
#SBATCH --account=courses02
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=/home/cou049/queue/grb_1123793080.o%j
#SBATCH --error=/home/cou049/queue/grb_1123793080.e%j
#SBATCH --export=NONE

cd /scratch2/courses02/cou049/G0008
obsdownload.py -o 1123793080

sbatch -M galaxy /home/cou049/queue/cot_1123793080.sh
