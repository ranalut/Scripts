
library(foreign)
library(tidyr)

# ================================================
# Table load and formatting...
# ================================================

eco <- read.dbf('D:/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_full.dbf',as.is=TRUE)

species <- c('white-headed woodpecker')
scenario <- c('_whwo_14_hab_v2')
sens <- list(c('full','clim'))
path <- c('white_headed_woodpecker/white_headed_woodpecker_eco_') 
thresh <- 100 # c(0.01) # Should relate to minimum homerange size or analogous
names(thresh) <- species
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  
  for (t in 1:length(sens[[n]]))
  {
    for (i in 1:5)
    {
      file_name <- paste("D:/Box Sync/PNWCCVA/Outputs/",path[n],sens[[n]][t],'_',gcm[i],scenario[n],'.dbf',sep='')
      temp <- read.dbf(file_name,as.is=TRUE)
      # print(colnames(temp))
      temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
      # print(colnames(temp))
      # stop('cbw')
      extract_columns <- c('ECO_NAME','ECO_CODE','AREA_SQKM','d2020','d2050','d2100',paste('Y',seq(2000,2100,10),sep=''))
      col_index <- match(extract_columns,colnames(temp))
      # print(col_index)
      
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
  # stop('cbw')
  
  # Drop eco regions that are never above min. density threshold
  drop_abs <- function(x,pred_table=output,thresh_value=thresh[n])
  {
    temp <- pred_table[pred_table$ECO_CODE==x,]
    # print(temp)
    must_be <- thresh_value
    # print(must_be)
    temp <- temp[,c('ECO_CODE','AREA_SQKM','Y2000','Y2020','Y2050','Y2100')]
    # print(temp)
    temp <- gather(temp, key='Year', value='Area',3:6)
    # temp$count_prop <- temp$Area / temp$AREA_SQKM
    # print(temp)
    # stop('cbw')
    test <- temp$Area >= must_be
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

write.csv(output2,"D:/Box Sync/PNWCCVA/MS_Woodpecker/Results/all_area_table_1.csv")
