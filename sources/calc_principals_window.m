function varargout = calc_principals_window(varargin)
% CALC_PRINCIPALS_WINDOW M-file for calc_principals_window.fig
%      CALC_PRINCIPALS_WINDOW, by itself, creates a new CALC_PRINCIPALS_WINDOW or raises the existing
%      singleton*.
%
%      H = CALC_PRINCIPALS_WINDOW returns the handle to a new CALC_PRINCIPALS_WINDOW or the handle to
%      the existing singleton*.
%
%      CALC_PRINCIPALS_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALC_PRINCIPALS_WINDOW.M with the given input arguments.
%
%      CALC_PRINCIPALS_WINDOW('Property','Value',...) creates a new CALC_PRINCIPALS_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calc_principals_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calc_principals_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calc_principals_window

% Last Modified by GUIDE v2.5 15-Sep-2006 14:34:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calc_principals_window_OpeningFcn, ...
                   'gui_OutputFcn',  @calc_principals_window_OutputFcn, ...
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


% --- Executes just before calc_principals_window is made visible.
function calc_principals_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calc_principals_window (see VARARGIN)
set(findobj('Tag','pushbutton_calc_step2'),'Enable','Off');
set(findobj('Tag','edit_d2'),'Enable','Off');
set(findobj('Tag','text_s2_dip'),'Enable','Off');
set(findobj('Tag','text_dip_range'),'Enable','Off');

% Choose default command line output for calc_principals_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = calc_principals_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%	edit Sigma 1 strike for Step 1
%-------------------------------------------------------------------------
function edit_s1_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
if x < 0.0 | x >= 180.0
    h = warndlg('Strike should be 0?s<180 here','!! Warnimg !!');
    waitfor(h);
    set(hObject,'String',''); return;
end
set(hObject,'String',num2str(x,'%6.1f'));
if isempty(get(findobj('Tag','edit_s1'),'String'))~=1
    set(findobj('Tag','pushbutton_calc_step2'),'Enable','Off');
    set(findobj('Tag','edit_d2'),'Enable','Off');
    set(findobj('Tag','text_s2_dip'),'Enable','Off');
    set(findobj('Tag','text_dip_range'),'Enable','Off');
end

function edit_s1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	edit Sigma 1 dip for Step 1
%-------------------------------------------------------------------------
function edit_d1_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
if x < -90.0 | x > 90.0
    h = warndlg('Dip should be -90<s?90 here','!! Warnimg !!');
    waitfor(h);
    set(hObject,'String',''); return;
end
set(hObject,'String',num2str(x,'%6.1f'));
if isempty(get(findobj('Tag','edit_s1'),'String'))~=1
    set(findobj('Tag','pushbutton_calc_step2'),'Enable','Off');
    set(findobj('Tag','edit_d2'),'Enable','Off');
    set(findobj('Tag','text_s2_dip'),'Enable','Off');
    set(findobj('Tag','text_dip_range'),'Enable','Off');
end

function edit_d1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	CALC button for Step 1
%-------------------------------------------------------------------------
function pushbutton_calc_step1_Callback(hObject, eventdata, handles)
global S2D_MINMAX
%[rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsin,iflag)
rsin = ones(3,2)*(-1000);
rsin(1,1) = str2num(get(findobj('Tag','edit_s1'),'String'));
rsin(1,2) = str2num(get(findobj('Tag','edit_d1'),'String'));
iflag = 1;
[rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsin,iflag);
S2D_MINMAX = minmax;
set(findobj('Tag','pushbutton_calc_step2'),'Enable','On');
set(findobj('Tag','edit_d2'),'Enable','On');
set(findobj('Tag','text_s2_dip'),'Enable','On');
set(findobj('Tag','text_dip_range'),'Enable','On');
set(findobj('Tag','text_dip_range'),'String',['Dip range: ',...
    num2str(minmax(1),'%6.1f'),' to ',num2str(minmax(2),'%6.1f'),'‹']);
% set(findobj('Tag','edit_d2'),'String',num2str(minmax(1,1),'%8.3f'));

%-------------------------------------------------------------------------
%	CALC button for Step 2
%-------------------------------------------------------------------------
function pushbutton_calc_step2_Callback(hObject, eventdata, handles)
rsin = ones(3,2)*(-1000);
rsin(1,1) = str2num(get(findobj('Tag','edit_s1'),'String'));
rsin(1,2) = str2num(get(findobj('Tag','edit_d1'),'String'));
rsin(2,2) = str2num(get(findobj('Tag','edit_d2'),'String'));
iflag = 2;
% [rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsin,iflag);
[rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsin,iflag);
set(findobj('Tag','edit_11s'),'String',num2str(rsout1(1,1),'%6.1f'));
set(findobj('Tag','edit_11d'),'String',num2str(rsout1(1,2),'%6.1f'));
set(findobj('Tag','edit_12s'),'String',num2str(rsout1(2,1),'%6.1f'));
set(findobj('Tag','edit_12d'),'String',num2str(rsout1(2,2),'%6.1f'));
set(findobj('Tag','edit_13s'),'String',num2str(rsout1(3,1),'%6.1f'));
set(findobj('Tag','edit_13d'),'String',num2str(rsout1(3,2),'%6.1f'));
set(findobj('Tag','edit_21s'),'String',num2str(rsout2(1,1),'%6.1f'));
set(findobj('Tag','edit_21d'),'String',num2str(rsout2(1,2),'%6.1f'));
set(findobj('Tag','edit_22s'),'String',num2str(rsout2(2,1),'%6.1f'));
set(findobj('Tag','edit_22d'),'String',num2str(rsout2(2,2),'%6.1f'));
set(findobj('Tag','edit_23s'),'String',num2str(rsout2(3,1),'%6.1f'));
set(findobj('Tag','edit_23d'),'String',num2str(rsout2(3,2),'%6.1f'));
set(findobj('Tag','edit_31s'),'String',num2str(rsout3(1,1),'%6.1f'));
set(findobj('Tag','edit_31d'),'String',num2str(rsout3(1,2),'%6.1f'));
set(findobj('Tag','edit_32s'),'String',num2str(rsout3(2,1),'%6.1f'));
set(findobj('Tag','edit_32d'),'String',num2str(rsout3(2,2),'%6.1f'));
set(findobj('Tag','edit_33s'),'String',num2str(rsout3(3,1),'%6.1f'));
set(findobj('Tag','edit_33d'),'String',num2str(rsout3(3,2),'%6.1f'));
set(findobj('Tag','edit_41s'),'String',num2str(rsout4(1,1),'%6.1f'));
set(findobj('Tag','edit_41d'),'String',num2str(rsout4(1,2),'%6.1f'));
set(findobj('Tag','edit_42s'),'String',num2str(rsout4(2,1),'%6.1f'));
set(findobj('Tag','edit_42d'),'String',num2str(rsout4(2,2),'%6.1f'));
set(findobj('Tag','edit_43s'),'String',num2str(rsout4(3,1),'%6.1f'));
set(findobj('Tag','edit_43d'),'String',num2str(rsout4(3,2),'%6.1f'));

%-------------------------------------------------------------------------
%	edit Sigma 2 dip for Step 2
%-------------------------------------------------------------------------
function edit_d2_Callback(hObject, eventdata, handles)
global S2D_MINMAX
x = str2num(get(hObject,'String'));
if x < S2D_MINMAX(1) | x > S2D_MINMAX(2)
    h = warndlg('Out of possible dip range','!! Warnimg !!');
    waitfor(h);
    set(hObject,'String',''); return;
end
set(hObject,'String',num2str(x,'%6.1f'));

function edit_d2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%	Close button
%-------------------------------------------------------------------------
function pushbutton_close_Callback(hObject, eventdata, handles)
delete(gcf);


%-------------------------------------------------------------------------
%	Combination 1
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_11s_Callback(hObject, eventdata, handles)

function edit_11s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_11d_Callback(hObject, eventdata, handles)

function edit_11d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_12s_Callback(hObject, eventdata, handles)

function edit_12s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_12d_Callback(hObject, eventdata, handles)

function edit_12d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_13s_Callback(hObject, eventdata, handles)

function edit_13s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_13d_Callback(hObject, eventdata, handles)

function edit_13d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	Combination 2
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_21s_Callback(hObject, eventdata, handles)

function edit_21s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_21d_Callback(hObject, eventdata, handles)

function edit_21d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_22s_Callback(hObject, eventdata, handles)

function edit_22s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_22d_Callback(hObject, eventdata, handles)

function edit_22d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_23s_Callback(hObject, eventdata, handles)

function edit_23s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_23d_Callback(hObject, eventdata, handles)

function edit_23d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	Combination 3
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_31s_Callback(hObject, eventdata, handles)

function edit_31s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_31d_Callback(hObject, eventdata, handles)

function edit_31d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_32s_Callback(hObject, eventdata, handles)

function edit_32s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_32d_Callback(hObject, eventdata, handles)

function edit_32d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_33s_Callback(hObject, eventdata, handles)

function edit_33s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_33d_Callback(hObject, eventdata, handles)

function edit_33d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	Combination 4
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_41s_Callback(hObject, eventdata, handles)

function edit_41s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_41d_Callback(hObject, eventdata, handles)

function edit_41d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_42s_Callback(hObject, eventdata, handles)

function edit_42s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_42d_Callback(hObject, eventdata, handles)

function edit_42d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_43s_Callback(hObject, eventdata, handles)

function edit_43s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_43d_Callback(hObject, eventdata, handles)

function edit_43d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


