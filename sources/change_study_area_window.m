function varargout = change_study_area_window(varargin)
% CHANGE_STUDY_AREA_WINDOW M-file for change_study_area_window.fig
%      CHANGE_STUDY_AREA_WINDOW, by itself, creates a new CHANGE_STUDY_AREA_WINDOW or raises the existing
%      singleton*.
%
%      H = CHANGE_STUDY_AREA_WINDOW returns the handle to a new CHANGE_STUDY_AREA_WINDOW or the handle to
%      the existing singleton*.
%
%      CHANGE_STUDY_AREA_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANGE_STUDY_AREA_WINDOW.M with the given input arguments.
%
%      CHANGE_STUDY_AREA_WINDOW('Property','Value',...) creates a new CHANGE_STUDY_AREA_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before change_study_area_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to change_study_area_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help change_study_area_window

% Last Modified by GUIDE v2.5 07-Aug-2007 15:04:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @change_study_area_window_OpeningFcn, ...
                   'gui_OutputFcn',  @change_study_area_window_OutputFcn, ...
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


% --- Executes just before change_study_area_window is made visible.
function change_study_area_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to change_study_area_window (see VARARGIN)

% Choose default command line output for change_study_area_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global TEMP_ELEMENT NUM ELEMENT TEMP_GRID GRID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global MIN_LON MAX_LON MIN_LAT MAX_LAT
% to keep original data
TEMP_ELEMENT = zeros(NUM,4,'double');
TEMP_GRID    = zeros(6,1,'double');
TEMP_ELEMENT(:,1:2) = xy2lonlat([ELEMENT(:,1) ELEMENT(:,2)]);
TEMP_ELEMENT(:,3:4) = xy2lonlat([ELEMENT(:,3) ELEMENT(:,4)]);
TEMP_GRID    = GRID;
TEMP_MINLON = MIN_LON;
TEMP_MAXLON = MAX_LON;
TEMP_MINLAT = MIN_LAT;
TEMP_MAXLAT = MAX_LAT;

% --- Outputs from this function are returned to the command line.
function varargout = change_study_area_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%   MIN LON / MIN X (textfield)
%-------------------------------------------------------------------------
function edit_minlon_rev_Callback(hObject, eventdata, handles)
global TEMP_MINLON ICOORD LON_GRID TEMP_GRID
global TEMP_MINLAT TEMP_MAXLAT GRID MIN_LON
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    x = str2double(get(hObject,'String'));
        a1 = lonlat2xy([x TEMP_MINLAT]);
        a2 = lonlat2xy([x TEMP_MAXLAT]);
    GRID(1) = (a1(1) + a2(1))/2.0;
    MIN_LON = x;
    set(hObject,'String',num2str(MIN_LON,'%8.3f'));
else
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([x TEMP_GRID(2)]);
        a2 = xy2lonlat([x TEMP_GRID(4)]);
        MIN_LON = (a1(1) + a2(1))/2.0;
    end
	GRID(1) = x;
    set(hObject,'String',num2str(GRID(1),'%8.3f'));
end

% --- Executes during object creation, after setting all properties.
function edit_minlon_rev_CreateFcn(hObject, eventdata, handles)
global TEMP_MINLON MIN_LON GRID ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MIN_LON,'%8.3f'));
    TEMP_MINLON = MIN_LON;
else
    set(hObject,'String',num2str(GRID(1),'%8.3f'));
end

%-------------------------------------------------------------------------
%   MAX LON / MAX X (textfield)
%-------------------------------------------------------------------------
function edit_maxlon_rev_Callback(hObject, eventdata, handles)
global TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global GRID ICOORD LON_GRID TEMP_GRID MAX_LON
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    x = str2double(get(hObject,'String'));
        a1 = lonlat2xy([x TEMP_MINLAT]);
        a2 = lonlat2xy([x TEMP_MAXLAT]);
    GRID(3) = (a1(1) + a2(1))/2.0;
    MAX_LON = x;
    set(hObject,'String',num2str(MAX_LON,'%8.3f'));
else
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([x TEMP_GRID(2)]);
        a2 = xy2lonlat([x TEMP_GRID(4)]);
        MAX_LON = (a1(1) + a2(1))/2.0;
    end
    GRID(3) = x;
    set(hObject,'String',num2str(GRID(3),'%8.3f'));
end

% --- Executes during object creation, after setting all properties.
function edit_maxlon_rev_CreateFcn(hObject, eventdata, handles)
global TEMP_MAXLON MAX_LON GRID ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MAX_LON,'%8.3f'));
    TEMP_MAXLON = MAX_LON;
else
    set(hObject,'String',num2str(GRID(3),'%8.3f'));    
end

%-------------------------------------------------------------------------
%   MIN LAT / MIN Y (textfield)
%-------------------------------------------------------------------------
function edit_minlat_rev_Callback(hObject, eventdata, handles)
global TEMP_MINLAT GRID ICOORD LON_GRID TEMP_GRID
global TEMP_MINLON TEMP_MAXLON MIN_LAT
if ICOORD == 2 && isempty(LON_GRID) ~= 1
        x = str2double(get(hObject,'String'));
        a1 = lonlat2xy([TEMP_MINLON x]);
        a2 = lonlat2xy([TEMP_MAXLON x]);
        GRID(2) = (a1(2) + a2(2))/2.0;
    MIN_LAT = x;
    set(hObject,'String',num2str(MIN_LAT,'%8.3f'));
else
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([TEMP_GRID(1) x]);
        a2 = xy2lonlat([TEMP_GRID(3) x]);
        MIN_LAT = (a1(2) + a2(2))/2.0;
    end
    GRID(2) = x;
    set(hObject,'String',num2str(GRID(2),'%8.3f'));
end

% --- Executes during object creation, after setting all properties.
function edit_minlat_rev_CreateFcn(hObject, eventdata, handles)
global TEMP_MINLAT MIN_LAT GRID ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MIN_LAT,'%8.3f'));
    TEMP_MINLAT = MIN_LAT;
else
    set(hObject,'String',num2str(GRID(2),'%8.3f'));
end

%-------------------------------------------------------------------------
%   MAX LAT / MAX Y (textfield)
%-------------------------------------------------------------------------
function edit_maxlat_rev_Callback(hObject, eventdata, handles)
global TEMP_MAXLAT TEMP_MINLON TEMP_MAXLON
global GRID ICOORD LON_GRID TEMP_GRID MAX_LAT
if ICOORD == 2 && isempty(LON_GRID) ~= 1
        x = str2double(get(hObject,'String'));
        a1 = lonlat2xy([TEMP_MINLON x]);
        a2 = lonlat2xy([TEMP_MAXLON x]);
        GRID(4) = (a1(2) + a2(2))/2.0;
    MAX_LAT = x;
    set(hObject,'String',num2str(MAX_LAT,'%8.3f'));
else   
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([TEMP_GRID(1) x]);
        a2 = xy2lonlat([TEMP_GRID(3) x]);
        MAX_LAT = (a1(2) + a2(2))/2.0;
    end
    GRID(4) = x;
    set(hObject,'String',num2str(GRID(4),'%8.3f'));
end

% --- Executes during object creation, after setting all properties.
function edit_maxlat_rev_CreateFcn(hObject, eventdata, handles)
global TEMP_MAXLAT MAX_LAT GRID ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MAX_LAT,'%8.3f'));
    TEMP_MAXLAT = MAX_LAT;
else
    set(hObject,'String',num2str(GRID(4),'%8.3f'));
end

%-------------------------------------------------------------------------
%   OK (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_ok_rev_Callback(hObject, eventdata, handles)
global ELEMENT KODE NUM FCOMMENT
global MIN_LON MAX_LON MIN_LAT MAX_LAT
global TEMP_ELEMENT GRID ID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT TEMP_GRID
global ICOORD LON_GRID IND_RAKE

button = questdlg('Remove fault elements info out of the new area?','Remove fault?','Yes',...
    'No','default');
if strcmp(button,'No')
    h = figure(gcf);
    delete(h);
elseif strcmp(button,'Yes')    
    flag = zeros(NUM,1,'int8');
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        for k = 1:NUM
            a = (TEMP_ELEMENT(k,2)-TEMP_ELEMENT(k,4))/(TEMP_ELEMENT(k,1)-TEMP_ELEMENT(k,3));
            b = TEMP_ELEMENT(k,2) - a * TEMP_ELEMENT(k,1);
            x1 = TEMP_MINLON;           y1 = a * TEMP_MINLON + b;
            x2 = TEMP_MAXLON;           y2 = a * TEMP_MAXLON + b;
            x3 = (TEMP_MINLAT - b) / a; y3 = TEMP_MINLAT;
            x4 = (TEMP_MAXLAT - b) / a; y4 = TEMP_MAXLAT;
            if TEMP_ELEMENT(k,1) <= TEMP_MAXLON && TEMP_ELEMENT(k,1) >= TEMP_MINLON...
                    && TEMP_ELEMENT(k,2) <= TEMP_MAXLAT && TEMP_ELEMENT(k,2) >= TEMP_MINLAT
                flag(k) = 1;
                continue;
            elseif TEMP_ELEMENT(k,3) <= TEMP_MAXLON && TEMP_ELEMENT(k,3) >= TEMP_MINLON...
                    && TEMP_ELEMENT(k,4) <= TEMP_MAXLAT && TEMP_ELEMENT(k,4) >= TEMP_MINLAT
                flag(k) = 1;
                continue;
            elseif y1 <= TEMP_ELEMENT(k,4) && y1 >= TEMP_ELEMENT(k,2)...
                    && x1 <= TEMP_ELEMENT(k,3) && x1 >= TEMP_ELEMENT(k,1)
                flag(k) = 1;
                continue;
            elseif y2 <= TEMP_ELEMENT(k,4) && y2 >= TEMP_ELEMENT(k,2)...
                    && x2 <= TEMP_ELEMENT(k,3) && x2 >= TEMP_ELEMENT(k,1)
                flag(k) = 1;
                continue;
            elseif y3 <= TEMP_ELEMENT(k,4) && y3 >= TEMP_ELEMENT(k,2)...
                    && x3 <= TEMP_ELEMENT(k,3) && x3 >= TEMP_ELEMENT(k,1)
                flag(k) = 1;
                continue;
            elseif y4 <= TEMP_ELEMENT(k,4) && y4 >= TEMP_ELEMENT(k,2)...
                    && x4 <= TEMP_ELEMENT(k,3) && x4 >= TEMP_ELEMENT(k,1)
                flag(k) = 1;
                continue;
            end
        end
    else % for XY grid (Cartesian coordinates)
        for k = 1:NUM
            a = (ELEMENT(k,2)-ELEMENT(k,4))/(ELEMENT(k,1)-ELEMENT(k,3));
            b = ELEMENT(k,2) - a * ELEMENT(k,1);
            x1 = GRID(1);           y1 = a * GRID(1) + b;
            x2 = GRID(3);           y2 = a * GRID(3) + b;
            x3 = (GRID(2) - b) / a; y3 = GRID(2);
            x4 = (GRID(4) - b) / a; y4 = GRID(4);
            if ELEMENT(k,1) <= GRID(3) && ELEMENT(k,1) >= GRID(1)...
                    && ELEMENT(k,2) <= GRID(4) && ELEMENT(k,2) >= GRID(2)
                flag(k) = 1;
                continue;
            elseif ELEMENT(k,3) <= GRID(3) && ELEMENT(k,3) >= GRID(1)...
                    && ELEMENT(k,4) <= GRID(4) && ELEMENT(k,4) >= GRID(2)
                flag(k) = 1;
                continue;
            elseif y1 <= ELEMENT(k,4) && y1 >= ELEMENT(k,2)...
                    && x1 <= ELEMENT(k,3) && x1 >= ELEMENT(k,1)
                flag(k) = 1;
                continue;
            elseif y2 <= ELEMENT(k,4) && y2 >= ELEMENT(k,2)...
                    && x2 <= ELEMENT(k,3) && x2 >= ELEMENT(k,1)
                flag(k) = 1;
                continue;
            elseif y3 <= ELEMENT(k,4) && y3 >= ELEMENT(k,2)...
                    && x3 <= ELEMENT(k,3) && x3 >= ELEMENT(k,1)
                flag(k) = 1;
                continue;
            elseif y4 <= ELEMENT(k,4) && y4 >= ELEMENT(k,2)...
                    && x4 <= ELEMENT(k,3) && x4 >= ELEMENT(k,1)
                flag(k) = 1;
                continue;
            end
        end
    end
num_new = sum(flag);
kode_new = zeros(num_new,1,'int16');
id_new = zeros(num_new,1,'int16');
element_new = zeros(num_new,9,'double');
fcomment_new = struct('ref',[]);
if ~isempty(IND_RAKE)
    ind_rake_new = zeros(num_new,1,'double');
end
count = 0;
for k = 1:NUM
        if flag(k)==1
            count = count + 1;
            kode_new(count) = KODE(k);
            id_new(count) = ID(k);
            element_new(count,:) = ELEMENT(k,:);
            if ~isempty(IND_RAKE)
                ind_rake_new(count) = IND_RAKE(k);
            end
            fcomment_new(count).ref = FCOMMENT(k).ref;
        end
end
KODE = zeros(num_new,1,'int16');
KODE = kode_new;
ID = zeros(num_new,1,'int16');
ID = id_new;
ELEMENT = zeros(num_new,9,'double');
ELEMENT = element_new;
if ~isempty(IND_RAKE)
    IND_RAKE = zeros(num_new,1,'double');
    IND_RAKE = ind_rake_new;
end
FCOMMENT = struct('ref',[]);
FCOMMENT = fcomment_new;
% FCOMMENT(1:num_new).ref = fcomment_new(1:num_new).ref;

NUM = num_new;

h = figure(gcf);
delete(h);
end

%-------------------------------------------------------------------------
%   Cancel (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_cancel_rev_Callback(hObject, eventdata, handles)
global TEMP_ELEMENT NUM ELEMENT TEMP_GRID GRID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global MIN_LON MAX_LON MIN_LAT MAX_LAT
% to return original data
GRID    = TEMP_GRID;
MIN_LON = TEMP_MINLON;
MAX_LON = TEMP_MAXLON;
MIN_LAT = TEMP_MINLAT;
MAX_LAT = TEMP_MAXLAT;
% TEMP_ELEMENT(:,1:2) = xy2lonlat([ELEMENT(:,1) ELEMENT(:,2)]);
% TEMP_ELEMENT(:,3:4) = xy2lonlat([ELEMENT(:,3) ELEMENT(:,4)]);
h = figure(gcf);
delete(h);

