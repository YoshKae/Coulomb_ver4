function afault_drawing(flag)
% simple drawing of active fault lines using ascii input file
%
% input: flag = 1, lon (1st column) and lat (2nd column)
%        flag = 0, lat (1st column) and lon (2nd column)
% output:

global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID
global PREF
global H_MAIN
global AFAULT_DATA
global ICOORD LON_GRID
global HOME_DIR OVERLAY_MARGIN
persistent AFAULT_DIR
% for enhancing readability
xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);   
xinc = (xf - xs)/(MAX_LON-MIN_LON);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);
% automatically chosen directory 'active_fault_data'
try
    cd(AFAULT_DIR);
catch
    try
        cd('active_fault_data');
    catch
        cd(HOME_DIR);
    end
end
%---------------------------
if isempty(AFAULT_DATA)==1
    [filename,pathname] = uigetfile('*.*',' Open fault line data file');
    if isequal(filename,0)
        disp('  User selected Cancel')
%        close(hformat);
        return
    else
        disp('  ----- active fault data -----');
        disp(['  User selected', fullfile(pathname, filename)])
    end
%	fid = fopen(filename,'r');
    AFAULT_DIR = pathname;
    fid = fopen(fullfile(pathname, filename),'r');
   n = 2000000;  % dummy number (probably use 'end' later)
%   n = 10000;  % dummy number (probably use 'end' later)
    count = 0;
    hm = wait_calc_window;
% hm = msgbox('Now reading data. Please wait...');
    for m = 1:n
        count = count + 1;
    if m == 1
        a = textscan(fid,'%f %f','headerlines', 2);
        if flag == 0
        y{m} = a{1};
        x{m} = a{2};
        elseif flag == 1
        x{m} = a{1};
        y{m} = a{2};
        end
    else
        a = textscan(fid,'%f %f','headerlines', 1);
        if flag == 0
        y{m} = a{1};
        x{m} = a{2};
        elseif flag == 1
        x{m} = a{1};
        y{m} = a{2};
        end
    end
    if isempty(a{1}) && isempty(a{2})
        break
    end
    end
fclose(fid);

% dummy (buffer) width to select the coastline info a bit larger than study area
dummy = OVERLAY_MARGIN;
disp(['   * Extra margin width of the data screening is ' num2str(int16(dummy)) ' km']);
disp(['   * If you want to trim more, change the value OVERLAY_MARGIN in this']);
disp(['   * command window and then read it again. It is useful for 3D view.']);
disp(' ');
disp('   * To save the areal active fault data as binary, use the following command');
disp('   * in the Command Window.');
disp('   * save filename AFAULT_DATA (e.g., save myacault.mat AFAULT_DATA)');
disp('   * To read the .mat formatted active fault data, use ''File -> Open...'' menu later.');
disp(' ');
icount = 0;
temp = 0;
nn = 0;
%    hm = msgbox('Now plotting the fault lines. Please wait...');
    if isempty(H_MAIN) ~= 1
    figure(H_MAIN);
    hold on;
    end

for m = 1:count
    xx = [x{m}];
    yy = [y{m}];
    xx = xs + (xx - MIN_LON) * xinc;
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
%             b = xy2lonlat([xx(k+1) yy(k+1)]);
%          if ICOORD == 2 && isempty(LON_GRID) ~= 1
%             h = plot(gca,[a(1) b(1)],[a(2) b(2)],'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
%          else
%             h = plot(gca,[xx(k) xx(k+1)],[yy(k) yy(k+1)],'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
%          end
%             set(h,'Tag','AfaultObj');
%             AFAULT_DATA(nn,1) = icount;
%             AFAULT_DATA(nn,2) = a(1);	% lon. (start)
%             AFAULT_DATA(nn,3) = a(2);   % lat. (start)
%             AFAULT_DATA(nn,4) = b(1);   % lon. (finish)
%             AFAULT_DATA(nn,5) = b(2);   % lat. (finish)
%             AFAULT_DATA(nn,6) = xx(k);
%             AFAULT_DATA(nn,7) = yy(k);
%             AFAULT_DATA(nn,8) = xx(k+1);
%             AFAULT_DATA(nn,9) = yy(k+1);
            AFAULT_DATA(nn,1) = a(1);	% lon. (start)
            AFAULT_DATA(nn,2) = a(2);   % lat. (start)
            AFAULT_DATA(nn,3) = xx(k);
            AFAULT_DATA(nn,4) = yy(k);
        hold on;
        end
        end
        end
        end
end
        % put NaN tag to raise drawing pen (breaking active fault segment)
        if nn > nkeep
        nn = nn + 1;
            AFAULT_DATA(nn,1) = NaN;
            AFAULT_DATA(nn,2) = NaN;
            AFAULT_DATA(nn,3) = NaN;
            AFAULT_DATA(nn,4) = NaN;
        end
end
close(hm);
end

AFAULT_DATA = single(AFAULT_DATA);    % to reduce memory size

% ---------------------------- actual plotting --------------
if isempty(AFAULT_DATA)~=1
    hm = wait_calc_window;
    if isempty(H_MAIN) ~= 1
    figure(H_MAIN);
    hold on;
    end
    [m,n] = size(AFAULT_DATA);
% ===== old format plotting =================
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This active fault data AFAULT_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = [rot90(AFAULT_DATA(:,2));rot90(AFAULT_DATA(:,4))];
            y1 = [rot90(AFAULT_DATA(:,3));rot90(AFAULT_DATA(:,5))];
        else
            x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
            y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
        end
    else
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = AFAULT_DATA(:,1);
            y1 = AFAULT_DATA(:,2);
        else
            x1 = AFAULT_DATA(:,3);
            y1 = AFAULT_DATA(:,4);
        end
    end
	h = plot(gca,x1,y1,'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
    set(h,'Tag','AfaultObj');
    hold on;
    close(hm);
end

cd(HOME_DIR);
