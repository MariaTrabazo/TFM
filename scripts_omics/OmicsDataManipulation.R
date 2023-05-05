library("here")
library("spgs")
library("peakRAM")
library("stringr")
library("ggplot2")
library("ggfortify")
library("rgl")



calculate_by_row <- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/table_counts.tsv")
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	for(i in 1:nrow(df)){
		print("Media")
		print(mean(matrix(unlist(df[i, ]))))
		print("Mediana")
		print(median(matrix(unlist(df[i, ]))))
		print("Desviacion estandar")
		print(sd(matrix(unlist(df[i, ]))))
	}
	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

calculate_by_column <- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/table_counts.tsv")
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	for(i in 1:ncol(df)){
		print("Media")
		print(mean(matrix(unlist(df[i]))))
		print("Mediana")
		print(median(matrix(unlist(df[i]))))
		print("Desviacion estandar")
		print(sd(matrix(unlist(df[i]))))
	}
	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

calculate_for_all_data <- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/table_counts.tsv")
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	
	mean_value = 0
	median_value = 0
	sd_value = 0
	for(i in 1:ncol(df)){
		mean_value = mean_value + mean(matrix(unlist(df[i])))
		median_value = median_value + median(matrix(unlist(df[i])))
		sd_value = sd_value + sd(matrix(unlist(df[i])))
	}
	
	print("Media")
	print(mean_value)
	print("Mediana")
	print(median_value)
	print("Desviacion estandar")
	print(sd_value)
	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

calculate_pca<- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/E-GEOD-22954.csv") # https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-GEOD-22954
	df <- read.csv(file = path, header = FALSE, sep = ',', row.names = 1, skip=1)
	
	#df_divided <- split(df, factor(sort(rank(row.names(df))%%2)))
	#x <- df_divided$'0'
	#y <- df_divided$'1'
	
	pc <- prcomp(df, center = TRUE, scale. = TRUE)
	par(mfrow = c(1, 3))
	p1 <- ggplot(pc, aes(x=row.names(df), y=PC1)) + geom_bar(stat = "identity")
	p2 <- ggplot(pc, aes(x=row.names(df), y=PC2)) + geom_bar(stat = "identity")
	p3 <- ggplot(pc, aes(x=row.names(df), y=PC3)) + geom_bar(stat = "identity")
	X11()
	plot(p1)
	plot(p2)
	plot(p3)
	while(!is.null(dev.list())) Sys.sleep(1)
	
	
	
	end_time <- Sys.time()
    time_taken <- end_time - start_time

}

#calculate_by_row()
#calculate_by_column()
#calculate_for_all_data()
calculate_pca()
