#!/bin/bash

# get random binary number
random_binary=$( xxd -l 32 -b -c 1 /dev/random | awk '{ printf( "%s", $2 ) }' )

# calculate check sum (sha256)
check_sum=$( echo "${random_binary}" | shasum -a 256 -0 | tr "[:lower:]" "[:upper:]" | head -c 2 )

# convert check sum to binary
check_sum_binary=$( echo "obase=2;ibase=16;${check_sum}" | bc )

# combine random with check sum
binary=$(printf "%s%08d" "${random_binary}" "${check_sum_binary}")

# output decimal numbers (from 1 to 2048)
{
    echo "obase=10;ibase=2;"; echo "${binary}" | fold -w 11; 
} | bc | awk '{print $1+1}' | tr "\n" "\t" ; echo

# output words
{
    for i in $({ echo "obase=10;ibase=2;"; echo "${binary}" | fold -w 11; } | bc); do
        awk "NR == ${i} + 1" english.txt
    done
} | tr "\n" "\t"; echo
