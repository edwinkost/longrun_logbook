# 1950, 1972, 1984, 2000

python nc_basin_merge.py /projects/0/dfguu/users/edwin/05min_runs_november_2015_start/pcrglobwb_modflow_from_1950/                       /projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_1971/ 6 1950-12-31 1971-12-31 &
python nc_basin_merge.py /projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1972/ /projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1972_to_1983/ 6 1972-12-31 1983-12-31 &
python nc_basin_merge.py /projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_1984/ /projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1984_to_1999/ 6 1984-12-31 1999-12-31 &
python nc_basin_merge.py /projects/0/wtrcycle/users/edwin/edwin/05min_runs_november_2015/pcrglobwb_modflow_from_1950/continue_from_2000/ /projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/2000_to_2010/ 6 2000-12-31 2010-12-31 &
wait

cd /projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950
mkdir 1950_to_2010 
cd 1950_to_2010

cdo mergetime \
../1950_to_1971/discharge_annuaAvg_output.nc \
../1972_to_1983/discharge_annuaAvg_output.nc \
../1984_to_1999/discharge_annuaAvg_output.nc \
../2000_to_2010/discharge_annuaAvg_output.nc discharge_annuaAvg_output.nc

cdo mergetime \
../1950_to_1971/totalWaterStorageThickness_annuaAvg_output.nc \
../1972_to_1983/totalWaterStorageThickness_annuaAvg_output.nc \
../1984_to_1999/totalWaterStorageThickness_annuaAvg_output.nc \
../2000_to_2010/totalWaterStorageThickness_annuaAvg_output.nc totalWaterStorageThickness_annuaAvg_output.nc
