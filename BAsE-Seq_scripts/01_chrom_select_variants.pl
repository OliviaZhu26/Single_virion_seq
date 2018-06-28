#!/user/bin/perl
use warnings;
use strict;

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: 01_chrom_select_variants.pl
##Run as: perl $scriptpath/01_chrom_select_variants.pl aln-pe.$line.sorted.pileup >> 02_mismatches.txt 

my$mismatch=0;my$bases=0;
open(TXT, $ARGV[0]); #pileup file
while(<TXT>){
    my$line=$_; chomp $line;
    my@reads=split('\t',$line);
    if($reads[3] > 8){#for positions covered >8x
	$bases++;
	my@pos=split('',$reads[4]);
	my$mism=0;
	for(my$a=0;$a<@pos;$a++){
	    if(($pos[$a] ne '.')&&($pos[$a] ne ',')){$mism++;}
	}
	if(($mism/@pos)>0.8){$mismatch++;} #if over 80% of bases do not match reference, count as mismatch base
    }
}close(TXT);

my$percent=$mismatch/$bases;
print "$percent\t$mismatch\t$bases\n";
#print out % of all covered bases that do not match reference sequence
