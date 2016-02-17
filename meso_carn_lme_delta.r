
# This is the script I used to calculate statistics in the Feb16 version of the manuscript.

library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)
library(MuMIn)

# ================================================
# Table load and formatting...
# ================================================
# source('~/github/scripts/meso_carn_delta_table.r')
# stop('cbw')

output2 <- read.csv("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/delta_table.csv",header=TRUE,stringsAsFactors=TRUE,row.names = 1)

output2$sens <- factor(output2$sens)
output2$gcm <- factor(output2$gcm)
# output2$ECO_CODE <- factor(output2$ECO_CODE)

# ===========================================
# Lynx
# ===========================================

ly <- output2[output2$species=='lynx',]
ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
ly <- ly[100*ly$Y2000s/ly$AREA_SQKM > as.numeric(dens_thresh['lynx']),]

hist(ly$d2050s_dens)
# shapiro.test(ly$d2050s_dens) # significantly different from normal
# stop('cbw')

# m_ly1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
# m_ly1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
m_ly2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)
m_ly2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)

plot(m_ly2)
qqnorm(resid(m_ly2), main="Q-Q plot for residuals")
qqline(resid(m_ly2),col='red')
stop('cbw')
write.csv(as.data.frame(summary(m_ly2)[10]),"D:/Box Sync/PNWCCVA/2015 Outputs/lynx_lmer_coef.csv")
sink("D:/Box Sync/PNWCCVA/2015 Outputs/lynx_lmer.txt")
# anova(m_ly1_n,m_ly1) # Likelihood ratio tests. Both models are significant.
cat('\n')
print(summary(m_ly2)); cat('\n')
print(anova(m_ly2_n,m_ly2)); cat('\n')
print(coefficients(m_ly2)); cat('\n')
print(r.squaredLR(m_ly2,null=m_ly2_n)); cat('\n')
print(r.squaredGLMM(m_ly2))
sink()

# =========================================
# Wolverine 
# =========================================

w <- output2[output2$species=='wolverine',]
w$d2050s_dens <- 100 * w$d2050s/w$AREA_SQKM
w <- w[100*w$Y2000s/w$AREA_SQKM > as.numeric(dens_thresh['wolverine']),]

hist(w$d2050s_dens)
# shapiro.test(w$d2050s_dens) # significantly different from normal, doesn't matter
stop('cbw')

# m_w1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
# m_w1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
m_w2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)
m_w2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)

plot(m_w2)
qqnorm(resid(m_w2), main="Q-Q plot for residuals")
write.csv(as.data.frame(summary(m_w2)[10]),"D:/Box Sync/PNWCCVA/2015 Outputs/wolverine_lmer_coef.csv")
sink("D:/Box Sync/PNWCCVA/2015 Outputs/wolverine_lmer.txt")
# anova(m_w1_n,m_w1) # Likelihood ratio tests. Both models are significant.
print(summary(m_w2))
print(anova(m_w2_n,m_w2))
print(coefficients(m_w2))
print(r.squaredLR(m_w2,null=m_w2_n)); cat('\n')
print(r.squaredGLMM(m_w2))
sink()

# ============================================
# Fisher
# ============================================

f <- output2[output2$species=='fisher',]
f$d2050s_dens <- 100 * f$d2050s/f$AREA_SQKM
f <- f[100*f$Y2000s/f$AREA_SQKM > as.numeric(dens_thresh['fisher']),]
hist(f$d2050s_dens)
# shapiro.test(f$d2050s_dens) # significantly different from normal

# m_f1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=f, REML=FALSE) 
# m_f1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=f, REML=FALSE) 
m_f2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)
m_f2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)

plot(m_f2)
qqnorm(resid(m_f2), main="Q-Q plot for residuals")
write.csv(as.data.frame(summary(m_f2)[10]),"D:/Box Sync/PNWCCVA/2015 Outputs/fisher_lmer_coef.csv")
sink("D:/Box Sync/PNWCCVA/2015 Outputs/fisher_lmer.txt")
# anova(m_f1_n,m_f1) # Likelihood ratio tests. Both models are significant.
print(summary(m_f2))
print(anova(m_f2_n,m_f2))
print(coefficients(m_f2))
print(r.squaredLR(m_f2,null=m_f2_n)); cat('\n')
print(r.squaredGLMM(m_f2))
sink()

# Excerpt from Winter 2013 tutorial...
# Moreover, researchers in ecology (Schielzeth & Forstmeier, 2009), psycholinguistics (Barr, Levy, Scheepers, & Tilly, 2013) and other fields have shown via simulations that mixed models without random slopes are anticonservative or, in other words, they have a relatively high Type I error rate (they                                                                 tend to find a lot of significant results which are actually due to chance).Barr et al. (2013) recommend that you should "keep it maximal" with respect to your random effects structure, at least for controlled experiments. This means that you include all random slopes that are justified by your experimental design . and you do this for all fixed effects that are important for the overall interpretation of your study.
