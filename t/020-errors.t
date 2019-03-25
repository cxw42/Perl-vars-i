# -*- perl -*-

# t/020-errors.t - tests of invalid input

# Do not `use strict` or else this file won't compile in the event of errors.
# Leaving off `use strict` permits us to use the more detailed test results.

use Test::More;

use Acme::CXW::vars::i;     # Fatal if we can't load

#    use Acme::CXW::vars::i '@BORG' => 6 .. 6;
#    use Acme::CXW::vars::i '%BORD' => 1 .. 10;
#    use Acme::CXW::vars::i '&VERSION' => sub(){rand 20};
#    use Acme::CXW::vars::i '*SOUTH' => *STDOUT;
#    use Acme::CXW::vars::i [
#        '$VERSION' => sprintf("%d.%02d", q$Revision: 1.3 $ =~ /: (\d+)\.(\d+)/),
#        '$REVISION'=> '$Id: GENERIC.pm,v 1.3 2002/06/02 11:12:38 _ Exp $',
#    ];

# Use string eval + `use strict` to trap undefined variables
sub eval_dies_ok {
    eval $_[0];
    ok($@, $_[1] || ('Died as expected: ' . $_[0]));
}

# Bad sigils
eval_dies_ok q[ use Acme::CXW::vars::i '~BADSIGIL' => 1; ];
eval_dies_ok q[ use Acme::CXW::vars::i 'NOSIGIL' => 1; ];

# Elements of aggregates
eval_dies_ok q[ use Acme::CXW::vars::i '$array[0]' => 1; ];
eval_dies_ok q[ use Acme::CXW::vars::i '$hash{0}' => 1; ];

# Special variables
eval_dies_ok q[ use Acme::CXW::vars::i '$0' => 1; ];
eval_dies_ok q[ use Acme::CXW::vars::i '$1' => 1; ];
eval_dies_ok q[ use Acme::CXW::vars::i '$!' => 1; ];
eval_dies_ok q[ use Acme::CXW::vars::i '$^H' => 1; ];
eval_dies_ok q[ use Acme::CXW::vars::i '${^Foo}' => 1; ];

done_testing();
