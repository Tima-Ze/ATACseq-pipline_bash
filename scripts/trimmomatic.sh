#!/usr/bin/env bash
#SBATCH -J Trimmomatic
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=40G
#SBATCH -o report/trimmomatic.out
#SBATCH -e report/trimmomatic.err
#SBATCH --time=30-00:00:00

set -euo pipefail

mkdir -p results/trimmomatic
mkdir -p report/trimmomatic

parallel --colsep '\s+' -j 10 '
  minus_file={1}
  plus_file={2}
  sample={3}

  echo "Running Trimmomatic PE for $sample"

  trimmomatic PE -threads 10 \
    "$minus_file" "$plus_file" \
    results/trimmomatic/${sample}_minus_paired.fastq.gz results/trimmomatic/${sample}_minus_unpaired.fastq.gz \
    results/trimmomatic/${sample}_plus_paired.fastq.gz  results/trimmomatic/${sample}_plus_unpaired.fastq.gz \
    ILLUMINACLIP:NexteraPE-PE.fa:2:30:10:8:TRUE LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
	> report/trimmomatic/${sample}.log 2>&1
' :::: pairs_list.txt