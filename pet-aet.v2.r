library(ncdf)
library(rgdal)
library(raster)
library(foreign)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
# hexsimWorkspace <- 'sage_grouse_v2'
setwd(paste(workspace,'Scripts/',sep=''))

# # =======================================================================================================
# # WGS 84 grid for biomes data...

# theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/albers_centroids_1km_wgs84.dbf',sep=''), as.is=TRUE)
# theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

aet.nc <- raster(paste(workspace,'ClimateData/wna30sec_cru_ts_2.1_aet_ann_ltm_1961-1990.nc',sep=''),varname='aet_ann_ltm')
# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')
print(aet.nc)

pet.nc <- raster(paste(workspace,'ClimateData/wna30sec_cru_ts_2.1_pet_ann_ltm_1961-1990.nc',sep=''),varname='pet_ann_ltm')
print(pet.nc)

print('calculating...')
deficit <- pet.nc - aet.nc

print('writing...')
writeRaster(deficit,paste(workspace,'ClimateData/pet-aet_ann_1961-1990',sep=''),format='CDF')

# sagr distribution and deficit

current.dist <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/current.step0.csv',sep=''),header=TRUE)
deficit <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/deficit.step0.csv',sep=''),header=TRUE)
sagebrush <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/sagebrush.step0.csv',sep=''),header=TRUE)
mgmt.zones <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/mgmt.zones.step0.csv',sep=''),header=TRUE)
human <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/human.foot.leu.r1km.csv',sep=''),header=TRUE)

all.pts <- data.frame(hex.id=current.dist$hex_id, current=current.dist$extract.vector, deficit=deficit$extractedData, sagebrush=sagebrush$extractedData, mgmt.zone=mgmt.zones$extract.vector, human=human$extractedData2)
valid.pts <- all.pts[all.pts$deficit!=0,]

print(table(valid.pts$mgmt.zone,valid.pts$sagebrush))
print(table(valid.pts$mgmt.zone[valid.pts$deficit<720],valid.pts$sagebrush[valid.pts$deficit<720]))
print(table(valid.pts$mgmt.zone[valid.pts$deficit<720 & valid.pts$human<60],valid.pts$sagebrush[valid.pts$deficit<720 & valid.pts$human<60]))

valid.pts.pres <- valid.pts[valid.pts$current==1,]
valid.pts.abs <- valid.pts[valid.pts$current!=1,]

par(mfrow=c(2,2))
hist(valid.pts.pres$deficit,main='presences',breaks=seq(0,1100,25))
hist(valid.pts.abs$deficit,main='absences',breaks=seq(0,1100,25))

sample.pts.pres <- sample(seq(1,dim(valid.pts.pres)[1]), 10000)
sample.pts.abs <- sample(seq(1,dim(valid.pts.pres)[1]), 10000)

hist(valid.pts.pres$deficit[sample.pts.pres],main='presences',breaks=seq(0,1100,25))
hist(valid.pts.abs$deficit[sample.pts.abs],main='absences',breaks=seq(0,1100,25))

pres.quant <- quantile(valid.pts.pres$deficit[sample.pts.pres],probs=c(0,0.25,0.5,0.75,0.9, 0.95,0.98,1))
print(pres.quant)

# ks.test(valid.pts.pres$deficit[sample.pts.pres],'pnorm',mean=mean(valid.pts.pres$deficit[sample.pts.pres]),sd=mean(valid.pts.pres$deficit[sample.pts.pres]))
# ks.test(valid.pts.pres$deficit[sample.pts.pres],'plnorm',mean=mean(log(valid.pts.pres$deficit[sample.pts.pres])),sd=mean(log(valid.pts.pres$deficit[sample.pts.pres])))

# theDist <- fitdistr(valid.pts.pres$deficit[sample.pts.pres],'normal')
# ks.test(valid.pts.pres$deficit[sample.pts.pres],'pnorm',mean=theDist$estimate[1],sd=theDist$estimate[2])

# theDist <- fitdistr(valid.pts.pres$deficit[sample.pts.pres],'logistic')
# ks.test(valid.pts.pres$deficit[sample.pts.pres],'plnorm',mean=theDist$estimate[1],sd=theDist$estimate[2])
