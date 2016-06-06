#!/bin/bash

cd /home/lbq/lbq/mwasci/mwa_data/G0008
python /home/lbq/lbq/mwasci/mwapipeline/bin/obsdownload.py -o 1146425088

bash /home/lbq/lbq/mwasci/course/queue/cot_1146425088.sh
