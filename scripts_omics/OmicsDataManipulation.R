library("here")
library("spgs")
library("peakRAM")
library("stringr")



calculate_by_row <- function(){

	start_time <- Sys.time()
	path <- here("table_counts.tsv")
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
	path <- here("table_counts.tsv")
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
	path <- here("table_counts.tsv")
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

#calculate_by_row()
#calculate_by_column()
calculate_for_all_data()
