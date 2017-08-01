use warnings;
use strict;

### ITERATE THROUGH EACH BASE POSITION IN THE REFERENCE TO GENERATE CONSENSUS BASE-CALLS

my $depth = $ARGV[0];
my $concordance = $ARGV[1];
my $folder = $ARGV[2];
my $length = $ARGV[3]; #length of reference consensus genome
my $call;
my $count;
my %ref; # list of high coverage barcodes

open (REF, "$ARGV[4]") or die; # file containing list of high coverage barcodes
while (my $line = <REF>) {
	 if ($line =~ /(\d+)\n/) {
		$ref{$1}++;
		$count++;
	}
}
print "Generating consensus sequences for $count genomes\nCurrently processing genome...\n";
$count = 0;

system "mkdir $folder";
opendir(VCF, "vcf/");
my @files = readdir(VCF);
foreach my $file (@files) {
	if ($file =~ /bc(\d+).vcf/) {
		if (defined($ref{$1})) {
		        my @genome = ('N')x$length;
			$count++;
			print "$count\n";
			open (SEQ, ">$folder/bc$1.txt");	
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
