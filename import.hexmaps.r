
import.hexmaps <- function(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim',hexsim.wksp1,spp.folder,csv.name,hexmap.name)
{
	this.workspace <- paste(hexsim.wksp2,'\\Workspaces\\',spp.folder,sep='')
	
	command <- paste(
		# function call
		substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,
		'\\currentHexSim" && HexSimCommandLine.exe -importSpatialData ',
		# workspace
		this.workspace,' "',
		# hexmap folder
		this.workspace,'\\Analysis\\',hexmap.name,'.csv" ',
		hexmap.name,
		' TRUE TRUE',
		sep=''
		)
	print(command)
	shell(command)
}
