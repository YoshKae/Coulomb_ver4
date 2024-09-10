function varargout = grid_input_window2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @grid_input_window_OpeningFcn, ...
                   'gui_OutputFcn',  @grid_input_window_OutputFcn, ...
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
%     Opening Function グリッド入力ウィンドウが表示される直前に実行される初期化関数
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function grid_input_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global INUM
% adjust window position
    h = get(hObject,'Position');
    wind_width = h(3);
    wind_height = h(4);
    xpos = SCRW_X;
    ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
    set(hObject,'Position',[xpos ypos wind_width wind_height]);
% Choose default command line output for grid_grid_input_window
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% temporal solution to set the fault number one
    INUM = 1;

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Output Function
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function varargout = grid_input_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     X start (textfield)
%-------------------------------------------------------------------------
function edit_xstart_Callback(hObject, eventdata, handles)
global GRID
temp = GRID(1);
GRID(1,1) = str2num(get(hObject,'String'));
if GRID(1) >= GRID(3)-GRID(5)*3.0
    h = warndlg('x start should be smaller enough than x finish. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(1) = temp;
    return;
end
set(hObject,'String',num2str(GRID(1,1),'%7.2f'));
%------------------------------------------------------------
function edit_xstart_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(1,1),'%7.2f'));

%-------------------------------------------------------------------------
%     X finish (textfield)
%-------------------------------------------------------------------------
function edit_xfinish_Callback(hObject, eventdata, handles)
global GRID
temp = GRID(3);
GRID(3,1) = str2num(get(hObject,'String'));
if GRID(3) < GRID(1)+GRID(5)*3.0
    h = warndlg('x finish should be larger enough than x start. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(3) = temp;
    return;
end
set(hObject,'String',num2str(GRID(3,1),'%7.2f'));
%------------------------------------------------------------
function edit_xfinish_CreateFcn(hObject, eventdata, handles)
% 
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(3,1),'%7.2f'));

%-------------------------------------------------------------------------
%     X increment (textfield)
%-------------------------------------------------------------------------
function edit_xinc_Callback(hObject, eventdata, handles)
global GRID
temp = GRID(5);
GRID(5,1) = str2num(get(hObject,'String'));
if GRID(5) > (GRID(3)-GRID(1))/3.0
    h = warndlg('The increment is too large. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(5) = temp;
    return;
elseif GRID(5) <= 0.0
    h = warndlg('The increment should be positive. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(5) = temp;
    return;
end
set(hObject,'String',num2str(GRID(5,1),'%7.2f'));
%------------------------------------------------------------
function edit_xinc_CreateFcn(hObject, eventdata, handles) 
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(5,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Y start (textfield)
%-------------------------------------------------------------------------
function edit_ystart_Callback(hObject, eventdata, handles)
global GRID
temp = GRID(2);
GRID(2,1) = str2num(get(hObject,'String'));
if GRID(2) >= GRID(4)-GRID(6)*3.0
    h = warndlg('y start should be smaller enough than y finish. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(2) = temp;
    return;
end
set(hObject,'String',num2str(GRID(2,1),'%7.2f'));
%------------------------------------------------------------
function edit_ystart_CreateFcn(hObject, eventdata, handles)
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(2,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Y finish (textfield)
%-------------------------------------------------------------------------
function edit_yfinish_Callback(hObject, eventdata, handles)
global GRID
temp = GRID(4)
GRID(4,1) = str2num(get(hObject,'String'));
if GRID(4) < GRID(2)+GRID(6)*3.0
    h = warndlg('y finish should be larger enough than y start. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(4) = temp;
    return;
end
set(hObject,'String',num2str(GRID(4,1),'%7.2f'));
%------------------------------------------------------------
function edit_yfinish_CreateFcn(hObject, eventdata, handles) 
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(4,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Y increment (textfield)
%-------------------------------------------------------------------------
function edit_yinc_Callback(hObject, eventdata, handles)
global GRID
temp = GRID(6)
GRID(6,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(GRID(6,1),'%7.2f'));
if GRID(6) > (GRID(4)-GRID(2))/3.0
    h = warndlg('The increment is too large. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(6) = temp;
    return;
elseif GRID(6) <= 0.0
    h = warndlg('The increment should be positive. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f')); GRID(6) = temp;
    return;
end
%------------------------------------------------------------
function edit_yinc_CreateFcn(hObject, eventdata, handles)
% 
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(GRID(6,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Cancel (button)
%-------------------------------------------------------------------------
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% 
h = figure(gcf);
delete(h);

%-------------------------------------------------------------------------
%     Add lon. lat. info (button)
%-------------------------------------------------------------------------
function pushbutton_add_lonlat_Callback(hObject, eventdata, handles)
global H_STUDY_AREA H_MAIN
H_STUDY_AREA = study_area;
waitfor(H_STUDY_AREA);      % wait for user's input of lat & lon info.
h = findobj('Tag','main_menu_window');
if isempty(h)~=1 & isempty(H_MAIN)~=1
    iflag = check_lonlat_info;
    if iflag == 1
%    all_overlay_enable_on;
set(findobj('Tag','menu_gridlines'),'Enable','On');
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');    
    end
end

%-------------------------------------------------------------------------
%     OK (button)
%-------------------------------------------------------------------------
function pushbutton_ok_Callback(hObject, eventdata, handles)
global GRID XGRID YGRID
global FUNC_SWITCH
global H_MAIN PREF H_ELEMENT
global ELEMENT NUM
global HEAD POIS YOUNG FRIC CALC_DEPTH KODE SIZE R_STRESS ID SECTION
global DONOTSHOW
global INUM FCOMMENT

%
h = figure(gcf);
delete(h);
    % Calc grid position and hold them for all the other functions
    xstart = GRID(1,1);
    ystart = GRID(2,1);
    xfinish = GRID(3,1);
    yfinish = GRID(4,1);
    xinc = GRID(5,1);
    yinc = GRID(6,1);
    nxinc = int16((xfinish-xstart)/xinc + 1);
    nyinc = int16((yfinish-ystart)/yinc + 1);
    xpp = [1:1:nxinc];
    ypp = [1:1:nyinc];
    XGRID = double(xstart) + (double(1:1:(nxinc-1))-1.0) * double(xinc);
    YGRID = double(ystart) + (double(1:1:(nyinc-1))-1.0) * double(yinc);
FUNC_SWITCH = 1;
CALC_DEPTH =  0.0; % temporal value to pass the "record_stamp function"
                   % in grid_drawing function.
grid_drawing;

% new_fault_mouse_clicks;
FUNC_SWITCH = 0;
xy = zeros(2,2);
n = 0;
but = 1;

if isempty(DONOTSHOW) == 1
h0 = new_fault_pos_dialog;
waitfor(h0);
else
    if DONOTSHOW ~= 1
        h0 = new_fault_pos_dialog;
        waitfor(h0);
    end
end

%------ mouse clicks -------------------
try
while (but == 1 && n <= 2)
    h = figure(H_MAIN);
   [xi,yi,but] = ginput(1);
% 	hold on;
% 	p(n) = plot(xi,yi,'kx');
	n = n+1;
   xy(:,n) = [xi;yi];
   xs = xy(1,1); ELEMENT(1,1) = xy(1,1);
   ys = xy(2,1); ELEMENT(1,2) = xy(2,1);
   xf = xy(1,2); ELEMENT(1,3) = xy(1,2);
   yf = xy(2,2); ELEMENT(1,4) = xy(2,2);
end
catch
    disp('try again choosing NEW from DATA menu');
    return
end
%----------------------------------------
if isempty(findobj('Tag','new_fault_pos_dialog'))~=1
close(h0);
end
   hold on;
h = plot([xs xf],[ys yf]);
set(h,'Tag','new_fault_line');         %TAG cross_section_line
set (h,'Color',PREF(1,1:3),'LineWidth',PREF(1,4));
h1 = text(xs,ys,'A','FontSize',18);
h2 = text(xf,yf,'B','FontSize',18);
set(h1,'HorizontalAlignment','center');
set(h2,'HorizontalAlignment','center');
set(h1,'Tag','new_fault_A');         %TAG cross_section_A
set(h2,'Tag','new_fault_B');         %TAG cross_section_B

% default for beginner......
NUM = 1;
ID  = 1;
ELEMENT(INUM,5) = 0.0;     % right-lat. slip (m)
ELEMENT(INUM,6) = 0.0;     % reverse slip (m)
ELEMENT(INUM,7) = 90.0;    % dip (degree)
ELEMENT(INUM,8) = 0.0;     % fault top depth (km)
ELEMENT(INUM,9) = 10.0;    % fault bottom depth (km)
FCOMMENT(INUM).ref = 'added by mouse-click';     % default comment
CALC_DEPTH = (ELEMENT(:,8)+ELEMENT(:,9)) / 2.0;
POIS = 0.25;
YOUNG = 800000;
KODE(INUM,1) = 100;
FRIC = 0.4;
SIZE = [2;1;10000];
HEAD = cell(2,1);
x1 = ['header line 1'];
x2 = ['header line 2'];
HEAD(1,1) = mat2cell(x1);
HEAD(2,1) = mat2cell(x2);
R_STRESS = [19.00 -0.01 100.0 0.0;
            89.99 89.99  30.0 0.0;
           109.00 -0.01   0.0 0.0];
SECTION = [-16; -16; 18; 26; 1; 30; 1];
% default (end)

H_ELEMENT = element_input_window;
set(findobj('Tag','radiobutton_taper'),'Visible','off');
set(findobj('Tag','radiobutton_split'),'Visible','off');
set(findobj('Tag','text_strike_dist'),'Visible','off');
set(findobj('Tag','text_dip_dist'),'Visible','off');
set(findobj('Tag','text_n_element'),'Visible','off');
set(findobj('Tag','text_x'),'Visible','off');
set(findobj('Tag','text_strike_by_dip'),'Visible','off');
set(findobj('Tag','edit_taper_strike'),'Visible','off');
set(findobj('Tag','edit_taper_dip'),'Visible','off');
set(findobj('Tag','edit_taper_num'),'Visible','off');
set(findobj('Tag','edit_nf_strike'),'Visible','off');
set(findobj('Tag','edit_nf_dip'),'Visible','off');
set(findobj('Tag','text_split_strike'),'Visible','off');
set(findobj('Tag','text_split_dip'),'Visible','off');
set(findobj('Tag','pushbutton_add_fault'),'Visible','on');
waitfor(H_ELEMENT);
calc_element;



