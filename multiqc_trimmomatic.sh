#!/bin/bash
#SBATCH -J multiqc
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH -o report/multiqc.out
#SBATCH -e report/multiqc.err
#SBATCH --time=30-00:00:00
set -euo pipefail

# Make target folder
mkdir -p results/multiqc/trimmomatic

# Run MultiQC on Trimmomatic-related results
multiqc results/fastqc/trimmomatic/. --outdir results/multiqc/trimmomatic
