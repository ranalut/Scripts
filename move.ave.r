library(raster)

move.ave <- function(the.names, hex.grid, theGCM, hexmap.name, hexsim.wksp, hexsim.wksp2, output.wksp, output.wksp2, spp.folder, dimensions)
{
    the.stack <- stack(the.names[1:30])
    cat('stacked...')
    the.stack <- crop(the.stack, hex.grid[[2]]) 
    cat('cropped...')
    the.ave <- calc(the.stack, fun=mean, na.rm=TRUE)
    cat('averaged...')
    nc.2.hxn(
  		variable=NA, 
  		nc.file=the.ave, 
  		hex.grid=hex.grid[[2]], 
  		theCentroids=hex.grid[[1]],
  		max.value=Inf, 
  		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(hexmap.name,theGCM,sep=''),
  		dimensions=dimensions # c(1750,1859)
  		)
    cat('hexmap\n')
    # stop('cbw')
    
    for (j in 31:139) # 1991:2099
    {
      the.stack <- dropLayer(the.stack,1)
      temp <- crop(raster(the.names[j]),hex.grid[[2]])
      the.stack <- addLayer(the.stack,temp) 
      cat('cropped...')
      the.ave <- calc(the.stack, fun=mean, na.rm=TRUE)
      cat('averaged...')
      nc.2.hxn(
    		variable=NA, 
    		nc.file=the.ave, 
    		hex.grid=hex.grid[[2]], 
    		theCentroids=hex.grid[[1]],
    		max.value=Inf, 
    		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(hexmap.name,theGCM,sep=''),
    		dimensions=dimensions # c(1750,1859)
    		)
      cat('hexmap\n')
      file.copy(
    				 from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,theGCM,'/',hexmap.name,theGCM,'.1.hxn',sep=''), 
    				 to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,theGCM,'/',hexmap.name,theGCM,'.',(j-29),'.hxn',sep=''),
    				 overwrite=TRUE
    				 )
    }
    # Replace the first hexmap with the first map in series.
    the.stack <- stack(the.names[1:30])
    cat('stacked...')
    the.stack <- crop(the.stack, hex.grid[[2]]) 
    cat('cropped...')
    the.ave <- calc(the.stack, fun=mean, na.rm=TRUE)
    cat('averaged...')
    nc.2.hxn(
  		variable=NA, 
  		nc.file=the.ave, 
  		hex.grid=hex.grid[[2]], 
  		theCentroids=hex.grid[[1]],
  		max.value=Inf, 
  		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(hexmap.name,theGCM,sep=''),
  		dimensions=dimensions # c(1750,1859)
  		)
    cat('hexmap\n')
}

