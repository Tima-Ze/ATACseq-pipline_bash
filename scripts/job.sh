#!/usr/bin/env bash
set -euo pipefail


# Submit step 3: trim_galore.sh
jid3=$(sbatch trim_galore.sh | awk '{print $4}')
echo "Submitted trim_galore.sh"

# Submit step 4: fastqc_trim_galore.sh
jid4=$(sbatch --dependency=afterok:$jid3 fastqc_trim_galore.sh | awk '{print $4}')
echo "Submitted fastqc_trim_galore.sh"

# Submit step 6: bowtie_map.sh
jid6=$(sbatch --dependency=afterok:$jid4 bowtie_map.sh | awk '{print $4}')
echo "Submitted bowtie_map.sh"
