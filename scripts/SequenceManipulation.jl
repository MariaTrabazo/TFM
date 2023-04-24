using BioAlignments
using BioSequences
using BioServices.EUtils
using FastaIO
using DelimitedFiles
using EzXML
using GenomicAnnotations
using BenchmarkTools 
using DataFrames
using CSV
using CPUTime

#https://github.com/BioJulia/BioAlignments.jl/blob/master/docs/src/pairalign.md

function read_fasta(input_file)
    path = dirname(Base.source_path()) * input_file
    sequence_list = String[]
    FastaReader(path) do fr
        for (desc,seq) in fr
            push!(sequence_list,"$seq")
        end
    end
    return sequence_list
end

function write_results(data, file)
    path = dirname(Base.source_path()) * "/results/" * file
    open(path, "a") do f
    	CSV.write(f, data, header = false, append = true, delim = ' ')
    	close(f)
    end
end

function write_output_txt(data, file)
    
    path = dirname(Base.source_path()) * "/results/" * file
    open(path, "a") do f
    	write(f, data)
    	close(f)
    end
end

function get_sequences_from_database()
    start= time()
    search_dic = Dict()
    esearch_response = esearch(search_dic, db="nucleotide", term="Poaceae[Orgn] AND als[Gene]", usehistory=true)
    txt_response = parsexml(String(esearch_response.body))
    content = nodecontent(root(txt_response))
    content_split = split(content, '\n')
    id_list = []
    for i in content_split
        if(length(i) == 10)
            push!(id_list, i)
        end
    end

    if(isfile(dirname(Base.source_path())*"/results/sequence_list_julia.fasta"))
        rm(dirname(Base.source_path())*"/results/sequence_list_julia.fasta")
    end

    for j in id_list
        efetch_response = efetch(db="nucleotide", id=j, rettype ="fasta", retmode="txt")
        open(dirname(Base.source_path())*"/results/sequence_list_julia.fasta", "a") do file
            write(file, String(efetch_response.body))
        end
        
    end
    dt = time() - start
    time_value = "\nGetting sequence from db time: "* string(dt) * "\n"
	return dt

end

function align_two_sequences()   
    start= time()
    costmodel = AffineGapScoreModel(match=20, mismatch= -10, gap_open=-5, gap_extend=-1);
    list_sequences = String[]
    list_sequences = read_fasta("/results/sequence_list_julia.fasta")
    alignments = pairalign(GlobalAlignment(), getindex(list_sequences, 1), getindex(list_sequences, 2), costmodel)
    #println(alignments)
    dt = time() - start
    alignment_score = "\nJulia alignment score: " * string(score(alignments)) 
    write_output_txt(alignment_score, "results_alignment.txt")
	return dt
end

function get_complementary_reverse_sequence()
    start= time()
    list_sequences = read_fasta("/results/sequence_list_julia.fasta")
    seq = LongDNASeq(getindex(list_sequences, 3))
    dt = time() - start
    rev_comp_result = "\nJulia reverse complementary "* string(reverse_complement(seq))
    write_output_txt(rev_comp_result, "results_rev_comp.txt")
	return dt
end



function get_sequence_from_coordinates()
    start= time()
    path = dirname(Base.source_path()) * "/results/sequence_list_julia.fasta"
    write_output_txt("\nJulia sequences from coordinates\n", "results_coordinates.txt")
    FastaReader(path) do fr
        for (desc,seq_string) in fr
            seq=LongDNASeq(seq_string)
            if(length(seq_string)>=101)
                feature_seq=seq[6:101]
            else
                feature_seq = seq[6:length(seq_string)]
            end
            write_output_txt(string(feature_seq) * "\n", "results_coordinates.txt")
        end
    end
    dt = time() - start
    #write_results(time_value, "\n", "results.txt")
	return dt
end

function match_subsequence()
    start= time()
    list_sequences = read_fasta("/partial_hg38.fa");
    list_strings = ["CCC", "GAACAT", "ATCCCAA"]
    write_output_txt("\nJulia subsequences matches\n", "results_match.txt")
    for seq_string in list_strings
        matches = 0
        #print("Sequence: " * seq_string)
        for sequence in list_sequences 
            matches=matches + length(findall(Regex(seq_string), sequence))
            
        end
        write_output_txt("\nMatches: "*string(matches)*"\n", "results_match.txt")
    end
    dt = time() - start
	return dt
end


function get_benchmarks()


    #print("Obteniendo las secuencias de NCBI\n")
    result_bm_database = @benchmark get_sequences_from_database()
    time_database =  get_sequences_from_database()
    @CPUtime get_sequences_from_database()
    df_database = DataFrame(language = "Julia", memory = result_bm_database.memory * 0.00000095367431640625, time = time_database, cpu_time = 1)
    write_results(df_database, "results_database.csv")

    #print("Realizando el alineamiento\n")
    result_bm_alignment = @benchmark align_two_sequences()
    time_alignment = align_two_sequences()
    #print(display(cpu_alignment))
    @CPUtime align_two_sequences()
    df_alignment = DataFrame(language = "Julia", memory = result_bm_alignment.memory * 0.00000095367431640625, time = time_alignment, cpu_time = 1)
    write_results(df_alignment, "results_alignment.csv")

    #print("Obteniendo la reversa complementaria\n")
    result_bm_rev_comp = @benchmark get_complementary_reverse_sequence()
    time_rev_comp = get_complementary_reverse_sequence()
    #print(display(result_bm_rev_comp))
    @CPUtime get_complementary_reverse_sequence
    df_rev_comp = DataFrame(language = "Julia", memory = result_bm_rev_comp.memory * 0.00000095367431640625, time = time_rev_comp, cpu_time = 1)
    write_results(df_rev_comp, "results_rev_comp.csv")

    #print("Obteniendo secuencias a partir de coordenadas\n")
    result_bm_coordinates= @benchmark get_sequence_from_coordinates()
    time_coordinates = get_sequence_from_coordinates()
    #print(display(result_bm_coordinates))
    @CPUtime get_sequence_from_coordinates
    df_coordinates = DataFrame(language = ["Julia"], memory = result_bm_coordinates.memory * 0.00000095367431640625, time = time_coordinates, cpu_time = 1)
    write_results(df_coordinates, "results_coordinates.csv")

    #print("Buscando el número de coincidencias para tres subsecuencias\n")
    result_bm_match = @benchmark match_subsequence()
    time_match = match_subsequence()
    #print(display(result_bm_match))
    @CPUtime match_subsequence
    df_match = DataFrame(language = "Julia", memory = result_bm_match.memory * 0.00000095367431640625, time= time_match, cpu_time = 1)
    write_results(df_match, "results_match_subsequence.csv")
    
end


get_benchmarks()
