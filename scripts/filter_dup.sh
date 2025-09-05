#!/usr/bin/env bash
#SBATCH -J filter_dup
#SBATCH -D /data/scratch/timaz/atac
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10G
#SBATCH -o report/filter_dup.out
#SBATCH -e report/filter_dup.err
#SBATCH --time=30-00:00:00
#SBATCH --array=1-41%25

mkdir -p results/bam_noDup
mkdir -p results/bam_noDup/dup_metrics

bam=$(ls results/bam_noMT/*.bam | sed -n ${SLURM_ARRAY_TASK_ID}p)
sample=$(basename "$bam" .fastq.gz_noMT.bam)

# Define tmpdir
tmpdir="results/bam_noDup/tmp_${sample}"
mkdir -p "$tmpdir"

# Tell Spark/GATK to use it
export SPARK_LOCAL_DIRS=$tmpdir
export TMPDIR=$tmpdir

samtools addreplacerg \
    -r ID:$sample -r LB:lib1 -r PL:ILLUMINA -r PU:unit1 -r SM:$sample \
    $bam -o "$tmpdir/${sample}_rg.bam"

gatk --java-options "-Djava.io.tmpdir="$tmpdir"" MarkDuplicatesSpark \
    -I "$tmpdir/${sample}_rg.bam" \
    -O results/bam_noDup/${sample}_noDup.bam \
    -M results/bam_noDup/dup_metrics/${sample}_dup_metrics.txt \
    --remove-all-duplicates true \
    --tmp-dir "${tmpdir}" \
    --spark-runner LOCAL \
    --spark-master local[8]
	--conf spark.local.dir="$tmpdir"
	--verbosity ERROR
	
rm -rf "$tmpdir"
