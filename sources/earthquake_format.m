function varargout = earthquake_format(varargin)
% EARTHQUAKE_FORMAT M-file for earthquake_format.fig
%      EARTHQUAKE_FORMAT, by itself, creates a new EARTHQUAKE_FORMAT or raises the existing
%      singleton*.
%
%      H = EARTHQUAKE_FORMAT returns the handle to a new EARTHQUAKE_FORMAT or the handle to
%      the existing singleton*.
%
%      EARTHQUAKE_FORMAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EARTHQUAKE_FORMAT.M with the given input arguments.
%
%      EARTHQUAKE_FORMAT('Property','Value',...) creates a new EARTHQUAKE_FORMAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before earthquake_format_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to earthquake_format_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help earthquake_format

% Last Modified by GUIDE v2.5 24-Aug-2006 20:22:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @earthquake_format_OpeningFcn, ...
                   'gui_OutputFcn',  @earthquake_format_OutputFcn, ...
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


% --- Executes just before earthquake_format is made visible.
function earthquake_format_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
xpos = SCRW_X;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for earthquake_format
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes earthquake_format wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = earthquake_format_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
