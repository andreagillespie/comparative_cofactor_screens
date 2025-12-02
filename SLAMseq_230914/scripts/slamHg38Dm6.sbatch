#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/slam%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="slamdunk"
#SBATCH --partition=prod_med

module load slamdunk/0.2.4
module load fastqc/0.11.6
module load trimgalore/0.4.4

bname=`basename $1 _R1_001.fastq.gz`
rl=100
Ref=/data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/GRCh38BDGP6.reheaded.fa
utr=/data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/GRCh38BDGP6_3utr.bed

#mkdir slamout/${bname}

#fastqc -o fastqc/ $1

#trim_galore --fastqc -o trimmed_fastqs $1

srun -n 1 slamdunk all -r $Ref -b $utr -fb $utr -o slamout/${bname} -5 12 -n 100 -t 4 -m -mv 0.2 -mts -mbq 27 -rl $rl trimmed_fastqs/${bname}_R1_001_trimmed.fq.gz

srun -n 1 alleyoop collapse -o slamout/collapse/ -t 1 slamout/${bname}/count/*tcount.tsv &

srun -n 1 alleyoop snpeval -o slamout/${bname}/ -s slamout/${bname}/snp/ -r $Ref -b $utr -l $rl -t 1 slamout/${bname}/filter/*_slamdunk_mapped_filtered.bam &
srun -n 1 alleyoop rates -o slamout/${bname}/ -r $Ref -t 1 slamout/${bname}/filter/*_slamdunk_mapped_filtered.bam &
srun -n 1 alleyoop tccontext -o slamout/${bname}/ -r $Ref -t 1 slamout/${bname}/filter/*_slamdunk_mapped_filtered.bam &
srun -n 1 alleyoop tcperutrpos -o slamout/${bname}/ -r $Ref -b $utr -s slamout/${bname}/snp/ -l $rl -t 1 slamout/${bname}/filter/*_slamdunk_mapped_filtered.bam &
srun -n 1 alleyoop tcperreadpos -o slamout/${bname}/ -r $Ref -s slamout/${bname}/snp/ -l $rl -t 1 slamout/${bname}/filter/*_slamdunk_mapped_filtered.bam &
srun -n 1 alleyoop utrrates -o slamout/${bname}/ -r $Ref -l $rl -t 1 -b $utr slamout/${bname}/filter/*_slamdunk_mapped_filtered.bam &

wait
