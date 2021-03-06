
# This is the script I used to calculate statistics in the Feb16 version of the manuscript.

library(foreign)
library(lme4)
library(MuMIn)
library(geoR)

# ================================================
# Table load and formatting...
# ================================================
# source('~/github/scripts/meso_carn_delta_table.r')
# stop('cbw')

output2 <- read.csv("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/delta_table_2.csv",header=TRUE,stringsAsFactors=TRUE,row.names = 1)

output2$sens <- factor(output2$sens)
output2$gcm <- factor(output2$gcm)
# output2$ECO_CODE <- factor(output2$ECO_CODE)

# ===========================================
# Lynx
# ===========================================

ly <- output2[output2$species=='lynx',]
ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
ly$d2090s_dens <- 100 * ly$d2090s/ly$AREA_SQKM

# hist(ly$d2050s_dens)
# shapiro.test(ly$d2050s_dens) # significantly different from normal
hist(ly$d2090s_dens)
# stop('cbw')
# ly$bc_d2090s_dens <- (ly$d2090s_dens)^(boxcoxfit(ly$d2090s_dens, add.to.data=10)$lambda[1]) # lambda2 = TRUE,
# hist(ly$bc_d2090s_dens)
# shapiro.test(ly$bc_d2090s_dens) # significantly different from normal
# stop('cbw')
bc <- boxcoxfit(ly$d2090s_dens, lambda2=TRUE)
ly$bc_d2090s_dens <- (bc$lambda[2] + ly$d2090s_dens)^(bc$lambda[1]) 
hist(ly$bc_d2090s_dens)

m_ly1 <- lmer(bc_d2090s_dens ~ sens + gcm + (1 | ECO_CODE), data=ly, REML=FALSE)
qqnorm(resid(m_ly1), main="Q-Q plot for residuals")
qqline(resid(m_ly1),col='red')
print(AIC(m_ly1)) # 23.48
print(shapiro.test(resid(m_ly1)))
# stop('cbw')

m_ly2 <- lmer(bc_d2090s_dens ~ gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
qqnorm(resid(m_ly2), main="Q-Q plot for residuals")
qqline(resid(m_ly2),col='red')
print(AIC(m_ly2)) # 23.48
print(shapiro.test(resid(m_ly2)))
# stop('cbw')

m_ly3 <- lmer(bc_d2090s_dens ~ sens + (1 | ECO_CODE), data=ly, REML=FALSE) 
qqnorm(resid(m_ly3), main="Q-Q plot for residuals")
qqline(resid(m_ly3),col='red')
print(AIC(m_ly3)) # 272.78
print(shapiro.test(resid(m_ly3)))
# stop('cbw')

m_ly4 <- lmer(bc_d2090s_dens ~ sens * gcm + (1 | ECO_CODE), data=ly, REML=FALSE)
hist(resid(m_ly4), main="plot for residuals")
qqnorm(resid(m_ly4), main="Q-Q plot for residuals")
qqline(resid(m_ly4),col='red')
print(AIC(m_ly4)) # 17.31
print(shapiro.test(resid(m_ly4)))
stop('cbw')

stop('cbw')

# m_ly2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)
# m_ly2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)
# m_ly2 <- lmer(d2090s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)
# m_ly2_n <- lmer(d2090s_dens ~ gcm + (1 + sens|ECO_CODE), data=ly, REML=FALSE)

plot(m_ly2)
qqnorm(resid(m_ly2), main="Q-Q plot for residuals")
qqline(resid(m_ly2),col='red')
shapiro.test(resid(m_ly2)) # significantly different from normal
stop('cbw')

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
# =========================================
# Wolverine 
# =========================================

w <- output2[output2$species=='wolverine',]
w$d2050s_dens <- 100 * w$d2050s/w$AREA_SQKM
w$d2090s_dens <- 100 * w$d2090s/w$AREA_SQKM
w <- w[100*w$Y2000s/w$AREA_SQKM > as.numeric(dens_thresh['wolverine']),]

hist(w$d2050s_dens)
# shapiro.test(w$d2050s_dens) # significantly different from normal, doesn't matter
hist(w$d2090s_dens)
# stop('cbw')

# m_w1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
# m_w1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=w, REML=FALSE) 
# m_w2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)
# m_w2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)
m_w2 <- lmer(d2090s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)
m_w2_n <- lmer(d2090s_dens ~ gcm + (1 + sens|ECO_CODE), data=w, REML=FALSE)

plot(m_w2)
qqnorm(resid(m_w2), main="Q-Q plot for residuals")
qqline(resid(m_w2),col='red')
write.csv(as.data.frame(summary(m_w2)[10]),"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_lmer_coef_2090s.csv")
sink("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/wolverine_lmer_2090s.txt")
# anova(m_w1_n,m_w1) # Likelihood ratio tests. Both models are significant.
print(summary(m_w2))
print(anova(m_w2_n,m_w2))
print(coefficients(m_w2))
print(r.squaredLR(m_w2,null=m_w2_n)); cat('\n')
print(r.squaredGLMM(m_w2))
sink()
# stop('cbw')

# ============================================
# Fisher
# ============================================

f <- output2[output2$species=='fisher',]
f$d2050s_dens <- 100 * f$d2050s/f$AREA_SQKM
f$d2090s_dens <- 100 * f$d2090s/f$AREA_SQKM
f <- f[100*f$Y2000s/f$AREA_SQKM > as.numeric(dens_thresh['fisher']),]

hist(f$d2050s_dens)
# shapiro.test(f$d2050s_dens) # significantly different from normal
hist(f$d2090s_dens)

# m_f1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=f, REML=FALSE) 
# m_f1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=f, REML=FALSE) 
# m_f2 <- lmer(d2050s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)
# m_f2_n <- lmer(d2050s_dens ~ gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)
m_f2 <- lmer(d2090s_dens ~ sens + gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)
m_f2_n <- lmer(d2090s_dens ~ gcm + (1 + sens|ECO_CODE), data=f, REML=FALSE)

plot(m_f2)
qqnorm(resid(m_f2), main="Q-Q plot for residuals")
qqline(resid(m_f2),col='red')

write.csv(as.data.frame(summary(m_f2)[10]),"D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/fisher_lmer_coef_2090s.csv")
sink("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/fisher_lmer_2090s.txt")
# anova(m_f1_n,m_f1) # Likelihood ratio tests. Both models are significant.
print(summary(m_f2))
print(anova(m_f2_n,m_f2))
print(coefficients(m_f2))
print(r.squaredLR(m_f2,null=m_f2_n)); cat('\n')
print(r.squaredGLMM(m_f2))
sink()

# Excerpt from Winter 2013 tutorial...
# Moreover, researchers in ecology (Schielzeth & Forstmeier, 2009), psycholinguistics (Barr, Levy, Scheepers, & Tilly, 2013) and other fields have shown via simulations that mixed models without random slopes are anticonservative or, in other words, they have a relatively high Type I error rate (they                                                                 tend to find a lot of significant results which are actually due to chance).Barr et al. (2013) recommend that you should "keep it maximal" with respect to your random effects structure, at least for controlled experiments. This means that you include all random slopes that are justified by your experimental design . and you do this for all fixed effects that are important for the overall interpretation of your study.
