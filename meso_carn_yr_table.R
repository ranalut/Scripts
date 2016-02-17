
# This is the script I used to calculate statistics in the Feb16 version of the manuscript.

library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)
library(MuMIn)
library(tidyr)
library(dplyr)

# ================================================
# Table load and formatting...
# ================================================

eco <- read.dbf('D:/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)

species <- c('fisher','lynx','wolverine')
scenario <- c('_fisher_14','_lynx_050','_gulo_023_a2')
sens <- list(c('full','temp','swe','biomes'),c('50','35'), c('full','swe','biomes'))
path <- c('fisher/fisher_eco_','lynx/lynx_eco_','wolverine/wolverine_eco_') 
dens_thresh <- c(1,0.1,0.1)
names(dens_thresh) <- species
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
      
      if (n==1 & t==1 & i==1)
      { 
        output <- temp[,c('ECO_NAME','ECO_CODE','AREA_SQKM','Y2000s','Y2020s','Y2050s','Y2090s')]
        output$species <- rep(species[n],dim(output)[1])
        output$sens <- rep(sens[[n]][t],dim(output)[1])
        output$gcm <- rep(gcm[i],dim(output)[1])
      }
      else
      {
        temp2 <- temp[,c('ECO_NAME','ECO_CODE','AREA_SQKM','Y2000s','Y2020s','Y2050s','Y2090s')]
        temp2$species <- rep(species[n],dim(temp2)[1])
        temp2$sens <- rep(sens[[n]][t],dim(temp2)[1])
        temp2$gcm <- rep(gcm[i],dim(temp2)[1])
        output <- rbind(output,temp2)
      }
      # stop('cbw')
    }
    # stop('cbw')
  }
  
  if ((n-1)==0) { output2 <- output }
  else { output2 <- rbind(output2,output) }
}

output2 <- data.frame(output2)
# output_list <- list()

# Having a hard time implementing the minimum density criteria...

# for (i in 1:3)
# {
#   temp <- output2[species==species[i],]
#   temp <- select(temp,Y2000s:Y2090s)/temp$AREA_SQKM
#   test <- apply(temp,1,FUN = function(x) {y <- x >= dens_thresh[i];sum(y)})
#   output_list[[i]] <- temp[test>=3,]
# }
output3 <- gather(output2,'year','pop',Y2000s:Y2090s)
output3$year <- as.character(levels(output3$year))[output3$year]
output3$year <- as.numeric(substr(output3$year,2,5))

output4 <- split(output3, output3$species) # Dataframe to list by species.
# stop('cbw')
output5 <- list()

drop_abs <- function(x,pred_table,must_be, field)
{
  # print(x)
  temp <- 100 * pred_table[pred_table$ECO_CODE==x,field]/pred_table[pred_table$ECO_CODE==x,'AREA_SQKM'] # Per 100 km2
  test <- temp >= must_be
  if (sum(test)>=1) { return(x) }
  else { return(NA) }
}

for (i in 1:3)
{
  temp_table <- output4[[i]]
  all_eco <- unique(temp_table$ECO_CODE)
  keep_eco <- lapply(all_eco,drop_abs,pred_table=temp_table,must_be=dens_thresh[i],field='pop')
  keep_eco <- unlist(keep_eco)
  keep_eco <- keep_eco[is.na(keep_eco)==FALSE]
  cat('remaining ecoregions: ',keep_eco,'\n')
  # stop('cbw')
  temp_table <- temp_table[temp_table$ECO_CODE %in% keep_eco,]
  # stop('cbw')
  output5[[i]] <- temp_table
}
# stop('cbw')
output6 <- do.call(rbind, output5) # unsplit(output5, output3$species)

write.csv(output6,"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/yr_pop_table_thresh.csv")
