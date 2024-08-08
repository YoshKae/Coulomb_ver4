%% Demo ge_quiver
% Example usage of the ge_quiver function.
%   X, Y, DX, DY should be the same constructs as used by the quiver() function.  
% 'help ge_quiver' for more info.

[X,Y] = meshgrid(-2:.2:2);
Z = X.*exp(-X.^2 - Y.^2);
[DX,DY] = gradient(Z,.2,.2);

output = ge_quiver(X,Y,DX,DY , ...
                    'LineColor', 'ff00ffff', ...
                    'LineWidth', 1.2, ...
                    'altitude', 50000);

ge_output( 'demo_ge_quiver.kml', output );
