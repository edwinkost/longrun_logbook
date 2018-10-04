
set -x

cd /scratch-shared/edwinsut/pcrglobwb2_output_05min_gmd_paper/natural/begin_from_1958/global/netcdf/merged_1958-2015/

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

#~ -rw-r--r-- 1 edwinsut edwinsut 6.0M Oct  4 00:37 ../actualET_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.4M Oct  4 00:37 ../baseflow_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../desalinationAbstraction_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.6M Oct  4 00:37 ../discharge_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../domesticWaterWithdrawal_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../evaporation_from_irrigation_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../fossilGroundwaterAbstraction_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.4M Oct  4 00:37 ../gwRecharge_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.4M Oct  4 00:37 ../gwRecharge_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../industryWaterWithdrawal_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 2.6M Oct  4 00:37 ../interceptStor_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 1.7M Oct  4 00:37 ../interceptStor_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../irrGrossDemand_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../irrPaddyWaterWithdrawal_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../irrigationWaterWithdrawal_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../livestockWaterWithdrawal_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../netLqWaterToSoil_at_irrigation_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../nonFossilGroundwaterAbstraction_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../nonIrrGrossDemand_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../nonIrrReturnFlow_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../nonIrrWaterConsumption_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 843K Oct  4 00:37 ../precipitation_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../precipitation_at_irrigation_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 791K Oct  4 00:37 ../referencePotET_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.2M Oct  4 00:37 ../runoff_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 3.7M Oct  4 00:37 ../snowCoverSWE_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 2.9M Oct  4 00:37 ../snowCoverSWE_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 3.6M Oct  4 00:37 ../snowFreeWater_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 1.8M Oct  4 00:37 ../snowFreeWater_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.0M Oct  4 00:37 ../storGroundwaterFossil_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.2M Oct  4 00:37 ../storGroundwaterFossil_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.5M Oct  4 00:37 ../storGroundwater_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.5M Oct  4 00:37 ../storGroundwater_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 5.9M Oct  4 00:37 ../storLowTotal_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 5.7M Oct  4 00:37 ../storLowTotal_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.1M Oct  4 00:37 ../storUppTotal_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.0M Oct  4 00:37 ../storUppTotal_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../surfaceWaterAbstraction_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.5M Oct  4 00:37 ../surfaceWaterStorage_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.3M Oct  4 00:37 ../surfaceWaterStorage_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 5.6M Oct  4 00:37 ../temperature_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 387K Oct  4 00:37 ../topWaterLayer_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 387K Oct  4 00:37 ../topWaterLayer_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../totalAbstraction_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.2M Oct  4 00:37 ../totalEvaporation_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../totalGrossDemand_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.3M Oct  4 00:37 ../totalRunoff_annuaTot_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.8M Oct  4 00:37 ../totalWaterStorageThickness_annuaAvg_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 6.8M Oct  4 00:37 ../totalWaterStorageThickness_annuaEnd_output_1958-12-31_to_1958-12-31.nc
#~ -rw-r--r-- 1 edwinsut edwinsut 389K Oct  4 00:37 ../transpiration_from_irrigation_annuaTot_output_1958-12-31_to_1958-12-31.nc
