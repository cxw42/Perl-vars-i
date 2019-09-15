# -*- perl -*-

# t/040-options.t - tests related to options (which are not yet implemented!)

use strict;
use warnings;
use lib::relative '.';
use Kit;

use vars::i;     # Fatal if we can't load

test_arrayref_to_vars_i();
test_hashref_to_vars_i();
test_option_in_hashref();
test_option_in_arrayref();

done_testing();

# --- The tests ----------------------------------------------------------

sub test_arrayref_to_vars_i {   # A sanity check
    eval q[{
        package MY::TestArrayRefToVarsI;
        use vars::i [
            '$answer' => 42,
            '$string' => 'Hello',
        ];
    }];
    is($@, '', 'use vars::i ARRAYREF');
    eval_is '$MY::TestArrayRefToVarsI::answer', 42;
    eval_is '$MY::TestArrayRefToVarsI::string', 'Hello';
} #test_arrayref_to_vars_i

sub test_hashref_to_vars_i {    # Same as arrayref, but a hashref
    eval q[{
        package MY::TestHashRefToVarsI;
        use vars::i +{
            '$answer' => 43,
            '$string' => 'Hello!',
        };
    }];
    is($@, '', 'use vars::i HASHREF');
    eval_is '$MY::TestHashRefToVarsI::answer', 43;
    eval_is '$MY::TestHashRefToVarsI::string', 'Hello!';
} #test_hashref_to_vars_i

sub test_option_in_hashref {
    eval_dies_like q[{
        package MY::TestOptionInHashref;
        use vars::i +{
            '-NONEXISTENT_OPTION' => 'value',
            '$answer' => 43,
            '$string' => 'Hello!',
        };
    }], qr/option/;
} #test_option_in_hashref

sub test_option_in_arrayref {
    eval_dies_like q[{
        package MY::TestOptionInArrayref;
        use vars::i [
            '-NONEXISTENT_OPTION' => 'value',
            '$answer' => 43,
            '$string' => 'Hello!',
        ];
    }], qr/option/;
} #test_option_in_arrayref

=for comment

sub test_no_value_provided {
    eval q[{
        package MY::Test1;
        use vars::i '$VAR';     # no value
        use vars::i '$WITH_VALUE', 42;
    }];
    is($@, '', 'Compiles `use` without value OK ');

    # A sanity check.  Note: `package` is required since `use strict`
    # always permits package-qualified names.
    my $val = eval q[do { package MY::Test1; use strict; $WITH_VALUE }];
    is($@, '', 'Can access variable in package');
    ok($val == 42, 'Variable value was set correctly');

    # Now make sure the use..'$VAR' line had no effect
    eval q[{
        package MY::Test1;
        use strict; no warnings 'all';
        $VAR;   # Shouldn't exist
    }];
    ok($@, '`use` without value did not create var');
} #test_no_value_provided()

sub test_arrayref_value {
    eval q[{
        package MY::Test2;
        use vars::i [
            '@VAR' => [1..3],
        ];
    }];
    is($@, '', 'Created @VAR ok');

    my @val = eval q[do { package MY::Test2; use strict; @VAR }];
    is($@, '', 'Can access @VAR');
    is($val[$_-1], $_, "val $_ OK") for 1..3;

} #test_arrayref_value()

sub test_hashref_value {
    eval q[{
        package MY::Test3;
        use vars::i [
            '%VAR' => {1..4},
        ];
    }];
    is($@, '', 'Created %VAR ok');

    my %val = eval q[do { package MY::Test3; use strict; %VAR }];
    is($@, '', 'Can access %VAR');
    is($val{$_}, $_+1, "val $_ OK") for (1,3);
} #test_hashref_value()

sub test_inject_var {
    eval q[{
        package MY::Test4;
        use vars::i '$MY::Oddball::InjectedVar' => 42;
    }];
    is($@, '', 'Created InjectedVar OK');

    my $val = eval '$InjectedVar';
    is($@, '', 'Can access InjectedVar');
    is($val, 42, 'InjectedVar set OK');
} #test_inject_var()

=cut

