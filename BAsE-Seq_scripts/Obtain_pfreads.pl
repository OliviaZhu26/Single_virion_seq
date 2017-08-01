use warnings;
use strict;
### OBTAIN BARCODE-CONTAINING READ-PAIRS THAT SURVIVED FILTERING AND TRIMMING

my$line_number=0;my%pf;
open(R1,"$ARGV[0]")or die; #input R1_clipped3.fastq
while(my$line=<R1>){
	$line_number++;
 	if($line_number==1 && $line =~ /^(@.+?)\s/){$pf{$1}++;}
	if($line_number==4){$line_number=0;}
}close (R1);

my$pass_filter=0;$line_number=0;
my($line1,$line2,$line3,$line4);
open(READ2,">$ARGV[3]");
open(R2,"$ARGV[1]")or die; #input R2_clipped2.fastq
while (my $line = <R2>){$line_number++;
 	if($line_number==1&&$line=~/^(@.+?)\s/){
		$pf{$1}++;
		if($pf{$1}==2){$line1=$line;$pass_filter=1;}
	}
	if($line_number==2){$line2=$line;}
	if($line_number==3){$line3=$line;}
	if($line_number==4){$line4=$line;
		if ($pass_filter==1) {
			print READ2 "$line1$line2$line3$line4";
			$pass_filter=0;
		}$line_number=0;
	}
}close (R2);

my$count;$pass_filter=0;$line_number=0;
open(READ1,">$ARGV[2]");
open(R1,"$ARGV[0]")or die;
while(my$line=<R1>){$line_number++;
 	if ($line_number==1&&$line=~/^(@.+?)\s/) {
		if($pf{$1}==2){$line1=$line;$pass_filter=1;}
	}
	if($line_number==2){$line2=$line;}
	if($line_number==3){$line3=$line;}
	if($line_number==4){$line4=$line;
		if($pass_filter==1){
			print READ1 "$line1$line2$line3$line4";
			$pass_filter=0;$count++;
		}$line_number=0;
	}
}close (R1);

print "$count pass-filter read-pairs\n";
