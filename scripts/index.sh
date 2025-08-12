#!/bin/bash
#SBATCH -J index
#SBATCH -D /data/scratch/timaz/atac
#SBATCH -o out.out
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=30-00:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=timaz@zedat.fu-berlin.de
bowtie2-build --threads 8 ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz ref/index
