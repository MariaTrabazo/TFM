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
use plotters::prelude::*;
use std::fs::File;
use std::env;
use array2d::Array2D;
use linfa::traits::{Fit, Predict};
use ndarray::arr2;
use std::fs::OpenOptions;
use std::io;
use std::io::Write;
use statest::ttest::*;

extern crate ndarray;
extern crate ndarray_linalg;
extern crate ndarray_rand;

use ndarray::{Array, Array2, Axis, stack};
use ndarray_linalg::{Eigh};
use crate::ndarray_linalg::Eig;
use ndarray_rand::rand::Rng;


fn main() {
   
   get_benchmarks();
}

fn write_results(time: f64, cpu_time: f64, file: &str){

    
    let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("results");
    current_path.push(file);

    // Open a file with append option
    let mut data_file = OpenOptions::new()
        .append(true)
        .open(current_path)
        .unwrap();

    // Write to a file
    //let mut wtr = csv::Writer::from_writer(data_file);
    let mut wtr = csv::WriterBuilder::new()
        .delimiter(b' ')
        .from_writer(data_file);
    wtr.serialize(("Rust", "", time, cpu_time));
    wtr.flush();
    
    //data_file
        //.write("Rust 2".as_bytes())
        //.expect("write failed");
}

fn write_output_txt(data: &str, file: &str){

    
    let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("results");
    current_path.push(file);

    // Open a file with append option
    let mut data_file = OpenOptions::new()
        .append(true)
        .open(current_path)
        .unwrap();

    // Write to a file
    
    data_file.write(data.as_bytes());
}

fn calculate_by_row() -> Vec<f64> {

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
  	let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().from_path(current_path).unwrap();
    let mut row = vec![];
    for result in reader.records() {
       
       	
        let record =result.unwrap();
        let parts = record.as_slice().split("\t");
        for part in parts{
        	if !!!part.starts_with("F"){
        		row.push(part.to_string().parse::<f32>().unwrap());
        	}
        	
        }
        
   }
   
   let mut iter_array = row.chunks(9);
       	for i in iter_array{
       		let mean_value = mean(i);
       		let median_value = median(i);
       		let std_value = standard_deviation(i, Some(mean_value));
       		write_output_txt("\nRust mean by row: \n", "results_by_row.txt");
       		write_output_txt(&mean_value.to_string(), "results_by_row.txt");
       		write_output_txt("\nRust median by row: \n", "results_by_row.txt");
       		write_output_txt(&median_value.to_string(), "results_by_row.txt");
       		write_output_txt("\nRust standard deviation by row: \n", "results_by_row.txt");
       		write_output_txt(&std_value.to_string(), "results_by_row.txt");
    		
		}
   
   
  
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	//Ok(array);
	return array;
    
}

fn calculate_by_column() -> Vec<f64>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
  	let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().delimiter(b'\t').from_path(current_path).unwrap();
    let mut row1 = vec![];
    let mut row2 = vec![];
    let mut row3 = vec![];
    let mut row4 = vec![];
    let mut row5 = vec![];
    let mut row6 = vec![];
    let mut row7 = vec![];
    let mut row8 = vec![];
    let mut row9 = vec![];
    for result in reader.records() {
       
       	let record =result.unwrap();
       	for i in record.get(1){
       		row1.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(2){
       		row2.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(3){
       		row3.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(4){
       		row4.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(5){
       		row5.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(6){
       		row6.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(7){
       		row7.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(8){
       		row8.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(9){
       		row9.push(i.to_string().parse::<f32>().unwrap());
       	}
      	
      	
       
   }
   	
	let mean_value = mean(&row1);
	let median_value = median(&row1);
	let std_value = standard_deviation(&row1, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row2);
	let median_value = median(&row2);
	let std_value = standard_deviation(&row2, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row3);
	let median_value = median(&row3);
	let std_value = standard_deviation(&row3, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row4);
	let median_value = median(&row4);
	let std_value = standard_deviation(&row4, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row5);
	let median_value = median(&row5);
	let std_value = standard_deviation(&row5, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row6);
	let median_value = median(&row6);
	let std_value = standard_deviation(&row6, Some(mean_value));write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
		
	
	let mean_value = mean(&row7);
	let median_value = median(&row7);
	let std_value = standard_deviation(&row7, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row8);
	let median_value = median(&row8);
	let std_value = standard_deviation(&row8, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");
	
	
	let mean_value = mean(&row9);
	let median_value = median(&row9);
	let std_value = standard_deviation(&row9, Some(mean_value));
	write_output_txt("\nRust mean by column: \n", "results_by_column.txt");
	write_output_txt(&mean_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust median by column: \n", "results_by_column.txt");
	write_output_txt(&median_value.to_string(), "results_by_column.txt");
	write_output_txt("\nRust standard deviation by column: \n", "results_by_column.txt");
	write_output_txt(&std_value.to_string(), "results_by_column.txt");

  	
  
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
    
}

fn calculate_for_all_data() -> Vec<f64>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
  	let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().delimiter(b'\t').from_path(current_path).unwrap();
    let mut row1 = vec![];
    let mut row2 = vec![];
    let mut row3 = vec![];
    let mut row4 = vec![];
    let mut row5 = vec![];
    let mut row6 = vec![];
    let mut row7 = vec![];
    let mut row8 = vec![];
    let mut row9 = vec![];
    for result in reader.records() {
       
       	let record =result.unwrap();
       	for i in record.get(1){
       		row1.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(2){
       		row2.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(3){
       		row3.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(4){
       		row4.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(5){
       		row5.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(6){
       		row6.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(7){
       		row7.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(8){
       		row8.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(9){
       		row9.push(i.to_string().parse::<f32>().unwrap());
       	}
      	
      	
       
   }
	
	let mean_value = mean(&row1) + mean(&row2) + mean(&row3) + mean(&row4) +mean(&row5) + mean(&row6) + mean(&row7) + mean(&row8) + mean(&row9);
	let median_value = median(&row1) + median(&row2) + median(&row3) + median(&row4) + median(&row5) + median(&row6) + median(&row7) + median(&row8) + median(&row9);
	let std_value = standard_deviation(&row1, Some(mean(&row1))) + standard_deviation(&row2, Some(mean(&row2))) + standard_deviation(&row3, Some(mean(&row3))) + standard_deviation(&row4, Some(mean(&row4))) + standard_deviation(&row5, Some(mean(&row5))) + standard_deviation(&row6, Some(mean(&row6))) + standard_deviation(&row7, Some(mean(&row7))) + standard_deviation(&row8, Some(mean(&row8))) + standard_deviation(&row9, Some(mean(&row9)));
	write_output_txt("\nRust mean all: \n", "results_all.txt");
	write_output_txt(&mean_value.to_string(), "results_all.txt");
	write_output_txt("\nRust median all: \n", "results_all.txt");
	write_output_txt(&median_value.to_string(), "results_all.txt");
	write_output_txt("\nRust standard deviation all: \n", "results_all.txt");
	write_output_txt(&std_value.to_string(), "results_all.txt");

  	
  
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
    
}




fn calculate_ttest() -> Vec<f64> {

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
    
    
    let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().delimiter(b'\t').from_path(current_path).unwrap();
    let mut col1 = vec![];
    let mut col2 = vec![];
    let mut col3 = vec![];
    let mut col4 = vec![];
    let mut col5 = vec![];
    let mut col6 = vec![];
    for result in reader.records() {
       
       	let record =result.unwrap();
       	for i in record.get(1){
       		col1.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(2){
       		col2.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(3){
       		col3.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(4){
       		col4.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(5){
       		col5.push(i.to_string().parse::<f32>().unwrap());
       	}
       	for i in record.get(6){
       		col6.push(i.to_string().parse::<f32>().unwrap());
       	}  	
       
   }
	
	let mut list_early = vec![];
	list_early.append(&mut col1);
	list_early.append(&mut col2);
	list_early.append(&mut col3);
	
	let mut list_late = vec![];
	list_late.append(&mut col4);
	list_late.append(&mut col5);
	list_late.append(&mut col6);
	
	
    let ttest_early = list_early.ttest1(102.0, 0.05, Side::One(UPLO::Upper)); 
    let ttest_late = list_late.ttest1(102.0, 0.05, Side::One(UPLO::Upper)); 
   
   	write_output_txt("\nRust ttest early: \n", "results_ttest.txt");
   	write_output_txt(&ttest_early.to_string(), "results_ttest.txt");
	write_output_txt("\nRust ttest late: \n", "results_ttest.txt");
   	write_output_txt(&ttest_late.to_string(), "results_ttest.txt");
  
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
    
}

fn get_benchmarks(){

	println!("Calculando por fila\n");
	let result_database = calculate_by_row();
	let data_database= &result_database;
	write_results(data_database[0], data_database[1], "results_by_row.csv");

	println!("Calculando por columna\n");
    let result_alignment = calculate_by_column();
    let data_alignment= &result_alignment;
	write_results(data_alignment[0], data_alignment[1], "results_by_column.csv");
    
    println!("Calculando para toda la tabla\n");
	let result_rev_comp = calculate_for_all_data();
	let data_rev_comp= &result_rev_comp;
	write_results(data_rev_comp[0], data_rev_comp[1], "results_all.csv");
	
	println!("Calculando ttest\n");
	let result_ttest = calculate_ttest();
	let data_ttest= &result_ttest;
	write_results(data_ttest[0], data_ttest[1], "results_ttest.csv");
    
    
}


