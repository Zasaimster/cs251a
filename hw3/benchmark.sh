#!/bin/bash

# Path to cs251a repo
# WORKSPACE=/workspaces/cs251a # Max's config
WORKSPACE=/root/cs251a # Saim's config
GEM5_DIR=$WORKSPACE/gem5
GEM5_X86=$GEM5_DIR/build/X86/gem5.opt
BUILD_CONFIG_DIR=$WORKSPACE/hw3/configs
SPEC2017_DIR=$WORKSPACE/spec2017
RES_DIR=$WORKSPACE/hw3/test_results

# This assumes you have already built gem5 locally with `scons build/X86/gem5.opt -j 8`

# Our diff cache replacement policies
rps=("NMRURP" "NRURP" "TreePLRURP" "LRURP" "RandomRP")

# Default benchmarks in spec2017/Makefile
# lbm_s imagick_s nab_s x264_s mcf_s deepsjeng_s leela_s
# bms=("619.lbm_s" "638.imagick_s" "644.nab_s" "625.x264_s" "605.mcf_s" "631.deepsjeng_s" "641.leela_s")
bms=("619.lbm_s" "638.imagick_s" "644.nab_s" "625.x264_s" "605.mcf_s") # going to do just 5 for now to match exact requirements since execution takes too long

echo "Clearing existing results"
rm -rf ${RES_DIR}

echo "Creating new results directory"
for rp in "${rps[@]}"
do
  mkdir -p ${RES_DIR}/${rp}
  for bm in "${bms[@]}"
  do
    mkdir -p ${RES_DIR}/${rp}/${bm}/8_assoc
    mkdir -p ${RES_DIR}/${rp}/${bm}/16_assoc
  done
done

cd $SPEC2017_DIR
for rp in "${rps[@]}"
do
  # For every replacement policy: run simall, get the output, copy output to local directory. Repeat for higher assoc. Continue to next RP...?
  echo "Running simulation with REPLACEMENT POLICY=$rp and CACHE ASSOCIATIVITY=8"
  make CACHE_REPL_TYPE=$rp CACHE_ASSOC=8 simall

  # Copy over all outputs to local directory
  for bm in "${bms[@]}"
  do
    cp -r $SPEC2017_DIR/benchspec/CPU/${bm}/run/run_base_refspeed_mytest-m64.0000/m5out $RES_DIR/${rp}/${bm}/8_assoc/
  done

  echo "Running simulation with REPLACEMENT POLICY=$rp and CACHE ASSOCIATIVITY=16"
  make CACHE_REPL_TYPE=$rp CACHE_ASSOC=16 simall

  Copy over all outputs to local directory
  for bm in "${bms[@]}"
  do
    cp -r $SPEC2017_DIR/benchspec/CPU/${bm}/run/run_base_refspeed_mytest-m64.0000/m5out $RES_DIR/${rp}/${bm}/16_assoc/
  done

done
