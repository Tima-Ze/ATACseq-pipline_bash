#!/bin/bash
#SBATCH -J fastqc
#SBATCH -D /data/scratch/timaz/atac
#SBATCH -o out.out
#SBATCH --partition=nowick
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=30-00:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=timaz@zedat.fu-berlin.de

fastqc $1 -o results/fastqc/

# execute by:cat filename.txt | parallel sbatch job.sh
#Filename.txt include fastq files names with their path
