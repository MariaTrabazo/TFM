import csv
import pathlib
import numpy as np
from memory_profiler import memory_usage
import time
from time import process_time
import pandas
import os
import tracemalloc
from sklearn.linear_model import LinearRegression


def write_results(data, file):
	path = str(pathlib.Path(__file__).parent.resolve()) + "/results/" + file

	header = ['language', 'memory(MiB)', 'time(s)', 'CPU_time(s)']
	mode = 'a'
	if os.path.exists(path):
		mode = 'a'
	else:
		mode = 'x'
		
	
	with open(path, mode) as f:
		writer = csv.writer(f, delimiter= ' ')
		writer.writerow(header)
		writer.writerow(data)
		
		
def write_output_txt(data, file):
	path = str(pathlib.Path(__file__).parent.resolve()) + "/results/" + file
	
	mode = 'a'
	if os.path.exists(path):
		mode = 'a'
	else:
		mode = 'x'
		
	
	with open(path, mode) as f:
		f.write(data)
		f.close()

def linear_regression():
    
	start = time.time()
	cpu_start = process_time()
	
	path = str(pathlib.Path(__file__).parent.resolve()) + "/table_counts.tsv"
	df = pandas.read_csv(path, delimiter = '\t')
	a = df.iloc[0:round(len(df.index)/2), 1:len(df.columns)].values
	b = df.iloc[round(len(df.index)/2)+1:len(df.index), 1:len(df.columns)].values
	x = np.array(a).ravel()
	y = np.array(b).ravel()
	
	
	x = np.array(x).reshape(-1, 1)
	y = np.array(y)

    
	model = LinearRegression()
	model.fit(x, y)
	y_pred = model.predict(x)
    
	
	write_output_txt("Python coeficientes " + str(model.coef_) + "\n", "results_reg_lin.txt")
	write_output_txt("Python intercept " + str(model.intercept_) + "\n", "results_reg_lin.txt")
	write_output_txt("Python valores predichos " + str(y_pred) + "\n", "results_reg_lin.txt")
    
    
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	return results



def get_benchmarks():

	print("Calculando regresion lineal\n")
	results_database = linear_regression()
	tracemalloc.start()
	linear_regression()
	memory_database = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_database, results_database[0], results_database[1]]
	write_results(data, 'results_linear_regression.csv')
	
	
	



get_benchmarks()
