use strict;
use warnings;
use Test::More tests => 2;
use Encode qw(encode);

use charnames qw(:full);
use Encode::Fix ();

my $str = "\N{LATIN SMALL LETTER A WITH DIAERESIS}";

my $res = Encode::Fix::learn_recoding_process(
        from        => encode('UTF-8', $str),
        to          => $str,
        encodings   => ['UTF-8', 'Latin-1'],
);

is_deeply $res, ['decode', 'UTF-8'], 'Can detect UTF-8 decoding';

$res = Encode::Fix::learn_recoding_process(
        from        => $str,
        to          => encode('UTF-8', $str),
        encodings   => ['UTF-8', 'Latin-1'],
);

is_deeply $res, ['encode', 'UTF-8'], 'Can detect UTF-8 encoding';
