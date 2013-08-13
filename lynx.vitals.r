

# Vital rates taken from Carroll 2007

# Multiplier for demographic cycling
fecund <- c(1,0.8,0.2,0.25,0.25,0.25,0.25,0.4,0.6)
surv <- c(1,0.89,0.67,0.56,0.56,0.56,0.56,0.67,0.89)

mean.fecund <- mean(fecund)
mean.surv <- mean(surv)

# Max values
surv.max <- c(0.77,0.77,0.99,0.99,0.99,0.44)
fecund.max <- c(0,2.4,2.4,2.9,2.2,2.2)

# Survival Matrices
s.surv <- rep(NA,6)
n.surv <- rep(NA,6)

s.surv <- round(surv.max * mean.surv,2)
s.surv[1] <- round(s.surv[1] * mean.fecund,2)

sink('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Analysis/vitals.v1.txt')

for (i in 1:9)
{
	n.surv <- round(surv.max * surv[i],2)
	n.surv[1] <- round(n.surv[1] * fecund[i],2)
	
	# Write
	cat(s.surv,sep='\n')
	cat(n.surv,sep='\n')
	cat('\n')
}

sink()

