#!/bin/bash
#SBATCH -J fastqc_trim_galore
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH --time=30-00:00:00
#SBATCH -o report/%x.out
#SBATCH -e report/%x.err

set -euo pipefail
IN_DIR=/data/scratch/timaz/atac/results/trimmed
OUTDIR=/data/scratch/timaz/atac/results/fastqc/trimmed
mkdir -p ${OUTDIR}
export OUTDIR
export IN_DIR

find ${IN_DIR} -maxdepth 1 -type f -name "*.fq.gz" \
| parallel -j $SLURM_CPUS_PER_TASK \
    fastqc {} -o "${OUTDIR}"

# Run MultiQC on trim_galore-related results	
OUTDIR2=/data/scratch/timaz/atac/results/multiqc/trimmed
export OUTDIR2
mkdir -p ${OUTDIR2}

multiqc ${OUTDIR} --outdir ${OUTDIR2}
