package #Hide from PAUSE
    Kit;
use 5.006001;
use strict;
use warnings;
use Import::Into;
use Test::More;

use parent 'Exporter';

our @EXPORT;
BEGIN { @EXPORT=qw(eval_dies_ok eval_dies_like eval_is); }

=head1 NAME

Kit - vars::i test kit

=head1 SYNOPSIS

Test helpers.  These make it easier to trap undefined variables using string
eval and C<use strict>.

=head1 FUNCTIONS

=head2 eval_dies_ok

    eval_dies_ok "Code string" [, "message"];

Runs the code string; tests that the code died.

=cut

sub eval_dies_ok {
    eval $_[0];
    ok($@, $_[1] || ('Died as expected: ' . $_[0]));
}

=head2 eval_dies_like

    eval_dies_like "Code string", qr/regex/ [, "message"];

Runs the code string; tests that the code threw an exception matching C<regex>.

=cut

sub eval_dies_like {
    eval $_[0];
    like($@, $_[1], $_[2] || ('Died with exception matching ' . $_[1]));
}

=head2 eval_is

    eval_is '$Package::var', value [, "message"];

Tests that C<$Package::var> exists, and that C<$Package::var eq value>.

=cut

sub eval_is {
    my ($varname, $expected, $msg) = @_;
    $msg ||= "$varname eq $expected";
    my ($sigil, $package, $basename) = ($varname =~ m/^(.)(.+)::([^:]+)$/);
    die "Invalid varname $varname" unless $package && $varname;

    my $got = eval qq[do { package $package; use strict; $sigil$basename }];

    is($@, '', "Accessed $varname");
    is($got, $expected, $msg);
} #eval_var_is

=head2 import

Exports the functions using L<Exporter> --- all functions are exported by
default.  Also loads L<Test::More> into the caller.

=cut

sub import {
    my $target = caller;
    __PACKAGE__->export_to_level(1, @_);
    Test::More->import::into($target);
}
