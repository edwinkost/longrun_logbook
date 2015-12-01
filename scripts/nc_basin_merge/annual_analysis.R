
require(ncdf4)

tws = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1901/1901_to_2010/totalWaterStorageThickness_annuaAvg_output.nc")
swt = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1901/1901_to_2010/surfaceWaterStorage_annuaAvg_output.nc")
snw = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_only_from_1901/1901_to_2010/snowCoverSWE_annuaAvg_output.nc")

starting_year = 1901

time = ncvar_get(tws, "time")

TWS = rep(NA, length(time))
SWT = rep(NA, length(time))
SNW = rep(NA, length(time))

for (i in 1:length(time)){


TWS[i] = sum(ncvar_get(tws, "total_thickness_of_water_storage")[,,i], na.rm = T)
SWT[i] = sum(ncvar_get(swt, "surface_water_storage")[,,i], na.rm = T)
SNW[i] = sum(ncvar_get(snw, "snow_water_equivalent")[,,i], na.rm = T)

print(i)
print(TWS[i])

print(i)
print(SWT[i])

print(i)
print(SNW[i])

}

year = starting_year-1+seq(1,length(time),1)

plot(year, TWS)
lines(year, TWS)


