
  
build.paths <- function(theSRES) 
{  
  file.name.a2.pre <- 'conus_' 
  file.name.a2.suf <- '_y' 
  file.name.cru <- 'conus_historical_y'

  names1 <- paste("L:/space_lawler/shared/USGS EROS Landcover/CONUS_Landcover_Historical/CONUS_Landcover_Historical/",file.name.cru,seq(1992,2005,1),'.tif',sep='')
  
  names2 <- paste("L:/space_lawler/shared/USGS EROS Landcover/CONUS_Landcover_",theSRES,"/CONUS_Landcover_",theSRES,"/",file.name.a2.pre,theSRES,file.name.a2.suf,seq(2006,2099,1),'.tif',sep='')
  the.names <- c(rep(names1[1],31),names1,names2)
  return(the.names)
}
