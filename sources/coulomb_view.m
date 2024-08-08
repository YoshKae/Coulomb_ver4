function coulomb_view(N)
%   This function makes the coulomb out image on the main window.
%
%   INPUT: N (bar: color code saturation +-)
%

global H_MAIN
global XGRID YGRID FRIC CALC_DEPTH DEPTH_RANGE_TYPE CALC_DEPTH_RANGE
global CC
global ICOORD
global SHADE_TYPE STRESS_TYPE STRIKE DIP RAKE
global PREF
global FUNC_SWITCH STRAIN_SWITCH
global ANATOLIA
global VD_CHECKED
global C_SAT
global LON_PER_X LAT_PER_Y XY_RATIO
global LON_GRID LAT_GRID
global INPUT_FILE CURRENT_VERSION
global CONT_INTERVAL

    figure(H_MAIN)
	set(H_MAIN,'Menubar','figure','Toolbar','figure');
hold off;
% in case
if isnan(N) == 1
    h = errordlg('A calculation point hits a singular point. Shift the grid slightly.',...
        '!!Warning!!');
    return;
end
if FUNC_SWITCH == 6     % strain function
    N = power(10,N);
else
    N = abs(N);
end
C_SAT = N;

if ICOORD == 1
    XY_RATIO = 1;
end

set(H_MAIN,'Colormap',ANATOLIA);
%
if SHADE_TYPE == 2
    n_interp = 10.0;    % how much fine grid we need
    nxg = length(XGRID); xgmin = min(XGRID); xgmax = max(XGRID);
    nyg = length(YGRID); ygmin = min(YGRID); ygmax = max(YGRID);
    xnew_inc = (xgmax - xgmin) / (double(nxg) * n_interp);
    ynew_inc = (ygmax - ygmin) / (double(nyg) * n_interp);
    new_xgrid = [xgmin:xnew_inc:xgmax];
    new_ygrid = rot90([ygmin:ynew_inc:ygmax]);
        new_xgrid_mtr = zeros(length(new_ygrid),length(new_xgrid));    % initialization
        new_ygrid_mtr = zeros(length(new_ygrid),length(new_xgrid));    % initialization
        cc_new = zeros(length(new_ygrid),length(new_xgrid));            % initialization
    new_xgrid_mtr = repmat(new_xgrid,length(new_ygrid),1);
    new_ygrid_mtr = repmat(new_ygrid,1,length(new_xgrid));
    old_xgrid_mtr = repmat(XGRID,length(YGRID),1);
    old_ygrid_mtr = repmat(flipud(rot90(YGRID)),1,length(XGRID));
    cc_new = zeros(length(new_ygrid),length(new_xgrid));    % initialization
    % use interp2 function (interp2(x,y,z,xi,yi) using default 'linear'
    cc_new = interp2(old_xgrid_mtr,old_ygrid_mtr,fliplr(CC),new_xgrid_mtr,new_ygrid_mtr);
	cc_new = fliplr(cc_new);
    % keep CC data
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
%         tempx = new_xgrid;
%         tempy = new_xgrid;
        tempx = XGRID;
        tempy = YGRID;
        new_xgrid(1) = LON_GRID(1);  new_xgrid(end) = LON_GRID(end);
        new_ygrid(1) = LAT_GRID(1);  new_ygrid(end) = LAT_GRID(end);
        cc_new = flipud(cc_new);
    end
else
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        tempx = XGRID;
        tempy = YGRID;
        XGRID = LON_GRID;
        YGRID = LAT_GRID;
    end
end

if SHADE_TYPE == 2
    switch PREF(7,1)
    case 1
    ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(jet);
    case 2
    ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
    case 3
    ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(gray);
    otherwise
    ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
            'YData',[new_ygrid(end) new_ygrid(1)]);colormap(jet);
    end
    set(gca,'YDir','normal');
else
    switch PREF(7,1)
    case 1
        ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(end) YGRID(1)]);colormap(jet);
    case 2
        ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(end) YGRID(1)]);colormap(ANATOLIA);
    case 3
        ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(end) YGRID(1)]);colormap(gray);
    otherwise
        ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
            'YData',[YGRID(end) YGRID(1)]);colormap(jet);
    end
    set(gca,'YDir','normal');
end

% color saturation (-1 bar to 1 bar)
%set (ac, 'title','Coulomb output','xlabel','X (km)','ylabel','Y (km)');
hold on;
shading(gca,'interp');

caxis([-N N]);
axis image;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(gca,'DataAspectRatio',[XY_RATIO 1 1]);
end
shading interp;
%    h = get(gca,'Parent');
hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        hx = xlabel('Longitude (degree)','FontSize',14);
        hy = ylabel('Latitude  (degree)','FontSize',14);
    else
        hx = xlabel('X (km)','FontSize',14);
        hy = ylabel('Y (km)','FontSize',14);
    end
    
    switch FUNC_SWITCH
    case 4
        ht = title('Vertical displacement (m)','FontSize',18);            
    case 6                            % strain
        switch STRAIN_SWITCH
            case 1          % SXX
            	ht = title('Strain SXX component','FontSize',18);  
            case 2          % SYY
            	ht = title('Strain SYY component','FontSize',18);  
            case 3          % SZZ
            	ht = title('Strain SZZ component','FontSize',18);  
            case 4          % SXY
            	ht = title('Strain SYZ component','FontSize',18);  
            case 5          % SXZ
            	ht = title('Strain SXZ component','FontSize',18);  
            case 6          % SYZ
            	ht = title('Strain SXY component','FontSize',18);  
            case 7          % Dilatation
            	ht = title('Dilatation','FontSize',18);  
            otherwise
            	ht = title('Strain','FontSize',18);  
        end          
    case 7                          % shear stress change
        ht = title('Shear stress change (bar,right-lat. positive)','FontSize',14);
    case 8                          % normal stress change
        ht = title('Normal stress change (bar,unclamping positive)','FontSize',14);
    case 9                          % Coulomb stress change
        ht = title('Coulomb stress change (bar)','FontSize',18);
    otherwise
    end
% colorbar('location','SouthOutside');
colorbar('location','EastOutside');
hold on;
% fault_overlay;
% hold off;
%    set(H_MAIN,'Visible','on');

%-----------    contour mapview overlay for stress function  ---------------------------
if FUNC_SWITCH == 7 | FUNC_SWITCH == 8 | FUNC_SWITCH == 9
h = get(findobj('Tag','checkbox_coulomb_contour'),'Value');
if h == 1
hold on;
[m n] = size(CC);
cmax = max(reshape(max(CC),length(XGRID),1));
cmin = min(reshape(min(CC),length(XGRID),1));
a = cmax - cmin;
if isempty(CONT_INTERVAL)
    if a > 10.0
        CONT_INTERVAL = 1;
    elseif a > 5.0
        CONT_INTERVAL = 0.5;
    else
        CONT_INTERVAL = 0.1;
    end
    set(findobj('Tag','edit_stress_cont_interval'),'String',num2str(CONT_INTERVAL,'%3.1f'));
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	[C,h] = contour(LON_GRID,LAT_GRID,flipud(CC));
else
    [C,h] = contour(XGRID,YGRID,flipud(CC));
end
set(h,'LineColor','k','ShowText','on','LevelStep',CONT_INTERVAL);
% disp(['  Contour interval is now ' num2str(CONT_INTERVAL,'%6.3f')]);
% disp('  To change the contour interval, use variable CONT_INTERVAL.');
% disp('  Type here like CONT_INTERVAL = 0.2; Do not make it so small. It takes lots of time.');
i = findobj('Type','patch');
set(i,'LineWidth',1);
hold off;
end
end

%-----------    contour mapview overlay for strain function  ---------------------------
if FUNC_SWITCH == 6
h = get(findobj('Tag','contour_checkbox'),'Value');
if h == 1
hold on;
[m n] = size(CC);
dd = zeros(m,n);
dd = (CC./abs(CC)).*log10(abs(CC));
% cmax = max(reshape(max(abs(CC)),NXINC,1))
cmax = round(max(reshape(max(dd),length(XGRID),1)));
cmin = round(min(reshape(min(dd),length(XGRID),1)));
% nn = [cmin:1:cmax];
if isempty(CONT_INTERVAL)
CONT_INTERVAL = cmax - cmin + 1;
end
% nn = [0 0]
% [C,h] = contour(XGRID,YGRID,flipud(CC),int8(2*log10(abs(N))));
%if SHADE_TYPE == 1
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	[C,h] = contour(LON_GRID,LAT_GRID,flipud(dd));
else
    [C,h] = contour(XGRID,YGRID,flipud(dd));
end
% else
% % [C,h] = contour(new_xgrid,new_ygrid,flipud(cc_new));
% [C,h] = contour(XGRID,YGRID,flipud(dd));
% end
set(h,'LineColor','k','ShowText','on','LevelStep',CONT_INTERVAL);
% disp(['  Contour interval is now ' num2str(CONT_INTERVAL,'%6.3f')]);
% disp('  To change the contour interval, use variable CONT_INTERVAL.');
% disp('  Type here like CONT_INTERVAL = 0.2; Do not make it so small. It takes lots of time.');

% clabel(C,h);
i = findobj('Type','patch');
set(i,'LineWidth',1);
% hold on;
% fault_overlay;
hold off;
end
end

%-----------    contour mapview overlay for vertical displ. function  ---------------------------
if FUNC_SWITCH == 4
% h = get(findobj('Tag','vd_contour_checkbox'),'Value');
% if h == 1
if VD_CHECKED == 1
hold on;

    [m n] = size(CC);
    cmax = max(reshape(max(CC),length(XGRID),1));
    cmin = min(reshape(min(CC),length(XGRID),1));
    a = cmax - cmin;
    if isempty(CONT_INTERVAL)
    if a > 10.0
        CONT_INTERVAL = 1;
    elseif a > 5.0
        CONT_INTERVAL = 0.5;
    elseif a > 1.0
        CONT_INTERVAL = 0.1;
    else
        CONT_INTERVAL = 0.01;
    end
    end
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        [C,h] = contour(LON_GRID,LAT_GRID,flipud(CC));
    else
        [C,h] = contour(XGRID,YGRID,flipud(CC));
    end    
    
set(h,'LineColor','k','ShowText','on','LevelStep',CONT_INTERVAL);
% disp(['  Contour interval is now ' num2str(CONT_INTERVAL,'%6.3f')]);
% disp('  To change the contour interval, use variable CONT_INTERVAL.');
% disp('  Type here like CONT_INTERVAL = 0.2; Do not make it so small. It takes lots of time.');
i = findobj('Type','patch');
set(i,'LineWidth',1);
hold off;
end
end
%-----------    returning the numbers to the original ones  ---------------------------
if ICOORD == 2 && isempty(LON_GRID) ~= 1
        XGRID = tempx;
        YGRID = tempy;
end

%----------- data & file name stamp --------------
hold on;

if ICOORD == 2 && isempty(LON_GRID) ~= 1
    r = (LAT_GRID(end)-LAT_GRID(1))/(LON_GRID(end)-LON_GRID(1));
    if r > 1
    r = 1;
    end
    x = LON_GRID(end) + (LON_GRID(end)-LON_GRID(1))/(10.0/r);
    y = LAT_GRID(1)-((LAT_GRID(end)-LAT_GRID(1))/10.0)/r;
    lsp = ((LAT_GRID(end)-LAT_GRID(1))+(LON_GRID(end)-LON_GRID(1)))/75.0;
else
    r = (YGRID(end)-YGRID(1))/(XGRID(end)-XGRID(1));
    if r > 1
    r = 1;
    end
    x = XGRID(end) + (XGRID(end)-XGRID(1))/(10.0/r);
    y = YGRID(1)-((YGRID(end)-YGRID(1))/10.0)/r;
    lsp = ((YGRID(end)-YGRID(1))+(XGRID(end)-XGRID(1)))/75.0;
end
% date_and_file_stamp(H_MAIN,INPUT_FILE,x,y,lsp,FUNC_SWITCH,CALC_DEPTH,STRESS_TYPE,...
%     FRIC,DEPTH_RANGE_TYPE,CALC_DEPTH_RANGE,STRIKE,DIP,RAKE);
if isempty(CALC_DEPTH_RANGE)
    CALC_DEPTH_RANGE = [0:5:10];
end
try
dm1 = STRIKE(1); dm2 = DIP(1); dm3 = RAKE(1);
catch
dm1 = 90; dm2 = 90; dm3 = 0;
end
record_stamp(H_MAIN,x,y,'SoftwareVersion',CURRENT_VERSION,...
        'FunctionType',FUNC_SWITCH,'Depth',CALC_DEPTH,...
        'DepthType',DEPTH_RANGE_TYPE,'DepthMin',CALC_DEPTH_RANGE(1),...
        'DepthMax',CALC_DEPTH_RANGE(end),...
        'StressType',STRESS_TYPE,'Friction',FRIC,...
        'FileName',INPUT_FILE,'LineSpace',lsp,'Strike',dm1,'Dip',dm2,'Rake',dm3,...
        'FontSize',9);
CALC_DEPTH_RANGE = [];
