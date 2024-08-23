function varargout = preference_window(varargin)
% PREFERENCE_WINDOW M-file for preference_window.fig
%      PREFERENCE_WINDOW, by itself, creates a new PREFERENCE_WINDOW or raises the existing
%      singleton*.
%
%      H = PREFERENCE_WINDOW returns the handle to a new PREFERENCE_WINDOW or the handle to
%      the existing singleton*.
%
%      PREFERENCE_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREFERENCE_WINDOW.M with the given input arguments.
%
%      PREFERENCE_WINDOW('Property','Value',...) creates a new PREFERENCE_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preference_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preference_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preference_window

% Last Modified by GUIDE v2.5 10-Jan-2007 09:20:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preference_window_OpeningFcn, ...
                   'gui_OutputFcn',  @preference_window_OutputFcn, ...
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


% --- Executes just before preference_window is made visible.
function preference_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global OUTFLAG
j = get(findobj('Tag','preference_window'),'Position');
wind_width = j(1,3);
wind_height = j(1,4);

dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + 50;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for preference_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if OUTFLAG == 1
    h = findobj('Tag','Radiobutton_output');
    set(h,'Value',1);
    h = findobj('Tag','Radiobutton_input');
    set(h,'Value',0);
else
    h = findobj('Tag','Radiobutton_output');
    set(h,'Value',0);
    h = findobj('Tag','Radiobutton_input');
    set(h,'Value',1);
end

% --- Outputs from this function are returned to the command line.
function varargout = preference_window_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     FAULT COLOR R (textfield)  
%-------------------------------------------------------------------------
function fault_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(1,1) = str2num(get(hObject,'String'));
[PREF(1,1)] = check_value(PREF(1,1));
set(hObject,'String',num2str(PREF(1,1),'%3.1f'));

function fault_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(1,1),'%3.1f'));


%-------------------------------------------------------------------------
%     FAULT COLOR G (textfield)  
%-------------------------------------------------------------------------
function fault_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(1,2) = str2num(get(hObject,'String'));
[PREF(1,2)] = check_value(PREF(1,2));
set(hObject,'String',num2str(PREF(1,2),'%3.1f'));

function fault_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(1,2),'%3.1f'));

%-------------------------------------------------------------------------
%     FAULT COLOR B (textfield)  
%-------------------------------------------------------------------------
function fault_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(1,3) = str2num(get(hObject,'String'));
[PREF(1,3)] = check_value(PREF(1,3));
set(hObject,'String',num2str(PREF(1,3),'%3.1f'));

function fault_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(1,3),'%3.1f'));

%-------------------------------------------------------------------------
%     VECTOR COLOR R (textfield)  
%-------------------------------------------------------------------------
function vector_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(2,1) = str2num(get(hObject,'String'));
[PREF(2,1)] = check_value(PREF(2,1));
set(hObject,'String',num2str(PREF(2,1),'%3.1f'));

function vector_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(2,1),'%3.1f'));

%-------------------------------------------------------------------------
%     VECTOR COLOR G (textfield)  
%-------------------------------------------------------------------------
function vector_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(2,2) = str2num(get(hObject,'String'));
[PREF(2,2)] = check_value(PREF(2,2));
set(hObject,'String',num2str(PREF(2,2),'%3.1f'));

function vector_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(2,2),'%3.1f'));

%-------------------------------------------------------------------------
%     VECTOR COLOR B (textfield)  
%-------------------------------------------------------------------------
function vector_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(2,3) = str2num(get(hObject,'String'));
[PREF(2,3)] = check_value(PREF(2,3));
set(hObject,'String',num2str(PREF(2,3),'%3.1f'));

function vector_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(2,3),'%3.1f'));

%-------------------------------------------------------------------------
%     GRID COLOR R (textfield)  
%-------------------------------------------------------------------------
function grid_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(3,1) = str2num(get(hObject,'String'));
[PREF(3,1)] = check_value(PREF(3,1));
set(hObject,'String',num2str(PREF(3,1),'%3.1f'));

function grid_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(3,1),'%3.1f'));

%-------------------------------------------------------------------------
%     GRID COLOR G (textfield)  
%-------------------------------------------------------------------------
function grid_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(3,2) = str2num(get(hObject,'String'));
[PREF(3,2)] = check_value(PREF(3,2));
set(hObject,'String',num2str(PREF(3,2),'%3.1f'));

function grid_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(3,2),'%3.1f'));

%-------------------------------------------------------------------------
%     GRID COLOR B (textfield)  
%-------------------------------------------------------------------------
function grid_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(3,3) = str2num(get(hObject,'String'));
[PREF(3,3)] = check_value(PREF(3,3));
set(hObject,'String',num2str(PREF(3,3),'%3.1f'));

function grid_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(3,3),'%3.1f'));

%-------------------------------------------------------------------------
%     COASTLINE COLOR R (textfield)  
%-------------------------------------------------------------------------
function coastline_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(4,1) = str2num(get(hObject,'String'));
[PREF(4,1)] = check_value(PREF(4,1));
set(hObject,'String',num2str(PREF(4,1),'%3.1f'));

function coastline_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(4,1),'%3.1f'));

%-------------------------------------------------------------------------
%     COASTLINE COLOR G (textfield)  
%-------------------------------------------------------------------------
function coastline_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(4,2) = str2num(get(hObject,'String'));
[PREF(4,2)] = check_value(PREF(4,2));
set(hObject,'String',num2str(PREF(4,2),'%3.1f'));

function coastline_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(4,2),'%3.1f'));

%-------------------------------------------------------------------------
%     COASTLINE COLOR B (textfield)  
%-------------------------------------------------------------------------
function coastline_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(4,3) = str2num(get(hObject,'String'));
[PREF(4,3)] = check_value(PREF(4,3));
set(hObject,'String',num2str(PREF(4,3),'%3.1f'));

function coastline_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(4,3),'%3.1f'));

%-------------------------------------------------------------------------
%     EARTHQUAKE COLOR R (textfield)  
%-------------------------------------------------------------------------
function eq_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(5,1) = str2num(get(hObject,'String'));
[PREF(5,1)] = check_value(PREF(5,1));
set(hObject,'String',num2str(PREF(5,1),'%3.1f'));

function eq_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(5,1),'%3.1f'));

%-------------------------------------------------------------------------
%     EARTHQUAKE COLOR G (textfield)  
%-------------------------------------------------------------------------
function eq_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(5,2) = str2num(get(hObject,'String'));
[PREF(5,2)] = check_value(PREF(5,2));
set(hObject,'String',num2str(PREF(5,2),'%3.1f'));

function eq_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(5,2),'%3.1f'));

%-------------------------------------------------------------------------
%     EARTHQUAKE COLOR B (textfield)  
%-------------------------------------------------------------------------
function eq_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(5,3) = str2num(get(hObject,'String'));
[PREF(5,3)] = check_value(PREF(5,3));
set(hObject,'String',num2str(PREF(5,3),'%3.1f'));

function eq_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(5,3),'%3.1f'));

%-------------------------------------------------------------------------
%     ACTIVE FAULT COLOR R (textfield)  
%-------------------------------------------------------------------------
function afault_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(6,1) = str2num(get(hObject,'String'));
[PREF(6,1)] = check_value(PREF(6,1));
set(hObject,'String',num2str(PREF(6,1),'%3.1f'));

function afault_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(6,1),'%3.1f'));

%-------------------------------------------------------------------------
%     ACTIVE FAULT COLOR G (textfield)  
%-------------------------------------------------------------------------
function afault_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(6,2) = str2num(get(hObject,'String'));
[PREF(6,2)] = check_value(PREF(6,2));
set(hObject,'String',num2str(PREF(6,2),'%3.1f'));

function afault_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(6,2),'%3.1f'));

%-------------------------------------------------------------------------
%     ACTIVE FAULT COLOR B (textfield)  
%-------------------------------------------------------------------------
function afault_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(6,3) = str2num(get(hObject,'String'));
[PREF(6,3)] = check_value(PREF(6,3));
set(hObject,'String',num2str(PREF(6,3),'%3.1f'));

function afault_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(6,3),'%3.1f'));

%-------------------------------------------------------------------------
%     VOLCANO COLOR R (textfield)  
%-------------------------------------------------------------------------
function volcano_color_R_Callback(hObject, eventdata, handles)
global PREF
PREF(9,1) = str2num(get(hObject,'String'));
[PREF(9,1)] = check_value(PREF(9,1));
set(hObject,'String',num2str(PREF(9,1),'%3.1f'));

function volcano_color_R_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
try
set(hObject,'String',num2str(PREF(9,1),'%3.1f'));
catch
set(hObject,'String',num2str(0.9,'%3.1f'));
end

%-------------------------------------------------------------------------
%     VOLCANO COLOR G (textfield)  
%-------------------------------------------------------------------------
function volcano_color_G_Callback(hObject, eventdata, handles)
global PREF
PREF(9,2) = str2num(get(hObject,'String'));
[PREF(9,2)] = check_value(PREF(9,2));
set(hObject,'String',num2str(PREF(9,2),'%3.1f'));

function volcano_color_G_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
try
set(hObject,'String',num2str(PREF(9,2),'%3.1f'));
catch
set(hObject,'String',num2str(0.9,'%3.1f'));
end

%-------------------------------------------------------------------------
%     VOLCANO COLOR B (textfield)  
%-------------------------------------------------------------------------
function volcano_color_B_Callback(hObject, eventdata, handles)
global PREF
PREF(9,3) = str2num(get(hObject,'String'));
[PREF(9,3)] = check_value(PREF(9,3));
set(hObject,'String',num2str(PREF(9,3),'%3.1f'));

function volcano_color_B_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
try
set(hObject,'String',num2str(PREF(9,3),'%3.1f'));
catch
set(hObject,'String',num2str(0.1,'%3.1f'));
end

%-------------------------------------------------------------------------
%     FAULT LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function fault_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(1,4) = str2num(get(hObject,'String'));
[PREF(1,4)] = check_value_width(PREF(1,4));
set(hObject,'String',num2str(PREF(1,4),'%3.1f'));

function fault_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(1,4),'%3.1f'));

%-------------------------------------------------------------------------
%     VECTOR LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function vector_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(2,4) = str2num(get(hObject,'String'));
[PREF(2,4)] = check_value_width(PREF(2,4));
set(hObject,'String',num2str(PREF(2,4),'%3.1f'));

function vector_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(2,4),'%3.1f'));

%-------------------------------------------------------------------------
%     GRID LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function grid_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(3,4) = str2num(get(hObject,'String'));
% [PREF(3,4)] = check_value(PREF(3,4));
set(hObject,'String',num2str(PREF(3,4),'%3.1f'));

function grid_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(3,4),'%3.1f'));

%-------------------------------------------------------------------------
%     COASTLINE LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function coastline_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(4,4) = str2num(get(hObject,'String'));
[PREF(4,4)] = check_value_width(PREF(4,4));
set(hObject,'String',num2str(PREF(4,4),'%3.1f'));

function coastline_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(4,4),'%3.1f'));

%-------------------------------------------------------------------------
%     EARTHQUAKE LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function eq_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(5,4) = str2num(get(hObject,'String'));
[PREF(5,4)] = check_value_width(PREF(5,4));
set(hObject,'String',num2str(PREF(5,4),'%3.1f'));

function eq_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(5,4),'%3.1f'));

%-------------------------------------------------------------------------
%     ACTIVE FAULT LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function afault_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(6,4) = str2num(get(hObject,'String'));
[PREF(6,4)] = check_value_width(PREF(6,4));
set(hObject,'String',num2str(PREF(6,4),'%3.1f'));

function afault_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(PREF(6,4),'%3.1f'));

%-------------------------------------------------------------------------
%     VOLCANO LINE WIDTH (textfield)  
%-------------------------------------------------------------------------
function volcano_line_width_Callback(hObject, eventdata, handles)
global PREF
PREF(9,4) = str2num(get(hObject,'String'));
PREF(9,4) = check_value_width(PREF(9,4));
set(hObject,'String',num2str(PREF(9,4),'%3.1f'));

function volcano_line_width_CreateFcn(hObject, eventdata, handles)
global PREF
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
try
set(hObject,'String',num2str(PREF(9,4),'%3.1f'));
catch
set(hObject,'String',num2str(1.0,'%3.1f'));
end

%-------------------------------------------------------------------------
%     COLOR MAP CHOICE (pop up menu)  
%-------------------------------------------------------------------------
function color_map_pop_Callback(hObject, eventdata, handles)
global PREF
PREF(7,1)   = single(get(hObject,'Value'));
PREF(7,2:4) = 0.00;

function color_map_pop_CreateFcn(hObject, eventdata, handles)
global PREF
set(hObject,'Value',int8(PREF(7,1)));
PREF(7,2:4) = 0.00;

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     COORDINATE CHOICE (pop up menu) 
%-------------------------------------------------------------------------
function popupmenu_xy_lonlat_Callback(hObject, eventdata, handles)
global ICOORD PREF COAST_DATA AFAULT_DATA XY_RATIO GRID IACT
global COORD_ACTION % used to refresh corresponding to switching coord
global LON_GRID
temp = ICOORD;
ICOORD = single(get(hObject,'Value'));
PREF(8,1) = ICOORD;
if ICOORD == 1
    XY_RATIO = 1;
else
    % dummy to get XY_RATIO
    try
        a  = xy2lonlat([GRID(1,1) GRID(2,1)]);
    catch
        return
    end
end
if ICOORD ~= temp
    COORD_ACTION = 1;
    IACT = 0;
end


function popupmenu_xy_lonlat_CreateFcn(hObject, eventdata, handles)
global ICOORD PREF XY_RATIO GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if isempty(ICOORD)
ICOORD = PREF(8,1);
end
if ICOORD == 1
    XY_RATIO = 1;
else
    try
    % dummy to get XY_RATIO
    a  = xy2lonlat([GRID(1,1) GRID(2,1)]);
    catch
        return
    end
end
set(hObject,'Value',int8(ICOORD));

%-------------------------------------------------------------------------
%     !! check value range from 0 to 1
%-------------------------------------------------------------------------
function [v1] = check_value(v0)
    v1 = v0;
    if v0 > 1.0
        v1 = 1.0;
    end
    if v0 < 0.0
        v1 = 0.0;
    end
%-------------------------------------------------------------------------
%     !! check value range from 0 to 1
%-------------------------------------------------------------------------
function [v1] = check_value_width(v0)
    v1 = v0;
    if v0 > 10.0
        v1 = 10.0;
    end
    if v0 < 0.1
        v1 = 0.1;
    end

%===============================================================
%     OK BUTTON (button) 
%===============================================================
function pref_OK_button_Callback(hObject, eventdata, handles)
global PREF
global COORD_ACTION % used to refresh corresponding to switching coord
global ICOORD OUTFLAG HOME_DIR PREF_DIR INPUT_FILE FNUM_ONOFF
global LON_GRID
h = figure(gcf);
delete(h);
if COORD_ACTION == 1
    if ICOORD == 1  % since 'change_coordinates' automatically switch the coordinate
        ICOORD = 2;
    else
        ICOORD = 1;
    end
    change_coordinates;
	COORD_ACTION = 0; 
end

tempdir = pwd;
if ~strcmp(tempdir,HOME_DIR)
    cd(HOME_DIR);
end
cd preferences
    dlmwrite('preferences.dat',PREF,'delimiter',' ','precision','%3.1f');
            if isempty(OUTFLAG) == 1
                OUTFLAG = 1;
            end
            if isempty(PREF_DIR) == 1
                PREF_DIR = HOME_DIR;
            end
            if isempty(INPUT_FILE) == 1
                INPUT_FILE = 'empty';
            end
    save preferences2.mat PREF_DIR INPUT_FILE OUTFLAG FNUM_ONOFF;
cd ..


%-------------------------------------------------------------------------
%     DEFAULT BUTTON (button)
%-------------------------------------------------------------------------
function default_button_Callback(hObject, eventdata, handles)
global PREF OUTFLAG FNUM_ONOFF
PREF = [1.0 0.0 0.0 1.2;...
        0.0 0.0 0.0 1.0;...
        0.7 0.7 0.0 0.2;...
        0.0 0.0 0.0 1.2;...
        1.0 0.5 0.0 3.0;...
        0.2 0.2 0.2 1.0;...
        2.0 0.0 0.0 0.0;...
        1.0 0.0 0.0 0.0;...
        0.9 0.9 0.1 1.0];
h = findobj('Tag','fault_color_R');
set(h,'String',num2str(PREF(1,1),'%3.1f'));
h = findobj('Tag','fault_color_G');
set(h,'String',num2str(PREF(1,2),'%3.1f'));
h = findobj('Tag','fault_color_B');
set(h,'String',num2str(PREF(1,3),'%3.1f'));
h = findobj('Tag','fault_line_width');
set(h,'String',num2str(PREF(1,4),'%3.1f'));
h = findobj('Tag','vector_color_R');
set(h,'String',num2str(PREF(2,1),'%3.1f'));
h = findobj('Tag','vector_color_G');
set(h,'String',num2str(PREF(2,2),'%3.1f'));
h = findobj('Tag','vector_color_B');
set(h,'String',num2str(PREF(2,3),'%3.1f'));
h = findobj('Tag','vector_line_width');
set(h,'String',num2str(PREF(2,4),'%3.1f'));
h = findobj('Tag','grid_color_R');
set(h,'String',num2str(PREF(3,1),'%3.1f'));
h = findobj('Tag','grid_color_G');
set(h,'String',num2str(PREF(3,2),'%3.1f'));
h = findobj('Tag','grid_color_B');
set(h,'String',num2str(PREF(3,3),'%3.1f'));
h = findobj('Tag','grid_line_width');
set(h,'String',num2str(PREF(3,4),'%3.1f'));
h = findobj('Tag','coastline_color_R');
set(h,'String',num2str(PREF(4,1),'%3.1f'));
h = findobj('Tag','coastline_color_G');
set(h,'String',num2str(PREF(4,2),'%3.1f'));
h = findobj('Tag','coastline_color_B');
set(h,'String',num2str(PREF(4,3),'%3.1f'));
h = findobj('Tag','coastline_line_width');
set(h,'String',num2str(PREF(4,4),'%3.1f'));
h = findobj('Tag','eq_color_R');
set(h,'String',num2str(PREF(5,1),'%3.1f'));
h = findobj('Tag','eq_color_G');
set(h,'String',num2str(PREF(5,2),'%3.1f'));
h = findobj('Tag','eq_color_B');
set(h,'String',num2str(PREF(5,3),'%3.1f'));
h = findobj('Tag','eq_line_width');
set(h,'String',num2str(PREF(5,4),'%3.1f'));
h = findobj('Tag','afault_color_R');
set(h,'String',num2str(PREF(6,1),'%3.1f'));
h = findobj('Tag','afault_color_G');
set(h,'String',num2str(PREF(6,2),'%3.1f'));
h = findobj('Tag','afault_color_B');
set(h,'String',num2str(PREF(6,3),'%3.1f'));
h = findobj('Tag','afault_line_width');
set(h,'String',num2str(PREF(6,4),'%3.1f'));
h = findobj('Tag','color_map_pop');
set(h,'Value',int8(PREF(7,1)));
h = findobj('Tag','popupmenu_xy_lonlat');
set(h,'Value',int8(PREF(8,1)));
h = findobj('Tag','Radiobutton_output');
set(h,'Value',1);
h = findobj('Tag','Radiobutton_input');
set(h,'Value',0);
h = findobj('Tag','volcano_color_R');
set(h,'String',num2str(PREF(9,1),'%3.1f'));
h = findobj('Tag','volcano_color_G');
set(h,'String',num2str(PREF(9,2),'%3.1f'));
h = findobj('Tag','volcano_color_B');
set(h,'String',num2str(PREF(9,3),'%3.1f'));
h = findobj('Tag','volcano_line_width');
set(h,'String',num2str(PREF(9,4),'%3.1f'));

set (handles.radiobutton_input,'Value',0);
set (handles.radiobutton_output,'Value',1);
OUTFLAG = 1;
set (handles.checkbox_fnumber_visible,'Value',1);
FNUM_ONOFF = 1;

%-------------------------------------------------------------------------
%   Output directory (default, radiobutton)
%-------------------------------------------------------------------------
function radiobutton_output_Callback(hObject, eventdata, handles)
global OUTFLAG
x = get(hObject,'Value');
if x == 1
    OUTFLAG = 1;
    set (handles.radiobutton_input,'Value',0);
else
    OUTFLAG = 0;
    set (handles.radiobutton_input,'Value',1);
end

function radiobutton_output_CreateFcn(hObject, eventdata, handles)
global OUTFLAG
if OUTFLAG == 1
        set (hObject,'Value',1);
else
        set (hObject,'Value',0);
end

%-------------------------------------------------------------------------
%   Output directory (input directory, radiobutton)
%-------------------------------------------------------------------------
function radiobutton_input_Callback(hObject, eventdata, handles)
global OUTFLAG
x = get(hObject,'Value');
if x == 1
    OUTFLAG = 0;
    set (handles.radiobutton_output,'Value',0);
else
    OUTFLAG = 1;
    set (handles.radiobutton_output,'Value',1);
end

function radiobutton_input_CreateFcn(hObject, eventdata, handles)
global OUTFLAG
if OUTFLAG == 0
        set (hObject,'Value',1);
else
        set (hObject,'Value',0);
end

%-------------------------------------------------------------------------
%   Fault number visible (checkbox)
%-------------------------------------------------------------------------
function checkbox_fnumber_Callback(hObject, eventdata, handles)
global FNUM_ONOFF
FNUM_ONOFF = get(hObject,'Value');


function checkbox_fnumber_CreateFcn(hObject, eventdata, handles)
global FNUM_ONOFF
if FNUM_ONOFF == 1
        set (hObject,'Value',1);
else
        set (hObject,'Value',0);
end
