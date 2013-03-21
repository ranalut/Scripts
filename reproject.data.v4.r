library(ncdf)
library(rgdal)
library(raster)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

startTime <- Sys.time()

biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')

# new.grid <- projectExtent(crs='+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs',res=911.8)

cat(Sys.time()-startTime, 'minutes to load file', '\n')

# Contiguous US Albers Equal Area Conic USGS
biomes2 <- projectRaster(from=biomes, crs='+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs', method='ngb')
# biomes2 <- projectRaster(from=biomes, crs='+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs', filename=paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_reproj_v1',sep=''), format='ascii', method='ngb')
# biomes2 <- projectRaster(from=biomes, crs='aea', method='ngb')

# ESRI North_America_Albers_Equal_Area_Conic
# biomes3 <- projectRaster(from=biomes, crs='+proj=aea +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs', method='ngb')

# writeRaster(biomes2,filename=paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_reproj_v1', sep=''),format='GTiff',overwrite=TRUE) #ascii

cat(Sys.time()-startTime, 'minutes to transform file', '\n')

writeRaster(biomes2,filename=paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_reproj_v1', sep=''),format='CDF',overwrite=TRUE, varname='biomes') # This is giving me a .nc file with a geographic coordinate system instead of the Albers.  I don't know why.
# test <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_reproj_v1.nc',sep=''),band=1)
print(projection(test))
test <- open.ncdf(con=paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_reproj_v1.nc',sep=''))
print(attributes(test))


# print(attributes(biomes2))
print(extent(biomes2))
plot(biomes2, col=palette(terrain.colors(n=7)))
