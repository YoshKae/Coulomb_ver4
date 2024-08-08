function varargout = f3d_view_control_window(varargin)
% F3D_VIEW_CONTROL_WINDOW M-file for f3d_view_control_window.fig
%      F3D_VIEW_CONTROL_WINDOW, by itself, creates a new F3D_VIEW_CONTROL_WINDOW or raises the existing
%      singleton*.
%
%      H = F3D_VIEW_CONTROL_WINDOW returns the handle to a new F3D_VIEW_CONTROL_WINDOW or the handle to
%      the existing singleton*.
%
%      F3D_VIEW_CONTROL_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in F3D_VIEW_CONTROL_WINDOW.M with the given input arguments.
%
%      F3D_VIEW_CONTROL_WINDOW('Property','Value',...) creates a new F3D_VIEW_CONTROL_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before f3d_view_control_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to f3d_view_control_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help f3d_view_control_window

% Last Modified by GUIDE v2.5 29-Jul-2006 08:34:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @f3d_view_control_window_OpeningFcn, ...
                   'gui_OutputFcn',  @f3d_view_control_window_OutputFcn, ...
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


% --- Executes just before f3d_view_control_window is made visible.
function f3d_view_control_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global H_MAIN C_POINT
h = findobj('Tag','f3d_view_control_window');
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

% Choose default command line output for f3d_view_control_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes f3d_view_control_window wait for user response (see UIRESUME)
% uiwait(handles.f3d_view_control_window);


% --- Outputs from this function are returned to the command line.
function varargout = f3d_view_control_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     Net slip (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_net_slip_Callback(hObject, eventdata, handles)
global F3D_SLIP_TYPE FUNC_SWITCH
x = get(hObject,'Value');
if x == 1
    F3D_SLIP_TYPE = 1;
    set(findobj('Tag','radiobutton_strike_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_dip_slip'),'Value',0.0);
end
% subfig_clear;
% FUNC_SWITCH = 1;
% grid_drawing_3d;
% displ_open(2);
% flag = check_lonlat_info;
% if flag == 1
%     all_overlay_enable_on;
% end

%-------------------------------------------------------------------------
%     Strike-slip slip (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_strike_slip_Callback(hObject, eventdata, handles)
global F3D_SLIP_TYPE FUNC_SWITCH
x = get(hObject,'Value');
if x == 1
    F3D_SLIP_TYPE = 2;
    set(findobj('Tag','radiobutton_net_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_dip_slip'),'Value',0.0);
end
% subfig_clear;
% FUNC_SWITCH = 1;
% grid_drawing_3d;
% displ_open(2);
% flag = check_lonlat_info;
% if flag == 1
%     all_overlay_enable_on;
% end

%-------------------------------------------------------------------------
%     Dip slip slip (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_dip_slip_Callback(hObject, eventdata, handles)
global F3D_SLIP_TYPE FUNC_SWITCH
x = get(hObject,'Value');
if x == 1
    F3D_SLIP_TYPE = 3;
    set(findobj('Tag','radiobutton_net_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_strike_slip'),'Value',0.0);
end
% subfig_clear;
% FUNC_SWITCH = 1;
% grid_drawing_3d;
% displ_open(2);
% flag = check_lonlat_info;
% if flag == 1
%     all_overlay_enable_on;
% end

%-------------------------------------------------------------------------
%     Saturation slip (text box)  
%-------------------------------------------------------------------------
function edit_slip_color_sat_Callback(hObject, eventdata, handles)
global C_SLIP_SAT
C_SLIP_SAT = str2double(get(hObject,'String'));
set(hObject,'String',num2str(C_SLIP_SAT,'%6.2f'));

%--------------------
function edit_slip_color_sat_CreateFcn(hObject, eventdata, handles)
global C_SLIP_SAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
	set(hObject,'String',num2str(C_SLIP_SAT,'%6.2f'));    

%-------------------------------------------------------------------------
%     Redrawing (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_redraw_Callback(hObject, eventdata, handles)
global F3D_SLIP_TYPE FUNC_SWITCH
% a1 = get(findobj('Tag','radiobutton_net_slip'));
% a2 = get(findobj('Tag','radiobutton_strike_slip'));
% a3 = get(findobj('Tag','radiobutton_dip_slip'));
% if a1 == 1
%         F3D_SLIP_TYPE = 1;
% elseif a2 == 1
%         F3D_SLIP_TYPE = 2;
% elseif a3 == 1
%         F3D_SLIP_TYPE = 3;   
% else
%     disp('junk');
% end
% subfig_clear;
FUNC_SWITCH = 1;
grid_drawing_3d;
displ_open(2);
flag = check_lonlat_info;
if flag == 1
    all_overlay_enable_on;
end


%----------------------------------------------------------
function all_overlay_enable_on
set(findobj('Tag','menu_gridlines'),'Enable','On');
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');    
