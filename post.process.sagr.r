
library(RColorBrewer)
source('consolidate.results.r')
source('add.records.r')
source('post.process.tables.r')

scenario <- 'sagr.136.hab.v2b.' # 'sagr.175.hab.v2b.' # 'sagr.169.hab.v2b.' # 'sagr.136.hab.v2b.'
workspace <- 'h:/hexsim/workspaces/sage_grouse_v3/'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
# classes <- c('grassland','shrublands','developed')
model.types <- list(c('','clim.','veg.'),c('full','clim','veg'))
reps <- 5
spatial.info <- list(4,'smz')

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
			spatial.name=spatial.info[[2]]
			)
}
