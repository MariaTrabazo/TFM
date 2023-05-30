using CSV
using CPUTime
using DataFrames
using StatsBase
using MultivariateStats
using RDatasets
using BenchmarkTools 
using Plots
using HypothesisTests
using Statistics
using GLM
using Flux, CUDA
using Flux: train!, onehotbatch
using Images
using Flux.Data.MNIST
     




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

function linear_regression()
	
	start= time()
	path = dirname(Base.source_path()) * "/E-GEOD-22954.csv"
	df = CSV.read(path, DataFrame, delim=',')
	
	a = Float64[]
	b = Float64[]
	for n in 1:round(Int, nrow(df)/2)
		row = df[n, 2:end]
		for i in row
			push!(a, i)
		end
	end
	
	for m in round(Int, nrow(df)/2)+1:nrow(df)
		row = df[m, 2:end]
		for j in row
			push!(b, j)
		end
	end
	
	
	data2 = DataFrame(x=a, y=b)
	model = lm(@formula(y ~ x), data2)

	y_pred = predict(model, DataFrame(x=a))
	
	
	write_output_txt("\nJulia coeficientes " *string(coef(model))*"\n", "results_reg_lin.txt")
	write_output_txt("\nJulia intercept " *string(coef(model)[1])*"\n", "results_reg_lin.txt")
	write_output_txt("\nJulia valores predichos " *string(y_pred)*"\n", "results_reg_lin.txt")
	

	
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


function loss(model, x, y)
	return Flux.crossentropy(model(x),Flux.onehotbatch(y,0:9))
end



function create_batch(r, images, labels)
    xs = [vec(Float64.(img)) for img in images[r]]
    ys = [Flux.onehot(labels, 0:9) for labels in labels[r]]
    return (Flux.batch(xs), Flux.batch(ys))
end
     


function recognise_numbers()
	
	start= time()
	
	#=
	IMPLAMENTACION 1
	
	images = MNIST.images();
	labels = MNIST.labels();
	n_inputs = unique(length.(images))[]
	n_outputs = length(unique(labels))
	
	trainbatch = create_batch(1:5000, images, labels)
	model = Chain(Dense(n_inputs, n_outputs, identity), softmax)
    loss(x,y) = Flux.crossentropy(model(x),y)
    opt = ADAM()
    
    for i in 1:10
		Flux.train!(loss, Flux.params(model), [trainbatch], opt)
	end
    =#

     #=
     IMPLEMENTACION 2
     
	x_train, y_train = MLDatasets.MNIST.traindata()
	x_test, y_test = MLDatasets.MNIST.testdata()
	x_train = Float32.(x_train)
	y_train = Flux.onehotbatch(y_train, 0:9)


	model = Chain(Dense(784, 256, relu),Dense(256, 10, relu), softmax)

	loss(x, y) = Flux.Losses.logitcrossentropy(model(x), y)

	optimizer = ADAM()

	parameters = Flux.params(model)
	train_data = [(Flux.flatten(x_train), Flux.flatten(y_train))]
	
	for i in 1:400
		Flux.train!(loss, parameters, train_data, optimizer)
	end
	
	test_data = [(Flux.flatten(x_test), y_test)]
	accuracy = 0
	for i in 1:length(y_test)
		if findmax(model(test_data[1][1][:, i]))[2] - 1  == y_test[i]
		    accuracy = accuracy + 1
		end
	end
	println(accuracy / length(y_test))
    =#
	
	dt = time() - start


end



function get_benchmarks()


    result_bm_database = @benchmark linear_regression()
    time_database =  linear_regression()
    @CPUtime linear_regression()
    df_database = DataFrame(language = "Julia", memory = result_bm_database.memory * 0.00000095367431640625, time = time_database, cpu_time = 1)
    write_results(df_database, "results_linear_regression.csv")
    
    result_bm_coordinates= @benchmark calculate_pca()
    time_coordinates = calculate_pca()
    @CPUtime calculate_pca
    df_coordinates = DataFrame(language = ["Julia"], memory = result_bm_coordinates.memory * 0.00000095367431640625, time = time_coordinates, cpu_time = 1)
    write_results(df_coordinates, "results_pca.csv")


    
end


recognise_numbers()
#get_benchmarks()
