
library(foreign)
library(lme4)
library(nlme)
library(MuMIn)
library(geoR)
library(mgcv)
library(tidyr)
library(ggplot2)

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
# Wolverine
# ===========================================

ly <- output2[output2$species=='wolverine',]
# ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
# ly$d2090s_dens <- 100 * ly$d2090s/ly$AREA_SQKM
# stop('cbw')
ly <- gather(ly, year, pop, 11:109) # 4:7
ly$year <- as.character(ly$year)
ly$year <- as.numeric(substr(ly$year,2,5))
hist(ly$pop)
hist(log((ly$pop+1)))
# bc <- boxcoxfit(ly$pop)
# hist(ly$pop^(bc$lambda[1]))
# ly$pop <- ly$pop^(bc$lambda[1]) 
ly$pop <- log((ly$pop+1)) # Proceeding with the log then bootstrapping coef.

p <- ggplot(ly, aes(year, pop))
p <- p + geom_line(aes(colour = factor(ECO_CODE)))
plot(p)

# min(unique(test$pop))
# stop('cbw')

# =====================================================
# Fixed effects: scenarios (sens) and gcm
# Random effects: ecoregion (ECO_CODE)

# sink('D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_lmer_aic.txt',append = TRUE)
# cat('AIC','call','\n',sep='\t')
# mod <- lmer(pop ~ (1|ECO_CODE), data=ly)
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ gcm + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ sens + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ sens + gcm + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ year + sens + gcm + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ year + I(year^2)+ sens + gcm + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ year*sens + gcm + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ year*gcm + sens + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# # Top model
# mod <- update(mod, pop ~ year*gcm + year*sens + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# mod <- update(mod, pop ~ year*gcm + year*sens + I(year^2) + (1|ECO_CODE))
# cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
# 
# sink()
# stop('cbw')

# Top-ranking model by AIC...
mod <- lmer(pop ~ (1|ECO_CODE), data=ly)
mod <- update(mod, pop ~ year*gcm + year*sens + (1|ECO_CODE))
cat(AIC(mod),deparse(formula(mod)),'\n',sep='\t')
qqnorm(resid(mod), main="Q-Q plot for residuals")
qqline(resid(mod),col='red')
summary(mod)
r.squaredGLMM(mod)

# temp <- bootMer(mod, FUN = function(x) fixef(x),  nsim=10) # 1000
conf_int <- confint(mod, parm="beta_", boot.type="perc", level = 0.95, nsim=3)
# stop('cbw')

write.csv(fixef(mod),"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_coef.csv")
write.csv(conf_int,"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_95_ci_n3.csv")

# Need to plot 95% confidence intervals for each parameter to see if they overlap with zero and with one another to see if any group is higher than another.

df <- cbind(fixef(mod),conf_int)
colnames(df) <- c('value','lower','upper')
temp <- df[1,]
unit <- matrix(df[1,1],nrow=dim(df)[1]-1,ncol=dim(df)[2])
# df_rel <- df-unit
# df_rel
# df <- data.frame(df[-1,])
df <- unit + df[-1,]
df <- data.frame(rbind(temp,df))
rownames(df)[1] <- 'intercept'# 'gcmccsm3,sens35'

# Need to plot 95% confidence intervals for each parameter to see if they overlap with zero and with one another to see if any group is higher than another.

p <- ggplot(df, aes(x=rownames(df), y=value)) + 
  geom_errorbar(aes(ymin=lower, ymax=upper), width=.1) +
  geom_line() + geom_point() + ylab('value relative to intercept: gcmccsm3, sens35') + xlab('coefficient') + coord_flip()
plot(p)
