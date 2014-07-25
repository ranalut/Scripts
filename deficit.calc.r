
deficit <- function(aet.file, pet.file, file.path.out, season)
{

	aet <- raster(aet.file, crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
	pet <- raster(pet.file, crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

	deficit <- aet - pet
	# print('deficit'); print(Sys.time()-startTime)
	rm(aet)
	rm(pet)

	writeRaster(deficit, file.path.out, varname=paste('deficit_',season,sep=''),overwrite=TRUE)
}

