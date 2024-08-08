function varargout = coulomb_window(varargin)
% Start initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @coulomb_window_OpeningFcn, ...
                   'gui_OutputFcn',  @coulomb_window_OutputFcn, ...
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
% h = @pushbutton_coul_calc_Callback;

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Opening Function
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function coulomb_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global SHADE_TYPE
receivers_matrix_off;
    h = findobj('Tag','coulomb_window');
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
    SHADE_TYPE = 1;         % default
% Choose default command line output for coulomb_window
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Output Function
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function varargout = coulomb_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%------------------------------------------------------------------------
%----- RADIOBUTTON SELECTION --------------------------------------------
function uipanel_receiver_SelectionChangeFcn(hObject,eventdata,handles)
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
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 1;
end

function radiobutton_optss_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 2;
end

function radiobutton_optth_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 3;
end

function radiobutton_optno_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 4;
end

function radiobutton_specified_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 5;
end

%--------------------------------------------------------------------------
%----- RADIOBUTTON SELECTION 2 --------------------------------------------
function image_shading_SelectionChangeFcn(hObject,eventdata,handles)
global SHADE_TYPE
selection = get(hObject,'SelectedObject')
switch get(selection,'Tag')
    case 'mozaic_radiobutton'
        SHADE_TYPE = 1
    case 'interpolating_radiobutton'
        SHADE_TYPE = 2
end
%-------------------------------------------------------------------------
%                    MOZAIC image 
%-------------------------------------------------------------------------
function mozaic_radiobutton_Callback(hObject, eventdata, handles)
global SHADE_TYPE
x = get(hObject,'Value');
if x==1
    SHADE_TYPE = 1;
    pushbutton_coul_calc_Callback;
end
%-------------------------------------------------------------------------
%                   INTERPOLATED image 
%-------------------------------------------------------------------------
function interpolating_radiobutton_Callback(hObject, eventdata, handles)
global SHADE_TYPE
x = get(hObject,'Value');
if x==1
    SHADE_TYPE = 2;
    pushbutton_coul_calc_Callback;
end

%-------------------------------------------------------------------------
%     PUSHBUTTON2 (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles) 
input_open(1);

%-------------------------------------------------------------------------
%     COLOR SATURATION SLIDER (slider)  
%-------------------------------------------------------------------------
function slider_coul_sat_Callback(hObject, eventdata, handles) 
global COLORSN
set (handles.edit_coul_sat,'String',num2str(get(hObject,'Value'),2));
    COLORSN = get(hObject,'Value');
    pushbutton_coul_calc_Callback;
%-----------
function slider_coul_sat_CreateFcn(hObject, eventdata, handles) 
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%-------------------------------------------------------------------------
%     Color saturation edit (textfield)  
%-------------------------------------------------------------------------
function edit_coul_sat_Callback(hObject, eventdata, handles)
global COLORSN
    h = str2double(get(hObject,'String'));
    hmax = get(findobj('Tag','slider_coul_sat'),'Max');
    hmin = get(findobj('Tag','slider_coul_sat'),'Min');
    if h > hmax
        set(handles.slider_coul_sat,'Value',hmax);        
    elseif h <= hmin
        set(handles.slider_coul_sat,'Value',hmin);
        h = hmin + 0.000001
    else
        set(handles.slider_coul_sat,'Value',h);                
    end
    COLORSN = h;
    pushbutton_coul_calc_Callback;
%-----------
function edit_coul_sat_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%       Contour (checkbox)
%-------------------------------------------------------------------------
function checkbox_coulomb_contour_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
if x == 1
    warndlg('This takes much time, in particular finer interval. Be patient. Otherwise, check it off.');
end

%-------------------------------------------------------------------------
%     Contour interval edit (textfield)  
%-------------------------------------------------------------------------
function edit_stress_cont_interval_Callback(hObject, eventdata, handles)
global CONT_INTERVAL
h = str2double(get(hObject,'String'));
if h > 0.1
    CONT_INTERVAL = h;
else
    CONT_INTERVAL = 0.1;
end
set(hObject,'String',num2str(CONT_INTERVAL,'%3.1f'));

%-----------
function edit_stress_cont_interval_CreateFcn(hObject, eventdata, handles)
global CONT_INTERVAL
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CONT_INTERVAL = 1.0; % default value
set(hObject,'String',num2str(CONT_INTERVAL,'%3.1f'));

%-------------------------------------------------------------------------
%       Close button (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_close_Callback(hObject, eventdata, handles)
% 
global IACT
IACT = 0;
h = figure(gcf);
delete(h);

%-------------------------------------------------------------------------
%       Specified fault -- strike -- (textfield)
%-------------------------------------------------------------------------
function edit_spec_strike_Callback(hObject, eventdata, handles)
receivers_matrix_off;
strike = str2num(get(hObject,'String'));
set(hObject,'String',num2str(strike,'%6.1f'));
check_coul_input;
dummy = findobj('Tag','slider_strike');
if ~isempty(dummy)
    set(dummy,'Value',strike);
end

%-----------
function edit_spec_strike_CreateFcn(hObject, eventdata, handles)
global AV_STRIKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(AV_STRIKE,'%6.0f'));

%-------------------------------------------------------------------------
%       Specified fault -- dip -- (textfield)
%-------------------------------------------------------------------------
function edit_spec_dip_Callback(hObject, eventdata, handles)
receivers_matrix_off;
dip = str2num(get(hObject,'String'));
set(hObject,'String',num2str(dip,'%6.1f'));
check_coul_input;
dummy = findobj('Tag','slider_dip');
if ~isempty(dummy)
    set(dummy,'Value',dip);
end

%----------- 
function edit_spec_dip_CreateFcn(hObject, eventdata, handles)
global AV_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(AV_DIP,'%6.0f'));

%-------------------------------------------------------------------------
%       Specified fault -- rake -- (textfield)
%-------------------------------------------------------------------------
function edit_spec_rake_Callback(hObject, eventdata, handles)
receivers_matrix_off;
rake = str2num(get(hObject,'String'));
set(hObject,'String',num2str(rake,'%6.1f'));
check_coul_input;
dummy = findobj('Tag','slider_rake');
if ~isempty(dummy)
    set(dummy,'Value',rake);
end

%-----------  
function edit_spec_rake_CreateFcn(hObject, eventdata, handles)
global AV_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(AV_RAKE,'%6.0f'));

%-------------------------------------------------------------------------
%       Open sliders to control specified slip (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_open_spec_sliders_Callback(hObject, eventdata, handles)
global H_SPECIFIED_SLIDER
dummy = findobj('Tag','figure_specified_slider');
if isempty(dummy)==1
    H_SPECIFIED_SLIDER = specified_slider_window;
else
    figure(H_SPECIFIED_SLIDER);
end


%-------------------------------------------------------------------------
%       Calc. depth (textfield)
%-------------------------------------------------------------------------
function edit_coul_depth_Callback(hObject, eventdata, handles)
% 
global IACT DEPTH_RANGE_TYPE
IACT = 0;
DEPTH_RANGE_TYPE = 0;
depth = str2num(get(hObject,'String'));
set(hObject,'String',num2str(depth,'%6.1f'));
check_coul_input;

%-----------  
function edit_coul_depth_CreateFcn(hObject, eventdata, handles)
% 
global CALC_DEPTH
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
depth = CALC_DEPTH;
set(hObject,'String',num2str(depth,'%6.1f'));

%-------------------------------------------------------------------------
%     Depth range (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_depth_range_Callback(hObject, eventdata, handles)
global IACT H_DEPTH DEPTH_RANGE_TYPE
IACT = 0;
DEPTH_RANGE_TYPE = 1;
H_DEPTH = depth_range_window;

%-------------------------------------------------------------------------
%     Coeff. of friction (textfield)  
%-------------------------------------------------------------------------
function edit_coul_fric_Callback(hObject, eventdata, handles)
global IACT FRIC
% IACT = 2;   % do not have to calculate deformation again
IACT = 1;   % do not have to calculate deformation again
friction = str2double(get(hObject,'String'));
set(hObject,'String',num2str(friction,'%4.2f'));
check_coul_input;
FRIC = str2double(get(hObject,'String'));
dummy = findobj('Tag','slider_friction');
if ~isempty(dummy)
    set(dummy,'Value',FRIC);
end

%----------- 
function edit_coul_fric_CreateFcn(hObject, eventdata, handles)
% 
global FRIC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
friction = FRIC;
set(hObject,'String',num2str(friction,'%4.2f'));

%-------------------------------------------------------------------------
%     Cross section button (????)  -- Cross section control window --
%-------------------------------------------------------------------------
function crosssection_toggle_Callback(hObject, eventdata, handles)
global H_SEC_WINDOW
global ICOORD SECTION GRID
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DIP SEC_DOWNDIP_INC
global AV_DEPTH
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
    SEC_YS = GRID(2,1)+(GRID(4,1)-GRID(2,1))/4.0;
    SEC_XF = GRID(1,1)+3.0*(GRID(3,1)-GRID(1,1))/4.0;
    SEC_YF = GRID(2,1)+3.0*(GRID(4,1)-GRID(2,1))/4.0;
    SEC_INCRE = (GRID(5,1)+GRID(6,1))/5.0;
    SEC_DEPTH = AV_DEPTH * 4.0;
    SEC_DEPTHINC = (GRID(5,1)+GRID(6,1))/5.0;
    SEC_DIP = 90.0;
    SEC_DOWNDIP_INC = (GRID(5,1)+GRID(6,1))/5.0;
end
H_SEC_WINDOW = xsec_window;
set(findobj('Tag','text_downdip_inc'),'Visible','on');
set(findobj('Tag','edit_downdip_inc'),'Visible','on');
set(findobj('Tag','text_downdip_inc_km'),'Visible','on');
set(findobj('Tag','text_section_dip'),'Visible','on');
set(findobj('Tag','edit_section_dip'),'Visible','on');
set(findobj('Tag','text_section_dip_deg'),'Visible','on');

%-------------------------------------------------------------------------
%     Slip line option (checkbutton)  
%-------------------------------------------------------------------------
function Slip_line_Callback(hObject, eventdata, handles)
% 
global FLAG_SLIP_LINE FLAG_PR_AXES
FLAG_SLIP_LINE = get(hObject,'Value');

if FLAG_SLIP_LINE == 1
    FLAG_PR_AXES = 0;
    set(findobj('Tag','principal_axes'),'Value',0);
end

%-------------------------------------------------------------------------
%     Principal axes option (checkbutton)  
%-------------------------------------------------------------------------
function principal_axes_Callback(hObject, eventdata, handles)
global FLAG_PR_AXES
FLAG_PR_AXES = get(hObject,'Value');
if FLAG_PR_AXES == 1
    set(findobj('Tag','Slip_line'),'Value',0);
end

%-------------------------------------------------------------------------
%     Receivers matrix off (internal function)  
%-------------------------------------------------------------------------
function receivers_matrix_off
global RECEIVERS
RECEIVERS = [];

%-------------------------------------------------------------------------
%     CALC & VIEW (pushbutton) 
%-------------------------------------------------------------------------
function pushbutton_coul_calc_Callback(hObject, eventdata, handles)
coulomb_calc_and_view;
