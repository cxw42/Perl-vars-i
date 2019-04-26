# -*- perl -*-

# t/010__vars-i.t - module load and functional tests

# Do not `use strict` or else this file won't compile in the event of errors.
# Leaving off `use strict` permits us to use the more detailed test results.

use Test::More tests => 19;

use Acme::CXW::vars::i;     # Fatal if we can't load

    use Acme::CXW::vars::i '@BORG' => 6 .. 6;
    use Acme::CXW::vars::i '%BORD' => 1 .. 10;
    use Acme::CXW::vars::i '&VERSION' => sub(){rand 20};
    use Acme::CXW::vars::i '*SOUTH' => *STDOUT;
    use Acme::CXW::vars::i [
        '$VERSION' => sprintf("%d.%02d", q$Revision: 1.3 $ =~ /: (\d+)\.(\d+)/),
        '$REVISION'=> '$Id: GENERIC.pm,v 1.3 2002/06/02 11:12:38 _ Exp $',
    ];

BEGIN {
    # Use string eval + `use strict` to trap undefined variables
    ok(eval q[use strict; no warnings 'all'; @BORG; 1],
                q[use Acme::CXW::vars::i '@BORG' => 6 .. 6;]);
    is(@BORG, 1, q[is @BORG, 1]);
    is($BORG[0], 6, q[is $BORG[0], 6]);

    ok(eval q[use strict; no warnings 'all'; %BORD; 1],
                q[use Acme::CXW::vars::i '%BORD' => 1 .. 10;]);
    is(keys(%BORD), 5, q[is keys(%BORD), 5]);
    is($BORD{1}, 2, q[is $BORD{1}, 2]);
    is($BORD{3}, 4, q[is $BORD{3}, 4]);
    is($BORD{5}, 6, q[is $BORD{5}, 6]);
    is($BORD{7}, 8, q[is $BORD{7}, 8]);
    is($BORD{9}, 10, q[is $BORD{9}, 10]);

    is(defined(&VERSION),1, q[use Acme::CXW::vars::i '&VERSION' => sub(){rand 20};]);
    is(\&VERSION, \&VERSION, q[is \&VERSION, \&VERSION]);
    isnt(&VERSION, &VERSION, q[isnt &VERSION, &VERSION]);

    is(defined(*SOUTH),1,q[use Acme::CXW::vars::i '*SOUTH' => *STDOUT;]);
    is(*SOUTH, *STDOUT, q[use Acme::CXW::vars::i '*SOUTH' => *STDOUT;]);

    is(defined $VERSION, 1, q|use Acme::CXW::vars::i [...];|);
    is($VERSION, 1.03, q[is $VERSION, 1.3]);

    is(defined $REVISION, 1, q|use Acme::CXW::vars::i [...];|);
    is($REVISION, '$Id: GENERIC.pm,v 1.3 2002/06/02 11:12:38 _ Exp $', q[is $REVISION, '$Id: GENERIC.pm,v 1.3 2002/06/02 11:12:38 _ Exp $']);

}

#perl -lne"print qq|is($2, $3, q[$1]);| if /(use Acme::CXW::vars::i '([^']+)' => (.*?);)$/" >2
#is( $VERSION, 3.44, q[use Acme::CXW::vars::i '$VERSION' => 3.44;]);
