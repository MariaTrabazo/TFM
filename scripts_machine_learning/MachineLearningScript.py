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
from sklearn.linear_model import LinearRegression
import tensorflow as tf
from tensorflow import keras


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
	
	path = str(pathlib.Path(__file__).parent.resolve()) + "/E-GEOD-22954.csv"
	df = pandas.read_csv(path, delimiter = ',')
	a = df.iloc[0:round(len(df.index)/2), 1:len(df.columns)].values
	b = df.iloc[round(len(df.index)/2):len(df.index), 1:len(df.columns)].values
	
	
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
	

def calculate_pca():
	
	start = time.time()
	cpu_start = process_time()
	
	path = str(pathlib.Path(__file__).parent.resolve()) + "/E-GEOD-22954.csv"
	df = pandas.read_csv(path, delimiter = ',')
	x = df.iloc[:, 1:len(df.columns)].values
	y = df.iloc[:, 0].values 
	
	#sc = StandardScaler()
 
	#x = sc.fit_transform(x)
	
	pca = PCA(n_components = 2)
	principalComponents = pca.fit_transform(x)
	principalDf = pandas.DataFrame(data = principalComponents, columns=['PC1', 'PC2'])
	write_output_txt("Python pca" + str(principalDf) + "\n", "results_pca.txt")
	
	
	plt.scatter(data=principalDf, x="PC1", y="PC2")
	plt.savefig('results/python_plot.png')
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	results = [end-start, cpu_diff]
	return results

def recognise_numbers():
    
	start = time.time()
	cpu_start = process_time()
	
	(train_x, train_y), (test_x, test_y) = keras.datasets.mnist.load_data()
	
	train_x = train_x.astype('float32') / 255.0
	test_x = test_x.astype('float32') / 255.0

	train_y = keras.utils.to_categorical(train_y)
	test_y = keras.utils.to_categorical(test_y)
	
	model = keras.models.Sequential([
    keras.layers.Conv2D(32, (3, 3), activation='relu', input_shape=(28, 28, 1)),
    keras.layers.MaxPooling2D((2, 2)),
    keras.layers.Conv2D(64, (3, 3), activation='relu'),
    keras.layers.MaxPooling2D((2, 2)),
    keras.layers.Flatten(),
    keras.layers.Dense(64, activation='relu'),
    keras.layers.Dense(10, activation='softmax')
	])
	
	model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
	model.fit(train_x, train_y, epochs=10, batch_size=32)
	
	test_loss, test_acc = model.evaluate(test_x, test_y)
	#print("Test accuracy:", test_acc)
	
	predictions = model.predict(test_x)
	predicted_labels = np.argmax(predictions, axis=1)
	#print("Predictions:", predicted_labels)

	write_output_txt("Python predictions " + str(predicted_labels) + "\n", "results_handwritten_numbers.txt")
	write_output_txt("Python accuracy " + str(test_acc) + "\n", "results_handwritten_numbers.txt")


    
	
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
	
	print("Obteniendo PCA\n")	
	results_coordinates = calculate_pca()
	tracemalloc.start()
	calculate_pca()
	memory_coordinates = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_coordinates, results_coordinates[0], results_coordinates[1]]
	write_results(data, 'results_pca.csv')
	
	print("Calculando reconocimiento de numeros\n")
	results_numbers = recognise_numbers()
	tracemalloc.start()
	recognise_numbers()
	memory_numbers = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_numbers, results_numbers[0], results_numbers[1]]
	write_results(data, 'results_handwritten_numbers.csv')
	
	
	


get_benchmarks()
