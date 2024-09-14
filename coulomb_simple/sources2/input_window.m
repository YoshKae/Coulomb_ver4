function varargout = input_window(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @input_window_OpeningFcn, ...
                   'gui_OutputFcn',  @input_window_OutputFcn, ...
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


%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     OpeningFcn
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function input_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCR_SIZE  % screen size (1x4, [x y width height]) & width
global INPUT_VARS

if isempty(INPUT_VARS.INUM)
    INPUT_VARS.INUM = 1;
end
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window2');
if isempty(dummy)~=1
    h = get(dummy,'Position');
end
shift = 30;
xpos = h(1,1) + shift;
ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height + shift;
set(hObject,'Position',[xpos ypos wind_width wind_height]);
% Choose default command line output for input_window
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     OutputFcn
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function varargout = input_window_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%   POISSON RATIO (textfield)
%-------------------------------------------------------------------------
function edit_poisson_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.POIS = str2num(get(hObject,'String'));
set(hObject,'String',num2str(POIS,'%6.2f'));
%-----------------------------------
function edit_poisson_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_poisson');
set(h,'String',num2str(INPUT_VARS.POIS,'%6.2f'));

%-------------------------------------------------------------------------
%   YOUNG MODULUS (textfield)
%-------------------------------------------------------------------------
function edit_young_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.YOUNG = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.YOUNG,'%8.1f'));
%-----------------------------------
function edit_young_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_young');
set(h,'String',num2str(INPUT_VARS.YOUNG,'%8.1f'));

%-------------------------------------------------------------------------
%   HEADER LINE 1 (textfield)
%-------------------------------------------------------------------------
function edit_hline1_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.HEAD(1,:) = get(hObject,'String');
set (hObject,'String',INPUT_VARS.HEAD(1,:));
%-----------------------------------
function edit_hline1_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_hline1');
set (h,'String',INPUT_VARS.HEAD(1,:));

%-------------------------------------------------------------------------
%   HEADER LINE 2 (textfield)
%-------------------------------------------------------------------------
function edit_hline2_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.HEAD(2,:) = get(hObject,'String');
set (hObject,'String',INPUT_VARS.HEAD(2,:));
%-----------------------------------
function edit_hline2_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_hline2');
set (h,'String',INPUT_VARS.HEAD(2,:));

%-------------------------------------------------------------------------
%   CALC. DEPTH (textfield)
%-------------------------------------------------------------------------
function edit_calcdepth_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.CALC_DEPTH = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.CALC_DEPTH,'%6.2f'));
%-----------------------------------
function edit_calcdepth_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_calcdepth');
set(h,'String',num2str(INPUT_VARS.CALC_DEPTH,'%6.2f'));

%-------------------------------------------------------------------------
%   FRICTION (textfield)
%-------------------------------------------------------------------------
function edit_fric_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.FRIC = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.FRIC,'%3.1f'));
%-----------------------------------
function edit_fric_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_fric');
set(h,'String',num2str(INPUT_VARS.FRIC,'%3.1f'));

%-------------------------------------------------------------------------
%   SIGMA 1 (ORIENTATION)  (textfield)
%-------------------------------------------------------------------------
function edit_s1or_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(1,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(1,1),'%7.1f'));
%-----------------------------------
function edit_s1or_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s1or');
set(h,'String',num2str(INPUT_VARS.R_STRESS(1,1),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 1 (DIP)  (textfield)
%-------------------------------------------------------------------------
function edit_s1dip_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(1,2) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(1,2),'%7.1f'));
%-----------------------------------
function edit_s1dip_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s1dip');
set(h,'String',num2str(INPUT_VARS.R_STRESS(1,2),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 1 (INITIAL STRESS)  (textfield)
%-------------------------------------------------------------------------
function edit_s1in_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.R_STRESS(1,3) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(1,3),'%7.1f'));
%-----------------------------------
function edit_s1in_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s1in');
set(h,'String',num2str(INPUT_VARS.R_STRESS(1,3),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 1 (GRADIENT)  (textfield)
%-------------------------------------------------------------------------
function edit_s1grad_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.R_STRESS(1,4) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(1,4),'%7.1f'));
%-----------------------------------
function edit_s1grad_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s1grad');
set(h,'String',num2str(INPUT_VARS.R_STRESS(1,4),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 2 (ORIENTATION)  (textfield)
%-------------------------------------------------------------------------
function edit_s2or_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(2,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(2,1),'%7.1f'));
%-----------------------------------
function edit_s2or_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s2or');
set(h,'String',num2str(INPUT_VARS.R_STRESS(2,1),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 2 (DIP)  (textfield)
%-------------------------------------------------------------------------
function edit_s2dip_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.R_STRESS(2,2) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(2,2),'%7.1f'));
%-----------------------------------
function edit_s2dip_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s2dip');
set(h,'String',num2str(INPUT_VARS.R_STRESS(2,2),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 2 (INITIAL STRESS)  (textfield)
%-------------------------------------------------------------------------
function edit_s2in_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(2,3) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(2,3),'%7.1f'));
%-----------------------------------
function edit_s2in_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s2in');
set(h,'String',num2str(INPUT_VARS.R_STRESS(2,3),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 2 (GRADIENT)  (textfield)
%-------------------------------------------------------------------------
function edit_s2grad_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(2,4) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(2,4),'%7.1f'));
%-----------------------------------
function edit_s2grad_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s2grad');
set(h,'String',num2str(INPUT_VARS.R_STRESS(2,4),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 3 (ORIENTATION)  (textfield)
%-------------------------------------------------------------------------
function edit_s3or_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(3,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(3,1),'%7.1f'));
%-----------------------------------
function edit_s3or_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s3or');
set(h,'String',num2str(INPUT_VARS.R_STRESS(3,1),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 3 (DIP)  (textfield)
%-------------------------------------------------------------------------
function edit_s3dip_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(3,2) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(3,2),'%7.1f'));
%-----------------------------------
function edit_s3dip_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s3dip');
set(h,'String',num2str(INPUT_VARS.R_STRESS(3,2),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 3 (INITIAL STRESS)  (textfield)
%-------------------------------------------------------------------------
function edit_s3in_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(3,3) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(3,3),'%7.1f'));
%-----------------------------------
function edit_s3in_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s3in');
set(h,'String',num2str(INPUT_VARS.R_STRESS(3,3),'%7.1f'));

%-------------------------------------------------------------------------
%   SIGMA 3 (GRADIENT)  (textfield)
%-------------------------------------------------------------------------
function edit_s3grad_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.R_STRESS(3,4) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.R_STRESS(3,4),'%7.1f'));
%-----------------------------------
function edit_s3grad_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_s3grad');
set(h,'String',num2str(INPUT_VARS.R_STRESS(3,4),'%7.1f'));

%=========================================================================
%-------------------------------------------------------------------------
%   GRID (X-START)  (textfield)
%-------------------------------------------------------------------------
function edit_xstart_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.GRID(1,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(1,1),'%7.2f'));
%-----------------------------------
function edit_xstart_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_xstart');
set(h,'String',num2str(INPUT_VARS.GRID(1,1),'%7.2f'));

%-------------------------------------------------------------------------
%   GRID (X-FINISH)  (textfield)
%-------------------------------------------------------------------------
function edit_xfinish_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.GRID(3,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(3,1),'%7.2f'));
%-----------------------------------
function edit_xfinish_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_xfinish');
set(h,'String',num2str(INPUT_VARS.GRID(3,1),'%7.2f'));

%-------------------------------------------------------------------------
%   GRID (X-INCREMENT)  (textfield)
%-------------------------------------------------------------------------
function edit_xinc_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.GRID(5,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(5,1),'%7.2f'));
%-----------------------------------
function edit_xinc_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_xinc');
set(h,'String',num2str(INPUT_VARS.GRID(5,1),'%7.2f'));

%-------------------------------------------------------------------------
%   GRID (Y-START)  (textfield)
%-------------------------------------------------------------------------
function edit_ystart_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.GRID(2,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(2,1),'%7.2f'));
%-----------------------------------
function edit_ystart_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_ystart');
set(h,'String',num2str(INPUT_VARS.GRID(2,1),'%7.2f'));

%-------------------------------------------------------------------------
%   GRID (Y-FINISH)  (textfield)
%-------------------------------------------------------------------------
function edit_yfinish_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.GRID(4,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(4,1),'%7.2f'));
%-----------------------------------
function edit_yfinish_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_yfinish');
set(h,'String',num2str(INPUT_VARS.GRID(4,1),'%7.2f'));

%-------------------------------------------------------------------------
%   GRID (Y-INCREMENT)  (textfield)
%-------------------------------------------------------------------------
function edit_yinc_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.GRID(6,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(6,1),'%7.2f'));
%-----------------------------------
function edit_yinc_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_yinc');
set(h,'String',num2str(INPUT_VARS.GRID(6,1),'%7.2f'));

%-------------------------------------------------------------------------
%   SAVE AS...  (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_saveas_Callback(hObject, eventdata, handles)
global SYSTEM_VARS
    if isempty(SYSTEM_VARS.PREF)==1
        % make default values & then save them.
        SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                            0.0 0.0 0.0 1.0;...
                            0.7 0.7 0.0 0.2;...
                            0.0 0.0 0.0 1.2;...
                            1.0 0.5 0.0 3.0;...
                            0.2 0.2 0.2 1.0;...
                            2.0 0.0 0.0 0.0;...
                            1.0 0.0 0.0 0.0];
    end
    [filename,pathname] = uiputfile('*.inp',...
        ' Save Input File As');
    if isequal(filename,0) | isequal(pathname,0)
        disp('User selected Cancel')
    else
        disp(['User saved as ', fullfile(pathname,filename)])
    end
    cd(pathname);
    input_save_ascii;
    cd(SYSTEM_VARS.HOME_DIR);

%-------------------------------------------------------------------------
%   OK  (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_ok_Callback(hObject, eventdata, handles)
h = figure(gcf);
delete(h);
% to calculate and save numbers for basic info
calc_element;
%
%----- DRAW GRID IN MAIN WINDOW ------ (copied from ...)
global CALC_CONTROL
global OVERLAY_VARS
subfig_clear;
CALC_CONTROL.FUNC_SWITCH = 1;
grid_drawing2;
fault_overlay;
if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 | isempty(OVERLAY_VARS.AFAULT_DATA)~=1
    hold on;
    overlay_drawing;
end
CALC_CONTROL.FUNC_SWITCH = 0; %reset
flag = check_lonlat_info2;
if flag == 1
    %----------------------------------------------------------
    % function all_overlay_enable_on
    set(findobj('Tag','menu_coastlines'),'Enable','On');
    set(findobj('Tag','menu_activefaults'),'Enable','On');
    set(findobj('Tag','menu_earthquakes'),'Enable','On');
    set(findobj('Tag','menu_gps'),'Enable','On');
    set(findobj('Tag','menu_annotations'),'Enable','On');
    set(findobj('Tag','menu_clear_overlay'),'Enable','On');
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On');
end
%----- DRAW GRID IN MAIN WINDOW ------ (copied from ...)

%-------------------------------------------------------------------------
%   FAULT (X-START)  (textfield)
%-------------------------------------------------------------------------
function edit_fxstart_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1),'%9.2f'));
%-----------------------------------
function edit_fxstart_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_fxstart');
set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1),'%9.2f'));

%-------------------------------------------------------------------------
%   FAULT (Y-START)  (textfield)
%-------------------------------------------------------------------------
function edit_fystart_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2),'%9.2f'));
%-----------------------------------
function edit_fystart_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_fystart');
set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2),'%9.2f'));

%-------------------------------------------------------------------------
%   FAULT (X-FINISH)  (textfield)
%-------------------------------------------------------------------------
function edit_fxfinish_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3),'%9.2f'));
%-----------------------------------
function edit_fxfinish_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_fxfinish');
set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3),'%9.2f'));

%-------------------------------------------------------------------------
%   FAULT (Y-FINISH)  (textfield)
%-------------------------------------------------------------------------
function edit_fyfinish_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4),'%9.2f'));
%-----------------------------------
function edit_fyfinish_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_fyfinish');
set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4),'%9.2f'));

%-------------------------------------------------------------------------
%   KODE  (textfield)
%-------------------------------------------------------------------------
function edit_input_kode_Callback(hObject, eventdata, handles)
global INPUT_VARS
x = str2num(get(hObject,'String'));
if x ~= 100 && x ~= 200 && x ~= 300 && x ~= 400 && x ~= 500
    h = warndlg('Kode should be 100 or 200 or 300 or 400 or 500.','!! Warning !!');
    waitfor(h);
else
    INPUT_VARS.KODE(INPUT_VARS.INUM) = x;
end
set(hObject,'String',num2str(INPUT_VARS.KODE(INPUT_VARS.INUM),'%3i'));
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 100
    if INPUT_VARS.IRAKE == 1   % rake & netslip type
        set(findobj('Tag','text_input_latslip'),'String','rake');
        set(findobj('Tag','text_slip1_unit'),'String','(�)');
        set(findobj('Tag','text_input_dipslip'),'String','net slip');
        set(findobj('Tag','text_slip2_unit'),'String','(m)');
    else            % lateral slip and dip slip type
        set(findobj('Tag','text_input_latslip'),'String','rt.lat slip');
        set(findobj('Tag','text_slip1_unit'),'String','(m)');
        set(findobj('Tag','text_input_dipslip'),'String','dip slip');
        set(findobj('Tag','text_slip2_unit'),'String','(m)');
    end
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 200
    set(findobj('Tag','text_input_latslip'),'String','rt.lat slip');
    set(findobj('Tag','text_slip1_unit'),'String','(m)');
    set(findobj('Tag','text_input_dipslip'),'String','tensile slip');
 	set(findobj('Tag','text_slip2_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 300
    set(findobj('Tag','text_input_latslip'),'String','tensile slip');
	set(findobj('Tag','text_slip1_unit'),'String','(m)');
    set(findobj('Tag','text_input_dipslip'),'String','dip slip');
	set(findobj('Tag','text_slip2_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 400
    set(findobj('Tag','text_input_latslip'),'String','rt.lat pot.');
	set(findobj('Tag','text_slip1_unit'),'String','(m^3)');
    set(findobj('Tag','text_input_dipslip'),'String','dip pot.');
	set(findobj('Tag','text_slip2_unit'),'String','(m^3)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
    set(findobj('Tag','text_input_latslip'),'String','tensile pot.');
	set(findobj('Tag','text_slip1_unit'),'String','(m^3)');
    set(findobj('Tag','text_input_dipslip'),'String','inflate pot.');
	set(findobj('Tag','text_slip2_unit'),'String','(m)^3');
end

% --- Executes during object creation, after setting all properties.
function edit_input_kode_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_input_kode');
set(h,'String',num2str(INPUT_VARS.KODE(INPUT_VARS.INUM),'%3i'));
set(hObject,'String',num2str(INPUT_VARS.KODE(INPUT_VARS.INUM),'%3i'));

%-------------------------------------------------------------------------
%   SLIP 1st column (static text, createfunction)
%-------------------------------------------------------------------------
function text_input_latslip_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 100
    if INPUT_VARS.IRAKE == 1   % rake & netslip type
        set(findobj('Tag','text_input_latslip'),'String','rake');
    else            % lateral slip and dip slip type
        set(findobj('Tag','text_input_latslip'),'String','rt.lat slip');
    end
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 200
    set(findobj('Tag','text_input_latslip'),'String','rt.lat slip');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 300
    set(findobj('Tag','text_input_latslip'),'String','tensile open');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 400
    set(findobj('Tag','text_input_latslip'),'String','rt.lat potency');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
    set(findobj('Tag','text_input_latslip'),'String','tensile potency');
end

%-------------------------------------------------------------------------
%   SLIP 2nd column (static text, createfunction)
%-------------------------------------------------------------------------
function text_input_dipslip_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 100
    if INPUT_VARS.IRAKE == 1   % rake & netslip type
        set(findobj('Tag','text_input_dipslip'),'String','net slip');
    else            % lateral slip and dip slip type
        set(findobj('Tag','text_input_dipslip'),'String','dip slip');
    end
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 200
    set(findobj('Tag','text_input_dipslip'),'String','tensile open');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 300
    set(findobj('Tag','text_input_dipslip'),'String','dip slip');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 400
    set(findobj('Tag','text_input_dipslip'),'String','dip potency');    
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
    set(findobj('Tag','text_input_dipslip'),'String','inflate potency');  
end

%-------------------------------------------------------------------------
%   SLIP 1st column unit (static text, createfunction)
%-------------------------------------------------------------------------
function text_slip1_unit_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 100
    if INPUT_VARS.IRAKE == 1   % rake & netslip type
        set(findobj('Tag','text_slip1_unit'),'String','(�)');
    else            % lateral slip and dip slip type
        set(findobj('Tag','text_slip1_unit'),'String','(m)');
    end
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 200
	set(findobj('Tag','text_slip1_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 300
	set(findobj('Tag','text_slip1_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 400
	set(findobj('Tag','text_slip1_unit'),'String','(m^3)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
	set(findobj('Tag','text_slip1_unit'),'String','(m^3)');
end

%-------------------------------------------------------------------------
%   SLIP 2nd column unit (static text, createfunction)
%-------------------------------------------------------------------------
function text_slip2_unit_CreateFcn(hObject, eventdata, handles) 
global INPUT_VARS
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 100
    set(findobj('Tag','text_slip2_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 200
	set(findobj('Tag','text_slip2_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 300
	set(findobj('Tag','text_slip2_unit'),'String','(m)');
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 400
	set(findobj('Tag','text_slip2_unit'),'String','(m^3)');    
elseif INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
	set(findobj('Tag','text_slip2_unit'),'String','(m^3)');    
end

%-------------------------------------------------------------------------
%   FAULT (LATERAL SLIP)  (textfield)
%-------------------------------------------------------------------------
function edit_laterals_Callback(hObject, eventdata, handles) 
global INPUT_VARS
global IND_RAKE
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5) = str2num(get(hObject,'String'));
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 400 || INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
    set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5),'%4.1e'));    
else
    if INPUT_VARS.IRAKE == 1
        set(hObject,'String',num2str(IND_RAKE(INPUT_VARS.INUM),'%5.1f'));        
    else
        set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5),'%7.3f'));
    end
end
%-----------------------------------
function edit_laterals_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
global IND_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_laterals');
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 400 || INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
	set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5),'%4.1e'));
else
    if INPUT_VARS.IRAKE == 1
        set(hObject,'String',num2str(IND_RAKE(INPUT_VARS.INUM),'%5.1f'));        
    else    
        set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5),'%7.3f'));
    end
end

%-------------------------------------------------------------------------
%   FAULT (DIP SLIP)  (textfield)
%-------------------------------------------------------------------------
function edit_dips_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6) = str2num(get(hObject,'String'));
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 400 || INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
    set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6),'%4.1e')); 
else
    if INPUT_VARS.IRAKE == 1
        x = sqrt(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5)^2+INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6)^2);
        set(hObject,'String',num2str(x,'%7.3f'));          
    else
        set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6),'%7.3f'));
    end
end
%-----------------------------------
function edit_dips_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_dips');
if INPUT_VARS.KODE(INPUT_VARS.INUM) == 400 || INPUT_VARS.KODE(INPUT_VARS.INUM) == 500
	set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6),'%4.1e'));
else
    if INPUT_VARS.IRAKE == 1
        x = sqrt(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5)^2+INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6)^2);
        set(hObject,'String',num2str(x,'%7.3f'));          
    else
        set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6),'%7.3f'));
    end
end

%-------------------------------------------------------------------------
%   FAULT (DIP)  (textfield)
%-------------------------------------------------------------------------
function edit_dip_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7),'%5.1f'));
%-----------------------------------
function edit_dip_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_dip');
set(h,'String',num2str(EINPUT_VARS.LEMENT(INPUT_VARS.INUM,7),'%5.1f'));

%-------------------------------------------------------------------------
%   FAULT (TOP)  (textfield)
%-------------------------------------------------------------------------
function edit_top_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8),'%6.2f'));
%-----------------------------------
function edit_top_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_top');
set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8),'%6.2f'));

%-------------------------------------------------------------------------
%   FAULT (BOTTOM)  (textfield)
%-------------------------------------------------------------------------
function edit_bottom_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9),'%6.2f'));
%-----------------------------------
function edit_bottom_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_bottom');
set(h,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9),'%6.2f'));

%-------------------------------------------------------------------------
%   FAULT (i-th fault element)  (textfield)
%-------------------------------------------------------------------------
function edit_elem_Callback(hObject, eventdata, handles) 
global INPUT_VARS
INPUT_VARS.INUM = str2num(get(hObject,'String'));
if INPUT_VARS.INUM > INPUT_VARS.NUM
    warndlg('This must not over the total number','Warning!');
end
set(handles.edit_fxstart,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1),'%9.2f'))
set(handles.edit_fystart,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2),'%9.2f'))
set(handles.edit_fxfinish,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3),'%9.2f'))
set(handles.edit_fyfinish,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4),'%9.2f'))
set(handles.edit_laterals,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5),'%7.3f'))
set(handles.edit_dips,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6),'%7.3f'))
set(handles.edit_dip,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7),'%5.1f'))
set(handles.edit_top,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8),'%6.2f'))
set(handles.edit_bottom,'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9),'%6.2f'))
%-----------------------------------
function edit_elem_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_elem');
set(h,'String',num2str(INPUT_VARS.INUM));

%-------------------------------------------------------------------------
%   FAULT (TOTAL NUMBER OF FAULTS)  (textfield)
%-------------------------------------------------------------------------
function edit_totalnf_Callback(hObject, eventdata, handles)
global INPUT_VARS
INPUT_VARS.NUM = str2num(get(hObject,'String'));
INPUT_VARS.ELEMENT(INPUT_VARS.NUM,:);
set(hObject,'String',num2str(INPUT_VARS.NUM));
%-----------------------------------
function edit_totalnf_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_totalnf');
set(h,'String',num2str(INPUT_VARS.NUM));
