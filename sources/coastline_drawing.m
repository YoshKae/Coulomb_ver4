function coastline_drawing
% simple drawing of coast lines using ascii input file
%
global MIN_LAT MAX_LAT MIN_LON MAX_LON ZERO_LON
global GRID
global PREF
global H_MAIN
global ICOORD LON_GRID
global COAST_DATA
global HOME_DIR
global OVERLAY_MARGIN
persistent COAST_DIR

% for enhancing readability
xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);
% automatically chosen directory 'coastline_data'
try
    cd(COAST_DIR);
catch
    try
        cd('coastline_data');
    catch
        cd(HOME_DIR);
    end
end
    
% Chose a data file in default dialog
if isempty(COAST_DATA)==1

%     hformat = coastline_format;
    [filename,pathname] = uigetfile('*.*',' Open coastline data file');
    if isequal(filename,0)
        disp('  User selected Cancel')
%         close(hformat);
        return
    else
        disp('  ----- coastline data -----');
        disp(['  User selected', fullfile(pathname, filename)])
    end
fid = fopen(filename,'r');
COAST_DIR = pathname;

% ***** TEST reading to check western hemishere? *****************
n = 10000;  % dummy number (probably use 'end' later)
count = 0;
for m = 1:n
    count = count + 1;
    if m == 1
        test = textscan(fid,'%f %f','headerlines', 2);
        aa{m} = test{1};
        bb{m} = test{2};
    else
        test = textscan(fid,'%f %f','headerlines', 1);
        aa{m} = test{1};
        bb{m} = test{2};
    end
    check_test = [test{1}];
%     % for NOAA painful format
	if length(check_test) <= 1
        break
    end 
end
for i = 1:size(aa,1);
    aaa = [aa{i}];
end
if max(aaa) > 180.0
    but = 'plus';
else
    but = 'minus';
end
% ****************************************************************

%     but = questdlg('Western hemisphere is treated as ',...
%         'coastline data format','plus','minus','plus');
if length(but) == 4     % 'plus' W hemisphere is treated as positive in the input file
% adjusting GMT format (no negative longitude)
    if MIN_LON < 0.0
        minlon = 360.0 + MIN_LON;
    else
        minlon = MIN_LON;
    end
    if MAX_LON < 0.0
        maxlon = 360.0 + MAX_LON;
    else
        maxlon = MAX_LON;
    end
    if ZERO_LON < 0.0
        zerolon = 360.0 + ZERO_LON;
    else
		erolon = ZERO_LON;
    end
elseif length(but) == 5    % 'minus' (negative)
    minlon = MIN_LON;
	maxlon = MAX_LON;
	zerolon = ZERO_LON;
else                        % empty
    warndlg('Check your coastline file.','!! Warning !!');
    return
end
xinc = (xf - xs)/(maxlon-minlon);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);
end


%---------------------

hm = wait_calc_window;

%---------------------
if isempty(COAST_DATA)==1
n = 10000;  % dummy number (probably use 'end' later)
count = 0;
% nseg = 0;
fid = fopen(fullfile(pathname, filename),'r');
for m = 1:n
    count = count + 1;
    if m == 1
        a = textscan(fid,'%f %f','headerlines', 2);
        x{m} = a{1};
        y{m} = a{2};
    else
        a = textscan(fid,'%f %f','headerlines', 1);
        x{m} = a{1};
        y{m} = a{2};
    end
    checka = [a{1}];
%     nseg   = nseg + sum(isnan(checka));
%     size(checka)
%     % for NOAA painful format
	if length(checka) <= 1
        break
    end
    
end

fclose(fid);
% COAST_DATA = zeros(nn,3); %(number of segment x y xnext ynext)
end
%-----------

% h = findobj('Tag','main_menu_window');
if isempty(H_MAIN) ~= 1
    figure(H_MAIN);
    hold on;
end

%---------------------
if isempty(COAST_DATA)==1
% dummy width to select the coastline info a bit larger than study area
dummy = OVERLAY_MARGIN;
disp(['   * Extra margin width of the data screening is ' num2str(int16(dummy)) ' km']);
disp(['   * If you want to trim more, change the value OVERLAY_MARGIN in this']);
disp(['   * command window and then read it again. It is useful for 3D view.']);
disp(' ');
disp('   * To save the areal coastline data as binary, use the following command');
disp('   * in the Command Window.');
disp('   * save filename COAST_DATA (e.g., save mycoastline.mat COAST_DATA)');
disp('   * To read the .mat formatted coastline data, use ''File -> Open...'' menu later.');
disp(' ');
icount = 0;
temp = 0;
nn = 0;

% count
nlength = size(x,1);

if count <= 2           % nasty NOAA ('nan nan') format
for m = 1:nlength
    xx = [x{m}];
    yy = [y{m}];
        xx = xs + (xx - minlon) * xinc;
        yy = ys + (yy - MIN_LAT) * yinc;
    hold on;
for k = 1:length(xx)
        if isnan(xx(k))
            nn = nn + 1;
            COAST_DATA(nn,1) = NaN;
            COAST_DATA(nn,2) = NaN;
            COAST_DATA(nn,3) = NaN;
            COAST_DATA(nn,4) = NaN;
            continue
        else
        if xx(k) >= (xs-dummy) 
        if xx(k) <= (xf+dummy)
        if yy(k) >= (ys-dummy)
        if yy(k) <= (yf+dummy)
            nn = nn + 1;
            if m ~= temp
                icount = icount + 1;
                temp = m;
            end
            a = xy2lonlat([xx(k) yy(k)]);
            COAST_DATA(nn,1) = a(1);
            COAST_DATA(nn,2) = a(2);
            COAST_DATA(nn,3) = xx(k);
            COAST_DATA(nn,4) = yy(k);
        hold on;
        end
        end
        end
        end
        end
end
end

else            % followings are ('< deliminator format')
% m is segment number
for m = 1:count
    xx = [x{m}];
    yy = [y{m}];
        xx = xs + (xx - minlon) * xinc;
        yy = ys + (yy - MIN_LAT) * yinc;
        nkeep = nn;
    hold on;
for k = 1:length(xx)
        if xx(k) >= (xs-dummy) 
        if xx(k) <= (xf+dummy)
        if yy(k) >= (ys-dummy)
        if yy(k) <= (yf+dummy)
            nn = nn + 1;
            if m ~= temp
                icount = icount + 1;
                temp = m;
            end
            a = xy2lonlat([xx(k) yy(k)]);
            
            COAST_DATA(nn,1) = a(1);
            COAST_DATA(nn,2) = a(2);
            COAST_DATA(nn,3) = xx(k);
            COAST_DATA(nn,4) = yy(k);
        hold on;
        end
        end
        end
        end
end
        % put NaN tag to raise drawing pen (breaking coastline segment)
        if nn > nkeep
        nn = nn + 1;
            COAST_DATA(nn,1) = NaN;
            COAST_DATA(nn,2) = NaN;
            COAST_DATA(nn,3) = NaN;
            COAST_DATA(nn,4) = NaN;
        end
end
end
% close(hformat);
end

COAST_DATA = single(COAST_DATA);    % to reduce memory size

% ---------------------------- actual plotting --------------
if isempty(COAST_DATA)~=1
    [m,n] = size(COAST_DATA);   % to distinguish old or new format
% ===== old format plotting =================
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This coastline data COAST_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = [rot90(COAST_DATA(:,2));rot90(COAST_DATA(:,4))];
            y1 = [rot90(COAST_DATA(:,3));rot90(COAST_DATA(:,5))];
        else
            x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
            y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
        end
% ===== new format plotting =================
    else
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = COAST_DATA(:,1);
            y1 = COAST_DATA(:,2);
        else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
        end
    end
        hold on;
        h = plot(gca,x1,y1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
        set(h,'Tag','CoastlineObj');
        hold on;
end
% -------------------------------------------------------------
% order_overlay_handle(1);
close(hm);
% toc
cd(HOME_DIR);
