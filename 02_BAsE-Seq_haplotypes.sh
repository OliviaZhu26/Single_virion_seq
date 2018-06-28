#!/bin/sh

##Author: Lewis Hong and ZHU O. Yuan
##Script name: 02_BAsE-Seq_haplotypes.sh
##BAsE-Seq pipeline script part 02 to generate consensus sequences for each barcode
##Run as ./02_Base_seq_haplotype.sh 4 50 59 3198 3215 1 1500

##Calls scripts: (please refer to individual scripts for details)
# high_cov_genomes.pl
# generate_consensus_seq.pl
# haplo_list_all.pl

minCov=$1  #coverage per base required for base call
percentCov=$2  #percentage of bases covered to minCov for barcode sequence to be retained as a usable genome
startPos=$3  #start position of area being considered for haplotype wrt reference genome
endpos=$4   #end position of area being considered for haplotype wrt teference genome
Rlen=$5    #length of reference genome
cutoff=$6  #SNV frequency cutoff
noGenomes=$7   #minimum number of haplotypes to constitute a well covered base across the population

echo "Retrieving high coverage genomes"
#Identify high coverage genomes (eg. at least 4 reads covering at least 50% of bases):
perl $SCRIPTPATH/high_cov_genomes.pl $minCov $percentCov $startPos $endPos > BarcodeRef_4x_50.txt
#Generate individual genome sequences (eg. minimum depth = 4; minimum concordance = 0.7):
perl $SCRIPTPATH/generate_consensus_seq.pl $minCov 0.7 $RLen BarcodeRef_4x_50.txt > ConsensusSeqs.txt
