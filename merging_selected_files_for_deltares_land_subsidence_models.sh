
set -x

# monthly values merging
cdo -L -f nc4 -z zip -mergetime ../discharge_monthAvg_output_*.nc                                        discharge_monthAvg_output_1955-2010.nc                       &
cdo -L -f nc4 -z zip -mergetime ../gwRecharge_monthTot_output_*.nc                                       gwRecharge_monthTot_output_1955-2010.nc                      & 
cdo -L -f nc4 -z zip -mergetime ../totalGroundwaterAbstraction_monthTot_output_*.nc                      totalGroundwaterAbstraction_monthTot_output_1955-2010.nc     &
cdo -L -f nc4 -z zip -mergetime ../channelStorage_monthAvg_output_*.nc                                   channelStorage_monthAvg_output_1955-2010.nc                  &
wait                                                                                                     
                                                                                                         
# -for annual analysis                                                                                   
cdo -L -f nc4 -z zip -mergetime ../precipitation_annuaTot_output_*.nc                                    precipitation_annuaTot_output_1955-2010.nc                   &
cdo -L -f nc4 -z zip -mergetime ../totalEvaporation_annuaTot_output_*.nc                                 totalEvaporation_annuaTot_output_1955-2010.nc                &
cdo -L -f nc4 -z zip -mergetime ../totalRunoff_annuaTot_output_*.nc                                      totalRunoff_annuaTot_output_1955-2010.nc                     &
cdo -L -f nc4 -z zip -mergetime ../gwRecharge_annuaTot_output_*.nc                                       gwRecharge_annuaTot_output_1955-2010.nc                      & 
cdo -L -f nc4 -z zip -mergetime ../baseflow_annuaTot_output_*.nc                                         baseflow_annuaTot_output_1955-2010.nc                        &
                                                                                                         
cdo -L -f nc4 -z zip -mergetime ../totalAbstraction_annuaTot_output_*.nc                                 totalAbstraction_annuaTot_output_1955-2010.nc                &
cdo -L -f nc4 -z zip -mergetime ../desalinationAbstraction_annuaTot_output_*.nc                          desalinationAbstraction_annuaTot_output_1955-2010.nc         &
cdo -L -f nc4 -z zip -mergetime ../surfaceWaterAbstraction_annuaTot_output_*.nc                          surfaceWaterAbstraction_annuaTot_output_1955-2010.nc         &
cdo -L -f nc4 -z zip -mergetime ../nonFossilGroundwaterAbstraction_annuaTot_output_*.nc                  nonFossilGroundwaterAbstraction_annuaTot_output_1955-2010.nc &
cdo -L -f nc4 -z zip -mergetime ../fossilGroundwaterAbstraction_annuaTot_output_*.nc                     fossilGroundwaterAbstraction_annuaTot_output_1955-2010.nc    &
cdo -L -f nc4 -z zip -mergetime ../nonIrrGrossDemand_annuaTot_output_*.nc                                nonIrrGrossDemand_annuaTot_output_1955-2010.nc               &

cdo -L -f nc4 -z zip -mergetime ../snowCoverSWE_annuaAvg_output_*.nc                                     snowCoverSWE_annuaAvg_output_1955-2010.nc                    &
cdo -L -f nc4 -z zip -mergetime ../snowFreeWater_annuaAvg_output_*.nc                                    snowFreeWater_annuaAvg_output_1955-2010.nc                   &
cdo -L -f nc4 -z zip -mergetime ../surfaceWaterStorage_annuaAvg_output_*.nc                              surfaceWaterStorage_annuaAvg_output_1955-2010.nc             &
cdo -L -f nc4 -z zip -mergetime ../topWaterLayer_annuaAvg_output_*.nc                                    topWaterLayer_annuaAvg_output_1955-2010.nc                   &
cdo -L -f nc4 -z zip -mergetime ../interceptStor_annuaAvg_output_*.nc                                    interceptStor_annuaAvg_output_1955-2010.nc                   &
cdo -L -f nc4 -z zip -mergetime ../storUppTotal_annuaAvg_output_*.nc                                     storUppTotal_annuaAvg_output_1955-2010.nc                    &
cdo -L -f nc4 -z zip -mergetime ../storLowTotal_annuaAvg_output_*.nc                                     storLowTotal_annuaAvg_output_1955-2010.nc                    &
cdo -L -f nc4 -z zip -mergetime ../storGroundwater_annuaAvg_*.nc                                         storGroundwater_annuaAvg_output_1955-2010.nc                 &
cdo -L -f nc4 -z zip -mergetime ../storGroundwaterFossil_annuaAvg_*.nc                                   storGroundwaterFossil_annuaAvg_output_1955-2010.nc           &
cdo -L -f nc4 -z zip -mergetime ../totalWaterStorageThickness_annuaAvg_*.nc                              totalWaterStorageThickness_annuaAvg_output_1955-2010.nc      &
wait
