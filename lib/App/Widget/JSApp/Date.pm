
######################################################################
## $Id: Date.pm 3497 2005-10-20 20:51:20Z spadkins $
######################################################################

package App::Widget::JSApp::Date;
$VERSION = do { my @r=(q$Revision: 3497 $=~/\d+/g); sprintf "%d."."%02d"x$#r,@r};

use App::Widget::JSApp;
@ISA = ( "App::Widget::JSApp" );

use strict;

=head1 NAME

App::Widget::JSApp::Date - A date widget

=head1 SYNOPSIS

   use App::Widget::JSApp::Date;

   ...

=cut

sub html {
    my $self = shift;
    my $name = $self->{name};

    $self->init_jsapp();

    my $context = $self->{context};
    my $value = $context->so_get($name);
    $value = "" if (!defined $value);

    my $html = <<EOF;
<script type="text/javascript">
  context.widget("$name", {
    "serviceClass" : "DateWidget",
    "submittable" : 1,
    "default" : "$value"
  }).write();
</script>
EOF

    return($html);
}

1;

