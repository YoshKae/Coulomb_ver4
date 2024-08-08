function varargout = ec_control_window(varargin)
% EC_CONTROL_WINDOW M-file for ec_control_window.fig
%      EC_CONTROL_WINDOW, by itself, creates a new EC_CONTROL_WINDOW or raises the existing
%      singleton*.
%
%      H = EC_CONTROL_WINDOW returns the handle to a new EC_CONTROL_WINDOW or the handle to
%      the existing singleton*.
%
%      EC_CONTROL_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EC_CONTROL_WINDOW.M with the given input arguments.
%
%      EC_CONTROL_WINDOW('Property','Value',...) creates a new EC_CONTROL_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ec_control_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ec_control_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ec_control_window

% Last Modified by GUIDE v2.5 26-Jul-2006 08:58:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ec_control_window_OpeningFcn, ...
                   'gui_OutputFcn',  @ec_control_window_OutputFcn, ...
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


% --- Executes just before ec_control_window is made visible.
function ec_control_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global EC_STRESS_TYPE
h = findobj('Tag','ec_control_window');
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
% default
EC_STRESS_TYPE = 1;
% Choose default command line output for ec_control_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ec_control_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ec_control_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     COULOMB RIGHT-LAT (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_right_lat_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
    EC_STRESS_TYPE = 1;
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
end
% hObject    handle to radiobutton_coul_right_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_coul_right_lat


%-------------------------------------------------------------------------
%     COULOMB REVERSE (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_rev_slip_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
    EC_STRESS_TYPE = 2;
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COULOMB SPECIFIED RAKE (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_spec_rake_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
	EC_STRESS_TYPE = 3;
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COULOMB INDIVIDUAL RAKE (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_ind_rake_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
	EC_STRESS_TYPE = 4;
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COULOMB SPECIFIED RAKE ASSIGNMENT (textfield)   
%-------------------------------------------------------------------------
function edit_coul_spec_rake_Callback(hObject, eventdata, handles)
global EC_RAKE
EC_RAKE = str2num(get(hObject,'String'));
if EC_RAKE > 180.0 | EC_RAKE < -180.0
    h = warndlg('Put the number in a range of -180 to 180.','!! Warning !!');
    waitfor(h);
end
set(hObject,'String',num2str(EC_RAKE,'%6.1f'));

function edit_coul_spec_rake_CreateFcn(hObject, eventdata, handles)
global EC_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if isempty(EC_RAKE) == 1
    EC_RAKE = 135.0;
end
set(hObject,'String',num2str(EC_RAKE,'%6.1f'));

%-------------------------------------------------------------------------
%     COEFF FRICTION (textfield) 
%-------------------------------------------------------------------------
function edit_ec_friction_Callback(hObject, eventdata, handles)
global FRIC
FRIC = str2num(get(hObject,'String'));
if FRIC > 1.0 | FRIC < 0.0
    h = warndlg('Put the number in a range of 0 to 1.','!! Warning !!');
    waitfor(h);
end
set(hObject,'String',num2str(FRIC,'%4.2f'));

function edit_ec_friction_CreateFcn(hObject, eventdata, handles)
global FRIC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(FRIC,'%4.2f'));

%-------------------------------------------------------------------------
%     NORMAL STRESS CHANGE (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_normal_stress_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
    EC_STRESS_TYPE = 5;
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COLOR SATURATION LIMITS (textfield) 
%-------------------------------------------------------------------------
function edit_color_bar_sat_Callback(hObject, eventdata, handles)
global C_SAT
C_SAT = str2num(get(hObject,'String'));
if C_SAT >= 100.0 | C_SAT <= 0.0
    h = warndlg('Put the positive number in a range of 0.01 to 99.99','!! Warning !!');
    waitfor(h);
end
set(hObject,'String',num2str(C_SAT,'%5.2f'));

function edit_color_bar_sat_CreateFcn(hObject, eventdata, handles)
global C_SAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(C_SAT,'%5.2f'));

%-------------------------------------------------------------------------
%     CALC & VIEW (pushbutton) 
%-------------------------------------------------------------------------
function pushbutton_ec_calc_view_Callback(hObject, eventdata, handles)
global ELEMENT POIS YOUNG FRIC ID
global FUNC_SWITCH
global DC3D IACT
global H_MAIN H_EC_CONTROL
global IMAXSHEAR
% subfig_clear;
% clear_obj_and_subfig;
hc = wait_calc_window;   % custom waiting dialog
ch = get(H_MAIN,'Children');
% n = length(ch) - 3;
% if n >= 1
%     for k = 1:n
%     delete(ch(k));
%     end
%     set(H_MAIN,'Menubar','figure','Toolbar','none');
% end
FUNC_SWITCH = 10;

tic
element_condition(ELEMENT,POIS,YOUNG,FRIC,ID);
t1 = toc;
disp([' Elapsed time for element stress calculation = ' num2str(t1,'%10.1f') ' sec.']);
if IMAXSHEAR ~= 3
    tic
    grid_drawing_3d;
    displ_open(2);
    t2 = toc;
    disp([' Elapsed time for 3D graphic rendering = ' num2str(t2,'%10.1f') ' sec.']);
else
    warndlg('Numerical output only','!! Warning !!')
end

close(hc)

% h = findobj('Tag','ec_control_window');
% if (isempty(h)==1 && isempty(H_EC_CONTROL)==1)
%     H_EC_CONTROL = ec_control_window;
% end
% h_grid = figure(gcf);

%-------------------------------------------------------------------------
%     CLOSE (pushbutton) 
%-------------------------------------------------------------------------
function pushbutton_ec_close_Callback(hObject, eventdata, handles)
h = figure(gcf);
delete(h);

