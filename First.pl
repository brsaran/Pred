!#usr/bin/perl



my $JN,$FIN;

$JN = $ARGV[1];
$FIN = $ARGV[0];

#Create Job folder

`mkdir $JN`;
#&BLASTN('input',10, 18);
&TripletSVM($FIN,$JN);



sub BLASTN{

my $seq = $_[0];
my $Eval = $_[1];
my $wordSz = $_[2];
my $BOut = `blastn -query $seq -db MMiRNA -evalue $Eval -outfmt "10 qseqid qstart qend qseq" -word_size $wordSz`;

open(FILE,">Water_in");
print FILE $BOut;

}

sub BLASTX{
my $seq = $_[0];
my $Eval = $_[1];
my $wordSz = $_[2];


}

sub TripletSVM{

#Generate input for SVM
my $seq_fi = $_[0];
my $job = $_[1];
my $x,$y;

`perl Infor_SVM.pl $seq_fi $job`;

#Run for libsvm input
`perl triplet_svm_classifier.pl $job/Energy.out $job/libsvm.dat 22`;
`mv 1.txt $job/1.txt`;
`mv 2.txt $job/2.txt`;

open(FILE,"$job/libsvm.dat");

while ($x = <FILE>){
	$y.= "1 ".$x;
}

close(FILE);
open(FILE,">$job/libsvm.dat");
print FILE $y;
close(FILE);
$y="";

#Run model

`./svm-predict $job/libsvm.dat svm.model $job/SVM_out`;

#Map ID
my ($ln1,$ln2,$ln3,@idk,$sew,$i);

open(FILE,"$job/2.txt");
open(FILE1,"$job/SVM_out");
@idk = <FILE1>; $i=0;

while (($ln1 = <FILE>) && ($ln2 =<FILE>) && ($ln3 = <FILE>)){
	$sew.= $ln1.$ln2;
	$ln1=~s/\s//g;
	$idk[$i] = $ln1.",".$idk[$i];
	$i++;
}

close(FILE);
close(FILE1);

open(FILE,">$job/SVM_out");
print FILE @idk;
close(FILE);

open(FILE,">$job/SVM_FASTA");
print FILE $sew;
close(FILE);

#RNAFOld

`RNAfold < $job/SVM_FASTA > $job/PreCur_Energy.out`;
`mv *.ps $job/`;
 
}


sub generate_random_string
{
        my $length_of_randomstring=shift;# the length of
                 # the random string to generate

        my @chars=('a'..'z','A'..'Z','0'..'9');
        my $random_string;
        foreach (1..$length_of_randomstring)
        {
                # rand @chars will generate a random
                # number between 0 and scalar @chars
                $random_string.=$chars[rand @chars];
        }
        return $random_string;
}
