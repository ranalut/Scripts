
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

output2 <- read.csv("../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/all_pop_table_1.csv",header=TRUE,stringsAsFactors=TRUE,row.names = 1)
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

# sink('../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_lmer_aic.txt',append = TRUE)
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
write.csv(fixef(mod),"../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_coef.csv")

#############################################
# Non-bootstrapped 95% CI
fe <- data.frame(summary(mod)$coefficients)
fe$lower <- fe$Estimate - 1.96*fe$Std..Error
fe$upper <- fe$Estimate + 1.96*fe$Std..Error
write.csv(fe,"../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_coef_ci95.csv")
fe <- fe[-1,]
p <- ggplot(fe, aes(x=rownames(fe), y=Estimate)) + 
  geom_errorbar(aes(ymin=lower, ymax=upper), width=.1) +
  geom_line() + geom_point() + ylab('value (intercept=esA1b,HabitatForest)') + xlab('coefficient') + coord_flip()
plot(p)
ggsave("../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_coef_ci95.png", width = 7, height = 5)

###########################################
# Bootstrap confidence intervals
conf_int <- confint(mod, parm="beta_", boot.type="perc", level = 0.95, nsim=1000)
# stop('cbw')
write.csv(conf_int,"../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_95_ci_n1000.csv")

df <- as.data.frame(cbind(fixef(mod),conf_int))
colnames(df) <- c('value','lower','upper')
df <- df[-1,]

p <- ggplot(df, aes(x=rownames(df), y=value)) + 
  geom_errorbar(aes(ymin=lower, ymax=upper), width=.1) +
  geom_line() + geom_point() + ylab('value relative to intercept: gcmccsm3, sensbiomes') + xlab('coefficient') + coord_flip()
plot(p)

ggsave("../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_95_ci_n1000.png",width=7,height=5)

######################################################
# Bootstrapped CIs are the same as model-based CIs, continue with model-based
# because multiple comparisons are easier using established methods (and packages)
model <- mod
png("../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_effects.png", width = 960, height = 480)
plot(effect(c('year','gcm'),mod=model))
dev.off()

png("../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_effects2.png", width = 960, height = 480)
plot(effect(c('year','sens'),mod=model))
dev.off()

test <- testInteractions(mod, pairwise="gcm", slope="year")
test2 <- testInteractions(mod, pairwise="sens",slope="year")
test <- rbind(test,test2)

write.csv(test,"../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_log_lmer_test_interaction.csv")
