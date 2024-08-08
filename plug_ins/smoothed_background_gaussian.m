% SMOOTHED_BACKGROUND
%
% This script makes simple mozaic pattern background seismicity with the
% same grid spacing with Coulomb calculation
%
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------

try
    if isempty(sat_control)
        sat_control = 0.5; % to control color saturation
    end
catch
    sat_control = 0.5;  % default value 0.5
end

if isempty(EQ_DATA)
    h = errordlg(['No earthquake data read in MATLAB memory. So no ',...
        'image can be made. Read earthquake data in advance.'],...
        'File Error!');
    waitfor(h);
    return
end
if GRID(3)-XGRID(end) > 0
    x0 = [XGRID GRID(3)];
    nx = length(XGRID);
else
    x0 = XGRID;
    nx = length(XGRID)-1;
end
if GRID(4)-YGRID(end) > 0
    y0 = [YGRID GRID(4)];
    ny = length(YGRID);
else
    y0 = YGRID;
	ny = length(YGRID)-1;
end
    xs = x0(1:end-1);
    xf = x0(2:end);
    ys = y0(1:end-1);
    yf = y0(2:end);

BACKGROUND = zeros(length(YGRID),length(XGRID));

% --- time sorting for rate calculation ------------------
eq_datenum = rot90(datenum(double(EQ_DATA(:,3)),double(EQ_DATA(:,4)),...
                double(EQ_DATA(:,5)),double(EQ_DATA(:,8)),double(EQ_DATA(:,9)),0));
% ****** dialogical inputs *******************************
disp('----- Time period of the plotted earthquake data -----');
disp(['     START: ' num2str(EQ_DATA(1,3),'%4i') '/' num2str(EQ_DATA(1,4),'%2i') '/'...
    num2str(EQ_DATA(1,5),'%2i') '/' num2str(EQ_DATA(1,8),'%2i') '/'...
    num2str(EQ_DATA(1,8),'%2i')]);
disp(['       END: ' num2str(EQ_DATA(end,3),'%4i') '/' num2str(EQ_DATA(end,4),'%2i') '/'...
    num2str(EQ_DATA(end,5),'%2i') '/' num2str(EQ_DATA(end,8),'%2i') '/'...
    num2str(EQ_DATA(end,8),'%2i')]);
disp(' ');
reply = input('Use the period between the first shock and last shock above? y/n [y]:','s');
if isempty(reply)
    reply = 'y';
end
switch reply
    case 'y'
        mintime = min(eq_datenum);
        maxtime = max(eq_datenum);
        r   = str2double(input('  radius: km (e.g., 5)?','s'));
    case 'n'
        t0y = str2double(input('  Starting time: year  (integer e.g., 1998)?','s'));
        t0m = str2double(input('  Starting time: month (integer e.g.,    4)?','s'));
        t0d = str2double(input('  Starting time: day   (integer e.g.,   21)?','s'));
        t1y = str2double(input('  Ending time: year    (integer e.g., 2003)?','s'));
        t1m = str2double(input('  Ending time: month   (integer e.g.,   12)?','s'));
        t1d = str2double(input('  Ending time: day     (integer e.g.,   31)?','s'));
        r   = str2double(input('  radius: km (double e.g., 5)?','s'));
        mintime = datenum(t0y,t0m,t0d);
        maxtime = datenum(t1y,t1m,t1d);
    otherwise
        return
end
tp = (maxtime - mintime)/365.25;

kconst = 1.0/sqrt(2.0*pi());

icount = zeros(ny,nx);
BACKGROUND = zeros(ny,nx);
neq = length(EQ_DATA(:,16));
for k = 1:neq               % EQ loop
    for l = 1:nx            % x loop
        for m = 1:ny        % y loop
%         BACKGROUND(m,l) = 0;
            dist = sqrt((EQ_DATA(k,16)-xs(l))^2+(EQ_DATA(k,17)-ys(m))^2);
%             if dist < r
%                 BACKGROUND(m,l) = BACKGROUND(m,l) + 1;
%             end
            BACKGROUND(m,l) = BACKGROUND(m,l)+kconst*exp(-(dist/r)*(dist/r));
        end
    end
end
% *********************************************************

% translate number of earthuakes in each node into annual seis rate
% BACKGROUND = BACKGROUND / tp; % annual rate
% rateAdj = length(EQ_DATA(:,16)) / sum(rot90(sum(BACKGROUND)));
% BACKGROUND = BACKGROUND * rateAdj; % to adjust to be the same with total num of shocks

rateAdj    = length(EQ_DATA(:,16)) / sum(rot90(sum(BACKGROUND)));
BACKGROUND = BACKGROUND * rateAdj; % to adjust to be the same with total num of shocks
BACKGROUND = BACKGROUND / tp; % annual rate

%======= making image =================================
fint = 2; % switch tiled or interporated (1: tiled, 2: interp)
figure('Name','Annual seismicity rate in each grid area','NumberTitle','off');
hold on;
if fint == 2
	[out,new_xgrid,new_ygrid] = interporation(BACKGROUND, ...
                                    10, XGRID, YGRID(1:end-1));
	ac = image(flipud(out),'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
else
    ac = image(BACKGROUND,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(1) YGRID(end)]);colormap(ANATOLIA);
end
set(gca,'YDir','normal');
title(['Background seismicity rate [ / yr / ' num2str(GRID(5)*GRID(6),'%5.3f') ' km^2]']);
% nsat = max(rot90(max(BACKGROUND)))*sat_control;
nsat = abs(sat_control);

caxis([-nsat nsat]);
axis image;
colorbar('location','EastOutside');

% --- to draw reliable rectangular area determined from radius
hold on;
xr0 = GRID(1)+r; yr0 = GRID(2)+r;
xr1 = GRID(3)-r; yr1 = GRID(4)-r;
plot([xr0 xr1 xr1 xr0 xr0],...
    [yr0 yr0 yr1 yr1 yr0]);
    set(gca,'DataAspectRatio',[1 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1]);

%======== overlay drawing ============================
% global COAST_DATA EQ_DATA AFAULT_DATA GTEXT_DATA
% global ICOORD LON_GRID PREF
% global NH_COMMENT
% global H_MAIN

% ----- coast line plot -----
if isempty(COAST_DATA)~=1
        hold on;
    [m,n] = size(COAST_DATA);
%     if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         x1 = [rot90(COAST_DATA(:,2));rot90(COAST_DATA(:,4))];
%         y1 = [rot90(COAST_DATA(:,3));rot90(COAST_DATA(:,5))];
%     else
    if n == 9
        x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
        y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
    else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
    end
%    end
        hold on;
        h = plot(gca,x1,y1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
%         set(h,'Tag','CoastlineObj');
        hold on;
end
% % ----- active fault plot -----
if isempty(AFAULT_DATA)~=1
         hold on;
    [m,n] = size(AFAULT_DATA);
    if n == 9
        x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
        y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
    else
        x1 = AFAULT_DATA(:,3);
        y1 = AFAULT_DATA(:,4);
    end
    h = plot(gca,x1,y1,'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
%     set(h,'Tag','AfaultObj');
  
end

%===============================================
% REPEATING PROCESS TO CHANGE SATURATION COLOR
%===============================================
disp(' ');
disp(['The current color saturation value is ' num2str(sat_control,...
    '%4.3f') '/each area/yr']);
reply = input('Do you want to change the value? y/n [y]:','s');
if isempty(reply)
    reply = 'n';
end
switch reply
    case 'y'
        sat_control   = str2double(input('  new value (double e.g., 5)?','s'));
        smoothed_background;
    case 'n'
    %===============================================
    % EQ OVERLAY PLOTTING
    %===============================================
    reply = input('Do you want to overlay earthquakes? y/n [y]:','s');
    if isempty(reply)
        reply = 'n';
    end
    switch reply
        case 'y'
        if ICOORD==2
            ICOORD = 1; % x & y plot (for background plotting now)
            hold on;
            earthquake_plot;
            ICOORD = 2;
        else
            hold on;
            earthquake_plot;
        end
        case 'n'
            return
    end
end

% clear all temporal variables because this is a script (not a function)
clear x0 y0 xs xf ys yf nx ny neq mintime maxtime tp reply;
clear ac dist eq_datenum h i icount k l m n nsat r rateAdj reply
clear sat_control x1 xr0 xr1 y1 yr0 yr1







