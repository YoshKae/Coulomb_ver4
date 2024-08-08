%% Demo ge_groundoverlay
% Example usage of the ge_groundoverlay function. 
% 'help ge_groundoverlay' for more info.

x_max = 38;
x_min = -23;
y_max = 66;
y_min = 2;

output = ge_groundoverlay( x_max, x_min, y_max, y_min, ...
                            'iconHref', 'map.bmp', ...
                            'color', '93ffffff', ...
                            'viewBoundScale', '0.55' );
    
ge_output( 'demo_ge_groundoverlay.kml', output );