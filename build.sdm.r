
library(randomForest)
library(PresenceAbsence)

source('export.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
spp.folder <- 'rabbit_v1'

map.names <- c('pyra2','all.water','ave.def.mam.ccsm3','ave.fire.ccsm3','ave.mtco.ccsm3','ave.mtwa.ccsm3','ccsm3.hist.biome','lulc.hist.a2')
time.steps <- c(rep(1,6),30,32)

for (i in 1:length(map.names))
{
	export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name=map.names[i],time.step=time.steps[i]) # stop('cbw')
}

# Assemble data

the.data <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[1],'.csv',sep=''))
for (i in 2:length(map.names))
{
	temp <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[i],'.csv',sep=''),row.names=1)
	the.data <- cbind(the.data,temp)
}
colnames(the.data) <- c('hexid','pyra2','water','def.mam','fire','mtco','mtwa','biomes','lulc')
the.data <- the.data[the.data$water!=1 & the.data$def.mam!=0,]
the.data <- the.data[-1,]
the.data$obs <- the.data$pyra2
the.data$obs[the.data$pyra2>=667] <- 1
the.data$obs[the.data$pyra2<667] <- 0
the.data$obs <- factor(the.data$obs,levels=c(0,1))
the.data$biomes <- factor(the.data$biomes,levels=seq(0,11,1))
the.data$lulc <- factor(the.data$lulc, levels=c(0,2,6,13,14,18))

pres.pts <- sample(the.data$hexid[the.data$pyra2>=667], size=10000)
abs.pts <- sample(the.data$hexid[the.data$pyra2<667], size=10000)

train.pts <- c(pres.pts[1:8000],abs.pts[1:8000])
test.pts <- c(pres.pts[8001:10000],abs.pts[8001:10000])
save(train.pts,test.pts,file='l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/train.test.v1.rdata')

# Build Model
# rf.model <- randomForest(data=the.data[the.data$hexid%in%train.pts,], obs ~ def.mam + fire + mtco + mtwa + biomes + lulc, importance=TRUE)

# print(rf.model)
# print(rf.model$importance)
# save(rf.model,file='l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.v1.rdata')
load('l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.v1.rdata')

# Threshold
train.pred <- predict(rf.model, newdata=the.data[the.data$hexid%in%train.pts,], type='prob')
thresh.table <- data.frame(the.data[the.data$hexid%in%train.pts,c('hexid','obs')],train.pred[,2])
thresh.table$obs <- as.numeric(thresh.table$obs) - 1
print(auc(thresh.table))
thresh.optim <- optimal.thresholds(DATA=thresh.table, opt.methods=c('Sens=Spec','MaxKappa','ReqSpec'),req.spec=1) # threshold=seq(0.2,0.8,0.05), 
print(thresh.optim)
cutoff <- thresh.optim[2,2]

test.pred <- predict(rf.model, newdata=the.data[the.data$hexid%in%test.pts,], type='prob')
test.pred <- as.data.frame(test.pred)
test.pred$pred <- ifelse(as.numeric(test.pred[,2]) >= cutoff,1,0)
test.pred$obs <- as.numeric(the.data[the.data$hexid%in%test.pts,'obs']) - 1
print(table(test.pred[,3:4]))

# Predict
# pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob')

# write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]),'l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.pred.v1.csv',row.names=FALSE)


