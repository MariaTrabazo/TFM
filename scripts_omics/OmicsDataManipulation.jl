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

function calculate_pca()

	start= time()
	path = dirname(Base.source_path()) * "/E-GEOD-22954.csv"
	df = CSV.read(path, DataFrame)
	
	matrix = Array(df[:, 2:end])'
	
	M = fit(PCA, matrix; maxoutdim=2)
	Yte = predict(M, matrix)
	
	h = scatter!(Yte[1,:], Yte[2,:], label="")
	plot!(xlabel="PC1", ylabel="PC2", framestyle=:box)
	savefig(h, "results/julia_plot.png")
	
	write_output_txt("\nJulia pca " *string(Yte)*"\n", "results_pca.txt")
	
	dt = time() - start


end


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

    
    result_bm_coordinates= @benchmark calculate_pca()
    time_coordinates = calculate_pca()
    @CPUtime calculate_pca
    df_coordinates = DataFrame(language = ["Julia"], memory = result_bm_coordinates.memory * 0.00000095367431640625, time = time_coordinates, cpu_time = 1)
    write_results(df_coordinates, "results_pca.csv")

   
    
end

get_benchmarks()
