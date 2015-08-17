
library(foreign)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)
write.csv(eco,'C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.csv')
abbrev <- read.csv("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/eco_abbrev.csv",stringsAsFactors=FALSE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_eco_','wolverine/wolverine_eco_','fisher/fisher_eco_') 

gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
dens_thresh <- c(0.1,0.1,1) # Looked at Y2000 density and dropped the lowest, least relevant.

for (n in 1:length(species))
{
    cat('\n\nstart',species[n],'\n')
    t <- 1
    file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",path[n],sens[[n]][t],'_ave',scenario[n],'.dbf',sep='')
    temp <- read.dbf(file_name,as.is=TRUE)
    # print(colnames(temp))
    temp <- merge(eco,temp,all.x=TRUE,all.y=FALSE)
    # print(colnames(temp))
    
    temp$y2000s_dens <- round(100 * temp$Y2000s / temp$AREA_SQKM,3)
    temp$y2050s_dens <- round(100 * temp$Y2050s / temp$AREA_SQKM,3)
    temp$pc_50 <- 100*round((temp$d2050s / temp$AREA_SQKM) / (temp$Y2000s/temp$AREA_SQKM),2)
    temp$y2090s_dens <- round(100 * temp$Y2090s / temp$AREA_SQKM,3)
    temp$pc_90 <- 100*round((temp$d2090s / temp$AREA_SQKM) / (temp$Y2000s/temp$AREA_SQKM),2)
    delta <- temp[,c('ECO_NAME','ECO_CODE','y2000s_dens','y2050s_dens','pc_50','y2090s_dens','pc_90')]
    # print(delta[order(abs(delta$delta_dens),decreasing=TRUE),])
    # stop('cbw')
    
    file_name <- paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/",path[n],sens[[n]][t],'_sd',scenario[n],'.dbf',sep='')
    temp2 <- read.dbf(file_name,as.is=TRUE)
    # print(colnames(temp))
    temp2 <- merge(eco,temp2,all.x=TRUE,all.y=FALSE)
    # print(colnames(temp))
     
    temp2$sd_y2000s <- round(100 * temp2$Y2000s/temp$AREA_SQKM,3)
    temp2$sd_y2050s <- round(100 * temp2$Y2050s/temp$AREA_SQKM,3)
    temp2$sd_y2090s <- round(100 * temp2$Y2090s/temp$AREA_SQKM,3)
    temp2 <- temp2[,c('ECO_NAME','ECO_CODE','sd_y2000s','sd_y2050s','sd_y2090s')]
    
    delta <- data.frame(delta,temp2[,c('sd_y2000s','sd_y2050s','sd_y2090s')])
    delta <- delta[,c(1:3,8,4,9,5,6,10,7)]
    y2000s <- paste(delta[,3],' \U00b1 ',delta[,4],sep='')
    y2050s <- paste(delta[,5],' \U00b1 ',delta[,6],sep='')
    y2090s <- paste(delta[,8],' \U00b1 ',delta[,9],sep='')
    delta2 <- data.frame(delta[,1:2],y2000s,y2050s,change=paste(delta[,7],'%',sep=''),y2090s,change=paste(delta[,10],'%',sep=''))
    delta2 <- delta2[delta$y2000s_dens>dens_thresh[n] | delta$y2050s_dens>dens_thresh[n] | delta$y2090s_dens>dens_thresh[n],]
    print(delta2)
    delta2 <- merge(delta2,abbrev)
    write.csv(delta2,paste("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/",species[n],"_density_table.csv",sep=''))
}

