function varargout = displ_h_window(varargin)
% DISPL_H_WINDOW M-file for displ_h_window.fig
%      DISPL_H_WINDOW, by itself, creates a new DISPL_H_WINDOW or raises the existing
%      singleton*.
%
%      H = DISPL_H_WINDOW returns the handle to a new DISPL_H_WINDOW or the handle to
%      the existing singleton*.
%
%      DISPL_H_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPL_H_WINDOW.M with the given input arguments.
%
%      DISPL_H_WINDOW('Property','Value',...) creates a new DISPL_H_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before displ_h_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to displ_h_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help displ_h_window

% Last Modified by GUIDE v2.5 04-Aug-2006 17:41:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @displ_h_window_OpeningFcn, ...
                   'gui_OutputFcn',  @displ_h_window_OutputFcn, ...
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


% --- Executes just before displ_h_window is made visible.
function displ_h_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
set(findobj('Tag','Mouse_click'),'Enable','Off');
h = findobj('Tag','displ_h_window');
j = get(h,'Position');
wind_width = j(1,3);
wind_height = j(1,4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for displ_h_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes displ_h_window wait for user response (see UIRESUME)
% uiwait(handles.displ_h_window);


% --- Outputs from this function are returned to the command line.
function varargout = displ_h_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
% Calculations are only done by pushing
%       1) "Calc. & view" button
%       2) changing the slider movement
%       3) "Mouse click"
% (collect all input information when doing the above two excutions)
%-------------------------------------------------------------------------

%=========================================================================
%	  SLIDER MOVEMENT
%=========================================================================
function slider_displ_Callback(hObject, eventdata, handles)
%
global FUNC_SWITCH
global H_MAIN
global DISP_SCALE
global SIZE
temp_reserve = FUNC_SWITCH;
h = findobj('Tag','exaggeration');
v = get(hObject,'Value') * SIZE(3,1);
set(h,'String',num2str(v,'%6.0f'));
	figure(H_MAIN);
    delete(axes('Parent',H_MAIN));
    hold on;
    FUNC_SWITCH = temp_reserve;
    DISP_SCALE = get(hObject,'Value');
calc_button_Callback;

%-----
function slider_displ_CreateFcn(hObject, eventdata, handles)
% 
global DISP_SCALE
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
DISP_SCALE = get(hObject,'Value');

%-------------------------------------------------------------------------
%	  UIPANEL SELECTION CHANGE  
%-------------------------------------------------------------------------
function uipanel_reference_SelectionChangeFcn(hObject,eventdata,handles)
%
global COORD
selection = get(hObject,'SelectedObject')
switch get(selection,'Tag')
    case 'radiobutton_nofix'
        radiobutton_nofix_Callback;
        COORD = 1; % cartesian coordinate
    case 'radiobutton_fixcart'
        radiobutton_fixcart_Callback;
        COORD = 1; % cartesian coordinate
    case 'radiobutton_fixlonlat'
        COORD = 2;
end

%-------------------------------------------------------------------------
%	  NO FIX (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_nofix_Callback(hObject, eventdata, handles)
global H_MAIN FIXFLAG FUNC_SWITCH
set(findobj('Tag','Mouse_click'),'Enable','off');
x = get(hObject,'Value');
if x==1;
    temp_reserve = FUNC_SWITCH;
%     COORD = 1;
    FIXFLAG = 0;
    figure(H_MAIN);
    delete(axes('Parent',H_MAIN));
    hold on;
    FUNC_SWITCH = temp_reserve;
    h = findobj('Tag','slider_displ');
	displ_open(get(h,'Value'));
%    FUNC_SWITCH = 0; %reset
end

%-------------------------------------------------------------------------
%	  FIXED CARTESIAN (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_fixcart_Callback(hObject, eventdata, handles)
global COORD  FIXFLAG H_MAIN FIXX FIXY FUNC_SWITCH
set(findobj('Tag','Mouse_click'),'Enable','on');
x = get(hObject,'Value');
if x==1;
    COORD = 1;
    FIXFLAG = 1;
    h = findobj('Tag','edit_fixx');
    FIXX = str2double(get(h,'String'));
    h = findobj('Tag','edit_fixy');
    FIXY = str2double(get(h,'String'));
%     figure(H_MAIN);
%     delete(axes('Parent',H_MAIN));
%     hold on;
%     FUNC_SWITCH = 2;
%     h = findobj('Tag','slider_displ');
% 	displ_open(get(h,'Value'));
%     FUNC_SWITCH = 0; %reset
end

%-------------------------------------------------------------------------
%	  FIXED LON & LAT (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_fixlonlat_Callback(hObject, eventdata, handles)
%
global COORD  FIXFLAG H_MAIN FIXX FIXY FUNC_SWITCH
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global GRID
set(findobj('Tag','Mouse_click'),'Enable','on');
x = get(hObject,'Value');
if x==1;
%     d = warndlg('Make sure the study area and type lon. & lat. as a ref point');
%     study_area;
%    COORD = 1;
    FIXFLAG = 2;
    mid_lon = (MIN_LON + MAX_LON) / 2.0;
    mid_lat = (MIN_LAT + MAX_LAT) / 2.0;
    h = findobj('Tag','edit_fixlon');
    set(h,'String',num2str(mid_lon,'%7.2f'));
    h = findobj('Tag','edit_fixlat');
    set(h,'String',num2str(mid_lat,'%6.2f'));
    a = lonlat2xy([mid_lon mid_lat]);
    FIXX = a(1);
    FIXY = a(2);
%         xs = GRID(1,1);
%         xf = GRID(3,1);
%         ys = GRID(2,1);
%         yf = GRID(4,1);
%         xinc = (xf - xs)/(MAX_LON-MIN_LON);
%         yinc = (yf - ys)/(MAX_LAT-MIN_LAT);
%         FIXX = xs + xinc * (mid_lon - MIN_LON);
%         FIXY = ys + yinc * (mid_lat - MIN_LAT);
%     figure(H_MAIN);
%     delete(axes('Parent',H_MAIN));
%     hold on;
%     FUNC_SWITCH = 2;
%     h = findobj('Tag','slider_displ');
% 	displ_open(get(h,'Value'));
%     FUNC_SWITCH = 0; %reset
end

%-------------------------------------------------------------------------
%	  FIXED X POSITION (textfield)
%-------------------------------------------------------------------------
function edit_fixx_Callback(hObject, eventdata, handles)
% 
global COORD  FIXFLAG H_MAIN FIXX FIXY FUNC_SWITCH
FIXX = str2double(get(hObject,'String'));
    COORD = 1;
    FIXFLAG = 1;
    h = findobj('Tag','edit_fixy');
    FIXY = str2double(get(h,'String'));
%     figure(H_MAIN);
%     delete(axes('Parent',H_MAIN));
%     hold on;
%     FUNC_SWITCH = 2;
%     h = findobj('Tag','slider_displ');
% 	displ_open(get(h,'Value'));
%     FUNC_SWITCH = 0; %reset
    
% --- Executes during object creation, after setting all properties.
function edit_fixx_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global FIXX FIXY FIXFLAG
FIXX = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%	  FIXED Y POSITION (textfield)
%-------------------------------------------------------------------------
function edit_fixy_Callback(hObject, eventdata, handles)
% 
global COORD  FIXFLAG H_MAIN FIXX FIXY FUNC_SWITCH
global DISP_SCALE
FIXY = str2double(get(hObject,'String'));
    h = findobj('Tag','edit_fixx');
    FIXX = str2double(get(h,'String'));
%     figure(H_MAIN);
%     delete(axes('Parent',H_MAIN));
%     hold on;
%     FUNC_SWITCH = 2;
%     h = findobj('Tag','slider_displ');
% 	displ_open(get(h,'Value'));
%     FUNC_SWITCH = 0; %reset

% --- Executes during object creation, after setting all properties.
function edit_fixy_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global FIXX FIXY FIXFLAG
FIXY = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%	  FIXED LON POSITION (textfield)
%-------------------------------------------------------------------------
function edit_fixlon_Callback(hObject, eventdata, handles)
global COORD  FIXFLAG H_MAIN FIXX FIXY FUNC_SWITCH
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global GRID
    target_lon = str2double(get(hObject,'String'));
    target_lat = str2double(get(findobj('Tag','edit_fixlat'),'String'));
    set(hObject,'String',num2str(target_lon,'%7.2f'));
    a = lonlat2xy([target_lon target_lat]);
    FIXX = a(1);
    FIXY = a(2);
    
% --- Executes during object creation, after setting all properties.
function edit_fixlon_CreateFcn(hObject, eventdata, handles)
global MIN_LON MAX_LON
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% mid_lon = (MIN_LON + MAX_LON)/2.0;
% set(hObject,'String',num2str(mid_lon,'%7.2f'));


%-------------------------------------------------------------------------
%	  FIXED LAT POSITION (textfield)
%-------------------------------------------------------------------------
function edit_fixlat_Callback(hObject, eventdata, handles)
global COORD  FIXFLAG H_MAIN FIXX FIXY FUNC_SWITCH
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global GRID
    target_lon = str2double(get(findobj('Tag','edit_fixlon'),'String'));
    target_lat = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(target_lat,'%7.2f'));
    a = lonlat2xy([target_lon target_lat]);
    FIXX = a(1);
    FIXY = a(2);
    
% --- Executes during object creation, after setting all properties.
function edit_fixlat_CreateFcn(hObject, eventdata, handles)
global MIN_LAT MAX_LAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% mid_lat = (MIN_LAT + MAX_LAT)/2.0;
% set(hObject,'String',num2str(mid_lat,'%7.2f'));


%-------------------------------------------------------------------------
%	  CALC DEPTH  
%-------------------------------------------------------------------------
function edit_displdepth_Callback(hObject, eventdata, handles)
% 
global CALC_DEPTH FLAG_DEPTH IACT
CALC_DEPTH = str2num(get(hObject,'String'));
FLAG_DEPTH = 1;
IACT = 0;

function edit_displdepth_CreateFcn(hObject, eventdata, handles)
% 
global CALC_DEPTH
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(CALC_DEPTH,'%5.2f'));



%=========================================================================
%	  Executes on button press in Mouse_click. 
%=========================================================================
function Mouse_click_Callback(hObject, eventdata, handles)
% hObject    handle to Mouse_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% selecting the fixed point by mouse
global FIXX FIXY FIXFLAG COORD
global H_MAIN A_MAIN
global FUNC_SWITCH
temp_reserve = FUNC_SWITCH;
% FIXFLAG = 1;
xy = [];
n = 0;
% but = 1;
% while but == 1
    figure(H_MAIN);
    % ca = axes('Parent',H_MAIN);
   [xi,yi,but] = ginput(1);
%    plot(A_MAIN,xi,yi,'ro'); 
%    n = n+1;
   xy(:,1) = [xi;yi];
   FIXX = xy(1,1);
   FIXY = xy(2,1);
if FIXFLAG == 1
    h = findobj('Tag','edit_fixx');
    set(h,'String',num2str(xi,'%7.2f'));
    h = findobj('Tag','edit_fixy');
    set(h,'String',num2str(yi,'%7.2f'));
    plot(A_MAIN,xi,yi,'ro'); 
elseif FIXFLAG == 2
%     a = xy2lonlat([FIXX FIXY])
     h = findobj('Tag','edit_fixlon');
    set(h,'String',num2str(xi,'%7.2f'));
    h = findobj('Tag','edit_fixlat');
    set(h,'String',num2str(yi,'%7.2f'));
    plot(A_MAIN,xi,yi,'ro');
    a = lonlat2xy([xi yi]);
    FIXX = a(1);
    FIXY = a(2);
end
    figure(H_MAIN);
    delete(axes('Parent',H_MAIN));
    hold on;
	FUNC_SWITCH = temp_reserve;
%     h = findobj('Tag','slider_displ');
% 	displ_open(get(h,'Value'));
calc_button_Callback
    hold on;
        plot(A_MAIN,xi,yi,'ro');
%    FUNC_SWITCH = 0; %reset

    
%=========================================================================
%	  CALC & VIEW BUTTON
%=========================================================================
function calc_button_Callback(hObject, eventdata, handles)
% 
global FIXFLAG H_MAIN A_MAIN FIXX FIXY FUNC_SWITCH
global IACT DC3D FLAG_DEPTH ICOORD LON_GRID
global COAST_DATA EQ_DATA AFAULT_DATA
global H_SECTION HOME_DIR PREF_DIR OUTFLAG INPUT_FILE
temp_reserve = FUNC_SWITCH;
%--- action when we change the target depth -----------
% if FLAG_DEPTH == 1
if IACT ~= 1        
Okada_halfspace;
end
IACT = 1;           % to keep okada output
    a = DC3D(:,1:2);
    b = DC3D(:,5:8);
    c = horzcat(a,b);
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files;
    else
	cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z UX UY UZ';
    header3 = '(km) (km) (km) (m) (m) (m)';
    dlmwrite('Displacement.cou',header1,'delimiter',''); 
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
    disp(['Displacement.cou is saved in ' pwd]);
    cd (HOME_DIR);
%     dlmwrite('Displacement.cou',c,'delimiter','\t');
    FLAG_DEPTH = 0;
% end
%------------------------------------------------------

if FIXFLAG == 1         %%%%% fixed cartesian calc.
    h = findobj('Tag','edit_fixx');
    FIXX = str2double(get(h,'String'));
    h = findobj('Tag','edit_fixy');
    FIXY = str2double(get(h,'String'));
    figure(H_MAIN);
    delete(axes('Parent',H_MAIN));
    hold on;
    FUNC_SWITCH = temp_reserve;
    h = findobj('Tag','slider_displ');
	displ_open(get(h,'Value'));
    hold on;
    plot(A_MAIN,FIXX,FIXY,'ro');  
elseif FIXFLAG == 2     %%%%% fixed lonlat calc.
    h1 = findobj('Tag','edit_fixlon');
    h2 = findobj('Tag','edit_fixlat');
    if isempty(get(h1,'String'))~=1 & isempty(get(h2,'String'))~=1
            b1 = str2double(get(h1,'String'));
            b2 = str2double(get(h2,'String'));
            a = lonlat2xy([b1 b2]);
            FIXX = a(1); FIXY = a(2);
        figure(H_MAIN);
        delete(axes('Parent',H_MAIN));
        hold on;
    	FUNC_SWITCH = temp_reserve;
        h = findobj('Tag','slider_displ');
        displ_open(get(h,'Value'));
        hold on;
        plot(A_MAIN,b1,b2,'ro');
    else
        warndlg('Put number in Lon & Lat textboxes');
    end   
else                    %%%%% no fixed point
        figure(H_MAIN);
        delete(axes('Parent',H_MAIN));
        hold on;
        FUNC_SWITCH = temp_reserve;
        h = findobj('Tag','slider_displ');
        displ_open(get(h,'Value'));
%        FUNC_SWITCH = 0; %reset
end
% ----- overlay drawing --------------------------------
if isempty(COAST_DATA) ~= 1 | isempty(EQ_DATA) ~= 1 | isempty(AFAULT_DATA) ~= 1
        hold on;
        overlay_drawing;
end
% ----- update cross section window if exist ------------
h = findobj('Tag','section_view_window');
if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    draw_dipped_cross_section;
    displacement_section;
end
% ----- update cartesian / lon & lat control for disp_h_window
if IACT == 0
if ICOORD == 1
    set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off');
    set(findobj('Tag','text_disp_lon'),'Visible','off');
    set(findobj('Tag','text_disp_lat'),'Visible','off');
    set(findobj('Tag','edit_fixlon'),'Visible','off');
    set(findobj('Tag','edit_fixlat'),'Visible','off');
    set(findobj('Tag','radiobutton_fixcart'),'Visible','on');
    set(findobj('Tag','text_cart_x'),'Visible','on');
    set(findobj('Tag','text_cart_y'),'Visible','on');
    set(findobj('Tag','text_x_km'),'Visible','on');
    set(findobj('Tag','text_y_km'),'Visible','on');
    set(findobj('Tag','edit_fixx'),'Visible','on');
    set(findobj('Tag','edit_fixy'),'Visible','on');  
else
    set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
    set(findobj('Tag','text_cart_x'),'Visible','off');
    set(findobj('Tag','text_cart_y'),'Visible','off');
    set(findobj('Tag','text_x_km'),'Visible','off');
    set(findobj('Tag','text_y_km'),'Visible','off');
    set(findobj('Tag','edit_fixx'),'Visible','off');
    set(findobj('Tag','edit_fixy'),'Visible','off');  
    set(findobj('Tag','radiobutton_fixlonlat'),'Visible','on');
    set(findobj('Tag','text_disp_lon'),'Visible','on');
    set(findobj('Tag','text_disp_lat'),'Visible','on');
    set(findobj('Tag','edit_fixlon'),'Visible','on');
    set(findobj('Tag','edit_fixlat'),'Visible','on');
end 
end

%-------------------------------------------------------------------------
%	  CROSS SECTION BUTTON (Button)  
%-------------------------------------------------------------------------
function cross_section_w_Callback(hObject, eventdata, handles)
% 
global H_SEC_WINDOW
global FUNC_SWITCH
temp_reserve = FUNC_SWITCH;
H_SEC_WINDOW = xsec_window;
set(findobj('Tag','text_downdip_inc'),'Visible','off');
set(findobj('Tag','edit_downdip_inc'),'Visible','off');
set(findobj('Tag','text_downdip_inc_km'),'Visible','off');
set(findobj('Tag','text_section_dip'),'Visible','off');
set(findobj('Tag','edit_section_dip'),'Visible','off');
set(findobj('Tag','text_section_dip_deg'),'Visible','off');
FUNC_SWITCH = temp_reserve; %reset

%-------------------------------------------------------------------------
%	  EXAGGERATION (Textfield)  
%-------------------------------------------------------------------------
function exaggeration_Callback(hObject, eventdata, handles)
%
global SIZE
global DISP_SCALE
ds = str2num(get(hObject,'String'));
DISP_SCALE = int32(ds/SIZE(3,1));
set(hObject,'String',num2str(ds,'%6.0f'));
h = findobj('Tag','slider_displ');
mx = get(h,'Max');
if DISP_SCALE >= mx
    set(h,'Value',mx);
    set(hObject,'String',num2str(mx*SIZE(3,1),'%6.0f'));
else
    set(h,'Value',DISP_SCALE);
end
calc_button_Callback;

%----
function exaggeration_CreateFcn(hObject, eventdata, handles)
% 
global SIZE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% h = get(findobj('Tag','slider_displ'),'Value');
set(hObject,'String',num2str(SIZE(3,1),'%6.0f'));
