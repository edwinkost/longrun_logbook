#-extracts data from partial netCDF output via arrays

#-modules
import os, sys
import time as tm
import numpy as np
import netCDF4 as nc
import datetime
import glob
from multiprocessing import Pool
import calendar
from dateutil.relativedelta import *

# file cache to minimize/reduce opening/closing files.  
filecache = dict()


def calculate_monthdelta(date1, date2):
    def is_last_day_of_the_month(date):
        days_in_month = calendar.monthrange(date.year, date.month)[1]
        return date.day == days_in_month
    imaginary_day_2 = 31 if is_last_day_of_the_month(date2) else date2.day
    monthdelta = (
        (date2.month - date1.month) +
        (date2.year - date1.year) * 12 +
        (-1 if date1.day > imaginary_day_2 else 0)
        )
    return monthdelta

def getMax(x,a):
	m= float(a.max())
	if x == None:
		return m
	else:
		return max(m,x)
	
def getMin(x,a):
	m= float(a.min())
	if x == None:
		return m
	else:
		return min(m,x)

def netcdfList(inputDir):
	'''creates a dictionary of netcdf files'''
	netcdfList = glob.glob(os.path.join(inputDir, '*.nc'))
	print inputDir
	print os.path.join(inputDir, '*.nc')
	ll=[]
	for ncFile in netcdfList:
		ll.append(ncFile.split('/')[-1])
	return ll

def ncFileNameDict(inputDirRoot, areas, ncFileName):
	'''creates a dictionary of subdomains of pcrglob model outut'''
	netcdfInputDict = {}
	for key in range(1, len(areas)+1, 1):
		value = os.path.join(inputDirRoot, areas[key-1], 'netcdf', ncFileName)
		netcdfInputDict[key] = value
	return netcdfInputDict

def mergeNetCDF(inputTuple):
	
	ncName    = inputTuple[0]
	latMin    = inputTuple[1]
	latMax    = inputTuple[2]
	lonMin    = inputTuple[3]
	lonMax    = inputTuple[4]
	deltaLat  = inputTuple[5]
	deltaLon  = inputTuple[6]
	
	startDate    = inputTuple[7]
	endDate      = inputTuple[8] 
	
	print 'combining files for %s'%ncName
	scriptStartTime = tm.time()
	
	#-dictionary holding netCDFInput
	netCDFInput = ncFileNameDict(inputDirRoot, areas, ncName)
	#-netDCF output
	netCDFOutput= os.path.join(outputDir,ncName)
	#~ ncFormat = 'NETCDF3_CLASSIC'
	ncFormat = 'NETCDF4'
	
	# option to use zlib compression:
	using_zlib = True

	#-set dimensions, attributes, and dimensions per netCDF input data set
	# and retrieve the resolution and definition of coordinates and calendar
	attributes= {}
	dimensions= {}
	variables= {}
	variableName = None
	
	calendar= {}
	uniqueTimes = np.array([])

	# defining time based on the given arguments 
	if startDate != None and endDate != None:

		# start time and end time
		sd = str(startDate).split('-')
		startTime = datetime.datetime(int(sd[0]), int(sd[1]), int(sd[2]), 0)
		ed = str(endDate).split('-')
		endTime   = datetime.datetime(int(ed[0]), int(ed[1]), int(ed[2]), 0)
		
		print netCDFInput.values()[0]
		
		# open the first netcdf file to get time units and time calendar
		ncFile = netCDFInput.values()[0]
		print ncFile
		f = nc.Dataset(ncFile)
		time_units    = f.variables['time'].units
		time_calendar = f.variables['time'].calendar
		
		# temporal resolution
		timeStepType = "daily"
		
		if (f.variables['time'][1] - f.variables['time'][0]) > 25.0: timeStepType = "monthly"
		if (f.variables['time'][1] - f.variables['time'][0]) > 305.0: timeStepType = "yearly"
		
		f.close() 

		if timeStepType == "daily":
			number_of_days = (endTime - startTime).days + 1
			datetime_range = [startTime + datetime.timedelta(days = x) for x in range(0, number_of_days)]
			
		if timeStepType == "monthly":
			number_of_months = calculate_monthdelta(startTime, endTime +  datetime.timedelta(days = 1)) + 1
			datetime_range = [startTime + relativedelta(months =+x) for x in range(0, number_of_months)]
		
		if timeStepType == "yearly":
			number_of_years = endTime.year - startTime.year + 1
			datetime_range = [startTime + relativedelta(years =+x) for x in range(0, number_of_years)]
		
		# time variables that will be used 
		uniqueTimes = nc.date2num(datetime_range, time_units, time_calendar)
	
	for ncFile in netCDFInput.values():

		# open netCDF file
		if ncFile in filecache.keys():
			rootgrp = filecache[ncFile]
			print "Cached: ", ncFile
		else:
			rootgrp = nc.Dataset(ncFile)
			filecache[ncFile] = rootgrp
			print "New: ", ncFile

		# and get index
		index= netCDFInput.keys()[netCDFInput.values().index(ncFile)]

		# retrieve dimensions,  atributes, variables, and missing value
		dimensions[index]= rootgrp.dimensions.copy()
		variables[index]=  rootgrp.variables.copy()
		attributes[index]= rootgrp.__dict__.copy()
	
		#-set new values
		for key in dimensions[index].keys():
			if 'lat' in key.lower():
				latVar= key
			if 'lon' in key.lower():
				lonVar= key
		latMin= getMin(latMin,variables[index][latVar][:])
		latMax= getMax(latMax,variables[index][latVar][:])
		lonMin= getMin(lonMin,variables[index][lonVar][:])
		lonMax= getMax(lonMax,variables[index][lonVar][:])
	
		#-assign calendar
		if 'time' in  variables[index].keys():
			for name in variables[index]['time'].ncattrs():
				if name not in calendar.keys():
					calendar[name]= getattr(variables[index]['time'],name)
				else:
					if getattr(variables[index]['time'],name) != calendar[name]:
						rootgrp.close()
						sys.exit('calendars are incompatible')
			#-time
			if uniqueTimes.size == 0:
				uniqueTimes= variables[index]['time'][:]
			#~ else:
				#~ uniqueTimes= np.unique(np.c_[uniqueTimes[:],variables[index]['time'][:]])
			uniqueTimes.sort()
		keys= variables[index].keys()
		for key in dimensions[index].keys():
			if key in keys:
				keys.remove(key)
		key= keys[0]
		if variableName == None:
			variableName= key
		else:
			if key <> variableName:
				rootgrp.close()
				sys.exit('variables are incompatible')
		#-Missing Value
		MV = rootgrp.variables[key]._FillValue
		varUnits = rootgrp.variables[variableName].units
		#-close file 
		rootgrp.close()
	
	#-create output netCDF
	#~ longitudes= np.around(np.arange(lonMin,lonMax+deltaLon,deltaLon), decimals=4)
	#~ latitudes=  np.around(np.arange(latMax,latMin-deltaLat,-deltaLat), decimals=4)

	longitudes= np.arange(lonMin,lonMax+deltaLon,deltaLon)
	latitudes=  np.arange(latMax,latMin-deltaLat,-deltaLat)

	#~ longitudes= np.linspace(lonMin,lonMax+deltaLon, int(round((lonMax+deltaLon - lonMin)/deltaLon)))
	#~ latitudes=  np.linspace(latMax,latMin-deltaLat, int(round((latMax - latMin+deltaLat)/deltaLat)))

	uniqueTimes= uniqueTimes.tolist()
	#-open file
	rootgrp= nc.Dataset(netCDFOutput,'w',format= ncFormat)
	#-create dimensions for longitudes and latitudes
	rootgrp.createDimension('latitude',len(latitudes))
	rootgrp.createDimension('longitude',len(longitudes))
	lat= rootgrp.createVariable('latitude','f4',('latitude'))
	lat.standard_name= 'Latitude'
	lat.long_name= 'Latitude cell centres'
	lon= rootgrp.createVariable('longitude','f4',('longitude'))
	lon.standard_name= 'Longitude'
	lon.long_name= 'Longitude cell centres'
	#-assing latitudes and longitudes to variables
	lat[:]= latitudes
	lon[:]= longitudes  

	latitudes = np.around(latitudes, decimals=4)
	longitudes = np.around(longitudes, decimals=4)
    
	#-create time and set its attributes
	date_time=rootgrp.createDimension('time',len(uniqueTimes))
	date_time= rootgrp.createVariable('time','f8',('time',))
	for attr,value in calendar.iteritems():
		setattr(date_time,attr,str(value))
	date_time[:]= uniqueTimes
	#-setting variable
	if len(calendar) == 0:
		varStructure= ('latitude','longitude')  
	else:
		varStructure= ('time','latitude','longitude')  

	variable = rootgrp.createVariable(variableName, 'f4', varStructure, fill_value = MV, zlib = using_zlib)

	#-set variable attributes and overall values
	for index in attributes.keys():
		for name in variables[index][variableName].ncattrs():
			try:
				setattr(variable,name,str(getattr(variables[index][variableName],name)))
			except:
				pass
		for attr,value in attributes[index].iteritems():
			setattr(rootgrp,attr,str(value)) 
	
	#-write to file
	rootgrp.sync()
	rootgrp.close()
	
	#NOTE: this assumes it is a timed variable!
	#-iterate over time steps and retrieve values
	
	print 'nr of time steps = %s, nr of files = %s ' % (len(uniqueTimes), len(netCDFInput))
	for time in uniqueTimes[:]:

		#~ print 'processing %s for time index %.0d' %(ncName, 1+ time - min(uniqueTimes))
		print 'processing %s for time %.0d' %(ncName, time)

		#-create empty field to fill
		variableArray= np.ones((len(latitudes),len(longitudes)))*MV
		
		#-iterate over input netCDFs
		for ncFile in netCDFInput.values():
			#-open netCDF file and get dictionary index
			rootgrp= nc.Dataset(ncFile,'r',format= ncFormat)
			index= netCDFInput.keys()[netCDFInput.values().index(ncFile)]
			#-retrieve posCnt and process
			#-get row and column indices from lats and lons
			for key in dimensions[index].keys():
				if 'lat' in key.lower():
					latVar= key
				if 'lon' in key.lower():
					lonVar= key
			latMaxNcFile = round(getMax(latMin,variables[index][latVar][:]),4)
			latMinNcFile = round(getMin(latMax,variables[index][latVar][:]),4)
			lonMinNcFile = round(getMin(lonMax,variables[index][lonVar][:]),4)
			lonMaxNcFile = round(getMax(lonMin,variables[index][lonVar][:]),4)

			row0=  np.where(latitudes == min(latMax,latMaxNcFile))[0][0]
			row1=  np.where(latitudes == max(latMin,latMinNcFile))[0][0]+1
			col0= np.where(longitudes == max(lonMin,lonMinNcFile))[0][0]
			col1= np.where(longitudes == min(lonMax,lonMaxNcFile))[0][0]+1

			posCnt= None
			try:
				posCnt= variables[index]['time'][:].tolist().index(time)
				sampleArray= rootgrp.variables[variableName][posCnt,:,:]
				sampleArray[sampleArray == variables[index][variableName]._FillValue]= MV
				variableArray[row0:row1,col0:col1][variableArray[row0:row1,col0:col1] == MV]= \
					sampleArray[variableArray[row0:row1,col0:col1] == MV]
			except:
				if posCnt == None:
					print 'time not present'
				else:
					print 'error  in resampled'
			#-close
			rootgrp.close()
	
		#-write array to destination netCDF
		posCnt= uniqueTimes.index(time)
		rootgrp= nc.Dataset(netCDFOutput,'a',format= ncFormat)
		rootgrp.variables[variableName][posCnt,:,:]= variableArray
		variable.units = str(varUnits)
		rootgrp.sync()
		rootgrp.close()
	
	secs = int(tm.time() - scriptStartTime)
	print "Processing %s took %s hh:mm:ss\n" % (ncName, str(datetime.timedelta(seconds=secs)))

##################################
######## user input ##############
##################################
#~ inputDirRoot = '/projects/wtrcycle/users/edwinhs/05min_runs_28_november_2014/multi_cores_natural_1960_to_2010/'  # sys.argv[1] #'/scratch/water2invest/pcrglob/HadGem_historical/'
#~ outputDir    = inputDirRoot+'/global/'
#~ outputDir    = '/projects/wtrcycle/users/edwinhs/05min_runs_28_november_2014/multi_cores_natural_1960_to_2010/global/'
#~ outputDir    = '/projects/wtrcycle/users/edwinhs/05min_runs_november_2014/test_multi_cores_natural/global/'      # inputDirRoot' # inputDirRoot
areas           = ['M%02d'%i for i in range(1,54,1)]
deltaLat        = 5.0/60.0
deltaLon        = 5.0/60.0
latMin          =  -90 + deltaLat / 2
latMax		    =   90 - deltaLat / 2
lonMin          = -180 + deltaLon / 2
lonMax          =  180 - deltaLon / 2

# input and output directories:
inputDirRoot      = sys.argv[1] 
outputDir = inputDirRoot+"/global/netcdf/"
try:
	outputDir = sys.argv[2]
	if sys.argv[2] == "default": outputDir = inputDirRoot+"/global/netcdf/"
except:
	outputDir = inputDirRoot+"/global/netcdf/"

# maximum number of cores that will be used
try:
	max_number_of_cores = int(sys.argv[3])
except:
	max_number_of_cores = 2 # the number of cores will be limited by file sizes and available memory

# maximum number of cores that will be used
try:
	if sys.argv[3] == "fat": max_number_of_cores = 8 # based on the experience, we can use maximum 8 cores in the fat node, for merging monthly model output in the period 1958-2010
except:
	pass
print max_number_of_cores

# making outputDir
try:
	os.makedirs(outputDir)
except:
	pass	

# starting and end dates
startDate    = None            # 
endDate      = None            # 
try:
	startDate    = str(sys.argv[4]) 
	endDate      = str(sys.argv[5])
except:
	pass

# type of netcdf file list (see below):
list_type = None
try:
	list_type = str(sys.argv[6]) 
except:
	pass

#- main script

# the annual files
netcdfList = [
'snowCoverSWE_annuaAvg_output.nc',
'snowFreeWater_annuaAvg_output.nc',
'interceptStor_annuaAvg_output.nc',
'topWaterLayer_annuaAvg_output.nc',
'storUppTotal_annuaAvg_output.nc',
'storLowTotal_annuaAvg_output.nc',
'storGroundwater_annuaAvg_output.nc',
'surfaceWaterStorage_annuaAvg_output.nc',
'irrGrossDemand_annuaTot_output.nc',
'nonIrrGrossDemand_annuaTot_output.nc',
'totalRunoff_annuaTot_output.nc',
'totalEvaporation_annuaTot_output.nc'
]

# the monthly files
if list_type == "monthly":\
	netcdfList = [
		'snowCoverSWE_monthAvg_output.nc',
		'snowFreeWater_monthAvg_output.nc',
		'interceptStor_monthAvg_output.nc',
		'topWaterLayer_monthAvg_output.nc',
		'storUppTotal_monthAvg_output.nc',
		'storLowTotal_monthAvg_output.nc',
		'storGroundwater_monthAvg_output.nc',
		'surfaceWaterStorage_monthAvg_output.nc',
		'discharge_monthAvg_output.nc',
		'totalGroundwaterAbstraction_monthTot_output.nc',
		'gwRecharge_monthTot_output.nc',
		'precipitation_monthTot_output.nc'
		]

for i in netcdfList:print i

ncores = min(len(netcdfList), max_number_of_cores)

#~ # testing for a single job
#~ mergeNetCDF((netcdfList[0], latMin, latMax, lonMin, lonMax, deltaLat, deltaLon, startDate, endDate))

ll = []
for ncName in netcdfList:
	ll.append((ncName, latMin, latMax, lonMin, lonMax, deltaLat, deltaLon, startDate, endDate))

pool = Pool(processes=ncores)    # start "ncores" of worker processes
pool.map(mergeNetCDF, ll)        # multicore processing

