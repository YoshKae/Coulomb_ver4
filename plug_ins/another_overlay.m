function another_overlay
% simple drawing of lines using ascii input file
%
% input: lon (1st column) and lat (2nd column)
%
% output:

global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID
global PREF
global H_MAIN
global ICOORD LON_GRID
global HOME_DIR OVERLAY_MARGIN

% input dialog to determine line color and line width
prompt = {'Enter line color: R (0-1)', 'Enter line color: G (0-1)',...
    'Enter line color: B (0-1)','Enter line width:'};
dlg_title = 'Set up line color and width';
num_lines = 1;
def = {'0.9','0.2','0.2','0.5'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
rr = str2double(answer{1}); % R
gg = str2double(answer{2}); % G
bb = str2double(answer{3}); % B

% handvisibility on for main graphic window
set(H_MAIN,'HandleVisibility','on');
h = figure(H_MAIN);

% if the map is in cartesian coordinate, message box warns the user
if ICOORD == 1
    msgbox('Change the coordinate model lon and lat and try again.') 
end

% for enhancing readability
xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);   
xinc = (xf - xs)/(MAX_LON-MIN_LON);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);

% dialog open to read the ascii data
    [filename,pathname] = uigetfile('*.*',' Open line data file');
    if isequal(filename,0)
        disp('  User selected Cancel')
        return
    else
        disp('  ----- another line data -----');
        disp(['  User selected', fullfile(pathname, filename)])
    end
    fid = fopen(fullfile(pathname, filename),'r');
    n = 10000;  % dummy number (probably use 'end' later)
    count = 0;
    hm = wait_calc_window;
    for m = 1:n
        count = count + 1;
        a = textscan(fid,'%f %f','headerlines', 1);
                x{m} = a{1};
                y{m} = a{2};
    end
    fclose(fid);

% dummy (buffer) width to select the coastline info a bit larger than study area
dummy = OVERLAY_MARGIN;
icount = 0;
temp = 0;
nn = 0;

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
            LINE_DATA(nn,1) = a(1);	% lon. (start)
            LINE_DATA(nn,2) = a(2);   % lat. (start)
            LINE_DATA(nn,3) = xx(k);
            LINE_DATA(nn,4) = yy(k);
        hold on;
        end
        end
        end
        end
end
        % put NaN tag to raise drawing pen (breaking active fault segment)
        if nn > nkeep
        nn = nn + 1;
            LINE_DATA(nn,1) = NaN;
            LINE_DATA(nn,2) = NaN;
            LINE_DATA(nn,3) = NaN;
            LINE_DATA(nn,4) = NaN;
        end
end
close(hm);
LINE_DATA = single(LINE_DATA);    % to reduce memory size
assignin('base','LINE_DATA',LINE_DATA)
disp(' ');
disp('Data exported to Workspace.  Variable name: ''LINE_DATA''');
disp('You can plot this data using ''more_overlay_plot'' function');
disp('e.g., more_overlay_plot(LINE_DATA,[1 0 0],1.0)');
disp(' ');

more_overlay_plot(LINE_DATA,[rr gg bb],str2double(answer{4}));

cd(HOME_DIR);

set(H_MAIN,'HandleVisibility','callback');
