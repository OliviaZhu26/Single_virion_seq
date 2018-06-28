use warnings;
use strict;

#############################################################################################
############# DETERMINE HAPLOTYPES BASED ON FILTERED SNVS (ALL GENOMES) ##################
#############################################################################################

### LOAD REFERENCE GENOME

my $ref;
open (REF, "$ARGV[0]") or die; #input HBV reference sequence in fasta
my $header = <REF>;
while (<REF>) {
	$ref .= $_;
}
close (REF);

$ref =~ s/\R//g;
my @ref = split (//, $ref);

### LOAD FILTERED SNVS

my $snv_count; #number of filtered SNVs
my %snv;
open (SNV, "$ARGV[1]") or die; #input filtered SNV file (position in column 1, variant base in column 2)
while (my $line = <SNV>) {
	if ($line =~ /^(\d+)\t(\w+)\n/) {
		my $pos = $1 - 1;
		$snv{$pos} = $2; 
		$snv_count++; 
	}
}
close (SNV);
# print out the consensus.
open (CONSENSUS, ">consensus.txt") or die;
print CONSENSUS ">reference\n";
for (sort {$a <=> $b} keys %snv) {
    print CONSENSUS "$ref[$_]";
}
print CONSENSUS "\n";
close(CONSENSUS);
print "$snv_count filtered SNVs...\n";

### ITERATE THROUGH EACH CONSENSUS SEQUENCE AND COUNT UNIQUE HAPLOTYPES

my ($called, $genomes, %haplo);

open (HAP, ">$ARGV[3]"); #output file for haplotypes
opendir(DIR, "$ARGV[2]"); #folder containing high-coverage consensus sequences
my @files = readdir(DIR);
foreach my $file (@files) {
	if ($file =~ /.*?.txt/) {
		$genomes++;
		my @seq;
		open (FILE, "$ARGV[2]/$file") or die; 
		while (my $line = <FILE>) {
			if ($line =~ /(.*?)\n/) { 
				my $sequence = $1;
				@seq = split (//, $sequence);
			}
		}
		close (FILE);
		my $hap = "";
		for (sort {$a <=> $b} keys %snv) {
			$called = 0;
			if ($seq[$_] eq $ref[$_]) {
				$hap = $hap.".";
				$called = 1;
			}
			if ($seq[$_] ne $ref[$_]) { #FIXME: this is too slow
				my $base = $_ + 1;
				open (SNV, "$ARGV[1]") or die; #input filtered SNV file
				while (my $line = <SNV>) {
					if ($line =~ /^($base)\t($seq[$_])\n/) { #verify that variant base is present in filtered SNV file
						$hap = $hap.$seq[$_];
						$called = 1;
					}
				}
			}
			if ($called == 0) {
				$hap = $hap."N";
			}
		}
		$haplo{$hap}++;
	}
}
print "$genomes haplotypes reported\n";

foreach my $key (sort {$haplo{$b} <=> $haplo{$a}} keys %haplo) {
	print HAP "$key\t$haplo{$key}\n";
}
