
######################################################################
## $Id: TabbedAppFrame.pm 3657 2006-03-10 19:43:13Z spadkins $
######################################################################

package App::Widget::JSApp::TabbedAppFrame;
$VERSION = do { my @r=(q$Revision: 3657 $=~/\d+/g); sprintf "%d."."%02d"x$#r,@r};

use App;
use App::Widget::TabbedAppFrame;
use App::Widget::JSApp;
@ISA = ( "App::Widget::TabbedAppFrame", "App::Widget::JSApp" );

use strict;

=head1 NAME

App::Widget::JSApp::TabbedAppFrame - An application frame.

=head1 SYNOPSIS

   $name = "office";

   # official way
   use Widget;
   $context = App->context();
   $w = $context->widget($name);

   # internal way
   use App::Widget::JSApp::TabbedAppFrame;
   $w = App::Widget::JSApp::TabbedAppFrame->new($name);

=cut

######################################################################
# CONSTANTS
######################################################################

######################################################################
# ATTRIBUTES
######################################################################

# INPUTS FROM THE ENVIRONMENT

=head1 DESCRIPTION

This class implements an application frame.
This includes a menu, an application toolbar, a screen selector, 
a screen title, a screen toolbar, and 
a screen frame.  The application is actually implemented by the set
of screens that the application frame is configured to allow navigation
to.

The application frame can implement itself in frames if it is
configured to do so.  Otherwise, it implements itself as a table.

=cut

######################################################################
# OUTPUT METHODS
######################################################################

sub _init {
    my $self = shift;
    $self->SUPER::_init(@_);
    $self->init_jsapp();
}

1;

