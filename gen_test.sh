#!/bin/bash

set -x
set -eu

# configurable
# test_name=riscv_arithmetic_basic_test
# test_name=riscv_mmu_stress_test # this one seemed to work but stopped why??
# test_name=riscv_rand_instr_test
# test_name=riscv_unaligned_load_store_test # this one indeed yields satp stuff
test_name=riscv_u_mode_rand_test

# target=rv32i
target=rv32imc_sv32

spike_csv_path=$test_name.csv

# constant
out_dirname=out_`date -I`
asm_dirname=$out_dirname/asm_test
elf_path=$asm_dirname/${test_name}_0.o
spike_log_path=$out_dirname/spike_sim/$test_name.0.log

source env.sh
# use the same seed as in mtkcpu
python3 run.py --seed 773733898  --target $target --test $test_name --simulator questa --verbose
file $elf_path
file $spike_log_path

force=-f
python3 scripts/spike_log_to_trace_csv.py $force --log $spike_log_path --csv $spike_csv_path
head $spike_csv_path


riscv-none-embed-objdump -d $elf_path   > objdump.$test_name.txt


python3 -c "import beepy; beepy.beep()"

grep -v core $out_dirname/spike_sim/$test_name.0.log
