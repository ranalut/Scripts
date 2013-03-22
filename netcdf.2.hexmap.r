library(ncdf)
library(rgdal)
library(raster)
library(foreign)

nc.2.hxn <- function(variable, nc.file, hex.grid, theCentroids, max.value, hexsim.wksp, spp.wksp)
{
	
	startTime <- Sys.time()
	theData <- raster(nc.file)
	
	extractedData <- extract(theData, hex.grid)
	extractedData[is.na(extractedData)==TRUE] <- 0
	extractedData[extractedData > max.value] <- max.value
	cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
	# print(head(extractedData)); stop('cbw')

	dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
	dir.create(path=paste(hexsim.wksp,'scratch_workspace/',sep=''), recursive=TRUE)
	write.csv(dataDump, paste(hexsim.wksp,'scratch_workspace/',variable,'.csv',sep=''),row.names=FALSE)

	startTime <- Sys.time()
	workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
	dir.create(path=paste(hexsim.wksp,'Workspaces/',spp.folder,"/Spatial Data/Hexagons/",sep=''), recursive=TRUE)
	command <- paste('cd "',hexsim.wksp2,'\\currentHexSim\\" && HexMapConverter.exe "',hexsim.wksp2,'\\scratch_workspace\\',variable,'.csv" true true 3131 2075 true "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Spatial Data\\Hexagons\\',variable,'"',sep='')
	shell(command)
}

# nc.2.hxn(
	# variable='swe.march', 
	# nc.file="E:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
	# hex.grid=hex.grid[[2]], 
	# theCentroids=hex.grid[[1]],
	# max.value=2000, 
	# hexsim.wksp= 'C:/Users/cbwilsey/Documents/PostDoc/HexSim', #'F:/PNWCCVA_Data2/HexSim/scratch_workspace/',
	# hexsim.wksp2= 'C:\\Users\\cbwilsey\\Documents\\Postdoc\\HexSim', #'F:\\PNWCCVA_Data2\\HexSim\\'
	# spp.folder= 'spotted_frog_v2'
	# )

