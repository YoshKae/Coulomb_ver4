%% Demo ge_contour
% Example usage of the ge_contour function.
%   x, y, data should be the same constructs as used by the contour function.  
% 'help ge_contour' for more info.

data = peaks(50);

[countLat, countLong] = size(data);
max_lat_deg = 60.61;
min_lat_deg = 56.70;
gridlatres = abs(max_lat_deg - min_lat_deg) / (countLat-1);
max_long_deg = 6.25;
min_long_deg = 0.05;
gridlonres = abs(max_long_deg - min_long_deg) / (countLong-1);

y = min_lat_deg : gridlatres : max_lat_deg;
x = min_long_deg : gridlonres : max_long_deg;


output = ge_contour( x, y, data, ...
                     'altitude', 25000, ...
                     'LineWidth', 1.8, ...
                     'LineColor', 'ffaa341f');

ge_output( 'demo_ge_contour.kml', output );


