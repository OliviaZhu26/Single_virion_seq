use warnings;
use strict;

my$cutoff=$ARGV[3]; #minimum number of read-pairs per barcode
my$REFNAME=$ARGV[4]; #reference name as stated in ref.fasta
my$REFLENGTH=$ARGV[5]; #reference length as in ref.fasta

### SPLIT SAM FILES INTO INDIVIDUAL GENOMES ###

my $line_number;
my %pf_id; # contains read ids for pass-filter reads

open (PF, "$ARGV[0]") or die; # input R2_clipped_pf.fastq
while (my $line = <PF>) {
	$line_number++;
 	if ($line_number == 1 && $line =~ /^@(.+?)\s/) {$pf_id{$1}++;}#print "$1\t".$pf_id{$1}."\n";}
	if ($line_number == 4) { $line_number = 0; }
}
close (PF);

my $id;
my %barcodes=(); # contains barcode sequence as key and array of pass-filter read ids as value
$line_number = 0;
my $pass_filter;

open (FASTQ, "$ARGV[1]") or die; #input $PREFX.barcoded_2.fastq
while (my $line = <FASTQ>) {
	$line_number++;
 	if ($line_number == 1 && $line =~ /^@(.+?)\s/) {
		$id = $1;
		if (defined($pf_id{$id})) {$pass_filter = 1;}
	}
	if ($line_number == 2 && $line =~ /^([ATCG]{20})CGAC/) {
		if ($pass_filter == 1) {
			push @{$barcodes{$1}}, $id;
			#print @{$barcodes{$1}};	
			#print "$1\t".$id."\n"; (hash of arrays)
		#store pass-filter read ids in an array for each barcode
		#GAGGGGCCACCACCGTCCTG	M00739:174:000000000-ACAV4:1:1107:12779:7512
		#AGTTTCCCCCCTCTTGAGCA	M00739:174:000000000-ACAV4:1:1107:20174:7512
		}
		$pass_filter = 0;
	}
	if ($line_number == 4) {$line_number = 0;}		
}
close (FASTQ);

%pf_id=();

my $header;
my %sam=();
open (SAM, "$ARGV[2]") or die; #input *_bwa_filtered_uniq.sam
while (my $line = <SAM>) {
	if ($line =~ /^(\@SQ.*\n)/) {$header = $1;}
	if ($line =~ /^(.+?)(\t.+)\n/) {
		my $entry = "$1$2";
		#print "$1\t$entry\n";
		push @{$sam{$1}}, $entry;
	}
}
close (SAM);

system "mkdir ./IndividualGenomes";
system "mkdir ./IndividualGenomes/sam";
open (BARCODE, ">IndividualGenomes/BarcodeReference.txt");	
print BARCODE "Barcodes with at least $cutoff read-pairs\n";
my $count;
foreach my $key (keys(%barcodes)) {
	if (scalar@{$barcodes{$key}} >= $cutoff) { #proceed with barcodes that have at least cutoff read-pairs
		$count++;
		print BARCODE "$count\t$key\n";
		print "Processing barcode $count: $key\n";	
		open (GENOMES, ">IndividualGenomes/sam/bc$count.sam");
		print GENOMES "\@SQ	SN:".$REFNAME."	LN:".$REFLENGTH."
#";
		foreach (@{$barcodes{$key}}) {
#			if (defined(@{$sam{$_}}) && (@{$sam{$_}} ne "")) {
			if (($sam{$_})&&(@{$sam{$_}} ne "")) {
				print GENOMES "@{$sam{$_}}[0]\n@{$sam{$_}}[1]\n";
			}
		}
		close (GENOMES);
	}
}
close (BARCODE);
