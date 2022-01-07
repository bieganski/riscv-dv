#!/bin/bash


elf=$1

if [ "$elf" == "" ]; then
	echo "ERROR: pass an elf path"
	exit 1
fi


riscv-none-embed-objdump -xtrds $elf | grep  rv32

riscv-none-embed-objdump -Mno-aliases -Mnumeric -xtrds $elf | grep csrr | rev | cut -d , -f 2 | rev | sort | uniq

