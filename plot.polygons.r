
library(maptools)
library(sp)

# temp <- read.dbf('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions/mostly_in_study_grid_ecoregions.dbf',as.is=TRUE)

eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='FID',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

ss <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/lynx.041b/lynx.041b-[1]/eco.BirthsMinusDeaths.table.csv',header=TRUE)

# merge()

