%% Demo ge_contour
% Example usage of the ge_contour function.
%   x, y, data should be the same constructs as used by the contour function.  
% 'help ge_contour' for more info.

data = peaks(50);

[countLat, countLong] = size(data);
Environment.max_lat_deg = 60.61;
Environment.min_lat_deg = 56.70;
Environment.gridlatres = abs(Environment.max_lat_deg - Environment.min_lat_deg) / (countLat-1);
Environment.max_long_deg = 6.25;
Environment.min_long_deg = 0.05;
Environment.gridlonres = abs(Environment.max_long_deg - Environment.min_long_deg) / (countLong-1);
y = Environment.min_lat_deg:Environment.gridlatres:Environment.max_lat_deg;
x = Environment.min_long_deg:Environment.gridlonres:Environment.max_long_deg;


output = ge_contour( x, y, data, ...
                     'altitude', 25000, ...
                     'LineWidth', 1.2, ...
                     'LineColor', 'ffaa341f');

ge_output( 'demo_ge_contour.kml', output );


