function varargout = increment_window(varargin)
% INCREMENT_WINDOW M-file for increment_window.fig
%      INCREMENT_WINDOW, by itself, creates a new INCREMENT_WINDOW or raises the existing
%      singleton*.
%
%      H = INCREMENT_WINDOW returns the handle to a new INCREMENT_WINDOW or the handle to
%      the existing singleton*.
%
%      INCREMENT_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INCREMENT_WINDOW.M with the given input arguments.
%
%      INCREMENT_WINDOW('Property','Value',...) creates a new INCREMENT_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before increment_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to increment_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help increment_window

% Last Modified by GUIDE v2.5 01-Jun-2006 16:13:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @increment_window_OpeningFcn, ...
                   'gui_OutputFcn',  @increment_window_OutputFcn, ...
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


% --- Executes just before increment_window is made visible.
function increment_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for increment_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = increment_window_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;



function x_increment_Callback(hObject, eventdata, handles)
global GRID
GRID(5,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(GRID(5,1),'%6.2f'));

% --- Executes during object creation, after setting all properties.
function x_increment_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(5,1),'%6.2f'));



function y_increment_Callback(hObject, eventdata, handles)
global GRID
GRID(6,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(GRID(6,1),'%6.2f'));

% --- Executes during object creation, after setting all properties.
function y_increment_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(6,1),'%6.2f'));


% --- Executes on button press in OK_button.
function OK_button_Callback(hObject, eventdata, handles)
global GRID
global IACT
GRID(5,1) = str2num(get(findobj('Tag','x_increment'),'String'));
GRID(6,1) = str2num(get(findobj('Tag','y_increment'),'String'));
IACT = 0;
h = figure(gcf);
calc_element;
delete(h);
