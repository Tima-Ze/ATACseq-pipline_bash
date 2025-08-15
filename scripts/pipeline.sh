#!/usr/bin/env bash
set -euo pipefail

# Submit step 0: mkdir.sh
jid0=$(sbatch mkdir.sh | awk '{print $4}')
echo "Submitted mkdir.sh as job $jid0"

# Submit step 1: fastqc.sh
jid1=$(sbatch fastqc.sh | awk '{print $4}')
echo "Submitted fastqc.sh as job $jid1"

# Submit step 2: check_pairs.sh
jid2=$(sbatch check_pairs.sh | awk '{print $4}')
echo "Submitted check_pairs.sh as job $jid2"

# Submit step 3: trim_galore.sh
jid3=$(sbatch --dependency=afterok:$jid2 trim_galore.sh | awk '{print $4}')
echo "Submitted trim_galore.sh as job $jid3"

# Submit step 2: trimmomatic.sh
#jid3=$(sbatch --dependency=afterok:$jid2 trimmomatic.sh | awk '{print $4}')
#echo "Submitted trimmomatic.sh as job $jid3"

# Submit step 2: cutadapt.sh
#jid3=$(sbatch --dependency=afterok:$jid2 cutadapt.sh | awk '{print $4}')
#echo "Submitted cutadapt.sh as job $jid3"

# Submit step 4: fastqc_trim_galore.sh
jid4=$(sbatch --dependency=afterok:$jid3 fastqc_trim_galore.sh | awk '{print $4}')
echo "Submitted fastqc_trim_galore.sh as job $jid4"

# Submit step 5: multiqcqc_trim_galore.sh
jid5=$(sbatch --dependency=afterok:$jid4 multiqcqc_trim_galore.sh | awk '{print $4}')
echo "Submitted multiqcqc_trim_galore.sh as job $jid5"

# Submit step 6: bowtie_map.sh
jid6=$(sbatch --dependency=afterok:$jid5 bowtie_map.sh | awk '{print $4}')
echo "Submitted bowtie_map.sh as job $jid6"
