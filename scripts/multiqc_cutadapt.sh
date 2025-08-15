#!/bin/bash
#SBATCH -J multiqc_cutadapt
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH -o report/multiqc_cutadapt.out
#SBATCH -e report/multiqc_cutadapt.err
#SBATCH --time=30-00:00:00
set -euo pipefail

# Make target folder
mkdir -p results/multiqc/cutadapt

# Run MultiQC on cutadapt-related results
multiqc results/fastqc/cutadapt/. --outdir results/multiqc/cutadapt