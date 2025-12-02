#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_med
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-12:00:00
#SBATCH --output=../../logs/CnRt_post%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="cnrt_post"

module load samtools/1.8
module load igvtools/2.3.95

bname=`basename $1 _aligned_reads.bam`

samtools sort -o ${bname}.sort.bam $1

samtools index ${bname}.sort.bam

igvtools count ${bname}.sort.bam ${bname}.tdf hg19
