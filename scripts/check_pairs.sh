#!/usr/bin/env bash
#SBATCH -J check_pairs
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH -o /data/scratch/timaz/atac/report/check_pairs.out
#SBATCH -e report/check_pairs.err

set -euo pipefail
mkdir -p data/unpaired

pairs_file="pairs_list.txt"
> "$pairs_file"  # empty or create file

# Check NeuN_minus files for matching plus files
while IFS= read -r minus_file; do
    sample=${minus_file#data/fastq/NeuN_minus.}
    plus_file="data/fastq/NeuN_plus.${sample}"

    if [[ -f "$plus_file" ]]; then
        echo "$minus_file $plus_file $sample" >> "$pairs_file"
    else
        echo "Warning: Plus file not found for $sample"
        mv "$minus_file" data/unpaired/
    fi
done < <(find data/fastq -type f -name "NeuN_minus.*.fastq.gz" | sort)

# Check NeuN_plus files for missing minus pairs
while IFS= read -r plus_file; do
    sample=${plus_file#data/fastq/NeuN_plus.}
    minus_file="data/fastq/NeuN_minus.${sample}"

    if [[ ! -f "$minus_file" ]]; then
        echo "Warning: Minus file not found for $sample"
        mv "$plus_file" data/unpaired/
    fi
done < <(find data/fastq -type f -name "NeuN_plus.*.fastq.gz" | sort)

echo "Pairs list written to: $pairs_file"
