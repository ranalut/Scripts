
library(foreign)
library(lme4)
library(MuMIn)
library(geoR)
library(mgcv)
library(tidyr)

# ================================================
# For GAMMs
# ===============================================
ctrl <- gam.control(nthreads=1,irls.reg=0.0,epsilon = 1e-07, maxit = 50000, mgcv.tol=1e-7,mgcv.half=15, trace = FALSE, rank.tol=.Machine$double.eps^0.5,
                    nlm=list(),optim=list(),newton=list(), outerPIsteps=0,idLinksBases=TRUE,scalePenalty=TRUE, keepData=FALSE,scale.est="pearson") 

# ================================================
# Table load and formatting...
# ================================================
# source('~/github/scripts/meso_carn_delta_table.r')
# stop('cbw')

output2 <- read.csv("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/delta_table_2.csv",header=TRUE,stringsAsFactors=TRUE,row.names = 1)
output2$dum <- 1
output2$sens <- factor(output2$sens)
output2$gcm <- factor(output2$gcm)
# output2$ECO_CODE <- factor(output2$ECO_CODE)
species <- c('lynx','wolverine','fisher')

# ===========================================
# Lynx
# ===========================================

ly <- output2[output2$species=='fisher',]
# ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
# ly$d2090s_dens <- 100 * ly$d2090s/ly$AREA_SQKM

ly <- gather(ly, year, pop, 4:7)
ly$year <- as.character(ly$year)
ly$year <- as.numeric(substr(ly$year,2,5))
# hist(log(test$pop))
# min(unique(test$pop))
stop('cbw')

# =====================================================
# Data response is not normally distributed
# Wasn't able to transform data to Gaussian. Tried sqrt, cube root, and Box-Cox.
# =====================================================
# hist(ly$d2050s_dens)
# shapiro.test(ly$d2050s_dens) # significantly different from normal
# hist(ly$d2090s_dens)
# stop('cbw')
# bc <- boxcoxfit(ly$d2090s_dens, lambda2=TRUE)
# ly$bc_d2090s_dens <- (bc$lambda[2] + ly$d2090s_dens)^(bc$lambda[1]) 
# hist(ly$bc_d2090s_dens, breaks=20)
# shapiro.test(ly$bc_d2090s_dens) # significantly different from normal
# stop('cbw')

# =====================================================
# Fixed effects: scenarios (sens) and gcm
# Random effects: ecoregion (ECO_CODE)
ly_01 <- gam(pop ~  sens * gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_01)) # Poisson  28664.67
shapiro.test(sample(resid(ly_01),5000)) # Significantly different.

ly_02 <- gam(pop ~  sens + gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_02)) # Poisson 28656.69 *******
shapiro.test(resid(ly_02)) # Significantly different.

ly_03 <- gam(pop ~  gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_03)) # Poisson 28665.27
shapiro.test(resid(ly_03)) # Significantly different.

ly_04 <- gam(pop ~  sens + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_04)) # Poisson  29041.47
shapiro.test(resid(ly_04)) # Significantly different.

ly_05 <- gam(pop ~  s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_05)) # Poisson 29050.05
shapiro.test(resid(ly_05)) # Significantly different.

# ==================================
# Add smoothers
# ==================================

# Poisson
ly_01a <- gam(pop ~  sens + gcm + s(year, by=gcm, k=4) + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_01a)) # Poisson 26389.57 ******
plot(ly_01a)
qqnorm(resid(ly_01a), main="Q-Q plot for residuals")
qqline(resid(ly_01a),col='red')
print(summary(ly_01a)) # Adjusted R^2 = 99.6%, Deviance explained 99.6%
      
ly_01b <- gam(pop ~  sens + gcm + s(year, by=sens, k=4) + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=poisson(), select=TRUE, data=ly, method="ML")
print(AIC(ly_01b)) # Poisson 26912.06

stop('cbw')

#################################################33


write.csv(as.data.frame(summary(m_ly2)[10]),"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/lynx_lmer_coef_2090s.csv")
sink("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/lynx_lmer_2090s.txt")
# anova(m_ly1_n,m_ly1) # Likelihood ratio tests. Both models are significant.
cat('\n')
print(summary(m_ly2)); cat('\n')
print(anova(m_ly2_n,m_ly2)); cat('\n')
print(coefficients(m_ly2)); cat('\n')
print(r.squaredLR(m_ly2,null=m_ly2_n)); cat('\n')
print(r.squaredGLMM(m_ly2))
sink()
# stop('cbw')
