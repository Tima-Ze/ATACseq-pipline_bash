#!/bin/bash
#SBATCH -J fastqc_trimmomatic
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --time=30-00:00:00
#SBATCH -o report/fastqc_trimmomatic.out
#SBATCH -e report/fastqc_trimmomatic.err

set -euo pipefail

mkdir -p results/fastqc/trimmomatic

find results/trimmomatic -maxdepth 1 -type f \( -name "*paired.fastq.gz" \) \
| parallel -j $SLURM_CPUS_PER_TASK \
    fastqc {} -o results/fastqc/trimmomatic/