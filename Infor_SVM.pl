#!usr/bin/perl

$input = @ARGV[0];
$Job = $ARGV[1];

open(FIL1,"$input");
my $i;
my $j;

while(($line1 = <FIL1>) && ($line2 = <FIL1>)){
	$Temp_file = $line1.$line2;
	$FnT = substr($line1,1,5);
	#print $File_nam_temp;
	open(TTT,">$FnT");
	print TTT $Temp_file;	
	close(TTT);
	$Output .= `RNAfold -noPS <$FnT`;
	`rm $FnT`;
	$j++;
#	print $j." completed\n";

}
	open(TTT,">$Job/Energy.out");
	print TTT $Output;
	close(TTT);



