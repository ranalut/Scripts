library(ncdf)
library(rgdal)
library(raster)
library(foreign)

setwd('F:/PNWCCVA_Data2/Scripts/')

startTime <- Sys.time()

source('load.hex.grid')
hex.grid <- load.hex.grid(centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',file.format='txt',proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

# ==============================================================================================================
# Historical SWE

nc.2.hxn <- function(variable, nc.file, max.value, workspace)
{
	variable <- 'swe.march'
	theData <- raster("D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc") #,varname='streams')

	startTime <- Sys.time()
	extractedData <- extract(theData, hex.grid)
	extractedData[is.na(extractedData)==TRUE] <- 0
	extractedData[extractedData > 1000] <- 1000
	cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
	# print(head(extractedData)); stop('cbw')

	dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
	write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/',variable,'.csv',sep=''),row.names=FALSE)

	startTime <- Sys.time()
	workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
	command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\',variable,'.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\',variable,'"',sep='')
	shell(command)
}



# Historical SWE SD
variable <- 'swe.sd.march'
theData <- raster("D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_march.nc") #,varname='streams')

startTime <- Sys.time()
extractedData <- extract(theData, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
extractedData[extractedData > 1000] <- 1000
cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/',variable,'.csv',sep=''),row.names=FALSE)

dir.create(paste('F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/Hexagons/',variable,sep=''),recursive=TRUE)
startTime <- Sys.time()
workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\',variable,'.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\',variable,'"',sep='')
shell(command)

# stop('cbw')
