
# To run this script copy into console...
# for (map in 1:3) { source('post.process.frog.r') }

source('export.hexmaps.r')

spp.folder <- 'spotted_frog_v2' # 'woodpecker_v1' # 'nutcracker_v1' 
map.name <- 'population'
workspace <- 'l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/spotted_frog_v2/'
scenario <- 'rana.lut.105.125.'
# theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
theGCMs <- c('baseline','ccsm3','cgcm3','giss-er','miroc','hadcm3')
model.types <- list(c('','.aet','.swe'),c('full','aet','swe'))
reps <- 5
parameters <- list(list(0,'eco','ECO_ID_U',c(17026:17097)), list(1,'huc','PNWCCVA_ID',c(1:1549)), list(2,'pa','OBJECTID', c(1:1252)))

time.steps <- c(1,seq(10,100,10))

do.consolidate <- 	'n'
do.tables <- 		'y'

if (do.consolidate=='y')
{
	source('consolidate.maps.apply.frog.r')

	# Extract the hexmap data
	hexsim.wksp <- 'D:/data/wilsey/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
	hexsim.wksp2 <- 'D:\\data\\wilsey\\hexsim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
	output.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
	output.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

	base.map <- read.csv(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',parameters[[map]][2],'.csv',sep=''))
	base.map[1,2] <- 0
	base.map$Step_1 <= round(base.map$Step_1)

	scenarios <- rep(scenario,(length(model.types[[1]])*length(theGCMs)*reps*length(time.steps)))
	model_1 <- rep(model.types[[1]],each=(length(theGCMs)*reps*length(time.steps)))
	model_2 <- rep(model.types[[2]],each=(length(theGCMs)*reps*length(time.steps)))
	gcm <- rep(rep(theGCMs,each=(reps*length(time.steps))),3)
	rep <- rep(rep(seq(1,reps,1), each=length(time.steps)),(3*length(theGCMs)))
	year <- rep(time.steps,(3*length(theGCMs)*reps))
	inputs <- data.frame(scenario=scenarios, model_1, model_2, gcm, rep, year)

	if (file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',scenario,parameters[[map]][2],'.csv',sep=''))==TRUE)
	{
		test <- read.csv(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',scenario,parameters[[map]][2],'.csv',sep=''),header=TRUE)
		test <- test[,c('model','gcm','rep','year')]
		inputs_test <- inputs[,c('model_2','gcm','rep','year')]
		names(inputs_test) <- names(test)
		test_merge <- rbind(test,inputs_test)
		duplicates <- duplicated(test_merge)
		duplicates <- duplicates[(dim(test)[1]+1):length(duplicates)]
		inputs <- inputs[duplicates==FALSE,]
	}
	# stop('cbw')

	apply(X=inputs,MARGIN=1,FUN=map.consolidator.frog,
		hexsim.wksp2=hexsim.wksp2,
		output.wksp2=output.wksp2,
		output.wksp=output.wksp,
		spp.folder=spp.folder,
		map.name=map.name,
		parameters=parameters[[map]],
		base.map=base.map
		)
}

if (do.tables=='y')
{
	spatial.info <- parameters[[map]]
	source('post.process.tables.maps.frog.r')
	
	post.processing.maps.frog(
			workspace=workspace,
			scenario=scenario,
			models2=model.types[[2]],
			theGCMs=theGCMs,
			reps=reps,
			spatial.name=spatial.info[[2]],
			ref.field=spatial.info[[3]],
			ref.values=spatial.info[[4]],
			out.name='columbia_spotted_frog'
			)
}

