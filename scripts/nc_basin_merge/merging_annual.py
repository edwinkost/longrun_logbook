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

# merging annual resolution over areas
cmd      = ''
for i_year in range(0, len(year_int)-1):
    cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-12-31 %i-12-31 & ' %(input_folder[i_year]         , output_folder, year_int[i_year]         , year_int[i_year+1]-1, num_of_cores, year_int[i_year]         , year_int[i_year+1]-1)
cmd     += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-12-31 %i-12-31 & ' %(input_folder[len(year_int)-1], output_folder, year_int[len(year_int)-1], last_year,            num_of_cores, year_int[len(year_int)-1], last_year)
cmd     += 'wait'
print cmd
#~ os.system(cmd)

# get the list of pcrglobw netcdf files
pcrglobwb_netcdf_list = glob.glob(output_folder + "/" + str(year_int[i_year]) + "_to_" + str(year_int[i_year+1]-1) + '/*annua*.nc')

print pcrglobwb_netcdf_list

# preparing the complete output folder
complete_output_folder = output_folder + "/" + str(year_int[0]) + "_to_" + str(last_year)
cmd = 'mkdir '+str(complete_output_folder)
os.system(cmd)

# merging over time
cmd = ''
for nc_file in pcrglobwb_netcdf_list:
    
    # output file
    output_file = ''
    output_file = '%s/%s' %(complete_output_folder, str(os.path.basename(nc_file)))
    if os.path.exists(output_file): os.remove(output_file)
    
    # command line for merging
    cmd += 'cdo mergetime '
    for i_year in range(0, len(year_int)-1):
        cmd += '%s/%i_to_%i/%s ' %(output_folder, year_int[i_year],          year_int[i_year+1] - 1, str(os.path.basename(nc_file)))
    cmd     += '%s/%i_to_%i/%s ' %(output_folder, year_int[len(year_int)-1], last_year             , str(os.path.basename(nc_file)))
    cmd += output_file + " & "
    
cmd     += 'wait'
print cmd
#~ os.system(cmd)


# merging modflow output over time (modflow output files are only at monthly resolution)
modflow_netcdf_list = [
'groundwaterDepthLayer1_monthEnd_output.nc',
'groundwaterDepthLayer2_monthEnd_output.nc',
'groundwaterHeadLayer1_monthEnd_output.nc',
'groundwaterHeadLayer2_monthEnd_output.nc',
'groundwaterThicknessEstimate_monthEnd_output.nc',
'groundwaterVolumeEstimate_monthEnd_output.nc'
]

# first, we have to select the proper years and calculate their yearly average values
cmd = ''
for nc_file in modflow_netcdf_list:
    
    # delete output files if they are exists
    for i_year in range(0, len(year_int)-1):
        output_file = '%s/%i_to_%i/%s' %(output_folder, year_int[i_year],          year_int[i_year+1]-1, nc_file+"annuaAvg.nc")
        if os.path.exists(output_file): os.remove(output_file)
    output_file     = '%s/%i_to_%i/%s' %(output_folder, year_int[len(year_int)-1], last_year,            nc_file+"annuaAvg.nc")
    if os.path.exists(output_file): os.remove(output_file)        

    # command lines for selecting years
    for i_year in range(0, len(year_int)-1):
        cmd += 'cdo yearavg -selyear,%i/%i %s/modflow/transient/netcdf/%s ' %(year_int[i_year],          year_int[i_year+1]-1, input_folder[i_year]         , nc_file)
        output_file = '%s/%i_to_%i/%s' %(output_folder, year_int[i_year],          year_int[i_year+1]-1, nc_file+"annuaAvg.nc")
        cmd += output_file + " & "
    cmd     += 'cdo yearavg -selyear,%i/%i %s/modflow/transient/netcdf/%s ' %(year_int[len(year_int)-1], last_year,            input_folder[len(year_int)-1], nc_file)    
    output_file = '%s/%i_to_%i/%s'     %(output_folder, year_int[len(year_int)-1], last_year,            nc_file+"annuaAvg.nc")
    cmd += output_file + " & "
cmd     += 'wait'
print cmd
os.system(cmd)


# then we will merge it over time


# calculate TWS
cmd = ''

#~ # calculate annual average of 
#~ cmd  = '' 
#~ cmd += 'cdo yearavg %s %s' %(complete_output_folder + "/groundwaterThicknessEstimate_annuaAvg_output.nc", complete_output_folder + "/groundwaterThicknessEstimate_annuaAvg_output.nc")
