
copy.hexmaps <- function(in.dir, out.dir, in.name, out.name, in.n, out.n)
{
	dir.create(paste(out.dir,out.name,'/',sep=''),recursive=TRUE)
	
	for (i in 1:length(in.n))
	{
		file.copy(
			from=paste(in.dir,in.name,'/',in.name,'.',in.n[i],'.hxn',sep=''), 
			to=paste(out.dir,out.name,'/',out.name,'.',out.n[i],'.hxn',sep=''), 
			recursive=FALSE, 
			overwrite=TRUE
			)
		# stop('cbw')
	}
}

theGCMs <- c('ccsm3','cgcm3','giss-er','miroc','hadcm3')

for (j in theGCMs)
{
  copy.hexmaps(
  	in.dir=paste('D:/data/wilsey/hexsim/workspaces/lynx_v1/Results/lynx.050.',j,'.maps/lynx.050.',j,'.maps-[1]/',sep=''), 
  	out.dir="D:/Data/wilsey/hexsim/workspaces/lynx_v1/Spatial Data/Hexagons/", 
  	in.name='hab.qual', 
  	out.name=paste('hab.qual.v3.',j,sep=''), 
  	in.n=c(1,seq(10,108,1)), 
  	out.n=c(1,seq(10,108,1))
  	)
}

for (j in theGCMs)
{
  copy.hexmaps(
  	in.dir=paste('D:/data/wilsey/hexsim/workspaces/lynx_v1/Results/lynx.050.baseline.2000.maps/lynx.050.baseline.2000.maps-[1]/',sep=''), 
  	out.dir="D:/Data/wilsey/hexsim/workspaces/lynx_v1/Spatial Data/Hexagons/", 
  	in.name='hab.qual.baseline.2000', 
  	out.name=paste('hab.qual.v3.',j,sep=''), 
  	in.n=seq(1,9,1), 
  	out.n=seq(1,9,1)
  	)
}

stop('cbw') 

theGCMs <- c('ccsm3','cgcm3','giss-er','miroc','hadcm3')

for (j in theGCMs)
{
  copy.hexmaps(
  	in.dir=paste('D:/Data/wilsey/wolverine_v1/Results/gulo.023.a2.',j,'.maps.biomes/gulo.023.a2.',j,'.maps.biomes-[1]/',sep=''), 
  	out.dir="D:/Data/wilsey/wolverine_v1/Spatial Data/Hexagons/", 
  	in.name='habitat.qual', 
  	out.name=paste('hab.qual.',j,'.biomes',sep=''), 
  	in.n=c(1,seq(11,109,1)), 
  	out.n=c(1,seq(11,109,1))
  	)
	
	copy.hexmaps(
  	in.dir=paste('D:/Data/wilsey/wolverine_v1/Results/gulo.023/gulo.023-[1]/',sep=''), 
  	out.dir="D:/Data/wilsey/wolverine_v1/Spatial Data/Hexagons/", 
  	in.name='habitat.qual', 
  	out.name=paste('hab.qual.',j,'.biomes',sep=''), 
  	in.n=1, 
  	out.n=1
  	)
}
