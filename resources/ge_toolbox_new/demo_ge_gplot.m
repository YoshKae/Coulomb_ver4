%% Demo ge_gplot
% Example usage of the ge_gplot function.
% 'help ge_gplot' for more info.

k = 1:60;
[b,xy] = bucky;
xy = xy * 60;

[xout,yout,gplot_output] = ge_gplot( b(k,k), xy(k,:), ...
                                'LineWidth', 3.0, 'LineColor', 'ff33ccff');
                            
points_output = ge_point(xout,yout, zeros(length(xout),1), 'name', ' ', 'Icon', 'http://maps.google.com/mapfiles/kml/shapes/open-diamond.png');  

ge_output('demo_ge_gplot.kml', [ge_folder('gplot',gplot_output), ...
                                ge_folder('points',points_output)]);
                            