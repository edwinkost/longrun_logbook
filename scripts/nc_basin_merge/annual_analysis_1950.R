
require(ncdf4)

tws_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/TWS.nc")
swt_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/surfaceWaterStorage_annuaAvg_output.nc")
snw_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/snowCoverSWE_annuaAvg_output.nc")
snf_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/snowFreeWater_annuaAvg_output.nc")
int_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/interceptStor_annuaAvg_output.nc")
top_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/topWaterLayer_annuaAvg_output.nc")
upp_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/storUppTotal_annuaAvg_output.nc")
low_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/storLowTotal_annuaAvg_output.nc")
gwt_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1950/1950_to_2010/groundwaterThicknessEstimate_annuaAvg_output.nc")

starting_year = 1950

time = ncvar_get(tws, "time")

TWS = rep(NA, length(time))
SWT = rep(NA, length(time))
SNW = rep(NA, length(time))
SNF = rep(NA, length(time))
INT = rep(NA, length(time))
TOP = rep(NA, length(time))
UPP = rep(NA, length(time))
LOW = rep(NA, length(time))
GWT = rep(NA, length(time))

for (i in 1:length(time)){


TWS[i] = sum(ncvar_get(tws_file, "total_thickness_of_water_storage")[,,i], na.rm = T)
SWT[i] = sum(ncvar_get(swt_file, "surface_water_storage")[,,i], na.rm = T)
SNW[i] = sum(ncvar_get(snw_file, "snow_water_equivalent")[,,i], na.rm = T)
SNF[i] = sum(ncvar_get(snf_file, "snow_free_water")[,,i], na.rm = T)
INT[i] = sum(ncvar_get(int_file, "interceptiom_storage")[,,i], na.rm = T)
TOP[i] = sum(ncvar_get(top_file, "top_water_layer")[,,i], na.rm = T)
UPP[i] = sum(ncvar_get(upp_file, "upper_soil_storage")[,,i], na.rm = T)
LOW[i] = sum(ncvar_get(low_file, "lower_soil_storage")[,,i], na.rm = T)
GWT[i] = sum(ncvar_get(gwt_file, "groundwater_thickness_estimate")[,,i], na.rm = T)

print(i)
print(paste("TWS : ",TWS[i]))
print(paste("SWT : ",SWT[i]))
print(paste("SNW : ",SNW[i]))
print(paste("SNF : ",SNF[i]))
print(paste("INT : ",INT[i]))
print(paste("TOP : ",TOP[i]))
print(paste("UPP : ",UPP[i]))
print(paste("LOW : ",LOW[i]))
print(paste("GWT : ",GWT[i]))

print("")

}

year = starting_year-1+seq(1,length(time),1)

plot(year, TWS)
lines(year, TWS)


