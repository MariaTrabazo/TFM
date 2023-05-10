library("ggplot2")




database_data <- read.csv("/home/maria/Documentos/TFM/PEC2/scripts/results/results_database.csv", sep='\t')


database_memory <- ggplot(database_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de descarga de base de datos",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/database_memory.png", database_memory)

database_cpu_time <- ggplot(database_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de descarga de base de datos",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/database_cpu_time.png", database_cpu_time)

database_time <- ggplot(database_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de descarga de base de datos",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/database_time.png", database_time)










alignment_data <- read.csv("/home/maria/Documentos/TFM/PEC2/scripts/results/results_alignment.csv", sep='\t')


alignment_memory <- ggplot(alignment_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria del alineamiento",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/alignment_memory.png", alignment_memory)

alignment_cpu_time <- ggplot(alignment_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de descarga del alineamiento",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/alignment_cpu_time.png", alignment_cpu_time)

alignment_time <- ggplot(alignment_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion del alineamiento",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/alignment_time.png", alignment_time)











rev_comp_data <- read.csv("/home/maria/Documentos/TFM/PEC2/scripts/results/results_rev_comp.csv", sep='\t')


rev_comp_memory <- ggplot(rev_comp_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de la reversa complementaria",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/rev_comp_memory.png", rev_comp_memory)

rev_comp_cpu_time <- ggplot(rev_comp_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de la reversa complementaria",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/rev_comp_cpu_time.png", rev_comp_cpu_time)

rev_comp_time <- ggplot(rev_comp_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de la reversa complementaria",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/rev_comp_time.png", rev_comp_time)













coordinates_data <- read.csv("/home/maria/Documentos/TFM/PEC2/scripts/results/results_coordinates.csv", sep='\t')

coordinates_memory <- ggplot(coordinates_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de secuencia por coordenadas",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/coordinates_memory.png", coordinates_memory)

coordinates_cpu_time <- ggplot(coordinates_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/coordinates_cpu_time.png", coordinates_cpu_time)

coordinates_time <- ggplot(coordinates_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/PEC2/scripts/imagenes/coordinates_time.png", coordinates_time)











