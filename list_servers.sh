ec2-describe-instances | perl -F\\t -anle 'if ($F[0] eq "INSTANCE") { $x{$F[1]} = [@F]; } elsif ($F[0] eq "TAG") { if ($F[4] eq "Encryption Server") { print $x{$F[2]}[3], "\t", $F[2]; } }' | cut -f 1
