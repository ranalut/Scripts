
# focus on ecoregion NA0524 (Yellowstone) for sensitivity analysis

library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)
library(MuMIn)

eco <- read.dbf('C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf',as.is=TRUE)

species <- c('lynx','wolverine','fisher')
scenario <- c('_lynx_050','_gulo_023_a2','_fisher_14')
sens <- list(c('50','35'), c('full','swe','biomes'),c('full','temp','swe','biomes'))
path <- c('lynx/lynx_eco_','wolverine/wolverine_eco_','fisher/fisher_eco_') 
dens_thresh <- c(0.1,0.1,1)
names(dens_thresh) <- species
gcm <- c('ccsm3','cgcm3','giss','hadcm3','miroc')

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

ly <- output2[output2$species=='lynx',]
ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
ly <- ly[100*ly$Y2000s/ly$AREA_SQKM > as.numeric(dens_thresh['lynx']),]
# m_ly1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
# m_ly1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
m_ly2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)
m_ly2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)

plot(m_ly2)
write.csv(as.data.frame(summary(m_ly2)[10]),"C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/lynx_lmer_coef.csv")
sink("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/lynx_lmer.txt")
# anova(m_ly1_n,m_ly1) # Likelihood ratio tests. Both models are significant.
cat('\n')
print(summary(m_ly2)); cat('\n')
print(anova(m_ly2_n,m_ly2)); cat('\n')
print(coefficients(m_ly2)); cat('\n')
print(r.squaredLR(m_ly2,null=m_ly2_n)); cat('\n')
print(r.squaredGLMM(m_ly2))
sink()

w <- output2[output2$species=='wolverine',]
w$d2050s_dens <- 100 * w$d2050s/w$AREA_SQKM
w <- w[100*w$Y2000s/w$AREA_SQKM > as.numeric(dens_thresh['wolverine']),]
# m_w1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
# m_w1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
m_w2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)
m_w2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)

plot(m_w2)
write.csv(as.data.frame(summary(m_w2)[10]),"C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/wolverine_lmer_coef.csv")
sink("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/wolverine_lmer.txt")
# anova(m_w1_n,m_w1) # Likelihood ratio tests. Both models are significant.
print(summary(m_w2))
print(anova(m_w2_n,m_w2))
print(coefficients(m_w2))
print(r.squaredLR(m_w2,null=m_w2_n)); cat('\n')
print(r.squaredGLMM(m_w2))
sink()

f <- output2[output2$species=='fisher',]
f$d2050s_dens <- 100 * f$d2050s/f$AREA_SQKM
f <- f[100*f$Y2000s/f$AREA_SQKM > as.numeric(dens_thresh['fisher']),]
# m_f1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=f, REML=FALSE) 
# m_f1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=f, REML=FALSE) 
m_f2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)
m_f2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)

plot(m_f2)
write.csv(as.data.frame(summary(m_f2)[10]),"C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/fisher_lmer_coef.csv")
sink("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/fisher_lmer.txt")
# anova(m_f1_n,m_f1) # Likelihood ratio tests. Both models are significant.
print(summary(m_f2))
print(anova(m_f2_n,m_f2))
print(coefficients(m_f2))
print(r.squaredLR(m_f2,null=m_f2_n)); cat('\n')
print(r.squaredGLMM(m_f2))
sink()

# Excerpt from Winter 2013 tutorial...
# Moreover, researchers in ecology (Schielzeth & Forstmeier, 2009), psycholinguistics (Barr, Levy, Scheepers, & Tilly, 2013) and other fields have shown via simulations that mixed models without random slopes are anticonservative or, in other words, they have a relatively high Type I error rate (they                                                                 tend to find a lot of significant results which are actually due to chance).Barr et al. (2013) recommend that you should "keep it maximal" with respect to your random effects structure, at least for controlled experiments. This means that you include all random slopes that are justified by your experimental design . and you do this for all fixed effects that are important for the overall interpretation of your study.
