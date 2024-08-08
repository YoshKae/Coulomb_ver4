function varargout = element_input_window(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @element_input_window_OpeningFcn, ...
                   'gui_OutputFcn',  @element_input_window_OutputFcn, ...
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

% --- Executes just before element_input_window is made visible.
function element_input_window_OpeningFcn(hObject, eventdata, handles, varargin)
global INUM KODE
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global CLICK_TAPER
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
% xpos = h(1,1) + h(1,3) + 5;
xpos = h(1,1) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
KODE(INUM,1) = 100;
set(findobj('Tag','radiobutton_taper'),'Value',0);
% CLICK_TAPER = 1;


% --- Outputs from this function are returned to the command line.
function varargout = element_input_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     Fault X start (textfield)
%-------------------------------------------------------------------------
function edit_fxstart_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,1),'%9.2f'));
%----------------------
function edit_fxstart_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% INUM = 1;
set(hObject,'String',num2str(ELEMENT(INUM,1),'%9.2f'));

%-------------------------------------------------------------------------
%     Fault Y start (textfield)
%-------------------------------------------------------------------------
function edit_fystart_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,2) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,2),'%9.2f'));
%----------------------
function edit_fystart_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,2),'%9.2f'));

%-------------------------------------------------------------------------
%     Fault X finish (textfield)
%-------------------------------------------------------------------------
function edit_fxfinish_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,3) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,3),'%9.2f'));
%----------------------
function edit_fxfinish_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,3),'%9.2f'));

%-------------------------------------------------------------------------
%     Fault Y finish (textfield)
%-------------------------------------------------------------------------
function edit_fyfinish_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,4) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,4),'%9.2f'));
%----------------------
function edit_fyfinish_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,4),'%9.2f'));

%-------------------------------------------------------------------------
%     Lateral slip (textfield)
%-------------------------------------------------------------------------
function edit_laterals_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,5) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,5),'%7.3f'));
%----------------------
function edit_laterals_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,5),'%7.3f'));

%-------------------------------------------------------------------------
%     Dip slip (textfield)
%-------------------------------------------------------------------------
function edit_dips_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,6) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,6),'%7.3f'));
%----------------------
function edit_dips_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,6),'%7.3f'));

%-------------------------------------------------------------------------
%     Dip (textfield)
%-------------------------------------------------------------------------
function edit_dip_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,7) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,7),'%5.1f'));
%----------------------
function edit_dip_CreateFcn(hObject, eventdata, handles)
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,7),'%5.1f'));

%-------------------------------------------------------------------------
%     Fault top (textfield)
%-------------------------------------------------------------------------
function edit_top_Callback(hObject, eventdata, handles) 
global INUM ELEMENT
ELEMENT(INUM,8) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,8),'%6.2f'));
%----------------------
function edit_top_CreateFcn(hObject, eventdata, handles) 
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,8),'%6.2f'));

%-------------------------------------------------------------------------
%     Fault bottom (textfield)
%-------------------------------------------------------------------------
function edit_bottom_Callback(hObject, eventdata, handles)
global INUM ELEMENT
ELEMENT(INUM,9) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(INUM,9),'%6.2f'));
%----------------------
function edit_bottom_CreateFcn(hObject, eventdata, handles) 
global INUM ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(INUM,9),'%6.2f'));

%-------------------------------------------------------------------------
%     Number of faults (i-th fault element) (textfield)
%-------------------------------------------------------------------------
function edit_elem_Callback(hObject, eventdata, handles)
global INUM NUM ELEMENT
INUM = str2num(get(hObject,'String'));
if INUM > NUM
    warndlg('This must not over the total number','Warning!');
    return
end
% KODE(INUM,1) = 100;
%h = findobj('Tag','edit_fxstart');
set(handles.edit_fxstart,'String',num2str(ELEMENT(INUM,1),'%9.2f'))
set(handles.edit_fystart,'String',num2str(ELEMENT(INUM,2),'%9.2f'))
set(handles.edit_fxfinish,'String',num2str(ELEMENT(INUM,3),'%9.2f'))
set(handles.edit_fyfinish,'String',num2str(ELEMENT(INUM,4),'%9.2f'))
set(handles.edit_laterals,'String',num2str(ELEMENT(INUM,5),'%7.3f'))
set(handles.edit_dips,'String',num2str(ELEMENT(INUM,6),'%7.3f'))
set(handles.edit_dip,'String',num2str(ELEMENT(INUM,7),'%5.1f'))
set(handles.edit_top,'String',num2str(ELEMENT(INUM,8),'%6.2f'))
set(handles.edit_bottom,'String',num2str(ELEMENT(INUM,9),'%6.2f'))
%----------------------
function edit_elem_CreateFcn(hObject, eventdata, handles)
global INUM
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INUM));

%-------------------------------------------------------------------------
%     Total number of faults (textfield)
%-------------------------------------------------------------------------
function edit_totalnf_Callback(hObject, eventdata, handles)
% 
global NUM ELEMENT
NUM = str2num(get(hObject,'String'));
ELEMENT(NUM,:);
set(hObject,'String',num2str(NUM));

function edit_totalnf_CreateFcn(hObject, eventdata, handles)
% 
global NUM TAPER_CALLED
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% if TAPER_CALLED ~= 1
%     NUM = 1;
% end
set(hObject,'String',num2str(NUM));

%-------------------------------------------------------------------------
%     OK (button)
%-------------------------------------------------------------------------
function pushbutton_ok_Callback(hObject, eventdata, handles)
global TAPER_CALLED ELEMENT INUM NUM FCOMMENT ID
global CLICK_TAPER CLICK_SPLIT N_STR N_DIP TD_STR TD_DIP TN
global FUNC_SWITCH YOUNG POIS ID KODE
global SD_LIMIT DD_LIMIT IRAKE IND_RAKE
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global H_ELEMENT_MOD

if CLICK_TAPER == 1 | CLICK_SPLIT == 1
if sum(ID) > NUM
    h = errordlg('This file contains a multi-element fault already. Change # of elements (first column) all one in the input file','Error');
    waitfor(h);
    return;
end
end

h = figure(gcf);
delete(h);
if TAPER_CALLED ~= 1
%     % disp('checked')
	if ~isempty(IND_RAKE)
        [rake dummy] = comp2rake(ELEMENT(NUM,5),ELEMENT(NUM,6));
        IND_RAKE(NUM) = rake;
	end    
    fault_overlay;
    TAPER_CALLED = 0;    
else
% taper & splitting
% the following codes do not work for some unknow reason...
%     x1 = get(findobj('Tag','radiobutton_taper'),'Value')
%     x2 = get(findobj('Tag','radiobutton_split'),'Value')
% ===== tapering function =====
    if CLICK_TAPER == 1
% %       el(:,1) xstart (km)
% %       el(:,2) ystart (km)
% %       el(:,3) xfinish (km)
% %       el(:,4) yfinish (km)
% %       el(:,5) right-lat. slip (m)
% %       el(:,6) reverse slip (m)
% %       el(:,7) dip (degree)
% %       el(:,8) fault top depth (km)
% %       el(:,9) fault bottom depth (km)
        edge = 0.01;
        [el] = taper_calc(ELEMENT(INUM,:),TD_STR,TD_DIP,edge,TN,YOUNG,POIS);
        % function el = taper_calc(el0,d_strike,d_dip,edge,npatch,young,poisson)
        m = size(el,1);
        nr = int16(NUM) - int16(INUM);
        if nr > 0
            ELEMENT(INUM+m:(INUM+m+nr-1),:) = ELEMENT(INUM+1:NUM,:);
            counter = 0;
            for i = INUM+m:INUM+m+nr-1
                FCOMMENT(1,i).ref = FCOMMENT(1,INUM+counter).ref;
                counter = counter + 1;
            end
            ID(INUM+m:(INUM+m+nr-1))      = ID(INUM+1:NUM);
%            ID(INUM+m:(INUM+m+nr-1),:)      = ID(INUM+1:NUM,:);
            KODE(INUM+m:(INUM+m+nr-1),:)    = KODE(INUM+1:NUM,:);
        end
        ELEMENT(INUM:(INUM+m-1),:)  = el(:,:);
        if ~isempty(IND_RAKE)
        [rake dummy] = comp2rake(ELEMENT(INUM:(INUM+m-1),5),...
            ELEMENT(INUM:(INUM+m-1),6));
        IND_RAKE(INUM:(INUM+m-1)) = rake(INUM:(INUM+m-1));
        end
        FCOMMENT(1,INUM:(INUM+m-1)) = FCOMMENT(INUM);
        ID(INUM:(INUM+m-1)) = ID(INUM);
%        ID(INUM:(INUM+m-1),:) = ID(INUM);
        KODE(INUM:(INUM+m-1),:) = KODE(INUM);
        NUM = NUM + m - 1;
        set(findobj('Tag','edit_totalnf'),'String',num2str(NUM,'%3i'));
 % ===== splitting function =====
    elseif CLICK_SPLIT == 1              % splitting
        nn = N_STR * N_DIP;
        [el] = split_calc(ELEMENT(INUM,:),N_STR,N_DIP);
        m = size(el,1);
        nr = int16(NUM) - int16(INUM);
        if nr > 0                       % Sidetrack
            ELEMENT(INUM+m:(INUM+m+nr-1),:) = ELEMENT(INUM+1:NUM,:);
            counter = 0;
            for i = INUM+m:INUM+m+nr-1
                FCOMMENT(1,i).ref = FCOMMENT(1,INUM+counter).ref;
                counter = counter + 1;
            end
%             dID   = ones(1,INUM+m+nr-1);
%             dKode = 100 * ones(INUM+m+nr-1,1);
%             dID(1,INUM+m:(INUM+m+nr-1))      = ID(1,INUM+1:NUM);
%             dKODE(INUM+m:(INUM+m+nr-1),:)    = KODE(INUM+1:NUM,:);
            ID(INUM+m:(INUM+m+nr-1))      = ID(INUM+1:NUM);
            KODE(INUM+m:(INUM+m+nr-1),:)    = KODE(INUM+1:NUM,:);
            if IRAKE == 1
                IND_RAKE(INUM+m:(INUM+m+nr-1),:) = IND_RAKE(INUM+1:NUM,:);
            end
        end        
        ELEMENT(INUM:(INUM+m-1),:)  = el(:,:);
        
        if ~isempty(IND_RAKE) %          !!! rake option
% %             if INUM == NUM
%        IND_RAKE = [IND_RAKE(1:INUM-1);zeros(m,1)];   
% %             else
% %         IND_RAKE = [IND_RAKE(1:INUM-1);zeros(m,1);IND_RAKE(INUM+1:end)];
% %             end
        
        [rake dummy] = comp2rake(ELEMENT(INUM:(INUM+m-1),5),...
            ELEMENT(INUM:(INUM+m-1),6));
%         size(rake)
%         size(IND_RAKE)
        IND_RAKE(INUM:(INUM+m-1)) = rake(1:m);
        end
        
        FCOMMENT(INUM:(INUM+m-1)) = FCOMMENT(INUM);
%         dID(1,INUM:(INUM+m-1)) = ID(INUM);
%         dKODE(INUM:(INUM+m-1),:) = KODE(INUM);
        ID(INUM:(INUM+m-1)) = ID(INUM);
        KODE(INUM:(INUM+m-1),:) = KODE(INUM);
            if IRAKE == 1
                IND_RAKE(INUM:(INUM+m-1),:) = KODE(INUM);
            end
        NUM = NUM + m - 1;
        set(findobj('Tag','edit_totalnf'),'String',num2str(NUM,'%3i'));
%         ID = dID;
%         KODE = dKODE;
    else
        if ~isempty(IND_RAKE)
            if IRAKE == 1
        [rake dummy] = comp2rake(ELEMENT(INUM,5),ELEMENT(INUM,6));
        IND_RAKE(INUM) = rake(1);
            end
        end
    end
% drawing the grid again to confirm (copied from menu_grid_Callback)
    calc_element;
    subfig_clear;
    FUNC_SWITCH = 1;
    grid_drawing;
    fault_overlay;
    FUNC_SWITCH = 0; %reset
    flag = check_lonlat_info;
    if flag == 1
    set(findobj('Tag','menu_gridlines'),'Enable','On');
    set(findobj('Tag','menu_coastlines'),'Enable','On');
    set(findobj('Tag','menu_activefaults'),'Enable','On');
    set(findobj('Tag','menu_earthquakes'),'Enable','On'); 
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
    end
% reset flags
TAPER_CALLED = 0;
CLICK_TAPER  = 0;
CLICK_SPLIT  = 0;
end

% calc_element;
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA) ~= 1 | isempty(EQ_DATA) ~= 1 | isempty(AFAULT_DATA) ~= 1
        hold on;
        overlay_drawing;
    end
%end
%----------------------------- if context window still exists...

if (isempty(findobj('Tag','figure_element_modification'))~=1 && isempty(H_ELEMENT_MOD)~=1)
    close(figure(H_ELEMENT_MOD))
    H_ELEMENT_MOD = [];
end

%    if (isempty(findobj('Tag','figure_element_modification'))~=1 && isempty(H_ELEMENT_MOD)~=1)
%         close(figure(H_ELEMENT_MOD))
%         H_ELEMENT_MOD = [];
%     subfig_clear;
%     FUNC_SWITCH = 1;
%     grid_drawing;
%     fault_overlay;
%     if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
%             isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
%         hold on;
%         overlay_drawing;
%     end
%     FUNC_SWITCH = 0; %reset
%     flag = check_lonlat_info;
%     if flag == 1
%         set(findobj('Tag','menu_coastlines'),'Enable','On');
%         set(findobj('Tag','menu_activefaults'),'Enable','On');
%         set(findobj('Tag','menu_earthquakes'),'Enable','On');
%         set(findobj('Tag','menu_gps'),'Enable','On'); 
%         set(findobj('Tag','menu_annotations'),'Enable','On'); 
%         set(findobj('Tag','menu_clear_overlay'),'Enable','On');
%         set(findobj('Tag','menu_trace_put_faults'),'Enable','On');     
%     end
%    end
%-----------------------------


%-------------------------------------------------------------------------
%     Taper (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_taper_Callback(hObject, eventdata, handles)
global CLICK_TAPER CLICK_SPLIT ELEMENT INUM SD_LIMIT DD_LIMIT
CLICK_TAPER = get(hObject,'Value');
if CLICK_TAPER == 1
    set(findobj('Tag','radiobutton_split'),'Value',0);
    CLICK_SPLIT = 0;
% calc. limitation of tapering distance
        buffer = 0.4;
        SD_LIMIT = sqrt((ELEMENT(INUM,3)-ELEMENT(INUM,1))^2.0+...
            (ELEMENT(INUM,4)-ELEMENT(INUM,2))^2.0)/2.0 - buffer;
        bs = sin(deg2rad(ELEMENT(INUM,7)));
        if bs == 0.0
            bs = 0.0001;
        end
        DD_LIMIT = ((ELEMENT(INUM,9)-ELEMENT(INUM,8)) / bs) / 2.0 - buffer;
end

%-------------------------------------------------------------------------
%     Splitting (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_split_Callback(hObject, eventdata, handles)
global CLICK_SPLIT CLICK_TAPER
CLICK_SPLIT = get(hObject,'Value');
if CLICK_SPLIT == 1
    set(findobj('Tag','radiobutton_taper'),'Value',0);
    CLICK_TAPER = 0;
end

%-------------------------------------------------------------------------
%     Taper distance along strike (textfield)
%-------------------------------------------------------------------------
function edit_taper_strike_Callback(hObject, eventdata, handles)
global TD_STR SD_LIMIT
TD_STR = str2num(get(hObject,'String'));
if TD_STR > SD_LIMIT
    h = warndlg('Your input number is over the limitation.');
    waitfor(h);
    set(hObject,'String',num2str(SD_LIMIT,'%5.1f'));
end

function edit_taper_strike_CreateFcn(hObject, eventdata, handles)
global TD_STR
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
TD_STR = 1.0;
set(hObject,'String',num2str(TD_STR,'%5.1f'));

%-------------------------------------------------------------------------
%     Taper distance along dip (textfield)
%-------------------------------------------------------------------------
function edit_taper_dip_Callback(hObject, eventdata, handles)
global TD_DIP DD_LIMIT
TD_DIP = str2num(get(hObject,'String'));
if TD_DIP > DD_LIMIT
    h = warndlg('Your input number is over the limitation.');
    waitfor(h);
    set(hObject,'String',num2str(DD_LIMIT,'%5.1f'));
end

% --- Executes during object creation, after setting all properties.
function edit_taper_dip_CreateFcn(hObject, eventdata, handles)
global TD_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
TD_DIP = 1.0;
set(hObject,'String',num2str(TD_DIP,'%5.1f'));

%-------------------------------------------------------------------------
%     Number of tapered faults (textfield)
%-------------------------------------------------------------------------
function edit_taper_num_Callback(hObject, eventdata, handles)
global TN
TN = str2num(get(hObject,'String'));
if TN <= 1
    h = warndlg('Put number larger than one.');
    waitfor(h);
    set(hObject,'String',num2str(2,'%3i'));    
end

function edit_taper_num_CreateFcn(hObject, eventdata, handles)
global TN
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
TN = 5;
set(hObject,'String',num2str(TN,'%3i'));

%-------------------------------------------------------------------------
%     Number of splitted faults along strike (textfield)
%-------------------------------------------------------------------------
function edit_nf_strike_Callback(hObject, eventdata, handles)
global N_STR
N_STR = str2num(get(hObject,'String'));

function edit_nf_strike_CreateFcn(hObject, eventdata, handles)
global N_STR
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
N_STR = int8(2);
set(hObject,'String',num2str(N_STR));

%-------------------------------------------------------------------------
%     Number of splitted faults along dip (textfield)
%-------------------------------------------------------------------------
function edit_nf_dip_Callback(hObject, eventdata, handles)
global N_DIP
N_DIP = str2num(get(hObject,'String'));

function edit_nf_dip_CreateFcn(hObject, eventdata, handles)
global N_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
N_DIP = int8(2);
set(hObject,'String',num2str(N_DIP));

%-------------------------------------------------------------------------
%     ADD (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_add_fault_Callback(hObject, eventdata, handles)
global FUNC_SWITCH
global COAST_DATA EQ_DATA AFAULT_DATA
global INUM
    INUM = INUM + 1;
	subfig_clear;
    FUNC_SWITCH = 1;
    grid_drawing;
    fault_overlay;
    if isempty(COAST_DATA) ~= 1 | isempty(EQ_DATA) ~= 1 | isempty(AFAULT_DATA) ~= 1
        hold on;
        overlay_drawing;
    end
    FUNC_SWITCH = 0; %reset
    flag = check_lonlat_info;
    if flag == 1
    set(findobj('Tag','menu_gridlines'),'Enable','On');
    set(findobj('Tag','menu_coastlines'),'Enable','On');
    set(findobj('Tag','menu_activefaults'),'Enable','On');
    set(findobj('Tag','menu_earthquakes'),'Enable','On'); 
    end
    calc_element;
    new_fault_mouse_clicks;

%-------------------------------------------------------------------------
%     Help (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_help_fposition_Callback(hObject, eventdata, handles)
cd slides
str = ['Help_fault_positioning.jpg'];
[x,imap] = imread(str);
if exist('x')==1
    figure('Menubar','none','NumberTitle','off');
    axes('Position',[0 0 1 1]);
    axis xy;
%    axis ij;
    image(x)
    drawnow
end
cd ..



