function varargout = earthquake_screening(varargin)
% EARTHQUAKE_SCREENING M-file for earthquake_screening.fig
%      EARTHQUAKE_SCREENING, by itself, creates a new EARTHQUAKE_SCREENING or raises the existing
%      singleton*.
%
%      H = EARTHQUAKE_SCREENING returns the handle to a new EARTHQUAKE_SCREENING or the handle to
%      the existing singleton*.
%
%      EARTHQUAKE_SCREENING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EARTHQUAKE_SCREENING.M with the given input arguments.
%
%      EARTHQUAKE_SCREENING('Property','Value',...) creates a new EARTHQUAKE_SCREENING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before earthquake_screening_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to earthquake_screening_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help earthquake_screening

% Last Modified by GUIDE v2.5 05-Dec-2006 10:51:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @earthquake_screening_OpeningFcn, ...
                   'gui_OutputFcn',  @earthquake_screening_OutputFcn, ...
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


%=========================================================================
%   Opening Function
%=========================================================================
function earthquake_screening_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to earthquake_screening (see VARARGIN)
% Choose default command line output for earthquake_screening
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% z map format
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2
global EQ_ZFORMAT_DATA MIN_EQ_TIME MAX_EQ_TIME
global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width

    h = findobj('Tag','earthquake_screening_window');
    j = get(h,'Position');
    wind_width = j(1,3);
    wind_height = j(1,4);
    xpos = SCRW_X;
    ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
    set(hObject,'Position',[xpos ypos wind_width wind_height]);

% --- Outputs from this function are returned to the command line.
function varargout = earthquake_screening_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%   Total number of shocks
%-------------------------------------------------------------------------
function edit_total_num_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_total_num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
[m,n] = size(EQ_ZFORMAT_DATA);
set(hObject,'String',num2str(m,'%6i')); % max 999,999 shocks

%-------------------------------------------------------------------------
%   Start time (Year) 
%-------------------------------------------------------------------------
function edit_s_yr_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%4i'));

%------------------------------- create function
function edit_s_yr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MIN_EQ_TIME
set(hObject,'String',num2str(MIN_EQ_TIME(1),'%4i'));
% z map format
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2

%-------------------------------------------------------------------------
%   Start time (Month) 
%-------------------------------------------------------------------------
function edit_s_mo_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_s_mo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MIN_EQ_TIME
set(hObject,'String',num2str(MIN_EQ_TIME(2),'%2i'));

%-------------------------------------------------------------------------
%   Start time (Day) 
%-------------------------------------------------------------------------
function edit_s_dy_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_s_dy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MIN_EQ_TIME
set(hObject,'String',num2str(MIN_EQ_TIME(3),'%2i'));

%-------------------------------------------------------------------------
%   Start time (Hour) 
%-------------------------------------------------------------------------
function edit_s_hr_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_s_hr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MIN_EQ_TIME
set(hObject,'String',num2str(MIN_EQ_TIME(4),'%2i'));

%-------------------------------------------------------------------------
%   Start time (Minute) 
%-------------------------------------------------------------------------
function edit_s_mn_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_s_mn_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MIN_EQ_TIME
set(hObject,'String',num2str(MIN_EQ_TIME(5),'%2i'));

%-------------------------------------------------------------------------
%   Finish time (Year) 
%-------------------------------------------------------------------------
function edit_f_yr_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%4i'));
% z map format
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2

%------------------------------- create function
function edit_f_yr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MAX_EQ_TIME
set(hObject,'String',num2str(MAX_EQ_TIME(1),'%4i'));

%-------------------------------------------------------------------------
%   Finish time (Month) 
%-------------------------------------------------------------------------
function edit_f_mo_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_f_mo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MAX_EQ_TIME
set(hObject,'String',num2str(MAX_EQ_TIME(2),'%2i'));

%-------------------------------------------------------------------------
%   Finish time (Day) 
%-------------------------------------------------------------------------
function edit_f_dy_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_f_dy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MAX_EQ_TIME
set(hObject,'String',num2str(MAX_EQ_TIME(3),'%2i'));

%-------------------------------------------------------------------------
%   Finish time (Hour) 
%-------------------------------------------------------------------------
function edit_f_hr_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_f_hr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MAX_EQ_TIME
set(hObject,'String',num2str(MAX_EQ_TIME(4),'%2i'));

%-------------------------------------------------------------------------
%   Finish time (Minute) 
%-------------------------------------------------------------------------
function edit_f_mn_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%2i'));

%------------------------------- create function
function edit_f_mn_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global MAX_EQ_TIME
set(hObject,'String',num2str(MAX_EQ_TIME(5),'%2i'));

%-------------------------------------------------------------------------
%   Min. Longitude
%-------------------------------------------------------------------------
function edit_minlon_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%8.3f'));

%------------------------------- create function
function edit_minlon_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(min(EQ_ZFORMAT_DATA(:,1)),'%8.3f'));

%-------------------------------------------------------------------------
%   Max. Longitude
%-------------------------------------------------------------------------
function edit_maxlon_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%8.3f'));

%------------------------------- create function
function edit_maxlon_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(max(EQ_ZFORMAT_DATA(:,1)),'%8.3f'));

%-------------------------------------------------------------------------
%   Min. Latitude
%-------------------------------------------------------------------------
function edit_minlat_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%7.3f'));

%------------------------------- create function
function edit_minlat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(min(EQ_ZFORMAT_DATA(:,2)),'%7.3f'));

%-------------------------------------------------------------------------
%   Max. Latitude
%-------------------------------------------------------------------------
function edit_maxlat_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%7.3f'));

%------------------------------- create function
function edit_maxlat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(max(EQ_ZFORMAT_DATA(:,2)),'%7.3f'));

%-------------------------------------------------------------------------
%   Min. Magnitude
%-------------------------------------------------------------------------
function edit_min_mag_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%3.1f'));

%------------------------------- create function
function edit_min_mag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(min(EQ_ZFORMAT_DATA(:,6)),'%3.1f'));

%-------------------------------------------------------------------------
%   Max. Magnitude
%-------------------------------------------------------------------------
function edit_max_mag_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%3.1f'));

%------------------------------- create function
function edit_max_mag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(max(EQ_ZFORMAT_DATA(:,6)),'%3.1f'));

%-------------------------------------------------------------------------
%   Min. Depth
%-------------------------------------------------------------------------
function edit_min_depth_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%6.2f'));

%------------------------------- create function
function edit_min_depth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(min(EQ_ZFORMAT_DATA(:,7)),'%6.2f'));

%-------------------------------------------------------------------------
%   Max. Depth
%-------------------------------------------------------------------------
function edit_max_depth_Callback(hObject, eventdata, handles)
x = str2num(get(hObject,'String'));
set(hObject,'String',num2str(x,'%6.2f'));
% z map format
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2
%------------------------------- create function
function edit_max_depth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global EQ_ZFORMAT_DATA
set(hObject,'String',num2str(max(EQ_ZFORMAT_DATA(:,7)),'%6.2f'));

%-------------------------------------------------------------------------
%   Cancel (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_cata_cancel_Callback(hObject, eventdata, handles)
global EQ_ZFORMAT_DATA
EQ_ZFORMAT_DATA = [];
set(findobj('Tag','menu_earthquakes'),'Checked','off');
delete(figure(gcf));

%-------------------------------------------------------------------------
%   pushbutton_cata_ok (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_cata_ok_Callback(hObject, eventdata, handles)
global EQ_ZFORMAT_DATA
global MIN_LON MAX_LON MIN_LAT MAX_LAT

m = size(EQ_ZFORMAT_DATA,1);
sec = zeros(m,1);
eq_datenum = zeros(m,1);
eq_datenum = datenum(EQ_ZFORMAT_DATA(:,3),EQ_ZFORMAT_DATA(:,4),...
    EQ_ZFORMAT_DATA(:,5),EQ_ZFORMAT_DATA(:,8),...
    EQ_ZFORMAT_DATA(:,9),sec);
syr = str2num(get(findobj('Tag','edit_s_yr'),'String'));
smo = str2num(get(findobj('Tag','edit_s_mo'),'String'));
sdy = str2num(get(findobj('Tag','edit_s_dy'),'String'));
shr = str2num(get(findobj('Tag','edit_s_hr'),'String'));
smn = str2num(get(findobj('Tag','edit_s_mn'),'String'));
mintime = datenum(syr,smo,sdy,shr,smn,0);
fyr = str2num(get(findobj('Tag','edit_f_yr'),'String'));
fmo = str2num(get(findobj('Tag','edit_f_mo'),'String'));
fdy = str2num(get(findobj('Tag','edit_f_dy'),'String'));
fhr = str2num(get(findobj('Tag','edit_f_hr'),'String'));
fmn = str2num(get(findobj('Tag','edit_f_mn'),'String'));
maxtime = datenum(fyr,fmo,fdy,fhr,fmn,0);
temp = [EQ_ZFORMAT_DATA eq_datenum];
% ===== z map format ===================================================
% 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min, 10)strike1, 11)dip1, 12)rake1,
% 13)strike2, 14)dip2, 15)rake2
% Now add 16) eq_datanum
dummyWidth = 0.000999;
minlon = str2double(get(findobj('Tag','edit_minlon'),'String')) - dummyWidth;
maxlon = str2double(get(findobj('Tag','edit_maxlon'),'String')) + dummyWidth;
minlat = str2double(get(findobj('Tag','edit_minlat'),'String')) - dummyWidth;
maxlat = str2double(get(findobj('Tag','edit_maxlat'),'String')) + dummyWidth;
minmag = str2double(get(findobj('Tag','edit_min_mag'),'String'));
maxmag = str2double(get(findobj('Tag','edit_max_mag'),'String'));
mindepth = str2double(get(findobj('Tag','edit_min_depth'),'String'));
maxdepth = str2double(get(findobj('Tag','edit_max_depth'),'String'));
% ----- screening process ------------------
sc1	 = find(temp(:,16) >= mintime & temp(:,16) <= maxtime);     % time sorting
sc2	 = find(temp(sc1,1) >= minlon & temp(sc1,1) <= maxlon &...  % catalog areal sorting
	temp(sc1,1) >= MIN_LON & temp(sc1,1) <= MAX_LON);
sc3	 = sc1(sc2);
sc4	 = find(temp(sc3,2) >= minlat & temp(sc3,2) <= maxlat &...  % study areal sorting
	temp(sc3,2) >= MIN_LAT & temp(sc3,2) <= MAX_LAT);
sc5	 = sc3(sc4);
sc6  = find(temp(sc5,7) >= mindepth & temp(sc5,7) <= maxdepth); % depth range sorting
sc7  = sc5(sc6);
sc8  = find(temp(sc7,6) >= minmag & temp(sc7,6) <= maxmag);     % magnitude range sorting
sc9  = sc7(sc8);
new_cat = temp(sc9,1:15);
% new_cat = temp(:,1:15);
% ------------------------------------------
try
    [mm,nn] = size(new_cat);
    EQ_ZFORMAT_DATA = zeros(mm,nn);
    EQ_ZFORMAT_DATA = new_cat;
catch
    EQ_ZFORMAT_DATA = [];
end
delete(figure(gcf));








