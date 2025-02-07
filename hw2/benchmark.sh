#!/bin/bash

# Path to cs251a repo
WORKSPACE=/workspaces/cs251a # Max's config
# WORKSPACE=/root/cs251a # Saim's config
GEM5_DIR=$WORKSPACE/gem5
GEM5_X86=$GEM5_DIR/build/X86/gem5.opt

$GEM5_X86 ${GEM5_DIR}/configs/deprecated/example/se.py --cmd=${WORKSPACE}/build/hw2/test
