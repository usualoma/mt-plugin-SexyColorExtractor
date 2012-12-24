package SexyColorExtractor::Asset;

use strict;
use warnings;

use MT::Image;
use SexyColorExtractor::Util;
use Color::Object;

sub _max {
    my $max;
    for my $color (@_) {
        $max = $color if ( !$max || $color->{count} > $max->{count} );
    }
    return $max;
}

sub pre_save {
    my ( $cb, $obj, $original ) = @_;

    extract_color( $cb, $obj );
}

sub extract_color {
    my ( $cb, $obj ) = @_;

    return 1 if defined( $obj->se_bg_rgb );
    return 1 if MT->config->ImageDriver ne 'ImageMagick';

    my $file_path = $obj->file_path;
    my $fmgr = $obj->blog ? $obj->blog->file_mgr : MT::FileMgr->new('Local');
    my $img_data = $fmgr->get_data( $file_path, 'upload' );

    my $img = MT::Image->new( Data => $img_data );

    return 1 unless $img;

    $img->{magick}->Quantize(
        levels => number_of_colors( $obj->blog_id ),
        dither => 'true'
    );

    my %color_map = ();
    my @colors    = ();
    my $min_count = $img->{width} * $img->{height} * min_ratio();
    {
        my @histogram = $img->{magick}->Histogram();
        my $unit      = 2**16;
        while (@histogram) {
            my ( $r, $g, $b, $a, $count ) = splice( @histogram, 0, 5 );

            next if $count < $min_count;

            my @color     = map { $_ / $unit } ( $r, $g, $b );
            my $obj       = Color::Object->newRGB(@color);
            my $color_obj = {
                rgb   => \@color,
                hsv   => [ $obj->asHSV ],
                color => $obj,
                count => $count,
            };

            $color_map{ $r . $g . $b } = $color_obj;
            push( @colors, $color_obj );
        }
    }

    my %edge_color_map = ();
    {
        my @values = (
            $img->{magick}->GetPixels(
                map    => 'RGB',
                x      => 0,
                y      => 0,
                width  => $img->{width},
                height => 1
            ),
            $img->{magick}->GetPixels(
                map    => 'RGB',
                x      => 0,
                y      => 0,
                width  => 1,
                height => $img->{height}
            ),
        );
        while (@values) {
            my ( $r, $g, $b ) = splice( @values, 0, 3 );
            my $parent_obj = $color_map{ $r . $g . $b } or next;
            my $color_obj = $edge_color_map{ $r . $g . $b }
                ||= { %$parent_obj, count => 0, };
            $color_obj->{count}++;
        }
    }

    my $bg = _max( values %edge_color_map );

    my @fg1_candidates = grep {
               abs( $_->{hsv}[0] - $bg->{hsv}[0] ) >= fg1_hue_diff()
            && abs( $_->{hsv}[2] - $bg->{hsv}[2] )
            >= fg1_brightness_diff()
    } @colors;

    my $fg1 = _max(@fg1_candidates);
    if ( !$fg1 ) {
        my $v = $bg->{hsv}[2] + 0.5;
        if ( $v > 1 ) {
            $v -= 1;
        }
        my $obj = Color::Object->newHSV( ( $bg->{hsv}[0] + 180 ) % 360,
            $bg->{hsv}[1], $v );
        $fg1 = {
            rgb   => [ $obj->asRGB ],
            hsv   => [ $obj->asHSV ],
            color => $obj,
            count => 0,
        };
    }

    my $fg2 = $fg1;
    {
        my $max_diff = 0;
        for my $color_obj (@fg1_candidates) {
            my $diff = abs( $fg1->{hsv}[0] - $color_obj->{hsv}[0] );
            if ( $diff > $max_diff ) {
                $fg2      = $color_obj;
                $max_diff = $diff;
            }
        }
    }

    $obj->se_bg_rgb( join( ',', map { int( 256 * $_ ) } @{ $bg->{rgb} } ) );
    $obj->se_bg_hsv(
        join( ',',
            $bg->{hsv}[0], map { int( 256 * $_ ) } @{ $bg->{hsv} }[ 1, 2 ] )
    );
    $obj->se_fg1_rgb( join( ',', map { int( 256 * $_ ) } @{ $fg1->{rgb} } ) );
    $obj->se_fg1_hsv(
        join( ',',
            $fg1->{hsv}[0], map { int( 256 * $_ ) } @{ $fg1->{hsv} }[ 1, 2 ] )
    );
    $obj->se_fg2_rgb( join( ',', map { int( 256 * $_ ) } @{ $fg2->{rgb} } ) );
    $obj->se_fg2_hsv(
        join( ',',
            $fg2->{hsv}[0], map { int( 256 * $_ ) } @{ $fg2->{hsv} }[ 1, 2 ] )
    );

    1;
}

1;
