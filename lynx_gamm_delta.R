

library(foreign)
library(ggplot2)
library(gridExtra)
library(lme4)
library(MuMIn)
library(geoR)
library(mgcv)

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

output2 <- read.csv("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/delta_table.csv",header=TRUE,stringsAsFactors=TRUE,row.names = 1)
output2$dum <- 1
output2$sens <- factor(output2$sens)
output2$gcm <- factor(output2$gcm)
# output2$ECO_CODE <- factor(output2$ECO_CODE)

# ===========================================
# Lynx
# ===========================================

ly <- output2[output2$species=='lynx',]
ly$d2050s_dens <- 100 * ly$d2050s/ly$AREA_SQKM
ly$d2090s_dens <- 100 * ly$d2090s/ly$AREA_SQKM

# Drop ECO_CODEs for which population doesn't begin above threshold density.
ly <- ly[100*ly$Y2000s/ly$AREA_SQKM > as.numeric(dens_thresh['lynx']),]

# =====================================================
# Data response is not normally distributed
# Wasn't able to transform data to Gaussian. Tried sqrt, cube root, and Box-Cox.
# =====================================================
# hist(ly$d2050s_dens)
# shapiro.test(ly$d2050s_dens) # significantly different from normal
# hist(ly$d2090s_dens)
# stop('cbw')
# ly$bc_d2090s_dens <- (ly$d2090s_dens)^(boxcoxfit(ly$d2090s_dens, add.to.data=10)$lambda[1]) # lambda2 = TRUE,
# hist(ly$bc_d2090s_dens)
# shapiro.test(ly$bc_d2090s_dens) # significantly different from normal
# stop('cbw')

ly_full <- gam(d2090s_dens ~  sens * gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_full)) # 205.2783 
gam.check(ly_full) # 
shapiro.test(resid(ly_full)) # Significantly different.

ly_ar <- gam(d2090s_dens ~  sens * gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, correlation = corAR1(form=~1|ECO_CODE), na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_ar)) # 205.2783 
gam.check(ly_ar) # 
shapiro.test(resid(ly_ar)) # Significantly different.

ly_1 <- gam(d2090s_dens ~  sens + gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_1)) # 205.0398 
gam.check(ly_1) # 
shapiro.test(resid(ly_1)) # Significantly different.

ly_2 <- gam(d2090s_dens ~  gcm + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_2)) # 204.5321 
gam.check(ly_2) # 
shapiro.test(resid(ly_2)) # Significantly different.

ly_3 <- gam(d2090s_dens ~  sens + s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_3)) # 471.6727 
gam.check(ly_3) # 
shapiro.test(resid(ly_3)) # Significantly different.

ly_4 <- gam(d2090s_dens ~  s(ECO_CODE, bs="re", by=dum), gamma=1.4, na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_4)) # 470.4572 
gam.check(ly_4) # 
shapiro.test(resid(ly_4)) # Significantly different.

# ==================================
# Add smoothers
# ==================================
# This won't run...
ly_2a <- gam(d2090s_dens ~  gcm + s(ECO_CODE, k=6) + s(ECO_CODE, bs="re", by=dum) , gamma=1.4, na.action=na.omit, control=ctrl, family=gaussian(), select=TRUE, data=ly, method="ML")
print(AIC(ly_2a)) # 204.5321 
gam.check(ly_2a) # 
shapiro.test(resid(ly_2a)) # Significantly different.


stop('cbw')

m_ly1 <- lmer(d2050s ~ sens + gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
qqnorm(resid(m_ly1), main="Q-Q plot for residuals")
qqline(resid(m_ly1),col='red')
print(AIC(m_ly1))
m_ly1_n <- lmer(d2050s ~ gcm + (1 | ECO_CODE), data=ly, REML=FALSE) 
qqnorm(resid(m_ly1_n), main="Q-Q plot for residuals")
qqline(resid(m_ly1_n),col='red')
print(AIC(m_ly1))
m_ly3 <- lmer(d2050s ~ sens + (1 | ECO_CODE), data=ly, REML=FALSE) 
qqnorm(resid(m_ly3), main="Q-Q plot for residuals")
qqline(resid(m_ly3),col='red')
print(AIC(m_ly3))

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
