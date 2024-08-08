function varargout = section_view_window(varargin)
% SECTION_VIEW_WINDOW M-file for section_view_window.fig
%      SECTION_VIEW_WINDOW, by itself, creates a new SECTION_VIEW_WINDOW or raises the existing
%      singleton*.
%
%      H = SECTION_VIEW_WINDOW returns the handle to a new SECTION_VIEW_WINDOW or the handle to
%      the existing singleton*.
%
%      SECTION_VIEW_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SECTION_VIEW_WINDOW.M with the given input arguments.
%
%      SECTION_VIEW_WINDOW('Property','Value',...) creates a new SECTION_VIEW_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before section_view_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to section_view_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help section_view_window

% Last Modified by GUIDE v2.5 04-Jun-2006 09:45:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @section_view_window_OpeningFcn, ...
                   'gui_OutputFcn',  @section_view_window_OutputFcn, ...
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


% --- Executes just before section_view_window is made visible.
function section_view_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to section_view_window (see VARARGIN)

global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
% window width 585 pixel
wind_width = 585;
% window height 300 pixel
wind_height = 300;
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for section_view_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes section_view_window wait for user response (see UIRESUME)
% uiwait(handles.section_view_window);


% --- Outputs from this function are returned to the command line.
function varargout = section_view_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
