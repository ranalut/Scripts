
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
	}
}

copy.hexmaps(
	in.dir='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/lynx.035f/lynx.035f-[1]/', 
	out.dir="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/Hexagons/", 
	in.name='hab.qual', 
	out.name='hab.qual.CRU.mean', 
	in.n=seq(1,15,1), 
	out.n=seq(1,15,1)
	)

