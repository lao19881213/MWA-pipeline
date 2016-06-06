#!/bin/bash

cd /scratch/blao/mwasci/mwa_data/G0008
python $LIBPATH/mwapipeline/bin/obsdownload.py -o 1146604864


bash /scratch/blao/mwasci/course/queue/cot_1146604864.sh
