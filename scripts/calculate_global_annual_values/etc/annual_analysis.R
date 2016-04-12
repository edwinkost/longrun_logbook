
# You have to define the following variables
# - output_folder
# - starting_year
# - starting_year_for_analysis 

require(ncdf4)

pre_file = nc_open( paste( output_folder, "/precipitation_annuaTot_output.nc"               , sep = "") )
eva_file = nc_open( paste( output_folder, "/totalEvaporation_annuaTot_output.nc"            , sep = "") )
run_file = nc_open( paste( output_folder, "/totalRunoff_annuaTot_output.nc"                 , sep = "") )

snw_file = nc_open( paste( output_folder, "/snowCoverSWE_annuaAvg_output.nc"                , sep = "") )
snf_file = nc_open( paste( output_folder, "/snowFreeWater_annuaAvg_output.nc"               , sep = "") )

swt_file = nc_open( paste( output_folder, "/surfaceWaterStorage_annuaAvg_output.nc"         , sep = "") )
top_file = nc_open( paste( output_folder, "/topWaterLayer_annuaAvg_output.nc"               , sep = "") )

int_file = nc_open( paste( output_folder, "/interceptStor_annuaAvg_output.nc"               , sep = "") )

upp_file = nc_open( paste( output_folder, "/storUppTotal_annuaAvg_output.nc"                , sep = "") )
low_file = nc_open( paste( output_folder, "/storLowTotal_annuaAvg_output.nc"                , sep = "") )

gwt_file = nc_open( paste( output_folder, "/groundwaterThicknessEstimate_annuaAvg_output.nc", sep = "") )

# time values 
time = ncvar_get(swt_file, "time")

# years used in the model
year = seq(starting_year, 2010, 1)

PRE = rep(NA, length(time))
EVA = rep(NA, length(time))
RUN = rep(NA, length(time))

SNW = rep(NA, length(time))
SNF = rep(NA, length(time))

SWT = rep(NA, length(time))
TOP = rep(NA, length(time))

INT = rep(NA, length(time))

UPP = rep(NA, length(time))
LOW = rep(NA, length(time))

GWT = rep(NA, length(time))

# cell area 
cell_area_file = nc_open("/home/edwin/data/cell_area_nc/cellsize05min.correct.used.nc")
cell_area = ncvar_get(cell_area_file, "Band1")[,]
nc_close(cell_area_file)

for (i in 1:length(time)){

PRE_field = ncvar_get(pre_file, "precipitation"                   , c(1, 1, i), c(-1, -1, 1))
EVA_field = ncvar_get(eva_file, "total_evaporation"               , c(1, 1, i), c(-1, -1, 1))
RUN_field = ncvar_get(run_file, "total_runoff"                    , c(1, 1, i), c(-1, -1, 1))

SNW_field = ncvar_get(snw_file, "snow_water_equivalent"           , c(1, 1, i), c(-1, -1, 1))
SNF_field = ncvar_get(snf_file, "snow_free_water"                 , c(1, 1, i), c(-1, -1, 1))

SWT_field = ncvar_get(swt_file, "surface_water_storage"           , c(1, 1, i), c(-1, -1, 1))
TOP_field = ncvar_get(top_file, "top_water_layer"                 , c(1, 1, i), c(-1, -1, 1))

INT_field = ncvar_get(int_file, "interception_storage"            , c(1, 1, i), c(-1, -1, 1))

UPP_field = ncvar_get(upp_file, "upper_soil_storage"              , c(1, 1, i), c(-1, -1, 1))
LOW_field = ncvar_get(low_file, "lower_soil_storage"              , c(1, 1, i), c(-1, -1, 1))

GWT_field = ncvar_get(gwt_file, "groundwater_thickness_estimate"  , c(1, 1, i), c(-1, -1, 1))

# ignore zero values for some stores 
SWT_field[which(SWT_field < 0.0)] = 0.0

# calculate the global volumes (unit: km3)
PRE[i] = sum( PRE_field  * cell_area, na.rm = T)/10^9
EVA[i] = sum( EVA_field  * cell_area, na.rm = T)/10^9
RUN[i] = sum( RUN_field  * cell_area, na.rm = T)/10^9

SNW[i] = sum( SNW_field  * cell_area, na.rm = T)/10^9
SNF[i] = sum( SNF_field  * cell_area, na.rm = T)/10^9

SWT[i] = sum( SWT_field  * cell_area, na.rm = T)/10^9
TOP[i] = sum( TOP_field  * cell_area, na.rm = T)/10^9

INT[i] = sum( INT_field  * cell_area, na.rm = T)/10^9

UPP[i] = sum( UPP_field  * cell_area, na.rm = T)/10^9
LOW[i] = sum( LOW_field  * cell_area, na.rm = T)/10^9

GWT[i] = sum( GWT_field  * cell_area, na.rm = T)/10^9

print(i)
print(year[i])
print(paste("PRE : ",PRE[i]))
print(paste("EVA : ",EVA[i]))
print(paste("RUN : ",RUN[i]))

print(paste("SNW : ",SNW[i]))
print(paste("SNF : ",SNF[i]))

print(paste("SWT : ",SWT[i]))
print(paste("TOP : ",TOP[i]))

print(paste("INT : ",INT[i]))

print(paste("UPP : ",UPP[i]))
print(paste("LOW : ",LOW[i]))

print(paste("GWT : ",GWT[i]))

print("")

}

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
