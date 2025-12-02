#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=80G
#SBATCH --output=logs/preprocess_%j.stdout
#SBATCH --time=0-23:00:0 
#SBATCH --job-name="ATAC_preprocessing"
#SBATCH --partition=prod_med
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH	--mail-user=andrea.gillespie@petermac.org

module purge
#module load samtools/1.9
module load samtools/1.4.1
module load trimgalore/0.4.4
module load bowtie2/2.3.4.1
module load picard/2.23.8

bname=`basename $1 _R1_001.fastq.gz`
dname=`dirname $1`

trim_galore --quality 20 --fastqc --gzip --output_dir trimmed_fastq --paired $1 ${dname}/${bname}_R2_001.fastq.gz

bowtie2 --very-sensitive -X 1000 -x /scratch/teams/dawson_genomics/Projects/CB_ChIP/CUTandTAG_221109/reference/CB_reference -1 trimmed_fastq/${bname}_R1_001_val_1.fq.gz -2 trimmed_fastq/${bname}_R2_001_val_2.fq.gz | samtools view -bS - >  bams/${bname}.bam

samtools sort -o bams/${bname}.sort.bam bams/${bname}.bam 

samtools index bams/${bname}.sort.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.bam O=bams/${bname}_dedup.bam M=bams/${bname}_dedup.txt REMOVE_DUPLICATES=true

samtools sort -o bams/${bname}_dedup_sort.bam bams/${bname}_dedup.bam

samtools idxstats bams/${bname}_dedup_sort.bam | cut -f 1 | grep -v M | xargs samtools view -b bams/${bname}_dedup_sort.bam > bams/${bname}_dedup_sort_nMT.bam

samtools view -b -F 4 bams/${bname}_dedup_sort_nMT.bam  > bams/${bname}_dedup_sort_nMTnU.bam

samtools view -b -q 20 bams/${bname}_dedup_sort_nMTnU.bam  > bams/${bname}_dedup_sort_nMTnU_MAPQ.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar CollectInsertSizeMetrics I=bams/${bname}_dedup_sort_nMTnU_MAPQ.bam O=bams/${bname}_insert_size_metrics.txt H=bams/${bname}_insert_size_histogram.pdf M=0.5

samtools index bams/${bname}_dedup_sort_nMTnU_MAPQ.bam


