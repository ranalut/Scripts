
# To run this script copy into console...
# for (map in 1:3) { source('post.process.nutcracker.r') }

source('export.hexmaps.r')

spp.folder <- 'nutcracker_v1' 
scenario <- 'hab.v2.'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
model.types <- list(c('','clim.','veg.'),c('full','clim','veg'))
reps <- 25
parameters <- list(list(1,'eco','ECO_ID_U',c(17026:17097)), list(2,'huc','PNWCCVA_ID',c(1:1549)), list(3,'pa','OBJECTID', c(1:1252)))
thresholds <- c(0.515,0.52,0.64)
time.steps <- seq(10,110,10)

source('consolidate.hab.maps.r')