library(ncdf)
library(rgdal)
library(raster)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

# startTime <- Sys.time()
theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids84.txt',sep=''), header=TRUE)
# cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.

theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# print(head(theCentroids)); stop('cbw')
# theData <- theCentroids
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

# ===================================================================================================
# coldest month
# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
coldest.month <- raster(paste(workspace,'ClimateData/netCDF/wna30sec_cru_ts_2.1/wna30sec_cru_ts_2.1_mtco_ltm_1961-1990.nc',sep=''),varname='mtco_ltm')

# startTime <- Sys.time()
extractedData <- extract(coldest.month, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'ClimateData/coldest.month.step0.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\ClimateData\\coldest.month.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\spotted_frog_v1\\Spatial Data\\Hexagons\\coldest.month"',sep='')
shell(command)
# cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...

# ======================================================================================================
# driest month
driest.month <- raster(paste(workspace,'ClimateData/netCDF/wna30sec_cru_ts_2.1/wna30sec_cru_ts_2.1_prec_dry_ltm_1961-1990.nc',sep=''),varname='prec_dry_ltm')
# startTime <- Sys.time()
extractedData <- extract(driest.month, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'ClimateData/driest.month.step0.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\ClimateData\\driest.month.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\spotted_frog_v1\\Spatial Data\\Hexagons\\driest.month"',sep='')
shell(command)
# cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...

# =====================================================================================================
# snow water equivalent
swe.ann <- raster(paste(workspace,'ClimateData/netCDF/wna30sec_cru_ts_2.1/wna30sec_cru_ts_2.1_swe_ann_ltm_1961-1990.nc',sep=''),varname='swe_ann_ltm')
# startTime <- Sys.time()
extractedData <- extract(swe.ann, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'ClimateData/swe.ann.step0.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\ClimateData\\swe.ann.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\spotted_frog_v1\\Spatial Data\\Hexagons\\swe.ann"',sep='')
shell(command)
# cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...

# ====================================================================================================
# Topographic Position Index
# This is very slow (near an hour).
tpi <- raster(paste(workspace,'GMTED2010-GlobalDEM/TPI_r5',sep=''),crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

extractedData <- extract(tpi, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'GMTED2010-GlobalDEM/tpi_5.step0.csv',sep=''),row.names=FALSE)

dataDump <- read.csv(paste(workspace,'GMTED2010-GlobalDEM/tpi_5.step0.csv',sep=''))
dataDump$extractedData <- -1 * dataDump$extractedData
write.csv(dataDump, paste(workspace,'GMTED2010-GlobalDEM/tpi_5_inv.step0.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\GMTED2010-GlobalDEM\\tpi_5_inv.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\spotted_frog_v1\\Spatial Data\\Hexagons\\tpi_5_inv"',sep='')
shell(command)
# cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...



