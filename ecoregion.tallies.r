
eco.tally <- function(hexsim.wksp,spp.folder,scenario,tally.name='BirthsMinusDeaths',eco.reg)
{
	# file.remove(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario,'/',scenario,'-[1]/eco.',tally.name,'.csv',sep=''))
	
	# Tally
	file.names <- dir(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario,'/',scenario,'-[1]/',sep=''))
	the.file <- grep(paste(tally.name,'_TALLY',sep=''),file.names,value=TRUE)
	the.data <- read.csv(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario,'/',scenario,'-[1]/',the.file,sep=''),header=TRUE)
	print(head(the.data))
	cat('load tally\n')
	# print(head(baseline)); stop('cbw')

	# the.data <- data.frame(the.data,Eco=eco.reg$Value)
	the.sums <- aggregate(the.data$Value,by=list(eco.reg$Step_1),FUN=sum)
	the.sums$x <- round(the.sums$x)
	# the.sums <- aggregate(the.data[,'Value'],by=list(the.data[,'Eco']),FUN=sum)
	cat('sums done\n')
	# aggregate(datos[,c("a1","a2","a3")], by=list(datos$Position), "sum")
	
	temp <- the.sums
	colnames(temp) <- c('Step_1','Sum')
	output.map <- merge(eco.reg,temp)
	# print(head(output.map))
	output.map <- output.map[,c('Hex_ID','Sum')]
	
	write.csv(output.map, paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario,'/',scenario,'-[1]/eco.',tally.name,'.csv',sep=''),row.names=FALSE)
	write.csv(the.sums, paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario,'/',scenario,'-[1]/eco.',tally.name,'.table.csv',sep=''),row.names=FALSE)
	return(the.sums)
}

# EcoRegions
eco.reg <- read.csv('f:/pnwccva_data2/hexsim/workspaces/lynx_v1/analysis/ecoregions.csv',header=TRUE)
# print(head(eco.reg))
# cat('load ecoregions\n')
	
baseline.sum <- eco.tally(
						hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
						spp.folder='lynx_v1',
						scenario='lynx.041b',
						tally.name='BirthsMinusDeaths',
						eco.reg=eco.reg
						)

scenarios <- c('lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')

for (i in scenarios)
{
	future.sum <- eco.tally(
							hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
							spp.folder='lynx_v1',
							scenario=i,
							tally.name='BirthsMinusDeaths',
							eco.reg=eco.reg
							)
}
