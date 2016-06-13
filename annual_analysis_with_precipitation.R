
require(ncdf4)
require(ggplot2)
require(grid)

#~ # activating x11 (I don't think this is necessary)
#~ x11()

# reading system arguments:
args <- commandArgs()

# pcrglobwb output folder that will be analyzed:
#~ pcrglobwb_output_folder <- "/scratch-shared/edwin/05min_runs_may_2016/pcrglobwb_modflow_from_1901_6LCs_adjusted_ksat/adjusted_ksat/"
pcrglobwb_output_folder <- args[4]

# type of runs
type_of_run <- "non-natural"
type_of_run <- args[5]

# copy the script to the pcrglobwb_output_folder
cmd_line = paste('cp *.R '  , pcrglobwb_output_folder)
system(cmd_line)
cmd_line = paste('cp *.sh ' , pcrglobwb_output_folder)
system(cmd_line)

# with or without merging
with_merging_option = "no_merging"
with_merging_option = as.character(args[6])
with_merging <- TRUE
if (with_merging_option == "no_merging") {with_merging <- FALSE}

# years used in the model
starting_year           <- 1901
starting_year           <- as.integer(args[7])
end_year                <- 2010
end_year                <- as.integer(args[8])
year = seq(starting_year, end_year, 1)

# with or without modflow option
with_modflow_option = "with_modflow"
with_modflow_option = as.character(args[9])
with_modflow <- TRUE
if (with_modflow_option == "no_modflow") {with_modflow <- FALSE}

# change the current working directory to pcrglobwb_output_folder
setwd(pcrglobwb_output_folder)
# - and making the folders merged and analysis
system('mkdir merged')
system('mkdir analysis')

# output folder that contains the merged netcdf files
merged_pcrglobwb_output_folder <- paste(pcrglobwb_output_folder,"/merged/"  , sep = "")

# output folder for this analysis:
analysis_output_folder         <- paste(pcrglobwb_output_folder,"/analysis/", sep = "")

# running the merging commands
if (with_merging == TRUE) {
print("=====================================")
print("=====================================")
print("Merging netcdf files in progress ...")
print("=====================================")
print("=====================================")

if (with_modflow == TRUE) {
system('bash merging_annual_files.sh')
} else {
system('bash merging_annual_files_without_modflow.sh')
}
}


# opening netcdf files:
pre_file = nc_open( paste(merged_pcrglobwb_output_folder, "/precipitation_annuaTot_output.nc"               , sep = "") )
eva_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalEvaporation_annuaTot_output.nc"            , sep = "") )
run_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalRunoff_annuaTot_output.nc"                 , sep = "") )
rch_file = nc_open( paste(merged_pcrglobwb_output_folder, "/gwRecharge_annuaTot_output.nc"                  , sep = "") )
snw_file = nc_open( paste(merged_pcrglobwb_output_folder, "/snowCoverSWE_annuaAvg_output.nc"                , sep = "") )
snf_file = nc_open( paste(merged_pcrglobwb_output_folder, "/snowFreeWater_annuaAvg_output.nc"               , sep = "") )
swt_file = nc_open( paste(merged_pcrglobwb_output_folder, "/surfaceWaterStorage_annuaAvg_output.nc"         , sep = "") )
top_file = nc_open( paste(merged_pcrglobwb_output_folder, "/topWaterLayer_annuaAvg_output.nc"               , sep = "") )
int_file = nc_open( paste(merged_pcrglobwb_output_folder, "/interceptStor_annuaAvg_output.nc"               , sep = "") )
upp_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storUppTotal_annuaAvg_output.nc"                , sep = "") )
low_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storLowTotal_annuaAvg_output.nc"                , sep = "") )
if (type_of_run == "non-natural") {
wtd_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalAbstraction_annuaTot_output.nc"            , sep = "") )
gwa_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalGroundwaterAbstraction_annuaTot_output.nc" , sep = "") )
nir_file = nc_open( paste(merged_pcrglobwb_output_folder, "/nonIrrGrossDemand_annuaTot_output.nc"           , sep = "") )
}

if (with_modflow == TRUE) {
gwt_file = nc_open( paste(merged_pcrglobwb_output_folder, "/groundwaterThicknessEstimate_annuaAvg_output.nc", sep = "") )
} else {
gwt_active_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storGroundwater_annuaAvg_output.nc"      , sep = "") )
gwt_fossil_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storGroundwaterFossil_annuaAvg_output.nc", sep = "") )
}


###################################################################################################################
# creating empty arrays (annual resolution) 

# - precipitation, evaporation and runoff
precipitation             = rep(NA, length(time))
evaporation               = rep(NA, length(time))
runoff                    = rep(NA, length(time))

# - recharge, withdrawal, groundwater withdrawal, irrigation and non irrigation withdrawal
recharge                  = rep(NA, length(time))
total_withdrawal          = rep(NA, length(time))
groundwater_withdrawal    = rep(NA, length(time))
non_irrigation_withdrawal = rep(NA, length(time))       # domestic, industrial and livestock
irrigation_withdrawal     = rep(NA, length(time))       # irrigation only (without livestock)

# - storage terms
snow_water_equivalent     = rep(NA, length(time))
free_water_above_snow     = rep(NA, length(time))
surface_water_storage     = rep(NA, length(time))
top_water_layer           = rep(NA, length(time))
interception_storage      = rep(NA, length(time))
upper_soil_storage        = rep(NA, length(time))
lower_soil_storage        = rep(NA, length(time))
groundwater_storage       = rep(NA, length(time))
###################################################################################################################


# cell area 
cell_area_file = nc_open("/home/edwin/data/cell_area_nc/cellsize05min.correct.used.nc")
cell_area = ncvar_get(cell_area_file, "Band1")[,]
nc_close(cell_area_file)

# time values 
time = ncvar_get(swt_file, "time"); length(time)


for (i in 1:length(time)){


pre_field = ncvar_get(pre_file, "precipitation"                   , c(1, 1, i), c(-1, -1, 1))
eva_field = ncvar_get(eva_file, "total_evaporation"               , c(1, 1, i), c(-1, -1, 1))
run_field = ncvar_get(run_file, "total_runoff"                    , c(1, 1, i), c(-1, -1, 1))

rch_field = ncvar_get(rch_file, "groundwater_recharge"            , c(1, 1, i), c(-1, -1, 1))
snw_field = ncvar_get(snw_file, "snow_water_equivalent"           , c(1, 1, i), c(-1, -1, 1))
snf_field = ncvar_get(snf_file, "snow_free_water"                 , c(1, 1, i), c(-1, -1, 1))

swt_field = ncvar_get(swt_file, "surface_water_storage"           , c(1, 1, i), c(-1, -1, 1))
top_field = ncvar_get(top_file, "top_water_layer"                 , c(1, 1, i), c(-1, -1, 1))

int_field = ncvar_get(int_file, "interception_storage"            , c(1, 1, i), c(-1, -1, 1))

upp_field = ncvar_get(upp_file, "upper_soil_storage"              , c(1, 1, i), c(-1, -1, 1))
low_field = ncvar_get(low_file, "lower_soil_storage"              , c(1, 1, i), c(-1, -1, 1))

if (type_of_run == "non-natural") {
wtd_field = ncvar_get(wtd_file, "total_abstraction"               , c(1, 1, i), c(-1, -1, 1))
gwa_field = ncvar_get(gwa_file, "total_groundwater_abstraction"   , c(1, 1, i), c(-1, -1, 1))
nir_field = ncvar_get(nir_file, "non_irrigation_gross_demand"     , c(1, 1, i), c(-1, -1, 1))
}

if (with_modflow == TRUE) {
gwt_field = ncvar_get(gwt_file, "groundwater_thickness_estimate"  , c(1, 1, i), c(-1, -1, 1))
} else {
gwt_active_field = ncvar_get(gwt_active_file, "groundwater_storage"         , c(1, 1, i), c(-1, -1, 1))
gwt_fossil_field = ncvar_get(gwt_fossil_file, "fossil_groundwater_storage"  , c(1, 1, i), c(-1, -1, 1))
gwt_field = gwt_active_field + gwt_fossil_field

}


#~ # Ignore zero values for surface water store.                     
#~ swt_field_original = swt_field
#~ swt_field[which(swt_field < 0.0)] = 0.0
#~ # TODO: # We have to solve this issue. 
#~ # Possible solutions: 
#~ # 1) using kinematic wave; 
#~ # 2) try to use drain package for small streams; or 
#~ # 3) raise bottom elevations if there are only limited water left at streams. 
#~ # 4) Ask Oliver to obtain the total baseflow for the entire stress period.

# Note: Negative groundwater storage is possible. 
# TODO: Check this assumption.                       

# calculate the global values (unit: km3)
precipitation[i]              = sum( pre_field  * cell_area, na.rm = T)/10^9
evaporation[i]                = sum( eva_field  * cell_area, na.rm = T)/10^9
runoff[i]                     = sum( run_field  * cell_area, na.rm = T)/10^9
recharge[i]                   = sum( rch_field  * cell_area, na.rm = T)/10^9
snow_water_equivalent[i]      = sum( snw_field  * cell_area, na.rm = T)/10^9
free_water_above_snow[i]      = sum( snf_field  * cell_area, na.rm = T)/10^9
surface_water_storage[i]      = sum( swt_field  * cell_area, na.rm = T)/10^9
top_water_layer[i]            = sum( top_field  * cell_area, na.rm = T)/10^9
interception_storage[i]       = sum( int_field  * cell_area, na.rm = T)/10^9
upper_soil_storage[i]         = sum( upp_field  * cell_area, na.rm = T)/10^9
lower_soil_storage[i]         = sum( low_field  * cell_area, na.rm = T)/10^9
groundwater_storage[i]        = sum( gwt_field  * cell_area, na.rm = T)/10^9


total_withdrawal[i]           = 0.0
groundwater_withdrawal[i]     = 0.0
non_irrigation_withdrawal[i]  = 0.0
irrigation_withdrawal[i]      = 0.0

if (type_of_run == "non-natural") {
total_withdrawal[i]           = sum( wtd_field  * cell_area, na.rm = T)/10^9
groundwater_withdrawal[i]     = sum( gwa_field  * cell_area, na.rm = T)/10^9
non_irrigation_withdrawal[i]  = sum( nir_field  * cell_area, na.rm = T)/10^9    
irrigation_withdrawal[i]      = total_withdrawal[i] - non_irrigation_withdrawal[i]
}

print("")
print(i)
print(year[i])
print(paste("PRE : ", precipitation[i]            ))
print(paste("EVA : ", evaporation[i]              ))
print(paste("RUN : ", runoff[i]                   ))
print(paste("RCH : ", recharge[i]                 ))
print(paste("WTD : ", total_withdrawal[i]         ))
print(paste("GWA : ", groundwater_withdrawal[i]   ))
print(paste("NIR : ", non_irrigation_withdrawal[i]))
print(paste("IRR : ", irrigation_withdrawal[i]    ))
print(paste("SNW : ", snow_water_equivalent[i]    ))
print(paste("SNF : ", free_water_above_snow[i]    ))
print(paste("SWT : ", surface_water_storage[i]    ))
print(paste("TOP : ", top_water_layer[i]          ))
print(paste("INT : ", interception_storage[i]     ))
print(paste("UPP : ", upper_soil_storage[i]       ))
print(paste("LOW : ", lower_soil_storage[i]       ))
print(paste("GWT : ", groundwater_storage[i]      ))
print("")

if (i > 1) {
print(paste("GWT changes: ", groundwater_storage[i] - groundwater_storage[i-1] ))
}

}


# index of the starting year
analysis_starting_year = starting_year + 0
sta = which(year == analysis_starting_year)
# index of the last year
las = length(year)

# correcting snow and snow free water (due to the accumulation in glacier and ice sheet regions)
snw_lm_model = lm(snow_water_equivalent ~ year)
snf_lm_model = lm(free_water_above_snow ~ year)
snow_water_equivalent_corrected = snow_water_equivalent - (snw_lm_model$coefficients[1] + snw_lm_model$coefficients[2]*year)
free_water_above_snow_corrected = free_water_above_snow - (snf_lm_model$coefficients[1] + snf_lm_model$coefficients[2]*year)

# including the starting snow and snow free water
snow_water_equivalent_corrected = snow_water_equivalent[1] + snow_water_equivalent_corrected
free_water_above_snow_corrected = free_water_above_snow[1] + free_water_above_snow_corrected

# the corrected total water storage
total_water_storage_corrected = surface_water_storage + 
                                snow_water_equivalent_corrected + 
                                free_water_above_snow_corrected + 
                                interception_storage + 
                                top_water_layer + 
                                upper_soil_storage + 
                                lower_soil_storage + 
                                groundwater_storage
plot(year[sta:las], total_water_storage_corrected[sta:las])  ; lines(year[sta:las], total_water_storage_corrected[sta:las])
plot(year[sta:las], groundwater_storage[sta:las]);             lines(year[sta:las], groundwater_storage[sta:las])
plot(year[sta:las], surface_water_storage[sta:las]);           lines(year[sta:las], surface_water_storage[sta:las])
plot(year[sta:las], snow_water_equivalent_corrected[sta:las]); lines(year[sta:las], snow_water_equivalent_corrected[sta:las])
plot(year[sta:las], free_water_above_snow_corrected[sta:las]); lines(year[sta:las], free_water_above_snow_corrected[sta:las])


# a complete and raw data frame
data_frame_raw_complete = data.frame(year,
precipitation,
evaporation,
runoff,
recharge,
total_withdrawal,      
groundwater_withdrawal,
non_irrigation_withdrawal,
irrigation_withdrawal,
snow_water_equivalent, 
free_water_above_snow, 
surface_water_storage, 
top_water_layer,       
interception_storage,  
upper_soil_storage,    
lower_soil_storage,    
groundwater_storage,   
snow_water_equivalent_corrected,
free_water_above_snow_corrected)
file_name = paste(analysis_output_folder, "/table_raw_complete_from_", starting_year, ".txt",sep ="")
write.table(data_frame_raw_complete, file_name, sep = ";", row.names = FALSE)


# integrating to several storages
total_water_storage = total_water_storage_corrected
surface_water       = surface_water_storage + top_water_layer
snow                = snow_water_equivalent_corrected + free_water_above_snow_corrected ; plot(year[sta:las], snow[sta:las]); lines(year[sta:las], snow[sta:las])
interception        = interception_storage
soil_moisture       = upper_soil_storage + lower_soil_storage
groundwater         = groundwater_storage


# identify mean values (only using a specific period of interest
mean_total_water_storage = mean(total_water_storage[sta:las])
mean_surface_water       = mean(surface_water      [sta:las])
mean_snow                = mean(snow               [sta:las])
mean_interception        = mean(interception       [sta:las])
mean_soil_moisture       = mean(soil_moisture      [sta:las])
mean_groundwater         = mean(groundwater        [sta:las])


# identiy the maximum amplitude from the mean values (for making charts) 
amplitude = max( 
                    mean_total_water_storage - min(total_water_storage[sta:las]), max(total_water_storage[sta:las]) - mean_total_water_storage,
                    mean_surface_water       - min(surface_water[sta:las])      , max(surface_water[sta:las])       - mean_surface_water,
                    mean_groundwater         - min(groundwater[sta:las])        , max(groundwater[sta:las])         - mean_groundwater,
                0.0)

# making data frame for the absolute value and write it to file
data_frame_absolute = data.frame(year, total_water_storage, surface_water, snow, interception, soil_moisture, groundwater)
file_name = paste(analysis_output_folder, "absolute_from_", starting_year, ".txt",sep ="")
write.table(data_frame_absolute, file_name, sep = ";", row.names = FALSE)

# calculating anomaly values
total_water_storage_anomaly = total_water_storage - mean_total_water_storage
surface_water_anomaly       = surface_water       - mean_surface_water      
snow_anomaly                = snow                - mean_snow               ; plot(year[sta:las], snow_anomaly[sta:las]); lines(year[sta:las], snow_anomaly[sta:las])  
interception_anomaly        = interception        - mean_interception       
soil_moisture_anomaly       = soil_moisture       - mean_soil_moisture      
groundwater_anomaly         = groundwater         - mean_groundwater        

# making data frame for the anomaly value
data_frame_anomaly = data.frame(year, total_water_storage_anomaly, surface_water_anomaly, snow_anomaly, interception_anomaly, soil_moisture_anomaly, groundwater_anomaly)


# making the anomaly charts
tws_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = total_water_storage_anomaly)) + geom_line() + scale_x_continuous(limits = c(1900, 2015))
swt_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = surface_water_anomaly))       + geom_line() + scale_x_continuous(limits = c(1900, 2015))
snw_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = snow_anomaly))                + geom_line() + scale_x_continuous(limits = c(1900, 2015))
int_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = interception_anomaly))        + geom_line() + scale_x_continuous(limits = c(1900, 2015))
soi_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = soil_moisture_anomaly))       + geom_line() + scale_x_continuous(limits = c(1900, 2015))
gwt_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = groundwater_anomaly))         + geom_line() + scale_x_continuous(limits = c(1900, 2015))
# setting y axes
tws_anomaly_chart <- tws_anomaly_chart + scale_y_continuous(limits = c(- amplitude, amplitude))
swt_anomaly_chart <- swt_anomaly_chart + scale_y_continuous(limits = c(- amplitude, amplitude))
snw_anomaly_chart <- snw_anomaly_chart + scale_y_continuous(limits = c(- amplitude, amplitude))
int_anomaly_chart <- int_anomaly_chart + scale_y_continuous(limits = c(- amplitude, amplitude))
soi_anomaly_chart <- soi_anomaly_chart + scale_y_continuous(limits = c(- amplitude, amplitude))
gwt_anomaly_chart <- gwt_anomaly_chart + scale_y_continuous(limits = c(- amplitude, amplitude))



###########################################################################################################################
# plotting the anomaly charts - this is for one slide
gA <- ggplotGrob(tws_anomaly_chart)
gB <- ggplotGrob(swt_anomaly_chart)
gC <- ggplotGrob(gwt_anomaly_chart)
gD <- ggplotGrob(snw_anomaly_chart)
gE <- ggplotGrob(int_anomaly_chart)
gF <- ggplotGrob(soi_anomaly_chart)
g = cbind(rbind(gA, gB, gC, size = "first"), rbind(gD, gE, gF, size = "last"), size = "first")
file_name = paste(analysis_output_folder, "/all_storage_anomalies_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################


# making data frame for all fluxes
data_frame_flux = data.frame(precipitation, evaporation, runoff, recharge, total_withdrawal, groundwater_withdrawal, non_irrigation_withdrawal, irrigation_withdrawal)
file_name = paste(analysis_output_folder, "fluxes_from_", starting_year, ".txt",sep ="")
write.table(data_frame_flux, file_name, sep = ";", row.names = FALSE)


# calculate mean values of fluxes
mean_precipitation = mean(precipitation[sta:las])
mean_evaporation   = mean(evaporation[sta:las])
mean_runoff        = mean(runoff[sta:las])

# calculate anomaly fluxes and making data frame for anomaly
precipitation_anomaly = precipitation - mean_precipitation
evaporation_anomaly   = evaporation   - mean_evaporation  
runoff_anomaly        = runoff        - mean_runoff       
data_frame_flux_anomaly = data.frame(year, precipitation_anomaly, evaporation_anomaly, runoff_anomaly)
file_name = paste(analysis_output_folder, "/anomaly_fluxes_from_", starting_year, ".txt",sep ="")
write.table(data_frame_flux_anomaly, file_name, sep = ";", row.names = FALSE)

# amplitude for fluxes (for the bar plots)
amplitude_precipitation = max(mean_precipitation - min(precipitation[sta:las]), max(precipitation[sta:las]) - mean_precipitation) 
amplitude_evaporation   = max(mean_evaporation   - min(evaporation[sta:las])  , max(evaporation[sta:las])   - mean_evaporation) 
amplitude_runoff        = max(mean_runoff        - min(runoff[sta:las])       , max(runoff[sta:las])        - mean_runoff) 

# making barplot for fluxes
pre_anomaly_bar_plot = ggplot(data = data_frame_anomaly, aes(x = year, y = precipitation_anomaly)) + geom_bar(stat = "identity", position = "identity")
eva_anomaly_bar_plot = ggplot(data = data_frame_anomaly, aes(x = year, y = evaporation_anomaly  )) + geom_bar(stat = "identity", position = "identity")
run_anomaly_bar_plot = ggplot(data = data_frame_anomaly, aes(x = year, y = runoff_anomaly       )) + geom_bar(stat = "identity", position = "identity")
# setting x and y axes
pre_anomaly_bar_plot <- pre_anomaly_bar_plot + scale_y_continuous(limits = c(- amplitude_precipitation, amplitude_precipitation)) + scale_x_continuous(limits = c(1900, 2015))
eva_anomaly_bar_plot <- eva_anomaly_bar_plot + scale_y_continuous(limits = c(- amplitude_evaporation  , amplitude_evaporation  )) + scale_x_continuous(limits = c(1900, 2015))
run_anomaly_bar_plot <- run_anomaly_bar_plot + scale_y_continuous(limits = c(- amplitude_runoff       , amplitude_runoff       )) + scale_x_continuous(limits = c(1900, 2015))

# making absolute storage plots for of total water, surface water and groundwater
total_water_storage_chart <- ggplot(data = data_frame_absolute, aes(x = year, y = total_water_storage)) + geom_line() + scale_x_continuous(limits = c(1900, 2015))
surface_water_chart       <- ggplot(data = data_frame_absolute, aes(x = year, y = surface_water))       + geom_line() + scale_x_continuous(limits = c(1900, 2015))
groundwater_chart         <- ggplot(data = data_frame_absolute, aes(x = year, y = groundwater))         + geom_line() + scale_x_continuous(limits = c(1900, 2015))
# setting y axes
total_water_storage_chart <- total_water_storage_chart + scale_y_continuous(limits = c(mean_total_water_storage - amplitude, mean_total_water_storage + amplitude)) 
surface_water_chart       <- surface_water_chart       + scale_y_continuous(limits = c(mean_surface_water       - amplitude, mean_surface_water       + amplitude)) 
groundwater_chart         <- groundwater_chart         + scale_y_continuous(limits = c(mean_groundwater         - amplitude, mean_groundwater         + amplitude)) 

# making plots for precipitation, evaporation and runoff
precipitation_chart  <- ggplot(data = data_frame_absolute, aes(x = year, y = precipitation         )) + geom_line() + scale_x_continuous(limits = c(1900, 2015))
evaporation_chart    <- ggplot(data = data_frame_absolute, aes(x = year, y = evaporation           )) + geom_line() + scale_x_continuous(limits = c(1900, 2015))
runoff_chart         <- ggplot(data = data_frame_absolute, aes(x = year, y = runoff                )) + geom_line() + scale_x_continuous(limits = c(1900, 2015))

# making plots for groundwater recharge, total withdrawal and groundwater abstraction
recharge_chart       <- ggplot(data = data_frame_absolute, aes(x = year, y = recharge              )) + geom_line() + scale_x_continuous(limits = c(1900, 2015))
tot_withdrawal_chart <- ggplot(data = data_frame_absolute, aes(x = year, y = total_withdrawal      )) + geom_line() + scale_x_continuous(limits = c(1900, 2015))
gwt_withdrawal_chart <- ggplot(data = data_frame_absolute, aes(x = year, y = groundwater_withdrawal)) + geom_line() + scale_x_continuous(limits = c(1900, 2015))


###########################################################################################################################
# ploting storages and anomaly fluxes of precipitation, surface water, and groundwater
gA <- ggplotGrob(total_water_storage_chart)
gB <- ggplotGrob(surface_water_chart)
gC <- ggplotGrob(groundwater_chart)
gD <- ggplotGrob(pre_anomaly_bar_plot)
gE <- ggplotGrob(eva_anomaly_bar_plot)
gF <- ggplotGrob(run_anomaly_bar_plot)
file_name = paste(analysis_output_folder, "/storages_and_anomaly_fluxes_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
g = cbind(rbind(gA, gB, gC, size = "first"), rbind(gD, gE, gF, size = "first"), size = "first")
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################


###########################################################################################################################
# ploting storages and fluxes of recharge, total withdrawal and groundwater withdrawal
gG <- ggplotGrob(recharge_chart)
gH <- ggplotGrob(tot_withdrawal_chart)
gI <- ggplotGrob(gwt_withdrawal_chart)
file_name = paste(analysis_output_folder, "/storages_recharge_withdrawal_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
g = cbind(rbind(gA, gB, gC, size = "first"), rbind(gG, gH, gI, size = "first"), size = "first")
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################

###########################################################################################################################
# ploting storages and fluxes of precipitation, evaporation and runoff
gJ <- ggplotGrob(precipitation_chart)
gK <- ggplotGrob(evaporation_chart)
gL <- ggplotGrob(runoff_chart)
file_name = paste(analysis_output_folder, "/storages_fluxes_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
g = cbind(rbind(gA, gB, gC, size = "first"), rbind(gJ, gK, gL, size = "first"), size = "first")
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################
