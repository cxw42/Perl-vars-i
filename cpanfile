requires 'perl', '5.005005';

requires 'Carp';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};

on test => sub {
    requires 'Test::More';
};
