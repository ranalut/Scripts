

library(foreign)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
species <- 'wolverine'
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
scenario <- c('gulo_023_a2')
ecoregions <- unique(eco$ECO_NUM)
output <- matrix(NA,nrow=length(ecoregions),ncol=7)
colnames(output) <- c('eco_name','eco_num',gcm)

for (i in 1:5)
{
  file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",species,'/',species,'_eco_full_',gcm[i],'_',scenario,'.dbf',sep='')
  temp <- read.dbf(file_name,as.is=TRUE)
  temp <- merge(eco,temp)
  
  for (j in 1:length(ecoregions))
  {
    print(c(as.vector(temp[temp$ECO_NUM==ecoregions[j],c('ECO_NAME','ECO_NUM','d2090s')])))
    stop('cbw')
    output[i,c(1,2,(2+i))] <- c(as.vector(temp[temp$ECO_NUM==ecoregions[j],c('ECO_NAME','ECO_NUM','d2090s')]))
    print(output)
    output[i,(2+i)] <- output[i,(2+i)]/temp[temp$ECO_NUM==ecoregions[j],c('AREA_SQKM')]
    print(output)
    stop('cbw')
  }
}


