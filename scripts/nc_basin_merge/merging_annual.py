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

# merging annual resolution over areas (you have to type the source folders directly 
cmd  = ''
cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ 6 %i-12-31 %i-12-31 & ' %(input_folder[0], output_folder, year_int[0], year_int[1] - 1, year_int[0], year_int[1] - 1)
cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ 6 %i-12-31 %i-12-31 & ' %(input_folder[1], output_folder, year_int[1], year_int[2] - 1, year_int[1], year_int[2] - 1)
cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ 6 %i-12-31 %i-12-31 & ' %(input_folder[2], output_folder, year_int[2], year_int[3] - 1, year_int[2], year_int[3] - 1)
cmd += 'python nc_basin_merge.py %s %s/%i_to_%i/ 6 %i-12-31 %i-12-31 & ' %(input_folder[3], output_folder, year_int[3], last_year      , year_int[3], last_year)
cmd += 'wait'
print cmd
#~ os.system(cmd)

file_name_list = [
'snowCoverSWE_annuaAvg_output.nc',
'snowFreeWater_annuaAvg_output.nc',
'interceptStor_annuaAvg_output.nc',
'topWaterLayer_annuaAvg_output.nc',
'storUppTotal_annuaAvg_output.nc',
'storLowTotal_annuaAvg_output.nc',
'storGroundwater_annuaAvg_output.nc',
'surfaceWaterStorage_annuaAvg_output.nc',
'irrGrossDemand_annuaTot_output.nc',
'nonIrrGrossDemand_annuaTot_output.nc',
'totalRunoff_annuaTot_output.nc',
'totalEvaporation_annuaTot_output.nc'
]


#~ # merging annual resolution over areas
#~ cmd  = ''
#~ cmd += 'python nc_basin_merge.py /projects/0/dfguu/users/edwin/05min_runs_november_2015_start/pcrglobwb_modflow_from_1950/                       %s/1950_to_1971/ 6 1950-12-31 1971-12-31 & ' %(output_folder)
#~ cmd += 'python nc_basin_merge.py /projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1972/ %s/1972_to_1983/ 6 1972-12-31 1983-12-31 & ' %(output_folder)
#~ cmd += 'python nc_basin_merge.py /projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1984/ %s/1984_to_1999/ 6 1984-12-31 1999-12-31 & ' %(output_folder)
#~ cmd += 'python nc_basin_merge.py /projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_2000/ %s/2000_to_2010/ 6 2000-12-31 2010-12-31 & ' %(output_folder)
#~ cmd += 'wait'
#~ print cmd
#~ os.system(cmd)
#~ 
#~ 
#~ # merging annual resolution netcdf files over time
#~ os.chdir(/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950)
#~ cd 
#~ mkdir 1950_to_2010 
#~ cd 1950_to_2010
#~ 
#~ cmd = ''
#~ 'cdo mergetime \'
#~ %s/2000_to_2010/discharge_annuaAvg_output.nc \
#~ %s/1984_to_1999/discharge_annuaAvg_output.nc \
#~ %s/1972_to_1983/discharge_annuaAvg_output.nc \
#~ %s/1950_to_1971/discharge_annuaAvg_output.nc \
#~ %s/discharge_annuaAvg_output.nc
#~ 
#~ cdo mergetime \
#~ ../2000_to_2010/totalWaterStorageThickness_annuaAvg_output.nc \
#~ ../1984_to_1999/totalWaterStorageThickness_annuaAvg_output.nc \
#~ ../1972_to_1983/totalWaterStorageThickness_annuaAvg_output.nc \
#~ ../1950_to_1971/totalWaterStorageThickness_annuaAvg_output.nc \
#~ totalWaterStorageThickness_annuaAvg_output.nc
#~ 
#~ # merging 
