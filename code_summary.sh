#! /bin/bash

# set -x

if [ -z $1 ]; then
    echo "Usage: ./code_summary.sh {dir_name} {file_extensions(separated by comma(,)), 'php' by default}"
    exit 0
else
    dir=$1
fi

condition=""
if [ -z $2 ]; then
    condition="-name *.php"
else
    IFS=',' read -ra EXT <<< "$2"
    for i in "${EXT[@]}"; do
        if [ -z "$condition" ]; then
          condition="-name *.$i"
        else
          condition+=" -o -name *.$i"
        fi
    done
fi

fileCount=$(find "$dir" $condition | wc -l | xargs) # use xargs at end of line for trim
totalLines=$(find "$dir" $condition | xargs cat | wc -l | xargs)
avg=$(awk 'BEGIN{printf "%.2f\n", '$totalLines'/'$fileCount'}')

echo "Summary:"

echo -e "       directory: $dir"
echo -e "      file count: $fileCount"
echo -e "     total lines: $totalLines"
echo -e "             avg: $avg"

echo "Detail:"

detail=$(find "$dir" $condition | xargs wc -l | sort -n -r | head -n 11 | sed '1d')

echo -e "$detail"
