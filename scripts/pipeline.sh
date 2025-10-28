#!/usr/bin/env bash
set -euo pipefail

# Submit mkdir.sh
jid0=$(sbatch mkdir.sh | awk '{print $4}')

# Submit fastqc_fastq.sh
jid1=$(sbatch fastqc_fastq.sh | awk '{print $4}')

# Submit trim_galore.sh
jid2=$(sbatch trim_galore.sh | awk '{print $4}')

# Submit fastqc_trim_galore.sh
jid3=$(sbatch --dependency=afterok:$jid2 fastqc_trim_galore.sh | awk '{print $4}')

#bowtie_map.sh
jid4=$(sbatch --dependency=afterok:$jid3 bowtie_map.sh | awk '{print $4}')
