package Encode::Fix;
our $VERSION = '0.0.1';
use strict;
use warnings;

our @EXPORT_OK = qw(fix_double);
use Exporter qw(import);
use Encode qw(encode decode);

sub fix_double {
    my ($buf, $options) = @_;
    my $via = 'ISO-8859-1';
    $via = $options->{via} if $options && exists $options->{via};
    $buf = decode('UTF-8', $buf);
    $buf = encode($via, $buf);
    return decode('UTF-8', $buf);
}

1;
