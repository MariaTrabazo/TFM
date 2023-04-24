#!/bin/bash

mkdir results
python SequenceManipulation.py
Rscript SequenceManipulation.R
cargo run -- main src/main.rs
julia SequenceManipulation.jl > results/julia_output.txt
python write_julia_results.py


