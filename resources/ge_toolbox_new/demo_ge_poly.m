%% Demo ge_poly & ge_polyNplace
% Example usage of the ge_poly & ge_polyNplace functions.
%  Multiple polygons are seperated by NaNs.
% 'help ge_poly' or 'help ge_polyNplace' for more info.

try
    load conus;
catch
% if you have an older matlab... this might work instead
    load usalo;
end

world_coasts = ge_poly(uslon,uslat, 'PolyColor', '3333ffff', 'altitude', 150000, 'altitudeMode', 'relativeToGround', 'extrude', 1, 'tessellate', 1);
usa_states = ge_polyNplace(gtlakelon, gtlakelat, 1, 'name', 'Great Lakes', 'PolyColor','99ffffff');

ge_output('demo_ge_poly.kml', [world_coasts usa_states] );



