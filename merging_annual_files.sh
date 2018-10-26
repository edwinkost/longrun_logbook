
# option to show command lines
set -x

# - preparing the "merged" folder
mkdir merged

#~ # - merging monthly discharge result 
#~ cdo mergetime */global/netcdf/discharge_monthAvg_*.nc                                    merged/discharge_monthAvg_output.nc                 & 

# - merging groundwater thickness estimate result 
#   merging groundwater head result
#   and wait until the process is done
cdo mergetime */modflow/transient/netcdf/groundwaterThicknessEstimate_monthEnd_output.nc merged/groundwaterThicknessEstimate_monthEnd_output.nc &
cdo mergetime */modflow/transient/netcdf/groundwaterHeadLayer1_monthEnd_output.nc        merged/groundwaterHeadLayer1_monthEnd_output.nc        &
cdo mergetime */modflow/transient/netcdf/groundwaterHeadLayer2_monthEnd_output.nc        merged/groundwaterHeadLayer2_monthEnd_output.nc        &
wait 

# - calculating annual average values for groundwater thickness estimate 
cdo yearavg merged/groundwaterThicknessEstimate_monthEnd_output.nc                       merged/groundwaterThicknessEstimate_annuaAvg_output.nc &
cdo yearavg merged/groundwaterHeadLayer1_monthEnd_output.nc                              merged/groundwaterHeadLayer1_annuaAvg_output.nc        &
cdo yearavg merged/groundwaterHeadLayer2_monthEnd_output.nc                              merged/groundwaterHeadLayer1_annuaAvg_output.nc        &

# - merging the other relevant annual files and wait until all processes are done
cdo mergetime */global/netcdf/precipitation_annuaTot_*.nc                                merged/precipitation_annuaTot_output.nc                &
cdo mergetime */global/netcdf/totalEvaporation_annuaTot_*.nc                             merged/totalEvaporation_annuaTot_output.nc             &
cdo mergetime */global/netcdf/totalRunoff_annuaTot_*.nc                                  merged/totalRunoff_annuaTot_output.nc                  &
cdo mergetime */global/netcdf/gwRecharge_annuaTot_*.nc                                   merged/gwRecharge_annuaTot_output.nc                   &
cdo mergetime */global/netcdf/totalAbstraction_annuaTot_*.nc                             merged/totalAbstraction_annuaTot_output.nc             &
cdo mergetime */global/netcdf/totalGroundwaterAbstraction_annuaTot_*.nc                  merged/totalGroundwaterAbstraction_annuaTot_output.nc  &
cdo mergetime */global/netcdf/nonIrrGrossDemand_annuaTot_*.nc                            merged/nonIrrGrossDemand_annuaTot_output.nc            &
cdo mergetime */global/netcdf/snowCoverSWE_annuaAvg_*.nc                                 merged/snowCoverSWE_annuaAvg_output.nc                 &
cdo mergetime */global/netcdf/snowFreeWater_annuaAvg_*.nc                                merged/snowFreeWater_annuaAvg_output.nc                &
cdo mergetime */global/netcdf/surfaceWaterStorage_annuaAvg_*.nc                          merged/surfaceWaterStorage_annuaAvg_output.nc          &
cdo mergetime */global/netcdf/topWaterLayer_annuaAvg_*.nc                                merged/topWaterLayer_annuaAvg_output.nc                &
cdo mergetime */global/netcdf/interceptStor_annuaAvg_*.nc                                merged/interceptStor_annuaAvg_output.nc                &
cdo mergetime */global/netcdf/storUppTotal_annuaAvg_*.nc                                 merged/storUppTotal_annuaAvg_output.nc                 &
cdo mergetime */global/netcdf/storLowTotal_annuaAvg_*.nc                                 merged/storLowTotal_annuaAvg_output.nc                 &
wait
