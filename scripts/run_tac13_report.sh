#!/usr/bin/env bash
# 
# Prepare score summary in TAC 2013 format
set -e

usage="Usage: $0 OUT_DIR"

if [ "$#" -ne 1 ]; then
    echo $usage
    exit 1
fi

outdir=$1; shift # directory to which results are written

# INITIALISE REPORT HEADER
report=$outdir/00report.tab
(
    echo -en "system"                                # run name
    echo -en "\tKBP2010 micro-average"               # overall linking score
    echo -en "\tB^3 Precision\tB^3 Recall\tB^3 F1"   # B^3 clustering scores
    echo -e "\tB^3+ Precision\tB^3+ Recall\tB^3+ F1" # B^3+ clustering scores
) > $report

# ADD SYSTEM SCORES
for sys_eval in $outdir/*.evaluation
do
    basename $sys_eval \
        | sed 's/\.evaluation//' \
        | tr '\n' '\t' \
        >> $report
    cat $sys_eval \
        | grep -P '\tstrong_all_match$' \
        | cut -f 7 \
        | tr '\n' '\t' \
        >> $report
    cat $sys_eval \
        | grep -P '\tb_cubed$' \
        | cut -f 5,6,7 \
        | tr '\n' '\t' \
        >> $report
    cat $sys_eval \
        | grep -P '\tb_cubed_plus$' \
        | cut -f 5,6,7 \
        >> $report
done
