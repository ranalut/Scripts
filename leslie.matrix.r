
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

best.mat <- build.matrix(max.age=15,stage.thresh=c(0,2,3,7,9),vitals=list(fertility=c(0,2.4,2.9,2.2,2.2),survival=c(0.48,0.54,0.7,0.7,0.31)),yr1.multiplier=0.5)
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')
print('age distribution')
print(round(stable.stage(best.mat),3))

stop('cbw')

# your.matrix <- c(
# 0, 0.48, 0.48, 0.48, 0.48, 0.48, 0.48,
# 0, 0.55, 0.00, 0.00, 0.00, 0.00, 0.00,
# 0, 0.00, 0.55, 0.00, 0.00, 0.00, 0.00,
# 0, 0.00, 0.00, 0.55, 0.00, 0.00, 0.00,
# 0, 0.00, 0.00, 0.00, 0.55, 0.00, 0.00,
# 0, 0.00, 0.00, 0.00, 0.00, 0.55, 0.00,
# )


# minSurvival <- 0.56 # This is the minimum plus 1 SE (0.5 + 0.06)
minSurvival <- 0.55 # 0.62 # 0.606 # 0.61 # 0.606 # 0.554 # 0.5
minJuvSurv <- 0.2 # 0.26 # 0.27 # 0.355 # 0.3 # 0.34 # 0.337
meanProd <- 2.4 # 2.32 # 1.775 # 2.32 # 2.319 # 1.919
minRecruit <- minJuvSurv * meanProd

# Min Survival
theValues <- rep(0,7*4)
theValues[c(3,11,19,27)] <- minSurvival
theValues <- c(0,rep(minRecruit,6),1,rep(0,6),0,minSurvival,rep(0,5),theValues)
best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)
# stop('cbw')

# cat('This is the matrix from Kostecke & Cimprich 2008')
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')
print('age distribution')
print(round(stable.stage(best.mat),3))
stop('cbw')






# ====================================================
# Look for values
increment <- seq(0,0.5,0.01)
cat('\nmatching a growth rate with productivity\n')
cat('add','lambda','prod','Sj','Sa','stable stages...','\n',sep='\t')
for (i in 1:length(increment))
{
	theValues <- rep(0,7*4)
	# tempSurvival <- minSurvival + addThis[i]
	tempProd <- meanProd
	tempRecruit <- minJuvSurv * tempProd * (1-increment[i])
	tempSurvival <- minSurvival 
	theValues[c(3,11,19,27)] <- tempSurvival
	theValues <- c(0,rep(tempRecruit,6),1,rep(0,6),0,tempSurvival,rep(0,5),theValues)
	best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(increment[i],theLambda,tempProd,round(tempRecruit/tempProd,3),tempSurvival,round(stable.stage(best.mat),3),'\n',sep='\t')
}
stop('cbw')

# Look for values
increment <- seq(0.5,0.75,0.01)
cat('\nmatching a growth rate with productivity\n')
cat('add','lambda','prod','Sj','Sa','stable stages...','\n',sep='\t')
for (i in 1:length(increment))
{
	theValues <- rep(0,7*4)
	# tempSurvival <- minSurvival + addThis[i]
	tempProd <- meanProd + increment[i]
	tempRecruit <- minJuvSurv * tempProd
	tempSurvival <- minSurvival 
	theValues[c(3,11,19,27)] <- tempSurvival
	theValues <- c(0,rep(tempRecruit,6),1,rep(0,6),0,tempSurvival,rep(0,5),theValues)
	best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(increment[i],theLambda,tempProd,round(tempRecruit/tempProd,3),tempSurvival,round(stable.stage(best.mat),3),'\n',sep='\t')
}
# stop('cbw')

increment <- seq(0,0.25,0.01)
cat('\nmatching a growth rate with Sa\n')
cat('add','lambda','prod','Sj','Sa','stable stages...','\n',sep='\t')
for (i in 1:length(increment))
{
	theValues <- rep(0,7*4)
	# tempSurvival <- minSurvival + addThis[i]
	tempProd <- meanProd
	tempRecruit <- minJuvSurv * tempProd
	tempSurvival <- minSurvival + increment[i] 
	theValues[c(3,11,19,27)] <- tempSurvival
	theValues <- c(0,rep(tempRecruit,6),1,rep(0,6),0,tempSurvival,rep(0,5),theValues)
	best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(increment[i],theLambda,tempProd,round(tempRecruit/tempProd,3),tempSurvival,round(stable.stage(best.mat),3),'\n',sep='\t')
}
# stop('cbw')

increment <- seq(0,0.25,0.01)
cat('\nmatching a growth rate with Sj\n')
cat('add','lambda','prod','Sj','Sa','stable stages...','\n',sep='\t')
for (i in 1:length(increment))
{
	theValues <- rep(0,7*4)
	# tempSurvival <- minSurvival + addThis[i]
	tempProd <- meanProd
	tempJuvSurv <- minJuvSurv + increment[i]
	tempRecruit <- tempJuvSurv * tempProd
	tempSurvival <- minSurvival
	theValues[c(3,11,19,27)] <- tempSurvival
	theValues <- c(0,rep(tempRecruit,6),1,rep(0,6),0,tempSurvival,rep(0,5),theValues)
	best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)
	# print(best.mat)
	theLambda <- round(lambda(best.mat),3)
	cat(increment[i],theLambda,tempProd,round(tempRecruit/tempProd,3),tempSurvival,round(stable.stage(best.mat),3),'\n',sep='\t')
}
stop('cbw')


# minSurvival <- 0.56 # This is the minimum plus 1 SE (0.5 + 0.06)
minSurvival <- 0.609 # 0.555 # 0.5
minRecruit <- 0.365 * 1.919

# # Impacts of parasitism
# parasitism <- seq(0.01,0.75,0.01)
# cat('\nparasitism impact on recruitment\n')
# cat('par','lambda','rec','Sj','Sa','stable stages...','\n',sep='\t')
# for (i in 1:length(parasitism))
# {
	# theValues <- rep(0,7*4)
	# # tempSurvival <- minSurvival + addThis[i]
	# tempRecruit <- minRecruit * (1-parasitism[i])
	# theValues[c(3,11,19,27)] <- tempRecruit
	# theValues <- c(0,rep(tempRecruit,6),1,rep(0,6),0,minSurvival,rep(0,5),theValues)
	# best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)
	# # print(best.mat)
	# theLambda <- round(lambda(best.mat),3)
	# cat(parasitism[i],theLambda,round(tempRecruit,3),round(tempRecruit/1.919,3),minSurvival,round(stable.stage(best.mat),3),'\n',sep='\t')
# }


stop('cbw')

minSurvival <- 0.56 # This is the minimum plus 1 SE (0.5 + 0.06)
minRecruit <- 0.373

theValues <- rep(0,7*4)
theValues[c(3,11,19,27)] <- minSurvival
theValues <- c(0,rep(minRecruit,6),1,rep(0,6),0,minSurvival,rep(0,5),theValues)
best.mat <- matrix(theValues,nrow=7,ncol=7,byrow=TRUE)

cat('This is the matrix from Kostecke & Cimprich 2008')
print(best.mat)
theLambda <- lambda(best.mat)
cat("Lambda = ",theLambda,'\n')

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
