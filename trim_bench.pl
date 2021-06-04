use strict;
use warnings;
use Benchmark qw(cmpthese timethese :hireswallclock);
use Test::More;
use blib;
use Data::Dumper;
use DFA::Trim qw(trimmed fast_trimmed);
use Char::Replace qw(trim);
my $base= 'naive';
my @extra= qw(trimmed ftrimmed);
my %extra= map { $_ => 1 } @extra;
my $bm_time= $ENV{CHECK} ? 100000 : -1;

my @sub_names= ($base,@extra);

$|++;
printf "%6s %6s %1s %1s %4s %3s %3s|%12s|".("%12s %12s|" x @extra)."\n", 
    "blen","clen","S","U", "reps","ns","sp", $base."/s", map { $_."/s" , "as pct nv" } @extra;
printf "%.6s-%.6s-%.1s-%.1s-%.4s-%.3s-%.3s+%.12s+".("%.12s-%.12s+" x @extra)."\n",
    ("-" x 12) x (8+2*@extra);

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

my @all_keys; # each element is a hash of the conditions (keys) for the test
my %all_rps;  # each hash key contains an array of per second execution time.

my @try_lens= (1,5,10,50,100);
my @try_segments= (1,5,10,50,100);
my @try_unicode=(0,1);
my @try_as_sub=(0,1);

foreach my $ns_len (@try_lens) {
    foreach my $sp_len (@try_lens) {
        foreach my $segments (@try_segments) {
            foreach my $unicode (@try_unicode) {
                foreach my $as_sub (@try_as_sub) {
                    my $descr= "as_sub: $as_sub unicode: $unicode segments: $segments non-space length: $ns_len space length: $sp_len";
                    my $sp= $unicode ? "\x{1680}" : " ";
                    my $ns= $unicode ? "\x{100}" : "x";
                    my $string= ($sp x $sp_len) . ((($ns x $ns_len) . ($sp x $sp_len))x$segments);
                    my $utf8_string= $string;
                    utf8::encode($utf8_string);
                    my ($naive,$separate,$loop2,$trimmed,$trim,$ftrimmed);
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
                    $sub{ftrimmed}= sub {
                        $ftrimmed= fast_trimmed($string);
                        return;
                    };
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
                    my %key= (
                              blen=>$blen,
                              clen=>$clen,
                              as_sub=>$as_sub,
                              unicode=>$unicode, 
                              segments=>$segments, 
                              ns_len=>$ns_len, 
                              sp_len=>$sp_len,
                              const =>1,
                          );
                    push @all_keys,\%key;
                    my %rps;
                    my $max;
                    my $max_name;
                    foreach my $name (@sub_names) {
                        $rps{$name}= $r->{$name}->iters/$r->{$name}->real;
                        push @{$all_rps{$name}}, $rps{$name};
                        if (!defined $max or $max < $rps{$name}) {
                            $max= $rps{$name};
                            $max_name= $name;
                        }
                    }
                    my @data;
                    foreach my $name (@sub_names) {
                        my $fmt= $name eq $max_name ? "+" : "";
                        push @data, sprintf "%$fmt.1f",$rps{$name};
                        push @data, sprintf "%$fmt.1f",$rps{$name}/$rps{naive}*100
                            if $name ne "naive";
                    }
                    printf "%6d %6d %1d %1d %4d %3d %3d|%12s|". ("%12s %12s|" x @extra) . "\n", @key, @data;
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
                        ok($naive eq $ftrimmed,"naive and DFA::Trim::fast_trimmed are the same")
                            if $extra{ftrimmed};
                    }
                }
            }
        }
    }
}
use Statistics::Regression;
foreach my $name (@sub_names) {
    my $r= Statistics::Regression->new($name, ['const','segments','ns_len','sp_len','as_sub','unicode','blen','clen']);
    foreach my $i (0..$#all_keys) {
        my $val= $all_rps{$name}[$i];
        my $key= $all_keys[$i];
        $r->include($all_rps{$name}[$i],$all_keys[$i]);
    }
    $r->print();
}
