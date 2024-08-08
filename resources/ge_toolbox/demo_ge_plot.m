%% Demo ge_plot
% Example usage of the ge_plot function.
%   X, Y should be the same constructs as used by the plot function.  
% 'help ge_plot' for more info.

multiplier = 180/pi;
x1 = -pi*multiplier:pi/10:pi*multiplier;
y1 = tan(sin(x1)) - sin(tan(x1));

y2 = -pi*multiplier:pi/10:pi*multiplier;
x2 = tan(sin(y2)) - sin(tan(y2));

output = ge_plot(x1, y1, ...
                    'LineWidth',5.0, ...
                    'LineColor','ffffa432');
output2 = ge_plot(x2, y2, ...
                    'LineWidth',5.0,...
                    'LineColor','ffa4ff32');


ge_output('demo_ge_plot.kml', [output output2] );