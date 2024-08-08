%% Demo ge_box
% Example usage of the ge_box function.
% 'help ge_box' for more info.

x1_max = -10;
x1_min = -50;
y1_max = 40;
y1_min = 0;
x2_max = 5;
x2_min = -40;
y2_max = 30;
y2_min = 20;

output1 = ge_box( x1_max, x1_min, y1_max, y1_min, ...
                    'altitude', 20);

output2 = ge_box( x2_max, x2_min, y2_max, y2_min, ...
                    'altitude', 5000, ...
                    'name', 'box number 2', ...
                    'LineWidth', 5.0, ...
                    'LineColor', '00ffa432', ...
                    'PolyColor', '40ff833e' );
                
                
ge_output( 'demo_ge_box.kml', [output1 output2] );

