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
mkdir -p results/fastqc/trim_galore

parallel --colsep '\s+' -j 10 '
  minus_file={1}
  plus_file={2}
  sample={3}

  echo "Running trim_galore PE for $sample"

  trim_galore --paired --nextera --cores 4 \
  --fastqc --fastqc_args "--outdir /results/fastqc/trim_galore/" \
  --stringency 6 --length 36\
  --output_dir results/trim_galore \
  "$minus_file" "$plus_file"
' :::: pairs_list.txt


