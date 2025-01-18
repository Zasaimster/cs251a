#!/bin/bash

# Path to cs251a repo
WORKSPACE=/workspaces/cs251a
GEM5_DIR=$WORKSPACE/gem5
GEM5_X86=$GEM5_DIR/build/X86/gem5.opt
BUILD_CONFIG_DIR=$WORKSPACE/hw1/configs
BM_DIR=$WORKSPACE/hw1/cs251a-microbench
RES_DIR=$WORKSPACE/hw1/results
# $GEM5_X86 configs/deprecated/example/se.py --cmd=tests/test-progs/hello/bin/x86/linux/hello --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB

rm -rf ${RES_DIR}

# (mm,spmv,lfsr,merge,sieve)
benchmarks=("mm" "spmv" "lfsr" "merge" "sieve")

for bm in "${benchmarks[@]}"
do
  mkdir -p ${RES_DIR}/${bm} 
done


# Perform all benchmark tests with "-O3 -ffast-math -ftree-vectorize"
cd $BM_DIR && make clean --silent && make OPT="-O3 -ffast-math -ftree-vectorize" --silent && cd $WORKSPACE
for bm in "${benchmarks[@]}"
do
  # Default case
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB
  cp -r m5out/ $RES_DIR/$bm/default/

  # CPU model: X86MinorCPU
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se_x86minorcpu_8width.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=X86MinorCPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB
  cp -r m5out/ $RES_DIR/$bm/x86MinorCPU/

  # issueWidth=2
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se_derivo3_2width.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB
  cp -r m5out/ $RES_DIR/$bm/issueWidth2/

  # Clock frequency = 4Ghz
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
      --cpu-type=DerivO3CPU --sys-clock=4GHz --cpu-clock=4GHz --mem-type=DDR3_1600_8x8 \
      --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB
  cp -r m5out/ $RES_DIR/$bm/4GHz/
  
  # No L2 Cache
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB
  cp -r m5out/ $RES_DIR/$bm/no_l2_cache/

  # 256KB L2
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=256KiB
  cp -r m5out/ $RES_DIR/$bm/256KiB_l2_cache/
  
  # 16MB L2
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=16MiB
  cp -r m5out/ $RES_DIR/$bm/16MiB_l2_cache/

done

# Perform the default benchmark test with the "-O1" compiler
cd $BM_DIR && make clean --silent && make OPT=-O1 --silent && cd $GEM5_DIR
for bm in "${benchmarks[@]}"
do
  # Default case
  $GEM5_X86 ${BUILD_CONFIG_DIR}/se.py  --cmd=${BM_DIR}/${bm} \
    --cpu-type=DerivO3CPU --sys-clock=2GHz --cpu-clock=2GHz --mem-type=DDR3_1600_8x8 \
    --caches --l1d_size=64KiB --l1i_size=64KiB --l2cache --l2_size=2MiB
  cp -r m5out/ $RES_DIR/$bm/O1_compiler/
done
