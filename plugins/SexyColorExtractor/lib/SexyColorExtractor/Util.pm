package SexyColorExtractor::Util;

use strict;
use warnings;

our @EXPORT = qw(
    plugin number_of_colors default_format fg1_hue_diff fg1_brightness_diff
    min_ratio
);
use base qw(Exporter);

sub plugin {
    MT->component('SexyColorExtractor');
}

sub _get_config_value {
    my ( $key, $blog_id ) = @_;
    if ( !defined($blog_id) ) {
        my $app = MT->instance;
        my $blog = $app->can('blog') && $app->blog;
        $blog_id = $blog ? $blog->id : 0;
    }
    plugin()
        ->get_config_value( $key,
        $blog_id ? ( 'blog:' . $blog_id ) : 'system' );
}

sub number_of_colors {
    _get_config_value( 'number_of_colors', @_ );
}

sub default_format {
    _get_config_value( 'default_format', @_ );
}

sub fg1_hue_diff {
    _get_config_value( 'fg1_hue_diff', @_ );
}

sub fg1_brightness_diff {
    _get_config_value( 'fg1_brightness_diff', @_ );
}

sub min_ratio {
    _get_config_value( 'min_ratio', @_ );
}

1;
