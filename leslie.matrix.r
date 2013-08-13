
library(popbio)

build.matrix <- function(max.age,stage.thresh,vitals,yr1.multiplier) # yr1.multiplier used for things like females only model (0.5).
{
	stage.thresh <- c(stage.thresh,max.age)
	output <- matrix(rep(0,(max.age+1)^2),ncol=(max.age+1))
	# print(output)
	
	# Fertilities
	fert.vector <- rep(vitals[[1]][length(vitals[[1]])],(max.age+1))
	for (i in 1:(length(stage.thresh)-1)) { fert.vector[(stage.thresh[i]+1):stage.thresh[i+1]] <- vitals[[1]][i] }
	output[1,] <- fert.vector
	
	# Survival
	surv.vector <- rep(NA,max.age)
	for (i in 1:(length(stage.thresh)-1)) { surv.vector[(stage.thresh[i]+1):stage.thresh[i+1]] <- vitals[[2]][i] }
	surv.vector[1] <- yr1.multiplier * surv.vector[1]
	# print(surv.vector)
	
	for (i in 1:max.age)
	{
		output[(i+1),i] <- surv.vector[i]
	}
	return(output)
}

# Lynx
best.mat <- build.matrix(max.age=15,stage.thresh=c(0,1,2,3,8,10),vitals=list(fertility=c(0,2.4,2.4,2.9,2.2,2.2),survival=c(0.24,0.54,0.7,0.7,0.7,0.31)),yr1.multiplier=1)
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')
print('age distribution')
print(round(stable.stage(best.mat),3))

# Wolverine
best.mat <- build.matrix(max.age=10,stage.thresh=c(0,2),vitals=list(fertility=c(0,0.71),survival=c(0.72,0.76)),yr1.multiplier=1)
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')
print('age distribution')
print(round(stable.stage(best.mat),3))
