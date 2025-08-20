#!/usr/bin/env bash
#SBATCH -J filter_mito
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=8G
#SBATCH -o report/filter_mito.out
#SBATCH -e report/filter_mito.err
#SBATCH --time=30-00:00:00


mkdir -p results/bam_noMT

# Step 1: Index all BAMs
echo "Indexing BAM files..."
ls results/bam/*.bam | parallel -j 10 'samtools index {}'

# Step 2: Remove MT chromosome
echo "Filtering MT from BAMs..."
ls results/bam/*.bam | parallel -j 8 '
    keep=$(samtools idxstats {} | cut -f 1 | grep -v "^MT$")
    samtools view -@ 2 -b -h {} $keep > results/bam_noMT/{/.}_noMT.bam
'

# Step 3: Index the new BAMs
echo "Indexing BAMs without MT..."
ls results/bam_noMT/*.bam | parallel -j 8 'samtools index {}'

echo "Done!"
