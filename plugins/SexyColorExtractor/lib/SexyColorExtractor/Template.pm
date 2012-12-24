package SexyColorExtractor::Template;
use strict;
use warnings;
use utf8;

use SexyColorExtractor::Util;
use SexyColorExtractor::Asset;

sub _print {
    my ( $prefix, $ctx, $args ) = @_;
    my $asset = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return '' if $asset->class ne 'image';

    if ( !$asset->meta( $prefix . '_rgb' ) ) {
        SexyColorExtractor::Asset::extract_color( $ctx, $asset );
        if ( $asset->meta( $prefix . '_rgb' ) ) {
            $asset->save;
        }
        else {
            return '';
        }
    }

    my $map = lc( $args->{map} || 'RGB' );
    my $format = $args->{format} || default_format( $ctx->stash('blog_id') );
    my @color = split ',', $asset->meta( $prefix . '_' . $map );

    return sprintf( $format, @color );
}

sub asset_sexy_background_color {
    return _print( 'se_bg', @_ );
}

sub asset_sexy_text_main_color {
    return _print( 'se_fg1', @_ );
}

sub asset_sexy_text_sub_color {
    return _print( 'se_fg2', @_ );
}

1;
