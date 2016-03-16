
# Psuedo code
# Load the average populations, use the same minimum cutoffs as before. 
# Calucate area (based on watersheds)
# Calculate populations (based on watersheds)
# Put in a table with appropriate columns to build the bar chart
# Make bar chart with ggplot

library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)
library(MuMIn)
library(tidyr)
library(dplyr)

myColors <- c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00')

# eco <- read.dbf('D:/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
huc <- read.dbf('D:/Box Sync/PNWCCVA/Outputs/pnwccva_watersheds_carnivores.dbf',as.is=TRUE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_huc_','wolverine/wolverine_huc_','fisher/fisher_huc_') 
dens_thresh <- c(0.5,0.12,1.8) # see comment in ms version from 15feb16 for how these thresholds were selected.
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
      temp <- merge(huc,temp,all.x=TRUE,all.y=FALSE) # , by='PNWCCVA_ID')
      # print(colnames(temp))
      # stop('cbw')
      
      if (n==1 & t==1 & i==1)
      { 
        output <- temp[,c('PNWCCVA_ID','AREA_SQKM_','Y2000s','Y2020s','Y2050s','Y2090s')]
        output$species <- rep(species[n],dim(output)[1])
        output$sens <- rep(sens[[n]][t],dim(output)[1])
        output$gcm <- rep(gcm[i],dim(output)[1])
      }
      else
      {
        temp2 <- temp[,c('PNWCCVA_ID','AREA_SQKM_','Y2000s','Y2020s','Y2050s','Y2090s')]
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

output3 <- output2
output3[,c('Y2000s','Y2020s','Y2050s','Y2090s')] <- 100 * output3[,c('Y2000s','Y2020s','Y2050s','Y2090s')] / matrix(output3[,'AREA_SQKM_'],ncol=3,nrow=dim(output3)[1])

#############################################
# Area
output4 <- gather(output3, key=year, value=density, -PNWCCVA_ID, -AREA_SQKM_, -species, -sens, -gcm)
spp <- species
output5 <- list()
for (i in 1:3) { output5[[i]] <- filter(output4, species==spp[i] & density >= dens_thresh[i]) }
output6 <- do.call(rbind, output5)
output6$AREA_SQKM_ <- output6$AREA_SQKM_ / 1000

bar_table <- aggregate(AREA_SQKM_ ~ species + sens + gcm + year ,data=output6, FUN=sum)

bar_table2 <- filter(bar_table, (sens=='50' | sens=='full')) # & species=='lynx'

temp <- filter(bar_table2, year=='Y2000s')
temp <- rbind(temp,temp,temp)
bar_table3 <- filter(bar_table2, year!='Y2000s')
bar_table3$year <- substr(bar_table3$year,2,6)
bar_table3$delta <- bar_table3$AREA_SQKM_ - temp$AREA_SQKM_
bar_table3$p_delta <- bar_table3$delta / temp$AREA_SQKM_
bar_table4 <- aggregate(p_delta ~ species + year, data=bar_table3, FUN=mean)
# stop('cbw')

p <- ggplot() + 
  geom_bar(data=bar_table4, aes(x=year, y=p_delta), stat='identity',width=0.35, colour="#636363", fill="#cccccc") + ylim(-0.6,0.3) + 
  facet_wrap(~ species, nrow=3, scales='free') + 
  geom_jitter(data=bar_table3, aes(x=year, y=p_delta, colour=gcm), position = position_jitter(w = 0.05, h = 0.2), size=4) + scale_colour_brewer(palette="Set1") + ylab('percent change in area') + theme(legend.key = element_rect(fill = NA), panel.background = element_blank(), panel.grid.minor.y = element_blank(),  panel.grid.major.y=element_line(colour = "#cccccc")) 
# , strip.background = element_blank()) , strip.text.x = element_blank())  +
p

png("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/pd_acreages3.png",height=500)
  plot(p)
dev.off()
write.csv(bar_table3,"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/delta_acreages3.csv")
# stop('cbw')

###################################################
# Population
output4 <- gather(output3, key=year, value=density, -PNWCCVA_ID, -AREA_SQKM_, -species, -sens, -gcm)
output4 <- mutate(output4, pop = AREA_SQKM_ * density / 1000)
spp <- species
output5 <- list()
for (i in 1:3) { output5[[i]] <- filter(output4, species==spp[i] & density >= dens_thresh[i]) }
output6 <- do.call(rbind, output5)

bar_table <- aggregate(pop ~ species + sens + gcm + year ,data=output6, FUN=sum)

bar_table2 <- filter(bar_table, (sens=='50' | sens=='full')) # & species=='lynx'

temp <- filter(bar_table2, year=='Y2000s')
temp <- rbind(temp,temp,temp)
bar_table3 <- filter(bar_table2, year!='Y2000s')
bar_table3$year <- substr(bar_table3$year,2,6)
bar_table3$delta <- bar_table3$pop - temp$pop
bar_table3$p_delta <- bar_table3$delta / temp$pop
bar_table4 <- aggregate(p_delta ~ species + year, data=bar_table3, FUN=mean)

p <- ggplot() + 
  geom_bar(data=bar_table4, aes(x=year, y=p_delta), stat='identity',width=0.35, colour="#636363", fill="#cccccc") + ylim(-0.6,0.3) + 
  facet_wrap(~ species, nrow=3, scales='free') + 
  geom_jitter(data=bar_table3, aes(x=year, y=p_delta, colour=gcm), position = position_jitter(w = 0.05, h = 0.2), size=4) + scale_colour_brewer(palette="Set1") + ylab('percent change in population') + theme(legend.key = element_rect(fill = NA), panel.background = element_blank(), panel.grid.minor.y = element_blank(),  panel.grid.major.y=element_line(colour = "#cccccc")) 
# , strip.background = element_blank()) , strip.text.x = element_blank())  +
p

png("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/pd_population3.png",height=500)
  plot(p)
dev.off()

write.csv(bar_table3,"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/delta_population3.csv")

