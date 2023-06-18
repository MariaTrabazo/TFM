#![allow(unused)]

use entrez_rs::eutils::{Eutils, ESearch, EFetch, DB};
use entrez_rs::parser::esearch::{ESearchResult};
use entrez_rs::parser::pubmed::{PubmedArticleSet};
use entrez_rs::errors::Error;
use bio::io::fasta;
use bio_types::alignment::{Alignment,AlignmentMode};
use bio_types::alignment::AlignmentOperation::{Match, Subst, Ins, Del};
use std::env::{current_dir};
use std::path::{PathBuf};
use std::string::String;
use std::fs::OpenOptions;
use std::io;
use std::io::Write;
use std::time::Instant;
use std::thread::current;
use bio_seq::prelude::*;
use bio::alignment::pairwise::*;
use std::time::Duration;
use cpu_time::ProcessTime;

fn main() {
      
    get_benchmarks();
}


//se lee el fichero en formato fasta
fn read_fasta(folder: &str, file: &str)->Vec<String>  {

    let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push(folder);
    current_path.push(file);
    
    let mut array= vec![];
    let reader = fasta::Reader::from_file(&current_path.as_path()).unwrap();
    for result in reader.records() {
        let record = result.unwrap();
        
        let sequence = record.seq();
        let sequence_str = String::from_utf8_lossy(sequence).to_string();
        
        array.push(sequence_str);
    }

    return array;

    
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

//se descargan las secuencias de la base de datos
fn get_sequences_from_database() -> Result<Vec<f64> , Error>  {
    
    let start = Instant::now();
    let start_cpu = ProcessTime::now();
    let xml = ESearch::new(
        DB::Pubmed, 
        "eclampsia")
        .run()?;

    let parsed = ESearchResult::read(&xml);

    
    
    let pm_xml = EFetch::new(
          DB::Pubmed,
          vec!["33246200", "33243171"])
          .run()?;
    
    let pm_parsed = PubmedArticleSet::read(&pm_xml);
	
    //println!("{:?}", pm_parsed?.articles);
    let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
    Ok(array)
}


//se realiza el alineamiento de secuencias  
fn align_two_sequences()-> Vec<f64>{
    
    let start = Instant::now();
    let start_cpu = ProcessTime::now();
    let sequence_list = read_fasta("results", "sequence_list_python.fasta");
    
    let sequence1 = &sequence_list[0];
    let sequence2 = &sequence_list[1];
    let scoring = Scoring::from_scores(-5, -1, 20, -10) 
    .xclip(MIN_SCORE) 
    .yclip(MIN_SCORE);   

    let mut aligner = Aligner::with_capacity_and_scoring(sequence1.len(), sequence2.len(), scoring);
    let alignment = aligner.custom(sequence1.as_bytes(), sequence2.as_bytes());
    write_output_txt("\nRust alignment score: \n", "results_alignment.txt");
    write_output_txt(&alignment.score.to_string(), "results_alignment.txt");
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
}

//se obtiene la reversa complementaria
fn get_complementary_reverse_sequence()->Vec<f64>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();

    let sequence_list = read_fasta("results", "sequence_list_python.fasta");
    let sequence = dna!(&sequence_list[2]);
    let reverse_complementary =sequence.revcomp();
    write_output_txt("\nRust reverse complementary\n", "results_rev_comp.txt");
    write_output_txt(&reverse_complementary.to_string(), "results_rev_comp.txt");
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;

}

//se obtienen las secuencias según sus coordenadas
fn get_sequence_from_coordinates()->Vec<f64>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();

    let sequence_list = read_fasta("results", "sequence_list_python.fasta");
    write_output_txt("\nRust sequences from coordinates\n", "results_coordinates.txt");
    for sequence in sequence_list{
        let feature_seq;
        if sequence.len()>=100{
            feature_seq = &sequence[5..100];
        }
        else{
            feature_seq = &sequence[5..sequence.len()];
        }
        
    	write_output_txt(&feature_seq.to_string(), "results_coordinates.txt");

    }

	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
}

//se buscan coincidencias de subsecuencias
fn match_subsequence()->Vec<f64>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
    let list_sequences = read_fasta("", "partial_hg38.fa");
    let list_strings = ["CCC", "GAACAT", "ATCCCAA"];
    let mut matches;
    write_output_txt("Rust subsequences matches", "results_match.txt");
    for seq_string in list_strings{
        matches = 0;
        for sequence in &list_sequences{
            matches = matches + sequence.matches(seq_string).count();
        }
        write_output_txt(&matches.to_string(), "results_match.txt");

    }
    let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	return array;
   
}

//se realiza la llamada secuencial de todas las funciones
fn get_benchmarks(){

	println!("Obteniendo las secuencias de NCBI\n");
	let result_database = get_sequences_from_database();
	let data_database= &result_database.unwrap();
	write_results(data_database[0], data_database[1], "results_database.csv");

	println!("Realizando el alineamiento\n");
    let result_alignment = align_two_sequences();
    let data_alignment= &result_alignment;
	write_results(data_alignment[0], data_alignment[1], "results_alignment.csv");
    
    println!("Obteniendo la reversa complementaria\n");
	let result_rev_comp = get_complementary_reverse_sequence();
	let data_rev_comp= &result_rev_comp;
	write_results(data_rev_comp[0], data_rev_comp[1], "results_rev_comp.csv");
    
    println!("Obteniendo secuencias a partir de coordenadas\n");
    let result_coordinates = get_sequence_from_coordinates();
    let data_coordinates= &result_coordinates;
	write_results(data_coordinates[0], data_coordinates[1], "results_coordinates.csv");
    
    println!("Buscando el número de coincidencias para tres subsecuencias\n");
    let result_match = match_subsequence();
    let data_match= &result_match;
	write_results(data_match[0], data_match[1], "results_match_subsequence.csv");
    
    




}
