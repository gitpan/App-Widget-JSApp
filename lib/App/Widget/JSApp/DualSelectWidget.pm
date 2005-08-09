
######################################################################
## $Id: DualSelectWidget.pm,v 1.1 2005/08/09 19:46:51 spadkins Exp $
######################################################################

package App::Widget::JSApp::DualSelectWidget;
$VERSION = do { my @r=(q$Revision: 1.1 $=~/\d+/g); sprintf "%d."."%02d"x$#r,@r};

use App::Widget::JSApp;
@ISA = ( "App::Widget::JSApp" );

use strict;

=head1 NAME

App::Widget::JSApp::DualSelectWidget - An ordered multi-select widget made up of two HTML <select> tags and four buttons,
enhanced by JavaScript

=head1 SYNOPSIS

   use App::Widget::JSApp::DualSelectWidget;

   ...

=cut

sub html {
    my $self = shift;
    my $name = $self->{name};

    $self->init_jsapp();

    my $size = "";
    $size = ",\n    \"size\" : $self->{size}" if ($self->{size});

    my ($values, $labels) = $self->values_labels();
    my ($values_text, $i);

    my $labels_text = "";

    if ($#$values > -1) {
        $values_text = ",\n    \"values\" : [";
        for ($i = 0; $i <= $#$values; $i++) {
            $values_text .= "," if ($i > 0);
            $values_text .= "\n     " if ($i % 10 == 0);
            $values_text .= " \"$values->[$i]\"";
        }
        $values_text .= "\n    ]";

        if ($labels && %$labels) {
            $labels_text = ",\n    \"labels\" : {";
            for ($i = 0; $i <= $#$values; $i++) {
                next if (! defined $labels->{$values->[$i]});
                $labels_text .= "," if ($i > 0);
                $labels_text .= "\n     " if ($i % 10 == 0);
                $labels_text .= " \"$values->[$i]\" : \"$labels->{$values->[$i]}\"";
            }
            $labels_text .= "\n    }";
        }
    }
    else {
        $values_text = ",\n    values : [ ]";
    }
    my $context = $self->{context};
    my $value = $context->so_get($name);
    $value = "" if (!defined $value);

    my $html = <<EOF;
<script type="text/javascript">
  context.widget("$name", {
    "serviceClass" : "DualSelectWidget",
    "submittable" : 1,
    "default" : "$value"$size$values_text$labels_text
  }).write();
</script>
EOF

    return($html);
}

1;

