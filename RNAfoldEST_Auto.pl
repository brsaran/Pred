#!usr/bin/perl
print "Enter File name:";
$input = <STDIN>;
open(FIL1,"$input");
@Seq_hold1 = <FIL1>;
my $i;
my $j;



for($i=1;$i<@Rawseq1;$i++){
	open(TTT,">$FASTA_File[$i]");
	print TTT $FASTA_Header[$i].$Rawseq1[$i];	
	close(TTT);
	$temp = $FASTA_File[$i];
	$temp=~s/\n//g;
	print $temp;
	$Output[$i] = `RNAfold< $temp`;

}

open(TTT,">Energy1.out");
print TTT @Output;
close(TTT);


