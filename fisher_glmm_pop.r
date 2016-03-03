
library(foreign)
library(lme4)
library(MuMIn)
library(geoR)
library(mgcv)
library(tidyr)

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
# Fisher
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
# Fixed effects: scenarios (sens) and gcm
# Random effects: ecoregion (ECO_CODE)
ly_01 <- glmer(pop ~  sens * gcm + (1|ECO_CODE), na.action=na.omit, family=poisson(), data=ly)
print(AIC(ly_01)) # Poisson  28909.54

ly_06 <- lmer(pop ~  year + sens + gcm + (1|ECO_CODE), data=ly)
print(AIC(ly_06)) # Poisson 27151.07
qqnorm(resid(ly_06), main="Q-Q plot for residuals")
qqline(resid(ly_06),col='red')

ly_02 <- glmer(pop ~  sens + gcm + (1|ECO_CODE), family=poisson(), data=ly)
print(AIC(ly_02)) # Poisson 28901.56

ly_03 <- glmer(pop ~  gcm + (1|ECO_CODE), family=poisson(), data=ly)
print(AIC(ly_03)) # Poisson 28910.13

ly_04 <- glmer(pop ~  sens + (1|ECO_CODE), family=poisson(), data=ly)
print(AIC(ly_04)) # Poisson  29286.34

ly_05 <- glmer(pop ~ (1|ECO_CODE), family=poisson(), data=ly)
print(AIC(ly_05)) # Poisson 29294.92

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
