#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
import glob

# folder 
folder = str(sys.argv[1]) # '/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1935/'

# specific file name for the output TWS file
tws_filename = None
try:
	tws_filename = str(sys.argv[2])
except:
	pass

# calculate monthly average of TWS
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_monthAvg_output.nc %s/snowFreeWater_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_monthAvg.nc' %(folder, folder, folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_monthAvg.nc %s/interceptStor_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_monthAvg.nc' %(folder, folder, folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_monthAvg.nc %s/topWaterLayer_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_monthAvg.nc' %(folder, folder, folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_monthAvg.nc %s/storUppTotal_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_monthAvg.nc' %(folder, folder, folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_monthAvg.nc %s/storLowTotal_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_monthAvg.nc' %(folder, folder, folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_monthAvg.nc %s/surfaceWaterStorage_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_monthAvg.nc' %(folder, folder, folder)
print cmd
os.system(cmd)

# the TWS
if tws_filename == None: tws_filename = "TWS.nc"
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_monthAvg.nc %s/groundwaterThicknessEstimate_monthEnd_output.nc %s/%s' %(folder, folder, folder, tws_filename)
print cmd
os.system(cmd)

# renaming variable names
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater %s/snowCoverSWE_snowFreeWater_monthAvg.nc' %(folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor %s/snowCoverSWE_snowFreeWater_interceptStor_monthAvg.nc' %(folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_monthAvg.nc' %(folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_monthAvg.nc' %(folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_monthAvg.nc' %(folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_monthAvg.nc' %(folder)
print cmd; os.system(cmd)

# the TWS
if tws_filename == None: tws_filename = None
cmd = ''; print cmd
cmd = 'ncrename -v snow_water_equivalent,TWS %s/%s' %(folder, tws_filename)
print cmd
os.system(cmd)
