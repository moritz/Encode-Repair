use Test::More tests => 2;
use lib 'lib';
use charnames qw(:full);

BEGIN { use_ok('Encode::Fix', 'fix_double') or exit };

is fix_double("\xc3\x83\xc2\xa4"), "\N{LATIN SMALL LETTER A WITH DIAERESIS}",
   "can fix double-encoded a+diaeresis";
