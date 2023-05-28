import csv
import pathlib
import numpy as np
from memory_profiler import memory_usage
import time
from time import process_time
from collections import defaultdict
import pandas
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
from matplotlib.colors import ListedColormap
from sklearn.datasets import load_iris
from sklearn import preprocessing
from sklearn import utils
import matplotlib.pyplot as plt
import os
import tracemalloc
from scipy.stats import ttest_ind


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

def calculate_by_row():
	
	start = time.time()
	cpu_start = process_time()
	
	path = str(pathlib.Path(__file__).parent.resolve()) + "/table_counts.tsv"
	with open(path) as f:
		f = csv.reader(f, delimiter='\t')
		next(f)
		for row in f:
			list_rows = row
			del list_rows[0]
			list_values = list(map(float, list_rows))
			write_output_txt("Python mean by row " + str(np.mean(list_values)) + "\n", "results_by_row.txt")
			write_output_txt("Python median by row " + str(np.median(list_values)) + "\n", "results_by_row.txt")
			write_output_txt("Python standard deviation by row " + str(np.std(list_values)) + "\n", "results_by_row.txt")
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	return results
	

def calculate_by_column():
	
	start = time.time()
	cpu_start = process_time()
	
	columns = defaultdict(list)
	path = str(pathlib.Path(__file__).parent.resolve()) + "/table_counts.tsv"
	with open(path) as f:
		reader = csv.DictReader(f, delimiter='\t') 
		for row in reader:
			for (k,v) in row.items(): 
				columns[k].append(v) 
		
	
	column1_float = list(map(float,columns['WholeOvary_Ctrl_Early_1']))
	column2_float = list(map(float,columns['WholeOvary_Ctrl_Early_2']))
	column3_float = list(map(float,columns['WholeOvary_Ctrl_Early_3']))
	column4_float = list(map(float,columns['WholeOvary_Ctrl_Late_1']))
	column5_float = list(map(float,columns['WholeOvary_Ctrl_Late_2']))
	column6_float = list(map(float,columns['WholeOvary_Ctrl_Late_3']))
	column7_float = list(map(float,columns['WholeOvary_Ctrl_Mid_1']))
	column8_float = list(map(float,columns['WholeOvary_Ctrl_Mid_2']))
	column9_float = list(map(float,columns['WholeOvary_Ctrl_Mid_3']))
	list_columns = [column1_float, column2_float, column3_float, column4_float, column5_float, column6_float, column7_float, column8_float, column9_float]
	for col in list_columns:
		write_output_txt("Python mean by column " + str(np.mean(col)) + "\n", "results_by_column.txt")
		write_output_txt("Python median by column " + str(np.median(col)) + "\n", "results_by_column.txt")
		write_output_txt("Python standard deviation by column " + str(np.std(col)) + "\n", "results_by_column.txt")
		
		
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	return results

def calculate_for_all_data():
	
	start = time.time()
	cpu_start = process_time()
	
	path = str(pathlib.Path(__file__).parent.resolve()) + "/table_counts.tsv"
	mean = 0
	median = 0
	std = 0
	with open(path) as f:
		f = csv.reader(f, delimiter='\t')
		next(f)
		for row in f:
			list_rows = row
			del list_rows[0]
			list_values = list(map(float, list_rows))
			mean = mean + np.mean(list_values)
			median = median + np.median(list_values)
			std = std+ np.std(list_values)
	
	write_output_txt("Python mean all " + str(mean) + "\n", "results_all.txt")
	write_output_txt("Python median all " + str(median) + "\n", "results_all.txt")
	write_output_txt("Python standard deviation all " + str(std) + "\n", "results_all.txt")
	
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	return results
	


def calculate_ttest():
	start = time.time()
	cpu_start = process_time()
	
	path = str(pathlib.Path(__file__).parent.resolve()) + "/table_counts.tsv"
	columns = defaultdict(list)
	with open(path) as f:
		reader = csv.DictReader(f, delimiter='\t') 
		for row in reader:
			for (k,v) in row.items(): 
				columns[k].append(v) 
		
	
	column1_float = list(map(float,columns['WholeOvary_Ctrl_Early_1']))
	column2_float = list(map(float,columns['WholeOvary_Ctrl_Early_2']))
	column3_float = list(map(float,columns['WholeOvary_Ctrl_Early_3']))
	column4_float = list(map(float,columns['WholeOvary_Ctrl_Late_1']))
	column5_float = list(map(float,columns['WholeOvary_Ctrl_Late_2']))
	column6_float = list(map(float,columns['WholeOvary_Ctrl_Late_3']))
	
	list_early = column1_float + column2_float + column3_float
	list_late = column4_float + column5_float + column6_float
	
	t_stat, p_value = ttest_ind(list_early, list_late)
	
	
	write_output_txt("Python t test" + str(p_value) + "\n", "results_ttest.txt")
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	return results


def get_benchmarks():

	print("Calculando por fila\n")
	results_database = calculate_by_row()
	tracemalloc.start()
	calculate_by_row()
	memory_database = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_database, results_database[0], results_database[1]]
	write_results(data, 'results_by_row.csv')
	
	print("Calculando por columna\n")	
	results_alignment = calculate_by_column()
	tracemalloc.start()
	calculate_by_column()
	memory_alignment = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_alignment, results_alignment[0], results_alignment[1]]
	write_results(data, 'results_by_column.csv')
	
	

	print("Calculando para toda la tabla\n")	
	results_rev_comp = calculate_for_all_data()
	tracemalloc.start()
	calculate_for_all_data()
	memory_rev_comp = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_rev_comp, results_rev_comp[0], results_rev_comp[1]]
	write_results(data, 'results_all.csv')
	

	
	
	print("Calculando t test\n")	
	results_ttest = calculate_ttest()
	tracemalloc.start()
	calculate_ttest()
	memory_ttest = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_ttest, results_ttest[0], results_ttest[1]]
	write_results(data, 'results_ttest.csv')
	


get_benchmarks()
