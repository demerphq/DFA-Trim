use strict;
use warnings;
use Data::Dumper;
use Text::Wrap qw(wrap);

sub add_trie {
    my ($str,$root)= @_;
    $root ||={};
    my $node= $root;
    foreach my $char (split //, $str) {
        $node= ($node->{$char} ||= {});
    }
    $node->{''}= $str;
    return $root;
}

sub _convert_trie_to_array {
    my ($node, $array)= @_;
    my @ch= grep length, sort keys %$node;
    if (exists $node->{''}) {
        die "This should be a leaf!" if @ch;
        return 1;
    } else {
        my $state= [(0) x 256];
        push @$array, $state;
        my $id= @$array;
        foreach my $ch (@ch) {
            $state->[ord($ch)]= _convert_trie_to_array($node->{$ch}, $array);
        }
        return $id;
    }
}

sub convert_trie_to_array {
    my ($node)= @_;
    my @states;
    _convert_trie_to_array($node,\@states);
    return \@states;
}

sub transition_array {
    my ($states)= @_;
    my @transition;
    my @owner;
    my @offset=(0,0);

    push @transition, @{$states->[0]};
    push @owner, map { $_ ? 1 : 0 } @{$states->[0]};

    foreach my $state_idx (1..$#$states) {
        my $state= $states->[$state_idx];
        my $offset= 0;
        OFFSET:
        while ($offset < @transition) {
            for my $i (0..255) {
                if ($transition[$offset+$i] and $state->[$i]) {
                    $offset++;
                    next OFFSET;
                }
            }
            last;
        }
        $offset[$state_idx+1]= $offset;
        foreach my $i (0..255) {
            $transition[$offset+$i]||=0;
            $owner[$offset+$i]||=0;
            if ($state->[$i]) {
                die "bad mojo: offset=$offset i=$i", Dumper(\@transition,\@owner) 
                    if $transition[$offset+$i] or $owner[$offset+$i];
                $transition[$offset+$i]= $state->[$i];
                $owner[$offset+$i]= $state_idx+1;
            }
        }
    }
    return { transition => \@transition, owner => \@owner, offset => \@offset };
}

sub array_decl {
    my ($type,$name,$array)= @_;
    my $len= 0+@$array;
    return wrap "", "    ", "const $type $name\[$len]= { " . join(", ", @$array). " };\n";
}
sub print_decls {
    my ($root,$type,$prefix)=@_;
    my $struct= transition_array(convert_trie_to_array($root));
    print array_decl($type,$prefix . "_offset",$struct->{offset});
    print array_decl($type,$prefix . "_owner",$struct->{owner});
    print array_decl($type,$prefix . "_trans",$struct->{transition});
}

# these are the codepoints that match /\s/ in uncode.

my @cp= (9,10,11,12,13,32,5760,8192,8193,8194,8195,8196,8197,8198,8199,8200,8201,8202,8232,8233,8239,8287,12288);

my $all_cp;
my %trie;
my %rtrie;
my @ascii= (0) x 256;
foreach my $cp (@cp) {
    my $char= chr($cp);
    $ascii[$cp]= 1 if $cp < 256;
    utf8::encode($char);
    $all_cp .= $char;
    add_trie($char,\%trie);
    add_trie(scalar reverse($char),\%rtrie);
}

print_includes();
print_decls(\%trie,uint16_t => "lr");
print_decls(\%rtrie,uint16_t => "rl");
print array_decl(uint8_t => "latin_1", \@ascii);
print_subs($all_cp);

sub print_subs {
    my ($all_cp)= @_;
    $all_cp= '"'.join("", map { sprintf "\\%03o", ord $_ } split //, $all_cp). '"';

print <<"END_OF_C";

char * 
find_ltrim_pos(char *start, char *end) {
    uint16_t state=1;
    char *ptr= start;
    char *ret= start;
    uint8_t ch;
    uint16_t base;
    
    while (ptr < end ) {
        uint8_t ch= (uint8_t)*ptr;
        base= lr_offset[state];
        if (lr_owner[base+ch] != state || !(state= lr_trans[base+ch])) {
            return ret;
        }
        ptr++;
        if (state == 1) {
            ret= ptr;
        }
    }
    return NULL;
}

char *
find_rtrim_pos(char *start, char *end) {
    uint16_t state=1;
    char *ret= end;
    char *ptr= end;
    uint8_t ch;
    uint16_t base;
    
    while (start < ptr) {
        ptr--;
        ch= (uint8_t)*ptr;
        base= rl_offset[state];
        if (rl_owner[base+ch] != state || !(state= rl_trans[base+ch])) {
            return ret;
        }
        if (state == 1) {
            ret= ptr;
        }
    }
    return NULL;
}

int
main (int argc, char **argv)
{
    char *string= $all_cp "    foo   \\n\\n " $all_cp "\\n     ";
    char *end= string + strlen(string);

    char *lpos= find_ltrim_pos(string,end);
    char *rpos= find_rtrim_pos(string,end);
    printf("string: %p lpos: %p rpos: %p end: %p len: %d str: '%.*s'\\n", 
        string, lpos, rpos, end,
        (int)(rpos-lpos),(int)(rpos-lpos), lpos);
}
END_OF_C
}

sub print_includes {
    print <<EOF_C;
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <assert.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <byteswap.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <argp.h>
#include <strings.h>

#include <xmmintrin.h>
#include <immintrin.h>
EOF_C
}
