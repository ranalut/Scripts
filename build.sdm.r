
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

# Build random forest model

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

pres.pts <- sample(the.data$hexid[the.data$pyra2>=667], size=5000)
abs.pts <- sample(the.data$hexid[the.data$pyra2<667], size=5000)

train.pts <- c(pres.pts[1:4000],abs.pts[1:4000])
test.pts <- c(pres.pts[4001:5000],abs.pts[4001:5000])
save(train.pts,test.pts,file='l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/train.test.v1.rdata')

rf.model <- randomForest(data=the.data[the.data$hexid%in%train.pts,], obs ~ def.mam + fire + mtco + mtwa + biomes + lulc, importance=TRUE, xtest=the.data[the.data$hexid%in%test.pts,c('def.mam','fire','mtco','mtwa','biomes','lulc')], ytest=the.data[the.data$hexid%in%test.pts,'obs'], keep.forest=TRUE)

print(rf.model)
print(rf.model$importance)
save(rf.model,file='l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.v1.rdata')

pred.spp.distn <- predict(rf.model, newdata=the.data, type='response')

write.csv(data.frame(hexid=the.data$hexid,Pred=(as.numeric(pred.spp.distn))-1),'l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.pred.v1.csv',row.names=FALSE)


