use warnings;
use strict;

## Author: Lewis Hong and ZHU O. Yuan
## Script name: high_cov_genomes.pl
## GENERATE LIST OF HIGH COVERAGE GENOMES
## Run as perl $SCRIPTPATH/high_cov_genomes.pl $minCov $percentCov $startPos $endPos > BarcodeRef_4x_50.txt

my $min_cov = $ARGV[0]; #minimum coverage per base [4]
my $percent_cov = $ARGV[1]; #minimum percentage of genome at $min_cov [0-100]
my $start = $ARGV[2]; #right-most forward priming position
my $end = $ARGV[3]; #left-most reverse priming position
my $size = $end-$start+1; #size of region being called

opendir(VCF, "./IndividualGenomeAlignments/vcf"); #retrieve VCF files from lofreq
#formatted for lofreq output that provides information on all bases regardless of SNP call, modifications required for other vcf files or if lofreq changes vcf format
my @files = readdir(VCF);
foreach my $file (@files) {
	my $count;
	if ($file =~ /bc(\d+).vcf/) {
		my $barcode = $1;
		open (BC, "./IndividualGenomeAlignments/vcf/$file") or die; 
		while (my $line = <BC>) {
			if ($line =~ /^.*?\t(\d+).+DP4=(.*?);/) {
				my $position = $1;
				my @counts = split (/,/, $2);
				#counts total coverage for snp position
				my $coverage = $counts[0] + $counts[1] + $counts[2] + $counts[3];
				#if base is within region being called and over coverage requirement, count as a covered base
				if ($position > $start && $position < $end && $coverage >= $min_cov) { #only look at coverage within amplicon, but exclude primer regions
					$count++;
				}
			}
		}
		if (defined($count)) {
			#if % bases called > required, print as pass filter
			$count = $count/$size*100;
			if ($count >= $percent_cov) { 
				print "$barcode\n";
			}
		}
		close (BC);
	}
}
