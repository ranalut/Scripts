
# This is the script I used to calculate statistics in the Feb16 version of the manuscript.



library(foreign)
library(tidyr)

# ================================================
# Table load and formatting...
# ================================================

eco <- read.dbf('../Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_eco_','wolverine/wolverine_eco_','fisher/fisher_eco_') 
dens_thresh <- c(0.1,0.12,1)
names(dens_thresh) <- species
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  
  for (t in 1:length(sens[[n]]))
  {
    for (i in 1:5)
    {
      file_name <- paste("../Box Sync/PNWCCVA/Outputs/",path[n],sens[[n]][t],'_',gcm[i],scenario[n],'.dbf',sep='')
      temp <- read.dbf(file_name,as.is=TRUE)
      # print(colnames(temp))
      temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
      # print(colnames(temp))
      # stop('cbw')
      extract_columns <- c('ECO_NAME','ECO_CODE','AREA_SQKM','Y2000s','Y2020s','Y2050s','Y2090s','d2020s','d2050s','d2090s',paste('Y',seq(2000,2098,1),sep=''))
      col_index <- match(extract_columns,colnames(temp))
      
      if (n==1 & t==1 & i==1)
      { 
        output <- temp[,col_index]
        output$species <- rep(species[n],dim(output)[1])
        output$sens <- rep(sens[[n]][t],dim(output)[1])
        output$gcm <- rep(gcm[i],dim(output)[1])
      }
      else
      {
        temp2 <- temp[,col_index]
        temp2$species <- rep(species[n],dim(temp2)[1])
        temp2$sens <- rep(sens[[n]][t],dim(temp2)[1])
        temp2$gcm <- rep(gcm[i],dim(temp2)[1])
        output <- rbind(output,temp2)
      }
      # stop('cbw')
    }
    # stop('cbw')
  }
  
  # Drop eco regions that are never above min. density threshold
  drop_abs <- function(x,pred_table=output,thresh_value=dens_thresh[n])
  {
    temp <- pred_table[pred_table$ECO_CODE==x,]
    # print(temp)
    must_be <- thresh_value
    # print(must_be)
    temp <- temp[,c('ECO_CODE','AREA_SQKM','Y2000s','Y2020s','Y2050s','Y2090s')]
    temp <- gather(temp, key='Year', value='Count',3:6)
    temp$count_dens <- 100 * temp$Count / temp$AREA_SQKM
    # print(temp)
    # stop('cbw')
    test <- temp$count_dens >= must_be
    # print(test)
    # stop('cbw')
    if (sum(test)>=1) { return(x) }
    else { return(NA) }
  }
  
  all_spp <- unique(output$ECO_CODE)
  # all_spp <- all_spp[1:5] # for testing
  keep_spp <- lapply(all_spp,drop_abs)
  keep_spp <- unlist(keep_spp)
  keep_spp <- keep_spp[is.na(keep_spp)==FALSE]
  print(keep_spp)
  # stop('cbw')
  output <- output[output$ECO_CODE %in% keep_spp,]
  # stop('cbw')

  if ((n-1)==0) { output2 <- output }
  else { output2 <- rbind(output2,output) }
}

output2 <- data.frame(output2)

write.csv(output2,"../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/all_pop_table_1.csv")
