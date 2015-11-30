#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import glob

# output folders 
output_folder = '/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/'

# interval for years: 1950, 1972, 1984, 2000
year_int  = [1950, 1972, 1984, 2000]
last_year = 2010

# specific file name for output TWS file
tws_filename = "TWS_monthly.nc"

# input folders (the sequence must be consistent with the list 'year_int'
input_folder = [
'/projects/0/dfguu/users/edwin/05min_runs_november_2015_start/pcrglobwb_modflow_from_1950/',                      
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1972/',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1984/',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_2000/'
]

# maximum number of cores used per command lines
num_of_cores = 4

# preparing output folder
cmd = 'mkdir '+str(output_folder)
os.system(cmd)

# merging monthly resolution files over areas
cmd = ''; print cmd
for i_year in range(0, len(year_int)-1):
    cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-01-31 %i-12-31 monthly_16 & ' %(input_folder[i_year]         , output_folder, year_int[i_year]         , year_int[i_year+1]-1, num_of_cores, year_int[i_year]         , year_int[i_year+1]-1)
cmd     += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-01-31 %i-12-31 monthly_16 & ' %(input_folder[len(year_int)-1], output_folder, year_int[len(year_int)-1], last_year,            num_of_cores, year_int[len(year_int)-1], last_year)
cmd     += 'wait'
print cmd
os.system(cmd)

# get the list of pcrglobw netcdf files
pcrglobwb_netcdf_list = glob.glob(output_folder + "/" + str(year_int[i_year]) + "_to_" + str(year_int[i_year+1]-1) + '/*month*.nc')

print pcrglobwb_netcdf_list

# preparing the complete output folder
complete_output_folder = output_folder + "/" + str(year_int[0]) + "_to_" + str(last_year)
cmd = 'mkdir '+str(complete_output_folder)
os.system(cmd)

# merging over time
cmd = ''; print cmd
for nc_file in pcrglobwb_netcdf_list:
    
    # output file
    output_file = ''
    output_file = '%s/%s' %(complete_output_folder, str(os.path.basename(nc_file)))
    #~ if os.path.exists(output_file): os.remove(output_file)              # we don't have to delete files (it will overwrite them)
    
    # command line for merging
    cmd += 'cdo mergetime '
    for i_year in range(0, len(year_int)-1):
        cmd += '%s/%i_to_%i/%s ' %(output_folder, year_int[i_year],          year_int[i_year+1] - 1, str(os.path.basename(nc_file)))
    cmd     += '%s/%i_to_%i/%s ' %(output_folder, year_int[len(year_int)-1], last_year             , str(os.path.basename(nc_file)))
    cmd += output_file + " & "
    
cmd     += 'wait'
print cmd
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

# first, we have to select the proper years
cmd = ''; print cmd
for nc_file in modflow_netcdf_list:
    
    # command lines for selecting years
    for i_year in range(0, len(year_int)-1):
        output_file = '%s/%i_to_%i/%s' %(output_folder, year_int[i_year],          year_int[i_year+1]-1, nc_file)
        if os.path.exists(output_file):
            cmd += ''
        else:
            cmd += 'cdo selyear,%i/%i %s/modflow/transient/netcdf/%s ' %(year_int[i_year],          year_int[i_year+1]-1, input_folder[i_year]         , nc_file)
            cmd += output_file + " & "
    output_file = '%s/%i_to_%i/%s'     %(output_folder, year_int[len(year_int)-1], last_year,            nc_file)
    if os.path.exists(output_file):
        cmd += ''
    else:    
        cmd     += 'cdo selyear,%i/%i %s/modflow/transient/netcdf/%s ' %(year_int[len(year_int)-1], last_year,            input_folder[len(year_int)-1], nc_file)    
        cmd     += output_file + " & "
cmd     += 'wait'
print cmd
os.system(cmd)


# then we will merge it over time
cmd = ''; print cmd
for nc_file in modflow_netcdf_list:
    
    # output file
    output_file = '%s/%s' %(complete_output_folder, nc_file)
    #~ if os.path.exists(output_file): os.remove(output_file)
    
    # command line for merging
    cmd += 'cdo mergetime '
    for i_year in range(0, len(year_int)-1):
        cmd += '%s/%i_to_%i/%s ' %(output_folder, year_int[i_year],          year_int[i_year+1] - 1, nc_file)
    cmd     += '%s/%i_to_%i/%s ' %(output_folder, year_int[len(year_int)-1], last_year             , nc_file)
    cmd += output_file + " & "
cmd     += 'wait'
print cmd
os.system(cmd)

# calculate monthly average of TWS
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_monthAvg_output.nc %s/snowFreeWater_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_monthAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_monthAvg.nc %s/interceptStor_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_monthAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_monthAvg.nc %s/topWaterLayer_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_monthAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_monthAvg.nc %s/storUppTotal_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_monthAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_monthAvg.nc %s/storLowTotal_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_monthAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_monthAvg.nc %s/surfaceWaterStorage_monthAvg_output.nc %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_monthAvg.nc' %(complete_output_folder, complete_output_folder, complete_output_folder)
print cmd
os.system(cmd)

# the TWS
if tws_filename == None: tws_filename = "TWS.nc"
cmd = ''; print cmd
cmd = 'cdo add %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_monthAvg.nc %s/groundwaterThicknessEstimate_monthEnd_output.nc %s/%s' %(complete_output_folder, complete_output_folder, complete_output_folder, tws_filename)
print cmd
os.system(cmd)

# renaming variable names
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater %s/snowCoverSWE_snowFreeWater_monthAvg.nc' %(complete_output_folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_monthAvg %s/snowCoverSWE_snowFreeWater_interceptStor_monthAvg.nc' %(complete_output_folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_monthAvg.nc' %(complete_output_folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_monthAvg.nc' %(complete_output_folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_monthAvg.nc' %(complete_output_folder)
print cmd; os.system(cmd)
cmd = 'ncrename -v snow_water_equivalent,snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage %s/snowCoverSWE_snowFreeWater_interceptStor_topWaterLayer_storUppTotal_storLowTotal_surfaceWaterStorage_monthAvg.nc' %(complete_output_folder)
print cmd; os.system(cmd)

# the TWS
if tws_filename == None: tws_filename = None
cmd = ''; print cmd
cmd = 'ncrename -v snow_water_equivalent,TWS %s/%s' %(complete_output_folder, tws_filename)
print cmd
os.system(cmd)
