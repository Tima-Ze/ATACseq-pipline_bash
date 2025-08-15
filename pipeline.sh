
# Submit step 4: fastqc_trim_galore.sh
jid4=$(sbatch fastqc_trim_galore.sh | awk '{print $4}')
echo "Submitted fastqc_trim_galore.sh as job $jid4"

# Submit step 5: multiqc_trim_galore.sh
jid5=$(sbatch --dependency=afterok:$jid4 multiqc_trim_galore.sh | awk '{print $4}')
echo "Submitted multiqc_trim_galore.sh as job $jid5"
