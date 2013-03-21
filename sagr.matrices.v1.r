
library(popbio)

maxSurvival <- c(0.65,0.58)
maxRecruit <- c(0.429,0.745)

# Max Survival
theValues <- rep(0,9*6)
theValues[c(3,13,23,33,43,53)] <- maxSurvival[2]
theValues <- c(0,0.429,rep(0.745,7),1,rep(0,8),0,maxSurvival[1],rep(0,7),theValues)
best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
print(best.mat)
theLambda <- lambda(best.mat)
print(theLambda)

theScalars <- seq(0.5,1,0.05)
cat('\nimpact on survival\n')
cat('scalar','lambda','Sj','Sa','\n',sep='\t')
for (i in 1:length(theScalars))
{
	theValues <- rep(0,9*6)
	theValues[c(3,13,23,33,43,53)] <- maxSurvival[2]*theScalars[i]
	theValues <- c(0,maxRecruit[1],rep(maxRecruit[2],7),1,rep(0,8),0,(maxSurvival[1]*theScalars[i]),rep(0,7),theValues)
	best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(theScalars[i],theLambda,maxSurvival[1]*theScalars[i],maxSurvival[2]*theScalars[i],'\n',sep='\t')
}

cat('\nimpact on recruitment\n')
cat('scalar','lambda','Rj','Ra','Sj','Sa','\n',sep='\t')
for (i in 1:length(theScalars))
{
	theValues <- rep(0,9*6)
	theValues[c(3,13,23,33,43,53)] <- maxSurvival[2]
	theValues <- c(0,maxRecruit[1]*theScalars[i],rep(maxRecruit[2],7)*theScalars[i],1,rep(0,8),0,(maxSurvival[1]),rep(0,7),theValues)
	best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(theScalars[i],theLambda,maxRecruit[1]*theScalars[i],maxRecruit[2]*theScalars[i],maxSurvival[1],maxSurvival[2],'\n',sep='\t')
}

cat('\nimpact on recruitment and survival\n')
cat('scalar','lambda','Rj','Ra','Sj','Sa','\n',sep='\t')
for (i in 1:length(theScalars))
{
	theValues <- rep(0,9*6)
	theValues[c(3,13,23,33,43,53)] <- maxSurvival[2]*theScalars[i]
	theValues <- c(0,maxRecruit[1]*theScalars[i],rep(maxRecruit[2],7)*theScalars[i],1,rep(0,8),0,(maxSurvival[1]*theScalars[i]),rep(0,7),theValues)
	best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(theScalars[i],theLambda,maxRecruit[1]*theScalars[i],maxRecruit[2]*theScalars[i],maxSurvival[1]*theScalars[i],maxSurvival[2]*theScalars[i],'\n',sep='\t')
}

cat('\nimpact on recruitment and survival\n')
cat('scale.r','scale.s','lambda','Rj','Ra','Sj','Sa','\n',sep='\t')
for (i in 1:length(theScalars))
{
	for (j in 1:length(theScalars))
	{
		theValues <- rep(0,9*6)
		theValues[c(3,13,23,33,43,53)] <- maxSurvival[2]*theScalars[j]
		theValues <- c(0,maxRecruit[1]*theScalars[i],rep(maxRecruit[2],7)*theScalars[i],1,rep(0,8),0,(maxSurvival[1]*theScalars[j]),rep(0,7),theValues)
		best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
		# print(best.mat)
		theLambda <- round(lambda(best.mat),3)
		cat(theScalars[i],theScalars[j],theLambda,maxRecruit[1]*theScalars[i],maxRecruit[2]*theScalars[i],maxSurvival[1]*theScalars[j],maxSurvival[2]*theScalars[j],'\n',sep='\t')
	}
}
cat('scale.r','scale.s','lambda','Rj','Ra','Sj','Sa','\n',sep='\t')

# # 0.75
# theValues <- rep(0,9*6)
# theValues[c(3,13,23,33,43,53)] <- 0.435
# theValues <- c(0,0.429,rep(0.745,7),1,rep(0,8),0,0.4875,rep(0,7),theValues)
# best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
# print(best.mat)
# theLambda <- lambda(best.mat)
# print(theLambda)

# # 0.5
# theValues <- rep(0,9*6)
# theValues[c(3,13,23,33,43,53)] <- 0.29
# theValues <- c(0,0.429,rep(0.745,7),1,rep(0,8),0,0.325,rep(0,7),theValues)
# best.mat <- matrix(theValues,nrow=9,ncol=9,byrow=TRUE)
# print(best.mat)
# theLambda <- lambda(best.mat)
# print(theLambda)
