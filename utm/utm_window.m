function varargout = utm_window(varargin)
% UTM_WINDOW M-file for utm_window.fig
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @utm_window_OpeningFcn, ...
                   'gui_OutputFcn',  @utm_window_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before utm_window is made visible.
function utm_window_OpeningFcn(hObject, eventdata, handles, varargin)
global ZERO_LON ZERO_LAT MIN_LON MAX_LON MIN_LAT MAX_LAT
global XS YS XF YF
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);
% Choose default command line output for utm_window
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% Enable or disable setup
set(findobj('Tag','pushbutton_add'),'Enable','off');
set(findobj('Tag','edit_eq_lon'),'Enable','off');
set(findobj('Tag','edit_eq_lat'),'Enable','off');
set(findobj('Tag','edit_eq_depth'),'Enable','off');
set(findobj('Tag','edit_eq_length'),'Enable','off');
set(findobj('Tag','edit_eq_width'),'Enable','off');
set(findobj('Tag','edit_eq_mo'),'Enable','off');
set(findobj('Tag','edit_eq_strike'),'Enable','off');
set(findobj('Tag','edit_eq_dip'),'Enable','off');
set(findobj('Tag','edit_eq_rake'),'Enable','off');
set(findobj('Tag','edit_id_number'),'Enable','off');
set(findobj('Tag','edit_fx_start'),'Enable','off');
set(findobj('Tag','edit_fx_finish'),'Enable','off');
set(findobj('Tag','edit_fy_start'),'Enable','off');
set(findobj('Tag','edit_fy_finish'),'Enable','off');
set(findobj('Tag','edit_right_lat'),'Enable','off');
set(findobj('Tag','edit_rev_lat'),'Enable','off');
set(findobj('Tag','edit_f_top'),'Enable','off');
set(findobj('Tag','edit_f_bottom'),'Enable','off');
set(findobj('Tag','pushbutton_empirical'),'Enable','off');
set(findobj('Tag','pushbutton_f_add'),'Enable','off');
set(findobj('Tag','pushbutton_f_calc'),'Enable','off');
set(findobj('Tag','edit_all_input_params'),'Enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = utm_window_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     CENTER (LONGITUDE) (textfield)
%-------------------------------------------------------------------------
function edit_center_lon_Callback(hObject, eventdata, handles)
global ZERO_LON
ZERO_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ZERO_LON,'%8.3f'));
%----------------------
function edit_center_lon_CreateFcn(hObject, eventdata, handles) 
global ZERO_LON
if isempty(ZERO_LON)
    ZERO_LON = 130.2;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_center_lon');
set(h,'String',num2str(ZERO_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     CENTER (LATITUDE) (textfield)
%-------------------------------------------------------------------------
function edit_center_lat_Callback(hObject, eventdata, handles) 
global ZERO_LAT
ZERO_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ZERO_LAT,'%8.3f'));
%----------------------
function edit_center_lat_CreateFcn(hObject, eventdata, handles)
global ZERO_LAT
if isempty(ZERO_LAT)
    ZERO_LAT = 33.8;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_center_lat');
set(h,'String',num2str(ZERO_LAT,'%8.3f'));

%-------------------------------------------------------------------------
%     MINIMUM LONGITUDE (textfield)
%-------------------------------------------------------------------------
function edit_min_lon_Callback(hObject, eventdata, handles)
global MIN_LON
MIN_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MIN_LON,'%8.3f'));
%----------------------
function edit_min_lon_CreateFcn(hObject, eventdata, handles)
global MIN_LON
if isempty(MIN_LON) | MIN_LON == 0
    MIN_LON = 129.5;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_min_lon');
set(h,'String',num2str(MIN_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     MAXIMU LONGITUDE (textfield)
%-------------------------------------------------------------------------
function edit_max_lon_Callback(hObject, eventdata, handles)
global MAX_LON
MAX_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MAX_LON,'%8.3f'));
%----------------------
function edit_max_lon_CreateFcn(hObject, eventdata, handles)
global MAX_LON
if isempty(MAX_LON)
    MAX_LON = 131.0;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_max_lon');
set(h,'String',num2str(MAX_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     LONGITUDE INCREMENT (textfield)
%-------------------------------------------------------------------------
function edit_inc_lon_Callback(hObject, eventdata, handles)
global INC_LON
INC_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INC_LON,'%8.3f'));
%----------------------
function edit_inc_lon_CreateFcn(hObject, eventdata, handles)
global INC_LON
if isempty(INC_LON)
    INC_LON = 0.05;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INC_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     MINIMUM LATITUDE (textfield)
%-------------------------------------------------------------------------
function edit_min_lat_Callback(hObject, eventdata, handles)
global MIN_LAT
MIN_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MIN_LAT,'%8.3f'));
%----------------------
function edit_min_lat_CreateFcn(hObject, eventdata, handles)
global MIN_LAT
if isempty(MIN_LAT) | MIN_LAT == 0
    MIN_LAT = 33.0;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_min_lat');
set(h,'String',num2str(MIN_LAT,'%8.3f'));

%-------------------------------------------------------------------------
%     MAXIMUM LATITUDE (textfield)
%-------------------------------------------------------------------------
function edit_max_lat_Callback(hObject, eventdata, handles)
global MAX_LAT
MAX_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MAX_LAT,'%8.3f'));
%----------------------
function edit_max_lat_CreateFcn(hObject, eventdata, handles)
global MAX_LAT
if isempty(MAX_LAT)
    MAX_LAT = 34.5;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_max_lat');
set(h,'String',num2str(MAX_LAT,'%8.3f'));

%-------------------------------------------------------------------------
%     LATITUDE INCREMENT (textfield)
%-------------------------------------------------------------------------
function edit_inc_lat_Callback(hObject, eventdata, handles)
global INC_LAT
INC_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INC_LAT,'%8.3f'));

function edit_inc_lat_CreateFcn(hObject, eventdata, handles)
global INC_LAT
if isempty(INC_LAT)
    INC_LAT = 0.05;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INC_LAT,'%8.3f'));


%-------------------------------------------------------------------------
%     CALC. BUTTON (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_calc_Callback(hObject, eventdata, handles)
global ZERO_LON ZERO_LAT MIN_LON MAX_LON MIN_LAT MAX_LAT
global INC_LON INC_LAT
global XS YS XF YF
global PC_LON PC_LAT
global GRID MAPTLFLAG
global UTM_FLAG  % UTM_FLAG is used to identify if this is just a tool to know the coordinate (0) or
                 % to make an input file from this (1)

% warning dialog
if MIN_LAT >= MAX_LAT
    errordlg('max lat should be larger than min lat','Alignment Error!');
end
if MIN_LON >= MAX_LON
    errordlg('max lon should be larger than min lon','Alignment Error!');
end
if ZERO_LON > MAX_LON || ZERO_LON < MIN_LON
    errordlg('ref lon should be in the study area','Alignment Error!');
end
if ZERO_LAT > MAX_LAT || ZERO_LAT < MIN_LAT
    errordlg('ref lat should be in the study area','Alignment Error!');
end
ndlon = int16((MAX_LON - MIN_LON) / INC_LON);
ndlat = int16((MAX_LAT - MIN_LAT) / INC_LAT);
modlon = mod((MAX_LON - MIN_LON),INC_LON);
modlat = mod((MAX_LAT - MIN_LAT),INC_LAT);
if ndlon <= 5 | ndlat <= 5
     warndlg('grid interval is so wide','Warning!');   
end
% if modlon ~= 0.0 | modlat ~= 0.0
%      warndlg('grid interval is not aliquot. The position might be a little offset.','Warning!');   
% end

pcent_lon = (MAX_LON + MIN_LON)/2.0;
pcent_lat = (MAX_LAT + MIN_LAT)/2.0;
% total distance for x and Y
if MAPTLFLAG == 1
    xdeg  = distance(pcent_lat,MIN_LON,pcent_lat,MAX_LON);
    ydeg  = distance(MIN_LAT,pcent_lon,MAX_LAT,pcent_lon);
    xdist = deg2km(xdeg);
    ydist = deg2km(ydeg);
    xmin  = deg2km(distance(pcent_lat,MIN_LON,pcent_lat,ZERO_LON));
    ymin  = deg2km(distance(MIN_LAT,pcent_lon,ZERO_LAT,pcent_lon));
    xmax  = deg2km(distance(pcent_lat,MAX_LON,pcent_lat,ZERO_LON));
    ymax  = deg2km(distance(MAX_LAT,pcent_lon,ZERO_LAT,pcent_lon));
else
	[xdist,flag1] = distance2(pcent_lat,MIN_LON,pcent_lat,MAX_LON);
	[ydist,flag2] = distance2(MIN_LAT,pcent_lon,MAX_LAT,pcent_lon);
    [xmin, flag3] = distance2(pcent_lat,MIN_LON,pcent_lat,ZERO_LON);
    [ymin, flag4] = distance2(MIN_LAT,pcent_lon,ZERO_LAT,pcent_lon);
    [xmax, flag5] = distance2(pcent_lat,MAX_LON,pcent_lat,ZERO_LON);
    [ymax, flag6] = distance2(MAX_LAT,pcent_lon,ZERO_LAT,pcent_lon);
    dummy = flag1+flag2+flag3+flag4+flag5+flag6;
    if dummy >= 1
        msgbox('The points are over two UTM zones. It will be switched to simple great circle calc.',...
            'Notice','warn');
    xdist = greatCircleDistance(deg2rad(pcent_lat),deg2rad(MIN_LON),...
                        deg2rad(pcent_lat),deg2rad(MAX_LON));
	ydist = greatCircleDistance(deg2rad(MIN_LAT),deg2rad(pcent_lon),...
                        deg2rad(MAX_LAT),deg2rad(pcent_lon));
    xmin  = greatCircleDistance(deg2rad(pcent_lat),deg2rad(MIN_LON),...
                        deg2rad(pcent_lat),deg2rad(ZERO_LON));
    ymin  = greatCircleDistance(deg2rad(MIN_LAT),deg2rad(pcent_lon),...
                        deg2rad(ZERO_LAT),deg2rad(pcent_lon));
    xmax  = greatCircleDistance(deg2rad(pcent_lat),deg2rad(MAX_LON),...
                        deg2rad(pcent_lat),deg2rad(ZERO_LON));
    ymax  = greatCircleDistance(deg2rad(MAX_LAT),deg2rad(pcent_lon),...
                        deg2rad(ZERO_LAT),deg2rad(pcent_lon));
%     greatCircleDistance(phi_s, lambda_s, phi_f, lambda_f, r);
    end
end
if ZERO_LON > MIN_LON
    xmin = -xmin;
end
if ZERO_LAT > MIN_LAT
    ymin = -ymin;
end
if ZERO_LON > MAX_LON
    xmax = -xmax;
end
if ZERO_LAT > MAX_LAT
    ymax = -ymax;
end
set(findobj('Tag','edit_x_start'),'String',num2str(xmin,'%8.2f'));
set(findobj('Tag','edit_y_start'),'String',num2str(ymin,'%8.2f'));
set(findobj('Tag','edit_x_finish'),'String',num2str(xmax,'%8.2f'));
set(findobj('Tag','edit_y_finish'),'String',num2str(ymax,'%8.2f'));
% need? check them later...
XS = xmin; GRID(1,1) = xmin;
XF = xmax; GRID(3,1) = xmax;
YS = ymin; GRID(2,1) = ymin;
YF = ymax; GRID(4,1) = ymax;
%
GRID(5,1) = (xmax - xmin) / double(ndlon);
GRID(6,1) = (ymax - ymin) / double(ndlat);
set(findobj('Tag','edit_x_inc'),'String',num2str(GRID(5,1),'%8.2f'));
set(findobj('Tag','edit_y_inc'),'String',num2str(GRID(6,1),'%8.2f'));
PC_LON = pcent_lon;
PC_LAT = pcent_lat;

set(findobj('Tag','pushbutton_add'),'Enable','on');
set(findobj('Tag','edit_eq_lon'),'Enable','on');
set(findobj('Tag','edit_eq_lat'),'Enable','on');
set(findobj('Tag','edit_eq_depth'),'Enable','on');
set(findobj('Tag','edit_eq_length'),'Enable','on');
set(findobj('Tag','edit_eq_width'),'Enable','on');
set(findobj('Tag','edit_eq_mo'),'Enable','on');
set(findobj('Tag','edit_eq_strike'),'Enable','on');
set(findobj('Tag','edit_eq_dip'),'Enable','on');
set(findobj('Tag','edit_eq_rake'),'Enable','on');
set(findobj('Tag','edit_id_number'),'Enable','on');
set(findobj('Tag','edit_fx_start'),'Enable','on');
set(findobj('Tag','edit_fx_finish'),'Enable','on');
set(findobj('Tag','edit_fy_start'),'Enable','on');
set(findobj('Tag','edit_fy_finish'),'Enable','on');
set(findobj('Tag','edit_right_lat'),'Enable','on');
set(findobj('Tag','edit_rev_lat'),'Enable','on');
set(findobj('Tag','edit_f_top'),'Enable','on');
set(findobj('Tag','edit_f_bottom'),'Enable','on');
set(findobj('Tag','pushbutton_empirical'),'Enable','on');
set(findobj('Tag','pushbutton_f_add'),'Enable','off');
if UTM_FLAG == 0 % just a tool to know the coordinates
set(findobj('Tag','pushbutton_f_calc'),'Enable','on');
else
set(findobj('Tag','pushbutton_f_calc'),'Enable','off');
end
set(findobj('Tag','edit_all_input_params'),'Enable','off');

%-------------------------------------------------------------------------
%     GRID X START (textfield)
%-------------------------------------------------------------------------
function edit_x_start_Callback(hObject, eventdata, handles)
global GRID
GRID(1,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(1,1),'%8.2f'));
%----------------------
function edit_x_start_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(1,1) = str2double(get(hObject,'String'));
% set(hObject,'String',num2str(GRID(1,1),'%8.2f'));

%-------------------------------------------------------------------------
%     GRID Y START (textfield)
%-------------------------------------------------------------------------
function edit_y_start_Callback(hObject, eventdata, handles)
global GRID
GRID(2,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(2,1),'%8.2f'));
%----------------------
function edit_y_start_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(2,1) = str2double(get(hObject,'String'));
% set(hObject,'String',num2str(GRID(2,1),'%8.2f'));

%-------------------------------------------------------------------------
%     GRID X FINISH (textfield)
%-------------------------------------------------------------------------
function edit_x_finish_Callback(hObject, eventdata, handles)
global GRID
GRID(3,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(3,1),'%8.2f'));
%----------------------
function edit_x_finish_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(3,1) = str2double(get(hObject,'String'));
% set(hObject,'String',num2str(GRID(3,1),'%8.2f'));

%-------------------------------------------------------------------------
%     GRID Y FINISH (textfield)
%-------------------------------------------------------------------------
function edit_y_finish_Callback(hObject, eventdata, handles)
global GRID
GRID(4,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(4,1),'%8.2f'));
%----------------------
function edit_y_finish_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(4,1) = str2double(get(hObject,'String'));
% set(hObject,'String',num2str(GRID(4,1),'%8.2f'));

%-------------------------------------------------------------------------
%     GRID X INCREMENT (textfield)
%-------------------------------------------------------------------------
function edit_x_inc_Callback(hObject, eventdata, handles)
global GRID
GRID(5,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(5,1),'%8.2f'));
%----------------------
function edit_x_inc_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(5,1) = str2double(get(hObject,'String'));
% set(hObject,'String',num2str(GRID(5,1),'%8.2f'));

%-------------------------------------------------------------------------
%     GRID Y INCREMENT (textfield)
%-------------------------------------------------------------------------
function edit_y_inc_Callback(hObject, eventdata, handles)
global GRID
GRID(6,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(6,1),'%8.2f'));

%----------------------
function edit_y_inc_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(6,1) = str2double(get(hObject,'String'));
% set(hObject,'String',num2str(GRID(6,1),'%8.2f'));

%-------------------------------------------------------------------------
%     ADD (pushbutton) to add all cal info to main_menu_window
%-------------------------------------------------------------------------
function pushbutton_add_Callback(hObject, eventdata, handles)
global H_MAIN GRID XGRID YGRID FUNC_SWITCH CALC_DEPTH
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global LON_GRID LAT_GRID
% Calc grid position and hold them for all the other functions
    xstart = GRID(1,1);
    ystart = GRID(2,1);
    xfinish = GRID(3,1);
    yfinish = GRID(4,1);
    xinc = GRID(5,1);
    yinc = GRID(6,1);
    nxinc = int16((xfinish-xstart)/xinc + 1);
    nyinc = int16((yfinish-ystart)/yinc + 1);
    xpp = [1:1:nxinc];
    ypp = [1:1:nyinc];
    XGRID = double(xstart) + (double(1:1:(nxinc-1))-1.0) * double(xinc);
    YGRID = double(ystart) + (double(1:1:(nyinc-1))-1.0) * double(yinc);
FUNC_SWITCH = 1;
CALC_DEPTH  = 0; % temporal value for "record_stamp function"
                  % in grid_drawing function
%===== if map info exist
if isempty(MIN_LON) ~= 1 && isempty(MAX_LON) ~= 1
    if isempty(MIN_LAT) ~= 1 && isempty(MAX_LAT) ~= 1
        if isempty(ZERO_LON) ~= 1 && isempty(ZERO_LAT) ~= 1
xinc = double(MAX_LON - MIN_LON) / double(nxinc-1);
yinc = double(MAX_LAT - MIN_LAT) / double(nyinc-1);
LON_GRID = double(MIN_LON) + (double(1:1:nxinc)-1.0) * double(xinc);
LAT_GRID = double(MIN_LAT) + (double(1:1:nyinc)-1.0) * double(yinc);
        end
    end
end
%=====
grid_drawing;
FUNC_SWITCH = 0;
% set(findobj('Tag','pushbutton_f_add'),'Enable','on');
set(findobj('Tag','pushbutton_f_calc'),'Enable','on');
% set(findobj('Tag','edit_all_input_params'),'Enable','on');
% 
% h = findobj('Tag','pushbutton_f_calc');
% set(h,'Enable','on');
set(findobj('Tag','menu_gridlines'),'Enable','On');
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');    

%-------------------------------------------------------------------------
%     EQ LOCATION position edge (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_edgepos_Callback(hObject, eventdata, handles)
% x = get(hObject,'Value');
set (handles.radiobutton_centerpos,'Value',0);

%-------------------------------------------------------------------------
%     EQ LOCATION position center (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_centerpos_Callback(hObject, eventdata, handles)
% x = get(hObject,'Value');
set (handles.radiobutton_edgepos,'Value',0);

%-------------------------------------------------------------------------
%     EQ LOCATION LONGITUDE (textfield)
%-------------------------------------------------------------------------
function edit_eq_lon_Callback(hObject, eventdata, handles)
global EQ_LON
EQ_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_LON,'%8.3f'));

%----------------------
function edit_eq_lon_CreateFcn(hObject, eventdata, handles)
global EQ_LON
if isempty(EQ_LON)
    EQ_LON = 130.178;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     EQ LOCATION LATITUDE (textfield)
%-------------------------------------------------------------------------
function edit_eq_lat_Callback(hObject, eventdata, handles)
global EQ_LAT
EQ_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_LAT,'%8.3f'));

%----------------------
function edit_eq_lat_CreateFcn(hObject, eventdata, handles)
global EQ_LAT
if isempty(EQ_LAT)
    EQ_LAT = 33.741;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_LAT,'%8.3f'));

%-------------------------------------------------------------------------
%     EQ LOCATION DEPTH (textfield)
%-------------------------------------------------------------------------
function edit_eq_depth_Callback(hObject, eventdata, handles)
global EQ_DEPTH
EQ_DEPTH = str2num(get(hObject,'String'));
if EQ_DEPTH < 0.0
    h = warndlg('The depth should be positive.');
    EQ_DEPTH = 0.0;
end
set(hObject,'String',num2str(EQ_DEPTH,'%6.2f'));

%----------------------
function edit_eq_depth_CreateFcn(hObject, eventdata, handles)
global EQ_DEPTH
if isempty(EQ_DEPTH)
    EQ_DEPTH = 7.5;   % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_DEPTH,'%6.2f'));

%-------------------------------------------------------------------------
%     FAULT LENGTH (textfield)
%-------------------------------------------------------------------------
function edit_eq_length_Callback(hObject, eventdata, handles)
global EQ_LENGTH
EQ_LENGTH = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_LENGTH,'%7.2f'));

%----------------------
function edit_eq_length_CreateFcn(hObject, eventdata, handles)
global EQ_LENGTH
if isempty(EQ_LENGTH)
    EQ_LENGTH = 20.0;    % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_LENGTH,'%7.2f'));

%-------------------------------------------------------------------------
%     FAULT WIDTH (textfield)
%-------------------------------------------------------------------------
function edit_eq_width_Callback(hObject, eventdata, handles)
global EQ_WIDTH
EQ_WIDTH = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_WIDTH,'%7.2f'));

%----------------------
function edit_eq_width_CreateFcn(hObject, eventdata, handles) 
global EQ_WIDTH
if isempty(EQ_WIDTH)
    EQ_WIDTH = 10.0;    % default number
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_WIDTH,'%7.2f'));

%-------------------------------------------------------------------------
%     Pushbutton "From empirical relations"
%-------------------------------------------------------------------------
function pushbutton_empirical_Callback(hObject, eventdata, handles)
global H_WC
H_WC = wells_coppersmith_window;
% hObject    handle to pushbutton_empirical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------
%     MOMENT MAGNITUDE (textfield)
%-------------------------------------------------------------------------
function edit_eq_mo_Callback(hObject, eventdata, handles)
global EQ_MW
EQ_MW = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_MW,'%3.1f'));

%----------------------
function edit_eq_mo_CreateFcn(hObject, eventdata, handles)
global EQ_MW
if isempty(EQ_MW)
    EQ_MW = 6.6;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_MW,'%3.1f'));

%-------------------------------------------------------------------------
%     STRIKE (textfield)
%-------------------------------------------------------------------------
function edit_eq_strike_Callback(hObject, eventdata, handles)
global EQ_STRIKE
x = str2num(get(hObject,'String'));
if x >= 0 && x <= 360
    EQ_STRIKE = str2num(get(hObject,'String'));
    if x == 360
        EQ_STRIKE = 0.0;
    end
else
    h = warndlg('Out of strike range. It should be between 0 and 360.');
    waitfor(h);
%    return;
end
set(hObject,'String',num2str(EQ_STRIKE,'%6.1f'));

%----------------------
function edit_eq_strike_CreateFcn(hObject, eventdata, handles)
global EQ_STRIKE
if isempty(EQ_STRIKE)
    EQ_STRIKE = 303.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_STRIKE,'%6.1f'));

%-------------------------------------------------------------------------
%     DIP (textfield)
%-------------------------------------------------------------------------
function edit_eq_dip_Callback(hObject, eventdata, handles)
global EQ_DIP
x = str2num(get(hObject,'String'));
if x >= 0 && x <= 90
    EQ_DIP = str2num(get(hObject,'String'));
else
    h = warndlg('Out of dip range. It should be between 0 and 90.');
    waitfor(h);
%    return;
end
set(hObject,'String',num2str(EQ_DIP,'%6.1f'));

%----------------------
function edit_eq_dip_CreateFcn(hObject, eventdata, handles)
global EQ_DIP
if isempty(EQ_DIP)
    EQ_DIP = 81.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_DIP,'%6.1f'));

%-------------------------------------------------------------------------
%     RAKE (textfield)
%-------------------------------------------------------------------------
function edit_eq_rake_Callback(hObject, eventdata, handles)
global EQ_RAKE
x = str2num(get(hObject,'String'));
if x >= -180.0 && x <= 180
    EQ_RAKE = str2num(get(hObject,'String'));
else
    h = warndlg('Out of rake range. It should be between -180 and 180');
    waitfor(h);
%    return;
end
set(hObject,'String',num2str(EQ_RAKE,'%6.1f'));

%----------------------
function edit_eq_rake_CreateFcn(hObject, eventdata, handles)
global EQ_RAKE
if isempty(EQ_RAKE)
    EQ_RAKE = 4.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_RAKE,'%6.1f'));

%-------------------------------------------------------------------------
%     FAULT X START (textfield)
%-------------------------------------------------------------------------
function edit_fx_start_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,1) = str2double(get(hObject,'String'));

%----------------------
function edit_fx_start_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     FAULT Y START (textfield)
%-------------------------------------------------------------------------
function edit_fy_start_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,2) = str2double(get(hObject,'String'));

%----------------------
function edit_fy_start_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     FAULT X FINISH (textfield)
%-------------------------------------------------------------------------
function edit_fx_finish_Callback(hObject, eventdata, handles) 
global ELEMENT INUM
ELEMENT(INUM,3) = str2double(get(hObject,'String'));

%----------------------
function edit_fx_finish_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     FAULT Y FINISH (textfield)
%-------------------------------------------------------------------------
function edit_fy_finish_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,4) = str2double(get(hObject,'String'));

%----------------------
function edit_fy_finish_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     FAULT TOP (textfield)
%-------------------------------------------------------------------------
function edit_f_top_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,8) = str2double(get(hObject,'String'));

%----------------------
function edit_f_top_CreateFcn(hObject, eventdata, handles) 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     FAULT BOTTOM (textfield)
%-------------------------------------------------------------------------
function edit_f_bottom_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,9) = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_f_bottom_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     Right lateral slip (textfield)
%-------------------------------------------------------------------------
function edit_right_lat_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,5) = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_right_lat_CreateFcn(hObject, eventdata, handles)
% h
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     Disp slip (textfield)
%-------------------------------------------------------------------------
function edit_rev_lat_Callback(hObject, eventdata, handles)
global ELEMENT INUM
ELEMENT(INUM,6) = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_rev_lat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     CALCULATION FOR FAULT (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_f_calc_Callback(hObject, eventdata, handles)
% 
global ZERO_LON ZERO_LAT MIN_LON MAX_LON MIN_LAT MAX_LAT
global XS YS XF YF
global EQ_LON EQ_LAT EQ_DEPTH
global PC_LON PC_LAT
global EQ_LENGTH EQ_WIDTH EQ_STRIKE EQ_DIP EQ_RAKE EQ_MW
global NUM ID ELEMENT INUM KODE FCOMMENT
global MAPTLFLAG
% persistent ntrial % to keep track the INUM to add another fault

% ntrial = ntrial + 1;
% insurance...
EQ_LENGTH = str2double(get(findobj('Tag','edit_eq_length'),'String'));
EQ_WIDTH  = str2double(get(findobj('Tag','edit_eq_width'),'String'));
EQ_MW     = str2double(get(findobj('Tag','edit_eq_mo'),'String'));

% counter
% INUM = INUM + 1;
% increase id number
set(findobj('Tag','edit_id_number'),'String',num2str(INUM,'%2i'));
% total number of faults
NUM = INUM;
% Kode (default is 100)
KODE(INUM,1) = 100;
ID(INUM,1) = 1;
FCOMMENT(INUM,:).ref = ['Fault ' num2str(INUM,'%3i')];

fref = 0;
fref = get(handles.radiobutton_edgepos,'Value');
% fref = 0; position reference center
% fref = 1; position reference edge

% test
% ID = 1;
% NUM = 1;
% Each fault element
%       ELEMENT(:,1) xstart (km)
%       ELEMENT(:,2) ystart (km)
%       ELEMENT(:,3) xfinish (km)
%       ELEMENT(:,4) yfinish (km)
%       ELEMENT(:,5) right-lat. slip (m)
%       ELEMENT(:,6) reverse slip (m)
%       ELEMENT(:,7) dip (degree)
%       ELEMENT(:,8) fault top depth (km)
%       ELEMENT(:,9) fault bottom depth (km)
% Fault position
%  !!! NEED readjustment for dipping fault !!!!!!!!!!!!!!!!!!
if MAPTLFLAG == 1
    xdist = deg2km(distance(PC_LAT,EQ_LON,PC_LAT,ZERO_LON));
else
    [xdist,flag] = distance2(PC_LAT,EQ_LON,PC_LAT,ZERO_LON);
    if flag == 1
        xdist  = greatCircleDistance(deg2rad(PC_LAT),deg2rad(EQ_LON),...
                                    deg2rad(PC_LAT),deg2rad(ZERO_LON)); 
    end
end
if EQ_LON < ZERO_LON
    xdist = -xdist;
end
if MAPTLFLAG == 1
    ydist = deg2km(distance(EQ_LAT,PC_LON,ZERO_LAT,PC_LON));
else
    [ydist,flag] = distance2(EQ_LAT,PC_LON,ZERO_LAT,PC_LON);
    if flag == 1
        ydist  = greatCircleDistance(deg2rad(EQ_LAT),deg2rad(PC_LON),...
                                    deg2rad(ZERO_LAT),deg2rad(PC_LON)); 
    end
end
if EQ_LAT < ZERO_LAT
    ydist = -ydist;
end

if fref == 1    % edge position
    xfn = xdist + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
    yfn = ydist + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
else            % center position
    xtemp = xdist;
    ytemp = ydist;
    xdist = xtemp - sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
    ydist = ytemp - cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
    xfn   = xtemp + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
    yfn   = ytemp + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
%   adjustment
    dd = (EQ_WIDTH / 2.) * cos(deg2rad(EQ_DIP));
    theta = atan(abs(yfn-ydist)/abs(xfn-xdist));
    zx = dd * sin(theta);   % unit distance along x-axis for dip-slip direction
    zy = dd * cos(theta);   % unit distance along y-axis for dip-slip direction
    if xfn >= xdist
        if yfn >= ydist
            zx = -zx;
            zy = zy;
        else
            zx = zx;
            zy = zy;
        end
    else
        if yfn >= ydist
            zx = -zx;
            zy = -zy;
        else
            zx = zx;
            zy = -zy;
        end
    end 
    xdist = xdist + zx;
    ydist = ydist + zy;
    xfn   = xfn + zx;
    yfn   = yfn + zy;
end

% xfn & yfn are one of the fault edges following Aki & Richards convension
% xfn = xdist + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
% yfn = ydist + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
set(findobj('Tag','edit_fx_start'),'String',num2str(xdist,'%8.2f'));
set(findobj('Tag','edit_fy_start'),'String',num2str(ydist,'%8.2f'));
set(findobj('Tag','edit_fx_finish'),'String',num2str(xfn,'%8.2f'));
set(findobj('Tag','edit_fy_finish'),'String',num2str(yfn,'%8.2f'));
ELEMENT(INUM,1) = xdist;
ELEMENT(INUM,2) = ydist;
ELEMENT(INUM,3) = xfn;
ELEMENT(INUM,4) = yfn;

% Slip from Mw
shr = 3.4e+11;
mo = power(10,(1.5 * EQ_MW + 9.1))*1.0e+7;
slip = mo/(shr * EQ_LENGTH * EQ_WIDTH * 1.0e+10);
rlslip = ((-1.0) * cos(deg2rad(EQ_RAKE)) * slip)/100;
rvslip = (sin(deg2rad(EQ_RAKE)) * slip)/100;
set(findobj('Tag','edit_right_lat'),'String',num2str(rlslip,'%8.2f'));
set(findobj('Tag','edit_rev_lat'),'String',num2str(rvslip,'%8.2f'));
ELEMENT(INUM,5) = rlslip;
ELEMENT(INUM,6) = rvslip;

% Fault depth control
hd = (EQ_WIDTH/2.0) * sin(deg2rad(EQ_DIP));
if fref == 1    % edge position
    tp = EQ_DEPTH;
    bt = EQ_DEPTH + 2.0 * hd;
else            % center position
    tp = EQ_DEPTH - hd;
    bt = EQ_DEPTH + hd;
    if tp < 0.0
        h = warndlg('Fault top depth above the surface (negative). Change the source depth or fault width.');
        waitfor(h);
%         return
    end
end
set(findobj('Tag','edit_f_top'),'String',num2str(tp,'%8.2f'));
set(findobj('Tag','edit_f_bottom'),'String',num2str(bt,'%8.2f'));
ELEMENT(INUM,7) = EQ_DIP;
ELEMENT(INUM,8) = tp;
ELEMENT(INUM,9) = bt;
set(findobj('Tag','pushbutton_f_add'),'Enable','on');
% INUM = 1;

%-------------------------------------------------------------------------
%     ADD FAULT (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_f_add_Callback(hObject, eventdata, handles)
global CALC_DEPTH POIS YOUNG KODE FRIC SIZE HEAD R_STRESS H_ELEMENT SECTION
global ID NUM ELEMENT INUM
global EQ_LAT EQ_LON
global ICOORD LON_GRID

% set default values
CALC_DEPTH = (ELEMENT(INUM,8)+ELEMENT(INUM,9)) / 2.0;
POIS = 0.25;
YOUNG = 800000;

% KODE = 100;
FRIC = 0.4;
SIZE = [2;1;10000];
% HEAD = cell(2,1);
x1 = 'header line 1';
x2 = 'header line 2';
% HEAD(1,1) = mat2cell(x1);
% HEAD(2,1) = mat2cell(x2);
% HEAD(1,1)='header line 1';
% HEAD(2,1)='header line 2';
HEAD{1} = x1;
HEAD{2} = x2;
R_STRESS = [19.00 -0.01 100.0 0.0;
            89.99 89.99  30.0 0.0;
           109.00 -0.01   0.0 0.0];
SECTION = [-16; -16; 18; 26; 1; 30; 1];
% default (end)
% H_ELEMENT = element_input_window;
fault_overlay;
% lonp = str2num(get(findobj('Tag','edit_eq_lon'),'String'));
% latp = str2num(get(findobj('Tag','edit_eq_lat'),'String'));
a = lonlat2xy([EQ_LON EQ_LAT]);
hold on;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    h = scatter(EQ_LON,EQ_LAT,'filled','bo');
else
    h = scatter(a(1),a(2),'filled','bo');
end
% set(h,'Color','b');
% menu enable -> function all_functions_enable_on
set(findobj('Tag','menu_grid'),'Enable','On');
set(findobj('Tag','menu_displacement'),'Enable','On');
set(findobj('Tag','menu_strain'),'Enable','On');
set(findobj('Tag','menu_stress'),'Enable','On');
set(findobj('Tag','menu_change_parameters'),'Enable','On');
set(findobj('Tag','edit_all_input_params'),'Enable','on');
set(findobj('Tag','menu_file_save'),'Enable','On');
set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
set(findobj('Tag','menu_map_info'),'Enable','On');

% INUM = INUM + 1;
set(findobj('Tag','edit_id_number'),'String',num2str(INUM,'%2i'));

%-------------------------------------------------------------------------
%     CANCEL (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_utm_cancel_Callback(hObject, eventdata, handles)
    delete(figure(gcf));
    
%-------------------------------------------------------------------------
%     OK (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_utm_ok_Callback(hObject, eventdata, handles)
    calc_element;
    delete(figure(gcf));
    
%-------------------------------------------------------------------------
%     ID number (static text)
%-------------------------------------------------------------------------
function edit_id_number_Callback(hObject, eventdata, handles)
global NUM INUM ID KODE FCOMMENT ELEMENT
x = int8(str2double(get(hObject,'String')));
if x > NUM + 1
    h = warndlg('Fault ID should be sequential.');
    waitfor(h);
    set(hObject,'String',num2str(INUM,'%3i'));
    return
elseif x == NUM + 1         % case to add another fault element
    INUM = x;
    KODE(INUM,1) = 100;
    ID(INUM,1) = 1;
    FCOMMENT(INUM,:).ref = ['Fault ' num2str(INUM,'%3i')];
    ELEMENT(INUM,1) = str2double(get(findobj('Tag','edit_fx_start'),'String'));
    ELEMENT(INUM,2) = str2double(get(findobj('Tag','edit_fy_start'),'String'));
    ELEMENT(INUM,3) = str2double(get(findobj('Tag','edit_fx_finish'),'String'));
    ELEMENT(INUM,4) = str2double(get(findobj('Tag','edit_fy_finish'),'String'));
    ELEMENT(INUM,5) = str2double(get(findobj('Tag','edit_right_lat'),'String'));
    ELEMENT(INUM,6) = str2double(get(findobj('Tag','edit_rev_lat'),'String'));
    ELEMENT(INUM,7) = str2double(get(findobj('Tag','edit_eq_dip'),'String'));
    ELEMENT(INUM,8) = str2double(get(findobj('Tag','edit_f_top'),'String'));
    ELEMENT(INUM,9) = str2double(get(findobj('Tag','edit_f_bottom'),'String'));
    NUM = INUM;
else                        % to show one of the existed fault elements
    INUM = x;
    set(findobj('Tag','edit_fx_start'),'String',num2str(ELEMENT(INUM,1),'%8.2f'));
    set(findobj('Tag','edit_fy_start'),'String',num2str(ELEMENT(INUM,2),'%8.2f'));
    set(findobj('Tag','edit_fx_finish'),'String',num2str(ELEMENT(INUM,3),'%8.2f'));
    set(findobj('Tag','edit_fy_finish'),'String',num2str(ELEMENT(INUM,4),'%8.2f'));
    set(findobj('Tag','edit_right_lat'),'String',num2str(ELEMENT(INUM,5),'%8.2f'));
    set(findobj('Tag','edit_rev_lat'),'String',num2str(ELEMENT(INUM,6),'%8.2f'));
    set(findobj('Tag','edit_eq_dip'),'String',num2str(ELEMENT(INUM,7),'%8.2f'));
    set(findobj('Tag','edit_f_top'),'String',num2str(ELEMENT(INUM,8),'%8.2f'));
    set(findobj('Tag','edit_f_bottom'),'String',num2str(ELEMENT(INUM,9),'%8.2f'));    
end


function edit_id_number_CreateFcn(hObject, eventdata, handles)
global INUM
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
INUM = 1; % for counting (initialization)
set(hObject,'String',num2str(1,'%2i'));

%-------------------------------------------------------------------------
%     Edit all input parameters (static text)
%-------------------------------------------------------------------------
function edit_all_input_params_Callback(hObject, eventdata, handles)
global H_INPUT H_UTM
H_INPUT = input_window;
h = findobj('Tag','utm_window');
if (isempty(h)~=1 & isempty(H_UTM)~=1)
    close(figure(H_UTM))
    H_UTM = [];
end



