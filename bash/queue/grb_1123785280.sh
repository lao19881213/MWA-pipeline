#!/bin/bash

cd /scratch2/mwasci/blao/data/G0008
obsdownload.py -o 1123785280

bash /home/blao/course_dfms/queue/cot_1123785280.sh
