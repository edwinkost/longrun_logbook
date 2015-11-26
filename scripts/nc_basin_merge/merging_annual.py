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
    cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-12-31 %i-12-31 & ' %(input_folder[i_year]         , output_folder, year_int[i_year]         , year_int[i_year+1]-1, num_of_cores, year_int[i_year], year_int[i_year+1]-1)
cmd     += 'python nc_basin_merge.py %s %s/%i_to_%i/ %i %i-12-31 %i-12-31 & ' %(input_folder[len(year_int)-1], output_folder, year_int[len(year_int)-1], last_year,            num_of_cores, year_int[3],      last_year)
cmd     += 'wait'
print cmd
#~ os.system(cmd)

# get the list of pcrglobw netcdf files
pcrglobwb_netcdf_list = glob.glob(os.path.join(output_folder, '*annua*.nc'))

# preparing the complete output folder
complete_output_folder = output_folder + "/" + str(year_int[0]) + "_to_" + str(last_year)
cmd = 'mkdir '+str(complete_output_folder)
os.system(cmd)

# merging over time
cmd = ''
for nc_file in pcrglobwb_netcdf_list:
    cmd += 'cdo mergetime '
    for i_year in range(0, len(year_int)-1):
        cmd += '%s/%i_to_%i/%s ' %(output_folder, year_int[i_year],          year_int[i_year+1] - 1, str(os.path.basename(nc_file)))
    cmd     += '%s/%i_to_%i/%s ' %(output_folder, year_int[len(year_int)-1], last_year             , str(os.path.basename(nc_file)))
    cmd += '%s/%s & ' %(complete_output_folder, str(os.path.basename(nc_file)))
cmd     += 'wait'
print cmd
#~ os.system(cmd)


#~ ../1984_to_1999/totalWaterStorageThickness_annuaAvg_output.nc \
#~ ../1972_to_1983/totalWaterStorageThickness_annuaAvg_output.nc \
#~ ../1950_to_1971/totalWaterStorageThickness_annuaAvg_output.nc \
#~ totalWaterStorageThickness_annuaAvg_output.nc




    #~ cmd += ' & '
#~ print cmd
#~ os.system(cmd)

#~ cmd = ''
#~ 'cdo mergetime \'
#~ %s/2000_to_2010/discharge_annuaAvg_output.nc \
#~ %s/1984_to_1999/discharge_annuaAvg_output.nc \
#~ %s/1972_to_1983/discharge_annuaAvg_output.nc \
#~ %s/1950_to_1971/discharge_annuaAvg_output.nc \
#~ %s/discharge_annuaAvg_output.nc
#~ 
#~ 
#~ # merging 

# merging modflow output over time
modflow_netcdf_list = []

# calculate TWS

