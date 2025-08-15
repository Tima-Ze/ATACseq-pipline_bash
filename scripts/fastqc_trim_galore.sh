#!/bin/bash
#SBATCH -J fastqc_trim_galore
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --time=30-00:00:00
#SBATCH -o report/fastqc_trim_galore.out
#SBATCH -e report/fastqc_trim_galore.err

set -euo pipefail

mkdir -p results/fastqc/trim_galore

find results/trim_galore -maxdepth 1 -type f \( -name "*._val_1.fq.gz" -o -name "**._val_2.fq.gz" \) \
| parallel -j $SLURM_CPUS_PER_TASK \
    fastqc {} -o results/fastqc/trim_galore/