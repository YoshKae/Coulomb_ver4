function varargout = annotation_window(varargin)
% ANNOTATION_WINDOW M-file for annotation_window.fig
%      ANNOTATION_WINDOW, by itself, creates a new ANNOTATION_WINDOW or raises the existing
%      singleton*.
%
%      H = ANNOTATION_WINDOW returns the handle to a new ANNOTATION_WINDOW or the handle to
%      the existing singleton*.
%
%      ANNOTATION_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNOTATION_WINDOW.M with the given input arguments.
%
%      ANNOTATION_WINDOW('Property','Value',...) creates a new ANNOTATION_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before annotation_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to annotation_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help annotation_window

% Last Modified by GUIDE v2.5 06-Dec-2006 09:03:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @annotation_window_OpeningFcn, ...
                   'gui_OutputFcn',  @annotation_window_OutputFcn, ...
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


% --- Executes just before annotation_window is made visible.
function annotation_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to annotation_window (see VARARGIN)

% Choose default command line output for annotation_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes annotation_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = annotation_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%	Type annotation (textfield)
%-------------------------------------------------------------------------
function edit_annotation_Callback(hObject, eventdata, handles)
global GTEXT_DATA
%     GTEXT_DATA(n+1).x = 0.0;
%     GTEXT_DATA(n+1).y = 0.0;
%     GTEXT_DATA(n+1).handle = 0.00;
%     GTEXT_DATA(n+1).text = [];
%     GTEXT_DATA(n+1).font = 10.0;
% hObject    handle to edit_annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_annotation as text
%        str2double(get(hObject,'String')) returns contents of edit_annotation as a double



% --- Executes during object creation, after setting all properties.
function edit_annotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%	Fontsize (textfield)
%-------------------------------------------------------------------------
function edit_fontsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fontsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fontsize as text
%        str2double(get(hObject,'String')) returns contents of edit_fontsize as a double


% --- Executes during object creation, after setting all properties.
function edit_fontsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fontsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%	Cancel (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_an_cancel_Callback(hObject, eventdata, handles)
global ANNOTATION_CANCELED
% hObject    handle to pushbutton_an_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ANNOTATION_CANCELED = 1;
delete(figure(gcf));

%-------------------------------------------------------------------------
%	OK (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_an_ok_Callback(hObject, eventdata, handles)
global GTEXT_DATA
% hObject    handle to pushbutton_an_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    n = length(GTEXT_DATA);
    GTEXT_DATA(n+1).text = get(handles.edit_annotation,'String');
    GTEXT_DATA(n+1).font = str2num(get(handles.edit_fontsize,'String'));
    delete(figure(gcf));


