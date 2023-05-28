import pathlib
import pandas as pd



path = str(pathlib.Path(__file__).parent.resolve()) + "/results/julia_output.txt"
data_file = open(path, 'r')
lines = data_file.readlines()
time_values = []
for line in lines:
	time_values.append(float(line.split(" ")[3]))

path2 = str(pathlib.Path(__file__).parent.resolve()) + "/results/results_by_row.csv"
df = pd.read_csv(path2, delimiter= ' ')
df.at[3, 'CPU_time(s)'] = time_values[0]
df.to_csv(path2, index=False, sep=' ')

path3 = str(pathlib.Path(__file__).parent.resolve()) + "/results/results_by_column.csv"
df = pd.read_csv(path3, delimiter= ' ')
df.at[3, 'CPU_time(s)'] = time_values[1]
df.to_csv(path3, index=False, sep= ' ')

path4 = str(pathlib.Path(__file__).parent.resolve()) + "/results/results_all.csv"
df = pd.read_csv(path4, delimiter= ' ')
df.at[3, 'CPU_time(s)'] = time_values[2]
df.to_csv(path4, index=False, sep= ' ')

path5 = str(pathlib.Path(__file__).parent.resolve()) + "/results/results_ttest.csv"
df = pd.read_csv(path5, delimiter= ' ')
df.at[3, 'CPU_time(s)'] = time_values[3]
df.to_csv(path5, index=False, sep= ' ')



