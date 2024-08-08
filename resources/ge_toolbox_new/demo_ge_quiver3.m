%% Demo ge_quiver3
% Example usage of the ge_quiver3 function.
%   XM, YM, ZM, UM, VM, WM should be the same constructs as used by the quiver3() function.  
% 'help ge_quiver3' for more info.

N = 60;

t = linspace(0,2*pi,N);

x_red = zeros(N,1);
y_red = linspace(0,90,N);
z_red = 1e5*ones(N,1);

u_red = sin(t);
v_red = zeros(N,1);
w_red = cos(t);

x_green = linspace(0,90,N);
y_green = zeros(N,1);
z_green = 1e5*ones(N,1);

u_green = zeros(N,1);
v_green = sin(t);
w_green = cos(t);

x_blue = 10*sin(t);
y_blue = 10*cos(t);
z_blue = 1e5*ones(N,1);

u_blue = sin(t);
v_blue = cos(t);
w_blue = ones(N,1)*0.5*pi;

%[x_yellow, y_yellow] = meshgrid(-2:0.25:2,-1:0.2:1);
%z_yellow = x_yellow .* exp(-x_yellow.^2 - y_yellow.^32);
%[u_yellow,v_yellow,w_yellow] = surfnorm(x_yellow,y_yellow,z_yellow);

d = date;
dnum = datevec( d );
s_red = '';
s_blue = '';
s_green = '';

for n = 1:(N-1)
    
    dnum2 = dnum;
    dnum3 = dnum;
    dnum2(5) = dnum(5) + n;
    dnum3(5) = dnum(5) + n +1;
    dstr = datestr( dnum2, 'yyyy-mm-ddTHH:MM:SSZ');
    dstr2 = datestr( dnum3, 'yyyy-mm-ddTHH:MM:SSZ');   
    
    s_red = [s_red ge_quiver3(x_red(n),y_red(n),z_red(n),u_red(n),v_red(n),w_red(n),...
                            'modelLinkStr','elong_cube_red_lite.dae',...
                            'altitudeMode','absolute',...
                            'arrowScale',2.5e6,...
                            'timeSpanStart', char(dstr), ...
                            'timeSpanStop', char(dstr2 ), ...
                            'placemarkName', 'quiver3 - red') ];

    s_green = [s_green ge_quiver3(x_green(n),y_green(n),z_green(n),u_green(n),v_green(n),w_green(n),...
                            'modelLinkStr','elong_cube_green_lite.dae',...
                            'altitudeMode','absolute',...
                            'arrowScale',2.5e6,...
                            'timeSpanStart', char(dstr), ...
                            'timeSpanStop', char(dstr2 ), ...                            
                            'placemarkName', 'quiver3 - green')];

    s_blue = [s_blue ge_quiver3(x_blue(n),y_blue(n),z_blue(n),u_blue(n),v_blue(n),w_blue(n),...
                            'modelLinkStr','elong_cube_blue_lite.dae',...
                            'altitudeMode','absolute',...
                            'arrowScale',2.5e6,...
                            'timeSpanStart', char(dstr), ...
                            'timeSpanStop', char(dstr2 ), ...                            
                            'placemarkName', 'quiver3 - blue') ];

%    s_yellow = ge_quiver3(x_yellow,y_yellow,z_yellow,u_yellow,v_yellow,w_yellow,...
%                            'modelLinkStr','yellow_arrow.dae',...
%                            'altitudeMode','absolute',...
%                            'arrowScale',1e6,...
%                            'placemarkName', 'quiver3 - yellow arrow');
    
end

filename = 'demo_ge_quiver3';

s_redf = ge_folder('red', s_red);
s_greenf = ge_folder('green', s_green);
s_bluef = ge_folder('blue', s_blue);
ge_output(strcat(filename,'.kml'),[s_redf,s_greenf,s_bluef]);%,s_yellow])

zip(strcat(filename,'.kmz'),{ strcat(filename,'.kml'), ...
                   'yellow_arrow.dae', ...
                   'elong_cube_red_lite.dae',...
                   'elong_cube_green_lite.dae',...
                   'elong_cube_blue_lite.dae'});

if ispc
    eval( ['!del ', filename, '.kml'] );
    eval( ['!move ', filename, '.kmz.zip ', filename, '.kmz' ] );
else
    eval( ['!rm ', filename, '.kml'] );
end

