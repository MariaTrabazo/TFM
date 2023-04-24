# coding=utf-8

from Bio import Align
from Bio import AlignIO
from Bio import SeqIO
from Bio.SeqFeature import SeqFeature, SimpleLocation
from Bio.Seq import Seq
from Bio import Entrez
from memory_profiler import memory_usage
import time
from time import process_time
import pathlib
import re
import csv
import tracemalloc
import os

def open_fasta_file(input_file):
	path = str(pathlib.Path(__file__).parent.resolve()) + "/results/" + input_file
	sequences = []
    #se lee el fichero en formato fasta con las secuencias, que se almacenan en la lista sequences
	for seq_record in SeqIO.parse(path, "fasta"):
		sequences.append(str(seq_record.seq))
	return sequences

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
	
	
def get_sequences_from_database():
	start = time.time()
	cpu_start = process_time()
	handle = Entrez.esearch(db='nucleotide', term = ["Poaceae[Orgn] AND als[Gene]"])
	record = Entrez.read(handle)
	handle.close()

	ids = record["IdList"]
    
	mode = 'a'
	if os.path.exists(str(pathlib.Path(__file__).parent.resolve()) + '/results/sequence_list_python.fasta'):
		mode = 'a'
	else:
		mode = 'x'
	file = open(str(pathlib.Path(__file__).parent.resolve()) + '/results/sequence_list_python.fasta', mode)
	for seq_id in ids:
		handle = Entrez.efetch(db="nucleotide", id=str(seq_id), rettype="fasta", retmode="text")
		record2 = handle.readlines()
		for item in record2:
            #print(item)
			file.write(item)
    
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start       
	end = time.time()
	time_value = "\nGetting sequence from db time: " + str(end-start)
	#print(time_value)
	#write_results(time_value, "\n", "results.txt")
	results = [end-start, cpu_diff]
	return results
   
def align_two_sequences():
	start = time.time()
	cpu_start = process_time()
	list_sequences = open_fasta_file("sequence_list_python.fasta")
	align = Align.PairwiseAligner() #esta clase representa un alineamiento de secuencias por pares
	align.mode = 'global' #se indica el tipo de alineamiento, en este caso, global, para encontrar la mejor concordancia entre las dos secuencias completas
    #se asignan puntuaciones en base a las coincidencias y huecos entre las secuencias
	align.match_score = 20 
	align.mismatch_score = -10
	align.open_gap_score = -5
	align.extend_gap_score = -1
    #se realiza el alineamiento y para cada alineamiento se imprime el resultado y la puntuación calculada
	alignments=align.align(list_sequences[0], list_sequences[1])
    #for alignment in align.align(list_sequences[0], list_sequences[1]):
        #print(alignment)
    
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start    
	end = time.time()
    #print("Score = %.f " % alignments.score)
	#print("Alignment time: ", str(end-start)) #se obtiene el tiempo del alineamiento
	value_time = "\nSequence alignment time: "+ str(end-start)
	score = "\nPython alignment score: " + str(alignments.score) + "\n"
    
	write_output_txt( score, "results_alignment.txt")
	results = [end-start, cpu_diff]
	return results


def get_complementary_reverse_sequence():
	start = time.time()
	cpu_start = process_time()
	list_sequences = open_fasta_file("sequence_list_python.fasta")
	seq = Seq(list_sequences[2])
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start
	end = time.time()
	time_value = "\nComplementary-reverse time: " + str(end-start)
	write_output_txt("Python reverse complementary " + str(seq.reverse_complement()) + "\n", "results_rev_comp.txt")
	results = [end-start, cpu_diff]
	return results



def get_sequence_from_coordinates():
	start = time.time()
	cpu_start = process_time()
	path = str(pathlib.Path(__file__).parent.resolve()) + "/results/sequence_list_python.fasta"
	write_output_txt("\nPython sequences from coordinates\n", "results_coordinates.txt")
	for seq_record in SeqIO.parse(path, "fasta"):
		seq = Seq(seq_record.seq)
		feature = SeqFeature(SimpleLocation(5, 100, strand=-1), type="gene")
		feature_seq = seq[feature.location.start : feature.location.end]
		write_output_txt(str(feature_seq) + "\n", "results_coordinates.txt")
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start
	end = time.time() 
	results = [end-start, cpu_diff]
	return results

def match_subsequence():
	start = time.time()
	cpu_start = process_time()

	list_sequence = ["CCC", "GAACAT", "ATCCCAA"]
	matches=0
	path = str(pathlib.Path(__file__).parent.resolve()) + "/partial_hg38.fa"
	write_output_txt("\nPython subsequences matches\n", "results_match.txt")
	for sequence in list_sequence:
		matches =0
		for seq_record in SeqIO.parse(path, "fasta"):
            
			res = [i.start() for i in re.finditer(sequence, str(seq_record.seq))]
			matches = matches +len(res)
		write_output_txt("Matches: " + str(matches)+ "\n","results_match.txt")
	
	cpu_end = process_time()
	cpu_diff = cpu_end - cpu_start
	end = time.time()
	results = [end-start, cpu_diff]
	return results

def get_benchmarks():

	print("Obteniendo las secuencias de NCBI\n")
	results_database = get_sequences_from_database()
	tracemalloc.start()
	get_sequences_from_database()
	memory_database = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_database, results_database[0], results_database[1]]
	write_results(data, 'results_database.csv')
	

	print("Realizando el alineamiento\n")	
	results_alignment = align_two_sequences()
	tracemalloc.start()
	align_two_sequences()
	memory_alignment = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_alignment, results_alignment[0], results_alignment[1]]
	write_results(data, 'results_alignment.csv')
	
	

	print("Obteniendo la reversa complementaria\n")	
	results_rev_comp = get_complementary_reverse_sequence()
	tracemalloc.start()
	get_complementary_reverse_sequence()
	memory_rev_comp = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_rev_comp, results_rev_comp[0], results_rev_comp[1]]
	write_results(data, 'results_rev_comp.csv')
	

	print("Obteniendo secuencias a partir de coordenadas\n")	
	results_coordinates = get_sequence_from_coordinates()
	tracemalloc.start()
	get_sequence_from_coordinates()
	memory_coordinates = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_coordinates, results_coordinates[0], results_coordinates[1]]
	write_results(data, 'results_coordinates.csv')

	print("Buscando el número de coincidencias para tres subsecuencias\n")	
	results_match = match_subsequence()
	tracemalloc.start()
	match_subsequence()
	memory_match = (tracemalloc.get_traced_memory()[1] / 1024)*0.000976563
	tracemalloc.stop()
	data = ['Python', memory_match, results_match[0], results_match[1]]
	write_results(data, 'results_match_subsequence.csv')



get_benchmarks()
