library("seqinr")
library("here")
library("rentrez")
library("Biostrings")
library("spgs")
library("stringi")
library("peakRAM")
library("stringr")

#se lee el fichero en formato fasta
read_fasta <- function(folder, file){
    path <- here(folder, file)
    file <- read.fasta(path, as.string = TRUE)
    list_sequences <- c()
    for (item in file){
        list_sequences <- c(list_sequences, item)
    }
    return(list_sequences)
}

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

#se descargan las secuencias de la base de datos
get_sequences_from_database <- function(){
    
    start_time <- Sys.time()

    esearch_response <- entrez_search(db = "nucleotide",
    term = "Poaceae[Orgn] AND als[Gene]")
    gene_ids <- as.numeric(esearch_response$ids)
    
    fetch_response <- entrez_fetch(db = "nucleotide",
    id = gene_ids, rettype = "fasta")
    write(fetch_response, file = here("scripts/results",
    "sequence_list_r.fasta"))

    end_time <- Sys.time()
    time_taken <- end_time - start_time

}

#se realiza el alineamiento de secuencias  
align_two_sequences <- function(){

    start_time <- Sys.time()

    list_sequences <- read_fasta("scripts/results", "sequence_list_r.fasta")
    s1 <- toupper(list_sequences[1])
    s2 <- toupper(list_sequences[2])
    sigma <- nucleotideSubstitutionMatrix(match = 20,
        mismatch = -10, baseOnly = TRUE)
    alignment <- pairwiseAlignment(s1, s2, substitutionMatrix = sigma,
        gapOpening = -5, gapExtension = -1, scoreOnly = FALSE)
    write_output_txt("scripts/results", "results_alignment.txt", paste("R alignment score", score(alignment)))

    end_time <- Sys.time()
    time_taken <- end_time - start_time
}

#se obtiene la reversa complementaria
get_complementary_reverse_sequence <- function(){
    start_time <- Sys.time()

    list_sequences <- read_fasta("scripts/results", "sequence_list_r.fasta")
    s1 <- toupper(list_sequences[3])
    reverse_complementary <- reverseComplement(s1)
    write_output_txt("scripts/results", "results_rev_comp.txt", paste("R reverse complementary ", toupper(reverse_complementary)))

    end_time <- Sys.time()
    time_taken <- end_time - start_time
}

#se obtienen las secuencias según sus coordenadas
get_sequence_from_coordinates <- function(){
    start_time <- Sys.time()

    list_sequences <- read_fasta("scripts/results", "sequence_list_r.fasta")
    write_output_txt("scripts/results", "results_coordinates.txt", "R sequences from coordinates")
    for(seq in list_sequences){
        dna_seq <- DNAString(toupper(seq))
        if (length(dna_seq) >= 100) {
            feature_seq <- subseq(dna_seq, 6, 100)
        }else{
            feature_seq <- subseq(dna_seq, 6, length(dna_seq))
        }
        write_output_txt("scripts/results", "results_coordinates.txt", toString(feature_seq))
    }
    end_time <- Sys.time()
    time_taken <- end_time - start_time

}

#se buscan coincidencias de subsecuencias
match_subsequence <- function(){
    start_time <- Sys.time()

    list_sequences <- read_fasta("", "scripts/partial_hg38.fa")
	list_strings <- c("ccc", "gaacat", "atcccaa")
	write_output_txt("scripts/results", "results_match.txt", "R subsequences matches")
	for (s in list_strings){
        count <- 0
        for(seq in list_sequences){
        	count <- count + str_count(seq, s)
        }
        write_output_txt("scripts/results", "results_match.txt", toString(count))
        
    }

    end_time <- Sys.time()
    time_taken <- end_time - start_time
}

#se realiza la llamada secuencial de todas las funciones
get_benchmarks <- function(){

	print("Obteniendo las secuencias de NCBI")
	times_database <- system.time(get_sequences_from_database())
	memory_database <- peakRAM(get_sequences_from_database())
	df_database <- data.frame('R',  memory_database$Peak_RAM_Used_MiB,  times_database[3], times_database[1])
	write_results("scripts/results", "results_database.csv", df_database)
	
	print("Realizando el alineamiento")
	times_alignment <- system.time(align_two_sequences())
	memory_alignment <- peakRAM(align_two_sequences())
	df_alignment <- data.frame('R', memory_alignment$Peak_RAM_Used_MiB, times_alignment[3], times_alignment[1])
	write_results("scripts/results", "results_alignment.csv", df_alignment)

	print("Obteniendo la reversa complementaria")		
	times_rev_comp <- system.time(get_complementary_reverse_sequence())
	memory_rev_comp <- peakRAM(get_complementary_reverse_sequence())
	df_rev_comp <- data.frame('R', memory_rev_comp$Peak_RAM_Used_MiB, times_rev_comp[3], times_rev_comp[1])
	write_results("scripts/results", "results_rev_comp.csv", df_rev_comp)
	
	print("Obteniendo secuencias a partir de coordenadas")
	times_coordinates <- system.time(get_sequence_from_coordinates())
	memory_coordinates <- peakRAM(get_sequence_from_coordinates())
	df_coordinates <- data.frame('R', memory_coordinates$Peak_RAM_Used_MiB, times_coordinates[3], times_coordinates[1])
	write_results("scripts/results", "results_coordinates.csv", df_coordinates)
	
	print("Buscando el número de coincidencias para tres subsecuencias")
	times_match <- system.time(match_subsequence())
	memory_match <- peakRAM(match_subsequence())
	df_match_subsequence <- data.frame('R', memory_match$Peak_RAM_Used_MiB, times_match[3], times_match[1])
	write_results("scripts/results", "results_match_subsequence.csv", df_match_subsequence)

}


get_benchmarks()

