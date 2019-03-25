# perl Makefile.PL && nmake realclean && cls && perl Makefile.PL && nmake test
# cpan-upload -mailto yo@yo.yo -verbose -user podmaster vars-i-1.01.tar.gz


use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Acme::CXW::vars::i',
    VERSION_FROM => 'lib/Acme/CXW/vars/i.pm', # finds \$VERSION
    ABSTRACT_FROM=> 'lib/Acme/CXW/vars/i.pm',
    AUTHOR       => 'D. H. (PodMaster)',
    PREREQ_PM    => {
                     'Carp' => '0',
                    },

    TEST_REQUIRES=> {
                     'Test::More' => 0,
                    },

    META_MERGE => {
        'meta-spec' => { version => 2 },
        'release_status' => 'testing',

        x_contributors => [
            # Use CPAN emails so MetaCPAN will pick them up.
            'D.H. <podmaster@cpan.org>',
            'Christopher White <cxw@cpan.org>',
        ],

        resources => {
            bugtracker => {
                web  => 'https://github.com/cxw42/Perl-vars-i/issues',
            },
            repository => {
                type => 'git',
                web  => 'https://github.com/cxw42/Perl-vars-i.git',
                web  => 'https://github.com/cxw42/Perl-vars-i',
            },
        },

    }, #META_MERGE
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Perl-vars-i-*' },
);
