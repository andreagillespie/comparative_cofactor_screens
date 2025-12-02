#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --output=logs/postprocess_%j.stdout
#SBATCH --time=0-02:00:0 
#SBATCH --job-name="ATAC_postprocessing"
#SBATCH --partition=prod_short
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH	--mail-user=andrea.gillespie@petermac.org

module purge
module load samtools/1.4.1
module load igvtools/2.3.95

bname=`basename $1 .sort.bam`

samtools index bams/bin_100/${bname}_sort_100bp.bam

samtools index bams/bin_180_247/${bname}_sort_180_247.bam

samtools index bams/bin_315_473/${bname}_sort_315_473.bam

samtools index bams/bin_558_615/${bname}_sort_558_615.bam

# remake tdfs with charlies reference chrom.sizes file
igvtools count bams/bin_100/${bname}_sort_100bp.bam tdfs/bin_100/${bname}_sort_100bp.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes

igvtools count bams/bin_180_247/${bname}_sort_180_247.bam tdfs/bin_180_247/${bname}_sort_180_247.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes

igvtools count bams/bin_315_473/${bname}_sort_315_473.bam tdfs/bin_315_473/${bname}_sort_315_473.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes

igvtools count bams/bin_558_615/${bname}_sort_558_615.bam tdfs/bin_558_615/${bname}_sort_558_615.tdf /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference.chrom.sizes
