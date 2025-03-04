WORKSPACE := /workspaces/cs251a
BUILD_DIR := ${WORKSPACE}/build
HW1_DIR := ${WORKSPACE}/hw1
HW2_DIR := ${WORKSPACE}/hw2
HW3_DIR := ${WORKSPACE}/hw3

OPT ?= -O0
CFLAGS := -std=gnu11 $(OPT) -Wall -Wextra -Wpedantic -Wstrict-aliasing -static

hw1: FORCE
	./hw1/benchmark.sh

hw2: FORCE
	mkdir -p ${BUILD_DIR}/hw2
	x86_64-linux-gnu-gcc ${HW2_DIR}/fsubr.c -o ${BUILD_DIR}/hw2/fsubr ${CFLAGS}

hw3: FORCE
	python3 ${HW3_DIR}/compare-results.py

clean-hw3:
	rm -r ${HW3_DIR}/figures

FORCE: ;

clean:
	@rm -rf $(BUILD_DIR)
