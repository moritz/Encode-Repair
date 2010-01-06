use strict;
use warnings;
use Test::More tests => 5;
use Encode qw(encode);

use charnames qw(:full);
use Encode::Fix ();

my $str = "\N{LATIN SMALL LETTER A WITH DIAERESIS}";

my $res = Encode::Fix::learn_recoding(
        from        => encode('UTF-8', $str),
        to          => $str,
        encodings   => ['UTF-8', 'Latin-1'],
);

is_deeply $res, ['decode', 'UTF-8'], 'Can detect UTF-8 decoding';

$res = Encode::Fix::learn_recoding(
        from        => $str,
        to          => encode('UTF-8', $str),
        encodings   => ['UTF-8', 'Latin-1'],
);

is_deeply $res, ['encode', 'UTF-8'], 'Can detect UTF-8 encoding';

$res = Encode::Fix::learn_recoding(
        from        => "small ae: \xc3\x83\xc2\xa4",
        to          => "small ae: \N{LATIN SMALL LETTER A WITH DIAERESIS}",
        encodings   => ['UTF-8', 'Latin-1', 'Latin-7'],
);

#is_deeply $res, ['decode', 'UTF-8', 'encode', 'Latin-1', 'decode', 'UTF-8'], 
#          'Can detect double encoding via Latin-1';
is Encode::Fix::fix_encoding("small ae: \xc3\x83\xc2\xa4", $res),
    "small ae: \N{LATIN SMALL LETTER A WITH DIAERESIS}",
    'Can fix double encoding via Latin-1 with autodetection';

$res = Encode::Fix::learn_recoding(
        from        => "beta: \xc4\xaa\xc2\xb2",
        to          => "beta: \N{GREEK SMALL LETTER BETA}",
        encodings   => ['UTF-8', 'Latin-1', 'Latin-7'],
);

is_deeply $res, ['decode', 'UTF-8', 'encode', 'Latin-7', 'decode', 'UTF-8'],
          'Can detect double encoding via Latin-1';
is Encode::Fix::fix_encoding("beta: \xc4\xaa\xc2\xb2", $res),
   "beta: \N{GREEK SMALL LETTER BETA}",
    'Can fix double encoding via Latin-7 with autodetection';
