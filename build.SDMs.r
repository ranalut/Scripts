
library(randomForest)
library(PresenceAbsence)

source('export.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'H:/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
output.wksp2 <- 'H:\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

data.folder <- 'rabbit_v1'
spp.folder <- 'rabbit_v1' # 'krat_v1' # 'sage_grouse_v3' # 'rabbit_v1'
spp.file <- 'pyra2' # 'krat' # 'current' # 'pyra2'
threshold <- 667 # 33 # 1 # 667 # Minimum area requirement
test.train <- 	'n'; ver <- 2 # Don't forget to change the version if you turn this on.
export.hexmaps <- 'n'
build.model <- 	'n'

map.names <- c(spp.file,'all.water','ave.def.mam.ccsm3','ave.fire.ccsm3','ave.mtco.ccsm3','ave.mtwa.ccsm3','ccsm3.hist.biome','lulc.hist.a2')
time.steps <- c(rep(1,6),30,32)

if (export.hexmaps=='y')
{
  for (i in 1) # 1:length(map.names))
  {
  	export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, output.wksp2=output.wksp2, spp.folder=data.folder, hexmap.name=map.names[i],time.step=time.steps[i]) # stop('cbw')
  }
}

# Assemble data
the.data <- read.csv(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[1],'.csv',sep=''))
for (i in 2:length(map.names))
{
	temp <- read.csv(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[i],'.csv',sep=''),row.names=1)
	the.data <- cbind(the.data,temp)
}
colnames(the.data) <- c('hexid',spp.file,'water','def.mam','fire','mtco','mtwa','biomes','lulc')
the.data <- the.data[the.data$water!=1 & the.data$mtwa!=0 & the.data$lulc!=0 & the.data$biomes!=0,]
the.data <- the.data[-1,]
the.data$obs <- the.data[,spp.file]
the.data$obs[the.data[,spp.file]>=threshold] <- 1
the.data$obs[the.data[,spp.file]<threshold] <- 0
the.data$obs <- factor(the.data$obs,levels=c(0,1))
the.data$biomes <- factor(the.data$biomes,levels=seq(0,11,1))
the.data$lulc <- factor(the.data$lulc, levels=c(0,2,6,13,14,18))

if (test.train=='y')
{
	pres.pts <- sample(the.data$hexid[the.data[,spp.file]>=threshold], size=10000)
	abs.pts <- sample(the.data$hexid[the.data[,spp.file]<threshold], size=10000)

	train.pts <- c(pres.pts[1:8000],abs.pts[1:8000])
	test.pts <- c(pres.pts[8001:10000],abs.pts[8001:10000])
	save(train.pts,test.pts, file=paste(output.wksp,'workspaces/',spp.folder,'/analysis/train.test.v',ver,'.rdata',sep=''))
}
load(paste(output.wksp,'workspaces/',spp.folder,'/analysis/train.test.v',ver,'.rdata',sep=''))

# Build Model
if (build.model=='y')
{
	rf.model <- randomForest(data=the.data[the.data$hexid%in%train.pts,], obs ~ def.mam + fire + mtco + mtwa + biomes + lulc, importance=TRUE)
	# print(rf.model); print(rf.model$importance)
	save(rf.model,file=paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,'a.rdata',sep=''))
	
	rf.model <- randomForest(data=the.data[the.data$hexid%in%train.pts,], obs ~ def.mam + mtco + mtwa, importance=TRUE)
	# print(rf.model); print(rf.model$importance)
	save(rf.model,file=paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,'b.rdata',sep=''))
	
	rf.model <- randomForest(data=the.data[the.data$hexid%in%train.pts,], obs ~ fire + biomes + lulc, importance=TRUE)
	# print(rf.model); print(rf.model$importance)
	save(rf.model,file=paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,'c.rdata',sep=''))
}

cat.performance <- function(test.table, cutoff)
{
	c.mat <- cmx(test.table,threshold=cutoff)
	print(c.mat)
	cat('Evaluation: value then standard deviation\n')
	cat('auc',as.numeric(auc(test.table)),'\n')
	cat('kappa',as.numeric(Kappa(c.mat)),'\n')
	sens <- as.numeric(sensitivity(c.mat))
	cat('omission',1-sens[1],sens[2],'\n')
	speci <- as.numeric(specificity(c.mat))
	cat('comission',1-speci[1],speci[2],'\n')
}

sink(paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,'.thresholds.txt',sep=''))

for (i in letters[1:3])
{
	load(paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,i,'.rdata',sep=''))

	# Threshold
	train.pred <- predict(rf.model, newdata=the.data[the.data$hexid%in%train.pts,], type='prob')
	thresh.table <- data.frame(the.data[the.data$hexid%in%train.pts,c('hexid','obs')],train.pred[,2])
	thresh.table$obs <- as.numeric(thresh.table$obs) - 1
	thresh.optim <- optimal.thresholds(DATA=thresh.table, opt.methods=c('Sens=Spec','MaxKappa','ReqSpec','MaxSens+Spec','Cost'),req.spec=0.72,FPC=1.5, FNC=1, smoothing=5) # threshold=seq(0.2,0.8,0.05), 
	cutoff <- thresh.optim[2,2]

	test.pred <- predict(rf.model, newdata=the.data[the.data$hexid%in%test.pts,], type='prob')
	# test.pred <- as.data.frame(test.pred)
	# test.pred$pred <- ifelse(as.numeric(test.pred[,2]) >= cutoff,1,0)
	# test.pred$obs <- as.numeric(the.data[the.data$hexid%in%test.pts,'obs']) - 1
	test.table <- data.frame(the.data[the.data$hexid%in%test.pts,c('hexid','obs')],test.pred[,2])
	test.table$obs <- as.numeric(test.table$obs) - 1
	
	print(rf.model$call)
	print(rf.model$importance)
	print(thresh.optim)
	
	
	cat.performance(test.table=test.table, cutoff=thresh.optim[2,2])
	cat.performance(test.table=test.table, cutoff=thresh.optim[5,2])
	
	for (j in seq(1.6,2,0.1))
	{
		thresh.optim <- optimal.thresholds(DATA=thresh.table, opt.methods=c('Sens=Spec','MaxKappa','ReqSpec','MaxSens+Spec','Cost'),req.spec=0.72,FPC=j, FNC=1, smoothing=5)
		cat('\n\ncost ratio= ',j,'\n')
		print(thresh.optim)
		cat.performance(test.table=test.table, cutoff=thresh.optim[5,2])
	}

	# print(table(test.pred[,3:4]))
	cat('\n\n\n')
}
sink()

stop('cbw')

# Predict
pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob')

write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]), paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.pred.v',ver,'.csv',sep=''),row.names=FALSE)

# Partial Plots
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='def.mam', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='fire', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='mtco', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='mtwa', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='biomes', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='lulc', which.class='1')
