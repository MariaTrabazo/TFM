import csv
import pathlib
import numpy as np
from memory_profiler import memory_usage
import time
from time import process_time
from collections import defaultdict


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
			print("Media")
			print(np.mean(list_values))
			print("Mediana")
			print(np.median(list_values))
			print("Desviacion estandar")
			print(np.std(list_values))
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	

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
		print("Media")
		print(np.mean(col))
		print("Mediana")
		print(np.median(col))
		print("Desviacion estandar")
		print(np.std(col))
		
		
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]

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
	
	print("Media")
	print(mean)
	print("Mediana")
	print(median)
	print("Desviacion estandar")
	print(std)
	
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
			
calculate_by_row()
calculate_by_column()
calculate_for_all_data()
	
