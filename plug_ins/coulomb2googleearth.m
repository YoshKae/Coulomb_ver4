% coulomb2googleearth
%
% This script converts coulomb calculation results into .kml format for
% plotting onto Google Earth, using global variables saved in the MATLAB
% console.
% To convert MATLAB data into Google Earth kml file, 'Matlab2GoogleEarth
% Toolbox' developed by Scott Davis (see MATLAB Central) is implemented.
% We really appreciate his code.
%
% === OUTPUT FILE ================
%   'coulomb_displacement.kml'
%   'coulomb_source_fault_plot.kml'
%   'coulomb_afault_plot.kml'  
%
% Copyright: Shinji Toda, January 30, 2007

% kml reference
%   http://earth.google.com/kml/kml_tags_21.html
%
% hexa color info
% aa=alpha (00 to ff); bb=blue (00 to ff); gg=green (00 to ff); rr=red (00
% to ff). 
% http://earth.google.com/kml/kml_tags_21.html#color
% http://www.dave-stephens.com/computers/colors.htm

disp('Calculating... Please wait...');
%------------------------------------------------------
%   Study area box
%------------------------------------------------------
output = ge_box(MIN_LAT,MAX_LAT,MIN_LON,MAX_LON,...
                    'name', 'study area', ...
                    'altitude', 0,...
                    'altitudeMode','clampedToGround',...
                    'LineWidth', 3.0, ...
                    'LineColor', 'fffffafa',...
                    'PolyColor', '00ffffff');
ge_output( 'coulomb_study_area_box.kml', output);
    disp('  -> ''coulomb_study_area_box.kml'' is saved in the current directory.');

%------------------------------------------------------
%   Displacement vectors
%------------------------------------------------------
if FUNC_SWITCH == 2     % horizontal disp vector is active
if isempty(DC3D) ~= 1
    if ~isempty(SIZE)
        exag = SIZE(3);
    else
        exag = 5000.0;
    end
mappos = xy2lonlat(DC3D(:,1:2));
% Cartesian calc for dx, dy, dz positions
my0 = length(YGRID);
mx0 = length(XGRID);
x0 = repmat(XGRID,my0,1);
y0 = repmat(rot90(YGRID),1,mx0);
z0 = repmat(CALC_DEPTH,my0,mx0);
% z0 = repmat(0.0,my0,mx0);
mapdisp = xy2lonlat([DC3D(:,1)+DC3D(:,6)*exag DC3D(:,2)+DC3D(:,7)*exag]);
dxp = mapdisp(:,1) - mappos(:,1);
dyp = mapdisp(:,2) - mappos(:,2);

% lon & lat calc.
my = length(LAT_GRID);
mx = length(LON_GRID);
x = repmat(LON_GRID,my,1);
y = repmat(rot90(LAT_GRID),1,mx);
% z = repmat(CALC_DEPTH,my,mx);
z = repmat(0.0,my,mx);
dx = flipud(reshape(dxp,my,mx));
dy = flipud(reshape(dyp,my,mx));
dz = flipud(reshape(DC3D(:,8)*exag,my,mx));

% save kml file
output1 = ge_quiver(x,y,dx,dy , ...
                    'LineColor', 'ff00ffff', ...
                    'LineWidth', 2.0, ...
                    'altitude', 0,...
                    'altitudeMode','clampedToGround');
% output2 = ge_quiver3(x,y,z,dx,dy,dz,'modelLinkStr','test.dae',...
%     'altitudeMode','clampedToGround',...
%     'arrowScale',10000,'placemarkName', 'ge_quiver3');

ge_output( 'coulomb_displ_horizontal.kml', output1 );
    disp('  -> ''coulomb_displ_horizontal.kml'' is saved in the current directory.');
% ge_output( 'coulomb_displ_3D.kml', output2 );
%     disp('  -> ''coulomb_displ_3D.kml'' is saved in the current directory.');
end
end

%------------------------------------------------------
%   Fault overlay
%------------------------------------------------------
aflon = zeros(NUM*5,1,'double');
aflat = zeros(NUM*5,1,'double');
icount = 1;
for n = 1:NUM
% map projection box for a source fault
    c = fault_corners(ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),...
        ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
    d1 = xy2lonlat([c(1,1) c(1,2)]);
	d2 = xy2lonlat([c(2,1) c(2,2)]);
	d3 = xy2lonlat([c(3,1) c(3,2)]);
	d4 = xy2lonlat([c(4,1) c(4,2)]);
    aflon(icount:icount+4,1) = [d1(1);d2(1);d3(1);d4(1);d1(1)];
    aflat(icount:icount+4,1)= [d1(2);d2(2);d3(2);d4(2);d1(2)];
    aflon(icount+5,1) = NaN;
    aflat(icount+5,1) = NaN;
    icount = icount + 6;              
end
source_faults = ge_poly(aflat, aflon,...
       'LineColor','ffa4ff32','PolyColor','00000000','LineWidth',10.0,'altitude', 10000, 'altitudeMode', 'relativeToGround', 'tessellate', 1);
ge_output('coulomb_source_fault_plot.kml', [source_faults]);
    disp('  -> ''coulomb_source_fault_plot.kml'' is saved in the current directory.');

%------------------------------------------------------
%   Plot ACTIVE FAULTS
%------------------------------------------------------
if isempty(AFAULT_DATA) ~= 1
nNan = max(AFAULT_DATA(:,1));
[m,n] = size(AFAULT_DATA(:,1));
aflon = zeros(m+nNan-1,1,'double');
aflat = zeros(m+nNan-1,1,'double');
icount = 1;
for k = 1:nNan
    c1 = AFAULT_DATA(:,1) == k;
    dum = sum(c1);
    s0 = icount;
    f0 = s0 + dum - 1;
    s1 = icount + (k - 1);
    f1 = s1 + dum - 1;
    start = icount;
    finish = start + dum - 1;
    aflon(s1:f1,1) = AFAULT_DATA(s0:f0,2);
    aflat(s1:f1,1) = AFAULT_DATA(s0:f0,3);
    aflon(f1+1,1) = NaN;
    aflat(f1+1,1) = NaN;
    icount = finish + 1;
end
    active_faults = ge_poly(aflat, aflon,...
       'LineColor','ff0000ff','PolyColor','00000000','LineWidth',2.5,'altitude', 10000, 'altitudeMode', 'relativeToGround', 'tessellate', 1);
ge_output('coulomb_afault_plot.kml', [active_faults]);
    disp('  -> ''coulomb_afault_plot.kml'' is saved in the current directory.');
end

%------------------------------------------------------
%   Plot EARTHQUAKES
%------------------------------------------------------
if isempty(EQ_DATA) ~= 1
    eqlon = rot90(EQ_DATA(:,1));
    eqlat = rot90(EQ_DATA(:,2));
    eqz   = ones(1,length(eqlon)).*1000;
    [m,n] = size(EQ_DATA);    
for k = 1:m    
    output1 = ge_circle( eqlat(k), eqlon(k), eqz(k),...
                         'LineWidth',2.0,...
                         'LineColor','ffffffff',...
                         'PolyColor','ffff0000');
    output = [output output1];
end
ge_output( 'coulomb_earthquake_plot.kml', output);

end

%------------------------------------------------------
%   COULOMB IMAGE OVERLAY
%------------------------------------------------------
if FUNC_SWITCH == 7 | FUNC_SWITCH == 8 | FUNC_SWITCH == 9  
disp('  * If you want to overlay Coulomb image on GoogleEarth, take the following procedure.');
disp('  *  (1) Save the coulomb image as .pdf from File > Save As menu.');
disp('  *  (2) Open the pdf file in Illustrator or other graphic software.');
disp('  *  (3) Remove all text and lines, and keep only the color image.');
disp('  *  (4) Save the image as .jpeg file. and mame it ''coulombmap.jpeg'' in the coulomb directory.');
disp('  *  (5) type ''coulomb2googleearth'' in this command window. You will get the overlay kml file.');
output = ge_groundoverlay( MAX_LAT, MIN_LAT, MAX_LON, MIN_LON , ...
                            'iconHref', 'coulombmap.jpg', ...
                            'color', '3fffffff',...
                            'viewBoundScale', '1.0' ); 
ge_output( 'coulomb_stress_overlay_image.kml', output );
    disp('  -> ''coulomb_stress_overlay_image.kml'' is saved in the current directory.');
end

disp('Done!');;

