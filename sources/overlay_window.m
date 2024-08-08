function varargout = overlay_window(varargin)
% OVERLAY_WINDOW M-file for overlay_window.fig
%      OVERLAY_WINDOW, by itself, creates a new OVERLAY_WINDOW or raises the existing
%      singleton*.
%
%      H = OVERLAY_WINDOW returns the handle to a new OVERLAY_WINDOW or the handle to
%      the existing singleton*.
%
%      OVERLAY_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OVERLAY_WINDOW.M with the given input arguments.
%
%      OVERLAY_WINDOW('Property','Value',...) creates a new OVERLAY_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before overlay_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to overlay_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help overlay_window

% Last Modified by GUIDE v2.5 25-Mar-2005 16:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @overlay_window_OpeningFcn, ...
                   'gui_OutputFcn',  @overlay_window_OutputFcn, ...
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


% --- Executes just before overlay_window is made visible.
function overlay_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to overlay_window (see VARARGIN)

% Choose default command line output for overlay_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes overlay_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = overlay_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%------------------------------------------------------------------------
%----- RADIOBUTTON SELECTION --------------------------------------------
function uipanel6_SelectionChangeFcn(hObject,eventdata,handles)
global STRESS_TYPE
selection = get(hObject,'SelectedObject')
switch get(selection,'Tag')
    case 'radiobutton_optfault'
        STRESS_TYPE = 1;
    case 'radiobutton_optss'
        STRESS_TYPE = 2;
    case 'radiobutton_optth'
        STRESS_TYPE = 3;
    case 'radiobutton_optno'
        STRESS_TYPE = 4;
    case 'radiobutton_specified'
        STRESS_TYPE = 5;
end

function radiobutton_optfault_Callback(hObject, eventdata, handles)
global STRESS_TYPE
x = get(hObject,'Value');
if x==1;
    STRESS_TYPE = 1;
end

function radiobutton_optss_Callback(hObject, eventdata, handles)
global STRESS_TYPE
x = get(hObject,'Value');
if x==1;
    STRESS_TYPE = 2;
end

function radiobutton_optth_Callback(hObject, eventdata, handles)
global STRESS_TYPE
x = get(hObject,'Value');
if x==1;
    STRESS_TYPE = 3;
end

function radiobutton_optno_Callback(hObject, eventdata, handles)
global STRESS_TYPE
x = get(hObject,'Value');
if x==1;
    STRESS_TYPE = 4;
end

function radiobutton_specified_Callback(hObject, eventdata, handles)
global STRESS_TYPE
x = get(hObject,'Value');
if x==1;
    STRESS_TYPE = 5;
end

%------------------------------------------------------------------------


%========================================================================
%===== CALC & VIEW ======================================================
function pushbutton_coul_calc_Callback(hObject, eventdata, handles)
% 
global DC3D CALC_DEPTH SHEAR NORMAL R_STRESS
global IACT
global STRESS_TYPE

friction = str2num(get(findobj('Tag','edit_coul_fric'),'String'));
CALC_DEPTH =  str2num(get(findobj('Tag','edit_coul_depth'),'String'));
if friction == 0.0
    friction = 0.00001;
end
beta = 0.5 * (atan(1.0/friction));

if IACT == 0
    Okada_halfspace;
end
a = length(DC3D);
if a < 14
    h = warndlg('Increase total grid number more than 14.','Warning!');
end
ss = zeros(6,a);
% rot90 useful?????
s9 = reshape(DC3D(:,9),1,a);
s10 = reshape(DC3D(:,10),1,a);
s11 = reshape(DC3D(:,11),1,a);
s12 = reshape(DC3D(:,12),1,a);
s13 = reshape(DC3D(:,13),1,a);
s14 = reshape(DC3D(:,14),1,a);
ss = [s9; s10; s11; s12; s13; s14];

switch STRESS_TYPE
%  --------------------- for specified faults calc...
    case 5
    strike = str2num(get(findobj('Tag','edit_spec_strike'),'String'));
    dip = str2num(get(findobj('Tag','edit_spec_dip'),'String'));
    rake = str2num(get(findobj('Tag','edit_spec_rake'),'String'));

%  --------------------- for optimally oriented strike slip fault calc...
    case 2
    [rs] = regional_stress(R_STRESS,CALC_DEPTH);
    
    sgx = zeros(a,1) + rs(1,1) + reshape(ss(1,1:a),a,1);
    sgy = zeros(a,1) + rs(2,1) + reshape(ss(2,1:a),a,1);
    sgz = zeros(a,1) + rs(3,1) + reshape(ss(3,1:a),a,1);
    sgyz = zeros(a,1) + rs(4,1) + reshape(ss(4,1:a),a,1);
    sgxz = zeros(a,1) + rs(5,1) + reshape(ss(5,1:a),a,1);
    sgxy = zeros(a,1) + rs(6,1) + reshape(ss(6,1:a),a,1);
    phi = zeros(a,1) + 0.5 * atan((2.0 * sgxy)./(sgx - sgy)) + pi/2.0;
    % PHI = 0.5*ATAN((2.0*SGXY)/(SGX-SGY))+PI/2
        ct = zeros(a,1) + cos(phi);
        st = zeros(a,1) + cos(phi);
    erad1 = sgx.*ct.*ct+sgy.*st+2.0.*sgx.*ct.*st;
        ct = zeros(a,1) + cos(phi+pi/2.0);
        st = zeros(a,1) + cos(phi+pi/2.0);
    erad2 = sgx.*ct.*ct+sgy.*st+2.0.*sgx.*ct.*st;
% how can we compare each value in two matrices ????????????????????
    if erad2 >= erad1
		phi = phi + pi/2.0;
    end
% ???????????????????????????????????? pending ?????????????????????
    strike = zeros(a,1) + rad2deg(phi) - rad2deg(beta);
    dip = 90.0;
    rake = 180.0;
    otherwise
    d = warndlg('Sorry that this function is under construction','Warning!');
end
%  -------------------------------------


if IACT == 2         % escape if only friction is changed
    tic
    coulomb = zeros(a,1);
    c4 = zeros(a,1) + friction;
    coulomb = SHEAR + c4 .* NORMAL;
    b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL];
    format long;
    dlmwrite('dcff.cou',b,'delimiter','\t','precision','%.6f');  
    toc
else
    tic
    SHEAR = zeros(a,1);
    NORMAL = zeros(a,1);
    coulomb = zeros(a,1);
    hh = waitbar(0,'Calculating coulomb stress... Please be patient...');
%     for k=1:a
    c1 = zeros(a,1) + strike;
    c2 = zeros(a,1) + dip;
    c3 = zeros(a,1) + rake;
    c4 = zeros(a,1) + friction;
    [SHEAR,NORMAL,coulomb] = calc_coulomb(c1,c2,c3,c4,ss);
    b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL];
    format long;
        dlmwrite('dcff.cou',b,'delimiter','\t','precision','%.6f');  
    close(hh);
    toc
end
coulomb_open(5);
%========================================================================




%%%%% PUSH BUTTON 2 (CALLBACK) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton2_Callback(hObject, eventdata, handles)
% 
input_open(1);

%========================================================================
%===== COLOR SATURATION SLIDER ==========================================
%==  (CALLBACK) ===========================
function slider_coul_sat_Callback(hObject, eventdata, handles)
% 
global ha1 ha2 % handle of figure
global a1
set (handles.edit_coul_sat,'String',num2str(get(hObject,'Value'),2));
[flag,h]=figflag('main_menu_window');
if flag == 1
%if ha2~=0
    coulomb_view(get(hObject,'Value'));
%end
%if a1~=0
%    displ_open(get(hObject,'Value'));
%end    
end  


%===  (CREATER) =============
function slider_coul_sat_CreateFcn(hObject, eventdata, handles)
% 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%===== COLOR SATURATION EDIT ===========================================
%==  (CALLBACK) =============================
function edit_coul_sat_Callback(hObject, eventdata, handles)
% 
global ha1 a1
set (handles.slider_coul_sat,'Value',str2double(get(hObject,'String')));
if ha2~=0
    coulomb_view(str2double(get(hObject,'String')));
end
if a1~=0
    displ_open(str2double(get(hObject,'String')));
end

%===  (CREATER) =============
function edit_coul_sat_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%========================================================================



%=========================================================================
%=========================================================================
%%%%% EDIT MIN LON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_min_lon_Callback(hObject, eventdata, handles)
% 
global minlon maxlon minlat maxlat
minlon = str2double(get(hObject,'String'));
if minlon >= maxlon
    h = warndlg('This should be smaller than max lon.','Warning');
end

%%  (CREATER) %%%%%%%%%% 
function edit_min_lon_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%% EDIT MAX LON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_max_lon_Callback(hObject, eventdata, handles)
% 
global minlon maxlon minlat maxlat
maxlon = str2double(get(hObject,'String'));
if maxlon <= minlon
    h = warndlg('This should be larger than min lon.','Warning');
end

%%  (CREATER) %%%%%%%%%% 
function edit_max_lon_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%% EDIT MIN LAT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_min_lat_Callback(hObject, eventdata, handles)
% 
global minlon maxlon minlat maxlat
minlat = str2double(get(hObject,'String'));
if minlat >= maxlat
    h = warndlg('This should be smaller than max lat.','Warning');
end

%%  (CREATER) %%%%%%%%%% 
function edit_min_lat_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%% EDIT MAX LAT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_max_lat_Callback(hObject, eventdata, handles)
% 
global minlon maxlon minlat maxlat
maxlat = str2double(get(hObject,'String'));
if maxlat <= minlat
    h = warndlg('This should be larger than min lat.','Warning');
end

%%  (CREATER) %%%%%%%%%% 
function edit_max_lat_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%=========================================================================
%=========================================================================


function uipanel5_SelectionChangeFcn(hObject,eventdata,handles)
global COORD
selection = get(hObject,'SelectedObject')
switch get(selection,'Tag')
    case 'radiobutton_cartesian'
        %radiobutton_cartesian_Callback;
        COORD = 1; % cartesian coordinate
    case 'radiobutton_lonlat'
        %radiobutton_lonlat_Callback;
        COORD = 2; % lon/lat coordinate
end



function radiobutton_cartesian_Callback(hObject, eventdata, handles)
global COORD
x = get(hObject,'Value');
if x==1;
    COORD = 1;
end

function radiobutton_lonlat_Callback(hObject, eventdata, handles)
global COORD
x = get(hObject,'Value');
if x==1;
    COORD = 2;
end


%=========================================================================
%===== DISPL OVERLAY BUTTON =============================================
function pushbutton_displ_Callback(hObject, eventdata, handles)
% 
displ_open(2);


%=========================================================================
%===== CLEAR BUTTON =====================================================
function pushbutton_clear_Callback(hObject, eventdata, handles)
% 
global ha2
global IACT
IACT = 0;
[flag,h] = figflag('main_menu_window');
if flag == 1
    delete(figure(h));
end


%=========================================================================
%===== FAULT OVERLAY BUTTON =============================================
function pushbutton_fault_Callback(hObject, eventdata, handles)
% 
fault_overlay;


%=========================================================================
%===== COASTLINE OVERLAY BUTTON ==========================================
%%  (CALLBACK) %%%%%%%%%% 
function pushbutton_coastline_Callback(hObject, eventdata, handles)
% 
global COORD
if COORD == 2
    coastline_drawing;
end


%=========================================================================
function pushbutton_surface_Callback(hObject, eventdata, handles)
% 
global dispsurf_flag
dispsurf_flag = 1;
displ_open;
dispsurf_flag = 0;


function Untitled_1_Callback(hObject, eventdata, handles)
%



%%%%% SPEC STRIKE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_spec_strike_Callback(hObject, eventdata, handles)
% 
global IACT
IACT = 1;   % do not have to calculate deformation again
strike = str2num(get(hObject,'String'));
set(hObject,'String',num2str(strike,'%6.2f'));

%%  (CREATE) %%%%%%%%%% 
function edit_spec_strike_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%% SPEC DIP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_spec_dip_Callback(hObject, eventdata, handles)
% 
global IACT
IACT = 1;   % do not have to calculate deformation again
dip = str2num(get(hObject,'String'));
set(hObject,'String',num2str(dip,'%6.2f'));

%%  (CREATE) %%%%%%%%%% 
function edit_spec_dip_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%% SPEC RAKE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  (CALLBACK) %%%%%%%%%% 
function edit_spec_rake_Callback(hObject, eventdata, handles)
% 
global IACT
IACT = 1;   % do not have to calculate deformation again
rake = str2num(get(hObject,'String'));
set(hObject,'String',num2str(rake,'%6.2f'));

%%  (CREATE) %%%%%%%%%% 
function edit_spec_rake_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%=======================================================================
%===== CALC DEPTH ======================================================
%%  (CALLBACK) %%%%%%%%%% 
function edit_coul_depth_Callback(hObject, eventdata, handles)
% 
global IACT
IACT = 0;
depth = str2num(get(hObject,'String'));
set(hObject,'String',num2str(depth,'%6.2f'));

%%  (CREATE) %%%%%%%%%% 
function edit_coul_depth_CreateFcn(hObject, eventdata, handles)
% 
global CALC_DEPTH
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
depth = CALC_DEPTH;
set(hObject,'String',num2str(depth,'%6.2f'));


%=======================================================================
%===== FRICTION ========================================================
%%  (CALLBACK) %%%%%%%%%% 
function edit_coul_fric_Callback(hObject, eventdata, handles)
% 
global IACT
IACT = 2;   % do not have to calculate deformation again
friction = str2num(get(hObject,'String'));
set(hObject,'String',num2str(friction,'%4.2f'));

%%  (CREATE) %%%%%%%%%% 
function edit_coul_fric_CreateFcn(hObject, eventdata, handles)
% 
global FRIC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
friction = FRIC;
set(hObject,'String',num2str(friction,'%4.2f'));


% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


