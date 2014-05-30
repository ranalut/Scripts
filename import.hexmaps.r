
import.hexmaps <- function(hexsim.wksp2,output.wksp2,spp.folder,csv.name,hexmap.name)
{
	this.workspace <- paste(output.wksp2,'\\Workspaces\\',spp.folder,sep='')
	
	command <- paste(
		# function call
		substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,
		'\\currentHexSim" && HexSimCommandLine.exe -importSpatialData ',
		# workspace
		this.workspace,' "',
		# hexmap folder
		this.workspace,'\\Analysis\\',csv.name,'.csv" ',
		hexmap.name,
		' true true',
		sep=''
		)
	print(command)
	shell(command)
}
