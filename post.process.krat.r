
# To run this script copy into console...
# for (map in 1:3) { source('post.process.krat.r') }

source('export.hexmaps.r')
source('post.process.tables.maps.r')

spp.folder <- 'krat_v1' # 'rabbit_v1' # 'woodpecker_v1' # 'nutcracker_v1' 
workspace <- 'l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/krat_v1/'
map.name <- 'distribution'
scenario <- 'krat.05.hab.v2.'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
# theGCMs <- c('ccsm3','cgcm3','giss-er','miroc','hadcm3')
model.types <- list(c('','clim.','veg.'),c('full','clim','veg'))
reps <- 25
parameters <- list(list(1,'eco','ECO_ID_U',c(17026:17097)), list(2,'huc','PNWCCVA_ID',c(1:1549)), list(3,'pa','OBJECTID', c(1:1252)))
spatial.info <- parameters[[map]]

time.steps <- seq(10,110,10)

# source('consolidate.maps.r')
run.post.proc <- 'y'

if (run.post.proc=='y')
{
	post.processing.maps(
			workspace=workspace,
			scenario=scenario,
			models2=model.types[[2]],
			theGCMs=theGCMs,
			reps=reps,
			spatial.name=spatial.info[[2]],
			ref.field=spatial.info[[3]],
			ref.values=spatial.info[[4]],
			out.name='kangaroo_rat'
			)
}


