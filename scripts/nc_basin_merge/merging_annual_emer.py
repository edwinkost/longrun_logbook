#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import glob

# output folders 
output_folder          = '/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/'

# interval for years: 1950, 1972, 1984, 2000
year_int  = [1950, 1972, 1984, 2000]
last_year = 2010

# input folders (the sequence must be consistent with the list 'year_int'
input_folder = [
'/projects/0/dfguu/users/edwin/05min_runs_november_2015_start/pcrglobwb_modflow_from_1950/',                      
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1972/',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1984/',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_2000/'
]

# maximum number of cores used per command lines
num_of_cores = 6

# preparing output folder
cmd = 'mkdir '+str(output_folder)
os.system(cmd)

# preparing the complete output folder
complete_output_folder = output_folder + "/" + str(year_int[0]) + "_to_" + str(last_year)
cmd = 'mkdir '+str(complete_output_folder)
os.system(cmd)

# merging modflow output over time (modflow output files are only at monthly resolution)
modflow_netcdf_list = [
'groundwaterDepthLayer1_monthEnd_output.nc',
'groundwaterDepthLayer2_monthEnd_output.nc',
'groundwaterHeadLayer1_monthEnd_output.nc',
'groundwaterHeadLayer2_monthEnd_output.nc',
'groundwaterThicknessEstimate_monthEnd_output.nc',
'groundwaterVolumeEstimate_monthEnd_output.nc'
]

# calculate annual average of TWS
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_annuaAvg_output.nc %s/snowFreeWater_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_annuaAvg.nc %s/interceptStor_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_annuaAvg.nc %s/topWaterLayer_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_annuaAvg.nc %s/storUppTotal_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_annuaAvg.nc %s/storLowTotal_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_annuaAvg.nc %s/surfaceWaterStorage_annuaAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)

cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc %s/groundwaterThicknessEstimate_annuaAvg_output.nc %s/TWS_type_one.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)

cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_annuaAvg.nc %s/storGroundwater_annuaAvg_output.nc %s/TWS_type_two.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
