# focus on ecoregion NA0524 (Yellowstone) for sensitivity analysis

library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_eco_','wolverine/wolverine_eco_','fisher/fisher_eco_') 

# ecoregion <- 'NA0524'
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')
# output <- as.data.frame(matrix(NA,nrow=1,ncol=9))
# colnames(output) <- c('eco_name','eco_code','species','sens',gcm)

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
      
      if (n==1 & t==1 & i==1)
      { 
        output <- temp[,c('ECO_NAME','ECO_CODE','AREA_SQKM','Y2000s','d2020s','d2050s','d2090s')]
        output$species <- rep(species[n],dim(output)[1])
        output$sens <- rep(sens[[n]][t],dim(output)[1])
        output$gcm <- rep(gcm[i],dim(output)[1])
      }
      else
      {
        temp2 <- temp[,c('ECO_NAME','ECO_CODE','AREA_SQKM','Y2000s','d2020s','d2050s','d2090s')]
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

output2$sens <- factor(output2$sens)
output2$gcm <- factor(output2$gcm)
# output2$ECO_CODE <- factor(output2$ECO_CODE)

w <- output2[output2$species=='wolverine',]
m_w1 <- lmer(d2020s ~ sens + gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
m_w1_n <- lmer(d2020s ~ gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
m_w2 <- lmer(d2020s ~ sens + gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)
m_w2_n <- lmer(d2020s ~ gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)

anova(m_w1_n,m_w1) # Likelihood ratio tests. Both models are significant.
anova(m_w2_n,m_w2)

plot(m_w2)
coefficients(m_w2)

# Excerpt from Winter 2013 tutorial...
# Moreover, researchers in ecology (Schielzeth & Forstmeier, 2009), psycholinguistics (Barr, Levy, Scheepers, & Tilly, 2013) and other fields have shown via simulations that mixed models without random slopes are anticonservative or, in other words, they have a relatively high Type I error rate (they                                                                 tend to find a lot of significant results which are actually due to chance).Barr et al. (2013) recommend that you should "keep it maximal" with respect to your random effects structure, at least for controlled experiments. This means that you include all random slopes that are justified by your experimental design . and you do this for all fixed effects that are important for the overall interpretation of your study.
