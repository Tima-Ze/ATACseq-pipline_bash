#!/usr/bin/env bash
#SBATCH -J filter_dup
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH -o report/filter_dup.out
#SBATCH -e report/filter_dup.err
#SBATCH --time=30-00:00:00

mkdir -p results/bam_noDup
mkdir -p results/bam_noDup/dup_metrics

ls results/bam_noMT/*.bam | parallel -j 16 '
    sample=$(basename {} .bam_noMT.bam)
    rgid=${sample}
    rglb=lib1
    rgpl=ILLUMINA
    rgpu=unit1
    rgsm=${sample}

    picard AddOrReplaceReadGroups \
        I={} \
        O=results/bam_noMT/${sample}_rg.bam \
        RGID=$rgid \
        RGLB=$rglb \
        RGPL=$rgpl \
        RGPU=$rgpu \
        RGSM=$rgsm \
        VALIDATION_STRINGENCY=LENIENT

    picard MarkDuplicates \
        I=results/bam_noMT/${sample}_rg.bam \
        O=results/bam_noDup/${sample}_noDup.bam \
        M=results/bam_noDup/dup_metrics/${sample}_dup_metrics.txt \
        REMOVE_DUPLICATES=true \
        VALIDATION_STRINGENCY=LENIENT
'


