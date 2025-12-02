#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --output=logs/postprocess_%j.stdout
#SBATCH --time=0-16:00:0 
#SBATCH --job-name="ATAC_postprocessing"
#SBATCH --partition=prod_med
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH	--mail-user=andrea.gillespie@petermac.org

module purge
module load samtools/1.4.1
module load igvtools/2.3.95

bname=`basename $1 _dedup_sort_nMTnU_MAPQ.bam`

#igvtools count bams/${bname}_dedup_sort_nMTnU_MAPQ.bam tdfs/${bname}_dedup_sort_nMTnU_MAPQ.tdf hg19

#samtools view -h bams/${bname}_dedup_sort_nMTnU_MAPQ.bam |LC_ALL=C awk -f scripts/filter_below.awk |samtools view -Sb - > bams/${bname}_dedup_sort_nMTnU_MAPQ_150bp.bam

#igvtools count bams/${bname}_dedup_sort_nMTnU_MAPQ_150bp.bam tdfs/${bname}_dedup_sort_nMTnU_MAPQ_150bp.tdf hg19

#samtools index bams/${bname}_dedup_sort_nMTnU_MAPQ_150bp.bam

#samtools index bams/${bname}_dedup_sort.bam

#igvtools count bams/${bname}_dedup_sort.bam tdfs/${bname}_dedup_sort.tdf hg19

#samtools view -h bams/${bname}_dedup_sort.bam |LC_ALL=C awk -f scripts/filter_below.awk |samtools view -Sb - > bams/${bname}_dedup_sort_150bp.bam

#igvtools count bams/${bname}_dedup_sort_150bp.bam tdfs/${bname}_dedup_sort_150bp.tdf hg19

#samtools index bams/${bname}_dedup_sort_150bp.bam

# remake tdfs with charlies reference chrom.sizes file
igvtools count bams/${bname}_dedup_sort.bam tdfs/${bname}_dedup_sort.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes

igvtools count bams/${bname}_dedup_sort_150bp.bam tdfs/${bname}_dedup_sort_150bp.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes

igvtools count bams/${bname}_dedup_sort_nMTnU_MAPQ.bam tdfs/${bname}_dedup_sort_nMTnU_MAPQ.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes

igvtools count bams/${bname}_dedup_sort_nMTnU_MAPQ_150bp.bam tdfs/${bname}_dedup_sort_nMTnU_MAPQ_150bp.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes
