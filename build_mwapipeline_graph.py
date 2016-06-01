#    SHAO - Shanghai Astronomical Observatory, Chinese Academy of Sciences
#    80 Nandan Road, Shanghai 200030 
#    China
#
#    ICRAR - International Centre for Radio Astronomy Research
#    (c) UWA - The University of Western Australia
#    Copyright by UWA (in the framework of the ICRAR)
#    All rights reserved
#
#    This library is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser General Public
#    License as published by the Free Software Foundation; either
#    version 2.1 of the License, or (at your option) any later version.
#
#    This library is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public
#    License along with this library; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston,
#    MA 02111-1307  USA
#
#    created by Baoqiang Lao
#    SHAO
#    27.05.2016
"""
Build the physical graph
"""

from build_mwapipeline_graph_common import AbstractBuildGraph
import json
import optparse
import sys

parser =optparse.OptionParser()
parser.add_option("-o","--obsnum",action="store",dest="obsnum",help="The obsnum is the observation ID",default="1123785280")
parser.add_option("-p","--proj",action="store",dest="proj",help="The proj is the project ID",default="G0008")
parser.add_option("-m","--model",action="store",dest="model",help="The model is the calibration model",default="3c444")
parser.add_option("-t","--tgtobsnum",action="store",dest="tgtobsnum",help="The tgtobsnum is the target observation ID",default="1123785280")
parser.add_option("-n","--node-id",action="store",dest="node_id",help="The node where the graph will be deployed",default="localhost")

(opts,args)=parser.parse_args(sys.argv)

obsnum=opts.obsnum
proj=opts.proj
bashdir='/home/blao/course/bin'
model=opts.model
tgt_obsnum=opts.tgtobsnum
node_id=opts.node_id

absbg=AbstractBuildGraph('bucket_name','shutdown',{'0':"0.0.0.0"},'','session_id')
#app drop
drop_bash_obsdownloads=absbg.create_bash_shell_app(node_id,'obsdownloads','bash {0}/grab_cot.sh {1} {2}'.format(bashdir,obsnum,proj))
drop_bash_calibrate=absbg.create_bash_shell_app(node_id,'calibrate','bash {0}/calibrate.sh {1} {2} {3}'.format(bashdir,obsnum,proj,model))
drop_bash_imaging=absbg.create_bash_shell_app(node_id,'imaging','bash {0}/imaging.sh {1} {2} {3} {4}'.format(bashdir,obsnum,proj,model,tgt_obsnum))
drop_bash_self_calibration=absbg.create_bash_shell_app(node_id,'self_calibration','bash {0}/selfcal.sh {1} {2}'.format(bashdir,obsnum,proj))
#memory drop
drop_memory_ms=absbg.create_memory_drop(node_id,'MS file')
drop_memory_bin=absbg.create_memory_drop(node_id,'solutions bin file')
drop_memory_imgfits=absbg.create_memory_drop(node_id,'imaging fits file')
drop_memory_self_calibration_fits=absbg.create_memory_drop(node_id,'self calibration fits file')
#link drop
drop_bash_obsdownloads.addOutput(drop_memory_ms)
drop_bash_calibrate.addInput(drop_memory_ms)
drop_bash_calibrate.addOutput(drop_memory_bin)
drop_bash_imaging.addInput(drop_memory_bin)
drop_bash_imaging.addOutput(drop_memory_imgfits)
drop_bash_self_calibration.addInput(drop_memory_ms)
drop_bash_self_calibration.addOutput(drop_memory_self_calibration_fits)

absbg.start_oids.append(drop_bash_obsdownloads['uid'])
drop_list=absbg.drop_list

with open("{0}.json".format(obsnum), 'w') as f:
    json.dump(drop_list, f,indent=2)


