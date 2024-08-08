%% Demo ge_imagesc
% Example usage of the ge_imagesc function.
%   x, y, & data portions should be the same constructs as used by the imagesc function.  
% 'help ge_imagesc' for more info.

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


output = ge_imagesc(x, y, data, ...
                     'altitude', 50000, ...
                     'transparency', 'bb');

output2 = ge_colorbar(mean(x), mean(y), data, ...
                     'altitude', 50000, ...
                     'orientation', 'vertical');

ge_output( 'demo_ge_imagesc.kml', [output2 output]);


