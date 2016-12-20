
# Psuedo code
# Load the average populations, use the same minimum cutoffs as before. 
# Calucate area (based on watersheds)
# Calculate populations (based on watersheds)
# Put in a table with appropriate columns to build the bar chart
# Make bar chart with ggplot

library(plyr)
library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)
library(MuMIn)
library(tidyr)
library(dplyr)

setwd('C:/Users/cwilsey.NAS/Box Sync/PNWCCVA/')
# setwd('C:/Users/cwilsey/Box Sync/PNWCCVA/')

parks <- list('Rainier','North Cascades')
myColors <- c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00')

# eco <- read.dbf('D:/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
# huc <- read.dbf('D:/Box Sync/PNWCCVA/Outputs/pnwccva_watersheds_full.dbf',as.is=TRUE)
pa <- read.dbf('./Outputs/pnwccva_protected_areas_full.dbf',as.is=TRUE)
indices <- unlist(lapply(parks,grep, pa$NAME))
pa <- pa[indices,]

species <- c("Clark's Nutcracker")
spp <- 'clnu'
scenario <- c('_hab_v2')
sens <- list(c('full','clim','veg'))
path <- c('clarks_nutcracker/clarks_nutcracker_pa_') 
dens_thresh <- c(0.01)
names(dens_thresh) <- species
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  
  for (t in 1:length(sens[[n]]))
  {
    for (i in 1:5)
    {
      file_name <- paste("./Outputs/",path[n],sens[[n]][t],'_',gcm[i],scenario[n],'.dbf',sep='')
      temp <- read.dbf(file_name,as.is=TRUE)
      # print(colnames(temp))
      temp <- merge(pa,temp,all.x=TRUE,all.y=FALSE) # , by='PNWCCVA_ID')
      # print(colnames(temp))
      # stop('cbw')
      
      if (n==1 & t==1 & i==1)
      { 
        output <- temp[,c('NAME','AREA_SQKM','Y2000','Y2020','Y2050','Y2100')]
        output$species <- rep(species[n],dim(output)[1])
        output$sens <- rep(sens[[n]][t],dim(output)[1])
        output$gcm <- rep(gcm[i],dim(output)[1])
      }
      else
      {
        temp2 <- temp[,c('NAME','AREA_SQKM','Y2000','Y2020','Y2050','Y2100')]
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

###################################################
# Population
output4 <- gather(output3, key=year, value=area, -NAME, -AREA_SQKM, -species, -sens, -gcm)
output4 <- ddply(output4, 
                 .(NAME,species,sens,gcm,year), 
                 summarize, 
                 AREA_SQKM=sum(AREA_SQKM),
                 area=sum(area)
                 )
temp <- output4[seq(1,dim(output4)[1],4),]
output4$start <- rep(temp$area,each=4)
output4$delta <- output4$area - output4$start
bar_table2 <- filter(output4, (sens=='50' | sens=='full')) # & species=='lynx'
bar_table3 <- filter(bar_table2, year!='Y2000')
bar_table3$year <- substr(bar_table3$year,2,6)
bar_table3$p_delta <- 100 * bar_table3$delta / bar_table3$start
bar_table4 <- aggregate(p_delta ~ NAME + species + year, data=bar_table3, FUN=mean)

p <- ggplot() + 
  geom_bar(data=bar_table4, aes(x=year, y=p_delta), stat='identity',width=0.35, colour="#636363", fill="#cccccc") + ylim(-100,75) + 
  facet_wrap(~ NAME, nrow=length(parks), scales='free') + 
  geom_jitter(data=bar_table3, aes(x=year, y=p_delta, colour=gcm), position = position_jitter(w = 0.06, h = 0.2), size=4) + scale_colour_brewer(palette="Set1") + ylab('percent change in occupied area') + theme(legend.key = element_rect(fill = NA), panel.background = element_blank(), panel.grid.minor.y = element_blank(),  panel.grid.major.y=element_blank(), strip.background = element_blank(), strip.text.x = element_text(size = 16)) 
# , strip.background = element_blank()) , strip.text.x = element_blank())  +
p

png(paste("./MS_nutcracker/Results/",spp,"_wa_parks_area.png",sep=''),height=500)
  plot(p)
dev.off()

write.csv(bar_table3,paste("./MS_nutcracker/Results/",spp,"_wa_parks_delta_area3.csv",sep=''))
write.csv(bar_table4,paste("./MS_nutcracker/Results/",spp,"_wa_parks_delta_area4.csv",sep=''))
