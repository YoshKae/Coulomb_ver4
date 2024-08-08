%% Demo ge_plot3
% Example usage of the ge_plot3 function.
%   X, Y, Z should be the same constructs as used by the plot3 function.  
% 'help ge_plot3' for more info.

t = 0:pi/50:10*pi;

output = ge_plot3(sin(t), cos(t), (t*1000000), ...
                    'LineWidth', 1.2, ...
                    'LineColor','ffffa432');

ge_output('demo_ge_plot3.kml', output );
