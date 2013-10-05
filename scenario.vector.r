
scenarios.vector <- function(base.sim, gcms, other)
{
	scenarios <- NA
	for (i in gcms)
	{
		for (j in other)
		{
			scenarios <- c(scenarios, paste(base.sim,i,j,sep=''))
		}
	}
	scenarios <- scenarios[-1]
	print(scenarios)
	return(scenarios)
}

# base.sim <- 'gulo.023.a2.'
# # base.sim <- 'gulo.023.'
# gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
# # gcms <- 'miroc'
# # gcms <- 'baseline'
# other <- c('','.biomes','.swe')
# # other <- ''

# scenarios <- scenarios.vector(
				# base.sim='gulo.023.a2.',
				# gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'),
				# other=c('','.biomes','.swe')
				# )