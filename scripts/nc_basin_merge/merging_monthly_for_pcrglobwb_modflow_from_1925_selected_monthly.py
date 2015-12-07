#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
import glob

# output folders 
output_folder          = '/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/'

# interval for years:
year_int  = [1925, 1947, 1954, 1975, 1991]
last_year = 2010

# specific file name for output TWS file
tws_filename = None

# input folders (the sequence must be consistent with the list 'year_int'
input_folder = [
'/projects/0/dfguu/users/edwin/05min_runs_november_2015_start/pcrglobwb_modflow_from_1925',                      
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1925/continue_from_1947',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1925/continue_from_1954',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1925/continue_from_1975',
'/projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1925/continue_from_1991'
]

# maximum number of cores used per command lines
num_of_cores = 6

# preparing output folder
cmd = 'mkdir '+str(output_folder)
os.system(cmd)

# TODO: copying the script 'nc_basin_merge.py' to the output_folder and change the working directory to the output_folder (such that the 'nc_basin_merge.py' will not be affected by any changes)

# merging annual resolution over areas
cmd = ''; print cmd
for i_year in range(0, len(year_int)-1):
    cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-01-31 %i-12-31 selected_monthly & ' %(input_folder[i_year]         , output_folder, year_int[i_year]         , year_int[i_year+1]-1, num_of_cores, year_int[i_year]         , year_int[i_year+1]-1)
cmd     += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-01-31 %i-12-31 selected_monthly & ' %(input_folder[len(year_int)-1], output_folder, year_int[len(year_int)-1], last_year,            num_of_cores, year_int[len(year_int)-1], last_year           )
cmd     += 'wait'
print cmd
os.system(cmd)

# get the list of pcrglobw netcdf files (must be consistent with the 'selected_monthly' option)
pcrglobwb_netcdf_list = [
output_folder + "/1901_to_2010/" + 'totalGroundwaterAbstraction_monthTot_output.nc',
output_folder + "/1901_to_2010/" + 'gwRecharge_monthTot_output.nc'
]

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
    if os.path.exists(output_file): os.remove(output_file)
    
    # command line for merging
    cmd += 'cdo mergetime '
    for i_year in range(0, len(year_int)-1):
        cmd += '%s/%i_to_%i/%s ' %(output_folder, year_int[i_year],          year_int[i_year+1] - 1, str(os.path.basename(nc_file)))
    cmd     += '%s/%i_to_%i/%s ' %(output_folder, year_int[len(year_int)-1], last_year             , str(os.path.basename(nc_file)))
    cmd += output_file + " & "
    
cmd     += 'wait'
print cmd
os.system(cmd)

