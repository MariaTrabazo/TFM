library("ggplot2")




database_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/results/results_linear_regression.csv", sep=' ')


database_memory <- ggplot(database_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de descarga de base de datos",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/linear_regression_memory.png", database_memory)

database_cpu_time <- ggplot(database_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de descarga de base de datos",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/linear_regression_cpu_time.png", database_cpu_time)

database_time <- ggplot(database_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de descarga de base de datos",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/linear_regression_time.png", database_time)





coordinates_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/results/results_pca.csv", sep=' ')

coordinates_memory <- ggplot(coordinates_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de secuencia por coordenadas",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/pca_memory.png", coordinates_memory)

coordinates_cpu_time <- ggplot(coordinates_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/pca_cpu_time.png", coordinates_cpu_time)

coordinates_time <- ggplot(coordinates_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/pca_time.png", coordinates_time)





handwritten_numbers_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/results/results_handwritten_numbers.csv", sep=' ')

handwritten_numbers_memory <- ggplot(handwritten_numbers_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de secuencia por coordenadas",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/handwritten_numbers_memory.png", handwritten_numbers_memory)

handwritten_numbers_cpu_time <- ggplot(handwritten_numbers_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/handwritten_numbers_cpu_time.png", handwritten_numbers_cpu_time)

handwritten_numbers_time <- ggplot(handwritten_numbers_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_machine_learning/imagenes/handwritten_numbers_time.png", handwritten_numbers_time)









