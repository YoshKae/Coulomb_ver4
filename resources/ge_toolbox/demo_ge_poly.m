%% Demo ge_poly & ge_polyNplace
% Example usage of the ge_poly & ge_polyNplace functions.
%  Multiple polygons are seperated by NaNs.
% 'help ge_poly' or 'help ge_polyNplace' for more info.

load conus;
% if you have an older matlab... this might work instead
% load usalo

world_coasts = ge_poly(uslat,uslon, 'PolyColor', '3333ffff', 'altitude', 10000, 'altitudeMode', 'relativeToGround', 'tessellate', 1);
usa_states = ge_polyNplace(gtlakelat, gtlakelon, 1, 'name', 'Great Lakes', 'PolyColor','99ffffff', 'altitude', 100);

ge_output('demo_ge_poly.kml', [world_coasts usa_states] );



