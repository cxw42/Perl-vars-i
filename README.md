# NAME

Acme::CXW::vars::i - Perl pragma to declare and simultaneously initialize global variables.

# SYNOPSIS

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

# DESCRIPTION

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

Like with `use vars;`, there is no need to fully qualify the variable name.
However, you may if you wish.

# NOTES

- Specifying a variable but not a value will succeed silently, and will **not**
create the variable.  E.g., `use vars::i '$foo';` is a no-op.
- Trying to create a special variable is fatal.  E.g., `use vars::i '$@', 1;`
will die at compile time.

# SEE ALSO

See [vars](https://metacpan.org/pod/vars), ["our" in perldoc](https://metacpan.org/pod/perldoc#our), ["Pragmatic Modules" in perlmodlib](https://metacpan.org/pod/perlmodlib#Pragmatic-Modules).

# MINIMUM PERL VERSION

This version supports Perl 5.6+.  If you are running an earlier Perl,
use version 1.01 of this module (PODMASTER/vars-i-1.01).

# AUTHORS

D.H aka PodMaster, plus code from CXW.

Please use http://rt.cpan.org/ to report bugs (there shouldn't be any ;p).

Just go to http://rt.cpan.org/NoAuth/Bugs.html?Dist=vars-i to see
a bug list and/or report new ones.

# LICENSE

Copyright (c) 2003 by D.H. aka PodMaster.  Portions copyright (c) 2019 by Chris
White.  All rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. If you don't know what this means,
visit http://perl.com/ or http://cpan.org/.
