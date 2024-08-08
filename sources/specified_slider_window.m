function varargout = specified_slider_window(varargin)
% SPECIFIED_SLIDER_WINDOW M-file for specified_slider_window.fig
%      SPECIFIED_SLIDER_WINDOW, by itself, creates a new SPECIFIED_SLIDER_WINDOW or raises the existing
%      singleton*.
%
%      H = SPECIFIED_SLIDER_WINDOW returns the handle to a new SPECIFIED_SLIDER_WINDOW or the handle to
%      the existing singleton*.
%
%      SPECIFIED_SLIDER_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECIFIED_SLIDER_WINDOW.M with the given input arguments.
%
%      SPECIFIED_SLIDER_WINDOW('Property','Value',...) creates a new SPECIFIED_SLIDER_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before specified_slider_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to specified_slider_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help specified_slider_window

% Last Modified by GUIDE v2.5 03-Sep-2007 12:06:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @specified_slider_window_OpeningFcn, ...
                   'gui_OutputFcn',  @specified_slider_window_OutputFcn, ...
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


% --- Executes just before specified_slider_window is made visible.
function specified_slider_window_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for specified_slider_window
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
	h = get(dummy,'Position');
end
xpos = h(1) + h(3) + 5;
dummy1 = findobj('Tag','coulomb_window');
h = get(dummy1,'Position');
ypos = h(2) - wind_height - 30;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% --- Outputs from this function are returned to the command line.
function varargout = specified_slider_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%       Strike (slider)
%-------------------------------------------------------------------------
function slider_strike_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
set(findobj('Tag','edit_spec_strike'),'String',num2str(x,'%6.1f'));
coulomb_calc_and_view;

% --- Executes during object creation, after setting all properties.
function slider_strike_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
x = str2double(get(findobj('Tag','edit_spec_strike'),'String'));
set(hObject,'Value',x);

%-------------------------------------------------------------------------
%       Dip (slider)
%-------------------------------------------------------------------------
function slider_dip_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
set(findobj('Tag','edit_spec_dip'),'String',num2str(x,'%6.1f'));
coulomb_calc_and_view;


% --- Executes during object creation, after setting all properties.
function slider_dip_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
x = str2double(get(findobj('Tag','edit_spec_dip'),'String'));
set(hObject,'Value',x);

%-------------------------------------------------------------------------
%       Rake (slider)
%-------------------------------------------------------------------------
function slider_rake_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
set(findobj('Tag','edit_spec_rake'),'String',num2str(x,'%6.1f'));
coulomb_calc_and_view;


% --- Executes during object creation, after setting all properties.
function slider_rake_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
x = str2double(get(findobj('Tag','edit_spec_rake'),'String'));
set(hObject,'Value',x);

%-------------------------------------------------------------------------
%       Friction (slider)
%-------------------------------------------------------------------------
function slider_friction_Callback(hObject, eventdata, handles)
global FRIC
x = get(hObject,'Value');
set(findobj('Tag','edit_coul_fric'),'String',num2str(x,'%4.2f'));
FRIC = x;
coulomb_calc_and_view;

% --- Executes during object creation, after setting all properties.
function slider_friction_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
x = str2double(get(findobj('Tag','edit_coul_fric'),'String'));
set(hObject,'Value',x);

%-------------------------------------------------------------------------
%       Close (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_slider_close_Callback(hObject, eventdata, handles)
h = figure(gcf);
delete(h);


