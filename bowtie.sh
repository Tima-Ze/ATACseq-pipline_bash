#!/usr/bin/env bash
#SBATCH -J Bowtie2
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=125G
#SBATCH -o report/bowtie.out
#SBATCH -e report/bowtie.err
#SBATCH --time=30-00:00:00


mkdir -p results/bowtie2
mkdir -p results/bam

awk '{
    split($1, a, "/"); minus_val1 = a[length(a)]; gsub(/\.fastq\.gz$/, "_val_1.fq.gz", minus_val1)
    split($2, b, "/"); plus_val2  = b[length(b)]; gsub(/\.fastq\.gz$/, "_val_2.fq.gz", plus_val2)
    sample     = $3
    print minus_val1, plus_val2, sample
}' pairs_list.txt | 
parallel --colsep ' ' -j 5 '
    val1={1}
    val2={2}
    sample={3}

    echo "Running Bowtie2 for $sample"

    bowtie2 -x ref/index \
            -1 results/trim_galore/"$val1" \
            -2 results/trim_galore/"$val2" \
            -p 5 \
            --very-sensitive \
    | samtools view -u - \
    | samtools sort -o "results/bam/${sample}.bam" -
'

