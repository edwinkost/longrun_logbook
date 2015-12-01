
require(ncdf4)

tws = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/TWS.nc")
swt = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/surfaceWaterStorage_annuaAvg_output.nc")
snw = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/snowCoverSWE_annuaAvg_output.nc")
snf = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/snowFreeWater_annuaAvg_output.nc")
int = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/interceptStor_annuaAvg_output.nc")
top = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/topWaterLayer_annuaAvg_output.nc")
upp = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/storUppTotal_annuaAvg_output.nc")
low = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/storLowTotal_annuaAvg_output.nc")
gwt = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1950/1950_to_2010/groundwaterThicknessEstimate_annuaAvg_output.nc")

starting_year = 1950

time = ncvar_get(tws, "time")

TWS = rep(NA, length(time))
SWT = rep(NA, length(time))
SNW = rep(NA, length(time))

for (i in 1:length(time)){


TWS[i] = sum(ncvar_get(tws, "TWS")[,,i], na.rm = T)
SWT[i] = sum(ncvar_get(swt, "surface_water_storage")[,,i], na.rm = T)
SNW[i] = sum(ncvar_get(snw, "snow_water_equivalent")[,,i], na.rm = T)
SNF[i] = sum(ncvar_get(snf, "snow_free_water")[,,i], na.rm = T)
INT[i] = sum(ncvar_get(int, "interceptiom_storage")[,,i], na.rm = T)
TOP[i] = sum(ncvar_get(top, "top_water_layer")[,,i], na.rm = T)
UPP[i] = sum(ncvar_get(upp, "upper_soil_storage")[,,i], na.rm = T)
LOW[i] = sum(ncvar_get(low, "lower_soil_storage")[,,i], na.rm = T)
GWT[i] = sum(ncvar_get(gwt, "groundwater_thickness_estimate")[,,i], na.rm = T)

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


