
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
pcrglobwb_output_folder <- "/projects/0/dfguu2/scratch/edwinhs/pcrglobwb2_output_05min_deltares_subsidence/natural_spinup/begin_from_1958/global/netcdf/merged_1958_to_2010/"

# years used in the model
starting_year           <- as.integer(args[5])
starting_year           <- 1958
end_year                <- as.integer(args[6])
end_year                <- 2010
year = seq(starting_year, end_year, 1)

# the first index for the year that will be analyzed - TODO: REMOVE THIS
first_index <- as.integer(args[7])
first_index <- 1

# output folder for this analysis
this_analysis_output_folder <- args[8]
this_analysis_output_folder <- "/projects/0/dfguu2/scratch/edwinhs/pcrglobwb2_output_05min_deltares_subsidence/natural_spinup/begin_from_1958/global/netcdf/merged_1958_to_2010/analysis/annual_fluxes/"
cmd_line = paste("mkdir -p ", this_analysis_output_folder, sep = "")
system(cmd_line)

# change the current working directory to pcrglobwb_output_folder
setwd(pcrglobwb_output_folder)

# output folder that contains the merged netcdf files
merged_pcrglobwb_output_folder <- pcrglobwb_output_folder


# opening netcdf files:
pre_file = nc_open( paste(merged_pcrglobwb_output_folder, "/precipitation_annuaTot_output_1958_to_2010.nc"               , sep = "") )
eva_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalEvaporation_annuaTot_output_1958_to_2010.nc"            , sep = "") )
run_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalRunoff_annuaTot_output_1958_to_2010.nc"                 , sep = "") )  # TODO: Also estimate it from the discharge
rch_file = nc_open( paste(merged_pcrglobwb_output_folder, "/gwRecharge_annuaTot_output_1958_to_2010.nc"                  , sep = "") )  # TODO: Also estimate baseflow.
snw_file = nc_open( paste(merged_pcrglobwb_output_folder, "/snowCoverSWE_annuaAvg_output_1958_to_2010.nc"                , sep = "") )
snf_file = nc_open( paste(merged_pcrglobwb_output_folder, "/snowFreeWater_annuaAvg_output_1958_to_2010.nc"               , sep = "") )
swt_file = nc_open( paste(merged_pcrglobwb_output_folder, "/surfaceWaterStorage_annuaAvg_output_1958_to_2010.nc"         , sep = "") )
top_file = nc_open( paste(merged_pcrglobwb_output_folder, "/topWaterLayer_annuaAvg_output_1958_to_2010.nc"               , sep = "") )
int_file = nc_open( paste(merged_pcrglobwb_output_folder, "/interceptStor_annuaAvg_output_1958_to_2010.nc"               , sep = "") )
upp_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storUppTotal_annuaAvg_output_1958_to_2010.nc"                , sep = "") )
low_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storLowTotal_annuaAvg_output_1958_to_2010.nc"                , sep = "") )

gwa_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storGroundwater_annuaAvg_output_1958_to_2010.nc"             , sep = "") )
gwf_file = nc_open( paste(merged_pcrglobwb_output_folder, "/storGroundwaterFossil_annuaAvg_output_1958_to_2010.nc"       , sep = "") )

tws_file = nc_open( paste(merged_pcrglobwb_output_folder, "/totalWaterStorageThickness_annuaAvg_output_1958_to_2010.nc"  , sep = "") )


###################################################################################################################
# creating empty arrays (annual resolution) 

# - precipitation, evaporation and runoff
precipitation             = rep(NA, length(year))
evaporation               = rep(NA, length(year))
runoff                    = rep(NA, length(year))

# - recharge
recharge                  = rep(NA, length(year))

# - storage terms
snow_water_equivalent     = rep(NA, length(year))
free_water_above_snow     = rep(NA, length(year))
surface_water_storage     = rep(NA, length(year))
top_water_layer           = rep(NA, length(year))
interception_storage      = rep(NA, length(year))
upper_soil_storage        = rep(NA, length(year))
lower_soil_storage        = rep(NA, length(year))
groundwater_storage       = rep(NA, length(year))
total_water_storage       = rep(NA, length(year))
###################################################################################################################


# cell area 
cell_area_file = nc_open("/home/edwin/data/cell_area_nc/cellsize05min.correct.used.nc")
cell_area = ncvar_get(cell_area_file, "Band1")[,]
nc_close(cell_area_file)

print(year)

for (i in 1:length(year)){

i_time = i + first_index - 1

print(i)

pre_field = ncvar_get(pre_file, "precipitation"                             , c(1, 1, i_time), c(-1, -1, 1))
eva_field = ncvar_get(eva_file, "total_evaporation"                         , c(1, 1, i_time), c(-1, -1, 1))
run_field = ncvar_get(run_file, "total_runoff"                              , c(1, 1, i_time), c(-1, -1, 1))
                                                                            
rch_field = ncvar_get(rch_file, "groundwater_recharge"                      , c(1, 1, i_time), c(-1, -1, 1))
snw_field = ncvar_get(snw_file, "snow_water_equivalent"                     , c(1, 1, i_time), c(-1, -1, 1))
snf_field = ncvar_get(snf_file, "snow_free_water"                           , c(1, 1, i_time), c(-1, -1, 1))
                                                                            
swt_field = ncvar_get(swt_file, "surface_water_storage"                     , c(1, 1, i_time), c(-1, -1, 1))
top_field = ncvar_get(top_file, "top_water_layer"                           , c(1, 1, i_time), c(-1, -1, 1))
                                                                            
int_field = ncvar_get(int_file, "interception_storage"                      , c(1, 1, i_time), c(-1, -1, 1))
                                                                            
upp_field = ncvar_get(upp_file, "upper_soil_storage"                        , c(1, 1, i_time), c(-1, -1, 1))
low_field = ncvar_get(low_file, "lower_soil_storage"                        , c(1, 1, i_time), c(-1, -1, 1))
                                                                            
gwt_active_field = ncvar_get(gwa_file, "groundwater_storage"         , c(1, 1, i_time), c(-1, -1, 1))
gwt_fossil_field = ncvar_get(gwf_file, "fossil_groundwater_storage"  , c(1, 1, i_time), c(-1, -1, 1))
gwt_field = gwt_active_field + gwt_fossil_field

tws_field = ncvar_get(tws_file, "total_thickness_of_water_storage"          , c(1, 1, i_time), c(-1, -1, 1))

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
total_water_storage[i]        = sum( tws_field  * cell_area, na.rm = T)/10^9

print("")
print(i)
print(year[i])
print(paste("PRE : ", precipitation[i]            ))
print(paste("EVA : ", evaporation[i]              ))
print(paste("RUN : ", runoff[i]                   ))
print(paste("RCH : ", recharge[i]                 ))

print(paste("SNW : ", snow_water_equivalent[i]    ))
print(paste("SNF : ", free_water_above_snow[i]    ))
print(paste("SWT : ", surface_water_storage[i]    ))
print(paste("TOP : ", top_water_layer[i]          ))
print(paste("INT : ", interception_storage[i]     ))
print(paste("UPP : ", upper_soil_storage[i]       ))
print(paste("LOW : ", lower_soil_storage[i]       ))
print(paste("GWT : ", groundwater_storage[i]      ))
print(paste("TWS : ", total_water_storage[i]      ))

print("")

if (i > 1) {
print(paste("GWT changes: ", groundwater_storage[i] - groundwater_storage[i-1] ))
print(paste("TWS changes: ", total_water_storage[i] - total_water_storage[i-1] ))
}

}

# change the current working directory to this_analysis_output_folder
setwd(this_analysis_output_folder)



# index of the starting year
analysis_starting_year = starting_year + 0
sta = which(year == analysis_starting_year)
# index of the last year
las = length(year)

snow_water_equivalent_corrected = snow_water_equivalent
free_water_above_snow_corrected = free_water_above_snow

# the corrected total water storage
total_water_storage_corrected = total_water_storage

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
snow_water_equivalent, 
free_water_above_snow, 
surface_water_storage, 
top_water_layer,       
interception_storage,  
upper_soil_storage,    
lower_soil_storage,    
groundwater_storage)

file_name = paste(this_analysis_output_folder, "/table_raw_complete_from_", starting_year, ".txt",sep ="")
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
file_name = paste(this_analysis_output_folder, "absolute_from_", starting_year, ".txt",sep ="")
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
tws_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = total_water_storage_anomaly)) + geom_line() + scale_x_continuous(limits = c(1955, 2015))
swt_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = surface_water_anomaly))       + geom_line() + scale_x_continuous(limits = c(1955, 2015))
snw_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = snow_anomaly))                + geom_line() + scale_x_continuous(limits = c(1955, 2015))
int_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = interception_anomaly))        + geom_line() + scale_x_continuous(limits = c(1955, 2015))
soi_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = soil_moisture_anomaly))       + geom_line() + scale_x_continuous(limits = c(1955, 2015))
gwt_anomaly_chart <- ggplot(data = data_frame_anomaly, aes(x = year, y = groundwater_anomaly))         + geom_line() + scale_x_continuous(limits = c(1955, 2015))
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
file_name = paste(this_analysis_output_folder, "/all_storage_anomalies_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################


# making data frame for fluxes
data_frame_flux = data.frame(precipitation, evaporation, runoff, recharge)
file_name = paste(this_analysis_output_folder, "fluxes_from_", starting_year, ".txt",sep ="")
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
file_name = paste(this_analysis_output_folder, "/anomaly_fluxes_from_", starting_year, ".txt",sep ="")
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
pre_anomaly_bar_plot <- pre_anomaly_bar_plot + scale_y_continuous(limits = c(- amplitude_precipitation, amplitude_precipitation)) + scale_x_continuous(limits = c(1955, 2015))
eva_anomaly_bar_plot <- eva_anomaly_bar_plot + scale_y_continuous(limits = c(- amplitude_evaporation  , amplitude_evaporation  )) + scale_x_continuous(limits = c(1955, 2015))
run_anomaly_bar_plot <- run_anomaly_bar_plot + scale_y_continuous(limits = c(- amplitude_runoff       , amplitude_runoff       )) + scale_x_continuous(limits = c(1955, 2015))

# making absolute storage plots for of total water, surface water and groundwater
total_water_storage_chart <- ggplot(data = data_frame_absolute, aes(x = year, y = total_water_storage)) + geom_line() + scale_x_continuous(limits = c(1955, 2015))
surface_water_chart       <- ggplot(data = data_frame_absolute, aes(x = year, y = surface_water))       + geom_line() + scale_x_continuous(limits = c(1955, 2015))
groundwater_chart         <- ggplot(data = data_frame_absolute, aes(x = year, y = groundwater))         + geom_line() + scale_x_continuous(limits = c(1955, 2015))
# setting y axes
total_water_storage_chart <- total_water_storage_chart + scale_y_continuous(limits = c(mean_total_water_storage - amplitude, mean_total_water_storage + amplitude)) 
surface_water_chart       <- surface_water_chart       + scale_y_continuous(limits = c(mean_surface_water       - amplitude, mean_surface_water       + amplitude)) 
groundwater_chart         <- groundwater_chart         + scale_y_continuous(limits = c(mean_groundwater         - amplitude, mean_groundwater         + amplitude)) 

# making plots for precipitation, evaporation and runoff
precipitation_chart  <- ggplot(data = data_frame_absolute, aes(x = year, y = precipitation         )) + geom_line() + scale_x_continuous(limits = c(1955, 2015))
evaporation_chart    <- ggplot(data = data_frame_absolute, aes(x = year, y = evaporation           )) + geom_line() + scale_x_continuous(limits = c(1955, 2015))
runoff_chart         <- ggplot(data = data_frame_absolute, aes(x = year, y = runoff                )) + geom_line() + scale_x_continuous(limits = c(1955, 2015))



###########################################################################################################################
# ploting storages and anomaly fluxes of precipitation, surface water, and groundwater
gA <- ggplotGrob(total_water_storage_chart)
gB <- ggplotGrob(surface_water_chart)
gC <- ggplotGrob(groundwater_chart)
gD <- ggplotGrob(pre_anomaly_bar_plot)
gE <- ggplotGrob(eva_anomaly_bar_plot)
gF <- ggplotGrob(run_anomaly_bar_plot)
file_name = paste(this_analysis_output_folder, "/storages_and_anomaly_fluxes_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
g = cbind(rbind(gA, gB, gC, size = "first"), rbind(gD, gE, gF, size = "first"), size = "first")
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################


###########################################################################################################################
# ploting storages and fluxes of precipitation, evaporation and runoff
gJ <- ggplotGrob(precipitation_chart)
gK <- ggplotGrob(evaporation_chart)
gL <- ggplotGrob(runoff_chart)
file_name = paste(this_analysis_output_folder, "/storages_fluxes_from_", starting_year, ".pdf",sep ="")
pdf(file_name, width = (29.7/2.54) * (3/4), height = (21.0/2.54) * (3/4))
g = cbind(rbind(gA, gB, gC, size = "first"), rbind(gJ, gK, gL, size = "first"), size = "first")
grid.newpage()
grid.draw(g)
dev.off()
###########################################################################################################################


