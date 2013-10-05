
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

export.hexmaps.spatial <- function(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim',spp.folder,hexmap.name) # ,time.step)
{
	this.workspace <- paste(hexsim.wksp2,'\\Workspaces\\',spp.folder,sep='')
	
	command <- paste(
		# function call
		substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,
		'\\currentHexSim" && HexSimCommandLine.exe -exportCSV ',
		# workspace
		this.workspace,' "',
		# hexmap folder
		this.workspace,'\\Spatial Data\\Hexagons\\',
		hexmap.name,'" "',
		# output csv
		this.workspace,'\\Analysis\\',hexmap.name,'.csv"',
		sep=''
	)
	print(command)
	shell(command)
}

# export.hexmaps(spp.folder='spotted_frog_v2',scenario='rana.lut.73.baseline',hexmap.name='population',time.step=110)
# export.hexmaps(spp.folder='lynx_v1',scenario='lynx.040.miroc',hexmap.name='lynx.presence',n=2,time.step=120)


export.hexmaps(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='spotted_frog_v2',scenario='rana.lut.100a',n=1,hexmap.name='K')

# export.hexmaps.spatial(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim', spp.folder='spotted_frog_v2',hexmap.name='CCSM3.aet.jja')
