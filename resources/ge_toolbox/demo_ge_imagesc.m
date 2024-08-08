%% Demo ge_imagesc
% Example usage of the ge_imagesc function.
%   x, y, & data portions should be the same constructs as used by the imagesc function.  
% 'help ge_imagesc' for more info.
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

output = ge_imagesc(x, y, data, ...
                     'altitude', 50000, ...
                     'transparency', 'bb');

ge_output( 'demo_ge_imagesc.kml', output );


