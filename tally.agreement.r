
plus.or.minus <- function(x, no.change)
{
	if (is.na(x)==TRUE) { return(NA) }
	if (x>=no.change) { return(1) }
	if (x<=(-1*no.change)) { return(-1) }
	else { return(0) }
}

# print(sapply(c(-10,-10,-10,1,5),plus.or.minus, no.change=2))
# stop('cbw')

tally.agreement <- function(x)
{
	the.table <- table(x)
	the.order <- order(the.table)
	score <- as.numeric(names(the.table)[the.order[length(the.order)]])
	# print(score)
	multiplier <- as.numeric(the.table[the.order[length(the.order)]])
	# print(multiplier)
	# Check for ties
	if (length(the.table)>1)
	{
		check <- as.numeric(the.table[the.order[length(the.order)]]) == as.numeric(the.table[the.order[(length(the.order)-1)]])
		# print(check)
		if (check==TRUE)
		{
			if ((score==1 | score==-1) & as.numeric(names(the.table)[the.order[(length(the.order)-1)]])==0)
			{
				score <- score
			}
			else { score <- 0 }
		}
	}
	value <- score*multiplier
	# print(value)
	# print('end')
	return(value)
}

# tally.agreement(x=c(-1,-1,-1,0,1))
# tally.agreement(x=c(-1,-1,1,0,1))
# tally.agreement(x=c(-1,0,1,0,1))
# tally.agreement(x=c(TRUE,TRUE,TRUE,FALSE,FALSE))



# print(test)

