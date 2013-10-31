source('scenario.vector.r')
source('extract.number.r')

do.counts <- function(data.files, out.file, type, var.name=NA)
{
	if (type=='abundance')
	{
		occupied <- as.data.frame(matrix(rep(NA,30),ncol=6))
		colnames(occupied) <- c('BASELINE','CCSM3','CGCM3.1','GISS-ER','MIROC3.2','UKMO-HadCM3')
		rownames(occupied) <- c('occupied','unoccupied','increasing','decreasing','stable')
		# print(occupied)
		
		for (i in 1:length(data.files))
		{
			# print(data.files[i])
			the.data <- read.csv(data.files[i], stringsAsFactors=FALSE, row.names=1, skip=4, header=FALSE)
			last.col <- dim(the.data)[2]
			# print(head(the.data))
			the.data$CBW_CODE <- sapply(rownames(the.data),FUN=extract.number,simplify=TRUE,var.name=var.name)
			# print(head(the.data))

			if (length(grep('base',data.files[i])) >= 1)
			{ 
				the.data <- the.data[,c(last.col:(last.col+1))]
				# print(head(the.data))
				colnames(the.data) <- c('mean','CBW_CODE')
				occupied[1,1] <- length(the.data$mean[the.data$mean > 0])
				occupied[2,1] <- length(the.data$mean[the.data$mean == 0])
				# print(occupied)
			}
			else 
			{
				the.data <- the.data[,c((last.col-1):(last.col+1))]
				# print(head(the.data))
				colnames(the.data) <- c('mean','change','CBW_CODE')
				occupied[1,i] <- length(the.data$mean[the.data$mean > 0])
				occupied[2,i] <- length(the.data$mean[the.data$mean == 0])
				# Occupied and increasing/decreasing at the end of the century
				occupied[3,i] <- length(the.data$change[the.data$change >= 1 & the.data$mean > 0])
				occupied[4,i] <- length(the.data$change[the.data$change <= (-1) & the.data$mean > 0])
				
				# occupied[5,i] <- length(the.data$change[the.data$change > (-1) & the.data$change < 1])
				occupied[5,i] <- occupied[1,i] - occupied[3,i] - occupied[4,i]
				# print(occupied)
			}	
		}
		
		print(occupied)
		write.csv(occupied, out.file, row.names=FALSE) 
		# return(the.data)
	}
}

# # Wolverine
# scenarios <- scenarios.vector(
				# base.sim='gulo.023.a2.',
				# gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'),
				# other='' # c('','.biomes','.swe')
				# )

# scenarios.files <- paste('H:/HexSim/Workspaces/wolverine_v1/Results/',scenarios,'/abs.change.',scenarios,'.huc.100.109.csv',sep='')
# scenarios.files <- c('H:/HexSim/Workspaces/wolverine_v1/Results/gulo.023.baseline/mean.gulo.023.baseline.huc.41.50.csv', scenarios.files)
# print(scenarios.files)

# do.counts(data.files=scenarios.files, out.file='H:/HexSim/Workspaces/wolverine_v1/Analysis/count.hucs.csv', type='abundance', var.name='huc')

# # Lynx
# scenarios <- scenarios.vector(
				# base.sim='lynx.050.',
				# gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'),
				# other='' # c('','.35')
				# )

# scenarios.files <- paste('I:/HexSim/Workspaces/lynx_v1/Results/',scenarios,'/abs.change.',scenarios,'.huc.97.105.csv',sep='')
# scenarios.files <- c('I:/HexSim/Workspaces/lynx_v1/Results/lynx.050.baseline/mean.lynx.050.baseline.huc.34.42.csv', scenarios.files)
# print(scenarios.files)

# do.counts(data.files=scenarios.files, out.file='I:/HexSim/Workspaces/lynx_v1/Analysis/count.hucs.csv', type='abundance', var.name='huc')

# # Spotted Frog
# scenarios <- scenarios.vector(
				# base.sim='rana.lut.104.100.',
				# gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'),
				# other='' # c('','.35')
				# )

# scenarios.files <- paste('H:/HexSim/Workspaces/spotted_frog_v2/Results/',scenarios,'/abs.change.',scenarios,'.huc.99.109.csv',sep='')
# scenarios.files <- c('H:/HexSim/Workspaces/spotted_frog_v2/Results/rana.lut.104.100.baseline/mean.rana.lut.104.100.baseline.huc.31.40.csv', scenarios.files)
# print(scenarios.files)

# do.counts(data.files=scenarios.files, out.file='H:/HexSim/Workspaces/spotted_frog_v2/Analysis/count.hucs.csv', type='abundance', var.name='huc')

# Squirrel
scenarios <- scenarios.vector(
				base.sim='squirrel.016.110.',
				gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'),
				other='' # c('','.35')
				)

scenarios.files <- paste('F:/pnwccva_data2/HexSim/Workspaces/town_squirrel_v1/Results/',scenarios,'/abs.change.',scenarios,'.huc.99.109.csv',sep='')
scenarios.files <- c('F:/pnwccva_data2/HexSim/Workspaces/town_squirrel_v1/Results/squirrel.016.110.baseline/mean.squirrel.016.110.baseline.huc.31.40.csv', scenarios.files)
print(scenarios.files)

do.counts(data.files=scenarios.files, out.file='F:/pnwccva_data2/HexSim/Workspaces/town_squirrel_v1/Analysis/count.hucs.csv', type='abundance', var.name='huc')
