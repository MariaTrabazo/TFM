using CSV
using CPUTime
using GenomicAnnotations
using DataFrames
using StatsBase
using MultivariateStats
using PlotlyJS
using RDatasets

function calculate_by_column()
	
	start= time()
	path = dirname(Base.source_path()) * "/table_counts.tsv"
	df = CSV.read(path, DataFrame, select=[2,3,4,5,6,7,8,9,10])
	for col in eachcol(df)
		print("Media\n")
		print(mean_and_std(col)[1])
		print("\nMediana\n")
		print(median(col))
		print("\nDesviacion estandar\n")
		print(mean_and_std(col)[2])
		print("\n")
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
	
	print("Media\n")
	print(mean)
	print("\nMediana\n")
	print(median_value)
	print("\nDesviacion estandar\n")
	print(std)
	print("\n")
	
	dt = time() - start


end

function calculate_by_row()
	
	start= time()
	path = dirname(Base.source_path()) * "/table_counts.tsv"
	df = CSV.read(path, DataFrame, select=[2,3,4,5,6,7,8,9,10])
	
	for n in 1:length(df[1])
		row = df[n, :]
		print("Media\n")
		print(mean_and_std(row)[1])
		print("\nMediana\n")
		print(median(row))
		print("\nDesviacion estandar\n")
		print(mean_and_std(row)[2])
		print("\n")
		
	end
	
	dt = time() - start


end

function calculate_pca()

	start= time()
	path = dirname(Base.source_path()) * "/E-GEOD-22954.csv"
	df = CSV.read(path, DataFrame)
	
	
	x = Matrix(df[2:floor(Int, nrow(df)/2), 2:end])'
	y = Matrix(df[floor(Int, nrow(df)/2)+1:end, 2:end])'
	
	
	M = fit(PCA, y; maxoutdim=2)
	Yte = predict(M, x)
	
	#p=scatter(Yte, marker=:circle, linewidth=0)
	display(plot(Yte, kind="bar"))
	
	dt = time() - start


end



#calculate_by_row()
#calculate_by_column()
#calculate_for_all_data()
calculate_pca()
