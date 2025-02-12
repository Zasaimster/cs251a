#!/bin/bash

# Path to cs251a repo
WORKSPACE=/workspaces/cs251a # Max's config
# WORKSPACE=/root/cs251a # Saim's config
GEM5_DIR=$WORKSPACE/gem5
GEM5_X86=$GEM5_DIR/build/X86/gem5.opt
HW2_DIR=$WORKSPACE/hw2
CONFIG_DIR=$HW2_DIR/configs

$GEM5_X86 \
    --outdir ${HW2_DIR}/m5out \
    ${CONFIG_DIR}/se_8width.py \
    --cmd=${WORKSPACE}/build/hw2/fsubr \
    --cpu-type=DerivO3CPU \
    --caches \
    --l1d_size=64KiB \
    --l1i_size=64KiB \
