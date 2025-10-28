#!/bin/bash
#SBATCH -J bowtie2
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH -o report/%x.out
#SBATCH -e report/%x.err
#SBATCH --time=30-00:00:00

set -euo pipefail

IN_DIR=/data/scratch/timaz/atac/results/trimmed
OUTDIR=/data/scratch/timaz/atac/results/bam
Ref_DIR=/data/scratch/timaz/atac/ref
mkdir -p "$OUTDIR"
export OUTDIR
export IN_DIR
export Ref_DIR

echo "Input files: " ${IN_DIR}/*.fq.gz

parallel -j 4 '

    sample=$(basename {} .fq.gz)

    echo "Running Bowtie2 for $sample"

    bowtie2 -x "${Ref_DIR}"/index \
            -U {} \
            -p 4 \
			 2>> "${OUTDIR}/alignment_summary.log" \
    | samtools view -u - \
    | samtools sort -o "${OUTDIR}"/${sample}.bam -
' ::: ${IN_DIR}/*.fq.gz

