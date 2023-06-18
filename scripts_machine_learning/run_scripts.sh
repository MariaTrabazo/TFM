#!/bin/bash

mkdir results
python MachineLearningScript.py
Rscript MachineLearningScript.R
julia MachineLearningScript.jl > results/julia_output.txt
python write_julia_results.py
cargo run -- main src/main.rs
exit 0




