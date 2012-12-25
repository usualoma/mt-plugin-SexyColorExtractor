<?php

function sexycolorextractor_color($prefix, $args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    if ($asset->asset_class != 'image') return '';

    $mt     = MT::get_instance();
    $config = $mt->db()->fetch_plugin_config('SexyColorExtractor', 'system');
    if (empty($config)) {
        $config = array();
    }

    $map    = strtolower(empty($args['map']) ? 'RGB' : $args['map']);
    $format
        = empty( $args['format'] )
        ? ( empty( $config['default_format'] )
        ? 'rgb(%d, %d, %d)'
        : $config['default_format'] )
        : $args['format'];

    $key   = $prefix . '_' . $map;
    $value = $asset->$key;

    if (empty($value)) {
        return '';
    }

    $color = explode(',', $value);

    return call_user_func_array('sprintf', array_merge(array($format), $color));
}
