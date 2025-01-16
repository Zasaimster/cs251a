#!/bin/bash

GEM5_DIR=~/gem5
BUILD_CONFIG_DIR=$GEM5_DIR/configs/deprecated/example
BM_DIR=~/hw1/cs251a-microbench
RES_DIR=~/hw1/results


benchmarks=("mm" "spmv" "lfsr" "merge" "sieve")

for bm in "${benchmarks[@]}"
do
  echo $RES_DIR/$bm
done