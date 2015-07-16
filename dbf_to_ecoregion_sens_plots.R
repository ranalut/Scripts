# focus on ecoregion NA0524 (Yellowstone) for sensitivity analysis

library(foreign)
library(ggplot2)
library(gridExtra)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_eco_','wolverine/wolverine_eco_','fisher/fisher_eco_') 

ecoregion <- 'NA0524'
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
output <- as.data.frame(matrix(NA,nrow=length(length(unlist(sens))),ncol=9))
colnames(output) <- c('eco_name','eco_code','species','sens',gcm)

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  
  for (t in 1:length(sens[[n]]))
  {
    for (i in 1:5)
    {
      file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",path[n],sens[[n]][t],'_',gcm[i],scenario[n],'.dbf',sep='')
      temp <- read.dbf(file_name,as.is=TRUE)
      # print(colnames(temp))
      temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
      # print(colnames(temp))
      # stop('cbw')
      
      area <- temp[temp$ECO_CODE==ecoregion,'AREA_SQKM']
      output[t,(4+i)] <- round(100*as.numeric(temp[temp$ECO_CODE==ecoregion,'d2050s'])/area,5)
      output[t,'eco_name'] <- temp[temp$ECO_CODE==ecoregion,'ECO_NAME']
      output[t,'eco_code'] <- temp[temp$ECO_CODE==ecoregion,'ECO_CODE']
      output[t,'sens'] <- sens[[n]][t]
      output[t,'species'] <- species[n]
      # print(output)
      # stop('cbw')
    }
  }
  
  if ((n-1)==0) { output2 <- output }
  else { output2 <- rbind(output2,output) }
}
# print(head(output))
# boxplot(t(output[,3:7]))

# stop('cbw')

  output3 <- data.frame(species=rep(output2$species,each=5),sens=rep(output2$sens,each=5),model=rep(gcm,length(output2$species)),change=c(apply(output2[,5:9],1,as.vector)))
  
  plots <- list()

    for (i in 1:length(species))
    {
      temp <- output3[output3$species==species[i],]
      plots[[i]] <- ggplot(temp) + geom_point(aes(factor(sens),change,colour=factor(model)),alpha=0.75,size=4) + guides(colour=guide_legend(title="GCM")) + theme(axis.text.x = element_text(size = 12, angle = 45,hjust=1)) + theme(axis.title.x = element_text(size = 14)) + xlab("Scenario") + ylab("Change in Individuals / 100 km2")
      # plot(p)
    }

png(paste('C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/sens_eco_0524_change_fig_2.png',sep=''),height=960,width=480)
par(mfrow=c(3,1))
  grid.arrange(plots[[1]],plots[[2]],plots[[3]], nrow=3, ncol=1)
dev.off()

# p + geom_boxplot() + theme(axis.text.x = element_text(size = 12, angle = 45,hjust=1)) + theme(axis.title.x = element_text(size = 12)) + xlab("Ecoregion") + ylab("Change in Individuals / 100 km2")

# + geom_jitter()