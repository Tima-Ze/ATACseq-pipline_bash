#!/usr/bin/env bash
#SBATCH -J trim_galore
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=40G
#SBATCH -o report/%x.out
#SBATCH -e report/%x.err
#SBATCH --time=30-00:00:00

set -euo pipefail

IN_DIR=/data/scratch/timaz/atac/data/fastq
OUTDIR=/data/scratch/timaz/atac/results/trimmed
mkdir -p "$OUTDIR"
export OUTDIR
export IN_DIR

parallel -j 10 '
  echo "Running trim_galore for {1}"
  trim_galore --nextera --cores 4 \
    --stringency 6 --length 36 \
    --output_dir "${OUTDIR}" {}
' ::: ${IN_DIR}/*.fastq.gz


cd ${OUTDIR}
#Move trimming reports into their own subdir
mkdir -p report
mv *trimming_report.txt report/

echo "All trim_galore runs finished. Reports are in results/trimmed/report/"
