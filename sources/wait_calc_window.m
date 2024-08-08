function varargout = wait_calc_window(varargin)
% WAIT_CALC_WINDOW M-file for wait_calc_window.fig
%      WAIT_CALC_WINDOW, by itself, creates a new WAIT_CALC_WINDOW or raises the existing
%      singleton*.
%
%      H = WAIT_CALC_WINDOW returns the handle to a new WAIT_CALC_WINDOW or the handle to
%      the existing singleton*.
%
%      WAIT_CALC_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAIT_CALC_WINDOW.M with the given input arguments.
%
%      WAIT_CALC_WINDOW('Property','Value',...) creates a new WAIT_CALC_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wait_calc_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wait_calc_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wait_calc_window

% Last Modified by GUIDE v2.5 08-Oct-2006 13:11:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wait_calc_window_OpeningFcn, ...
                   'gui_OutputFcn',  @wait_calc_window_OutputFcn, ...
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


% --- Executes just before wait_calc_window is made visible.
function wait_calc_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global SHADE_TYPE
h = findobj('Tag','wait_calc_window');
j = get(h,'Position');
wind_width = j(1,3);
wind_height = j(1,4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3)/2 - wind_width/2 - SCRW_X/2;
ypos = h(1,2) + h(1,4)/2 - wind_height/2;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for wait_calc_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wait_calc_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wait_calc_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
