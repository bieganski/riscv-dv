#!/bin/bash

set -x
set -eu

# configurable
test_name=riscv_arithmetic_basic_test
spike_csv_path=$test_name.csv

# constant
out_dirname=out_`date -I`
asm_dirname=$out_dirname/asm_test
elf_path=$asm_dirname/${test_name}_0.o
spike_log_path=$out_dirname/spike_sim/$test_name.0.log

source env.sh
python3 run.py  --target rv32i --test $test_name --simulator questa --verbose
file $elf_path
file $spike_log_path

python3 scripts/spike_log_to_trace_csv.py --log $spike_log_path --csv $spike_csv_path
head $spike_csv_path
