
data.prep <- function(data.file, type, var.name=NA)
{
	
	if (type=='productivity')
	{
		the.data <- read.csv(data.file,header=TRUE, stringsAsFactors=FALSE, row.names=1)
		the.data <- the.data[,c(1,dim(the.data)[2])]
		# print(head(the.data)); stop('cbw')
		colnames(the.data) <- c('CBW_CODE','variable')
		return(the.data)
	}
	if (type=='abundance')
	{
		the.data <- read.csv(data.file, stringsAsFactors=FALSE, row.names=1, skip=4, header=FALSE)
		last.col <- dim(the.data)[2]
		# print(head(the.data))
		the.data$CBW_CODE <- sapply(rownames(the.data),FUN=extract.number,simplify=TRUE,var.name=var.name)
		# print(head(the.data))
		the.data <- the.data[,c(last.col,(last.col+1))]
		colnames(the.data) <- c('variable','CBW_CODE')
		# print(head(the.data))
		# print(table(the.data$variable))
		return(the.data)
	}
}

data.prep.2 <- function(data.file, type, var.name=NA, column.name)
{
	
	if (type=='productivity')
	{
		the.data <- read.csv(data.file,header=TRUE, stringsAsFactors=FALSE, row.names=1)
		the.data <- the.data[,c(1,dim(the.data)[2])]
		# print(head(the.data)); stop('cbw')
		colnames(the.data) <- c('CBW_CODE','variable')
		return(the.data)
	}
	if (type=='abundance')
	{
		the.data <- read.csv(data.file, stringsAsFactors=FALSE, row.names=1, header=TRUE)
		the.data <- the.data[-c(1:3),]
		last.col <- dim(the.data)[2]
		# print(head(the.data))
		the.data$CBW_CODE <- sapply(rownames(the.data),FUN=extract.number,simplify=TRUE,var.name=var.name)
		# print(head(the.data)); stop('cbw')
		the.data <- the.data[,c(column.name,'CBW_CODE')]
		colnames(the.data) <- c('variable','CBW_CODE')
		# print(head(the.data))
		# print(table(the.data$variable))
		return(the.data)
	}
}
