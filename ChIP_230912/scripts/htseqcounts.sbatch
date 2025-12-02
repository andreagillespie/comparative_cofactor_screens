#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_short
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=0-02:00:00
#SBATCH --output=logs/htseqcounts%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="htseqcounts"

module load htseq/0.11.2

bname=`basename $1 .sort.dedup.bam`

htseq-count -f bam -r pos -s no -t gene $1 /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf > counts/${bname}.count

