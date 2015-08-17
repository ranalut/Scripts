

library(foreign)
library(ggplot2)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
abbrev <- read.csv("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/eco_abbrev.csv",stringsAsFactors=FALSE)
colnames(abbrev) <- c('eco_name','eco_code','abbrev')

species <- c('lynx50','lynx35','wolverine','fisher')
scenario <- c('_lynx_050','_lynx_050','_gulo_023_a2','_fisher_14') 
path <- c('lynx/lynx_eco_50_','lynx/lynx_eco_35_','wolverine/wolverine_eco_full_','fisher/fisher_eco_full_') 
dens_thresh <- c(0.1,0.1,0.1,1)

for (n in 1:length(species))
{
  gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
  ecoregions <- unique(eco$ECO_CODE)
  output <- as.data.frame(matrix(NA,nrow=length(ecoregions),ncol=8))
  colnames(output) <- c('eco_name','eco_code',gcm,'Y2000s')
  # print(head(output)); stop('cbw')
  cat('start',species[n],'\n')
  
  for (i in 1:5)
  {
    file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",path[n],gcm[i],scenario[n],'.dbf',sep='')
    temp <- read.dbf(file_name,as.is=TRUE)
    # print(colnames(temp))
    temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
    # print(colnames(temp))
    # stop('cbw')
    
    for (j in 1:length(ecoregions))
    {
      area <- temp[temp$ECO_CODE==ecoregions[j],'AREA_SQKM']
      output[j,(2+i)] <- round(100*as.numeric(temp[temp$ECO_CODE==ecoregions[j],'d2090s'])/area,5)
      output[j,'eco_name'] <- temp[temp$ECO_CODE==ecoregions[j],'ECO_NAME']
      output[j,'eco_code'] <- temp[temp$ECO_CODE==ecoregions[j],'ECO_CODE']
      output[j,'Y2000s'] <- 100 * temp[temp$ECO_CODE==ecoregions[j],'Y2000s'] / area
      # print(output)
      # stop('cbw')
    }
    # stop('cbw')
  }
  
  temp <- output[,-1]
  temp[,2:6] <- sign(temp[,2:6])
  temp$trend <- apply(temp[,2:6],1,sum)
  temp$min.pop <- temp$Y2000s > 10
  print(table(temp[,c('trend','min.pop')]))
  
  # stop('cbw')
  # boxplot(t(output[,3:7]))
  
  output <- merge(output,abbrev)
  # stop('cbw')
  output <- output[output$Y2000s > dens_thresh[n],]
  
  output2 <- data.frame(eco_name=rep(output$eco_name,each=5),eco_code=rep(output$eco_code,each=5),eco_abbrev=rep(output$abbrev,each=5),model=rep(gcm,length(output$eco_code)),change=c(apply(output[,3:7],1,as.vector)))
  
  png(paste('C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/',species[n],'_eco_change_fig.png',sep=''),width=960)
  
    p <- ggplot(output2, aes(factor(eco_abbrev), change)) + geom_point(aes(colour=factor(model)),alpha=0.75,size=4) + guides(colour=guide_legend(title="GCM")) + theme(axis.text.x = element_text(size = 12, angle = 45,hjust=1)) + theme(axis.title.x = element_text(size = 14)) + xlab("Ecoregion") + ylab("Change in Individuals / 100 km2")
    plot(p)
  
  dev.off()
}
# p + geom_boxplot() + theme(axis.text.x = element_text(size = 12, angle = 45,hjust=1)) + theme(axis.title.x = element_text(size = 12)) + xlab("Ecoregion") + ylab("Change in Individuals / 100 km2")

# + geom_jitter()