use Test::More tests => 4;
use lib 'lib';
use charnames qw(:full);

BEGIN { use_ok('Encode::Fix', 'fix_double') or exit };

is fix_double("small ae: \xc3\x83\xc2\xa4"), "small ae: \N{LATIN SMALL LETTER A WITH DIAERESIS}",
   "can fix double-encoded a+diaeresis";

is fix_double("\xc3\x83\xc2\xa4", {via => 'Latin1'}),
   "\N{LATIN SMALL LETTER A WITH DIAERESIS}",
   "can fix double-encoded a+diaeresis with explicit latin1 'via'";

is fix_double("beta: \xc4\xaa\xc2\xb2", {via => 'Latin-7'}),
   "beta: \N{GREEK SMALL LETTER BETA}",
   "double-encoded beta via Latin-7 (Greek)";
