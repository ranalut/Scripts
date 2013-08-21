
d.tally <- function(hexsim.wksp,spp.folder,base.scenario,fut.scenario,tally.name='BirthsMinusDeaths')
{
	file.remove(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/class.',tally.name,'.csv',sep=''))
	file.remove(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/class.',tally.name,'.csv',sep=''))
	file.remove(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/delta.',tally.name,'.csv',sep=''))
	file.remove(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/delta.class.',tally.name,'.csv',sep=''))
	
	file.names <- dir(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/',sep=''))
	# print(file.names)
	baseline.file <- grep(tally.name,file.names,value=TRUE)
	# print(baseline.file)
	baseline <- read.csv(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/',baseline.file,sep=''),header=TRUE)
	# print(head(baseline)); stop('cbw')

	baseline.c <- baseline
	baseline.c$Value[baseline.c$Value <= -25] <- -3
	baseline.c$Value[baseline.c$Value > -25 & baseline.c$Value <= -5] <- -2
	baseline.c$Value[baseline.c$Value <= -1 & baseline.c$Value > -5] <- -1
	baseline.c$Value[baseline.c$Value > -1 & baseline.c$Value < 0] <- -0.01
	baseline.c$Value[baseline.c$Value > 0 & baseline.c$Value < 1] <- 0.01
	baseline.c$Value[baseline.c$Value >= 1 & baseline.c$Value < 5] <- 1
	baseline.c$Value[baseline.c$Value >= 5 & baseline.c$Value < 25] <- 2
	baseline.c$Value[baseline.c$Value >= 25] <- 3
	write.csv(baseline.c, paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/class.',tally.name,'.csv',sep=''),row.names=FALSE)

	file.names <- dir(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/',sep=''))
	# print(file.names)
	fut.file <- grep(tally.name,file.names,value=TRUE)
	future <- read.csv(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/',fut.file,sep=''),header=TRUE)
	
	future.c <- future
	future.c$Value[future.c$Value <= -25] <- -3
	future.c$Value[future.c$Value > -25 & future.c$Value <= -5] <- -2
	future.c$Value[future.c$Value <= -1 & future.c$Value > -5] <- -1
	future.c$Value[future.c$Value > -1 & future.c$Value < 0] <- -0.01
	future.c$Value[future.c$Value > 0 & future.c$Value < 1] <- 0.01
	future.c$Value[future.c$Value >= 1 & future.c$Value < 5] <- 1
	future.c$Value[future.c$Value >= 5 & future.c$Value < 25] <- 2
	future.c$Value[future.c$Value >= 25] <- 3
	write.csv(future.c, paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/class.',tally.name,'.csv',sep=''),row.names=FALSE)
	
	output <- future
	output$Value <- future$Value - baseline$Value
	# print(head(output))
	print(range(output$Value))
	
	write.csv(output, paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/delta.',tally.name,'.csv',sep=''),row.names=FALSE)
	
	output$Value[output$Value <= -25] <- -3
	output$Value[output$Value > -25 & output$Value <= -5] <- -2
	output$Value[output$Value <= -1 & output$Value > -5] <- -1
	output$Value[output$Value > -1 & output$Value < 0] <- -0.01
	output$Value[output$Value > 0 & output$Value < 1] <- 0.01
	output$Value[output$Value >= 1 & output$Value < 5] <- 1
	output$Value[output$Value >= 5 & output$Value < 25] <- 2
	output$Value[output$Value >= 25] <- 3
	write.csv(output, paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',fut.scenario,'/',fut.scenario,'-[1]/delta.class.',tally.name,'.csv',sep=''),row.names=FALSE)
}


d.tally(
	hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
	spp.folder='lynx_v1',
	base.scenario='lynx.041b',
	fut.scenario='lynx.041b.ccsm3',
	tally.name='BirthsMinusDeaths'
	)
