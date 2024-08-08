function receiver_matrix_maker
%
% This is a function to make a matrix for receivers faults, which have
% strike, dip and rake at each node based on EQ_DATA converted from
% "receiver data." Once the matrix is made, the data is stored as RECEIVERS
% and "coulomb_calc_and_view.m" will check it and calculated Coulomb stress
% change. But the matrix is effective only immediately after this function
% is performed.

% make receivers faults matrix
global RECEIVERS
global XGRID YGRID EQ_DATA
global MIN_LON MAX_LON MIN_LAT MAX_LAT
% global ANATOLIA SEIS_RATE LON_GRID LAT_GRID DC3D ICOORD

% % need default values to fill NaN empty nodes
% def_strike = input('Default strike in case NaN node is detected? [e.g., 50.]');
% def_dip    = input('Default dip in case NaN node is detected? [e.g., 90.]');
% def_rake   = input('Default rake in case NaN node is detected? [e.g., 180.]');
% % def_strike = 100;
% % def_dip    = 45;
% % def_rake   = 90;

xinc = abs(XGRID(2)-XGRID(1));
yinc = abs(YGRID(2)-YGRID(1));

% define four corners
% disp('To have complete matrix, you need to input info about the four corners.');
% disp('***** left-top corner *****');
% lt1 = input('  Strike? [e.g., 135.]');
% lt2 = input('  Dip?');
% lt3 = input('  Rake?');
% disp('***** right-top corner *****');
% rt1 = input('  Strike?');
% rt2 = input('  Dip?');
% rt3 = input('  Rake?');
% disp('***** right-bottom corner *****');
% rb1 = input('  Strike?');
% rb2 = input('  Dip?');
% rb3 = input('  Rake?');
% disp('***** left-bottom corner *****');
% lb1 = input('  Strike?');
% lb2 = input('  Dip?');
% lb3 = input('  Rake?');

% lt1 = 20.0;
% lt2 = 90.0;
% lt3 = 180.0;
% rt1 =  5.0;
% rt2 = 45.0;
% rt3 = 89.0;
% rb1 =  1.0;
% rb2 = 45.0;
% rb3 = -89.0;
% lb1 = 145.0;
% lb2 = 45.0;
% lb3 = -89.0;

lt1 =  10.0;
lt2 =  90.0;
lt3 = 150.0;
rt1 =  10.0;
rt2 =  90.0;
rt3 = 150.0;
rb1 =  10.0;
rb2 =  90.0;
rb3 = 150.0;
lb1 =  10.0;
lb2 =  90.0;
lb3 = 150.0;

% cflag = input(' Do you consider conjugate nodal planes? 1. yes, 2. no ');
cflag = 2;

edge     = [min(XGRID)-xinc max(YGRID)+yinc lt1 lt2 lt3;     % left-top
            max(XGRID)+xinc max(YGRID)+yinc rt1 rt2 rt3;     % right-top
            max(XGRID)+xinc min(YGRID)-yinc rb1 rb2 rb3;     % right-bottom
            min(XGRID)-xinc min(YGRID)-yinc lb1 lb2 lb3];    % left-bottom
        
method = 'linear'; % interpolation method: 'linear' or 'nearest' or 'cube'
nx = size(XGRID,2);
ny = size(YGRID,2);
RECEIVERS = zeros(nx*ny,5);    % [strike, dip, rake, lon., lat.] 5 columns

%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------
% combine earthquake focal mech data with four corner strike, dip, and rake
% data
x   = rot90([double(EQ_DATA(:,16));double(edge(:,1))]);
y   = rot90([double(EQ_DATA(:,17));double(edge(:,2))]);
% make the other conjugate nodal plane
out = nodal_plane_calc([EQ_DATA(:,10);edge(:,3)],[EQ_DATA(:,11);edge(:,4)],...
    [EQ_DATA(:,12);edge(:,5)])

dummy = zeros(4,17);
EQ_DATA = [EQ_DATA; dummy];

EQ_DATA(:,10) = out(:,1);
EQ_DATA(:,11) = out(:,2);
EQ_DATA(:,12) = out(:,3);
EQ_DATA(:,13) = out(:,4);
EQ_DATA(:,14) = out(:,5);
EQ_DATA(:,15) = out(:,6);



zs1 = rot90(double(EQ_DATA(:,10)));
zd1 = rot90(double(EQ_DATA(:,11)));
zr1 = rot90(double(EQ_DATA(:,12)));
zs2 = rot90(double(EQ_DATA(:,13)));
zd2 = rot90(double(EQ_DATA(:,14)));
zr2 = rot90(double(EQ_DATA(:,15)));

[xx,yy] = meshgrid(XGRID,YGRID);

% decompose rake info to lateral and dip slip components to have average
% later
[zr1_latslip zr1_dipslip] = rake2comp(flipud(rot90(zr1)),ones(length(zr1),1));
[zr2_latslip zr2_dipslip] = rake2comp(flipud(rot90(zr2)),ones(length(zr2),1));

% zstrike1     = griddata(x,y,zs1,xx,yy,method);
% c1           = zstrike1 >  180.0; 
% c2           = zstrike1 <= 180.0;
% zstrike1     = (180.0-zstrike1).*c1 + zstrike1.*c2;
% zdip1        = griddata(x,y,zd1,xx,yy,method);
% zdip1        = (180.0-zdip1).*c1 + zdip1.*c2;
% zr1_latslip1 = griddata(x,y,zr1_latslip,xx,yy,method);
% zr1_dipslip1 = griddata(x,y,zr1_dipslip,xx,yy,method);
zstrike1     = griddata(x,y,zs1,xx,yy,method);
c1           = zstrike1 >  180.0; 
c2           = zstrike1 <= 180.0;
zstrike1     = (zstrike1-180.0).*c1 + zstrike1.*c2;
zdip1        = griddata(x,y,zd1,xx,yy,method);
zdip1        = (180.0-zdip1).*c1 + zdip1.*c2;
zr1_latslip1 = griddata(x,y,zr1_latslip,xx,yy,method);
zr1_dipslip1 = griddata(x,y,zr1_dipslip,xx,yy,method);

% isnan(zr1_latslip1)

zstrike2     = griddata(x,y,zs2,xx,yy,method);
c1           = zstrike2 >  180.0;
c2           = zstrike2 <= 180.0;
zstrike2     = (180.0-zstrike2).*c1 + zstrike2.*c2;
zdip2        = griddata(x,y,zd2,xx,yy,method);
zdip2        = (180.0-zdip2).*c1 + zdip2.*c2;
zr2_latslip2 = griddata(x,y,zr2_latslip,xx,yy,method);
zr2_dipslip2 = griddata(x,y,zr2_dipslip,xx,yy,method);

% reshaping
zstrike1     = reshape(zstrike1,nx*ny,1);
zdip1        = reshape(zdip1,nx*ny,1);
zr1_latslip1 = reshape(zr1_latslip1,nx*ny,1);
zr1_dipslip1 = reshape(zr1_dipslip1,nx*ny,1);
zstrike2     = reshape(zstrike2,nx*ny,1);
zdip2        = reshape(zdip2,nx*ny,1);
zr2_latslip2 = reshape(zr2_latslip2,nx*ny,1);
zr2_dipslip2 = reshape(zr2_dipslip2,nx*ny,1);

icounter = 0.0;
for k = 1:nx*ny
    if isnan(zr1_latslip1(k,1)) == 1 || isnan(zr1_dipslip1(k,1)) == 1
        icounter = icounter + 1;
    end
end

disp(' ');
disp(['Number of NaN: ' num2str(icounter,'%9i')]);
if icounter > 0
% need default values to fill NaN empty nodes
    def_strike = input('  Default strike for NaN nodes? [e.g., 50.]');
    def_dip    = input('  Default dip for NaN nodes?    [e.g., 90.]');
    def_rake   = input('  Default rake for NaN nodes?   [e.g., 180.]');
end

for k = 1:nx*ny
%     if isnan(zr1_latslip1(k,1)) == 1 || isnan(zr1_dipslip1(k,1)) == 1
%         icounter = icounter + 1;
%         zrake3(k,1)   = def_rake;
%         zstrike3(k,1) = def_strike;
%         zdip3(k,1)    = def_dip;
%     else
        [zrake1(k,1) dummy] = comp2rake(zr1_latslip1(k,1),zr1_dipslip1(k,1));
        [zrake2(k,1) dummy] = comp2rake(zr2_latslip2(k,1),zr2_dipslip2(k,1));
        if cflag == 1 % consider conjugate fault planes
            if k==1
                    zrake3(k,1)   =   zrake1(k,1);
                    zstrike3(k,1) = zstrike1(k,1);
                    zdip3(k,1)    =    zdip1(k,1);  
            else
                rake_diff1 = abs(zrake3(k-1,1) - zrake1(k,1));
                rake_diff2 = abs(zrake3(k-1,1) - zrake2(k,1));
                if rake_diff1 < rake_diff2
                    zrake3(k,1)   =   zrake1(k,1);
                    zstrike3(k,1) = zstrike1(k,1);
                    zdip3(k,1)    =    zdip1(k,1);
                else
                    zrake3(k,1)   =   zrake2(k,1);
                    zstrike3(k,1) = zstrike2(k,1);
                    zdip3(k,1)    =    zdip2(k,1);  
                end
            end
        else
                    zrake3(k,1)   =   zrake1(k,1);
                    zstrike3(k,1) = zstrike1(k,1);
                    zdip3(k,1)    =    zdip1(k,1);  
        end
%     end
end

c1             = zdip3 >  90.0;
c2             = zdip3 <= 90.0;
RECEIVERS(:,1) = (zstrike3+180.0).*c1 + zstrike3.*c2;	% strike
RECEIVERS(:,2) = (180.0-zdip3).*c1 + zdip3.*c2;         % dip
RECEIVERS(:,3) = zrake3;                                % rake
if RECEIVERS(:,1) < 0.0
%     RECEIVERS(:,1) = RECEIVERS(:,1) + 360.0;
    RECEIVERS(:,1) = abs(RECEIVERS(:,1));
    RECEIVERS(:,3) = RECEIVERS(:,3) - 180.0;
    if RECEIVERS(:,3) < -180.0
        RECEIVERS(:,3) = RECEIVERS(:,3) + 360.0;
    end
end
zstrike3       = reshape(zstrike3,ny,nx);
zdip3          = reshape(zdip3,ny,nx);
zrake3         = reshape(zrake3,ny,nx);


%======================================================================
%   write a GMT file 
%======================================================================
% setting
    mag1  = 2.0;      % plot size for original data (magnitude)
    mag2  = 1.5;      % plot size for smoothed grid data (magnitude)
    iskip =   1;      % control skipping
    ifill =   1;      % 0: no fill  1: fill
%
% --- Original data ---
header1 = '# note: remove -T1 to see beach ball instead of one nodal plane.';
pscoast1 = ['pscoast -R' num2str(MIN_LON,'%8.3f') '/'...
    num2str(MAX_LON,'%8.3f') '/'...
    num2str(MIN_LAT,'%8.3f') '/'...
    num2str(MAX_LAT,'%8.3f'...
    ) ' -JM7 -G255/200/125 -S80/130/180 -Ba1.0f0.5 -Df -K -P -U > out.ps'];
if ifill == 0
psmeca2 = 'psmeca << END -R -JM -Sa2.0c -T1 -P -V -O >> out.ps';
elseif ifill == 1
psmeca2 = 'psmeca << END -R -JM -Sa2.0c -G10/10/10 -P -V -O -K >> out.ps';
end
dlmwrite('receivers_original_meca.gmt',header1,'delimiter','');
dlmwrite('receivers_original_meca.gmt',pscoast1,'delimiter',''); 
% dlmwrite('receivers_original_meca.gmt',psmeca1,'-append','delimiter','');
dlmwrite('receivers_original_meca.gmt',psmeca2,'-append','delimiter','');
%    a = xy2lonlat([reshape(xx,nx*ny,1) reshape(yy,nx*ny,1)]);
%    mag = 0.5;      % plot size (magnitude)
%    iskip = 10;     % control skipping
    nn = size(EQ_DATA,1); 
for k = 1:nn
%     skip = mod(k,iskip);
%     if skip == 0
        focalmeca = [num2str(EQ_DATA(k,1),'%8.3f') ' ' num2str(EQ_DATA(k,2),...
        '%8.3f') ' 10.0 ' num2str(EQ_DATA(k,10),'%3i') ' ' num2str(EQ_DATA(k,...
        11),'%3i') ' ' num2str(EQ_DATA(k,12),'%3i') ' ' num2str(mag1,...
        '%3.1f') ' 0.0 0.0'];
    dlmwrite('receivers_original_meca.gmt',focalmeca,'-append','delimiter','');
%   end
end
dlmwrite('receivers_original_meca.gmt','END','-append','delimiter','');

% --- Smoothed data ---
header1 = '# note: remove -T1 to see beach ball instead of one nodal plane.';
pscoast1 = ['pscoast -R' num2str(MIN_LON,'%8.3f') '/'...
    num2str(MAX_LON,'%8.3f') '/'...
    num2str(MIN_LAT,'%8.3f') '/'...
    num2str(MAX_LAT,'%8.3f'...
    ) ' -JM7 -G255/200/125 -S80/130/180 -Ba1.0f0.5 -Df -K -P -U > out.ps'];
% psmeca1 = 'psmeca << END -R -JM -Sa2.0c -G10/10/10 -P -V -O -K >> out.ps';
psize = abs((XGRID(2)-XGRID(1))/(XGRID(end)-XGRID(1))) * 40.0;
if ifill == 0
psmeca3 = ['psmeca << END -R -JM -Sa' num2str(psize,'%3.1f') 'c -T1 -P -V -O >> out.ps'];
elseif ifill == 1
psmeca3 = ['psmeca << END -R -JM -Sa' num2str(psize,'%3.1f') 'c -G100/100/100 -P -V -O >> out.ps'];
end
dlmwrite('receivers_smoothed_meca.gmt',header1,'delimiter','');
dlmwrite('receivers_smoothed_meca.gmt',pscoast1,'delimiter',''); 
% dlmwrite('receivers_smoothed_meca.gmt',psmeca1,'-append','delimiter','');
% dlmwrite('receivers_smoothed_meca.gmt',psmeca2,'-append','delimiter','');
dlmwrite('receivers_smoothed_meca.gmt',psmeca3,'-append','delimiter','');
    a = xy2lonlat([reshape(xx,nx*ny,1) reshape(yy,nx*ny,1)]);
for k = 1:nx*ny
    skip = mod(k,iskip);
    if skip == 0
        RECEIVERS(k,4) = a(k,1);
        RECEIVERS(k,5) = a(k,2);
        focalmeca = [num2str(a(k,1),'%8.3f') ' ' num2str(a(k,2),...
        '%8.3f') ' 10.0 ' num2str(int16(RECEIVERS(k,1)),...
        '%3i') ' ' num2str(int16(RECEIVERS(k,...
        2)),'%3i') ' ' num2str(int16(RECEIVERS(k,3)),...
        '%3i') ' ' num2str(mag2,...
        '%3.1f') ' 0.0 0.0'];
    dlmwrite('receivers_smoothed_meca.gmt',focalmeca,'-append','delimiter','');
    end
end
dlmwrite('receivers_smoothed_meca.gmt','END','-append','delimiter','');

% --- display in Command Window ---
disp('GMT script ''receivers_original_meca.gmt'' file is saved in the current directory.');
disp('GMT script ''receivers_smoothed_meca.gmt'' file is saved in the current directory.');
