#!/bin/bash
if [ $# -gt 0 ]; then
    targets=$(find results/$1 -name "results.json")
    outfile="resultstats/"$1"-detailed.txt"
    echo "Processing "$1"..."

    mkdir -v "resultstats/"$1

    # 1 stands for refetch
    python process.py 1 $targets > $outfile
    echo "Done"
else
    echo "Usage; must specify a result directory"
fi
    
