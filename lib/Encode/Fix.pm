package Encode::Fix;
our $VERSION = '0.0.1';
use strict;
use warnings;

our @EXPORT_OK = qw(fix_double);
use Exporter qw(import);
use Encode qw(encode decode);

my %subs = (
    encode  => \&encode,
    decode  => \&decode,
);

sub fix_core {
    my ($str, $actions) = @_;
    for my $a (@$actions) {
        my ($type, $encoding) = @$a;
        $str = $subs{$type}->($encoding, $str);
    }
    $str;
}

sub fix_double {
    my ($buf, $options) = @_;
    my $via = 'ISO-8859-1';
    $via = $options->{via} if $options && exists $options->{via};
    fix_core($buf,
        [
            ['decode', 'UTF-8'],
            ['encode', $via],
            ['decode', 'UTF-8'],
        ]
    );
}

1;

=encoding utf-8

=head1 NAME

Encode::Fix - Repair wrongly encoded text strings

=head1 SYNOPSIS

    use Encode::Fix qw(fix_double);
    binmode STDOUT, ':encoding(UTF-8)';

    # prints: small ae: ä
    print fix_double("small ae: \xc3\x83\xc2\xa4\n");

    # prints: beta: β
    print fix_double("beta: \xc4\xaa\xc2\xb2\n", {via => 'Latin-7'});

=head1 DESCRIPTION

Sometimes software or humans mess up the character encoding of text. In some
cases it is possible to reconstruct the original text. This module helps you
to do it.

It covers the rather common case that a program assumes a wrong character
encoding on reading some input, and converts it to Mojibake (see
L<http://en.wikipedia.org/wiki/Mojibake>).

If you use this modul on a regular basis, it most likely indicates that
something is wrong in your processs. It should only be used for one-time tasks
such as migrating a database to a new system.

=head1 FUNCTIONS

=over

=item fix_double

Fixes the common case when a UTF-8 string was read as another encoding,
and was encoded as UTF-8 again. The other encoding defaults to ISO-8859-1 aka
Latin-1, and can be overridden with the C<via> option:

    my $fixed = fix_double($buffer, {via => 'ISO-8859-2' });

It expects a byte string as input, and returns a decoded text string.

=back


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2008, 2009 by Moritz Lenz, L<http://perlgeek.de/>,
moritz@faui2k3.org.

This is free software; you my use it under the terms of the Artistic License 2
as published by The Perl Foundation.

The code examples distributed with this package are an exception, and may be
used, modified and redistributed without any limitations.

Encode::Fix is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.

=head1 Development

The source code is stored in a public git repository at
L<http://github.com/moritz/Encode-Fix>. If you find any bugs, please used the
issue tracker linked from this site.

If you find a case of messed-up encodings that can be fixed deterministically
and that's not covered by this module, please contact the author, providing a
hex dump of both input and output, and as much information of the encoding and
decoding process as you have.

Patches are also very welcome.

=cut
