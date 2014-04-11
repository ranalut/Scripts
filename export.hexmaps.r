
export.hexmaps <- function(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim',spp.folder,scenario,n=1,hexmap.name) # ,time.step)
{
	this.workspace <- paste(hexsim.wksp2,'\\Workspaces\\',spp.folder,sep='')
	
	command <- paste(
		# function call
		substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,
		'\\currentHexSim" && HexSimCommandLine.exe -exportCSV ',
		# workspace
		this.workspace,' "',
		# hexmap folder
		this.workspace,'\\Results\\',scenario,'\\',scenario,'-[',n,']\\',
		hexmap.name,'" "', # '-[',n,']\\',hexmap.name,'-[',n,'].',time.step,'.hxn',
		# output csv
		this.workspace,'\\Results\\',scenario,'\\',scenario,'-[',n,']\\',
		hexmap.name,'\\',hexmap.name,'.csv"',
		sep=''
	)
	print(command)
	shell(command)
}

export.hexmaps.spatial <- function(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim',spp.folder,hexmap.name, time.step=NA, marker='')
{
	this.workspace <- paste(hexsim.wksp2,'\\Workspaces\\',spp.folder,sep='')
	
	command.1 <- paste(
		# function call
		substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,
		'\\currentHexSim" && HexSimCommandLine.exe -exportCSV ',
		# workspace
		this.workspace,' "',
		# hexmap folder
		this.workspace,'\\Spatial Data\\Hexagons\\',
		hexmap.name,
		sep=''
		)
	command.2 <- paste(
		# output csv
		this.workspace,'\\Analysis\\',hexmap.name,marker,'.csv"',
		sep=''
		)
	if (is.na(time.step)==TRUE) { command <- paste(command.1,'" "',command.2,sep='') }
	else { command <- paste(command.1,'\\',hexmap.name,'.',time.step,'.hxn" "',command.2,sep='') }
	print(command)
	shell(command)
}

# export.hexmaps(spp.folder='spotted_frog_v2',scenario='rana.lut.73.baseline',hexmap.name='population',time.step=110)
# export.hexmaps(spp.folder='lynx_v1',scenario='lynx.040.miroc',hexmap.name='lynx.presence',n=2,time.step=120)
# export.hexmaps(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='spotted_frog_v2',scenario='rana.lut.100a',n=1,hexmap.name='K')

# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='spotted_frog_v2',hexmap.name='CCSM3.aet.jja')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='biomes.2000')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='UKMO-HadCM3.biomes.2099')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='MIROC3.2_medres.biomes.2099')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='GISS-ER.biomes.2099')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='CGCM3.1_t47.biomes.2099')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='CCSM3.biomes.2099')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='lulc.2000')
# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='sage_grouse_v2',hexmap.name='lulc.2099')