
set -x

mkdir -p /scratch-shared/edwinhs/05min_runs_for_gmd_paper_30_oct_2017/05min_runs_4LCs_accutraveltime_cru-forcing_1958-2015/non-natural_starting_from_1958/merged_1958_to_2015_for_annual_flux_analysis/
cd /scratch-shared/edwinhs/05min_runs_for_gmd_paper_30_oct_2017/05min_runs_4LCs_accutraveltime_cru-forcing_1958-2015/non-natural_starting_from_1958/merged_1958_to_2015_for_annual_flux_analysis/

cdo -L -f nc4 -z zip -mergetime ../precipitation_annuaTot_output_*.nc           precipitation_annuaTot_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../totalEvaporation_annuaTot_output_*.nc        totalEvaporation_annuaTot_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../totalRunoff_annuaTot_output_*.nc             totalRunoff_annuaTot_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../gwRecharge_annuaTot_output_*.nc              gwRecharge_annuaTot_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../baseflow_annuaTot_output_*.nc                baseflow_annuaTot_output_1958_to_2015.nc

cdo -L -f nc4 -z zip -mergetime ../totalAbstraction_annuaTot_output_*.nc        totalAbstraction_annuaTot_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../desalinationAbstraction_annuaTot_output_*.nc desalinationAbstraction_annuaTot_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../surfaceWaterAbstraction_annuaTot_output_*.nc surfaceWaterAbstraction_annuaTot_output_1958_to_2015.nc

cdo -L -f nc4 -z zip -mergetime ../snowCoverSWE_annuaAvg_output_*.nc        snowCoverSWE_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../snowFreeWater_annuaAvg_output_*.nc       snowFreeWater_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../surfaceWaterStorage_annuaAvg_output_*.nc surfaceWaterStorage_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../topWaterLayer_annuaAvg_output_*.nc       topWaterLayer_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../interceptStor_annuaAvg_output_*.nc       interceptStor_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../storUppTotal_annuaAvg_output_*.nc        storUppTotal_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../storLowTotal_annuaAvg_output_*.nc        storLowTotal_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../storGroundwater_annuaAvg_*.nc            storGroundwater_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../storGroundwaterFossil_annuaAvg_*.nc      storGroundwaterFossil_annuaAvg_output_1958_to_2015.nc
cdo -L -f nc4 -z zip -mergetime ../totalWaterStorageThickness_annuaAvg_*.nc totalWaterStorageThickness_annuaAvg_output_1958_to_2015.nc

