
hexmap.time.series <- function(the.names, output.wksp, spp.folder, theGCM=theGCMs[i], hexmap.base.name, hex.grid, variable, end.yr=NA)
{
	if(is.na(end.yr)==TRUE) { end.yr <- length(the.names) }
	for (j in 2:end.yr)
			# for (j in 1)
			{
				test <- file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCM,'.',hexmap.base.name,'/',theGCM,'.',hexmap.base.name,'.',j,'.hxn',sep=''))
				if(test==TRUE) { cat(theGCM,j,'\n'); next(j) }
				
				nc.2.hxn(
					variable=variable, 
					nc.file=the.names[j], 
					hex.grid=hex.grid[[2]], 
					theCentroids=hex.grid[[1]],
					max.value=Inf,
					changeTable=NA,
					hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
					hexmap.name=paste(theGCM,'.',hexmap.base.name,sep=''),
					dimensions=c(1750,1859)
					)

				file.copy(
					from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCM,'.',hexmap.base.name,'/',theGCM,'.',hexmap.base.name,'.1.hxn',sep=''), 
					to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCM,'.',hexmap.base.name,'/',theGCM,'.',hexmap.base.name,'.',j,'.hxn',sep=''),
					overwrite=TRUE
					)
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
					changeTable=NA,
					hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
					hexmap.name=paste(theGCM,'.',hexmap.base.name,sep=''),
					dimensions=c(1750,1859)
					)
}