#!/bin/bash -l

# Queues up some data grabbing via obsdownload.py

#SBATCH --partition=copyq
#SBATCH --account=mwasci
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=/home/blao/course/queue/grb_1146604264.o%j
#SBATCH --error=/home/blao/course/queue/grb_1146604264.e%j
#SBATCH --export=NONE


source /home/blao/course/bashrc_append
source /home/blao/course/profile_append
source /home/blao/bashrc

cd /scratch2/mwasci/blao/data/G0008
obsdownload.py -o 1146604264

sbatch -M galaxy /home/blao/course/queue/cot_1146604264.sh
bash /home/blao/course_dfms/queue/cot_1146604264.sh
bash /home/blao/course_dfms/queue/cot_1146604264.sh
bash /home/blao/course_dfms/queue/cot_1146604264.sh
