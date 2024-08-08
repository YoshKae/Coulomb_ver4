function varargout = study_area(varargin)
% STUDY_AREA M-file for study_area.fig
%      STUDY_AREA, by itself, creates a new STUDY_AREA or raises the existing
%      singleton*.
%
%      H = STUDY_AREA returns the handle to a new STUDY_AREA or the handle to
%      the existing singleton*.
%
%      STUDY_AREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STUDY_AREA.M with the given input arguments.
%
%      STUDY_AREA('Property','Value',...) creates a new STUDY_AREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before study_area_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to study_area_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help study_area

% Last Modified by GUIDE v2.5 31-May-2006 17:06:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @study_area_OpeningFcn, ...
                   'gui_OutputFcn',  @study_area_OutputFcn, ...
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


% --- Executes just before study_area is made visible.
function study_area_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for study_area
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes study_area wait for user response (see UIRESUME)
% uiwait(handles.study_area);


% --- Outputs from this function are returned to the command line.
function varargout = study_area_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     MINIMUM LATITUDE (textfield)
%-------------------------------------------------------------------------
function min_lat_Callback(hObject, eventdata, handles)
global MIN_LAT
MIN_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MIN_LAT,'%7.3f'));
check_mapinfo_input;

function min_lat_CreateFcn(hObject, eventdata, handles)
global MIN_LAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(MIN_LAT,'%7.3f'));

%-------------------------------------------------------------------------
%     MAXIMU LATITUDE (textfield)
%-------------------------------------------------------------------------
function max_lat_Callback(hObject, eventdata, handles)
global MAX_LAT
MAX_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MAX_LAT,'%7.3f'));
check_mapinfo_input;

function max_lat_CreateFcn(hObject, eventdata, handles)
global MAX_LAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(MAX_LAT,'%7.3f'));

%-------------------------------------------------------------------------
%     ZERO LATITUDE (textfield)
%-------------------------------------------------------------------------
function zero_lat_Callback(hObject, eventdata, handles)
global ZERO_LAT
ZERO_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ZERO_LAT,'%7.3f'));
check_mapinfo_input;

function zero_lat_CreateFcn(hObject, eventdata, handles)
global ZERO_LAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ZERO_LAT,'%7.3f'));

%-------------------------------------------------------------------------
%     MINIMUM LONGITUDE (textfield)
%-------------------------------------------------------------------------
function min_lon_Callback(hObject, eventdata, handles)
global MIN_LON
MIN_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MIN_LON,'%8.3f'));
check_mapinfo_input;

function min_lon_CreateFcn(hObject, eventdata, handles)
global MIN_LON
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(MIN_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     MAXIMU LONGITUDE (textfield)
%-------------------------------------------------------------------------
function max_lon_Callback(hObject, eventdata, handles)
global MAX_LON
MAX_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MAX_LON,'%8.3f'));
check_mapinfo_input;

function max_lon_CreateFcn(hObject, eventdata, handles)
global MAX_LON
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(MAX_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     ZERO LONGITUDE (textfield)
%-------------------------------------------------------------------------
function zero_lon_Callback(hObject, eventdata, handles)
global ZERO_LON
ZERO_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ZERO_LON,'%8.3f'));
check_mapinfo_input;

function zero_lon_CreateFcn(hObject, eventdata, handles)
global ZERO_LON
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ZERO_LON,'%8.3f'));

%-------------------------------------------------------------------------
%     OK button (pushbutton)
%-------------------------------------------------------------------------
function OK_Callback(hObject, eventdata, handles)
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global OVERLAYFLAG
MIN_LAT = str2num(get(findobj('Tag','min_lat'),'String'));
MAX_LAT = str2num(get(findobj('Tag','max_lat'),'String'));
ZERO_LAT = str2num(get(findobj('Tag','zero_lat'),'String'));
MIN_LON = str2num(get(findobj('Tag','min_lon'),'String'));
MAX_LON = str2num(get(findobj('Tag','max_lon'),'String'));
ZERO_LON = str2num(get(findobj('Tag','zero_lon'),'String'));
h = figure(gcf);
delete(h);
calc_element;
% if OVERLAYFLAG == 1
%     earthquake_plot;
% elseif OVERLAYFLAG == 2
%     coastline_drawing;
% end

%-------------------------------------------------------------------------
%     Cancel button (pushbutton)
%-------------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles)
h = figure(gcf);
delete(h);


%-----------------------------------------------------------
function check_mapinfo_input
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON

if MIN_LAT >= MAX_LAT
    warning('min lat should be smaller than max lat.');
end

if MIN_LON >= MAX_LON
    warning('min lon should be smaller than max lon.');
end

if (ZERO_LAT < MIN_LAT) | (ZERO_LAT > MAX_LAT)
    warning('zero lat should be between min lat and max lat');
end

if (ZERO_LON < MIN_LON) | (ZERO_LON > MAX_LON)
    warning('zero lon should be between min lon and max lon');
end






