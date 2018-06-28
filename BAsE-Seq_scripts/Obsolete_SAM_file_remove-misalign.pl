#!/user/bin/perl
use warnings;
use strict;
#reads in sam files from graphmap/bwasw and removes forced indels
#perl SAM_file_remove-misalign.pl Base_seq_haplotypes.sam > Base_seq_haplotypes_corrected.sam

open(TXT, $ARGV[0]);
while(my$lee=<TXT>){
    chomp $lee;
    if($lee =~ /@/){print "$lee\n";}
    else{
	my@str=split('\t',$lee);
	$str[3]=1;$str[5]=length($str[9])."M";
	$str[10]="";my@lulu=split('',$str[9]);
	for(my$c=0;$c<length($str[9]);$c++){
	    if($lulu[$c] ne "N"){$str[10]=$str[10]."K";}
	    else{$str[10]=$str[10]."B";}
	}
	print "$str[0]";
	for(my$b=1;$b<11;$b++){print "\t$str[$b]";}
	print "\n";
    }
}close(TXT);

