# NOTE READ THIS: you should copy this Makefile to your local spec2017 folder. This is the Makefile we'll use rather than the default.

SHELL:=/bin/bash

# PWD=$(shell pwd)
BASE_DIR=/root
GEM5_DIR=${BASE_DIR}/gem5
HW_DIR=${BASE_DIR}/hw3
GEM5_BIN=${GEM5_DIR}/build/X86/gem5.opt
GEM5_CONFIG=${GEM5_DIR}/configs/deprecated/example/se.py
# GEM5_CONFIG=${HW_DIR}/configs/se.py
FAST_FORWARD_INSTS=100000000
# SIM_INSTS=50000000 # 50,000,000
SIM_INSTS=10000000
CACHE_REPL_TYPE ?= NMRURP
CACHE_ASSOC ?= 8
SIM_OPTIONS=\
        --mem-size=8GB \
        --cpu-type=DerivO3CPU \
        --caches --l2cache \
        --l1d_size=64kB --l1i_size=64kB --l2_size=2MiB \
        --l1d_assoc=${CACHE_ASSOC} --l2_assoc=${CACHE_ASSOC} \
        --l1d_repl=${CACHE_REPL_TYPE} --l2_repl=${CACHE_REPL_TYPE} \
        --sys-clock=2GHz --cpu-clock=2GHz \
        --maxinsts=${SIM_INSTS} \
        --fast-forward=${FAST_FORWARD_INSTS} \

lbm_s_BIN:=lbm_s
lbm_s_TARGET:=
lbm_s_ARGS:="2000 reference.dat 0 0 200_200_260_ldc.of"

imagick_s_BIN:=imagick_s
imagick_s_TARGET:='TARGET=imagick_s'
imagick_s_ARGS:="-limit disk 0 refspeed_input.tga -resize 817% -rotate -2.76 -shave 540x375 -alpha remove -auto-level -contrast-stretch 1x1% -colorspace Lab -channel R -equalize +channel -colorspace sRGB -define histogram:unique-colors=false -adaptive-blur 0x5 -despeckle -auto-gamma -adaptive-sharpen 55 -enhance -brightness-contrast 10x10 -resize 30% refspeed_output.tga"

nab_s_BIN:=nab_s
nab_s_TARGET:=
nab_s_ARGS:="3j1n 20140317 220"

x264_s_BIN:=x264_s
x264_s_TARGET:='TARGET=x264_s'
x264_s_ARGS:="--seek 500 --dumpyuv 200 --frames 1250 -o BuckBunny_New.264 ../../BuckBunny.yuv 1280x720"

mcf_s_BIN:=mcf_s
mcf_s_TARGET:=
mcf_s_ARGS:="inp.in"

xz_s_BIN:=xz_s
xz_s_TARGET:=
xz_s_ARGS:="cld.tar.xz 1400 19cf30ae51eddcbefda78dd06014b4b96281456e078ca7c13e1c0c9e6aaea8dff3efb4ad6b0456697718cede6bd5454852652806a657bb56e07d61128434b474 536995164 539938872 8"

gcc_s_BIN:=sgcc
gcc_s_TARGET:=
gcc_s_ARGS:="gcc-pp.c -O5 -finline-limit=24000 -fgcse -fgcse-las -fgcse-lm -fgcse-sm -o gcc-pp.opts-O5_-finline-limit_24000_-fgcse_-fgcse-las_-fgcse-lm_-fgcse-sm.s"

perlbench_s_BIN:=perlbench_s
perlbench_s_TARGET:=
perlbench_s_ARGS:="-I./lib checkspam.pl 2500 5 25 11 150 1 1 1 1"

deepsjeng_s_BIN:=deepsjeng_s
deepsjeng_s_TARGET:=
deepsjeng_s_ARGS:="ref.txt"

leela_s_BIN:=leela_s
leela_s_TARGET:=
leela_s_ARGS:="ref.sgf"

xalancbmk_s_BIN:=xalancbmk_s
xalancbmk_s_TARGET:=
xalancbmk_s_ARGS:="-v t5.xml xalanc.xsl"

#ALL_BENCHMARKS:=lbm_s imagick_s nab_s x264_s mcf_s xz_s gcc_s perlbench_s deepsjeng_s leela_s xalancbmk_s
ALL_BENCHMARKS:=lbm_s imagick_s nab_s x264_s mcf_s deepsjeng_s leela_s
BUILD_ALL:=$(addprefix build-,${ALL_BENCHMARKS})
SIM_ALL:=$(addprefix sim-,${ALL_BENCHMARKS})

build-%: TARGET=${$*_TARGET}
build-%:
        source shrc &&\
        go $* &&\
        runcpu --fake --config gcc-linux-x86 $* &&\
        cd build/build_base_mytest-m64.0000 &&\
        specmake ${TARGET} &&\
        go $* &&\
        cd run/run_base_refspeed_mytest-m64.0000 &&\
        specinvoke -n

sim-%: BIN=${$*_BIN}
sim-%: ARGS=${$*_ARGS}
sim-%: 
        source shrc &&\
        go $* &&\
        cd run/run_base_refspeed_mytest-m64.0000 &&\
        ${GEM5_BIN} ${GEM5_CONFIG} \
                --cmd=../../build/build_base_mytest-m64.0000/${BIN} \
                --options=${ARGS} \
                ${SIM_OPTIONS} 

buildall: ${BUILD_ALL}
        echo "Build All Done."

simall: ${SIM_ALL}
        echo "Sim All Done."

clean:
        runcpu --action clean --config gcc-linux-x86 all