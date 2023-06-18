library("here")
library("spgs")
library("peakRAM")
library("stringr")
library("ggplot2")
library("ggfortify")
library("rgl")
library("keras")
library("cluster")


#se escriben los resultados de memoria, tiempo de ejecución y tiempo de CPU
write_results <- function(folder, file, df){
    path <- here(folder, file)
    write.table(df, path, append = TRUE, quote = FALSE, sep=" ", dec=".",
            col.names = FALSE, row.names = FALSE)

}

#se escriben los resultados de cada una de las funciones
write_output_txt <- function(folder, file, data){
	path <- here(folder, file)
	write.table(data, file = path, append = TRUE,
            row.names = FALSE)

}

#se calcula el modelo de regresion lineal
linear_regression <- function(){

	start_time <- Sys.time()
	path <- here("scripts_machine_learning/E-GEOD-22954.csv")
	df <- read.csv(file = path, header = FALSE, sep = ',', row.names = 1, skip=1)
	
	
	split_index <- round(nrow(df) / 2)
	a <- df[1:split_index, 1:ncol(df)]
	b <- df[(split_index + 1):nrow(df), 1:ncol(df)]

	
	x <- as.vector(t(a))
	y <- as.vector(t(b))
	
	
	model <- lm(y ~ x, data = data.frame(x = x, y = y))
	fit <- summary(model)

	
	y_pred <- predict(model, newdata = data.frame(x = x))

	
	write_output_txt("scripts_machine_learning/results", "results_reg_lin.txt", paste("R coeficientes ", toString(coef(fit))))
	write_output_txt("scripts_machine_learning/results", "results_reg_lin.txt", paste("R intercept ", toString(coef(fit)[1])))
	write_output_txt("scripts_machine_learning/results", "results_reg_lin.txt", paste("R valores predichos ", toString(y_pred)))

	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

#analisis de componentes principales
calculate_pca<- function(){

	start_time <- Sys.time()
	path <- here("scripts_machine_learning/table_counts.tsv") # https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-GEOD-22954
	df <- read.csv(file = path, header = FALSE, sep = '\t', row.names = 1, skip=1)
	
	
	x <- df[, 1:ncol(df)]
	y <- df[, 1]
	
	pca <- prcomp(x, rank = min(nrow(x), ncol(x)))
	principalComponents <- pca$x
	
	
	wss <- numeric(9)  
	for (i in 1:9) {
	  kmeans_clusters <- kmeans(pca$x[, 1:i], centers = i)
	  wss[i] <- kmeans_clusters$tot.withinss
	}
	
	pdf("results/elbow_r_plot.pdf")
	plot<-plot(1:9, wss, type = "b", xlab = "Number of Clusters", ylab = "Within-Cluster Sum of Squares")
	dev.off()
	
	
	k <- 3 
	kmeans_clusters <- kmeans(pca$x[, 1:k], centers = k) 
	kmeans_clusters$cluster  
	pdf("results/r_plot.pdf")
	plot(pca$x[, 1], pca$x[, 2], col = kmeans_clusters$cluster, pch = 19, xlab = "PC1", ylab = "PC2")
	dev.off()

	write_output_txt("scripts_machine_learning/results", "results_pca.txt", paste("R pca ", toString(pca)))

	
	end_time <- Sys.time()
    time_taken <- end_time - start_time

}

#modelo de reconocimientos de numeros a partir de imagenes
recognise_numbers <- function(){

	start_time <- Sys.time()
	

	mnist <- dataset_mnist()
	train_x <- mnist$train$x
	train_y <- mnist$train$y
	test_x <- mnist$test$x
	test_y <- mnist$test$y

	
	train_x <- train_x / 255
	test_x <- test_x / 255

	train_y <- to_categorical(train_y, num_classes = 10)
	test_y <- to_categorical(test_y, num_classes = 10)

	
	model <- keras_model_sequential() %>%
	  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = 'relu', input_shape = c(28, 28, 1)) %>%
	  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
	  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = 'relu') %>%
	  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
	  layer_flatten() %>%
	  layer_dense(units = 64, activation = 'relu') %>%
	  layer_dense(units = 10, activation = 'softmax')

	
	model %>% compile(
	  optimizer = 'adam',
	  loss = 'categorical_crossentropy',
	  metrics = c('accuracy')
	)

	
	history <- model %>% fit(
	  train_x, train_y,
	  epochs = 10,
	  batch_size = 32,
	  validation_split = 0.2
	)

	
	scores <- model %>% evaluate(test_x, test_y)

	
	predictions <- model %>% predict(test_x)
	predicted_labels <- apply(predictions, 1, which.max)
	write_output_txt("scripts_machine_learning/results", "results_handwritten_numbers.txt", paste("R predictions ", toString(predicted_labels)))
	write_output_txt("scripts_machine_learning/results", "results_handwritten_numbers.txt", paste("R accuracy ", toString(scores[[2]])))



	
	end_time <- Sys.time()
    time_taken <- end_time - start_time
	

}

#se realiza la llamada secuencial de todas las funciones
get_benchmarks <- function(){

	print("Calculando regresion lineal")
	times_database <- system.time(linear_regression())
	memory_database <- peakRAM(linear_regression())
	df_database <- data.frame('R',  memory_database$Peak_RAM_Used_MiB,  times_database[3], times_database[1])
	write_results("scripts_machine_learning/results", "results_linear_regression.csv", df_database)
	
	print("Obteniendo PCA")
	times_coordinates <- system.time(calculate_pca())
	memory_coordinates <- peakRAM(calculate_pca())
	df_coordinates <- data.frame('R', memory_coordinates$Peak_RAM_Used_MiB, times_coordinates[3], times_coordinates[1])
	write_results("scripts_machine_learning/results", "results_pca.csv", df_coordinates)
	
	print("Calculando reconocimiento de numeros")
	times_numbers <- system.time(recognise_numbers())
	memory_numbers <- peakRAM(recognise_numbers())
	df_numbers <- data.frame('R',  memory_numbers$Peak_RAM_Used_MiB,  times_numbers[3], times_numbers[1])
	write_results("scripts_machine_learning/results", "results_handwritten_numbers.csv", df_numbers)
	
	

}



get_benchmarks()
