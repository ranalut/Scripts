
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)
library(rgdal)
library(foreign)

###############################################
# Spatial Data
# political <- readShapePoly(fn='D:/Box Sync/PNWCCVA/PNWCCVA_GeoDatabases/Other GIS/admin_states.shp',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# 
# study.area <- readOGR(dsn='D:/Box Sync/PNWCCVA/PNWCCVA_GeoDatabases/PNWCCVA_wolverine.gdb',layer="pnwccva_carnivore_study_area")
# 
# huc <- readOGR(dsn='D:/Box Sync/PNWCCVA/PNWCCVA_GeoDatabases/PNWCCVA_wolverine.gdb',layer="pnwccva_watersheds_carnivores")
shapefiles <- list(pol=political,sa=study.area,huc=huc)
################################################
# Inputs
species <- c('fisher','lynx','wolverine')
gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
scenario <- c('_fisher_14','_lynx_050','_gulo_023_a2')

###############################################
# Read a table to set breaks
all_breaks <- list()
for (i in 1:3)
{
  filename=paste("D:/Box Sync/PNWCCVA/Outputs/",species[i],'/',species[i],'_huc_full_ave',scenario[i],'.dbf',sep='')
  print(filename)
  dt <- read.dbf(filename,as.is=TRUE)
  map <- merge(shapefiles[['huc']],dt,by='PNWCCVA_ID', all.x=FALSE)
  map@data$dens100 <- 100 * map@data$Y2000s/map@data$AREA_SQKM_
  temp <- range(map@data$dens100)
  all_breaks[[i]] <- seq(temp[1],temp[2],length.out=6)
  all_breaks[[i]][6] <- all_breaks[[i]][6] + 2
  print(all_breaks[[i]])
}
print(all_breaks)
stop('cbw')
###########################################
# Plot generation
plot.dens <- function(species, gcm, breaks, time, spatial_data=shapefiles)
{
  dt <- read.dbf(paste("D:/Box Sync/PNWCCVA/Outputs/",species[i],'/',species[i],'_huc_full_',gcm,'_',scenario[i],'.dbf',sep=''),as.is=TRUE)
  map <- merge(spatial_data[['huc']],dt,by='PNWCCVA_ID', all.x=FALSE)
  map@data$dens100 <- 100 * map@data[,time]/map@data$AREA_SQKM_
  map@data$cuts <- cut(map@data$dens100, breaks=breaks, labels=FALSE)
  ramp <- brewer.pal(5,name='Blues')
  map@data$colors <- ramp[map@data$cuts]

  # map@data$cuts <- cut(map@data$dens100, c(0.12,5), labels=FALSE)
  # ramp <- brewer.pal(2,name='Blues')
  # map@data$colors <- ramp[map@data$cuts]

  # stop('cbw')

  ###############################################
  # Plot
  png(paste("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Plots/",species,'_',gcm,'_',time,".png",sep=''))
  par(mar=c(0,0,0,0))
  plot(spatial_data[['pol']], col=rgb(189,189,189,max=255), xlim=c(-136,-106), ylim=c(38,58)) #, cex.axis=1.25)
  plot(map, add=TRUE, col=map@data$colors, border=FALSE)
  plot(spatial_data[['pol']], add=TRUE, col=NA)
  plot(study.area, add=TRUE, border='#99000d',lwd=2)
  dev.off()
}

plot.dens(
  species='wolverine', 
  gcm='ccsm3', 
  breaks=all_breaks[[3]], 
  time='Y2090s', 
  spatial_data=shapefiles
  )
  