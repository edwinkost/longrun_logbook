
require(ncdf4)

swt_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/surfaceWaterStorage_annuaAvg_output.nc")
snw_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/snowCoverSWE_annuaAvg_output.nc")
snf_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/snowFreeWater_annuaAvg_output.nc")
int_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/interceptStor_annuaAvg_output.nc")
top_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/topWaterLayer_annuaAvg_output.nc")
upp_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/storUppTotal_annuaAvg_output.nc")
low_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/storLowTotal_annuaAvg_output.nc")
gwt_file = nc_open("/projects/0/dfguu/users/edwin/05min_runs_november_2015_merged/pcrglobwb_modflow_from_1925/1925_to_2010/groundwaterThicknessEstimate_annuaAvg_output.nc")

starting_year = 1925

# time values 
time = ncvar_get(swt_file, "time")

# years used in the model
year = seq(starting_year, 2010, 1)

SWT = rep(NA, length(time))
SNW = rep(NA, length(time))
SNF = rep(NA, length(time))
INT = rep(NA, length(time))
TOP = rep(NA, length(time))
UPP = rep(NA, length(time))
LOW = rep(NA, length(time))
GWT = rep(NA, length(time))

cell_area_file = nc_open("/home/edwin/data/cell_area_nc/cellsize05min.correct.used.nc")
cell_area = ncvar_get(cell_area_file, "Band1")[,]
nc_close(cell_area_file)

for (i in 1:length(time)){

SWT_field = ncvar_get(swt_file, "surface_water_storage"           , c(1, 1, i), c(-1, -1, 1))
SNW_field = ncvar_get(snw_file, "snow_water_equivalent"           , c(1, 1, i), c(-1, -1, 1))
SNF_field = ncvar_get(snf_file, "snow_free_water"                 , c(1, 1, i), c(-1, -1, 1))
INT_field = ncvar_get(int_file, "interception_storage"            , c(1, 1, i), c(-1, -1, 1))
TOP_field = ncvar_get(top_file, "top_water_layer"                 , c(1, 1, i), c(-1, -1, 1))
UPP_field = ncvar_get(upp_file, "upper_soil_storage"              , c(1, 1, i), c(-1, -1, 1))
LOW_field = ncvar_get(low_file, "lower_soil_storage"              , c(1, 1, i), c(-1, -1, 1))
GWT_field = ncvar_get(gwt_file, "groundwater_thickness_estimate"  , c(1, 1, i), c(-1, -1, 1))

# ignore zero values for some stores 
SWT_field[which(SWT_field < 0.0)] = 0.0
#~ GWT_field[which(GWT_field < 0.0)] = 0.0

#~ TWS[i] = sum( TWS_field  * cell_area, na.rm = T)
SWT[i] = sum( SWT_field  * cell_area, na.rm = T)
SNW[i] = sum( SNW_field  * cell_area, na.rm = T)
SNF[i] = sum( SNF_field  * cell_area, na.rm = T)
INT[i] = sum( INT_field  * cell_area, na.rm = T)
TOP[i] = sum( TOP_field  * cell_area, na.rm = T)
UPP[i] = sum( UPP_field  * cell_area, na.rm = T)
LOW[i] = sum( LOW_field  * cell_area, na.rm = T)
GWT[i] = sum( GWT_field  * cell_area, na.rm = T)

print(i)
print(year[i])
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

# assumption for the analysis starting_year
analysis_starting_year = 1960 # starting_year + 10
# index of the starting year
sta = which(year == analysis_starting_year)
# index of the starting year
las = length(year)

# correcting snow and snow free water (due to the accumulation in glacier and ice sheet regions)
snw_lm_model  = lm(SNW[sta:las] ~ year[sta:las])
snf_lm_model  = lm(SNF[sta:las] ~ year[sta:las])
SNW_corrected = SNW - (snw_lm_model$coefficients[1] + snw_lm_model$coefficients[2]*year)
SNF_corrected = SNF - (snf_lm_model$coefficients[1] + snf_lm_model$coefficients[2]*year)

# the corrected TWS
TWS_corrected = SWT + SNW_corrected + SNF_corrected + INT + TOP + UPP + LOW + GWT

plot(year[sta:las], TWS_corrected[sta:las]); lines(year[sta:las], TWS_corrected[sta:las])



