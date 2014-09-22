# To run this script copy into console...
# for (map in 1:4) { source('post.process.sagr.r') }

library(RColorBrewer)
source('consolidate.results.r')
source('add.records.r')
source('post.process.tables.r')

scenario <- 'sagr.136.hab.v2b.' # 'sagr.175.hab.v2b.' # 'sagr.169.hab.v2b.' # 'sagr.136.hab.v2b.'
workspace <- 'h:/hexsim/workspaces/sage_grouse_v3/'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
model.types <- list(c('','clim.','veg.'),c('full','clim','veg'))
reps <- 5
parameters <- list(list(1,'eco','ECO_ID_U',c(17026:17097)), list(2,'huc','PNWCCVA_ID',c(1:1549)), list(3,'pa','OBJECTID', c(1:1252)),list(4,'smz','Zone',c(1:7)))
spatial.info <- parameters[[map]]
# list(1,'eco','ECO_ID_U',c(17026:17097)) # list(2,'huc','PNWCCVA_ID',c(1:1549)) # list(2,'huc','PNWCCVA_ID',c(1:1549)) # list(3,'pa','OBJECTID',c(1:1252)) # list(4,'smz','Zone',c(1:7))

run.consolidate <- 	'n'
run.post.proc <-	'y'

if (run.consolidate=='y')
{
	consolidate.results(
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
			out.name='greater_sage_grouse'
			)
}
