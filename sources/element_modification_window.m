function varargout = element_modification_window(varargin)
% ELEMENT_MODIFICATION_WINDOW M-file for element_modification_window.fig
%      ELEMENT_MODIFICATION_WINDOW, by itself, creates a new ELEMENT_MODIFICATION_WINDOW or raises the existing
%      singleton*.
%
%      H = ELEMENT_MODIFICATION_WINDOW returns the handle to a new ELEMENT_MODIFICATION_WINDOW or the handle to
%      the existing singleton*.
%
%      ELEMENT_MODIFICATION_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELEMENT_MODIFICATION_WINDOW.M with the given input arguments.
%
%      ELEMENT_MODIFICATION_WINDOW('Property','Value',...) creates a new ELEMENT_MODIFICATION_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before element_modification_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to element_modification_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help element_modification_window

% Last Modified by GUIDE v2.5 24-Aug-2010 17:57:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @element_modification_window_OpeningFcn, ...
                   'gui_OutputFcn',  @element_modification_window_OutputFcn, ...
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


% --- Executes just before element_modification_window is made visible.
function element_modification_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to element_modification_window (see VARARGIN)

% Choose default command line output for element_modification_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes element_modification_window wait for user response (see UIRESUME)
% uiwait(handles.figure_element_modification);


% --- Outputs from this function are returned to the command line.
function varargout = element_modification_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%   ELEMENT NUMBER  (textfield)
%-------------------------------------------------------------------------
function edit_md_number_Callback(hObject, eventdata, handles)
h = warndlg('Do not change this number');
waitfor(h);
return;

% --- Executes during object creation, after setting all properties.
function edit_md_number_CreateFcn(hObject, eventdata, handles)
global NSELECTED INUM
% hObject    handle to edit_md_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(NSELECTED,'%3i'));
INUM = NSELECTED;


%-------------------------------------------------------------------------
%   Start X  (textfield)
%-------------------------------------------------------------------------
function edit_md_startx_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    c = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(c,'%9.4f'));
    d = str2double(get(findobj('Tag','edit_md_starty'),'String'));
    e = lonlat2xy([c d]);
    ELEMENT(NSELECTED,1) = e(1);
else
    ELEMENT(NSELECTED,1) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(ELEMENT(NSELECTED,1),'%9.4f'));
end
flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
set(findobj('Tag','edit_md_length'),'String',num2str(flength,'%8.4f'));
calc_element;
set(findobj('Tag','edit_md_strike'),'String',num2str(ELE_STRIKE(NSELECTED),'%8.4f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_startx_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	a = xy2lonlat([ELEMENT(NSELECTED,1) ELEMENT(NSELECTED,2)]);
    set(hObject,'String',num2str(a(1),'%9.4f'));    
else
    set(hObject,'String',num2str(ELEMENT(NSELECTED,1),'%9.4f'));
end

%-------------------------------------------------------------------------
%   Start Y  (textfield)
%-------------------------------------------------------------------------
function edit_md_starty_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    c = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(c,'%9.4f'));
    d = str2double(get(findobj('Tag','edit_md_startx'),'String'));
    e = lonlat2xy([d c]);
    ELEMENT(NSELECTED,2) = e(2);
else
    ELEMENT(NSELECTED,2) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(ELEMENT(NSELECTED,2),'%9.4f'));
end
flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
set(findobj('Tag','edit_md_length'),'String',num2str(flength,'%8.4f'));
calc_element;
set(findobj('Tag','edit_md_strike'),'String',num2str(ELE_STRIKE(NSELECTED),'%8.4f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_starty_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	a = xy2lonlat([ELEMENT(NSELECTED,1) ELEMENT(NSELECTED,2)]);
    set(hObject,'String',num2str(a(2),'%9.4f')); 
else
    set(hObject,'String',num2str(ELEMENT(NSELECTED,2),'%9.4f'));
end

%-------------------------------------------------------------------------
%   Mouse click for Starting point  (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_md_mouse_start_Callback(hObject, eventdata, handles)
global H_MAIN ELEMENT NSELECTED ICOORD LON_GRID
%----------------------------------------
xy = zeros(2,1);
n = 0;
but = 1;
try
    while (but == 1 && n < 1)
        h = figure(H_MAIN);
        [xi,yi,but] = ginput(1);
        n = n+1;
        xy(:,n) = [xi;yi];
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            set(findobj('Tag','edit_md_startx'),'String',num2str(xy(1,1),'%9.4f'));
            set(findobj('Tag','edit_md_starty'),'String',num2str(xy(2,1),'%9.4f'));
            a = lonlat2xy([xy(1,1) xy(2,1)]);
            ELEMENT(NSELECTED,1) = a(1);
            ELEMENT(NSELECTED,2) = a(2);
        else
            ELEMENT(NSELECTED,1) = xy(1,1);
            ELEMENT(NSELECTED,2) = xy(2,1);
            set(findobj('Tag','edit_md_startx'),'String',num2str(ELEMENT(NSELECTED,1),'%9.4f'));
            set(findobj('Tag','edit_md_starty'),'String',num2str(ELEMENT(NSELECTED,2),'%9.4f'));
        end
        flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
        set(findobj('Tag','edit_md_length'),'String',num2str(flength,'%8.4f'));
        calc_element;
        set(findobj('Tag','edit_md_strike'),'String',num2str(ELE_STRIKE(NSELECTED),'%8.4f'));
    end
catch
    errordlg('Error. Try again.');
    return
end
update_seis_moment;
grid_refreshment;

%-------------------------------------------------------------------------
%   Finish X  (textfield)
%-------------------------------------------------------------------------
function edit_md_finishx_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    c = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(c,'%9.4f'));
    d = str2double(get(findobj('Tag','edit_md_finishy'),'String'));
    e = lonlat2xy([c d]);
    ELEMENT(NSELECTED,3) = e(1);
else
    ELEMENT(NSELECTED,3) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(ELEMENT(NSELECTED,3),'%9.4f'));
end
flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
set(findobj('Tag','edit_md_length'),'String',num2str(flength,'%8.4f'));
calc_element;
set(findobj('Tag','edit_md_strike'),'String',num2str(ELE_STRIKE(NSELECTED),'%8.4f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_finishx_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	a = xy2lonlat([ELEMENT(NSELECTED,3) ELEMENT(NSELECTED,4)]);
    set(hObject,'String',num2str(a(1),'%9.4f'));   
else
    set(hObject,'String',num2str(ELEMENT(NSELECTED,3),'%9.4f'));
end


%-------------------------------------------------------------------------
%   Finish Y  (textfield)
%-------------------------------------------------------------------------
function edit_md_finishy_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    c = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(c,'%9.4f'));
    d = str2double(get(findobj('Tag','edit_md_finishx'),'String'));
    e = lonlat2xy([d c]);
    ELEMENT(NSELECTED,4) = e(2);
else
    ELEMENT(NSELECTED,4) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(ELEMENT(NSELECTED,4),'%9.4f'));
end
flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
set(findobj('Tag','edit_md_length'),'String',num2str(flength,'%8.4f'));
calc_element;
set(findobj('Tag','edit_md_strike'),'String',num2str(ELE_STRIKE(NSELECTED),'%8.4f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_finishy_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
	a = xy2lonlat([ELEMENT(NSELECTED,3) ELEMENT(NSELECTED,4)]);
    set(hObject,'String',num2str(a(2),'%9.4f'));
else
    set(hObject,'String',num2str(ELEMENT(NSELECTED,4),'%9.4f'));
end

%-------------------------------------------------------------------------
%   Mouse click for Finishing point  (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_md_mouse_finish_Callback(hObject, eventdata, handles)
global H_MAIN ELEMENT NSELECTED ICOORD LON_GRID
%----------------------------------------
xy = zeros(2,1);
n = 0;
but = 1;
try
    while (but == 1 && n < 1)
        h = figure(H_MAIN);
        [xi,yi,but] = ginput(1);
        n = n+1;
        xy(:,n) = [xi;yi];
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            set(findobj('Tag','edit_md_finishx'),'String',num2str(xy(1,1),'%9.4f'));
            set(findobj('Tag','edit_md_finishy'),'String',num2str(xy(2,1),'%9.4f'));
            a = lonlat2xy([xy(1,1) xy(2,1)]);
            ELEMENT(NSELECTED,3) = a(1);
            ELEMENT(NSELECTED,4) = a(2);
        else
            ELEMENT(NSELECTED,3) = xy(1,1);
            ELEMENT(NSELECTED,4) = xy(2,1);
            set(findobj('Tag','edit_md_finishx'),'String',num2str(ELEMENT(NSELECTED,3),'%9.4f'));
            set(findobj('Tag','edit_md_finishy'),'String',num2str(ELEMENT(NSELECTED,4),'%9.4f'));
        end
        flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
        set(findobj('Tag','edit_md_length'),'String',num2str(flength,'%8.4f'));
        calc_element;
        set(findobj('Tag','edit_md_strike'),'String',num2str(ELE_STRIKE(NSELECTED),'%8.4f'));
    end
catch
    errordlg('Error. Try again.');
    return
end
update_seis_moment;
grid_refreshment;

%-------------------------------------------------------------------------
%   Right-lat slip  (textfield)
%-------------------------------------------------------------------------
function edit_md_rightslip_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT IRAKE IND_RAKE
if IRAKE==1  % rake here
    netslip = sqrt(ELEMENT(NSELECTED,5)^2+ELEMENT(NSELECTED,6)^2);
    IND_RAKE(NSELECTED) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(IND_RAKE(NSELECTED),'%5.1f'));
    [ELEMENT(NSELECTED,5) ELEMENT(NSELECTED,6)] = rake2comp(IND_RAKE(NSELECTED),netslip);
else
    ELEMENT(NSELECTED,5) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(ELEMENT(NSELECTED,5),'%7.3f'));
end
update_seis_moment;

% --- Executes during object creation, after setting all properties.
function edit_md_rightslip_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT IRAKE IND_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if IRAKE==1  % rake here
% 	try
        set(hObject,'String',num2str(IND_RAKE(NSELECTED),'%5.1f'));
%     catch
%         [rake dummy] = comp2rake(ELEMENT(NSELECTED,5),ELEMENT(NSELECTED,6));
%         set(hObject,'String',num2str(rake,'%5.1f'));
%     end
else
    set(hObject,'String',num2str(ELEMENT(NSELECTED,5),'%7.3f'));
end


%-------------------------------------------------------------------------
%   Reverse slip  (textfield)
%-------------------------------------------------------------------------
function edit_md_revslip_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT IRAKE IND_RAKE
if IRAKE==1  % rake here
%    netslip = sqrt(ELEMENT(NSELECTED,5)^2+ELEMENT(NSELECTED,6)^2);
    netslip = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(netslip,'%7.3f'));
    [ELEMENT(NSELECTED,5) ELEMENT(NSELECTED,6)] = rake2comp(IND_RAKE(NSELECTED),netslip);    
else
    ELEMENT(NSELECTED,6) = str2double(get(hObject,'String'));
    set(hObject,'String',num2str(ELEMENT(NSELECTED,6),'%7.3f'));
end
update_seis_moment;

% --- Executes during object creation, after setting all properties.
function edit_md_revslip_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT IRAKE IND_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if IRAKE==1
    [dummy netslip] = comp2rake(ELEMENT(NSELECTED,5),ELEMENT(NSELECTED,6));
    set(hObject,'String',num2str(netslip,'%7.3f'));    
else
    set(hObject,'String',num2str(ELEMENT(NSELECTED,6),'%7.3f'));
end

%-------------------------------------------------------------------------
%   Strike-slip label  (static text)
%-------------------------------------------------------------------------
function text_element_md_lat_CreateFcn(hObject, eventdata, handles)
global IRAKE NSELECTED
if IRAKE == 1
    set(hObject,'String','Rake (‹)');
else
	set(hObject,'String','Right-lat. slip(m)');
end

%-------------------------------------------------------------------------
%   Dip-slip label  (static text)
%-------------------------------------------------------------------------
function text_element_md_rev_CreateFcn(hObject, eventdata, handles)
global IRAKE NSELECTED
if IRAKE == 1
    set(hObject,'String','Net slip (m)');
else
	set(hObject,'String','Reverse slip(m)');
end


%-------------------------------------------------------------------------
%   Dip  (textfield)
%-------------------------------------------------------------------------
function edit_md_dip_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT
ELEMENT(NSELECTED,7) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(NSELECTED,7),'%4.1f'));

hfault = ELEMENT(NSELECTED,9) - ELEMENT(NSELECTED,8);
wfault = hfault / sin(deg2rad(ELEMENT(NSELECTED,7)));
set(findobj('Tag','edit_md_width'),'String',num2str(wfault,'%5.2f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_dip_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(NSELECTED,7),'%4.1f'));

%-------------------------------------------------------------------------
%   Top depth  (textfield)
%-------------------------------------------------------------------------
function edit_md_top_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT
x = str2double(get(hObject,'String'));
if x < 0.0 || x >= ELEMENT(NSELECTED,9)
    h = errordlg('Unrealistic value. No negative & no over bottom depth.');
    waitfor(h);
%    return;
else
    ELEMENT(NSELECTED,8) = x;
end
set(hObject,'String',num2str(ELEMENT(NSELECTED,8),'%6.2f'));

hfault = ELEMENT(NSELECTED,9) - ELEMENT(NSELECTED,8);
wfault = hfault / sin(deg2rad(ELEMENT(NSELECTED,7)));
set(findobj('Tag','edit_md_width'),'String',num2str(wfault,'%5.2f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_top_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(NSELECTED,8),'%6.2f'));

%-------------------------------------------------------------------------
%   Bottom depth  (textfield)
%-------------------------------------------------------------------------
function edit_md_bottom_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT
ELEMENT(NSELECTED,9) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(ELEMENT(NSELECTED,9),'%6.2f'));

hfault = ELEMENT(NSELECTED,9) - ELEMENT(NSELECTED,8);
wfault = hfault / sin(deg2rad(ELEMENT(NSELECTED,7)));
set(findobj('Tag','edit_md_width'),'String',num2str(wfault,'%5.2f'));
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_bottom_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELEMENT(NSELECTED,9),'%6.2f'));


%-------------------------------------------------------------------------
%   Fault Length  (textedit)
%-------------------------------------------------------------------------
function edit_md_length_Callback(hObject, eventdata, handles)
global NSELECTED ELEMENT ICOORD LON_GRID
flength = str2double(get(hObject,'String'));
set(hObject,'String',num2str(flength,'%6.2f'));
fstrike = str2double(get(findobj('Tag','edit_md_strike'),'String'));
x = get(findobj('Tag','radiobutton_md_start'),'Value');
if x == 1
    ELEMENT(NSELECTED,3) = ELEMENT(NSELECTED,1) + sin(deg2rad(fstrike)) * flength;
    ELEMENT(NSELECTED,4) = ELEMENT(NSELECTED,2) + cos(deg2rad(fstrike)) * flength;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([ELEMENT(NSELECTED,3) ELEMENT(NSELECTED,4)]);
        set(findobj('Tag','edit_md_finishx'),'String',num2str(a(1),'%7.2f'));
        set(findobj('Tag','edit_md_finishy'),'String',num2str(a(2),'%7.2f'));
    else
        set(findobj('Tag','edit_md_finishx'),'String',num2str(ELEMENT(NSELECTED,3),'%7.2f'));
        set(findobj('Tag','edit_md_finishy'),'String',num2str(ELEMENT(NSELECTED,4),'%7.2f'));
    end
else
    ELEMENT(NSELECTED,1) = ELEMENT(NSELECTED,3) - sin(deg2rad(fstrike)) * flength;
    ELEMENT(NSELECTED,2) = ELEMENT(NSELECTED,4) - cos(deg2rad(fstrike)) * flength;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([ELEMENT(NSELECTED,1) ELEMENT(NSELECTED,2)]);
        set(findobj('Tag','edit_md_startx'),'String',num2str(a(1),'%7.2f'));
        set(findobj('Tag','edit_md_starty'),'String',num2str(a(2),'%7.2f'));
    else
        set(findobj('Tag','edit_md_startx'),'String',num2str(ELEMENT(NSELECTED,1),'%7.2f'));
        set(findobj('Tag','edit_md_starty'),'String',num2str(ELEMENT(NSELECTED,2),'%7.2f'));
    end
end
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_length_CreateFcn(hObject, eventdata, handles)
global NSELECTED ELEMENT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
flength = sqrt((ELEMENT(NSELECTED,1)-ELEMENT(NSELECTED,3))^2+(ELEMENT(NSELECTED,2)-ELEMENT(NSELECTED,4))^2);
set(hObject,'String',num2str(flength,'%6.2f'));

%-------------------------------------------------------------------------
%   Fault Strike  (textedit)
%-------------------------------------------------------------------------
function edit_md_strike_Callback(hObject, eventdata, handles)
global ELEMENT NSELECTED ELE_STRIKE ICOORD LON_GRID
ELE_STRIKE(NSELECTED) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(ELE_STRIKE(NSELECTED),'%6.2f'));

flength = str2double(get(findobj('Tag','edit_md_length'),'String'));
x = get(findobj('Tag','radiobutton_md_start'),'Value');
if x == 1
    ELEMENT(NSELECTED,3) = ELEMENT(NSELECTED,1) + sin(deg2rad(ELE_STRIKE(NSELECTED))) * flength;
    ELEMENT(NSELECTED,4) = ELEMENT(NSELECTED,2) + cos(deg2rad(ELE_STRIKE(NSELECTED))) * flength;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([ELEMENT(NSELECTED,3) ELEMENT(NSELECTED,4)]);
        set(findobj('Tag','edit_md_finishx'),'String',num2str(a(1),'%7.2f'));
        set(findobj('Tag','edit_md_finishy'),'String',num2str(a(2),'%7.2f'));        
    else
        set(findobj('Tag','edit_md_finishx'),'String',num2str(ELEMENT(NSELECTED,3),'%7.2f'));
        set(findobj('Tag','edit_md_finishy'),'String',num2str(ELEMENT(NSELECTED,4),'%7.2f'));
    end
else
    ELEMENT(NSELECTED,1) = ELEMENT(NSELECTED,3) - sin(deg2rad(ELE_STRIKE(NSELECTED))) * flength;
    ELEMENT(NSELECTED,2) = ELEMENT(NSELECTED,4) - cos(deg2rad(ELE_STRIKE(NSELECTED))) * flength;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        a = xy2lonlat([ELEMENT(NSELECTED,1) ELEMENT(NSELECTED,2)]);
        set(findobj('Tag','edit_md_startx'),'String',num2str(a(1),'%7.2f'));
        set(findobj('Tag','edit_md_starty'),'String',num2str(a(2),'%7.2f'));  
    else
        set(findobj('Tag','edit_md_startx'),'String',num2str(ELEMENT(NSELECTED,1),'%7.2f'));
        set(findobj('Tag','edit_md_starty'),'String',num2str(ELEMENT(NSELECTED,2),'%7.2f'));
    end
end
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_strike_CreateFcn(hObject, eventdata, handles)
global ELEMENT NSELECTED ELE_STRIKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(ELE_STRIKE(NSELECTED),'%6.2f'));


%-------------------------------------------------------------------------
%   Fault Width  (textedit)
%-------------------------------------------------------------------------
function edit_md_width_Callback(hObject, eventdata, handles)
global ELEMENT NSELECTED
wfault = str2double(get(hObject,'String'));
set(hObject,'String',num2str(wfault,'%5.2f'));
dfault = str2double(get(findobj('Tag','edit_md_dip'),'String'));
hfault = sin(deg2rad(dfault)) * wfault;
% x = get(findobj('Tag','radiobutton_md_start'),'Value');
% if x == 1
    ELEMENT(NSELECTED,9) = ELEMENT(NSELECTED,8) + hfault;
    set(findobj('Tag','edit_md_bottom'),'String',num2str(ELEMENT(NSELECTED,9),'%6.2f'));
% else
%     ELEMENT(NSELECTED,8) = ELEMENT(NSELECTED,9) - hfault;
%     set(findobj('Tag','edit_md_top'),'String',num2str(ELEMENT(NSELECTED,8),'%6.2f')); 
% end
update_seis_moment;
grid_refreshment;

% --- Executes during object creation, after setting all properties.
function edit_md_width_CreateFcn(hObject, eventdata, handles)
global ELEMENT NSELECTED
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
hfault = ELEMENT(NSELECTED,9) - ELEMENT(NSELECTED,8);
wfault = hfault / sin(deg2rad(ELEMENT(NSELECTED,7)));
set(hObject,'String',num2str(wfault,'%5.2f'));


%-------------------------------------------------------------------------
%   Fix starting/top point  (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_md_start_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
if x==1
    set(findobj('Tag','radiobutton_md_finish'),'Value',0);
    set(hObject,'Value',1);
end


%-------------------------------------------------------------------------
%   Fix finishin/bottom point  (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_md_finish_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
if x==1
    set(findobj('Tag','radiobutton_md_start'),'Value',0);
    set(hObject,'Value',1);
end


%-------------------------------------------------------------------------
%   pushbutton_element_OK with typing  (pushbutton)
%-------------------------------------------------------------------------
% --- Executes on button press in pushbutton_element_OK.
function pushbutton_element_OK_Callback(hObject, eventdata, handles)

% Do all calculations
calc_element;
h = figure(gcf);
delete(h);


%-------------------------------------------------------------------------
%   Update Mo & Mw (internal function)
%-------------------------------------------------------------------------
function update_seis_moment
global ELEMENT NSELECTED POIS YOUNG
[mo,mw] = calc_seis_moment(ELEMENT(NSELECTED,1),ELEMENT(NSELECTED,2),ELEMENT(NSELECTED,3),...
    ELEMENT(NSELECTED,4),ELEMENT(NSELECTED,5),ELEMENT(NSELECTED,6),ELEMENT(NSELECTED,7),...
    ELEMENT(NSELECTED,8),ELEMENT(NSELECTED,9),POIS,YOUNG);
set(findobj('Tag','text_md_mo'),'String',num2str(mo,'%3.1e'));
set(findobj('Tag','text_md_mw'),'String',num2str(mw,'%3.1f'));


%-------------------------------------------------------------------------
%   Update grid window (internal function)
%-------------------------------------------------------------------------
function grid_refreshment
global FUNC_SWITCH COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
global H_ELEMENT_MOD
subfig_clear;
FUNC_SWITCH = 1;
grid_drawing;
fault_overlay;
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing;
    end
%end
FUNC_SWITCH = 0; %reset
flag = check_lonlat_info;
if flag == 1
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');
set(findobj('Tag','menu_gps'),'Enable','On'); 
set(findobj('Tag','menu_annotations'),'Enable','On'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','On');
set(findobj('Tag','menu_trace_put_faults'),'Enable','On');     
end
try
    figure(H_ELEMENT_MOD);
catch
    return
end

%-------------------------------------------------------------------------
%   Update grid window OK (internal function)
%-------------------------------------------------------------------------
% to close the H_ELEMENT_MOD window... The last line of
% 'grid_refreshment'function is simply removed to avoid a simple error
function grid_refreshment_ok
global FUNC_SWITCH COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
global H_ELEMENT_MOD
subfig_clear;
FUNC_SWITCH = 1;
grid_drawing;
fault_overlay;
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing;
    end
%end
FUNC_SWITCH = 0; %reset
flag = check_lonlat_info;
if flag == 1
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');
set(findobj('Tag','menu_gps'),'Enable','On'); 
set(findobj('Tag','menu_annotations'),'Enable','On'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','On');
set(findobj('Tag','menu_trace_put_faults'),'Enable','On');     
end

%-------------------------------------------------------------------------
%   Delete fault (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_delete_fault_Callback(hObject, eventdata, handles)
global NUM ELEMENT FCOMMENT KODE NSELECTED H_ELEMENT_MOD
button = questdlg('Are you sure to delete this fault?','Delete?','Yes','No','Cancel');
if strcmp(button,'Yes')
    NUM = NUM - 1;
    if NUM == 0
        errordlg('Keep at least one fault in the study area.');
        NUM = 1;
        return;
    else
        ELEMENT(NSELECTED,:)=[];
        KODE(NSELECTED)=[];
        FCOMMENT(NSELECTED).ref=[];
%         ELEMENT(NSELECTED:end-1,:) = ELEMENT(NSELECTED+1:end,:);
%         KODE(NSELECTED:end-1) = KODE(NSELECTED+1:end);
%         FCOMMENT(NSELECTED:end-1) = FCOMMENT(NSELECTED+1:end)
    end
    if (isempty(findobj('Tag','figure_element_modification'))~=1 && isempty(H_ELEMENT_MOD)~=1)
    close(figure(H_ELEMENT_MOD))
    H_ELEMENT_MOD = [];
    end
else
    return;
end


%-------------------------------------------------------------------------
%   Taper/subdivide (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_taper_subdivide_Callback(hObject, eventdata, handles)
global H_ELEMENT TAPER_CALLED H_ELEMENT_MOD

% if (isempty(findobj('Tag','figure_element_modification'))~=1 && isempty(H_ELEMENT_MOD)~=1)
%    close(figure(H_ELEMENT_MOD))
%    H_ELEMENT_MOD = [];
% end

H_ELEMENT = element_input_window;
TAPER_CALLED = 1;







