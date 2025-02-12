#!/bin/bash

# Path to cs251a repo
# WORKSPACE=/workspaces/cs251a # Max's config
WORKSPACE=/root/cs251a # Saim's config
GEM5_DIR=$WORKSPACE/gem5
GEM5_X86=$GEM5_DIR/build/X86/gem5.opt
$GEM5_X86 ${GEM5_DIR}/configs/deprecated/example/se.py --cmd=${WORKSPACE}/build/hw2/test
BUILD_CONFIG_DIR=$WORKSPACE/hw1/configs

$GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB

# scons build/X86/gem5.opt -j 8

# /root/gem5/build/X86/gem5.opt --debug-flags=IEW,Rename,IQ,Fetch,Decode,Commit --debug-file=debug.out /root/gem5/configs/deprecated/example/se.py --cmd=/root/hw2/test  --cpu-type=DerivO3CPU --caches --l1d_size=64KiB --l1i_size=64KiB
# /root/gem5/build/X86/gem5.opt --debug-flags=Rename --debug-file=debugOutput.txt /root/gem5/configs/deprecated/example/se.py --cmd=/root/hw2/test  --cpu-type=DerivO3CPU --caches --l1d_size=64KiB --l1i_size=64KiB
# /root/gem5/build/X86/gem5.opt /root/gem5/configs/deprecated/example/se.py --cmd=/root/hw2/test  --cpu-type=DerivO3CPU --caches --l1d_size=64KiB --l1i_size=64KiB
/root/gem5/build/X86/gem5.opt /root/gem5/configs/deprecated/example/se.py --cmd=/root/hw2/test  --cpu-type=DerivO3CPU --caches --l1d_size=64KiB --l1i_size=64KiB