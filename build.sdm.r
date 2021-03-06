
library(randomForest)
library(PresenceAbsence)

source('export.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
data.folder <- 'rabbit_v1'
spp.folder <- 'krat_v1' # 'sage_grouse_v3' # 'rabbit_v1'
spp.file <- 'krat' # 'current' # 'pyra2'
threshold <- 33 # 1 # 667 # Minimum area requirement
test.train <- 	'y' # Don't forget to change the version if you turn this on.
build.model <- 	'y'

map.names <- c(spp.file,'all.water','ave.def.mam.ccsm3','ave.fire.ccsm3','ave.mtco.ccsm3','ave.mtwa.ccsm3','ccsm3.hist.biome','lulc.hist.a2')
time.steps <- c(rep(1,6),30,32)

for (i in 1:length(map.names))
{
	export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, spp.folder=data.folder, hexmap.name=map.names[i],time.step=time.steps[i]) # stop('cbw')
}

# Assemble data

the.data <- read.csv(paste(hexsim.wksp,'workspaces/',data.folder,'/Analysis/',map.names[1],'.csv',sep=''))
for (i in 2:length(map.names))
{
	temp <- read.csv(paste(hexsim.wksp,'workspaces/',data.folder,'/Analysis/',map.names[i],'.csv',sep=''),row.names=1)
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
	save(train.pts,test.pts, file=paste('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/',spp.folder,'/analysis/train.test.v1.rdata',sep=''))
	
}
load(paste('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/',spp.folder,'/analysis/train.test.v1.rdata',sep=''))

# Build Model
if (build.model=='y')
{
	rf.model <- randomForest(data=the.data[the.data$hexid%in%train.pts,], obs ~ def.mam + fire + mtco + mtwa + biomes + lulc, importance=TRUE)

	print(rf.model)
	print(rf.model$importance)
	save(rf.model,file=paste('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/',spp.folder,'/analysis/rf.model.v1.rdata',sep=''))
}
load(paste('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/',spp.folder,'/analysis/rf.model.v1.rdata',sep=''))

# Threshold
train.pred <- predict(rf.model, newdata=the.data[the.data$hexid%in%train.pts,], type='prob')
thresh.table <- data.frame(the.data[the.data$hexid%in%train.pts,c('hexid','obs')],train.pred[,2])
thresh.table$obs <- as.numeric(thresh.table$obs) - 1
thresh.optim <- optimal.thresholds(DATA=thresh.table, opt.methods=c('Sens=Spec','MaxKappa','ReqSpec'),req.spec=1) # threshold=seq(0.2,0.8,0.05), 
cutoff <- thresh.optim[2,2]

test.pred <- predict(rf.model, newdata=the.data[the.data$hexid%in%test.pts,], type='prob')
test.pred <- as.data.frame(test.pred)
test.pred$pred <- ifelse(as.numeric(test.pred[,2]) >= cutoff,1,0)
test.pred$obs <- as.numeric(the.data[the.data$hexid%in%test.pts,'obs']) - 1

sink(paste('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/',spp.folder,'/analysis/rf.model.v1.thresholds.txt',sep=''))
	print(auc(thresh.table))
	print(thresh.optim)
	print(table(test.pred[,3:4]))
sink()

# Predict
pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob')

write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]), paste('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/',spp.folder,'/analysis/rf.model.pred.v1.csv',sep=''),row.names=FALSE)

# Partial Plots
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='def.mam', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='fire', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='mtco', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='mtwa', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='biomes', which.class='1')
partialPlot(rf.model, the.data[the.data$hexid%in%train.pts,], x.var='lulc', which.class='1')
