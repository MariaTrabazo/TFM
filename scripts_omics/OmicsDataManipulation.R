library("here")
library("spgs")
library("peakRAM")
library("stringr")
library("ggplot2")
library("ggfortify")
library("rgl")

write_results <- function(folder, file, df){
    path <- here(folder, file)
    write.table(df, path, append = TRUE, quote = FALSE, sep=" ", dec=".",
            col.names = FALSE, row.names = FALSE)

}

write_output_txt <- function(folder, file, data){
	path <- here(folder, file)
	write.table(data, file = path, append = TRUE,
            row.names = FALSE)

}

calculate_by_row <- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/table_counts.tsv")
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	for(i in 1:nrow(df)){
		write_output_txt("scripts_omics/results", "results_by_row.txt", paste("R mean by row ", toString(mean(matrix(unlist(df[i, ]))))))
		write_output_txt("scripts_omics/results", "results_by_row.txt", paste("R median by row ", toString(median(matrix(unlist(df[i, ]))))))
		write_output_txt("scripts_omics/results", "results_by_row.txt", paste("R standard deviation by row ", toString(sd(matrix(unlist(df[i, ]))))))
	}
	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

calculate_by_column <- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/table_counts.tsv")
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	for(i in 1:ncol(df)){
		write_output_txt("scripts_omics/results", "results_by_column.txt", paste("R mean by column ", toString(mean(matrix(unlist(df[i]))))))
		write_output_txt("scripts_omics/results", "results_by_column.txt", paste("R median by column ", toString(median(matrix(unlist(df[i]))))))
		write_output_txt("scripts_omics/results", "results_by_column.txt", paste("R standard deviation by column ", toString(sd(matrix(unlist(df[i]))))))
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
	
	write_output_txt("scripts_omics/results", "results_all.txt", paste("R mean by column ", toString(mean_value)))
	write_output_txt("scripts_omics/results", "results_all.txt", paste("R median by column ", toString(median_value)))
	write_output_txt("scripts_omics/results", "results_all.txt", paste("R standard deviation by column ", toString(sd_value)))
	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

calculate_pca<- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/E-GEOD-22954.csv") # https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-GEOD-22954
	df <- read.csv(file = path, header = FALSE, sep = ',', row.names = 1, skip=1)
	
	col2_1 <- df[1:20,2]
	col2_2 <- df[21:40,2]
	col1 <- c(df[,1], col2_1)
	col3 <- c(col2_2, df[,3])
	
	df2 <- data.frame(col1, col3)
	
	pc <- prcomp(df2, center = TRUE, scale. = TRUE)	
	png("results/r_plot.png")
	myplot <- autoplot(pc, colour="blue")
	print(myplot)
	dev.off()
		
	write_output_txt("scripts_omics/results", "results_pca.txt", paste("R pca ", toString(pc)))

	
	end_time <- Sys.time()
    time_taken <- end_time - start_time

}

calculate_ttest<- function(){

	start_time <- Sys.time()
	path <- here("scripts_omics/table_counts.tsv")
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	list_early <- c(df[,1], df[,2], df[,3])
	list_late <- c(df[,4], df[,5], df[,6])
	
	ttest <- t.test(list_early, list_late)
	
		
	write_output_txt("scripts_omics/results", "results_ttest.txt", paste("R ttest ", toString(ttest)))

	
	end_time <- Sys.time()
    time_taken <- end_time - start_time

}


get_benchmarks <- function(){

	print("Calculando por fila")
	times_database <- system.time(calculate_by_row())
	memory_database <- peakRAM(calculate_by_row())
	df_database <- data.frame('R',  memory_database$Peak_RAM_Used_MiB,  times_database[3], times_database[1])
	write_results("scripts_omics/results", "results_by_row.csv", df_database)
	
	print("Calculando por columna")
	times_alignment <- system.time(calculate_by_column())
	memory_alignment <- peakRAM(calculate_by_column())
	df_alignment <- data.frame('R', memory_alignment$Peak_RAM_Used_MiB, times_alignment[3], times_alignment[1])
	write_results("scripts_omics/results", "results_by_column.csv", df_alignment)

	print("Calculando para toda la tabla")		
	times_rev_comp <- system.time(calculate_for_all_data())
	memory_rev_comp <- peakRAM(calculate_for_all_data())
	df_rev_comp <- data.frame('R', memory_rev_comp$Peak_RAM_Used_MiB, times_rev_comp[3], times_rev_comp[1])
	write_results("scripts_omics/results", "results_all.csv", df_rev_comp)
	
	print("Obteniendo PCA")
	times_coordinates <- system.time(calculate_pca())
	memory_coordinates <- peakRAM(calculate_pca())
	df_coordinates <- data.frame('R', memory_coordinates$Peak_RAM_Used_MiB, times_coordinates[3], times_coordinates[1])
	write_results("scripts_omics/results", "results_pca.csv", df_coordinates)

	print("Calculando ttest")
	times_ttest <- system.time(calculate_ttest())
	memory_ttest <- peakRAM(calculate_ttest())
	df_ttest <- data.frame('R', memory_ttest$Peak_RAM_Used_MiB, times_ttest[3], times_ttest[1])
	write_results("scripts_omics/results", "results_ttest.csv", df_ttest)

}

get_benchmarks()
