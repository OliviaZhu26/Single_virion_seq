use warnings;
use strict;

### GENERATE LIST OF HIGH COVERAGE GENOMES ###

my $min_cov = $ARGV[0]; #minimum coverage per base
my $percent_cov = $ARGV[1]; #minimum percentage of genome at $min_cov
my $start = $ARGV[2]; #right-most forward priming position
my $end = $ARGV[3]; #left-most reverse priming position
my $size = $end-$start+1;

opendir(VCF, "./IndividualGenomeAlignments/vcf");
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
				my $coverage = $counts[0] + $counts[1] + $counts[2] + $counts[3];
				if ($position > $start && $position < $end && $coverage >= $min_cov) { #only look at coverage within amplicon, but exclude primer regions
					$count++;
				}
			}
		}
		if (defined($count)) {
			$count = $count/$size*100;
			if ($count >= $percent_cov) { 
				print "$barcode\n";
			}
		}
		close (BC);
	}
}
