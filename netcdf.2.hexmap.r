library(ncdf)
library(rgdal)
library(raster)
library(foreign)

nc.2.hxn <- function(variable, nc.file, hex.grid, theCentroids, max.value, hexsim.wksp, hexsim.wksp2, output.wksp, output.wksp2, hexmap.name, spp.folder)
{
	
	startTime <- Sys.time()
	theData <- raster(nc.file, varname=variable)
	
	extractedData <- extract(theData, hex.grid)
	extractedData[is.na(extractedData)==TRUE] <- 0
	extractedData[extractedData > max.value] <- max.value
	cat(Sys.time()-startTime, 'minutes or seconds to extract data', '\n') # 1.5 minutes...
	# print(head(extractedData)); stop('cbw')

	dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
	dir.create(path=paste(hexsim.wksp,'scratch_workspace/',sep=''), recursive=TRUE)
	write.csv(dataDump, paste(hexsim.wksp,'scratch_workspace/',hexmap.name,'.csv',sep=''),row.names=FALSE)

	startTime <- Sys.time()
	dir.create(path=paste(output.wksp,'Workspaces/',spp.folder,"/Spatial Data/Hexagons/",hexmap.name,sep=''), recursive=TRUE)
	
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && HexMapConverter.exe "',hexsim.wksp2,'\\scratch_workspace\\',hexmap.name,'.csv" true true 3131 2075 true "',output.wksp2,'\\Workspaces\\',spp.folder,'\\Spatial Data\\Hexagons\\',hexmap.name,'"',sep='')
	# The command line syntax quoted below works...
	# 'C: && cd "C:\Users\cbwilsey\Documents\PostDoc\HexSim\currentHexSim\" && HexMapConverter.exe "C:\users\cbwilsey\documents\postdoc\hexsim\scratch_workspace\initial.dist.csv" true true 3131 2075 true "E:\HexSim\Workspaces\spotted_frog_v2\Spatial Data\Hexagons\initial.dist"'
	
	# print(command)
	shell(command)
}
