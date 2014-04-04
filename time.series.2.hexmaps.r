
hexmap.time.series <- function(the.names, output.wksp, spp.folder, theGCM, hexmap.base.name, hex.grid, variable, start.yr, end.yr=NA, changeTable=NA, buffer=NA, ag.fact=NA, fun=NA, crop=NA, ver)
{
	dir.create(paste(output.wksp,'scratch_workspace/raster_v',ver,sep=''))
	rasterOptions(tmpdir=paste(output.wksp,'scratch_workspace/raster_v',ver,sep=''))
	if(is.na(end.yr)==TRUE) { end.yr <- length(the.names) }
	for (j in start.yr:end.yr)
	# for (j in 1)
	{
		test <- file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.base.name,'.',theGCM,'/',hexmap.base.name,'.',theGCM,'.',j,'.hxn',sep=''))
		if(test==TRUE) { cat(theGCM,j,'\n'); next(j) }
		
		nc.2.hxn(
			variable=variable, 
			nc.file=the.names[j], 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=Inf,
			changeTable=changeTable,
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste(hexmap.base.name,'.',theGCM,sep=''),
			dimensions=c(1750,1859),
			buffer=buffer, ag.fact=ag.fact, fun=fun, crop=crop
			)

		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.base.name,'.',theGCM,'/',hexmap.base.name,'.',theGCM,'.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.base.name,'.',theGCM,'/',hexmap.base.name,'.',theGCM,'.',j,'.hxn',sep=''),
			overwrite=TRUE
			)
		file.remove(dir(paste(output.wksp,'scratch_workspace/raster_v',ver,sep=''),full.names=TRUE))
		cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# stop('cbw')
	}
	
	# Present-day
	nc.2.hxn(
			variable=variable, 
			nc.file=the.names[1], 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=Inf,
			changeTable=changeTable,
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste(hexmap.base.name,'.',theGCM,sep=''),
			dimensions=c(1750,1859),
			buffer=buffer, ag.fact=ag.fact, fun=fun, crop=crop
			)
	file.remove(dir("C:/Documents and Settings/cbwilsey/Local Settings/Temp/4/R_raster_tmp/cbwilsey",full.names=TRUE))
}