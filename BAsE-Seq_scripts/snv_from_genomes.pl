use warnings;
use strict;

#############################################################################################
##### SCAN EACH CONSENSUS SEQUENCE AND IDENTIFY VARIANT POSITIONS RELATIVE TO CONSENSUS #####
#############################################################################################

my $start = $ARGV[2]; #right-most forward priming position
my $end = $ARGV[3]; #left-most reverse priming position
my $bad_call = $ARGV[4]; # minimum number of genomes called to avoid "bad-call"
my $true_snv = $ARGV[5]; # "true SNV" frequency cutoff

### LOAD REFERENCE GENOME

my $ref;
open (REF, "$ARGV[0]") or die; #input bulk consensus genome in fasta
my $header = <REF>;
#local $/=undef;
while (<REF>) {
	$ref .= $_;
}
close (REF);

$ref =~ s/\R//g;
my @ref = split (//, $ref);
my %called_base;

### ITERATE THROUGH INDIVIDUAL GENOME SEQUENCES AND IDENTIFY SNVS

my ($count, $pos, %ref_freq, %alt_freq, %alt_allele, %alt_counts);

opendir(DIR, "$ARGV[1]"); #folder containing high-coverage individual genomes
my @files = readdir(DIR);
foreach my $file (@files) {
	if ($file =~ /.*?.txt/) {
		$count++;
		my @seq;
		open (FILE, "$ARGV[1]/$file") or die; 
		while (my $line = <FILE>) {
			if ($line =~ /(.*?)\n/) { 
				my $sequence = $1;
				@seq = split (//, $sequence);
			}
		}
		close (FILE);


		BASE: for (my $base = $start; $base < ($end<$#seq?$end-1:$#seq-1); $base++) { #avoid primer positions
			if ($seq[$base] eq 'N') {
				next BASE;
			}
			if ($seq[$base] eq $ref[$base]) {
				$ref_freq{$base}++;
			}
			if ($seq[$base] ne $ref[$base]) {
				$alt_freq{$base}++;
				push (@{$alt_allele{$base}}, $seq[$base]); 
			}
		}
	}
}
close (DIR);

### CALCULATE AND PRINT SNV FREQUENCIES BY POSITION

open (RAW, ">$ARGV[6]"); #output file for raw SNV frequencies
open (FILTERED, ">$ARGV[7]"); #output file for filtered SNVs

print RAW "base_pos\tReference\tSNV_freq\tpercent_genomes_called\tVariant\n";
print FILTERED "base_pos\tReference\tSNV_freq\tpercent_genomes_called\tVariant\n";

for (my $i = $start; $i < $end-1; $i++) {
	$pos = $i+1;
	unless (defined($ref_freq{$i})) {
		$ref_freq{$i} = 0;
	}
	unless (defined($alt_freq{$i})) {
		$alt_freq{$i} = 0;
	}
	my $called = $ref_freq{$i} + $alt_freq{$i};
 	my $called_percent = $called/$count*100;
 	$called_percent = sprintf("%.1f", $called_percent);
	if ($called == 0) { #positions with 0 called bases are designated as "no-call"
		print RAW "$pos\t$ref[$i]\tno-call\t0.0\n";
	}
 	if ($called != 0) {
 		my $snv = $alt_freq{$i}/$called*100;
	 	$snv = sprintf("%.3f", $snv);
		if ($called < $bad_call) { #positions with calls in $bad_call genomes are designated as "bad-call"
			print RAW "$pos\t$ref[$i]\tbad-call\t$called_percent\n";
		}
		if ($called >= $bad_call) {
			foreach (@{$alt_allele{$i}}) {
				$alt_counts{$_}++;
			}
			if (!%alt_counts) {
				print RAW "$pos\t$ref[$i]\t$snv\t$called_percent\n";
			}
		 	foreach my $key (keys %alt_counts) {
		 		if ($alt_counts{$key} == 1) {
		 			$alt_counts{$key} = 0; #ignore positions with only 1 discordant base call in all genomes
		 		}
		 		my $c = $alt_counts{$key}/$called*100;
		 		$c = sprintf("%.3f", $c);
				print RAW "$pos\t$ref[$i]\t$c\t$called_percent\t$key\n";
				if ($c > $true_snv) { 
					print FILTERED "$pos\t$ref[$i]\t$c\t$called_percent\t$key\n";
				}
		 	}
		}
		for (keys %alt_counts) {
			delete $alt_counts{$_};
		}
	 }
}
close (RAW);
close (FILTERED);
