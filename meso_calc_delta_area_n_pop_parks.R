
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

myColors <- c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00')
parks <- list('Rainier','North Cascades','Olympic')

# eco <- read.dbf('./Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
# huc <- read.dbf('./Outputs/pnwccva_watersheds_carnivores.dbf',as.is=TRUE)
pa <- read.dbf('./Outputs/pnwccva_protected_areas_carnivores.dbf',as.is=TRUE)
indices <- unlist(lapply(parks,grep, pa$NAME))
pa <- pa[indices,]

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_pa_','wolverine/wolverine_pa_','fisher/fisher_pa_') 
dens_thresh <- c(0.5,0.12,1.8) # see comment in ms version from 15feb16 for how these thresholds were selected.
names(dens_thresh) <- species
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

n <- 3 # 2 is wolverine, 3 is fisher

  cat('start',species[n],'\n')
  output <- NULL
  
  for (t in 1:length(sens[[n]]))
  {
    for (i in 1:5)
    {
      file_name <- paste("./Outputs/",path[n],sens[[n]][t],'_',gcm[i],scenario[n],'.dbf',sep='')
      temp <- read.dbf(file_name,as.is=TRUE)
      # print(colnames(temp))
      temp <- merge(pa,temp,all.x=TRUE,all.y=FALSE) # , by='OBJECT_ID')
      # print(colnames(temp))
      # stop('cbw')
      
      if (n==2 & t==1 & i==1) # Change b/c lynx has not summary for protected areas
      { 
        output <- temp[,c('NAME','AREA_SQKM','Y2000s','Y2020s','Y2050s','Y2090s')]
        output$species <- rep(species[n],dim(output)[1])
        output$sens <- rep(sens[[n]][t],dim(output)[1])
        output$gcm <- rep(gcm[i],dim(output)[1])
      }
      else
      {
        temp2 <- temp[,c('NAME','AREA_SQKM','Y2000s','Y2020s','Y2050s','Y2090s')]
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

output2 <- data.frame(output)

###################################################
# Population
output3 <- gather(output2, key=year, value=count, -NAME, -AREA_SQKM, -species, -sens, -gcm)
# park_areas <- output4[1:7,1:2]
# park_areas <- ddply(park_areas,.(NAME),summarize, AREA_SQKM=sum(AREA_SQKM))
output4 <- ddply(output3, 
                 .(NAME,species,sens,gcm,year), 
                 summarize, 
                 AREA_SQKM=sum(AREA_SQKM),
                 count=sum(count)
                 )
output4 <- mutate(output4, density = 100 * count / AREA_SQKM)
temp <- output4[seq(1,dim(output4)[1],4),]
output4$start <- rep(temp$count,each=4)
output4$delta <- output4$count - output4$start
bar_table2 <- filter(output4, (sens=='50' | sens=='full')) # Full model
bar_table3 <- filter(bar_table2, year!='Y2000s')
bar_table3$year <- substr(bar_table3$year,2,6)
bar_table3$p_delta <- 100 * bar_table3$delta / bar_table3$start
bar_table4 <- aggregate(p_delta ~ NAME + species + year, data=bar_table3, FUN=mean)

p <- ggplot() + geom_hline(yintercept = 0) +
  geom_bar(data=bar_table4, aes(x=year, y=p_delta), stat='identity',width=0.35, colour="#636363", fill="#cccccc") + ylim(-100,50) + 
  facet_wrap(~ NAME, nrow=3, scales='free') + 
  geom_jitter(data=bar_table3, aes(x=year, y=p_delta, colour=gcm), position = position_jitter(w = 0.085, h = 0), size=4) + scale_colour_brewer(palette="Set1") + ylab('percent change in population size') + theme(legend.key = element_rect(fill = NA), panel.background = element_blank(), panel.grid.minor.y = element_blank(),  panel.grid.major.y=element_blank(), strip.background = element_blank(), strip.text.x = element_text(size = 16)) 
# , strip.background = element_blank()) , strip.text.x = element_blank())  +
p

png(paste("./MS_MesoCarnivores/1_Results/",species[n],"_pd_count_wa_parks.png",sep=''),height=500)
  plot(p)
dev.off()


write.csv(bar_table3,paste("./MS_MesoCarnivores/1_Results/",species[n],"delta_wa_parks3.csv",sep=''))
write.csv(bar_table4,paste("./MS_MesoCarnivores/1_Results/",species[n],"delta_wa_parks4.csv",sep=''))

