use warnings;
use strict;

## Author: Lewis HONG and ZHU O. Yuan
## Script name: high_cov_genomes.pl
## ITERATE THROUGH EACH BASE POSITION IN THE REFERENCE TO GENERATE CONSENSUS SEQUENCES
## Run as: perl $SCRIPTPATH/generate_consensus_seq.pl $minCov 0.7 $RLen BarcodeRef_4x_50.txt > ConsensusSeqs.txt

my $depth = $ARGV[0];
my $concordance = $ARGV[1]; #percentage of bases required at a position to call a consensus base
my $length = $ARGV[2]; #length of reference consensus genome
my $call;
my $count;
my %ref; # list of high coverage barcodes

open (REF, "$ARGV[3]") or die; # file containing list of high coverage barcodes
while (my $line = <REF>) {
	 if ($line =~ /(\d+)\n/) {
		$ref{$1}++; #store barcode number for consensus calling
		$count++;
	}
}
print "Generating consensus sequences for $count genomes\nCurrently processing genome...\n";
$count = 0;

opendir(VCF, "vcf/");
my @files = readdir(VCF);
foreach my $file (@files) {
	if ($file =~ /bc(\d+).vcf/) {
		if (defined($ref{$1})) {
		        my @genome = ('N')x$length; #generate array to hold consensus sequence
			$count++;
			print ">bc$1\n"; #fasta header for consensus sequence	
			open (FILE, "vcf/$file") or die;
			while (my $line = <FILE>) {
			  my @line = split (/\t/,$line);
			  next if ($line =~ /^#/);     # ignore comments
			  next if ($line =~ /INDEL/);  # ignore indels
			  next if ($line[4] =~ /,/ );  # ignore ambiguous base
			  if ($line =~ /DP4=(\d+,\d+,\d+,\d+);/ ) {
			    my @counts = split (/,/, $1);			    
			    my $coverage = $counts[0] + $counts[1] + $counts[2] + $counts[3];
			    my $ref_frac = ($counts[0] + $counts[1])/$coverage;
			    #use coverahe cutoff to determine base call at position
			    $genome[$line[1]-1] = $line[3] if ($coverage >= $depth && $ref_frac >= $concordance);
			    $genome[$line[1]-1] = $line[4] if ($coverage >= $depth && $ref_frac <= 1-$concordance);
			  }
			}
			close (FILE);
			print SEQ join('', @genome), "\n";
			close (SEQ);
		}
	}
}
