function varargout = depth_range_window(varargin)
% DEPTH_RANGE_WINDOW M-file for depth_range_window.fig
%      DEPTH_RANGE_WINDOW, by itself, creates a new DEPTH_RANGE_WINDOW or raises the existing
%      singleton*.
%
%      H = DEPTH_RANGE_WINDOW returns the handle to a new DEPTH_RANGE_WINDOW or the handle to
%      the existing singleton*.
%
%      DEPTH_RANGE_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEPTH_RANGE_WINDOW.M with the given input arguments.
%
%      DEPTH_RANGE_WINDOW('Property','Value',...) creates a new DEPTH_RANGE_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before depth_range_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to depth_range_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help depth_range_window

% Last Modified by GUIDE v2.5 30-Jul-2006 16:41:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @depth_range_window_OpeningFcn, ...
                   'gui_OutputFcn',  @depth_range_window_OutputFcn, ...
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


% --- Executes just before depth_range_window is made visible.
function depth_range_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = findobj('Tag','depth_range_window');
j = get(h,'Position');
wind_width = j(3);
wind_height = j(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);% Choose default command line output for depth_range_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = depth_range_window_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     TOP DEPTH (textfield)  
%-------------------------------------------------------------------------
function edit_top_calc_depth_Callback(hObject, eventdata, handles)
global CALC_DEPTH_TOP
CALC_DEPTH_TOP = str2double(get(hObject,'String'));
if CALC_DEPTH_TOP < 0.0
    h = warndlg('depth should be positive.','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(CALC_DEPTH_TOP,'%5.1f'));
check_depth_range;

% --- Executes during object creation, after setting all properties.
function edit_top_calc_depth_CreateFcn(hObject, eventdata, handles)
global CALC_DEPTH_TOP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CALC_DEPTH_TOP = 0.0;
set(hObject,'String',num2str(CALC_DEPTH_TOP,'%5.1f'));

%-------------------------------------------------------------------------
%     BOTTOM DEPTH (textfield)  
%-------------------------------------------------------------------------
function edit_bottom_calc_depth_Callback(hObject, eventdata, handles)
global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP
CALC_DEPTH_BOTTOM = str2double(get(hObject,'String'));
if CALC_DEPTH_BOTTOM <= CALC_DEPTH_TOP
    h = warndlg('The bottom depth should be larger than the top one.','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(CALC_DEPTH_TOP,'%5.1f'));
check_depth_range;

% --- Executes during object creation, after setting all properties.
function edit_bottom_calc_depth_CreateFcn(hObject, eventdata, handles)
global CALC_DEPTH_BOTTOM
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CALC_DEPTH_BOTTOM = 20.0;
set(hObject,'String',num2str(CALC_DEPTH_BOTTOM,'%5.1f'));


%-------------------------------------------------------------------------
%     DEPTH INC. (textfield)  
%-------------------------------------------------------------------------
function edit_calc_depth_inc_Callback(hObject, eventdata, handles)
global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP CALC_DEPTH_INC CALC_DEPTH_RANGE
CALC_DEPTH_INC = str2double(get(hObject,'String'));
if CALC_DEPTH_INC <= 0.0
    h = warndlg('The increment should be greater than 0.0.','!!Warning!!');
    waitfor(h);
end
set(hObject,'String',num2str(CALC_DEPTH_INC,'%5.1f'));
check_depth_range;

% --- Executes during object creation, after setting all properties.
function edit_calc_depth_inc_CreateFcn(hObject, eventdata, handles)
global CALC_DEPTH_INC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CALC_DEPTH_INC = 5.0;
set(hObject,'String',num2str(CALC_DEPTH_INC,'%5.1f'));

%-------------------------------------------------------------------------
%	--- CHECK ---	
%-------------------------------------------------------------------------
function check_depth_range
global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP CALC_DEPTH_INC CALC_DEPTH_RANGE
mcd = mod((CALC_DEPTH_BOTTOM - CALC_DEPTH_TOP),CALC_DEPTH_INC);
n_slice = int8((CALC_DEPTH_BOTTOM - CALC_DEPTH_TOP) / CALC_DEPTH_INC - mcd/CALC_DEPTH_INC) + 1;
CALC_DEPTH_RANGE = ones(1,n_slice);
if mcd ~= 0.0
    h = warndlg('The increment does not split the depth range equally. It automatically shift the bottom.','!!Warning!!');
    waitfor(h);
end
for k = 1:n_slice
    CALC_DEPTH_RANGE(1,k) = CALC_DEPTH_TOP + (k - 1) * CALC_DEPTH_INC;
end
set(findobj('Tag','edit_bottom_calc_depth'),'String',num2str(CALC_DEPTH_RANGE(n_slice),'%5.1f'));

%-------------------------------------------------------------------------
%     MAXIMUM VALUES (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_max_value_Callback(hObject, eventdata, handles)
global DEPTH_RANGE_TYPE
x = get(hObject,'Value');
if x == 1
    DEPTH_RANGE_TYPE = 1;
    set(findobj('Tag','radiobutton_mean_value'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     MEAN VALUES (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_mean_value_Callback(hObject, eventdata, handles)
global DEPTH_RANGE_TYPE
x = get(hObject,'Value');
if x == 1
    DEPTH_RANGE_TYPE = 2;
    set(findobj('Tag','radiobutton_max_value'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     OK (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_depth_range_ok_Callback(hObject, eventdata, handles)
global CALC_DEPTH_RANGE
global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP
check_depth_range;
drange = [num2str(int32(CALC_DEPTH_TOP)) '-' num2str(int32(CALC_DEPTH_BOTTOM))];
set(findobj('Tag','edit_coul_depth'),'String',drange);
set(findobj('Tag','edit_coul_depth'),'Enable','off');
set(findobj('Tag','edit_coul_depth'),'Enable','off');
set(findobj('Tag','Slip_line'),'Enable','off');
h = figure(gcf);
delete(h);

