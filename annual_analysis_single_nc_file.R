
require(ncdf4)
require(ggplot2)
require(grid)

#~ # activating x11 (I don't think this is necessary)
#~ x11()

# reading system arguments:
args <- commandArgs()

# the netcdf file that will be analyzed:
nc_file_name <- args[4]
# - variable name
nc_variable  <- args[4]

# opening netcdf files:
nc_file = nc_open( nc_file_name , sep = "") )

# time values 
time = ncvar_get(swt_file, "time"); length(time)

# cell area 
cell_area_file = nc_open("/home/edwin/data/cell_area_nc/cellsize05min.correct.used.nc")
cell_area = ncvar_get(cell_area_file, "Band1")[,]
nc_close(cell_area_file)

nc_field = ncvar_get(nc_file, nc_variable, c(1, 1, i), c(-1, -1, 1))

# calculate the global values (unit: km3)
global_value = sum( pre_field  * cell_area, na.rm = T)/10^9

print(paste("Global value (km3): ", global_value))
