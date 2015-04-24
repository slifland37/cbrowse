#!/bin/bash

refetch=0
setup=0

if [ $# -gt 2 ]
then
    echo "Usage: dprocess.sh ([-refetch]|[-setup])"
fi

for arg in "$@"
do
    if [ $arg = '-refetch' ]
    then
	refetch=1
    elif [ $arg = '-setup' ]
    then
	setup=1
    else
	echo "Usage: dprocess.sh ([-refetch]|[-setup])"
    fi
done

if [ $setup -eq 1 ]
then
    echo "Performing initial setup"
fi

outdir="resultstats"
synfetchfile=$outdir"/agg/synfetchresults.txt"
synfetchcsvfile=$outdir"/agg/synfetchresults.csv"
syndatafile=$outdir"/agg/syndata.txt"
syndatacsvfile=$outdir"/agg/syndata.csv"

rm -iv $synfetchfile
rm -iv $synfetchcsvfile
rm -iv $syndatafile
rm -iv $syndatacsvfile

# Headers for shared CSV files
echo "Domain,Syn URL Sets,Reduced URLs" > $syndatacsvfile
echo "Domain,Failed Reduced URL fetches,Untested Reduced URLs,Successful Reduced URL fetches no match,\
Successful Reduced URL fetches with match" > $synfetchcsvfile

for hostdir in results/*; do
    targets=$(find $hostdir -name "results.json")
    re="results/(.*)"

    if [[ $hostdir =~ $re ]]
    then
	hostname=${BASH_REMATCH[1]}
	sitedir=$outdir/$hostname
	
	if [ $setup -eq 1 ]
	then
	    mkdir -v $sitedir
	    mkdir -v $sitedir"/fetched"
	fi

	outfile=$sitedir/$hostname"-detailed.txt"
	echo "processing "$hostdir"..."
	python process.py $refetch $targets > $outfile
    else
	echo "Script error; can't extract output directory name"
    fi
done
