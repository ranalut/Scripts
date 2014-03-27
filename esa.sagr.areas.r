

# Compare study area to sagr distribution

library(foreign)
current <- read.dbf('D:/PNWCCVA/SageGrouse/Sage-grouse_distribution_sgca/Sage-grouse_current_distribution_sgca.dbf',as.is=TRUE)
study.area <- read.dbf('D:/PNWCCVA/SageGrouse/sagr_clip_distn2.dbf',as.is=TRUE)

print(sum(study.area$AREA_KM2)/sum(current$AREA_KM2))

# Estimate change

workspace <- 'd:/pnwccva/sagegrouse/analysis/'

biomes.2000 <- read.csv(paste(workspace,'biomes.2000.csv',sep=''),header=TRUE)
test <- biomes.2000$biomes.2000.1 > 0.001
the.data <- biomes.2000[test==TRUE,]

gcms <- c('ccsm3','cgcm3.1_t47','giss-er','miroc3.2_medres','ukmo-hadcm3')
for (i in gcms)
{
	temp <- read.csv(paste(workspace,i,'.biomes.2099.csv',sep=''),header=TRUE)
	temp <- temp[test==TRUE,]
	the.data <- cbind(the.data,temp[,2])
}

colnames(the.data) <- c('hexid','current','ccsm3','cgcm3','giss','miroc','hadcm3')

lulc.2000 <- read.csv(paste(workspace,'lulc.2000.csv',sep=''),header=TRUE)
lulc <- lulc.2000[test==TRUE,]
lulc.2099 <- read.csv(paste(workspace,'lulc.2099.csv',sep=''),header=TRUE)
lulc.2099 <- lulc.2099[test==TRUE,]
lulc <- cbind(lulc,lulc.2099[,2])
colnames(lulc) <- c('hexid','current','lulc99')

calc.hab <- function(x,class1,class2=NA)
{
	if (is.na(class2)==TRUE) { temp <- x %in% class1 }
	if (is.na(class2)==FALSE) { temp <- x %in% class1 & x %in% class2 }
	output <- sum(temp) * 0.866
	return(output)
}

biome.hab.shrub <- apply(the.data[,c('current','ccsm3','cgcm3','giss','miroc','hadcm3')],MARGIN=2,FUN=calc.hab,class1=c(9))
print(biome.hab.shrub)
print(biome.hab.shrub/biome.hab.shrub[1])

biome.hab.grass <- apply(the.data[,c('current','ccsm3','cgcm3','giss','miroc','hadcm3')],MARGIN=2,FUN=calc.hab,class1=c(8))
print(biome.hab.grass)
print(biome.hab.grass/biome.hab.grass[1])

lulc.bad <- apply(lulc[,c('current','lulc99')],MARGIN=2,FUN=calc.hab,class1=c(2:6,13,14))
print(lulc.bad)
print(lulc.bad/lulc.bad[1])


stop('cbw')

biome.lulc.hab <- apply(the.data[,c('current','ccsm3','cgcm3','giss','miroc','hadcm3')],MARGIN=2,FUN=calc.hab,class1=c())
