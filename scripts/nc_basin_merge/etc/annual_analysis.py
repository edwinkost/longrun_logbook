#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
import glob

import numpy as np
import netCDF4 as nc
import pcraster as pcr

import virtualOS as vos

# folder that contains the output from PCR-GLOBWB and years that will be analyzed 
pcrglobwb_output_folder = 
years  = seq()

# output folder for these analyses (containing: 
analysis_ouput_folder = 
# - temporary folder 
tmp_folder = analysis_ouput_folder + "/tmp/"

# preparing output and temporary folders
cmd = 'mkdir '+analysis_ouput_folder
print cmd; os.system(cmd)
cmd = 'rm -r '+tmp_folder
print cmd; os.system(cmd)
os.makedirs(tmp_folder)

# 
storage = {}
storage['snowCoverSWE'   ] = {}  
storage['snowFreeWater'  ] = {}  
storage['interceptStor'  ] = {}  
storage['topWaterLayer'  ] = {}  
storage['storUppTotal'   ] = {}  
storage['storLowTotal'   ] = {}  
storage['storGroundwater'] = {}
storage['snowCoverSWE'   ]['filename'] = output_folder + "/" + 'snowCoverSWE_annuaAvg_output.nc'   
storage['snowFreeWater'  ]['filename'] = output_folder + "/" + 'snowFreeWater_annuaAvg_output.nc'  
storage['interceptStor'  ]['filename'] = output_folder + "/" + 'interceptStor_annuaAvg_output.nc'  
storage['topWaterLayer'  ]['filename'] = output_folder + "/" + 'topWaterLayer_annuaAvg_output.nc'  
storage['storUppTotal'   ]['filename'] = output_folder + "/" + 'storUppTotal_annuaAvg_output.nc'   
storage['storLowTotal'   ]['filename'] = output_folder + "/" + 'storLowTotal_annuaAvg_output.nc'   
storage['storGroundwater']['filename'] = output_folder + "/" + 'storGroundwater_annuaAvg_output.nc'
storage['snowCoverSWE'   ]['var_name'] = 
storage['snowFreeWater'  ]['var_name'] = 
storage['interceptStor'  ]['var_name'] = 
storage['topWaterLayer'  ]['var_name'] = 
storage['storUppTotal'   ]['var_name'] = 
storage['storLowTotal'   ]['var_name'] = 
storage['storGroundwater']['var_name'] = 

# clone and landmask maps
clone_map          = "/projects/0/dfguu/data/hydroworld/PCRGLOBWB20/input5min/routing/cellsize05min.correct.map"
pcr.setclone(clone_map)
landmask_filename  = None
if landmask_filename != None:
    landmask = pcr.boolean(pcr.readmap(landmask_filename))
else:
    landmask = pcr.boolean(1.0)
landmask = pcr.ifthen(landmask, landmask) 

# cell_area map (unit: m2)
cell_area_filename = "/projects/0/dfguu/data/hydroworld/PCRGLOBWB20/input5min/routing/cellsize05min.correct.map"
cell_area          = vos.readPCRmapClone(cell_area_filename, clone_map, tmp_folder)

for year in years:
    
    print year
    
    for storage_key in storage.keys():
    
        if year == years[0]:
            output_file = open
            storage[storage_key]['annual_average_volume'] = {}
        
        # reading 
        storage_in_meter = vos.netcdf2PCRobjClone(ncFile = 
                                                  varName = ,
                                                  dateInput = 
                                                  useDoy = None,
                                                  cloneMapFileName = clone_map)
        
        # converting to volume and using the value 
        storage_in_volume = storage_in_meter * cell_area
        storage_in_volume = pcr.ifthen(landmask, storage_in_volume)
        
        storage[storage_key]['annual_average_volume'][year] = float(vos.getMapTotal(storage_in_volume))
        

