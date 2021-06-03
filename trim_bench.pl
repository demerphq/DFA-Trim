use strict;
use warnings;
use Benchmark qw(cmpthese timethese :hireswallclock);
use Test::More;
use blib;
use Data::Dumper;
use DFA::Trim qw(trimmed);
use Char::Replace qw(trim);
my $base= 'naive';
my @extra= qw(separate loop2 trimmed);
my %extra= map { $_ => 1 } @extra;
my $bm_time= $ENV{CHECK} ? 100000 : -1;

my @keys= ($base,@extra);

$|++;
printf "%6s %6s %1s %1s %4s %3s %3s|%10s|".("%10s %10s|" x @extra)."\n", 
    "blen","clen","S","U", "reps","ns","sp", $base."/s", map { $_."/s" , "as pct nv" } @extra;
printf "%.6s-%.6s-%.1s-%.1s-%.4s-%.3s-%.3s+%.10s+".("%.10s-%.10s+" x @extra)."\n",
    ("-" x 10) x (8+2*@extra);

sub naive {
    my ($str)= @_;
    $str=~s/\A\s+|\s+\z//g;
    return $str;
}

sub separate {
    my ($str)= @_;
    $str=~s/\A\s+//;
    $str=~s/\s+\z//;
    return $str;
}

sub loop2 {
    my ($str)= @_;
    $str=~s/\A\s+//; 
    1 while 
    $str=~s/\s{16}\z//; 
    $str=~s/\s{8}\z//; 
    $str=~s/\s{4}\z//; 
    $str=~s/\s{2}\z//; 
    $str=~s/\s{1}\z//; 
    return $str;
}


foreach my $ns_len (1,2,5,10,25,100) {
    foreach my $sp_len (1,2,5,10,25,100) {
        foreach my $segments (1,10,100,1000) {
            foreach my $unicode (0,1) {
                foreach my $as_sub (0,1) {
                    my $descr= "as_sub: $as_sub unicode: $unicode segments: $segments non-space length: $ns_len space length: $sp_len";
                    my $sp= $unicode ? "\x{1680}" : " ";
                    my $ns= $unicode ? "\x{100}" : "x";
                    my $string= ($sp x $sp_len) . ((($ns x $ns_len) . ($sp x $sp_len))x$segments);
                    my $utf8_string= $string;
                    utf8::encode($utf8_string);
                    my ($naive,$separate,$loop2,$trimmed,$trim);
                    #diag "timing $descr\n";
                    my $clen= length $string;
                    my $blen= length $utf8_string;

                    my %sub;
                    if ($as_sub) {
                        $sub{naive}= sub {
                            $naive= naive($string); 
                            return; 
                        };
                        $sub{separate}= sub {
                            $separate= separate($string);
                            return;
                        };
                        $sub{loop2}= sub{
                            $loop2= loop2($string);
                            return;
                        };
                    } else {
                        $sub{naive}= sub {
                            $naive= $string; 
                            $naive=~s/\A\s+|\s+\z//g;  
                            return;
                        };
                        $sub{separate}= sub {
                            $separate= $string; 
                            $separate=~s/\A\s+//; 
                            $separate=~s/\s+\z//; 
                            return;
                        };
                        $sub{loop2}= sub {
                            $loop2= $string; 
                            $loop2=~s/\A\s+//; 
                            1 while 
                            $loop2=~s/\s{16}\z//; 
                            $loop2=~s/\s{8}\z//; 
                            $loop2=~s/\s{4}\z//; 
                            $loop2=~s/\s{2}\z//; 
                            $loop2=~s/\s{1}\z//; 
                            return;
                        };
                    }
                    $sub{trimmed}= sub {
                        $trimmed= trimmed($string);
                        return;
                    };
                    $sub{trim} = sub {
                        $trim= Char::Replace::trim($string);
                        return;
                    };

                    my %run;
                    $run{naive}= $sub{naive};
                    $run{$_}= $sub{$_} for @extra;

                    my $r= timethese($bm_time, \%run, "none");
                    my @key= ($blen,$clen,$as_sub,$unicode,$segments,$ns_len,$sp_len);
                    my %rps;
                    my $max;
                    my $max_name;
                    foreach my $name (@keys) {
                        $rps{$name}= $r->{$name}->iters/$r->{$name}->real;
                        if (!defined $max or $max < $rps{$name}) {
                            $max= $rps{$name};
                            $max_name= $name;
                        }
                    }
                    my @data;
                    foreach my $name (@keys) {
                        my $fmt= $name eq $max_name ? "+" : "";
                        push @data, sprintf "%$fmt.1f",$rps{$name};
                        push @data, sprintf "%$fmt.1f",$rps{$name}/$rps{naive}*100
                            if $name ne "naive";
                    }
                    printf "%6d %6d %1d %1d %4d %3d %3d|%10s|". ("%10s %10s|" x @extra) . "\n", @key, @data;
                    if ($ENV{CHECK}) {
                        ok($naive,"naive is true");
                        ok($naive eq $separate,"naive and separate are the same")
                            if $extra{separate};
                        ok($naive eq $loop2,"naive and loop2 are the same")
                            if $extra{loop2};
                        ok($naive eq $trim,"naive and Char::Replace::trim are the same")
                            if $extra{trim};
                        ok($naive eq $trimmed,"naive and DFA::Trim::trimmed are the same")
                            if $extra{trimmed};
                    }
                }
            }
        }
    }
}
