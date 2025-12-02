#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --output=logs/ATACbins_%j.stdout
#SBATCH --time=0-02:00:0 
#SBATCH --job-name="ATAC_bins"
#SBATCH --partition=prod_short
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH	--mail-user=andrea.gillespie@petermac.org

module purge
module load samtools/1.4.1

bname=`basename $1 .sort.bam`

samtools view -h $1 |LC_ALL=C awk -f scripts/filter_below_100.awk |samtools view -Sb - > bams/bin_100/${bname}_sort_100bp.bam

samtools view -h $1 |LC_ALL=C awk -f scripts/filter_180_247.awk |samtools view -Sb - > bams/bin_180_247/${bname}_sort_180_247.bam

samtools view -h $1 |LC_ALL=C awk -f scripts/filter_315_473.awk |samtools view -Sb - > bams/bin_315_473/${bname}_sort_315_473.bam

samtools view -h $1 |LC_ALL=C awk -f scripts/filter_558_615.awk |samtools view -Sb - > bams/bin_558_615/${bname}_sort_558_615.bam
