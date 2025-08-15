#!/bin/bash
#SBATCH -J multiqc_trim_galore
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH -o report/multiqc_trim_galore.out
#SBATCH -e report/multiqc_trim_galore.err
#SBATCH --time=30-00:00:00
set -euo pipefail

# Make target folder
mkdir -p results/multiqc/trim_galore

# Run MultiQC on Trimmomatic-related results
multiqc results/fastqc/trim_galore/. --outdir results/multiqc/trim_galore
