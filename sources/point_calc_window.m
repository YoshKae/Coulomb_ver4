function varargout = point_calc_window(varargin)
% POINT_CALC_WINDOW M-file for point_calc_window.fig
%      POINT_CALC_WINDOW, by itself, creates a new POINT_CALC_WINDOW or raises the existing
%      singleton*.
%
%      H = POINT_CALC_WINDOW returns the handle to a new POINT_CALC_WINDOW or the handle to
%      the existing singleton*.
%
%      POINT_CALC_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POINT_CALC_WINDOW.M with the given input arguments.
%
%      POINT_CALC_WINDOW('Property','Value',...) creates a new POINT_CALC_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before point_calc_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to point_calc_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help point_calc_window

% Last Modified by GUIDE v2.5 08-Aug-2006 20:58:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @point_calc_window_OpeningFcn, ...
                   'gui_OutputFcn',  @point_calc_window_OutputFcn, ...
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


% --- Executes just before point_calc_window is made visible.
function point_calc_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global H_MAIN C_POINT ICOORD LON_GRID
h = findobj('Tag','point_calc_window');
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

figure(H_MAIN);
FIXX = str2num(get(findobj('Tag','edit_point_x'),'String'));
FIXY = str2num(get(findobj('Tag','edit_point_y'),'String'));
hold on;
C_POINT = plot(FIXX,FIXY,'ko','LineWidth',1.2);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ICOORD == 2 && isempty(LON_GRID) ~= 1
set(findobj('Tag','text_point_x'),'String','lon.(deg)');
set(findobj('Tag','text_point_y'),'String','lat.(deg)');
end

% --- Outputs from this function are returned to the command line.
function varargout = point_calc_window_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     X position (texit field)  
%-------------------------------------------------------------------------
function edit_point_x_Callback(hObject, eventdata, handles)
global GRID C_POINT FIXX FIXY H_MAIN ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(b,'%8.3f'));
    a = lonlat2xy([b 0.0]);
    FIXX = a(1);
else
    FIXX = str2double(get(hObject,'String'));
    if FIXX < GRID(1) | FIXX > GRID(3)
        h = warndlg('the position should be within the study area.','!!Warning!!');
        waitfor(h);
    end
    set(hObject,'String',num2str(FIXX,'%8.3f'));
end
figure(H_MAIN);
hold on;
delete(C_POINT);
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([FIXX FIXY]);
    C_POINT = plot(a(1),a(2),'ko','LineWidth',1.2);
else
    C_POINT = plot(FIXX,FIXY,'ko','LineWidth',1.2);
end

% --- Executes during object creation, after setting all properties.
function edit_point_x_CreateFcn(hObject, eventdata, handles)
global GRID FIXX ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FIXX = (GRID(1) + GRID(3)) / 2.0;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([FIXX 0.0]);
    set(hObject,'String',num2str(a(1),'%8.3f'));    
else
    set(hObject,'String',num2str(FIXX,'%8.3f'));
end

%-------------------------------------------------------------------------
%     Y position (texit field)  
%-------------------------------------------------------------------------
function edit_point_y_Callback(hObject, eventdata, handles)
global GRID C_POINT FIXX FIXY H_MAIN H_MAIN ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(b,'%8.3f'));
    a = lonlat2xy([0.0 b]);
    FIXY = a(2);    
else
    FIXY = str2double(get(hObject,'String'));
    if FIXY < GRID(1) | FIXY > GRID(3)
        h = warndlg('the position should be within the study area.','!!Warning!!');
        waitfor(h);
    end
    set(hObject,'String',num2str(FIXY,'%8.3f'));
end
figure(H_MAIN);
hold on;
delete(C_POINT);
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([FIXX FIXY]);
    C_POINT = plot(a(1),a(2),'ko','LineWidth',1.2);
else
    C_POINT = plot(FIXX,FIXY,'ko','LineWidth',1.2);
end

% --- Executes during object creation, after setting all properties.
function edit_point_y_CreateFcn(hObject, eventdata, handles)
global GRID FIXY ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
FIXY = (GRID(2) + GRID(4)) / 2.0;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    a = xy2lonlat([0.0 FIXY]);
    set(hObject,'String',num2str(a(2),'%8.3f'));    
else
    set(hObject,'String',num2str(FIXY,'%8.3f'));
end

%-------------------------------------------------------------------------
%     Z position (texit field)  
%-------------------------------------------------------------------------
function edit_point_z_Callback(hObject, eventdata, handles)
z = str2double(get(hObject,'String'));
if z < 0.0
    h = warndlg('depth is positive','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(z,'%8.3f'));

% --- Executes during object creation, after setting all properties.
function edit_point_z_CreateFcn(hObject, eventdata, handles)
global CALC_DEPTH
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(CALC_DEPTH,'%8.3f'));

%-------------------------------------------------------------------------
%     Mouse click (pushbuttton)  
%-------------------------------------------------------------------------
function pushbutton_mouse_point_Callback(hObject, eventdata, handles)
global FIXX FIXY ICOORD LON_GRID
global H_MAIN C_POINT
% global FUNC_SWITCH
    xy = [];
 %   n = 0;
    figure(H_MAIN);
   [xi,yi,but] = ginput(1);
   xy(:,1) = [xi;yi];
   FIXX = xy(1,1);
   FIXY = xy(2,1);
   if ICOORD == 2 && isempty(LON_GRID) ~= 1
        h = findobj('Tag','edit_point_x');
        set(h,'String',num2str(FIXX,'%8.3f'));
        h = findobj('Tag','edit_point_y');
        set(h,'String',num2str(FIXY,'%8.3f'));  
        a = lonlat2xy([FIXX FIXY]);
        FIXX = a(1);
        FIXY = a(2);
   else
        h = findobj('Tag','edit_point_x');
        set(h,'String',num2str(FIXX,'%8.3f'));
        h = findobj('Tag','edit_point_y');
        set(h,'String',num2str(FIXY,'%8.3f'));  
   end
    figure(H_MAIN);
    hold on;
    delete(C_POINT);
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([FIXX FIXY]);
        C_POINT = plot(a(1),a(2),'ko','LineWidth',1.2);
    else
        C_POINT = plot(FIXX,FIXY,'ko','LineWidth',1.2);
    end

%-------------------------------------------------------------------------
%     Strike of receiver fault (point) (texit field)  
%-------------------------------------------------------------------------
function edit_point_strike_Callback(hObject, eventdata, handles)
strike = str2double(get(hObject,'String'));
if strike < 0.0 | strike >= 360.0
    h = warndlg('strike should be in 0.0 to 359.99','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(strike,'%6.2f'));

function edit_point_strike_CreateFcn(hObject, eventdata, handles)
global AV_STRIKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(AV_STRIKE,'%6.2f'));

%-------------------------------------------------------------------------
%     Dip of receiver fault (point) (texit field)  
%-------------------------------------------------------------------------
function edit_point_dip_Callback(hObject, eventdata, handles)
dip = str2double(get(hObject,'String'));
if dip < 0.0 | dip >= 90.0
    h = warndlg('dip should be in 0.0 to 90','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(dip,'%5.2f'));

% --- Executes during object creation, after setting all properties.
function edit_point_dip_CreateFcn(hObject, eventdata, handles)
global AV_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(AV_DIP,'%6.2f'));

%-------------------------------------------------------------------------
%     Rake of receiver fault (point) (texit field)  
%-------------------------------------------------------------------------
function edit_point_rake_Callback(hObject, eventdata, handles)
rake = str2double(get(hObject,'String'));
if rake < -180.0 | rake > 180.0
    h = warndlg('rake should be in -180.0 to 180','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(rake,'%6.2f'));

% --- Executes during object creation, after setting all properties.
function edit_point_rake_CreateFcn(hObject, eventdata, handles)
global AV_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(AV_RAKE,'%6.2f'));



%-------------------------------------------------------------------------
%     Shear stress change (texit field)  -- OUTPUT --
%-------------------------------------------------------------------------
function edit_point_shear_Callback(hObject, eventdata, handles)
set(hObject,'String','-');

% --- Executes during object creation, after setting all properties.
function edit_point_shear_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','-');

%-------------------------------------------------------------------------
%     Normal stress change (texit field)  -- OUTPUT --
%-------------------------------------------------------------------------
function edit_point_normal_Callback(hObject, eventdata, handles)
set(hObject,'String','-');

% --- Executes during object creation, after setting all properties.
function edit_point_normal_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','-');

%-------------------------------------------------------------------------
%     Coulomb stress change (texit field)  -- OUTPUT --
%-------------------------------------------------------------------------
function edit_coulomb_stress_Callback(hObject, eventdata, handles)
set(hObject,'String','-');

% --- Executes during object creation, after setting all properties.
function edit_coulomb_stress_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','-');

%-------------------------------------------------------------------------
%     CALCULATION (pushbutton) 
%-------------------------------------------------------------------------
function pushbutton_point_calculation_Callback(hObject, eventdata, handles)
global FIXX FIXY CALC_DEPTH ICOORD LON_GRID
global SEC_FLAG DC3D FRIC
SEC_FLAG = 0;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    b1 = str2num(get(findobj('Tag','edit_point_x'),'String'));
    b2 = str2num(get(findobj('Tag','edit_point_y'),'String')); 
    a = lonlat2xy([b1 b2]);
    FIXX = a(1);
    FIXY = a(2);
else
    FIXX = str2num(get(findobj('Tag','edit_point_x'),'String'));
    FIXY = str2num(get(findobj('Tag','edit_point_y'),'String'));
end
temp = CALC_DEPTH;
CALC_DEPTH = str2num(get(findobj('Tag','edit_point_z'),'String'));
strike = str2num(get(findobj('Tag','edit_point_strike'),'String'));
dip = str2num(get(findobj('Tag','edit_point_dip'),'String'));
rake = str2num(get(findobj('Tag','edit_point_rake'),'String'));
Okada_halfspace_one;

CALC_DEPTH = temp;
a = 1;
ss = zeros(6,a);
s9 = reshape(DC3D(1,9),1,a);
s10 = reshape(DC3D(1,10),1,a);
s11 = reshape(DC3D(1,11),1,a);
s12 = reshape(DC3D(1,12),1,a);
s13 = reshape(DC3D(1,13),1,a);
s14 = reshape(DC3D(1,14),1,a);
ss = [s9; s10; s11; s12; s13; s14];
    shear = zeros(a,1);
    normal = zeros(a,1);
    coulomb = zeros(a,1);
    c1 = zeros(a,1) + strike;
    c2 = zeros(a,1) + dip;
    c3 = zeros(a,1) + rake;
    c4 = zeros(a,1) + FRIC;
    [shear,normal,coulomb] = calc_coulomb(c1,c2,c3,c4,ss);
    if shear < 0.0
        set(findobj('Tag','edit_point_shear'),'ForegroundColor','b');       
    elseif shear > 0.0
        set(findobj('Tag','edit_point_shear'),'ForegroundColor','r'); 
    end
    if normal < 0.0
        set(findobj('Tag','edit_point_normal'),'ForegroundColor','b');       
    elseif normal > 0.0
        set(findobj('Tag','edit_point_normal'),'ForegroundColor','r'); 
    end
    if coulomb < 0.0
        set(findobj('Tag','edit_coulomb_stress'),'ForegroundColor','b');       
    elseif coulomb > 0.0
        set(findobj('Tag','edit_coulomb_stress'),'ForegroundColor','r'); 
    end
    set(findobj('Tag','edit_point_shear'),'String',num2str(shear,'%8.3f'));
    set(findobj('Tag','edit_point_normal'),'String',num2str(normal,'%8.3f'));
    set(findobj('Tag','edit_coulomb_stress'),'String',num2str(coulomb,'%8.3f'));

%-------------------------------------------------------------------------
%     CLOSE (pushbutton) 
%-------------------------------------------------------------------------
function pushbutton_point_close_Callback(hObject, eventdata, handles)
h = figure(gcf);
delete(h);


