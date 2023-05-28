library("ggplot2")
library("tibble")




database_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_omics/results/results_by_row.csv", sep=' ')

database_memory <- ggplot(database_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de descarga de base de datos",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/by_row_memory.png", database_memory)

database_cpu_time <- ggplot(database_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de descarga de base de datos",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/by_row_cpu_time.png", database_cpu_time)

database_time <- ggplot(database_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de descarga de base de datos",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/by_row_time.png", database_time)


alignment_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_omics/results/results_by_column.csv", sep=' ')


alignment_memory <- ggplot(alignment_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria del alineamiento",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/by_column_memory.png", alignment_memory)

alignment_cpu_time <- ggplot(alignment_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de descarga del alineamiento",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/by_column_cpu_time.png", alignment_cpu_time)

alignment_time <- ggplot(alignment_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion del alineamiento",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/by_column_time.png", alignment_time)











rev_comp_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_omics/results/results_all.csv", sep=' ')


rev_comp_memory <- ggplot(rev_comp_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de la reversa complementaria",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/all_memory.png", rev_comp_memory)

rev_comp_cpu_time <- ggplot(rev_comp_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de la reversa complementaria",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/all_cpu_time.png", rev_comp_cpu_time)

rev_comp_time <- ggplot(rev_comp_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de la reversa complementaria",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/all_time.png", rev_comp_time)






ttest_data <- read.csv("/home/maria/Documentos/TFM/TFM/scripts_omics/results/results_ttest.csv", sep=' ')

ttest_memory <- ggplot(ttest_data, aes(y=memory.MiB., x=language, fill=memory.MiB.)) + geom_bar(stat = "identity") + labs(title = "Uso de memoria de secuencia por coordenadas",  x = "Lenguajes", y = "Memoria(MiB)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/ttest_memory.png", ttest_memory)

ttest_cpu_time <- ggplot(ttest_data, aes(y=CPU_time.s., x=language, fill=CPU_time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de CPU de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de CPU(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/ttest_cpu_time.png", ttest_cpu_time)

ttest_time <- ggplot(ttest_data, aes(y=time.s., x=language, fill=time.s.)) + geom_bar(stat = "identity") + labs(title = "Tiempo de ejecucion de secuencia por coordenadas",  x = "Lenguajes", y = "Tiempo de ejecucion(s)")
ggsave("/home/maria/Documentos/TFM/TFM/scripts_omics/imagenes/ttest_time.png", ttest_time)
















