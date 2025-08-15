#!/bin/bash
#SBATCH -J multiqc_trimmomatic
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH -o report/multiqc_trimmomatic.out
#SBATCH -e report/multiqc_trimmomatic.err
#SBATCH --time=30-00:00:00
set -euo pipefail

# Make target folder
mkdir -p results/multiqc/trimmomatic

# Run MultiQC on Trimmomatic-related results
multiqc results/fastqc/trimmomatic/. --outdir results/multiqc/trimmomatic
