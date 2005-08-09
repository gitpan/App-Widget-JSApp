
######################################################################
## File: $Id: Makefile.PL,v 1.1 2005/08/09 19:46:51 spadkins Exp $
######################################################################

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

%opts = (
    'NAME'        => 'App-Widget-JSApp',
    'DISTNAME'    => 'App-Widget-JSApp',
    'VERSION'     => '0.10',
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

