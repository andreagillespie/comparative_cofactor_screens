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
bigwigs/MED12-dTAG_S13.LFC.bw bigwigs/MED14-dTAG_S16.LFC.bw bigwigs/MED25-dTAG_S19.LFC.bw \
bigwigs/MED12-CDK8i_S14.LFC.bw bigwigs/MED14-CDK8i_S17.LFC.bw bigwigs/MED25-CDK8i_S20.LFC.bw \
-R reference_files/histone_genes.bed -b 3000 -m 5000 -a 3000 -o DT_matrix/matrix_MED_histoneGenes_LFC.gz

plotHeatmap -m DT_matrix/matrix_MED_histoneGenes_LFC.gz -out plots/Heatmap_LFC_MED_histoneGenes.pdf \
--samplesLabel "MED12-dTAG" "MED14-dTAG" "MED25-dTAG" "MED12-CDK8i" "MED14-CDK8i" "MED25-CDK8i" --heatmapHeight 5 \
--plotTitle "Histone genes" --regionsLabel "log2 fold change" --colorMap RdYlBu_r --sortUsingSamples 2 --sortUsing sum

plotProfile -m DT_matrix/matrix_MED_histoneGenes_LFC.gz -out plots/Profile_LFC_MED_histoneGenes_grouped.pdf \
--samplesLabel "MED12-dTAG" "MED14-dTAG" "MED25-dTAG" "MED12-CDK8i" "MED14-CDK8i" "MED25-CDK8i" \
--plotTitle "Histone genes" --perGroup

plotProfile -m DT_matrix/matrix_MED_histoneGenes_LFC.gz -out plots/ProfHeat_LFC_MED_histoneGenes_grouped.pdf \
--samplesLabel "MED12-dTAG" "MED14-dTAG" "MED25-dTAG" "MED12-CDK8i" "MED14-CDK8i" "MED25-CDK8i" \
--plotTitle "Histone genes" --perGroup --plotType heatmap --yMin -1 --yMax 1
