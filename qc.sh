#!/usr/bin/env bash
#SBATCH -J qc
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH -o report/%x.out
#SBATCH -e report/%x.err
#SBATCH --time=30-00:00:00

set -euo pipefail

mito=results/bam/
No_dup=results/bam_noDup/dup_metrics
OUTDIR=results/qc
mkdir -p $OUTDIR

#Examin Mitochondrial read content
ls $mito/*.bam | parallel -j 8 '
    total=$(samtools idxstats {} | awk -F"\t" "{sum+=\$3} END{print sum}")
    mt=$(samtools idxstats {} | awk -F"\t" "\$1==\"MT\" {print \$3}")
    if [ -z "$mt" ]; then mt=0; fi
    prop=$(awk -v mt=$mt -v total=$total "BEGIN{if(total>0) printf \"%.4f\", mt/total; else print 0}")
    echo -e "$(basename {})\t$total\t$mt\t$prop"
' > $OUTDIR/mt_read_proportions.csv

#Examin duplicated reads percentage

echo -e "sample\tunpaired_examined\tpaired_examined\tdup_unpaired\tdup_paired\tpercent_duplication" > $OUTDIR/duplication_summary.csv

for f in $No_dup/*_dup_metrics.txt; do
    sample=$(basename "$f" _dup_metrics.txt)
    awk 'NR>1 && $1!="##" {print "'$sample'\t"$2"\t"$3"\t"$5"\t"$6"\t"$9}' "$f" >> $OUTDIR/duplication_summary.tsv
done


