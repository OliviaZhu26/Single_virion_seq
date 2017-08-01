#!/user/bin/perl
use warnings;
use strict;
#open OUT, "> $ARGV[1]" or die("Couldn't open $ARGV[1]\n");
#percentage mismatch in >8x bases (only count those)

my$mismatch=0;my$bases=0;
open(TXT, $ARGV[0]);
while(<TXT>){
    my$line=$_; chomp $line;
    my@reads=split('\t',$line);
    if($reads[3] > 8){
	$bases++;
	my@pos=split('',$reads[4]);
	my$mism=0;
	for(my$a=0;$a<@pos;$a++){
	    if(($pos[$a] ne '.')&&($pos[$a] ne ',')){$mism++;}
	}
	if(($mism/@pos)>0.8){$mismatch++;}
    }
}close(TXT);

my$percent=$mismatch/$bases;
print "$percent\t$mismatch\t$bases\n";
