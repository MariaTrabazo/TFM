#!/bin/bash

mkdir results
python OmicsDataManipulation.py
Rscript OmicsDataManipulation.R
cargo run -- main src/main.rs
julia OmicsDataManipulation.jl > results/julia_output.txt
python write_julia_results.py


