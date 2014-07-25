
source('deficit.calc.r')
library(raster)

the.time <- Sys.time()

do.hist <-  'n'
do.a2  <-   'y'
do.a1b <-   'n'
season <- 'ann' # 'mam'

# Historical
if (do.hist=='y')
{
 # file.folder <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/'
 file.folder <- 'L:/Space_Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/'
 dir.create(paste(file.folder,'deficit_',season,'_v1/',sep=''),recursive=TRUE)

 for (i in seq(1901,2000,1))
 {
	 deficit(
		 aet.file=paste(file.folder,'aet_',season,'_v1/wna30sec_CRU_TS_2.10_aet_',season,'_v1_',i,'.nc',sep=''),
		 pet.file=paste(file.folder,'pet_',season,'_v1/wna30sec_CRU_TS_2.10_pet_',season,'_v1_',i,'.nc',sep=''),
		 file.path.out=paste(file.folder,'deficit_',season,'_v1/deficit_',season,'_',i,'.nc',sep=''),
		 season=season
		 )
	 cat('year ',i,'\n')
 }
}


# Future
if (do.a2=='y')
{
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

# file.folder <- 'H:/bioclimate/annual/a2/'
file.folder <- 'L:/Space_Lawler/Shared/PNWCCVA-ClimateData/annual/a2/'
dir.create(paste(file.folder,'deficit_',season,'_a2_v1/',sep=''),recursive=TRUE)

for (i in seq(2001,2099,1))
{
	for (j in theGCMs)
	{
		deficit(
			aet.file=paste(file.folder,'aet_',season,'_a2_v1/wna30sec_a2_',j,'_aet_',season,'_v1_',i,'.nc',sep=''),
			pet.file=paste(file.folder,'pet_',season,'_a2_v1/wna30sec_a2_',j,'_pet_',season,'_v1_',i,'.nc',sep=''),
			file.path.out=paste(file.folder,'deficit_',season,'_a2_v1/',j,'_deficit_',season,'_',i,'.nc',sep=''),
			season=season
			)
		cat('a2 year ',i,' GCM ',j,' ',(Sys.time()-the.time),'\n')
		# stop('cbw')
	}
}
}

if (do.a1b=='y')
{
file.folder <- 'H:/bioclimate/annual/a1b/'
file.folder <- 'L:/Space_Lawler/Shared/PNWCCVA-ClimateData/annual/a1b/'
dir.create(paste(file.folder,'deficit_',season,'_a2_v1/',sep=''),recursive=TRUE)

for (i in seq(2001,2099,1))
{
	for (j in theGCMs)
	{
		deficit(
			aet.file=paste(file.folder,'aet_',season,'_a1b_v1/wna30sec_a2_',j,'_aet_',season,'_v1_',i,'.nc',sep=''),
			pet.file=paste(file.folder,'pet_',season,'_a1b_v1/wna30sec_a2_',j,'_pet_',season,'_v1_',i,'.nc',sep=''),
			file.path.out=paste(file.folder,'deficit_',season,'_a1b_v1/',j,'_deficit_',season,'_',i,'.nc',sep=''),
			season=season
			)
		cat('a2 year ',i,' GCM ',j,' ',(Sys.time()-the.time),'\n')
	}
}
}
