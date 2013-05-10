
run.hexsim.report <- function(report,hexsim.wksp,hexsim.wksp2,spp.folder,scenario.name,yrs)
{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe ',report,' "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	
	if (report=='-displacement')
	{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe ',report,':',yrs[1],':',yrs[2],' "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	}
	
	shell(command)
}

# births, deaths, sample, vitals, movement
# displacement

hexsim.wksp='F:/PNWCCVA_Data2/HexSim/'
hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim'
spp.folder='spotted_frog_v2'
scenario.name='rana.lut.66'

run.hexsim.report(
	report='-movement',
	yrs=c(10,15),
	hexsim.wksp=hexsim.wksp,
	hexsim.wksp2=hexsim.wksp2,
	spp.folder=spp.folder,
	scenario.name=scenario.name
	)

theData <- read.csv(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario.name,'/',scenario.name,'-[1]/',scenario.name,'_REPORT_move_rana_lut.csv',sep=''),stringsAsFactors=FALSE)
	
# shell("f:/pnwccva_data2/hexsim/currenthexsim/batchrunner.exe 2 f:/pnwccva_data2/hexsim/workspaces/spotted_frog_v2/batchFile_scenarios.xml")	