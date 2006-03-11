
######################################################################
## $Id: JSApp.pm 3661 2006-03-11 15:39:46Z spadkins $
######################################################################

package App::Widget::JSApp;
$VERSION = do { my @r=(q$Revision: 3661 $=~/\d+/g); sprintf "%d."."%02d"x$#r,@r};

use App::Widget;
@ISA = ( "App::Widget" );

use strict;

=head1 NAME

App::Widget::JSApp - Dynamic, client-side widgets for the App-Context Framework using the js-app Javascript distribution

=head1 SYNOPSIS

   use App::Widget::JSApp::DualListSelectWidget;

   ...

=cut

sub html {
    &App::sub_entry if ($App::trace);
    my $self = shift;
    my $name = $self->{name};
    my $context = $self->{context};

    $self->init_jsapp();

    my (@attrib);
    foreach my $key (keys %$self) {
        if ($key =~ /^jsapp_(.+)/) {
            push(@attrib, $1, $self->{$key}) if ($1 ne "domain");
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
            $js_conf .= " \"$attrib[$i]\" : \"" . $self->escape_double_quoted_value($attrib[$i+1]) . "\"";
        }
    }

    if (defined $self->{jsapp_domain}) {
        my ($value_domain, $values, $labels, $domain_alias);
        my ($values_text, $labels_text, $i);
        foreach my $domain_name (sort keys %{$self->{jsapp_domain}}) {

            $domain_alias = $self->{jsapp_domain}{$domain_name};
            $domain_alias = $domain_name if (!$domain_alias || $domain_alias eq "1");
            
            $value_domain = $context->value_domain($domain_name);
            ($values, $labels) = $value_domain->values_labels();

            $values_text = "";
            $labels_text = "";

            if ($#$values > -1) {
                $values_text = ",\n    \"${domain_alias}_values\" : [";
                for ($i = 0; $i <= $#$values; $i++) {
                    $values_text .= "," if ($i > 0);
                    $values_text .= "\n     " if ($i % 10 == 0);
                    $values_text .= " \"$values->[$i]\"";
                }
                $values_text .= "\n    ]";

                if ($labels && %$labels) {
                    $labels_text = ",\n    \"${domain_alias}_labels\" : {";
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
                $values_text = ",\n    \"${domain_alias}_values\" : [ ]";
                $labels_text = ",\n    \"${domain_alias}_labels\" : { }";
            }
            $js_conf .= $values_text;
            $js_conf .= $labels_text;
        }
    }
    if ($js_conf) {
        $js_conf .= " }";
    }

    my $html = <<EOF;
<script type="text/javascript">
  context.widget("$name"$js_conf).write();
</script>
EOF

    &App::sub_exit($html) if ($App::trace);
    return($html);
}

sub escape_double_quoted_value {
    my ($self, $value) = @_;
    $value =~ s/"/\\"/g;
    $value =~ s/\r//msg;
    $value =~ s/\n/\\n/msg;
    return($value);
}

sub init_jsapp {
    &App::sub_entry if ($App::trace);
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
    &App::sub_exit() if ($App::trace);
}

sub javascript_conf {
    &App::sub_entry if ($App::trace);
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
    &App::sub_exit($js) if ($App::trace);
    return($js);
}

1;

