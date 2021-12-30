#!/bin/bash

random_binary=$( xxd -l 16 -b -c 1 /dev/random | awk '{ printf( "%s", $2 ) }' )

check_sum=$( echo "${random_binary}" | shasum -a 256 -0 | tr "[:lower:]" "[:upper:]" | head -c 1 )

check_sum_binary=$( echo "obase=2;ibase=16;${check_sum}" | bc )

binary=$(printf "%s%04d" "${random_binary}" "${check_sum_binary}")

{ echo "obase=10;ibase=2;"; echo "${binary}" | fold -w 11; } | bc | awk '{print $1+1}' | tr "\n" "\t"; echo
