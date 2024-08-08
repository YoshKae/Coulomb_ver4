function earthquake_plot
% This function plots earthquakes on Coulomb map
% 
global H_MAIN
global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID
global PREF
global ICOORD LON_GRID
global EQ_DATA EQ_ZFORMAT_DATA MIN_EQ_TIME MAX_EQ_TIME
global EQ_FLAG

% global EQ_FORMAT_TYPE

xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);
xinc = (xf - xs)/(MAX_LON-MIN_LON);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);

if isempty(EQ_DATA)==1
% select format using a dialog box (eq_catalog_format_window)
%     EQ_FORMAT_TYPE = 1; % default (HARVARD CMT)
    h = eq_catalog_format_window;
    waitfor(h);
    if isempty(EQ_ZFORMAT_DATA)
        set(findobj('Tag','menu_earthquakes'), 'Checked', 'off');
        return
    end
    if EQ_FLAG == 0
        EQ_ZFORMAT_DATA = [];
        set(findobj('Tag','menu_earthquakes'), 'Checked', 'off');
        return
    end
    icheck = sum(sum(isnan(EQ_ZFORMAT_DATA))');
    if icheck >=1
        EQ_ZFORMAT_DATA = [];
        set(findobj('Tag','menu_earthquakes'), 'Checked', 'off');
        h = errordlg('This may not be a properly formatted data.','!! Warning !!');
        waitfor(h);
        return
    end
% find min time and max time for EQ screening process
    [m,n] = size(EQ_ZFORMAT_DATA);
    sec = zeros(m,1);
    eq_datenum = zeros(m,1);
    eq_datenum = datenum(floor(EQ_ZFORMAT_DATA(:,3)),EQ_ZFORMAT_DATA(:,4),...
    EQ_ZFORMAT_DATA(:,5),EQ_ZFORMAT_DATA(:,8),...
    EQ_ZFORMAT_DATA(:,9),sec);
    MIN_EQ_TIME = datevec(min(eq_datenum)); % [yr mo dy hr min sec]
    MAX_EQ_TIME = datevec(max(eq_datenum)); % [yr mo dy hr min sec]
% open 'earthquake_screening window
    h = earthquake_screening;
    waitfor(h);
    if isempty(EQ_ZFORMAT_DATA)
        h = warndlg('Data are out of area.','!! Warning !!');
        waitfor(h);
        set(findobj('Tag','menu_earthquakes'), 'Checked', 'off');
        return
    end
    hm = wait_calc_window;
% hm = msgbox('Now plotting earthquakes. Please wait...');
    lon = EQ_ZFORMAT_DATA(:,1);
    lat = EQ_ZFORMAT_DATA(:,2);
    xx = xs + (lon - MIN_LON) * xinc;
    yy = ys + (lat - MIN_LAT) * yinc;
    
% Now single from double precision to save memory (only a little influenced
% by nodal plane stress changes (ignorable)
    EQ_DATA = single([EQ_ZFORMAT_DATA xx yy]); 
    
%------ EQ_DATA format (17 columns) -------------------------------
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
% 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
% 16) x position, 17) y position
%------------------------------------------------------------------
    figure(H_MAIN);
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1                % lon.lat.coordinates
        h = scatter(EQ_DATA(:,1),EQ_DATA(:,2),5*PREF(5,4));
        set(h,'MarkerEdgeColor',PREF(5,1:3));                   % white edge color for earthquakes
    else
        if isempty(EQ_DATA(1,10)) || EQ_DATA(1,11)==0 % cartesian coordinates
        h = scatter(EQ_DATA(:,16),EQ_DATA(:,17),5*PREF(5,4));
        set(h,'MarkerEdgeColor',PREF(5,1:3));                   % white edge color for earthquakes
        else
        hold on;
        h = bb2([EQ_DATA(:,10) EQ_DATA(:,11) EQ_DATA(:,12)],...
            EQ_DATA(:,16),EQ_DATA(:,17),EQ_DATA(:,6)*PREF(5,4)/3.0,0,0,'b');

        end
    end
    set(h,'Tag','EqObj');
    close(hm);
    set(findobj('Tag','menu_focal_mech'),'Enable','On');

% --- if EQ_DATA already exist ---------------
elseif isempty(EQ_DATA)~=1
    
%     if EQ_FLAG == 0
%         EQ_ZFORMAT_DATA = [];
%         set(findobj('Tag','menu_earthquake'), 'Checked', 'off');
%         return
%     end
    
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        hold on;
        h = scatter(EQ_DATA(:,1),EQ_DATA(:,2),5*PREF(5,4));
        set(h,'MarkerEdgeColor',PREF(5,1:3)); % white edge color for earthquakes 
    else
        if isempty(EQ_DATA(1,10)) || EQ_DATA(1,11)==0
        hold on;
        h = scatter(EQ_DATA(:,16),EQ_DATA(:,17),5*PREF(5,4));
        set(h,'MarkerEdgeColor',PREF(5,1:3)); % white edge color for earthquakes
        else % if ~isempty(EQ_DATA(1,10))
        hold on;
        h = bb2([EQ_DATA(:,10) EQ_DATA(:,11) EQ_DATA(:,12)],...
            EQ_DATA(:,16),EQ_DATA(:,17),EQ_DATA(:,6)*PREF(5,4)/3.0,0,0,'b');
        end
    end
%    set(h,'MarkerEdgeColor',PREF(5,1:3)); % white edge color for earthquakes 
    set(h,'Tag','EqObj');
end
disp(' ');
disp('   * To save the earthquake data only as binary, use the following command');
disp('   * in the Command Window.');
disp('   * save filename EQ_DATA (e.g., save myearthquake.mat EQ_DATA)');
disp('   * To read the .mat formatted earthquake catalog data, use ''File -> Open...'' menu later.');
disp(' ');

