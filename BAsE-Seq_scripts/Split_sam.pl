use warnings;
use strict;

## Authors: Lewis HONG and ZHU O. Yuan
## Script Obtain_barcode.pl
## SPLIT SAM FILES INTO INDIVIDUAL GENOMES (FOLDERS)
## Run as: perl $SCRIPTPATH/Split_sam.pl $DATAPATH/$PREFX.barcoded_2_clipped_pf.fastq $DATAPATH/$PREFX.barcoded_2.fastq $DATAPATH/$PREFX.filtered.unique.sam $READSPERBRCD $REFNAME $REFLEN
## Additional output files: BarcodeReference.txt

my$cutoff=$ARGV[3]; #minimum number of read-pairs per barcode
my$REFNAME=$ARGV[4]; #reference name as stated in ref.fasta
my$REFLENGTH=$ARGV[5]; #reference length as in ref.fasta

my $line_number; #tracks line number
my %pf_id; # contains read ids for pass-filter reads

#stores read ID for passed filter, clipped, barcode removed reads
open (PF, "$ARGV[0]") or die; #$PREFX.barcoded_2_clipped_pf.fastq
while (my $line = <PF>) {
	$line_number++;
 	if ($line_number == 1 && $line =~ /^@(.+?)\s/) {$pf_id{$1}++;}
	if ($line_number == 4) { $line_number = 0; }
}
close (PF);

my $id; #read ID variable
my %barcodes=(); # to store barcode sequences as key and arrays of pass-filter read ids as value
$line_number = 0; #line number tracker
my $pass_filter; #pass_filter tracker

#retrieves barcode sequences for passed filter, clipped, barcode removed reads
#stores all reads carrying the same barcode in an array within a hash of barcodes
open (FASTQ, "$ARGV[1]") or die; #input $PREFX.barcoded_2.fastq
while (my $line = <FASTQ>) {
	$line_number++;
 	if ($line_number == 1 && $line =~ /^@(.+?)\s/) {
		$id = $1; #sanity check to make sure mate read exists
		if (defined($pf_id{$id})) {$pass_filter = 1;}
	}
	if ($line_number == 2 && $line =~ /^([ATCG]{20})CGAC/) { #extract barcode sequence
		if ($pass_filter == 1) {
			push @{$barcodes{$1}}, $id;
			#store pass-filter read ids in an array for each barcode
		}
		$pass_filter = 0;
	}
	if ($line_number == 4) {$line_number = 0;}		
}
close (FASTQ);

#retrieve uniquely mapped sam file information and store in hash
%pf_id=();
my $header;
my %sam=();
open (SAM, "$ARGV[2]") or die; #input *_bwa_filtered_uniq.sam
while (my $line = <SAM>) {
	if ($line =~ /^(\@SQ.*\n)/) {$header = $1;}
	if ($line =~ /^(.+?)(\t.+)\n/) {
		my $entry = "$1$2";
		push @{$sam{$1}}, $entry;
	}
}
close (SAM);

#create individual sam files for each barcode
system "mkdir ./IndividualGenomes";
system "mkdir ./IndividualGenomes/sam";
#create file to summarize reads per barcode identified
open (BARCODE, ">IndividualGenomes/BarcodeReference.txt");	
print BARCODE "Barcodes with at least $cutoff read-pairs\n";
my $count;
foreach my $key (keys(%barcodes)) { #for every stored barcode
	if (scalar@{$barcodes{$key}} >= $cutoff) { #proceed with barcodes that have at least $cutoff read-pairs
		$count++; #tracking number for every barcode
		print BARCODE "$count\t$key\n"; #output to BarcodeReference.txt
		print "Processing barcode $count: $key\n";
		open (GENOMES, ">IndividualGenomes/sam/bc$count.sam"); #create sam file for barcode
		print GENOMES "\@SQ	SN:".$REFNAME."	LN:".$REFLENGTH."#"; #sam header
		foreach (@{$barcodes{$key}}) { #print sam body
			if (($sam{$_})&&(@{$sam{$_}} ne "")) { #if read ID exists in sam file
				print GENOMES "@{$sam{$_}}[0]\n@{$sam{$_}}[1]\n";
			}
		}
		close (GENOMES);
	}
}
close (BARCODE);

# example BarcodeReference.txt output (barcode number and sequence, with matching sam files named bc1.sam etc.)
# line 1// Barcodes with at least 50 read-pairs
# line 2// 1	AAAGAATTC...
# ...
