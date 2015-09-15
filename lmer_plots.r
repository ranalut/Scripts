
library(foreign)
library(ggplot2)
library(gridExtra)

species <- c('wolverine','fisher','lynx')
species_titles <- c('Wolverine','Fisher','Canada lynx')
sens <- list(c('full','swe','biomes'),c('full','temp','swe','biomes'),c('50','35'))
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  n_sens <- length(sens[[n]])
  file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/",species[n],"_lmer_coef.csv",sep='')
  temp <- read.csv(file_name,row.names=1,stringsAsFactors=FALSE)
  
  output <- as.data.frame(matrix(NA,ncol=6,nrow=5*n_sens))
  colnames(output) <- c('species','scenario','gcm','estimate','se','t')
  
  o_sens <- sens[[n]][order(sens[[n]])]
  o_gcm <- gcm[order(gcm)]
  # stop('cbw')
  
  for (t in 1:n_sens)
  {
    if (t==1) { output[1,] <- c(species[n],o_sens[t],o_gcm[1],round(c(temp[1,1],temp[1,2],temp[1,3]),4)) }
    else { output[(5*(t-1)+1),] <- c(species[n],o_sens[t],o_gcm[1],round(c(temp[1,1]+temp[t,1],temp[t,2],temp[t,3]),4)) }
    
    for (i in 2:5)
    {
      if (t==1) { output[(5*(t-1)+i),] <- c(species[n],o_sens[t],o_gcm[i],round(c(temp[1,1]+temp[(n_sens+i-1),1],temp[(n_sens+i-1),2],temp[(n_sens+i-1),3]),4)) }
      else { output[(5*(t-1)+i),] <- c(species[n],o_sens[t],o_gcm[i],round(c(temp[1,1]+temp[t,1]+ temp[(n_sens+i-1),1],temp[(n_sens+i-1),2],temp[(n_sens+i-1),3]),4)) }
    }
  # stop('cbw')
  }
# stop('cbw')

if ((n-1)==0) { output2 <- output }
else { output2 <- rbind(output2,output) }
}
# print(head(output))
# boxplot(t(output[,3:7]))
output2[,4:6] <- apply(X=output2[,4:6],MARGIN=2,FUN=as.numeric)
# stop('cbw')

  plots <- list()

    for (i in 1:length(species))
    {
      dodge <- position_dodge(width=0.15)
      temp <- output2[output2$species==species[i],]
      plots[[i]] <- ggplot(temp,aes(factor(scenario),estimate,colour=factor(gcm),ymin=estimate-se, ymax=estimate+se)) + 
        geom_point(alpha=0.75,size=4,position=dodge) + 
        geom_errorbar(position=dodge,width=.1) +
        guides(colour=guide_legend(title="GCM")) + 
        theme(axis.text.x = element_text(size = 12, angle = 45,hjust=1)) + 
        theme(axis.title.x = element_text(size = 14)) + 
        xlab("Scenario") + 
        ylab("Change in Individuals / 100 km2") +
        ggtitle(species_titles[i]) +
        theme(plot.title = element_text(hjust = 0))
    }

png(paste('C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/model_based_scenario_change_fig.png',sep=''),height=960,width=480)
par(mfrow=c(3,1))
  grid.arrange(plots[[1]],plots[[2]],plots[[3]], nrow=3, ncol=1)
dev.off()

# p + geom_boxplot() + theme(axis.text.x = element_text(size = 12, angle = 45,hjust=1)) + theme(axis.title.x = element_text(size = 12)) + xlab("Ecoregion") + ylab("Change in Individuals / 100 km2")

# + geom_jitter()