using CSV
using CPUTime
using GenomicAnnotations
using DataFrames
using StatsBase
using MultivariateStats
using RDatasets
using CPUTime
using BenchmarkTools 
using Plots
using HypothesisTests

#se escriben los resultados de memoria, tiempo de ejecución y tiempo de CPU
function write_results(data, file)
    path = dirname(Base.source_path()) * "/results/" * file
    open(path, "a") do f
    	CSV.write(f, data, header = false, append = true, delim = ' ')
    	close(f)
    end
end

#se escriben los resultados de cada una de las funciones
function write_output_txt(data, file)
    
    path = dirname(Base.source_path()) * "/results/" * file
    open(path, "a") do f
    	write(f, data)
    	close(f)
    end
end

#calculo de estadísticos por columna
function calculate_by_column()
	
	start= time()
	path = dirname(Base.source_path()) * "/table_counts.tsv"
	df = CSV.read(path, DataFrame, select=[2,3,4,5,6,7,8,9,10])
	for col in eachcol(df)
		write_output_txt("\nJulia mean by column " *string(mean_and_std(col)[1])*"\n", "results_by_column.txt")
		write_output_txt("\nJulia median by column " *string(median(col))*"\n", "results_by_column.txt")
		write_output_txt("\nJulia standard deviation by column " *string(mean_and_std(col)[2])*"\n", "results_by_column.txt")
	end
	dt = time() - start


end

#calculo de estadisticos para toda la tabla
function calculate_for_all_data()
	
	start= time()
	path = dirname(Base.source_path()) * "/table_counts.tsv"
	df = CSV.read(path, DataFrame, select=[2,3,4,5,6,7,8,9,10])
	mean = 0
	median_value = 0
	std = 0
	for col in eachcol(df)
		mean = mean + mean_and_std(col)[1]
		median_value = median_value + median(col)
		std = std + mean_and_std(col)[2]
	end
	
	write_output_txt("\nJulia mean all " *string(mean)*"\n", "results_all.txt")
	write_output_txt("\nJulia median all " *string(median_value)*"\n", "results_all.txt")
	write_output_txt("\nJulia standard deviation all " *string(std)*"\n", "results_all.txt")
	
	dt = time() - start


end

#calculo de estadisticas por fila
function calculate_by_row()
	
	start= time()
	path = dirname(Base.source_path()) * "/table_counts.tsv"
	df = CSV.read(path, DataFrame, select=[2,3,4,5,6,7,8,9,10])
	
	for n in 1:length(df[1])
		row = df[n, :]
		write_output_txt("\nJulia mean by row " *string(mean_and_std(row)[1])*"\n", "results_by_row.txt")
		write_output_txt("\nJulia median by row " *string(median(row))*"\n", "results_by_row.txt")
		write_output_txt("\nJulia standard deviation by row " *string(mean_and_std(row)[2])*"\n", "results_by_row.txt")
		
	end
	
	dt = time() - start


end


#calculo del t-test
function calculate_ttest()

	start= time()
	path = dirname(Base.source_path()) * "/table_counts.tsv"
	df = CSV.read(path, DataFrame, select=[2,3,4,5,6,7])
	col1 = df[:, "WholeOvary_Ctrl_Early_1"]
	col2 = df[:, "WholeOvary_Ctrl_Early_2"]
	col3 = df[:, "WholeOvary_Ctrl_Early_3"]
	list_early = vcat(col1, col2, col3)
	
	col4 = df[:, "WholeOvary_Ctrl_Late_1"]
	col5 = df[:, "WholeOvary_Ctrl_Late_2"]
	col6 = df[:, "WholeOvary_Ctrl_Late_3"]
	list_late = vcat(col4, col5, col6)
	ttest = OneSampleTTest(vec(list_early), vec(list_late))
	
	write_output_txt("\nJulia ttest " *string(ttest)*"\n", "results_ttest.txt")
	
	dt = time() - start


end

#se realiza la llamada secuencial de todas las funciones
function get_benchmarks()


    result_bm_database = @benchmark calculate_by_row()
    time_database =  calculate_by_row()
    @CPUtime calculate_by_row()
    df_database = DataFrame(language = "Julia", memory = result_bm_database.memory * 0.00000095367431640625, time = time_database, cpu_time = 1)
    write_results(df_database, "results_by_row.csv")

   
    result_bm_alignment = @benchmark calculate_by_column()
    time_alignment = calculate_by_column()
    @CPUtime calculate_by_column()
    df_alignment = DataFrame(language = "Julia", memory = result_bm_alignment.memory * 0.00000095367431640625, time = time_alignment, cpu_time = 1)
    write_results(df_alignment, "results_by_column.csv")

    
    result_bm_rev_comp = @benchmark calculate_for_all_data()
    time_rev_comp = calculate_for_all_data()
    @CPUtime calculate_for_all_data
    df_rev_comp = DataFrame(language = "Julia", memory = result_bm_rev_comp.memory * 0.00000095367431640625, time = time_rev_comp, cpu_time = 1)
    write_results(df_rev_comp, "results_all.csv")

    
    result_ttest= @benchmark calculate_ttest()
    time_ttest = calculate_ttest()
    @CPUtime calculate_ttest
    df_ttest = DataFrame(language = ["Julia"], memory = result_ttest.memory * 0.00000095367431640625, time = time_ttest, cpu_time = 1)
    write_results(df_ttest, "results_ttest.csv")

   
    
end

get_benchmarks()
