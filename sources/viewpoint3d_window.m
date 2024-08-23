function varargout = viewpoint3d_window(varargin)
% VIEWPOINT3D_WINDOW M-file for viewpoint3d_window.fig
%      VIEWPOINT3D_WINDOW, by itself, creates a new VIEWPOINT3D_WINDOW or raises the existing
%      singleton*.
%
%      H = VIEWPOINT3D_WINDOW returns the handle to a new VIEWPOINT3D_WINDOW or the handle to
%      the existing singleton*.
%
%      VIEWPOINT3D_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWPOINT3D_WINDOW.M with the given input arguments.
%
%      VIEWPOINT3D_WINDOW('Property','Value',...) creates a new VIEWPOINT3D_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewpoint3d_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewpoint3d_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewpoint3d_window

% Last Modified by GUIDE v2.5 11-Mar-2007 19:21:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewpoint3d_window_OpeningFcn, ...
                   'gui_OutputFcn',  @viewpoint3d_window_OutputFcn, ...
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


% --- Executes just before viewpoint3d_window is made visible.
function viewpoint3d_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global H_MAIN H_F3D_VIEW
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
	h = get(dummy,'Position');
end
xpos = h(1) + h(3) + 5;
dummy1 = findobj('Tag','f3d_view_control_window');
dummy2 = findobj('Tag','ec_control_window');
if isempty(dummy1)~=1
	h = get(dummy1,'Position');
    ypos = h(2) - wind_height - 30;
elseif isempty(dummy2)~=1
	h = get(dummy2,'Position');
    ypos = h(2) - wind_height - 30;
else
    ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
end
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for viewpoint3d_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = viewpoint3d_window_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     View (azimuth)
%-------------------------------------------------------------------------
function edit_view_az_Callback(hObject, eventdata, handles)
global FUNC_SWITCH VIEW_AZ ELEMENT POIS YOUNG FRIC ID H_MAIN
VIEW_AZ = str2num(get(hObject,'String'));
set(hObject,'String',num2str(VIEW_AZ,'%4i'));

if FUNC_SWITCH == 1         % 3d grid model
    grid_drawing_3d;
    displ_open(2);
    flag = check_lonlat_info;
    if flag == 1
        all_overlay_enable_on;
    end
elseif FUNC_SWITCH == 10    % stress on faults (element condition calc.)
    ch = get(H_MAIN,'Children');
    n = length(ch) - 3;
    if n >= 1
        for k = 1:n
            delete(ch(k));
        end
        set(H_MAIN,'Menubar','figure','Toolbar','none');
    end
    element_condition(ELEMENT,POIS,YOUNG,FRIC,ID);
    grid_drawing_3d;
    displ_open(2);
else                          % 3d displ. (FUNC_SWITCH=5, 5.5, 5.7)
	grid_drawing_3d; hold on;
    displ_open(2);
    h = findobj('Tag','xlines'); delete(h);
    h = findobj('Tag','ylines'); delete(h);
end

% --- Executes during object creation, after setting all properties.
function edit_view_az_CreateFcn(hObject, eventdata, handles)
global VIEW_AZ
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(VIEW_AZ,'%4i'));

%-------------------------------------------------------------------------
%     View (vertical elevation)
%-------------------------------------------------------------------------
function edit_view_el_Callback(hObject, eventdata, handles)
global FUNC_SWITCH VIEW_EL ELEMENT POIS YOUNG FRIC ID H_MAIN
VIEW_EL = str2num(get(hObject,'String'));
set(hObject,'String',num2str(VIEW_EL,'%4i'));

if FUNC_SWITCH == 1         % 3d grid model
    grid_drawing_3d;
    displ_open(2);
    flag = check_lonlat_info;
    if flag == 1
        all_overlay_enable_on;
    end
elseif FUNC_SWITCH == 10    % stress on faults (element condition calc.)
    ch = get(H_MAIN,'Children');
    n = length(ch) - 3;
    if n >= 1
        for k = 1:n
            delete(ch(k));
        end
        set(H_MAIN,'Menubar','figure','Toolbar','none');
    end
    element_condition(ELEMENT,POIS,YOUNG,FRIC,ID);
    grid_drawing_3d;
    displ_open(2);
else                          % 3d displ. (FUNC_SWITCH=5, 5.5, 5.7)
	grid_drawing_3d; hold on;
    displ_open(2);
    h = findobj('Tag','xlines'); delete(h);
    h = findobj('Tag','ylines'); delete(h);
end

% --- Executes during object creation, after setting all properties.
function edit_view_el_CreateFcn(hObject, eventdata, handles)
global VIEW_EL
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(VIEW_EL,'%4i'));
