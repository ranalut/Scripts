

library(ggplot2)
library(foreign)

theData <- read.dbf("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/wolverine/wolverine_eco_full_ave_gulo_023_a2.dbf",as.is=TRUE)
eco <- read.dbf("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf",as.is=TRUE)
print(colnames(theData))
print(colnames(eco))
theData <- merge(theData,eco[,c('ECO_ID_U','ECO_NAME','AREA_SQKM')])
print(colnames(theData))

theData.2 <- as.data.frame(t(theData[3,2:101]))
colnames(theData.2) <- 'Abundance'
theData.2$Year <- seq(2000,2099,1)

g <- ggplot(theData.2, aes(Year, Abundance)) + geom_point(color="firebrick")
g

