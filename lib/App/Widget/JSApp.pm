
######################################################################
## $Id: JSApp.pm,v 1.1 2005/08/09 19:46:51 spadkins Exp $
######################################################################

package App::Widget::JSApp;
$VERSION = do { my @r=(q$Revision: 1.1 $=~/\d+/g); sprintf "%d."."%02d"x$#r,@r};

use App::Widget;
@ISA = ( "App::Widget" );

use strict;

=head1 NAME

App::Widget::JSApp::DualListSelectWidget - An ordered multi-select widget made up of two HTML <select> tags and four buttons,
enhanced by JavaScript

=head1 SYNOPSIS

   use App::Widget::JSApp::DualListSelectWidget;

   ...

=cut

sub html {
    my $self = shift;
    my $name = $self->{name};
    my $context = $self->{context};

    $self->init_jsapp();

    my (@attrib);
    foreach my $key (keys %$self) {
        if ($key =~ /^jsapp_(.+)/) {
            push(@attrib, $1, $self->{$key});
        }
    }
    if (! defined $self->{jsapp_submittable}) {
        push(@attrib, "submittable", 1);
    }
    my $value = $context->so_get($name);
    $value = "" if (!defined $value);
    push(@attrib, "default", $value);
    my $js_conf = "";
    if ($#attrib > -1) {
        $js_conf = ", {";
        for (my $i = 0; $i < $#attrib; $i += 2) {
            $js_conf .= "," if ($i > 0);
            $js_conf .= " \"$attrib[$i]\" : \"$attrib[$i+1]\"";
        }
        $js_conf .= " }";
    }

    my $html = <<EOF;
<script type="text/javascript">
  context.widget("$name"$js_conf).write();
</script>
EOF

    return($html);
}

sub init_jsapp {
    my ($self) = @_;
    my $context = $self->{context};
    my $response = $context->response();
    my $html_url_dir = $context->get_option("html_url_dir");
    my $js = "$html_url_dir/js-app/init.js";
    if (!$response->is_included($js)) {
        my $js_conf = $self->javascript_conf();
        $response->include("javascript", $js_conf);
        $response->include("javascript", $js);
    }
}

sub javascript_conf {
    my ($self) = @_;
    my $context = $self->{context};
    my $options = $context->options();
    my $html_url_dir     = $options->{html_url_dir};
    my $script_url_dir   = $options->{script_url_dir};
    my $js = $options->{jsapp_init};
    if (!$js) {
        $js = <<EOF;
<script type="text/javascript" language="JavaScript">
  var appOptions = {
    urlDocRoot    : "$html_url_dir",
    urlScriptRoot : "$script_url_dir"
  };
</script>
EOF
    }
    return($js);
}

1;

