#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="Profile_NfKB"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/INTS5-A2-untreated_S7.RPGC.bw bigwigs/INTS5-A2-TNFa_S8.RPGC.bw \
bigwigs/INTS5-A2-dTAG_S9.RPGC.bw bigwigs/INTS5-A2-dTAG-TNFa_S10.RPGC.bw \
-R reference_files/TNFa_FC2_DT.bed --beforeRegionStartLength 3000 --regionBodyLength 5000 --afterRegionStartLength 3000 --skipZeros \
-out DT_matrix/matrix_INTS5_TNFa_FC2_profile.gz

plotProfile -m DT_matrix/matrix_INTS5_TNFa_FC2_profile.gz -out plots/Profile_INTS5_TNFa_FC2.pdf \
--samplesLabel "INTS5-A2-untreated" "INTS5-A2-TNFa" "INTS5-A2-dTAG" "INTS5-A2-dTAG-TNFa" \
--plotTitle "genes w/TNFa FC > 2"

plotProfile -m DT_matrix/matrix_INTS5_TNFa_FC2_profile.gz -out plots/Profile_INTS5_TNFa_FC2_grouped.pdf \
--samplesLabel "INTS5-A2-untreated" "INTS5-A2-TNFa" "INTS5-A2-dTAG" "INTS5-A2-dTAG-TNFa" \
--plotTitle "genes w/TNFa FC > 2" --perGroup
