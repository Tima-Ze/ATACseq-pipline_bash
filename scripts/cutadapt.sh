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

pairs_file="pairs_list.txt"
if [[ ! -f "$pairs_file" ]]; then
    echo "Error: $pairs_file not found. Run check_pairs.sh first."
    exit 1
fi

parallel --colsep '\s+' -j 10 '
    minus_file={1}
    plus_file={2}
    sample={3}

    echo "Running cutadapt for $sample"
    cutadapt -a file:ref/NexteraPE_PE.fa \
             -e 0.1 \
             --overlap=15 \
             --cores=10 \
             -o results/cutadapt/$(basename "$minus_file") \
             -p results/cutadapt/$(basename "$plus_file") \
             "$minus_file" \
             "$plus_file"
' :::: "$pairs_file"
