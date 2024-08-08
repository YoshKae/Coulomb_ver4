%% Demo ge_windbarb
% Example usage of the ge_windbarb function.
%   X, Y, DX, DY should be the same constructs as used by the quiver() function.  
% 'help ge_windbarb' for more info.

clear;
load('winddata.mat');

[xcoords, ycoords] = ge_windbarb( X(1,:), Y(:,1), U, V ,'barbScale', 1, 'hemisphere', 'Auto' );

   poly_color_str = '55338822';
outline_color_str = 'ff00ff00';

barbs = ge_poly( xcoords,ycoords, 'PolyColor', poly_color_str ,...
                                  'LineColor', outline_color_str,...
                                  'LineWidth', 2);

ge_output( 'demo_ge_windbarb.kml', barbs );
