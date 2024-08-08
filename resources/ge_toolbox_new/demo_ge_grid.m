%% Demo ge_grid
% Example usage of the ge_grid function.
% 'help ge_grid' for more info.

x_max = -60;
x_min = -90;
y_max = 0;
y_min = -15;

output = ge_grid( x_max, x_min, y_max, y_min, ...
                'latRes', 0.5, ...
                'lonRes', 0.5, ...
                'name', 'grid example', ...
                'LineColor', 'ff20ff25', ...
                'PolyColor', '73ffe8ed' );

ge_output( 'demo_ge_grid.kml', output );