
# This version is only set to do the fixed effects with no interactions

# Need to run this...
# Install "reshape" from CRAN
# install.packages("coefplot2", repos="http://www.math.mcmaster.ca/bolker/R", type="source")

library(foreign)
library(ggplot2)
library(gridExtra)
library(coefplot2)

species <- c('wolverine','fisher','lynx')
species_titles <- c('Wolverine','Fisher','Canada lynx')
sens <- list(c('full','swe','biomes'),c('full','temp','swe','biomes'),c('50','35'))
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

for (n in 1:length(species))
{
  cat('start',species[n],'\n')
  n_sens <- length(sens[[n]])
  file_name <- paste("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/",species[n],"_log_lmer_coef.csv",sep='')
  temp <- read.csv(file_name,stringsAsFactors=FALSE)
  
  file_name <- paste("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/",species[n],"_log_lmer_95_ci_n3.csv",sep='')
  temp2 <- read.csv(file_name,stringsAsFactors=FALSE)
  temp <- cbind(temp[,2],temp2[,2:3])
  all_fixef <- temp2[,1]
  n_fe <- length(all_fixef)
  
  output <- as.data.frame(matrix(NA,ncol=5,nrow=n_fe))
  colnames(output) <- c('species','parameter','estimate','low','high')
  
  
  
  ref_value <- temp[1,1]
  
  for (t in 1:n_fe)
  {
    if (t==1) { output[1,] <- c(species[n],all_fixef[1],temp[,1:3]) }
    else
    {
      adj_values <- temp[t,] + ref_value
      output[t,] <- c(species[n],all_fixef[t],adj_values)  
    }
  }
  print(output); stop('cbw')

# stop('cbw')

if ((n-1)==0) { output2 <- output }
else { output2 <- rbind(output2,output) }
}
# print(head(output))
# boxplot(t(output[,3:7]))
stop('cbw')
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