function varargout = afault_format_window(varargin)
% AFAULT_FORMAT_WINDOW M-file for afault_format_window.fig
%      AFAULT_FORMAT_WINDOW, by itself, creates a new AFAULT_FORMAT_WINDOW or raises the existing
%      singleton*.
%
%      H = AFAULT_FORMAT_WINDOW returns the handle to a new AFAULT_FORMAT_WINDOW or the handle to
%      the existing singleton*.
%
%      AFAULT_FORMAT_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFAULT_FORMAT_WINDOW.M with the given input arguments.
%
%      AFAULT_FORMAT_WINDOW('Property','Value',...) creates a new AFAULT_FORMAT_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before afault_format_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to afault_format_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help afault_format_window

% Last Modified by GUIDE v2.5 05-Dec-2006 11:32:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @afault_format_window_OpeningFcn, ...
                   'gui_OutputFcn',  @afault_format_window_OutputFcn, ...
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


% --- Executes just before afault_format_window is made visible.
function afault_format_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width

% % Choose default command line output for afault_format_window
handles.output = hObject;
% 
% % Update handles structure
guidata(hObject, handles);
% 
h = findobj('Tag','afault_format_window');
j = get(h,'Position');
wind_width = j(3);
wind_height = j(4);
xpos = SCRW_X;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% --- Outputs from this function are returned to the command line.
function varargout = afault_format_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton_lonlat.
function radiobutton_lonlat_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_lonlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_lonlat
x = get(hObject,'Value');
if x == 1
    set(findobj('Tag','radiobutton_latlon'),'Value',0);
end

% --- Executes on button press in radiobutton_latlon.
function radiobutton_latlon_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_latlon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_latlon
x = get(hObject,'Value');
if x == 1
    set(findobj('Tag','radiobutton_lonlat'),'Value',0);
end

% --- Executes on button press in pushbutton_af_cancel.
function pushbutton_af_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_af_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(figure(gcf));


% --- Executes on button press in pushbutton_af_ok.
function pushbutton_af_ok_Callback(hObject, eventdata, handles)
global PLATFORM
% hObject    handle to pushbutton_af_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = get(findobj('Tag','radiobutton_lonlat'),'Value');
delete(figure(gcf));
%     if strcmp(PLATFORM,'MACI') | strcmp(PLATFORM,'MACI64') | strcmp(PLATFORM,'GLNX86') | strcmp(PLATFORM,'GLNXA64')
%         dum_intel_mac;
%     end
hold on;
afault_drawing(x);

%------------------------
% dummy function
%------------------------
function dum_intel_mac
%
%   dummy to read EQ catalog on Intel Mac. For unknown reason,
%   uigetfile does not work properly for the first access.
%
    [filename,pathname] = uigetfile({'*.*'},' Open input file');
    if isequal(filename,0)
        return
    else
        return
    end

