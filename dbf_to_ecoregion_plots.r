

library(foreign)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
species <- 'wolverine'
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
scenario <- c('gulo_023_a2')
ecoregions <- unique(eco$ECO_CODE)
output <- as.data.frame(matrix(NA,nrow=length(ecoregions),ncol=7))
colnames(output) <- c('eco_name','eco_code',gcm)
# print(head(output)); stop('cbw')

for (i in 1:5)
{
  file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",species,'/',species,'_eco_full_',gcm[i],'_',scenario,'.dbf',sep='')
  temp <- read.dbf(file_name,as.is=TRUE)
  # print(colnames(temp))
  temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
  # print(colnames(temp))
  # stop('cbw')
  
  for (j in 1:length(ecoregions))
  {
    area <- temp[temp$ECO_CODE==ecoregions[j],'AREA_SQKM']
    output[j,(2+i)] <- round(100*as.numeric(temp[temp$ECO_CODE==ecoregions[j],'d2090s'])/area,5)
    output[j,'eco_name'] <- temp[temp$ECO_CODE==ecoregions[j],'ECO_NAME']
    output[j,'eco_code'] <- temp[temp$ECO_CODE==ecoregions[j],'ECO_CODE']
    # print(output)
    # stop('cbw')
  }
  # stop('cbw')
}

print(head(output))
boxplot(t(output[,3:7]))

