function varargout = nodal_plane_window(varargin)
% NODAL_PLANE_WINDOW M-file for nodal_plane_window.fig
%      NODAL_PLANE_WINDOW, by itself, creates a new NODAL_PLANE_WINDOW or raises the existing
%      singleton*.
%
%      H = NODAL_PLANE_WINDOW returns the handle to a new NODAL_PLANE_WINDOW or the handle to
%      the existing singleton*.
%
%      NODAL_PLANE_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NODAL_PLANE_WINDOW.M with the given input arguments.
%
%      NODAL_PLANE_WINDOW('Property','Value',...) creates a new NODAL_PLANE_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nodal_plane_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nodal_plane_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nodal_plane_window

% Last Modified by GUIDE v2.5 27-Jan-2007 06:39:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nodal_plane_window_OpeningFcn, ...
                   'gui_OutputFcn',  @nodal_plane_window_OutputFcn, ...
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


% --- Executes just before nodal_plane_window is made visible.
function nodal_plane_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global INODAL NODAL_ACT
h = findobj('Tag','nodal_plane_window');
j = get(h,'Position');
wind_width = j(1,3);
wind_height = j(1,4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% Choose default command line output for nodal_plane_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

INODAL = 1;
NODAL_ACT = 0;


% --- Outputs from this function are returned to the command line.
function varargout = nodal_plane_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     NODAL PLANE 1 (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_nodal1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_nodal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_nodal1
global INODAL NODAL_ACT HOME_DIR
x = get(hObject,'Value');
if x == 1
    INODAL = 1;
    set(findobj('Tag','radiobutton_nodal2'),'Value',0.0);
    set(findobj('Tag','radiobutton_shaffle'),'Value',0.0);
    set(findobj('Tag','radiobutton_maxplane'),'Value',0.0);
    set(findobj('Tag','radiobutton_minplane'),'Value',0.0);
	set(hObject,'Value',1.0);
end
NODAL_ACT = 1;
cd (HOME_DIR);
focal_mech_calc;
% NODAL_ACT = 0;

%-------------------------------------------------------------------------
%     NODAL PLANE 2 (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_nodal2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_nodal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_nodal2
global INODAL NODAL_ACT HOME_DIR EQ_DATA
x = get(hObject,'Value');
% check1 = sum(EQ_DATA(:,10)) + sum(EQ_DATA(:,11)) + sum(EQ_DATA(:,12));
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if check2 == 0
    h = warndlg('No second set of focal mechanisms exist','!! Warning !!');
    waitfor(h);
    set(hObject,'Value',0.0);
    return
end

if x == 1
    INODAL = 2;
    set(findobj('Tag','radiobutton_nodal1'),'Value',0.0);
    set(findobj('Tag','radiobutton_shaffle'),'Value',0.0);
    set(findobj('Tag','radiobutton_maxplane'),'Value',0.0);
    set(findobj('Tag','radiobutton_minplane'),'Value',0.0);
	set(hObject,'Value',1.0);
end
NODAL_ACT = 1;
cd (HOME_DIR);
focal_mech_calc;
% NODAL_ACT = 0;

%-------------------------------------------------------------------------
%     SHUFFLE (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_shaffle_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_shaffle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_shaffle
global INODAL NODAL_ACT  HOME_DIR  EQ_DATA
x = get(hObject,'Value');
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if check2 == 0
    h = warndlg('No second set of focal mechanisms exist','!! Warning !!');
    waitfor(h);
    set(hObject,'Value',0.0);
    return
end
if x == 1
    INODAL = 3;
    set(findobj('Tag','radiobutton_nodal1'),'Value',0.0);
    set(findobj('Tag','radiobutton_nodal2'),'Value',0.0);
    set(findobj('Tag','radiobutton_maxplane'),'Value',0.0);
    set(findobj('Tag','radiobutton_minplane'),'Value',0.0);
	set(hObject,'Value',1.0);
end
NODAL_ACT = 1;
cd (HOME_DIR);
focal_mech_calc;
% NODAL_ACT = 0;

%-------------------------------------------------------------------------
%     MAX (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_maxplane_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_shaffle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_shaffle
global INODAL NODAL_ACT  HOME_DIR  EQ_DATA
x = get(hObject,'Value');
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if check2 == 0
    h = warndlg('No second set of focal mechanisms exist','!! Warning !!');
    waitfor(h);
    set(hObject,'Value',0.0);
    return
end
if x == 1
    INODAL = 4;
    set(findobj('Tag','radiobutton_nodal1'),'Value',0.0);
    set(findobj('Tag','radiobutton_nodal2'),'Value',0.0);
    set(findobj('Tag','radiobutton_shaffle'),'Value',0.0);
    set(findobj('Tag','radiobutton_minplane'),'Value',0.0);
	set(hObject,'Value',1.0);
end
NODAL_ACT = 1;
cd (HOME_DIR);
focal_mech_calc;
% NODAL_ACT = 0;

%-------------------------------------------------------------------------
%     MIN (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_minplane_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_shaffle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_shaffle
global INODAL NODAL_ACT  HOME_DIR  EQ_DATA
x = get(hObject,'Value');
check2 = sum(EQ_DATA(:,13)) + sum(EQ_DATA(:,14)) + sum(EQ_DATA(:,15));
if check2 == 0
    h = warndlg('No second set of focal mechanisms exist','!! Warning !!');
    waitfor(h);
    set(hObject,'Value',0.0);
    return
end
if x == 1
    INODAL = 5;
    set(findobj('Tag','radiobutton_nodal1'),'Value',0.0);
    set(findobj('Tag','radiobutton_nodal2'),'Value',0.0);
    set(findobj('Tag','radiobutton_shaffle'),'Value',0.0);
    set(findobj('Tag','radiobutton_maxplane'),'Value',0.0);
	set(hObject,'Value',1.0);
end
NODAL_ACT = 1;
cd (HOME_DIR);
focal_mech_calc;
% NODAL_ACT = 0;

%-------------------------------------------------------------------------
%     CLOSE (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_nodal_close_Callback(hObject, eventdata, handles)
close(figure(gcf));


