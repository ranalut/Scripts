
library(popbio)

# Min Survival
theValues <- c(
	0,0,0,0.7939,0.7126,
	1,0,0,0,0,
	0,0.426*0.743,0,0,0,
	0,0.426*0.223,0.625*0.466,0,0,
	0,0.426*0.034,0.625*0.534,0.561,0
	)

# theValues <- rep(0,7*4)
# theValues[c(3,11,19,27)] <- minSurvival
# theValues <- c(0,rep(minRecruit,6),1,rep(0,6),0,minSurvival,rep(0,5),theValues)
best.mat <- matrix(theValues,nrow=5,ncol=5,byrow=TRUE)
# stop('cbw')

# cat('This is the matrix from Kostecke & Cimprich 2008')
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')
print('age distribution')
print(round(stable.stage(best.mat),3))

print(elasticity(best.mat))
# stop('cbw')

# 0.740 growth rate.  Yikes.

# Min Survival
theValues <- c(
	0,0,0,3,3,
	1,0,0,0,0,
	0,0.426*0.743,0,0,0,
	0,0.426*0.223,0.625*0.466,0,0,
	0,0.426*0.034,0.625*0.534,0.561,0
	)

# theValues <- rep(0,7*4)
# theValues[c(3,11,19,27)] <- minSurvival
# theValues <- c(0,rep(minRecruit,6),1,rep(0,6),0,minSurvival,rep(0,5),theValues)
best.mat <- matrix(theValues,nrow=5,ncol=5,byrow=TRUE)
# stop('cbw')

# cat('This is the matrix from Kostecke & Cimprich 2008')
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')
print('age distribution')
print(round(stable.stage(best.mat),3))
