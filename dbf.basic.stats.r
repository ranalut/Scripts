eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_eco_','wolverine/wolverine_eco_','fisher/fisher_eco_') 

ecoregion <- 'NA0524'
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
output <- as.data.frame(matrix(NA,nrow=length(length(unlist(sens))),ncol=5))
colnames(output) <- c('eco_name','eco_code','species','sens','pop')

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  
   for (t in 1:length(sens[[n]]))
   {
#     for (i in 1:5)
#     {
      file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",path[n],sens[[n]][t],'_ave',scenario[n],'.dbf',sep='')
      temp <- read.dbf(file_name,as.is=TRUE)
      # print(colnames(temp))
      temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
      # print(colnames(temp))
      # stop('cbw')
      
      # area <- temp[temp$ECO_CODE==ecoregion,'AREA_SQKM']
      output[t,'pop'] <- round(100*as.numeric(temp[temp$ECO_CODE==ecoregion,'Y2000s']),5)
      output[t,'eco_name'] <- temp[temp$ECO_CODE==ecoregion,'ECO_NAME']
      output[t,'eco_code'] <- temp[temp$ECO_CODE==ecoregion,'ECO_CODE']
      output[t,'sens'] <- sens[[n]][t]
      output[t,'species'] <- species[n]
      # print(output)
      # stop('cbw')
#     }
  }
  
  if ((n-1)==0) { output2 <- output }
  else { output2 <- rbind(output2,output) }
}
# print(head(output))
# boxplot(t(output[,3:7]))
# stop('cbw')
