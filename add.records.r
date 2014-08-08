
# Add records

add.records <- function(max.r=records, mat=temp)
{
	mat <- as.matrix(mat)
	t.dim <- dim(mat)
	run.no <- mat[,'Run'][1]
	last.step <- mat[,'Time.Step'][t.dim[1]]
	
	add.mat <- matrix(0,ncol=t.dim[2],nrow=(records-t.dim[1]))
	colnames(add.mat) <- colnames(mat)
	add.mat[,'Run'] <- rep(run.no, (records-t.dim[1]))
	add.mat[,'Time.Step'] <- seq(from=(last.step+1),length.out=(records-t.dim[1]))
	add.mat[,'X'] <- rep(NA,(records-t.dim[1]))
	
	mat <- as.data.frame(rbind(mat,add.mat))
	return(mat)
}
