
######################################################################
## File: $Id: Makefile.PL 3651 2006-03-10 04:02:08Z spadkins $
######################################################################

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

%opts = (
    'NAME'        => 'App-Widget-JSApp',
    'DISTNAME'    => 'App-Widget-JSApp',
    'VERSION'     => '0.50',
    'PREREQ_PM'   => {
                       'App::Widget'              => 0,
                     },
    'clean'       => { FILES => '$(EXE_FILES)' },
    'dist'        => {'COMPRESS'=>'gzip -9f', 'SUFFIX' => 'gz',
                      'ZIP'=>'/usr/bin/zip','ZIPFLAGS'=>'-rl'},
);

######################################################################
# MAKE THE MAKEFILE
######################################################################

WriteMakefile(%opts);

sub MY::postamble {
    return <<EOF;

install ::
	@\$(MOD_INSTALL) htdocs  "\$(PREFIX)/htdocs/App"

EOF
}

