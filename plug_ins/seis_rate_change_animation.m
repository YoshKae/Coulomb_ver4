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
tic
load('MyColormap2','ANATOLIA_gray'); % color map
try
    if isempty(sat_control)
        sat_control = 2; % to control color saturation
    end
catch
    sat_control = 2;  % default value
end
sat_control = 2;

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

%================================ INPUT =================
% 
%   ..... t1 ............... tE .. t3 ..............t4
%          | (background)     |    | (comp. period)  |
%
% Background start
        t1y = 1990;     % year
        t1m =    1;     % month
        t1d =    1;     % day
        t1h =    0;     % hour
        t1n =    0;     % minute
        t1s =    0;     % second
% Event time (EQ time)
        tEy = 2017;     % year
        tEm =    9;     % month
        tEd =    7;     % day
        tEh =   23;     % hour
        tEn =   49;     % minute
        tEs =    0;     % second
% Starting time for the predicting period
        t3y = 2017;     % year
        t3m =    9;     % month
        t3d =    7;     % day
        t3h =   23;     % hour
        t3n =   49;     % minute
        t3s =    0;     % second
%         t3y = 2011;     % year
%         t3m =    3;     % month
%         t3d =   11;     % day
%         t3h =   14;     % hour
%         t3n =   46;     % minute
%         t3s =   18;     % second
% Ending time for the predicting period
        t4y = 2017;     % year
        t4m =   11;     % month
        t4d =   14;     % day
        t4h =   23;     % hour
        t4n =   59;     % minute
        t4s =    0;     % second

% Smooting radius
        r   =   20;       % km
% Minimum rate
        minr = 0.0;
%========================================================
        
        t1time  = datenum(t1y,t1m,t1d,t1h,t1n,t1s);
        evttime = datenum(tEy,tEm,tEd,tEh,tEn,tEs);
        t3time  = datenum(t3y,t3m,t3d,t3h,t3n,t3s); 
        t4time  = datenum(t4y,t4m,t4d,t4h,t4n,t4s);         
% rate calculation for the first period
t1 = (evttime - t1time)/365.25;
neq = length(EQ_DATA(:,16));

for l = 1:nx                % x loop
    for m = 1:ny            % y loop
        rate1(m,l) = minr;  % set default minimum value to escape divided by zero
        for k = 1:neq       % EQ loop
            if eq_datenum(k) < evttime && eq_datenum(k) >= t1time
                dist = sqrt((EQ_DATA(k,16)-xs(l))^2+(EQ_DATA(k,17)-ys(m))^2);
                if dist < r
                    rate1(m,l) = rate1(m,l) + 1;
                end
            end
        end
    end
end
% indnan1 = find(rate1 == minr);
rateAdj = length(find(t1time <= eq_datenum & eq_datenum < evttime)) / sum(rot90(sum(rate1)));
rate1 = rate1 * rateAdj / t1;
% c1 = rate1 == 0; c2 = rate1 ~= 0;
% if isempty(minr)
%     minr = 0.000001;
% end
% rate1 = rate1 .* c1 .* minr + rate1 .* c2;  % to escape devided by zero

% rate calculation for the second period
t34 = (t4time - t3time)/365.25;

neq = length(EQ_DATA(:,16));
for l = 1:nx                % x loop
    for m = 1:ny            % y loop
        rate2(m,l) = 0;
        for k = 1:neq       % EQ loop
            if eq_datenum(k) >= t3time && eq_datenum(k) <= t4time
                dist = sqrt((EQ_DATA(k,16)-xs(l))^2+(EQ_DATA(k,17)-ys(m))^2);
                if dist < r
                    rate2(m,l) = rate2(m,l) + 1;
                end
            end
        end
    end
end

% indnan2 = find(rate2 == 0.0);
rateAdj = length(find(eq_datenum >= t3time & eq_datenum < t4time)) / sum(rot90(sum(rate2)));
rate2 = rate2 * rateAdj / t34;

rate_change = log10(rate2 ./ rate1);
    undefined1 = rate1 == minr;
    undefined2 = rate2 == 0.0;
    undefined  = (undefined1-1).*(undefined2-1);
    indund     = find(undefined == 0);
rate_change(indund) = NaN;

%======= making image for undefined area =================================
figure('Name','Undefined area','NumberTitle','off');
hold on;
ac = image(-isnan(rate_change),'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(1) YGRID(end)]);colormap(gray);
set(gca,'YDir','normal');
title('Undefined areas');
caxis([-2 0]);
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
cadj   = sat_control/30.0;
c1     = isnan(rate_change);
c2     = ~isnan(rate_change);
c2maxu = rate_change.*c2 >= sat_control;
c2maxd = rate_change.*c2 < sat_control;
c2minu = rate_change.*c2 > -sat_control;
c2mind = rate_change.*c2 <= -sat_control;
c3 = (-100000)*c1 + (sat_control-cadj).*c2maxu + (sat_control+cadj)*c2mind...
	+ c2maxd.*c2minu.*rate_change;
figure('Name','Seismicity rate change','NumberTitle','off');
hold on;
% ac = image(c3,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
%             'YData',[YGRID(1) YGRID(end)]);colormap(ANATOLIA_gray);
ac = image(c3,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
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
% plot([xr0 xr1 xr1 xr0 xr0],...
%     [yr0 yr0 yr1 yr1 yr0]);
%     set(gca,'DataAspectRatio',[1 1 1],...
%     'Color',[0.9 0.9 0.9],...
%     'PlotBoxAspectRatio',[1 1 1]);

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
% TO SAVE RATE CHANGE MATRIX
%===============================================
disp('To save the log-scale rate change, save the variable ''rate_change''');
disp('To save the normal scale rate change, save the variable ''rate2''');
disp('(e.g., save SeisRateChange.mat rate_change)');

% clear all temporal variables because this is a script (not a function)
% clear x0 y0 xs xf ys yf nx ny neq t1time t3time t4time tp reply;
% clear t1 t34 t2d t2h t2m t2n t2y tsep rate1 rateAdj
% clear x1 xpos xr0 xr1 y1 ypos yr0 yr1

toc





