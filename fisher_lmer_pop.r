
library(foreign)
library(lme4)
library(MuMIn)
library(geoR)
library(mgcv)
library(tidyr)

# ================================================
# Table load and formatting...
# ================================================
# source('~/github/scripts/meso_carn_all_pop_table.r')
# stop('cbw')

output2 <- read.csv("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/all_pop_table_1.csv",header=TRUE,stringsAsFactors=TRUE,row.names = 1)
output2$dum <- 1
output2$sens <- factor(output2$sens)
output2$gcm <- factor(output2$gcm)
output2$ECO_CODE <- factor(output2$ECO_CODE)
species <- c('lynx','wolverine','fisher')

# ===========================================
# Fisher
# ===========================================

ly <- output2[output2$species=='fisher',]
# ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
# ly$d2090s_dens <- 100 * ly$d2090s/ly$AREA_SQKM
# stop('cbw')
ly <- gather(ly, year, pop, 11:109) # 4:7
ly$year <- as.character(ly$year)
ly$year <- as.numeric(substr(ly$year,2,5))
hist(ly$pop)
hist(log(ly$pop))
bc <- boxcoxfit(ly$pop)
hist(ly$pop^(bc$lambda[1]))
ly$pop <- log(ly$pop)
# ly$pop <- ly$pop^(bc$lambda[1]) 

# min(unique(test$pop))
# stop('cbw')

# =====================================================
# Fixed effects: scenarios (sens) and gcm
# Random effects: ecoregion (ECO_CODE)

sink('D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/fisher_lmer_aic.txt',append = TRUE)
cat('AIC','call','\n',sep='\t')
mod <- lmer(pop ~ (1|ECO_CODE), data=ly)
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ gcm + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ sens + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ sens + gcm + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ year + sens + gcm + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ year + I(year^2)+ sens + gcm + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ year*sens + gcm + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ year*gcm + sens + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ year*gcm + year*sens + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

mod <- update(mod, pop ~ year*gcm + year*sens + I(year^2) + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')

sink()

# Top-ranking model by AIC...
mod <- update(mod, pop ~ year*gcm + sens + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
qqnorm(resid(mod), main="Q-Q plot for residuals")
qqline(resid(mod),col='red')
summary(mod)
r.squaredGLMM(mod)
# Still not normal residuals, even with a Poisson.
stop('cbw')
#################################################33

write.csv(as.data.frame(summary(mod)[10]),"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/lynx_glmm_coef_all_yr.csv")
sink("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/fisher_glmm_outputs.txt")
# anova(m_ly1_n,m_ly1) # Likelihood ratio tests. Both models are significant.
cat('\n')
print(summary(m_ly2)); cat('\n')
print(anova(m_ly2_n,m_ly2)); cat('\n')
print(coefficients(m_ly2)); cat('\n')
print(r.squaredLR(m_ly2,null=m_ly2_n)); cat('\n')

sink()
# stop('cbw')
