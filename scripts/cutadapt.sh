#!/usr/bin/env bash
#SBATCH -J cutadapt
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=40G
#SBATCH -o report/cutadapt.out
#SBATCH -e report/cutadapt.err

set -euo pipefail

mkdir -p results/cutadapt

parallel --colsep '\s+' -j 10 '
    read1={1}
    read2={2}
    sample={3}

    echo "Running cutadapt for $sample"
    cutadapt -a file:ref/NexteraPE_PE.fa \
             -e 0.1 \
             --overlap=15 \
             --cores=10 \
             -o results/cutadapt/$(basename "$read1") \
             -p results/cutadapt/$(basename "$read2") \
             "$read1" \
             "$read2"
' :::: "$pairs_file"