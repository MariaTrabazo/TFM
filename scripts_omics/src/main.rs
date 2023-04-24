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


fn main() {
   
   //calculate_by_row();
   calculate_for_all_data();
   //calculate_by_column();
}

fn calculate_by_row() -> Result<(),Box<dyn Error>>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
  	let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().from_path(current_path)?;
    let mut row = vec![];
    for result in reader.records() {
       
       	
        let record =result?;
        let parts = record.as_slice().split("\t");
        for part in parts{
        	if !!!part.starts_with("F"){
        		row.push(part.to_string().parse::<f32>().unwrap());
        	}
        	
        }
        
   }
   
   let mut iter_array = row.chunks(9);
       	for i in iter_array{
    		println!("Media");
    		let mean_value = mean(i);
    		println!("{:?}", mean_value);
    		println!("Mediana");
    		let median_value = median(i);
    		println!("{:?}", median_value);
    		println!("Desviacion estandar");
    		let std_value = standard_deviation(i, Some(mean_value));
    		println!("{:?}", std_value);
		}
   
   
  
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	//return array;
	Ok(())
    
}

fn calculate_by_column() -> Result<(),Box<dyn Error>>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
  	let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().delimiter(b'\t').from_path(current_path)?;
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
       
       	let record =result?;
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
   	println!("Media");
	let mean_value = mean(&row1);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row1);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row1, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row2);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row2);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row2, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row3);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row3);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row3, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row4);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row4);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row4, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row5);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row5);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row5, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row6);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row6);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row6, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row7);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row7);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row7, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row8);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row8);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row8, Some(mean_value));
	println!("{:?}", std_value);
	
	println!("Media");
	let mean_value = mean(&row9);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row9);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row9, Some(mean_value));
	println!("{:?}", std_value);

  	
  
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	//return array;
	Ok(())
    
}

fn calculate_for_all_data() -> Result<(),Box<dyn Error>>{

    let start = Instant::now();
    let start_cpu = ProcessTime::now();
  
  
  	let string_path = &current_dir().unwrap();
    let mut current_path= PathBuf::new();
    current_path.push(string_path);
    current_path.push("table_counts.tsv");
    
    let mut reader =  ReaderBuilder::new().delimiter(b'\t').from_path(current_path)?;
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
       
       	let record =result?;
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
	println!("Media");
	let mean_value = mean(&row1) + mean(&row2) + mean(&row3) + mean(&row4) +mean(&row5) + mean(&row6) + mean(&row7) + mean(&row8) + mean(&row9);
	println!("{:?}", mean_value);
	println!("Mediana");
	let median_value = median(&row1) + median(&row2) + median(&row3) + median(&row4) + median(&row5) + median(&row6) + median(&row7) + median(&row8) + median(&row9);
	println!("{:?}", median_value);
	println!("Desviacion estandar");
	let std_value = standard_deviation(&row1, Some(mean(&row1))) + standard_deviation(&row2, Some(mean(&row2))) + standard_deviation(&row3, Some(mean(&row3))) + standard_deviation(&row4, Some(mean(&row4))) + standard_deviation(&row5, Some(mean(&row5))) + standard_deviation(&row6, Some(mean(&row6))) + standard_deviation(&row7, Some(mean(&row7))) + standard_deviation(&row8, Some(mean(&row8))) + standard_deviation(&row9, Some(mean(&row9)));
	println!("{:?}", std_value);

  	
  
	
	let cpu_time: Duration = start_cpu.elapsed();
    let end = start.elapsed();
	let mut array= vec![]; 
	
	array.push(end.as_secs_f64());
	array.push(cpu_time.as_secs_f64());
	//return array;
	Ok(())
    
}
