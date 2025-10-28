#!/bin/bash
#SBATCH -J index
#SBATCH -o %x.out
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=30-00:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=timaz@zedat.fu-berlin.de

Ref_DIR=/data/scratch/timaz/atac/ref
export Ref_DIR

bowtie2-build --threads $SLURM_CPUS_PER_TASK ${Ref_DIR}/*.fa.gz
