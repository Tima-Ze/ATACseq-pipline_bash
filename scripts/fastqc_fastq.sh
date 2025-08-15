#!/bin/bash
#SBATCH -J fastqc_fastq
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH -o report/fastqc_fastq.out
#SBATCH -e report/fastqc_fastq.err
#SBATCH --time=30-00:00:00

set -euo pipefail

mkdir -p results/fastqc/fastq

# Find all FASTQ(.gz) files and run fastqc in parallel
find data/fastq -maxdepth 1 -type f \( -name "*.fastq.gz" \) \
| parallel -j $SLURM_CPUS_PER_TASK \
    fastqc {} -o results/fastqc/fastq/
