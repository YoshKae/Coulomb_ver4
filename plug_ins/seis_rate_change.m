% SEIS_RATE_CHANGE
%
% This script makes seismicity rate change comparing two periods
% same grid spacing with Coulomb calculation
%
% Delta R = R t2 / R t1;
%   t1: first period
%   t2: second period
%
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------

try
    if isempty(sat_control)
        sat_control = 2; % to control color saturation
    end
catch
    sat_control = 2;  % default value
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

rate1 = zeros(length(YGRID),length(XGRID));
rate2 = zeros(length(YGRID),length(XGRID));
rate_change = zeros(length(YGRID),length(XGRID));

% --- time sorting for rate calculation ------------------
eq_datenum = rot90(datenum(double(EQ_DATA(:,3)),double(EQ_DATA(:,4)),...
                    double(EQ_DATA(:,5)),double(EQ_DATA(:,8)),...
                    double(EQ_DATA(:,9)),0));
% ****** dialogical inputs *******************************
disp(' ');
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
        t2y  = str2double(input('  Event time: year  (integer e.g., 2000)?','s'));
        t2m  = str2double(input('  Event time: month (integer e.g.,    4)?','s'));
        t2d  = str2double(input('  Event time: day   (integer e.g.,   21)?','s'));
        t2h  = str2double(input('  Event time: hour  (integer e.g.,    5)?','s'));
        t2n  = str2double(input('  Event time: minute(integer e.g.,   56)?','s'));
        r    = str2double(input('  radius: km (e.g., 5)?','s'));
%        minr = str2double(input('  minimum rate for first period: km (e.g., 0.000001)?','s'));
        mintime = min(eq_datenum);
        evttime = datenum(t2y,t2m,t2d,t2h,t2n,0);
        maxtime = max(eq_datenum);
    case 'n'
        t1y  = str2double(input('  Starting time: year  (integer e.g., 1998)?','s'));
        t1m  = str2double(input('  Starting time: month (integer e.g.,    4)?','s'));
        t1d  = str2double(input('  Starting time: day   (integer e.g.,   21)?','s'));
        t3y  = str2double(input('  Ending time:   year  (integer e.g., 2003)?','s'));
        t3m  = str2double(input('  Ending time:   month (integer e.g.,   12)?','s'));
        t3d  = str2double(input('  Ending time:   day   (integer e.g.,   31)?','s'));
        t2y  = str2double(input('  Event time:    year  (integer e.g., 2000)?','s'));
        t2m  = str2double(input('  Event time:    month (integer e.g.,    4)?','s'));
        t2d  = str2double(input('  Event time:    day   (integer e.g.,   21)?','s'));
        t2h  = str2double(input('  Event time:   hour   (integer e.g.,    5)?','s'));
        t2n  = str2double(input('  Event time:   minute (integer e.g.,   56)?','s'));
        r    = str2double(input('  radius: km (double e.g., 5)?','s'));
%        minr = str2double(input('  minimum rate for first period: km (e.g., 0.000001)?','s'));
        mintime = datenum(t1y,t1m,t1d);
        evttime = datenum(t2y,t2m,t2d,t2h,t2n,0);
        maxtime = datenum(t3y,t3m,t3d);
    otherwise
        return
end
        minr = 0.0;
        
% rate calculation for the first period
t1 = (evttime - mintime)/365.25;
neq = length(EQ_DATA(:,16));
for l = 1:nx                % x loop
    for m = 1:ny            % y loop
        rate1(m,l) = minr;  % set default minimum value to escape divided by zero
        for k = 1:neq       % EQ loop
            if eq_datenum(k) < evttime && eq_datenum(k) >= mintime
                dist = sqrt((EQ_DATA(k,16)-xs(l))^2+(EQ_DATA(k,17)-ys(m))^2);
                if dist < r
                    rate1(m,l) = rate1(m,l) + 1;
                end
            end
        end
    end
end
% indnan1 = find(rate1 == minr);
rateAdj = length(find(mintime <= eq_datenum & eq_datenum < evttime)) / sum(rot90(sum(rate1)));
rate1 = rate1 * rateAdj / t1;
% c1 = rate1 == 0; c2 = rate1 ~= 0;
% if isempty(minr)
%     minr = 0.000001;
% end
% rate1 = rate1 .* c1 .* minr + rate1 .* c2;  % to escape devided by zero

% rate calculation for the second period
% t2 = (evttime - mintime)/365.25;
t2 = (maxtime - evttime)/365.25;

neq = length(EQ_DATA(:,16));
for l = 1:nx                % x loop
    for m = 1:ny            % y loop
        rate2(m,l) = 0;
        for k = 1:neq       % EQ loop
            if eq_datenum(k) >= evttime && eq_datenum(k) <= maxtime
                dist = sqrt((EQ_DATA(k,16)-xs(l))^2+(EQ_DATA(k,17)-ys(m))^2);
                if dist < r
                    rate2(m,l) = rate2(m,l) + 1;
                end
            end
        end
    end
end
% indnan2 = find(rate2 == 0.0);
rateAdj = length(find(eq_datenum >= evttime & eq_datenum < maxtime)) / sum(rot90(sum(rate2)));
rate2 = rate2 * rateAdj / t2;

rate_change = log10(rate2 ./ rate1);
    undefined1 = rate1 == minr;
    undefined2 = rate2 == 0.0;
    undefined  = (undefined1-1).*(undefined2-1);
    indund     = find(undefined == 0);
rate_change(indund) = NaN;

%======= making image for undefined area =================================
% set(gcf,'Renderer','Painters')
figure('Name','Undefined area','NumberTitle','off');
hold on;
ac = image(-isnan(rate_change).*1.0,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(1) YGRID(end)]);colormap(gray);
set(gca,'YDir','normal');
title('Undefined areas');
caxis([-4 0]);
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

%======= making image =================================
figure('Name','Seismicity rate change','NumberTitle','off');
hold on;
ac = image(rate_change,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(1) YGRID(end)]);colormap(ANATOLIA);
set(gca,'YDir','normal');
title('Seismicity rate change (log scale)');
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
    [m,n] = size(COAST_DATA);   % to distinguish old or new format
% ===== old format plotting =================
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This coastline data COAST_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
%         if ICOORD == 2 && isempty(LON_GRID) ~= 1
%             x1 = [rot90(COAST_DATA(:,2));rot90(COAST_DATA(:,4))];
%             y1 = [rot90(COAST_DATA(:,3));rot90(COAST_DATA(:,5))];
%         else
            x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
            y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
%         end
% ===== new format plotting =================
    else
%         if ICOORD == 2 && isempty(LON_GRID) ~= 1
%             x1 = COAST_DATA(:,1);
%             y1 = COAST_DATA(:,2);
%         else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
%         end
    end
        hold on;
        h = plot(gca,x1,y1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
%        set(h,'Tag','CoastlineObj');
        hold on;
end
%****

% % ----- active fault plot -----
if isempty(AFAULT_DATA)~=1
         hold on;
    n = size(AFAULT_DATA,2);
% ===== old format plotting =================
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This active fault data AFAULT_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
%         if ICOORD == 2 && isempty(LON_GRID) ~= 1
%             x1 = [rot90(AFAULT_DATA(:,2));rot90(AFAULT_DATA(:,4))];
%             y1 = [rot90(AFAULT_DATA(:,3));rot90(AFAULT_DATA(:,5))];
%         else
            x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
            y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
%         end
    else
%         if ICOORD == 2 && isempty(LON_GRID) ~= 1
%             x1 = AFAULT_DATA(:,1);
%             y1 = AFAULT_DATA(:,2);
%         else
            x1 = AFAULT_DATA(:,3);
            y1 = AFAULT_DATA(:,4);
%         end
    end
	h = plot(gca,x1,y1,'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
end




%===============================================
% REPEATING PROCESS TO CHANGE SATURATION COLOR
%===============================================
disp(' ');
disp(['The current color saturation value is ' num2str(sat_control,...
    '%6.4f')]);
reply = input('Do you want to change the value? y/n [y]:','s');
if isempty(reply)
    reply = 'n';
end
switch reply
    case 'y'
        sat_control   = str2double(input('  new value (double e.g., 5)?','s'));
        seis_rate_change;
    case 'n'
    %===============================================
    % EQ OVERLAY PLOTTING
    %===============================================
    reply = input('Do you want to overlay all earthquakes? y/n [y]:','s');
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

%===============================================
% TO SAVE RATE CHANGE MATRIX
%===============================================
disp('To save the log-scale rate change, save the variable ''rate_change''');
disp('To save the normal scale rate change, save the variable ''rate2''');
disp('(e.g., save SeisRateChange.mat rate_change)');

% clear all temporal variables because this is a script (not a function)
clear x0 y0 xs xf ys yf nx ny neq mintime maxtime tp reply;
clear t1 t2 t2d t2h t2m t2n t2y tsep rate1 rateAdj
clear x1 xpos xr0 xr1 y1 ypos yr0 yr1





