function varargout = strain_window(varargin)
% STRAIN_WINDOW M-file for strain_window.fig
%      STRAIN_WINDOW, by itself, creates a new STRAIN_WINDOW or raises the existing
%      singleton*.
%
%      H = STRAIN_WINDOW returns the handle to a new STRAIN_WINDOW or the handle to
%      the existing singleton*.
%
%      STRAIN_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STRAIN_WINDOW.M with the given input arguments.
%
%      STRAIN_WINDOW('Property','Value',...) creates a new STRAIN_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before strain_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to strain_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help strain_window

% Last Modified by GUIDE v2.5 03-Oct-2006 22:21:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @strain_window_OpeningFcn, ...
                   'gui_OutputFcn',  @strain_window_OutputFcn, ...
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


% --- Executes just before strain_window is made visible.
function strain_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to strain_window (see VARARGIN)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = findobj('Tag','strain_window');
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

% Choose default command line output for strain_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes strain_window wait for user response (see UIRESUME)
% uiwait(handles.strain_window);


% --- Outputs from this function are returned to the command line.
function varargout = strain_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%	  SXX (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_sxx_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 1;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  SYY (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_syy_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 2;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  SZZ (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_szz_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 3;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  SXY (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_sxy_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 6;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  SXZ (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_sxz_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 5;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  SYZ (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_syz_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 4;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  DILATATION (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_dilatation_map_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 7;
end
strain_view_button_Callback;
%-------------------------------------------------------------------------
%	  DILATATION SECTION (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_dilatation_section_Callback(hObject, eventdata, handles)
global STRAIN_SWITCH H_SEC_WINDOW
global ICOORD SECTION GRID
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DIP SEC_DOWNDIP_INC
global AV_DEPTH
x = get(hObject,'Value');
if x==1;
    STRAIN_SWITCH = 8;
end
% in case...
if isempty(SECTION) ~= 1
    SEC_XS = SECTION(1);
    SEC_YS = SECTION(2);
    SEC_XF = SECTION(3);
    SEC_YF = SECTION(4);
    SEC_INCRE = SECTION(5);
    SEC_DEPTH = SECTION(6);
    SEC_DEPTHINC = SECTION(7);
    SEC_DIP = 90.0;
    SEC_DOWNDIP_INC = SECTION(7);
else
    SEC_XS = GRID(1,1)+(GRID(3,1)-GRID(1,1))/4.0;
    SEC_YS = GRID(2,1)+(GRID(4,1)-GRID(2,1))/4.0;;
    SEC_XF = GRID(1,1)+3.0*(GRID(3,1)-GRID(1,1))/4.0;
    SEC_YF = GRID(2,1)+3.0*(GRID(4,1)-GRID(2,1))/4.0;
    SEC_INCRE = (GRID(5,1)+GRID(6,1))/5.0;
    SEC_DEPTH = AV_DEPTH * 4.0;
    SEC_DEPTHINC = (GRID(5,1)+GRID(6,1))/5.0;
    SEC_DIP = 90.0;
    SEC_DOWNDIP_INC = (GRID(5,1)+GRID(6,1))/5.0;
end
H_SEC_WINDOW = xsec_window;
set(findobj('Tag','text_section_dip'),'Visible','off');
set(findobj('Tag','edit_section_dip'),'Visible','off');
set(findobj('Tag','text_section_dip_deg'),'Visible','off');
set(findobj('Tag','text_downdip_inc'),'Visible','off');
set(findobj('Tag','edit_downdip_inc'),'Visible','off');
set(findobj('Tag','text_downdip_inc_km'),'Visible','off');

%-------------------------------------------------------------------------
%       COLOR SATURATION SLIDER (slider)
%-------------------------------------------------------------------------
function strain_slider_Callback(hObject, eventdata, handles)
% set (handles.edit_coul_sat,'String',num2str(get(hObject,'Value'),2));
global COLORSN
h = get(hObject,'Value');
set (handles.edit_strain_color_sat,'String',num2str(get(hObject,'Value'),2));
% h = findobj('Tag','main_menu_window');
% if isempty(h) ~= 1
%    COLORSN = get(hObject,'Value');
%    coulomb_view(COLORSN);
%    set(handles.strain_color_sat,'String',num2str(h,'%4.1f'));
    strain_view_button_Callback;
% end

function strain_slider_CreateFcn(hObject, eventdata, handles)
%global COLORSN
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%set(hObject,'Value',-COLORSN);

%-------------------------------------------------------------------------
%       COLOR SATURATION TEXTFIELD (textfield)
%-------------------------------------------------------------------------
function strain_color_sat_Callback(hObject, eventdata, handles)
global COLORSN
% h = findobj('Tag','main_menu_window');
% if isempty(h) ~= 1
    h = str2num(get(hObject,'String'));
    if h >= 0.0
        warndlg('Put negative integer','!!Warning!!');
    end
    hmax = get(findobj('Tag','strain_slider'),'Max');
    hmin = get(findobj('Tag','strain_slider'),'Min');
    if h > hmax
        h = hmax;
        set(handles.strain_slider,'Value',hmax); 
        set(hObject,'String',num2str(h,'%4.1f'));
    elseif h <= hmin
        h = hmin;
        set(handles.strain_slider,'Value',hmin);
        set(hObject,'String',num2str(h,'%4.1f'));
    else
        set(handles.strain_slider,'Value',h); 
        set(hObject,'String',num2str(h,'%4.1f'));
    end
        strain_view_button_Callback;
%     COLORSN = h;
%     coulomb_view(COLORSN);
%    set(handles.slider_coul_sat,'Value',str2num(get(hObject,'String')
% end

function strain_color_sat_CreateFcn(hObject, eventdata, handles)
%global COLORSN
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%----------------------------------
function edit_strain_color_sat_Callback(hObject, eventdata, handles)
global COLORSN
    h = str2num(get(hObject,'String'));
    if h >= 0.0
        warndlg('Put negative integer','!!Warning!!');
    end
    hmax = get(findobj('Tag','strain_slider'),'Max');
    hmin = get(findobj('Tag','strain_slider'),'Min');
    if h > hmax
        h = hmax;
        set(handles.strain_slider,'Value',hmax); 
        set(hObject,'String',num2str(h,'%4.1f'));
    elseif h <= hmin
        h = hmin;
        set(handles.strain_slider,'Value',hmin);
        set(hObject,'String',num2str(h,'%4.1f'));
    else
        set(handles.strain_slider,'Value',h); 
        set(hObject,'String',num2str(h,'%4.1f'));
    end
        strain_view_button_Callback;

% --- Executes during object creation, after setting all properties.
function edit_strain_color_sat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%       CLEAR (button)
%-------------------------------------------------------------------------
function strain_close_button_Callback(hObject, eventdata, handles)
h = figure(gcf);
delete(h);

%-------------------------------------------------------------------------
%       CONTOUR CHECKBOX (checkbox)
%-------------------------------------------------------------------------
% --- Executes on button press in contour_checkbox.
function contour_checkbox_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
if x == 1
    warndlg('This takes much time, in particular finer interval. Be patient. Otherwise, check it off.');
end

%-------------------------------------------------------------------------
%       STRAIN CONTOUR (textfield)
%-------------------------------------------------------------------------
% strain_window('edit_strain_cont_interval_CreateFcn',gcbo,[],guidata(gcbo)
function edit_strain_cont_interval_Callback(hObject, eventdata, handles)
global CONT_INTERVAL
h = str2double(get(hObject,'String'));
if h < 0.01
    set(hObject,'String',num2str(0.01,'%4.2f'));    
else
    set(hObject,'String',num2str(h,'%4.2f'));
end
CONT_INTERVAL = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_strain_cont_interval_CreateFcn(hObject, eventdata, handles)
global CONT_INTERVAL CC XGRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if isempty(CONT_INTERVAL)
    CONT_INTERVAL = 0.2;
end
    set(hObject,'String',num2str(0.5,'%4.2f'));

%-------------------------------------------------------------------------
%       Mosaic (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_strain_mosaic_Callback(hObject, eventdata, handles)
global SHADE_TYPE
x = get(hObject,'Value');
if x == 1
    SHADE_TYPE = 1;
end
set(findobj('Tag','radiobutton_strain_interp'),'Value',0);
strain_view_button_Callback;
%-------------------------------------------------------------------------
%       Interpolation (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_strain_interp_Callback(hObject, eventdata, handles)
global SHADE_TYPE
x = get(hObject,'Value');
if x == 1
    SHADE_TYPE = 2;
end
set(findobj('Tag','radiobutton_strain_mosaic'),'Value',0);
strain_view_button_Callback;

%-------------------------------------------------------------------------
%       CALC. & VIEW (button)
%-------------------------------------------------------------------------
function strain_view_button_Callback(hObject, eventdata, handles)
global DC3D CALC_DEPTH SHEAR NORMAL R_STRESS
global IACT
global STRESS_TYPE
global STRIKE DIP RAKE
global COLORSN %color saturation value
global H_SECTION H_SEC_WINDOW
global FLAG_SLIP_LINE
global XYCOORD
global GRID
global XMIN XMAX XINC NXINC YMIN YMAX YINC NYINC
global CC ss
global STRAIN_SWITCH
global COAST_DATA EQ_DATA AFAULT_DATA
global OUTFLAG PREF_DIR HOME_DIR INPUT_FILE

if IACT == 0
    Okada_halfspace;
    IACT = 1;
end
a = length(DC3D);
if a < 14
    h = warndlg('Increase total grid number more than 14.','Warning!');
end
ss = zeros(7,a);
s9 = reshape(DC3D(:,9),1,a);        % SXX (strain)
s10 = reshape(DC3D(:,10),1,a);      % SYY
s11 = reshape(DC3D(:,11),1,a);      % SZZ
s12 = reshape(DC3D(:,12),1,a);      % SYZ
s13 = reshape(DC3D(:,13),1,a);      % SXZ
s14 = reshape(DC3D(:,14),1,a);      % SXY
dil = s9 + s10 + s11;               % Dilatation
ss = [s9; s10; s11; s12; s13; s14; dil];
    a0 = DC3D(:,1:2);
    a1 = zeros(length(a0),1)+CALC_DEPTH;
    b0 = DC3D(:,9:14);
    c0 = DC3D(:,9)+DC3D(:,10)+DC3D(:,11);
    d0 = horzcat(a0,a1,b0,c0);
    
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files;
    else
	cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z exx eyy ezz eyz exz exy dilatation';
    header3 = '(km) (km) (km) (-) (-) (-) (-) (-) (-) (-)';
    dlmwrite('Strain.cou',header1,'delimiter',''); 
    dlmwrite('Strain.cou',header2,'-append','delimiter',''); 
    dlmwrite('Strain.cou',header3,'-append','delimiter',''); 
    dlmwrite('Strain.cou',d0,'-append','delimiter','\t','precision','%.12f');
    disp(['Strain.cou is saved in ' pwd]);
    cd (HOME_DIR);

xmin = XMIN; ymin = YMIN;
xmax = XMAX; ymax = YMAX;
xinc = XINC; yinc = YINC;
nxinc = NXINC; nyinc = NYINC;
CC = zeros(NYINC,NXINC);
% dd = zeros(NYINC,NXINC);
switch (STRAIN_SWITCH)
    case 1          % SXX
        n = 1;
    case 2          % SYY
        n = 2;
    case 3          % SZZ
        n = 3;
    case 4          % SYZ
        n = 4;
    case 5          % SXZ
        n = 5;
    case 6          % SXY
        n = 6;
    case 7          % Dilatation
        n = 7;
    case 8          % Dilatation
        n = 7;
    otherwise       % cross section
        warndlg('under construction','!! Warning !!');
end
CC = reshape(ss(n,:),NYINC,NXINC);
CC = CC(NYINC:-1:1,:);
cmax = max(reshape(max(abs(CC)),NXINC,1));
cmin = min(reshape(min(abs(CC)),NXINC,1));
cmean = mean(reshape(mean(abs(CC)),NXINC,1));
COLORSN = log10(cmean);
if isnan(COLORSN) == 1
    h = errordlg('A calculation point hits a singular point. Shift the grid slightly.',...
        '!!Warning!!');
    return;
end
ch1 = get(findobj('Tag','strain_slider'),'Value');
ch2 = str2num(get(findobj('Tag','edit_strain_color_sat'),'String'));
if ch1 ~= COLORSN
    COLORSN = ch1;
elseif ch2 ~= COLORSN
    COLORSN = ch2;
end
set(findobj('Tag','strain_slider'),'Max',log10(cmax));
set(findobj('Tag','strain_slider'),'Min',log10(cmin));
set(findobj('Tag','strain_slider'),'Value',COLORSN);
set(findobj('Tag','edit_strain_color_sat'),'String',num2str(COLORSN,'%4.1f'));

% To make an image using "cc", sharing it with coulomb functions
coulomb_view(COLORSN);
fault_overlay;
% ----- overlay drawing --------------------------------
if isempty(COAST_DATA) ~= 1 | isempty(EQ_DATA) ~= 1 | isempty(AFAULT_DATA) ~= 1
        hold on;
        overlay_drawing;
end
