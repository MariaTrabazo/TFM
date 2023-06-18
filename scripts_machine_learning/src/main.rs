#![allow(unused)]

use std::env::{current_dir};
use std::time::Duration;
use cpu_time::ProcessTime;
use std::time::Instant;
use std::path::{PathBuf};
use std::error::Error;
use csv::ReaderBuilder;
use statistical::mean;
use statistical::median;
use statistical::standard_deviation;
use ndarray::{Array2, ArrayView2};
use plotters::prelude::*;
use std::fs::File;
use std::env;
use array2d::Array2D;
use linfa::traits::{Fit, Predict};
use ndarray::arr2;
//use petal_decomposition::Pca;
use linfa_reduction::Pca;
use std::fs::OpenOptions;
use std::io;
use std::io::Write;
use statest::ttest::*;
use ndarray::{Array, Array3, ArrayView, Axis, stack};
use vecshard::ShardExt;
use linear_regression::{linear_regression, predict};
use scripts_machine_learning::{Evaluator, Observation, read_observations};
use simple_stopwatch::Stopwatch;
use ndarray_linalg::SVD;

fn main() {
   
  
  get_benchmarks();
}

//se escriben los resultados de memoria, tiempo de ejecución y tiempo de CPU
fn write_results(time: f64, cpu_time: f64, file: &str){

    
    let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("results");
    current_path.push(file);

    
    let mut data_file = OpenOptions::new()
        .append(true)
        .open(current_path)
        .unwrap();

  
    let mut wtr = csv::WriterBuilder::new()
        .delimiter(b' ')
        .from_writer(data_file);
    wtr.serialize(("Rust", "", time, cpu_time));
    wtr.flush();
    
}

//se escriben los resultados de cada una de las funciones
fn write_output_txt(data: &str, file: &str){

    
    let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("results");
    current_path.push(file);

    
    let mut data_file = OpenOptions::new()
        .append(true)
        .open(current_path)
        .unwrap();
    
    data_file.write(data.as_bytes());
}

//se calcula el modelo de regresion lineal
fn linear_regression_function() -> Vec<f64> {

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
	let string_path = &current_dir().unwrap();
	let mut current_path= PathBuf::new();
	current_path.push(string_path);
	current_path.push("E-GEOD-22954.csv");

	let mut reader =  ReaderBuilder::new().from_path(current_path).unwrap();
    let mut row = vec![];
    for result in reader.records() {
       
        let record =result.unwrap();
        for i in &record{
        	if !!!i.starts_with("G"){
        		row.push(i.to_string().parse::<f32>().unwrap());
        	}
        
        }
        
   	}
    
    let pairs: Vec<(f32, f32)> = row
        .chunks(2)
        .map(|chunk| {
            let (first, second) = match chunk {
                &[x, y] => (x, y),
                &[x] => (x, 0.0),
                _ => panic!("Invalid chunk size"),
            };
            (first, second)
        })
        .collect();

    
    let eq = linear_regression(&pairs);
    
    
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
    
}

//implementacion base que no funciona
/*fn calculate_pca() -> Vec<f64> {

	let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
	let dataset = linfa_datasets::iris();

	
	let embedding = Pca::params(1) //error en esta linea
		.fit(&dataset).unwrap();


	let dataset = embedding.predict(dataset);
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
	

}*/


//modelo de reconocimientos de numeros a partir de imagenes
fn recognise_numbers() -> Vec<f64> {

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  


    let training_path = "trainingsample.csv";
    let training_set: Vec<Observation> = read_observations(training_path);
    
    let validation_path = "validationsample.csv";
    let validation_set: Vec<Observation> = read_observations(validation_path);

    let evaluator = Evaluator::new(&training_set);
    let percent_correct = 100.0 * evaluator.percent_correct(&validation_set);
    let percent_correct = format!("{percent_correct:.2}%");

   
    write_output_txt("Rust accuracy ", "results_handwritten_numbers.txt");
    write_output_txt(&percent_correct, "results_handwritten_numbers.txt");
    write_output_txt("\n", "results_handwritten_numbers.txt");

	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
    
}

//se realiza la llamada secuencial de todas las funciones
fn get_benchmarks(){

	println!("Calculando regresion lineal\n");
	let result_database = linear_regression_function();
	let data_database= &result_database;
	write_results(data_database[0], data_database[1], "results_linear_regression.csv");
	
	println!("Calculando reconocimiento de numeros\n");
	let result_numbers = recognise_numbers();
	let data_numbers= &result_numbers;
	write_results(data_numbers[0], data_numbers[1], "results_handwritten_numbers.csv");
    
    
}


