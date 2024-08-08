%% Demo ge_groundoverlay
% Example usage of the ge_groundoverlay function. 
% 'help ge_groundoverlay' for more info.

output = ge_groundoverlay( 66, 2, 38, -23 , ...
                            'iconHref', 'map.bmp', ...
                            'color', '93ffffff', ...
                            'viewBoundScale', '0.55' );
    
ge_output( 'demo_ge_groundoverlay.kml', output );