#!/bin/bash

f=$1

function err {
	echo "$@"
	exit 1
}

if [ "$f" == "" ]; then
	err "pass .elf or .csv filename"
fi

if ! [ -f $f ]; then
	err "$f doesnt exists"
fi

if [ "${f: -4}" == ".csv" ]; then
	tail -n +2 $f | cut -d \" -f 2 | cut -d ' ' -f 1 | sort | uniq -c
	echo "csv is execution log: number of insn occurences does not match .elf"
else
	# assume elf
	riscv-none-embed-objdump -d $f | tr '\t' " " | tr -s " " | cut -d " " -f 3 | sort | uniq -c | grep -v -E "section|format"
	echo "note that number of insn occurences does not match .csv, as it's not an execution log"
fi

