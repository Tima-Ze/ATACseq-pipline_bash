#!/usr/bin/env bash
#SBATCH -J trim_galore
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=40G
#SBATCH -o report/trim_galore.out
#SBATCH -e report/trim_galore.err
#SBATCH --time=30-00:00:00

set -euo pipefail

mkdir -p results/trim_galore

parallel --colsep '\s+' -j 10 '
  read1={1}
  read2={2}
  sample={3}

  echo "Running trim_galore PE for $sample"

  trim_galore --paired --nextera --cores 10 \
  --stringency 6 --length 36\
  --output_dir results/trim_galore \
  "$read1" "$read2"
' :::: pairs_list.txt

# Step 2: Clean up FASTQ outputs
cd results/trim_galore
rm -f *trimmed.fq.gz

# Step 3: Move trimming reports into their own subdir
mkdir -p report
mv *trimming_report.txt report/

echo "All trim_galore runs finished. Reports are in results/trim_galore/report/"
