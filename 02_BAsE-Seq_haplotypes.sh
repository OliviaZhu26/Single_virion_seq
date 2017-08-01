#!/bin/sh

#determine cutoffs for BAsE-Seq library (refer to QC figures where necessary)

minCov=$1  #coverage per base
percentCov=$2  #number of bases covered to minCov
startPos=$3  #start position of area being considered for haplotype
endpos=$4   #end position of area being considered for haplotype
Rlen=$5    #length of reference 
cutoff=$6  #SNV frequency cutoff
noGenomes=$7   #minimum number of haplotypes to constitute a well covered base across the population

echo "Retrieving high coverage genomes"
#Identify high coverage genomes (eg. at least 4 reads covering at least 50% of bases):
perl $SCRIPTPATH/high_cov_genomes.pl $minCov $percentCov $startPos $endPos > $1_BarcodeRef.txt
#Generate individual genome sequences (eg. minimum depth = 4; minimum concordance = 0.7):
perl $SCRIPTPATH/generate_consensus_seq.pl $minCov 0.7 individual_seq $RLen S7.1_BarcodeRef_4x_50.txt

echo "Identify SNVs and construct haplotypes"
#Obtain SNVs from individual genomes (eg. true SNV cutoff > 1%; "bad-call" cutoff = 1500 genomes):
###perl $SCRIPTPATH/snv_from_genomes.pl  $REFPATH IndividualGenomes/individual_seq/ $startPos $endPos $cutoff $noGenomes Indiv_SNV_raw.txt Indiv_SNV_filtered.txt
#Construct haplotypes from all genomes:
perl $SCRIPTPATH/haplo_list_all.pl $REFPATH SNVs_all.txt IndividualGenomes/individual_seq/ Indiv_haplo.txt
