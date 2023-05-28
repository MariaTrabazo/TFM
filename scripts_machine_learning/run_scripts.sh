#!/bin/bash

mkdir results
python MachineLearningScript.py
Rscript MachineLearningScript.R
cargo run -- main src/main.rs
julia MachineLearningScript.jl > results/julia_output.txt
python write_julia_results.py


