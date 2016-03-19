
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)
library(rgdal)
library(foreign)

###############################################
# Spatial Data
political <- readShapePoly(fn='D:/Box Sync/PNWCCVA/PNWCCVA_GeoDatabases/Other GIS/admin_states.shp',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
 
study.area <- readOGR(dsn='D:/Box Sync/PNWCCVA/PNWCCVA_GeoDatabases/PNWCCVA_white-headed_woodpecker.gdb',layer="pnwccva_full_study_area")
 
huc <- readOGR(dsn='D:/Box Sync/PNWCCVA/PNWCCVA_GeoDatabases/PNWCCVA_white-headed_woodpecker.gdb',layer="pnwccva_watersheds_full")
shapefiles <- list(pol=political,sa=study.area,huc=huc)

################################################
# Inputs
species <- c('white_headed_woodpecker')
gcms <- c('ccsm3','cgcm3','giss','hadcm3','miroc') # 'ave'
dbf_names <- c('_whwo_14_hab_v2')
scenarios <- c('full')
years <- c('Y2000','Y2020','Y2050','Y2100')

###############################################
# Read a table to set breaks
all_breaks <- list()
for (i in 1)
{
  filename=paste("D:/Box Sync/PNWCCVA/Outputs/",species[i],'/',species[i],'_huc_',scenarios[i],'_ave',dbf_names[i],'.dbf',sep='')
  print(filename)
  dt <- read.dbf(filename,as.is=TRUE)
  map <- merge(shapefiles[['huc']],dt,by='PNWCCVA_ID', all.x=FALSE)
  map@data$prop <- map@data$Y2000/map@data$AREA_SQKM_
  map@data$prop[is.nan(map@data$prop)==TRUE] <- 0
  hist(map@data$prop)
  # log_dens <- log(1 + map@data$prop)
  # hist(log_dens)
  temp <- range(map@data$prop)
  all_breaks[[i]] <- seq(temp[1],temp[2],length.out=6)
  all_breaks[[i]][6] <- all_breaks[[i]][6] * 2 # increase upper limit to avoid NAs
  # all_breaks[[i]] <- exp(all_breaks[[i]]) - 1
  print(all_breaks[[i]])
}
print(all_breaks)
# stop('cbw')

###########################################
# Plot generation
plot.dens <- function(spp, gcm, scenario, dbf_name, breaks, year, spatial_data=shapefiles)
{
  # print(paste("D:/Box Sync/PNWCCVA/Outputs/",spp,'/',spp,'_huc_',scenario,'_',gcm,dbf_name,'.dbf',sep=''))
  dt <- read.dbf(paste("D:/Box Sync/PNWCCVA/Outputs/",spp,'/',spp,'_huc_',scenario,'_',gcm,dbf_name,'.dbf',sep=''),as.is=TRUE)
  map <- merge(spatial_data[['huc']],dt,by='PNWCCVA_ID', all.x=FALSE)
  map@data$prop <- map@data[,year]/map@data$AREA_SQKM_
  map@data$cuts <- cut(map@data$prop, breaks=breaks, labels=FALSE)
  ramp <- brewer.pal(5,name='Blues')
  map@data$colors <- ramp[map@data$cuts]

  # map@data$cuts <- cut(map@data$prop, c(0.12,5), labels=FALSE)
  # ramp <- brewer.pal(2,name='Blues')
  # map@data$colors <- ramp[map@data$cuts]

  # stop('cbw')

  ###############################################
  # Plot
  png(paste("D:/Box Sync/PNWCCVA/MS_Woodpecker/Plots/",spp,'_',gcm,'_',year,".png",sep=''),width=240,height=200)
  par(mar=c(0,0,0,0))
  plot(spatial_data[['pol']], col=rgb(189,189,189,max=255), xlim=c(-136,-102), ylim=c(38,58)) #, cex.axis=1.25)
  plot(map, add=TRUE, col=map@data$colors, border=FALSE)
  plot(spatial_data[['pol']], add=TRUE, col=NA)
  plot(study.area, add=TRUE, border='#99000d',lwd=2)
  dev.off()
}

for (i in 1)
{
  for (j in 1:length(gcms))
  {
    for (n in 1:4)
    {
      plot.dens(
        spp=species[i], 
        gcm=gcms[j], 
        scenario=scenarios[i], 
        dbf_name=dbf_names[i],
        breaks=all_breaks[[i]], 
        year=years[n], 
        spatial_data=shapefiles
        )
      # stop('cbw')
    }
    # stop('cbw')
  }
}
