
# To run this script copy into console...
# for (map in 1:3) { source('post.process.rabbit.r') }

source('export.hexmaps.r')

spp.folder <- 'rabbit_v1' # 'woodpecker_v1' # 'nutcracker_v1' 
map.name <- 'distribution'
scenario <- 'rabbit.020.hab.v2.'
theGCMs <- c('ccsm3','cgcm3','giss-er','miroc','hadcm3')
model.types <- list(c('','clim.','veg.'),c('full','clim','veg'))
reps <- 25
parameters <- list(list(1,'eco','ECO_ID_U',c(17026:17097)), list(2,'huc','PNWCCVA_ID',c(1:1549)), list(3,'pa','OBJECTID', c(1:1252)))

time.steps <- seq(10,110,10)

source('consolidate.maps.r')