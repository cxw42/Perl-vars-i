# I basically took vars.pm, and turned it into vars/i.pm

package vars::i;
use 5.006;

our $VERSION = '1.05'; # TRIAL

# yuck
=for IT DOESN'T WORK nor is it important (try perl -Mstrict -Mwarnings=all -We"use vars q[$a];")
BEGIN {
    eval q{
use warnings::register;
    };
    eval q{
sub warnings::enabled { return $^W; }
    } if $@;
}
=cut

use strict qw(vars subs);

sub import {
    return if @_ < 2;
    my( $pack, $var, @value ) = @_;
    my $callpack = caller;

    my %stuff;

    if( not @value ){
        if( ref $var ){
            %stuff = @$var;
        } else {
            return;     # No value given --- no-op; not an error.
        }
    } else {
        %stuff = ( $var, [@value] );
    }

    for my $k( keys %stuff ){
        $var = $k;
        if( ref $stuff{$k} eq 'ARRAY' ){
            @value = @{ $stuff{$k} };
        }
        elsif( ref $stuff{$k} eq 'HASH' ){
            @value = %{ $stuff{$k} };
        }
        else {
            @value = $stuff{$k};
        }


        if( my( $ch, $sym ) = $var =~ /^([\$\@\%\*\&])(.+)$/ ){
            if( $sym !~ /^(\w+(::|'))+\w+$/ && $sym =~ /\W|(^\d+$)/ ){
                #    ^^ Skip fully-qualified names  ^^ Check special names

                # A variable name we can't or won't handle
                require Carp;

                if( $sym =~ /^\w+[[{].*[]}]$/ ){
                    Carp::croak("Can't declare individual elements of hash or array");
                }
                elsif( $sym =~ /^(\d+|\W|\^[\[\]A-Z\^_\?]|\{\^[a-zA-Z0-9]+\})$/ ){
                    Carp::croak("Refusing to initialize special variable $ch$sym");
                }
                else {
                    Carp::croak("I can't recognize $ch$sym as a variable name");
                }
            }

            $sym = "${callpack}::$sym" unless $sym =~ /::/;

            if( $ch eq '$' ){
                *{$sym} = \$$sym;
                (${$sym}) = @value;
            }
            elsif( $ch eq '@' ){
                *{$sym} = \@$sym;
                (@{$sym}) = @value;
            }
            elsif( $ch eq '%' ){
                *{$sym} = \%$sym;
                (%{$sym}) = @value;
            }
            elsif( $ch eq '*' ){
                *{$sym} = \*$sym;
                (*{$sym}) = shift @value;
            }
            else {   # $ch eq '&'; guaranteed by the regex above.
                *{$sym} = shift @value;
            }
            # There is no else, because the regex above guarantees
            # that $ch has one of the values we tested.

        } else {    # Name didn't match the regex above
            require Carp;
            Carp::croak("'$var' is not a valid variable name");
        }
    }
};

1;
__END__

=head1 NAME

vars::i - Perl pragma to declare and simultaneously initialize global variables.

=head1 SYNOPSIS

    use Data::Dumper;
    $Data::Dumper::Deparse = 1;

    use vars::i '$VERSION' => 3.44;
    use vars::i '@BORG' => 6 .. 6;
    use vars::i '%BORD' => 1 .. 10;
    use vars::i '&VERSION' => sub(){rand 20};
    use vars::i '*SOUTH' => *STDOUT;

    BEGIN {
        print SOUTH Dumper [
            $VERSION, \@BORG, \%BORD, \&VERSION
        ];
    }

    use vars::i [ # has the same effect as the 5 use statements above
        '$VERSION' => 3.66,
        '@BORG' => [6 .. 6],
        '%BORD' => {1 .. 10},
        '&VERSION' => sub(){rand 20},
        '*SOUTH' => *STDOUT,
    ];

    print SOUTH Dumper [ $VERSION, \@BORG, \%BORD, \&VERSION ];

    __END__

=head1 DESCRIPTION

For whatever reason, I once had to write something like

    BEGIN {
        use vars '$VERSION';
        $VERSION = 3;
    }

and I really didn't like typing that much.  With this package, I can say:

    use vars::i '$VERSION' => 3;

and get the same effect.

Also, I like being able to say

    use vars::i '$VERSION' => sprintf("%d.%02d", q$Revision: 1.3 $ =~ /: (\d+)\.(\d+)/);

    use vars::i [
     '$VERSION' => sprintf("%d.%02d", q$Revision: 1.3 $ =~ /: (\d+)\.(\d+)/),
     '$REVISION'=> '$Id: GENERIC.pm,v 1.3 2002/06/02 11:12:38 _ Exp $',
    ];

Like with C<use vars;>, there is no need to fully qualify the variable name.
However, you may if you wish.

=head1 NOTES

=over

=item *

Specifying a variable but not a value will succeed silently, and will B<not>
create the variable.  E.g., C<use vars::i '$foo';> is a no-op.

=item *

Trying to create a special variable is fatal.  E.g., C<use vars::i '$@', 1;>
will die at compile time.

=back

=head1 SEE ALSO

See L<vars>, L<perldoc/"our">, L<perlmodlib/Pragmatic Modules>.

=head1 MINIMUM PERL VERSION

This version supports Perl 5.6+.  If you are running an earlier Perl,
use version 1.01 of this module (PODMASTER/vars-i-1.01).

=head1 AUTHORS

D.H aka PodMaster, plus code from CXW.

Please use http://rt.cpan.org/ to report bugs (there shouldn't be any ;p).

Just go to http://rt.cpan.org/NoAuth/Bugs.html?Dist=vars-i to see
a bug list and/or report new ones.

=head1 LICENSE

Copyright (c) 2003 by D.H. aka PodMaster.  Portions copyright (c) 2019 by Chris
White.  All rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. If you don't know what this means,
visit http://perl.com/ or http://cpan.org/.

=cut
