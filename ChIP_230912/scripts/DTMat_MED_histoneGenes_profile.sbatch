#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="Profile_DEG"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/MED12-dTAG_S13.RPGC.bw bigwigs/MED14-dTAG_S16.RPGC.bw bigwigs/MED25-dTAG_S19.RPGC.bw \
bigwigs/MED12-CDK8i_S14.RPGC.bw bigwigs/MED14-CDK8i_S17.RPGC.bw bigwigs/MED25-CDK8i_S20.RPGC.bw \
bigwigs/MED12_S11.RPGC.bw bigwigs/MED14_S15.RPGC.bw bigwigs/MED25_S18.RPGC.bw \
-R reference_files/histone_genes.bed -b 3000 -m 5000 -a 3000 -o DT_matrix/matrix_MED_histoneGenes_profile.gz

plotProfile -m DT_matrix/matrix_MED_histoneGenes_profile.gz -out plots/Profile_MED_histoneGenes_grouped.pdf \
--samplesLabel "MED12-dTAG" "MED14-dTAG" "MED25-dTAG" "MED12-CDK8i" "MED14-CDK8i" "MED25-CDK8i" "MED12-DMSO" "MED14-DMSO" "MED25-DMSO" \
--plotTitle "Histone genes" --perGroup
