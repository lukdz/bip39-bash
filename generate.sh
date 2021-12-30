#!/bin/bash


# Exit immediately if a command exits with a non-zero status.
set -e 

# the return value of a pipeline is the status of
# the last command to exit with a non-zero status,
# or zero if no command exited with a non-zero status
set -o pipefail

# Treat unset variables as an error when substituting.
set -u


# length of word list (12 or 24)
word_list_length=${1:-24}

check_sum_binary_lenght=$(( word_list_length / 3 ))
check_sum_hex_lenght=$(( check_sum_binary_lenght / 4 ))
random_binary_lenght=$(( word_list_length * 11 - check_sum_binary_lenght ))
random_octet_lenght=$(( random_binary_lenght / 8 ))

if [ "${word_list_length}" -ne 12 ] && [ "${word_list_length}" -ne 24 ]
then
    printf "Not suported word list length\nUse 12 or 24 (default)\n"
    exit 1
fi

# get random binary number
random_binary=$( xxd -l "${random_octet_lenght}" -b -c 1 /dev/random | awk '{ printf( "%s", $2 ) }' )

# calculate check sum (sha256)
check_sum=$( printf "%s" "${random_binary}" | shasum -a 256 -0 | tr "[:lower:]" "[:upper:]" | head -c "${check_sum_hex_lenght}" )

# convert check sum to binary
check_sum_binary=$( printf "obase=2;ibase=16;%s\n" "${check_sum}" | bc )

# combine random with check sum
binary=$(printf "%s%0*d" "${random_binary}" "${check_sum_binary_lenght}" "${check_sum_binary}")

# output in table format
printf "%s\t%-8s %s\t%s\t%s\n" "#" "word" "line" "decimal" "binary"
{
    i=0
    for b in $( printf "%s\n" "${binary}" | fold -w 11 ); do
        ((i+=1))
        d=$( printf "obase=10;ibase=2;\n%s\n" "${b}" | bc )
        ((di = d + 1))
        awk \
            -v line_number="${di}" -v b="${b}" -v d="${d}" -v i="${i}" \
            'NR == line_number { printf( "%s\t%-8s %s\t%s\t%s\n", i, $1, line_number, d, b ) }' \
            english.txt
    done
}

# output words in single line
{
    for i in $({ printf "obase=10;ibase=2;\n"; printf "%s\n" "${binary}" | fold -w 11; } | bc); do
        ((i += 1))
        awk -v line_number="${i}" 'NR == line_number { printf( "%s ", $1 ) }' english.txt
    done
}; printf "\n"
