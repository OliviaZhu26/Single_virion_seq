use warnings;
use strict;

### positions covered > X per barcode
my$DIRECTORY=$ARGV[0];
my$CUTOFF=$ARGV[1];
my$OUTFILE=$DIRECTORY."/IndividualGenomes/Cov_per_barcode_".$CUTOFF.".txt"; #print "$OUTFILE\n";

open OUT,">> $OUTFILE" or die $!;
opendir(SAM, "$DIRECTORY/IndividualGenomes/pileup/");
my @files = readdir(SAM);
foreach my $file (@files) {#print "$file\n";
    if ($file =~ /pileup/) {#print "$file\n";
	my$count=0;
	open(R1,"IndividualGenomes/pileup/$file") or die;
	while(my$line=<R1>){	
	    my@data=split('\t',$line);
	    if($data[3] > $CUTOFF){$count++;}
	}
	print OUT "$count\t$file\n";
    }
}



