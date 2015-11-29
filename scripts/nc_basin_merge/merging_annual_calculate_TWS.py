#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import glob

# output folders 
output_folder          = '/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/'

# interval for years: 1950, 1972, 1984, 2000
year_int  = [1950, 1972, 1984, 2000]
last_year = 2010

# specific file name for output TWS file
tws_filename = None

# preparing the complete output folder
complete_output_folder = output_folder + "/" + str(year_int[0]) + "_to_" + str(last_year)
cmd = 'mkdir '+str(complete_output_folder)
os.system(cmd)

# calculate annual average of TWS
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_annuaAvg_output.nc %s/snowFreeWater_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
#~ cmd = ''; print cmd
#~ cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_annuaAvg.nc %s/interceptStor_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
#~ print cmd
#~ os.system(cmd)
#~ cmd = ''; print cmd
#~ cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_annuaAvg.nc %s/topWaterLayer_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
#~ print cmd
#~ os.system(cmd)
#~ cmd = ''; print cmd
#~ cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_annuaAvg.nc %s/storUppTotal_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
#~ print cmd
#~ os.system(cmd)
#~ cmd = ''; print cmd
#~ cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_annuaAvg.nc %s/storLowTotal_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
#~ print cmd
#~ os.system(cmd)
#~ cmd = ''; print cmd
#~ cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_annuaAvg.nc %s/surfaceWaterStorage_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
#~ print cmd
#~ os.system(cmd)
#~ 
#~ # the TWS
#~ if tws_filename == None: tws_filename = "TWS.nc"
#~ cmd = ''; print cmd
#~ cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc %s/groundwaterThicknessEstimate_annuaAvg_output.nc %s/%s' %(complete_output_folder, complete_output_folder, complete_output_folder, tws_filename)
#~ print cmd
#~ os.system(cmd)
#~ 
#~ # renaming variable names
#~ cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater %s/snowCoverSWE_snowFreeWater_annuaAvg.nc' %(complete_output_folder)
#~ print cmd; os.system(cmd)
#~ cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_annuaAvg %s/snowCoverSWE_snowFreeWater_interceptStor_annuaAvg.nc' %(complete_output_folder)
#~ print cmd; os.system(cmd)
#~ cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_annuaAvg.nc' %(complete_output_folder)
#~ print cmd; os.system(cmd)
#~ cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_annuaAvg.nc' %(complete_output_folder)
#~ print cmd; os.system(cmd)
#~ cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_annuaAvg.nc' %(complete_output_folder)
#~ print cmd; os.system(cmd)
#~ cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc' %(complete_output_folder)
#~ print cmd; os.system(cmd)
#~ 
#~ # the TWS
#~ if tws_filename == None: tws_filename = None
#~ cmd = ''; print cmd
#~ cmd = 'ncrename -v snow_water_equivalent,TWS %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc %s/groundwaterThicknessEstimate_annuaAvg_output.nc %s/%s' %(complete_output_folder, complete_output_folder, complete_output_folder, tws_filename)
#~ print cmd
#~ os.system(cmd)
