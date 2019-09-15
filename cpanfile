requires 'perl', '5.006001';

requires 'Carp';

on build => sub {
    requires 'ExtUtils::MakeMaker';
};

on test => sub {
    requires 'Import::Into', '1.002005';
    requires 'IO::Handle';
    requires 'lib::relative', '1.000';
    requires 'Test::More';
};

# vi: set ft=perl: #
