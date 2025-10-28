#!/bin/bash
#SBATCH -J fastqc_fastq
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH -o report/%x.out
#SBATCH -e report/%x.err
#SBATCH --time=30-00:00:00

set -euo pipefail
IN_DIR=/data/scratch/timaz/atac/data/fastq
OUTDIR=/data/scratch/timaz/atac/results/fastqc/fastq
mkdir -p "$OUTDIR"
export OUTDIR
export IN_DIR


# Find all FASTQ(.gz) files and run fastqc in parallel
find ${IN_DIR} -maxdepth 1 -type f \( -name "*.fastq.gz" \) \
| parallel -j $SLURM_CPUS_PER_TASK \
    fastqc {} -o "${OUTDIR}"
