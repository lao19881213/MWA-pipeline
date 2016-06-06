#!/bin/bash

cd /scratch/blao/mwasci/mwa_data/G0008
python $LIBPATH/mwapipeline/bin/obsdownload.py -o 1123785280


bash /scratch/blao/mwasci/course/queue/cot_1123785280.sh
bash /scratch/blao/mwasci/course/queue/cot_1123785280.sh
