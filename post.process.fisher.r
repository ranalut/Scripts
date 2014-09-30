# To run this script copy into console...
# for (map in 1:3) { source('post.process.fisher.r') }

library(RColorBrewer)
source('consolidate.results.r')
source('add.records.r')
source('post.process.tables.r')

scenario <- 'fisher.14.'
workspace <- '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/fisher_v1/'
theGCMs <- c('ccsm3','cgcm3','giss-er','miroc','hadcm3')
model.types <- list(c('','.biomes','.swe','.tmp'),c('full','biomes','swe','temp'))
reps <- 5
parameters <- list(list(1,'eco','ECO_ID_U',c(17026:17097)), list(2,'huc','PNWCCVA_ID',c(1:1549)), list(3,'pa','OBJECTID', c(1:1252)))
spatial.info <- parameters[[map]]

run.consolidate <- 	'y'
run.post.proc <-	'y'

if (run.consolidate=='y')
{
	consolidate.results.2(
		workspace=workspace, 
		scenario=scenario, 
		models=model.types[[1]], 
		models2=model.types[[2]], 
		theGCMs=theGCMs, 
		reps=reps,
		spatial.ref=spatial.info[[1]],
		spatial.name=spatial.info[[2]]
		)
}
# stop('cbw')

if (run.post.proc=='y')
{
	post.processing(
			workspace=workspace,
			scenario=scenario,
			models2=model.types[[2]],
			theGCMs=theGCMs,
			reps=5,
			spatial.name=spatial.info[[2]],
			ref.field=spatial.info[[3]],
			ref.values=spatial.info[[4]],
			out.name='fisher'
			)
}
