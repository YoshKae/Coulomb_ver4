function varargout = utm_window(varargin)
% UTM_WINDOW M-file for utm_window.fig
% この関数は、UTM座標に関連する入力を管理するためのGUIウィンドウを作成します。

% 初期化コードの開始 -このコードは編集しないでください--------------------------------
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @utm_window_OpeningFcn, ...
                   'gui_OutputFcn',  @utm_window_OutputFcn, ...
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
% 初期化コードの終了 - このコードは編集しないでください-------------------------------


% --- utm_windowが表示される前に実行されます。
function utm_window_OpeningFcn(hObject, eventdata, handles, varargin)
% UTMウィンドウが表示される前に実行される初期化関数。
% この関数は、ウィンドウがスクリーンの中央に配置されるようにします。

global ZERO_LON ZERO_LAT MIN_LON MAX_LON MIN_LAT MAX_LAT
global XS YS XF YF
global SCRS SCRW_X SCRW_Y % スクリーンサイズと幅を管理するグローバル変数

% ウィンドウの位置とサイズを設定
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
    h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% UTMウィンドウのデフォルトのコマンドライン出力を設定
handles.output = hObject;
% ハンドル構造を更新
guidata(hObject, handles);

% セットアップの有効/無効化を設定
set(findobj('Tag','pushbutton_add'),'Enable','off');
set(findobj('Tag','edit_eq_lon'),'Enable','off');
set(findobj('Tag','edit_eq_lat'),'Enable','off');
set(findobj('Tag','edit_eq_depth'),'Enable','off');
set(findobj('Tag','edit_eq_length'),'Enable','off');
set(findobj('Tag','edit_eq_width'),'Enable','off');
set(findobj('Tag','edit_eq_mo'),'Enable','off');
set(findobj('Tag','edit_eq_strike'),'Enable','off');
set(findobj('Tag','edit_eq_dip'),'Enable','off');
set(findobj('Tag','edit_eq_rake'),'Enable','off');
set(findobj('Tag','edit_id_number'),'Enable','off');
set(findobj('Tag','edit_fx_start'),'Enable','off');
set(findobj('Tag','edit_fx_finish'),'Enable','off');
set(findobj('Tag','edit_fy_start'),'Enable','off');
set(findobj('Tag','edit_fy_finish'),'Enable','off');
set(findobj('Tag','edit_right_lat'),'Enable','off');
set(findobj('Tag','edit_rev_lat'),'Enable','off');
set(findobj('Tag','edit_f_top'),'Enable','off');
set(findobj('Tag','edit_f_bottom'),'Enable','off');
set(findobj('Tag','pushbutton_empirical'),'Enable','off');
set(findobj('Tag','pushbutton_f_add'),'Enable','off');
set(findobj('Tag','pushbutton_f_calc'),'Enable','off');
set(findobj('Tag','edit_all_input_params'),'Enable','off');

% --- この関数の出力はコマンドラインに返されます。
function varargout = utm_window_OutputFcn(hObject, eventdata, handles)
% UTMウィンドウからの出力をコマンドラインに返す。 
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     CENTER LONGITUDE：中心経度 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_center_lon_Callback(hObject, eventdata, handles)
% 中心経度を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数ZERO_LONに設定します。
global ZERO_LON
ZERO_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(ZERO_LON,'%8.3f'));

function edit_center_lon_CreateFcn(hObject, eventdata, handles)
% 中心経度フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global ZERO_LON
if isempty(ZERO_LON)
    % デフォルト値
    ZERO_LON = 130.2;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_center_lon');
set(h,'String',num2str(ZERO_LON,'%8.3f'));


%-------------------------------------------------------------------------
%     MINIMUM LONGITUDE：最小経度 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_min_lon_Callback(hObject, eventdata, handles)
% 最小経度を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数MIN_LONに設定します。
global MIN_LON
MIN_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MIN_LON,'%8.3f'));

function edit_min_lon_CreateFcn(hObject, eventdata, handles)
% 最小経度フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global MIN_LON
if isempty(MIN_LON) | MIN_LON == 0
    % デフォルト値
    MIN_LON = 129.5;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_min_lon');
set(h,'String',num2str(MIN_LON,'%8.3f'));


%-------------------------------------------------------------------------
%     MAXIMUM LONGITUDE：最大経度 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_max_lon_Callback(hObject, eventdata, handles)
% 最大経度を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数MAX_LONに設定します。
global MAX_LON
MAX_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MAX_LON,'%8.3f'));

function edit_max_lon_CreateFcn(hObject, eventdata, handles)
% 最大経度フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global MAX_LON
if isempty(MAX_LON)
    % デフォルト値
    MAX_LON = 131.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_max_lon');
set(h,'String',num2str(MAX_LON,'%8.3f'));


%-------------------------------------------------------------------------
%     LONGITUDE INCREMENT：経度の増分 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_inc_lon_Callback(hObject, eventdata, handles)
% 経度の増分を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数INC_LONに設定します。
global INC_LON
INC_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INC_LON,'%8.3f'));

function edit_inc_lon_CreateFcn(hObject, eventdata, handles)
% 経度の増分フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global INC_LON
if isempty(INC_LON)
    % デフォルト値
    INC_LON = 0.05;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INC_LON,'%8.3f'));


%-------------------------------------------------------------------------
%     CENTER LATITUDE：中心緯度 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_center_lat_Callback(hObject, eventdata, handles) 
    % 中心緯度を設定するためのコールバック関数。
    % この関数は、テキストフィールドに入力された値を取得し、グローバル変数ZERO_LATに設定します。
    global ZERO_LAT
    ZERO_LAT = str2num(get(hObject,'String'));
    set(hObject,'String',num2str(ZERO_LAT,'%8.3f'));
    
    function edit_center_lat_CreateFcn(hObject, eventdata, handles)
    % 中心緯度フィールドの初期設定。
    % この関数は、テキストフィールドに初期値を設定します。
    global ZERO_LAT
    if isempty(ZERO_LAT)
        % デフォルト値
        ZERO_LAT = 33.8;
    end
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    h = findobj('Tag','edit_center_lat');
    set(h,'String',num2str(ZERO_LAT,'%8.3f'));
    
    
%-------------------------------------------------------------------------
%     MINIMUM LATITUDE：最小緯度 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_min_lat_Callback(hObject, eventdata, handles)
% 最小緯度を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数MIN_LATに設定します。
global MIN_LAT
MIN_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MIN_LAT,'%8.3f'));

function edit_min_lat_CreateFcn(hObject, eventdata, handles)
% 最小緯度フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global MIN_LAT
if isempty(MIN_LAT) | MIN_LAT == 0
    % デフォルト値
    MIN_LAT = 33.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_min_lat');
set(h,'String',num2str(MIN_LAT,'%8.3f'));


%-------------------------------------------------------------------------
%     MAXIMUM LATITUDE：最大緯度 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_max_lat_Callback(hObject, eventdata, handles)
% 最大緯度を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数MAX_LATに設定します。
global MAX_LAT
MAX_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(MAX_LAT,'%8.3f'));

function edit_max_lat_CreateFcn(hObject, eventdata, handles)
% 最大緯度フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global MAX_LAT
if isempty(MAX_LAT)
    % デフォルト値
    MAX_LAT = 34.5;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findobj('Tag','edit_max_lat');
set(h,'String',num2str(MAX_LAT,'%8.3f'));


%-------------------------------------------------------------------------
%     LATITUDE INCREMENT：緯度の増分 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_inc_lat_Callback(hObject, eventdata, handles)
% 緯度の増分を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数INC_LATに設定します。
global INC_LAT
INC_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INC_LAT,'%8.3f'));

function edit_inc_lat_CreateFcn(hObject, eventdata, handles)
% 緯度の増分フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global INC_LAT
if isempty(INC_LAT)
    % デフォルト値
    INC_LAT = 0.05;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INC_LAT,'%8.3f'));


%-------------------------------------------------------------------------
%     CALC. BUTTON (計算ボタン)
%-------------------------------------------------------------------------
function pushbutton_calc_Callback(hObject, eventdata, handles)
% 計算ボタンが押されたときに実行される関数。UTM座標に基づいた計算を行う。

global ZERO_LON ZERO_LAT MIN_LON MAX_LON MIN_LAT MAX_LAT
global INC_LON INC_LAT
global XS YS XF YF
global PC_LON PC_LAT
global GRID MAPTLFLAG
global UTM_FLAG  % UTM_FLAGが0の場合は座標の確認のみ、1の場合は入力ファイルを作成

% 警告ダイアログ：座標の大小関係を確認し、問題がある場合は警告を表示
if MIN_LAT >= MAX_LAT
    errordlg('max lat should be larger than min lat','Alignment Error!');
end
if MIN_LON >= MAX_LON
    errordlg('max lon should be larger than min lon','Alignment Error!');
end
if ZERO_LON > MAX_LON || ZERO_LON < MIN_LON
    errordlg('ref lon should be in the study area','Alignment Error!');
end
if ZERO_LAT > MAX_LAT || ZERO_LAT < MIN_LAT
    errordlg('ref lat should be in the study area','Alignment Error!');
end

% グリッドの設定
ndlon = int16((MAX_LON - MIN_LON) / INC_LON);
ndlat = int16((MAX_LAT - MIN_LAT) / INC_LAT);
modlon = mod((MAX_LON - MIN_LON),INC_LON);
modlat = mod((MAX_LAT - MIN_LAT),INC_LAT);
if ndlon <= 5 | ndlat <= 5
     warndlg('grid interval is so wide','Warning!');   
end

pcent_lon = (MAX_LON + MIN_LON)/2.0;
pcent_lat = (MAX_LAT + MIN_LAT)/2.0;
% 総距離の計算（X軸およびY軸）
if MAPTLFLAG == 1
    xdeg  = distance(pcent_lat,MIN_LON,pcent_lat,MAX_LON);
    ydeg  = distance(MIN_LAT,pcent_lon,MAX_LAT,pcent_lon);
    xdist = deg2km(xdeg);
    ydist = deg2km(ydeg);
    xmin  = deg2km(distance(pcent_lat,MIN_LON,pcent_lat,ZERO_LON));
    ymin  = deg2km(distance(MIN_LAT,pcent_lon,ZERO_LAT,pcent_lon));
    xmax  = deg2km(distance(pcent_lat,MAX_LON,pcent_lat,ZERO_LON));
    ymax  = deg2km(distance(MAX_LAT,pcent_lon,ZERO_LAT,pcent_lon));
else
	[xdist,flag1] = distance2(pcent_lat,MIN_LON,pcent_lat,MAX_LON);
	[ydist,flag2] = distance2(MIN_LAT,pcent_lon,MAX_LAT,pcent_lon);
    [xmin, flag3] = distance2(pcent_lat,MIN_LON,pcent_lat,ZERO_LON);
    [ymin, flag4] = distance2(MIN_LAT,pcent_lon,ZERO_LAT,pcent_lon);
    [xmax, flag5] = distance2(pcent_lat,MAX_LON,pcent_lat,ZERO_LON);
    [ymax, flag6] = distance2(MAX_LAT,pcent_lon,ZERO_LAT,pcent_lon);
    dummy = flag1+flag2+flag3+flag4+flag5+flag6;
    if dummy >= 1
        msgbox('The points are over two UTM zones. It will be switched to simple great circle calc.','Notice','warn');
        xdist = greatCircleDistance(deg2rad(pcent_lat),deg2rad(MIN_LON),deg2rad(pcent_lat),deg2rad(MAX_LON));
        ydist = greatCircleDistance(deg2rad(MIN_LAT),deg2rad(pcent_lon),deg2rad(MAX_LAT),deg2rad(pcent_lon));
        xmin  = greatCircleDistance(deg2rad(pcent_lat),deg2rad(MIN_LON),deg2rad(pcent_lat),deg2rad(ZERO_LON));
        ymin  = greatCircleDistance(deg2rad(MIN_LAT),deg2rad(pcent_lon),deg2rad(ZERO_LAT),deg2rad(pcent_lon));
        xmax  = greatCircleDistance(deg2rad(pcent_lat),deg2rad(MAX_LON),deg2rad(pcent_lat),deg2rad(ZERO_LON));
        ymax  = greatCircleDistance(deg2rad(MAX_LAT),deg2rad(pcent_lon),deg2rad(ZERO_LAT),deg2rad(pcent_lon));
    end
end

if ZERO_LON > MIN_LON
    xmin = -xmin;
end
if ZERO_LAT > MIN_LAT
    ymin = -ymin;
end
if ZERO_LON > MAX_LON
    xmax = -xmax;
end
if ZERO_LAT > MAX_LAT
    ymax = -ymax;
end

set(findobj('Tag','edit_x_start'),'String',num2str(xmin,'%8.2f'));
set(findobj('Tag','edit_y_start'),'String',num2str(ymin,'%8.2f'));
set(findobj('Tag','edit_x_finish'),'String',num2str(xmax,'%8.2f'));
set(findobj('Tag','edit_y_finish'),'String',num2str(ymax,'%8.2f'));

% グリッドの設定
XS = xmin; GRID(1,1) = xmin;
XF = xmax; GRID(3,1) = xmax;
YS = ymin; GRID(2,1) = ymin;
YF = ymax; GRID(4,1) = ymax;
GRID(5,1) = (xmax - xmin) / double(ndlon);
GRID(6,1) = (ymax - ymin) / double(ndlat);
set(findobj('Tag','edit_x_inc'),'String',num2str(GRID(5,1),'%8.2f'));
set(findobj('Tag','edit_y_inc'),'String',num2str(GRID(6,1),'%8.2f'));
PC_LON = pcent_lon;
PC_LAT = pcent_lat;

set(findobj('Tag','pushbutton_add'),'Enable','on');
set(findobj('Tag','edit_eq_lon'),'Enable','on');
set(findobj('Tag','edit_eq_lat'),'Enable','on');
set(findobj('Tag','edit_eq_depth'),'Enable','on');
set(findobj('Tag','edit_eq_length'),'Enable','on');
set(findobj('Tag','edit_eq_width'),'Enable','on');
set(findobj('Tag','edit_eq_mo'),'Enable','on');
set(findobj('Tag','edit_eq_strike'),'Enable','on');
set(findobj('Tag','edit_eq_dip'),'Enable','on');
set(findobj('Tag','edit_eq_rake'),'Enable','on');
set(findobj('Tag','edit_id_number'),'Enable','on');
set(findobj('Tag','edit_fx_start'),'Enable','on');
set(findobj('Tag','edit_fx_finish'),'Enable','on');
set(findobj('Tag','edit_fy_start'),'Enable','on');
set(findobj('Tag','edit_fy_finish'),'Enable','on');
set(findobj('Tag','edit_right_lat'),'Enable','on');
set(findobj('Tag','edit_rev_lat'),'Enable','on');
set(findobj('Tag','edit_f_top'),'Enable','on');
set(findobj('Tag','edit_f_bottom'),'Enable','on');
set(findobj('Tag','pushbutton_empirical'),'Enable','on');
set(findobj('Tag','pushbutton_f_add'),'Enable','off');

% 座標の確認ツールとして使用する場合
if UTM_FLAG == 0
    set(findobj('Tag','pushbutton_f_calc'),'Enable','on');
else
    set(findobj('Tag','pushbutton_f_calc'),'Enable','off');
end
set(findobj('Tag','edit_all_input_params'),'Enable','off');


%-------------------------------------------------------------------------
%     GRID X START：グリッドのX軸の開始位置 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_x_start_Callback(hObject, eventdata, handles)
% グリッドのX軸の開始位置を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(1,1)に設定します。
global GRID
GRID(1,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(1,1),'%8.2f'));

function edit_x_start_CreateFcn(hObject, eventdata, handles)
% グリッドのX軸の開始位置フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(1,1) = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%     GRID Y START：グリッドY軸の開始位置 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_y_start_Callback(hObject, eventdata, handles)
% グリッドY軸の開始位置を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(2,1)に設定します。
global GRID
GRID(2,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(2,1),'%8.2f'));

function edit_y_start_CreateFcn(hObject, eventdata, handles)
% グリッドY軸の開始位置フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(2,1) = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%     GRID X FINISH：グリッドのX軸の終了位 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_x_finish_Callback(hObject, eventdata, handles)
% グリッドのX軸の終了位置を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(3,1)に設定します。
global GRID
GRID(3,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(3,1),'%8.2f'));

function edit_x_finish_CreateFcn(hObject, eventdata, handles)
% グリッドのX軸の終了位置フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(3,1) = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%     GRID Y FINISH：グリッドY軸の終了位置 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_y_finish_Callback(hObject, eventdata, handles)
% グリッドY軸の終了位置を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(4,1)に設定します。
global GRID
GRID(4,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(4,1),'%8.2f'));

function edit_y_finish_CreateFcn(hObject, eventdata, handles)
% グリッドY軸の終了位置フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(4,1) = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%     GRID X INCREMENT：X軸の増分 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_x_inc_Callback(hObject, eventdata, handles)
% グリッドのX軸の増分を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(5,1)に設定します。
global GRID
GRID(5,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(5,1),'%8.2f'));

function edit_x_inc_CreateFcn(hObject, eventdata, handles)
% グリッドのX軸の増分フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(5,1) = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%     GRID Y INCREMENT：Y軸の増分 (textfield)
%-------------------------------------------------------------------------
function edit_y_inc_Callback(hObject, eventdata, handles)
% グリッドのY軸の増分を設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(6,1)に設定します。
global GRID
GRID(6,1) = str2double(get(hObject,'String'));
set(hObject,'String',num2str(GRID(6,1),'%8.2f'));

function edit_y_inc_CreateFcn(hObject, eventdata, handles)
% グリッドのY軸の増分フィールドの初期設定。
% この関数は、テキストフィールドに初期値を設定します。
global GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GRID(6,1) = str2double(get(hObject,'String'));


%-------------------------------------------------------------------------
%     追加ボタン：main_menu_windowへ計算情報の追加
%-------------------------------------------------------------------------
function pushbutton_add_Callback(hObject, eventdata, handles)
% メインメニューウィンドウにすべての計算情報を追加するためのボタン。
% 追加ボタンが押されたときに実行される関数。main_menu_windowへ計算情報を追加する。

global H_MAIN GRID XGRID YGRID FUNC_SWITCH CALC_DEPTH
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global LON_GRID LAT_GRID

% グリッド位置を計算し、他のすべての関数で使用できるように保持
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
CALC_DEPTH  = 0; % グリッド描画機能のための一時的な値


%===== マップ情報が存在する場合の処理
if isempty(MIN_LON) ~= 1 && isempty(MAX_LON) ~= 1
    if isempty(MIN_LAT) ~= 1 && isempty(MAX_LAT) ~= 1
        if isempty(ZERO_LON) ~= 1 && isempty(ZERO_LAT) ~= 1
            xinc = double(MAX_LON - MIN_LON) / double(nxinc-1);
            yinc = double(MAX_LAT - MIN_LAT) / double(nyinc-1);
            LON_GRID = double(MIN_LON) + (double(1:1:nxinc)-1.0) * double(xinc);
            LAT_GRID = double(MIN_LAT) + (double(1:1:nyinc)-1.0) * double(yinc);
        end
    end
end
%=====
% グリッド描画
grid_drawing;
FUNC_SWITCH = 0;

set(findobj('Tag','pushbutton_f_calc'),'Enable','on');
set(findobj('Tag','menu_gridlines'),'Enable','On');
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');    


%-------------------------------------------------------------------------
%     地震位置の端部を設定 (ラジオボタン)
%-------------------------------------------------------------------------
function radiobutton_edgepos_Callback(hObject, eventdata, handles)
% 地震位置の端部を設定するラジオボタン。
set (handles.radiobutton_centerpos,'Value',0);


%-------------------------------------------------------------------------
%     地震位置の中央を設定 (ラジオボタン)
%-------------------------------------------------------------------------
function radiobutton_centerpos_Callback(hObject, eventdata, handles)
% 地震位置の中央を設定するラジオボタン。
set (handles.radiobutton_edgepos,'Value',0);


%-------------------------------------------------------------------------
%     地震位置の経度を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_lon_Callback(hObject, eventdata, handles)
% 地震位置の経度を設定するためのコールバック関数。
global EQ_LON
EQ_LON = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_LON,'%8.3f'));

function edit_eq_lon_CreateFcn(hObject, eventdata, handles)
% 地震位置の経度フィールドの初期設定。
global EQ_LON
if isempty(EQ_LON)
    % デフォルト値
    EQ_LON = 130.178;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_LON,'%8.3f'));


%-------------------------------------------------------------------------
%     地震位置の緯度を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_lat_Callback(hObject, eventdata, handles)
% 地震位置の緯度を設定するためのコールバック関数。
global EQ_LAT
EQ_LAT = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_LAT,'%8.3f'));

function edit_eq_lat_CreateFcn(hObject, eventdata, handles)
% 地震位置の緯度フィールドの初期設定。
global EQ_LAT
if isempty(EQ_LAT)
    % デフォルト値
    EQ_LAT = 33.741;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_LAT,'%8.3f'));


%-------------------------------------------------------------------------
%     地震の深さを設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_depth_Callback(hObject, eventdata, handles)
% 地震の深さを設定するためのコールバック関数。
global EQ_DEPTH
EQ_DEPTH = str2num(get(hObject,'String'));
if EQ_DEPTH < 0.0
    h = warndlg('The depth should be positive.');
    EQ_DEPTH = 0.0;
end
set(hObject,'String',num2str(EQ_DEPTH,'%6.2f'));

function edit_eq_depth_CreateFcn(hObject, eventdata, handles)
% 地震の深さフィールドの初期設定。
global EQ_DEPTH
if isempty(EQ_DEPTH)
    % デフォルト値
    EQ_DEPTH = 7.5;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_DEPTH,'%6.2f'));

%-------------------------------------------------------------------------
%     断層の長さを設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_length_Callback(hObject, eventdata, handles)
% 断層の長さを設定するためのコールバック関数。
global EQ_LENGTH
EQ_LENGTH = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_LENGTH,'%7.2f'));

function edit_eq_length_CreateFcn(hObject, eventdata, handles)
% 断層の長さフィールドの初期設定。
global EQ_LENGTH
if isempty(EQ_LENGTH)
    % デフォルト値
    EQ_LENGTH = 20.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_LENGTH,'%7.2f'));


%-------------------------------------------------------------------------
%     断層の幅を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_width_Callback(hObject, eventdata, handles)
% 断層の幅を設定するためのコールバック関数。
global EQ_WIDTH
EQ_WIDTH = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_WIDTH,'%7.2f'));

function edit_eq_width_CreateFcn(hObject, eventdata, handles) 
% 断層の幅フィールドの初期設定。
global EQ_WIDTH
if isempty(EQ_WIDTH)
    % デフォルト値
    EQ_WIDTH = 10.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_WIDTH,'%7.2f'));


%-------------------------------------------------------------------------
%     wells & coppersmithの経験式に基づく計算 (ボタン)
%-------------------------------------------------------------------------
function pushbutton_empirical_Callback(hObject, eventdata, handles)
% wells & coppersmithの経験式に基づく計算を行うボタンのコールバック関数。
global H_WC
H_WC = wells_coppersmith_window;


%-------------------------------------------------------------------------
%     モーメントマグニチュードを設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_mo_Callback(hObject, eventdata, handles)
% モーメントマグニチュードを設定するためのコールバック関数。
% この関数は、テキストフィールドに入力された値を取得し、グローバル変数EQ_MWに設定します。
global EQ_MW
EQ_MW = str2num(get(hObject,'String'));
set(hObject,'String',num2str(EQ_MW,'%3.1f'));

function edit_eq_mo_CreateFcn(hObject, eventdata, handles)
% モーメントマグニチュードフィールドの初期設定。
global EQ_MW
if isempty(EQ_MW)
    EQ_MW = 6.6;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_MW,'%3.1f'));


%-------------------------------------------------------------------------
%     断層の走行（方位角）を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_strike_Callback(hObject, eventdata, handles)
% 断層の走行（方位角）を設定するためのコールバック関数。
global EQ_STRIKE
x = str2num(get(hObject,'String'));
if x >= 0 && x <= 360
    EQ_STRIKE = str2num(get(hObject,'String'));
    if x == 360
        EQ_STRIKE = 0.0;
    end
else
    h = warndlg('Out of strike range. It should be between 0 and 360.');
    waitfor(h);
end
set(hObject,'String',num2str(EQ_STRIKE,'%6.1f'));

function edit_eq_strike_CreateFcn(hObject, eventdata, handles)
% 断層の走行（方位角）フィールドの初期設定。
global EQ_STRIKE
if isempty(EQ_STRIKE)
    EQ_STRIKE = 303.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_STRIKE,'%6.1f'));


%-------------------------------------------------------------------------
%     断層のディップ（傾斜角）を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_dip_Callback(hObject, eventdata, handles)
% 断層のディップ（傾斜角）を設定するためのコールバック関数。
global EQ_DIP
x = str2num(get(hObject,'String'));
if x >= 0 && x <= 90
    EQ_DIP = str2num(get(hObject,'String'));
else
    h = warndlg('Out of dip range. It should be between 0 and 90.');
    waitfor(h);
end
set(hObject,'String',num2str(EQ_DIP,'%6.1f'));

function edit_eq_dip_CreateFcn(hObject, eventdata, handles)
% 断層のディップ（傾斜角）フィールドの初期設定。
global EQ_DIP
if isempty(EQ_DIP)
    EQ_DIP = 81.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_DIP,'%6.1f'));


%-------------------------------------------------------------------------
%     断層のレイク（すべり角）を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_eq_rake_Callback(hObject, eventdata, handles)
% 断層のレイク（すべり角）を設定するためのコールバック関数。
global EQ_RAKE
x = str2num(get(hObject,'String'));
if x >= -180.0 && x <= 180
    EQ_RAKE = str2num(get(hObject,'String'));
else
    h = warndlg('Out of rake range. It should be between -180 and 180');
    waitfor(h);
end
set(hObject,'String',num2str(EQ_RAKE,'%6.1f'));

function edit_eq_rake_CreateFcn(hObject, eventdata, handles)
% 断層のレイク（すべり角）フィールドの初期設定。
global EQ_RAKE
if isempty(EQ_RAKE)
    EQ_RAKE = 4.0;
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(EQ_RAKE,'%6.1f'));


%-------------------------------------------------------------------------
%     断層始点のX座標を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_fx_start_Callback(hObject, eventdata, handles)
% 断層始点のX座標を設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,1) = str2double(get(hObject,'String'));

function edit_fx_start_CreateFcn(hObject, eventdata, handles)
% 断層始点のX座標フィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     断層始点のY座標 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_fy_start_Callback(hObject, eventdata, handles)
% 断層始点のY座標を設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,2) = str2double(get(hObject,'String'));

function edit_fy_start_CreateFcn(hObject, eventdata, handles)
% 断層始点のY座標フィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%     断層終点のX座標を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_fx_finish_Callback(hObject, eventdata, handles) 
% 断層終点のX座標を設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,3) = str2double(get(hObject,'String'));

function edit_fx_finish_CreateFcn(hObject, eventdata, handles)
% 断層終点のX座標フィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     断層終点のY座標を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_fy_finish_Callback(hObject, eventdata, handles)
% 断層終点のY座標を設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,4) = str2double(get(hObject,'String'));

function edit_fy_finish_CreateFcn(hObject, eventdata, handles)
% 断層終点のY座標フィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     断層の上端の深さを設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_f_top_Callback(hObject, eventdata, handles)
% 断層の上端の深さを設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,8) = str2double(get(hObject,'String'));

function edit_f_top_CreateFcn(hObject, eventdata, handles) 
% 断層の上端の深さフィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     断層の下端の深さを設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_f_bottom_Callback(hObject, eventdata, handles)
% 断層の下端の深さを設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,9) = str2double(get(hObject,'String'));

% --- オブジェクト作成時に、すべてのプロパティを設定した後に実行されます。
function edit_f_bottom_CreateFcn(hObject, eventdata, handles)
% 断層の下端の深さフィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     右横ずれ量を設定 (テキストフィールド)
%-------------------------------------------------------------------------
function edit_right_lat_Callback(hObject, eventdata, handles)
% 右横ずれ量を設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,5) = str2double(get(hObject,'String'));

% --- オブジェクト作成時に、すべてのプロパティを設定した後に実行されます。
function edit_right_lat_CreateFcn(hObject, eventdata, handles)
% 右横ずれ量フィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     Disp slip：逆断層変位成分を設定(テキストフィールド)
%-------------------------------------------------------------------------
function edit_rev_lat_Callback(hObject, eventdata, handles)
% 逆断層変位成分を設定するためのコールバック関数。
global ELEMENT INUM
ELEMENT(INUM,6) = str2double(get(hObject,'String'));

% --- オブジェクト作成時に、すべてのプロパティを設定した後に実行されます。
function edit_rev_lat_CreateFcn(hObject, eventdata, handles)
% 逆断層変位成分フィールドの初期設定。
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%     CALCULATION FOR FAULT：断層に関する計算を行うボタン (テキストフィールド)
%-------------------------------------------------------------------------
function pushbutton_f_calc_Callback(hObject, eventdata, handles)
% 断層に関する計算を行うボタンのコールバック関数。
% ユーザーがGUIで入力した地震断層のパラメータを使用して、断層の位置や変位量を計算します。

global ZERO_LON ZERO_LAT MIN_LON MAX_LON MIN_LAT MAX_LAT
global XS YS XF YF
global EQ_LON EQ_LAT EQ_DEPTH
global PC_LON PC_LAT
global EQ_LENGTH EQ_WIDTH EQ_STRIKE EQ_DIP EQ_RAKE EQ_MW
global NUM ID ELEMENT INUM KODE FCOMMENT
global MAPTLFLAG

% 永続的に ntrial %でINUMを記録し、別の断層を追加する。
% ntrial = ntrial + 1;

% 保険：断層の長さ、幅、モーメントマグニチュードをGUIから取得
EQ_LENGTH = str2double(get(findobj('Tag','edit_eq_length'),'String'));
EQ_WIDTH  = str2double(get(findobj('Tag','edit_eq_width'),'String'));
EQ_MW     = str2double(get(findobj('Tag','edit_eq_mo'),'String'));

% 断層の数（INUM）を数える
% INUM = INUM + 1;

% 断層のID番号を更新
set(findobj('Tag','edit_id_number'),'String',num2str(INUM,'%2i'));
% 断層の総数
NUM = INUM;
% Kode：計算のタイプを指定するコード，通常の計算では100
KODE(INUM,1) = 100;
ID(INUM,1) = 1;
FCOMMENT(INUM,:).ref = ['Fault ' num2str(INUM,'%3i')];

% 断層の位置参照方法を取得（中央または端部）
% fref = 0：中心の位置参照、fref = 1：端部の位置参照
fref = 0;
fref = get(handles.radiobutton_edgepos,'Value');

% ID = 1;
% NUM = 1;
% Each fault element
%       ELEMENT(:,1) 断層始点のX座標値 (km)
%       ELEMENT(:,2) 断層始点のY座標値 (km)
%       ELEMENT(:,3) 断層終点のX座標値 (km)
%       ELEMENT(:,4) 断層終点のY座標値 (km)
%       ELEMENT(:,5) 右横ずれ成分（rt.lat, m）左横ずれはマイナス
%       ELEMENT(:,6) 逆断層変位成分（reverse, m）正断層はマイナス
%       ELEMENT(:,7) dip 断層の傾斜（0°-90°）
%       ELEMENT(:,8) 断層の上端の深さ（km）
%       ELEMENT(:,9) 断層の下端の深さ（km）
%  !!! NEED readjustment for dipping fault !!!!!!!!!!!!!!!!!!

% 地震の震源位置に基づいて断層の始点と終点のX, Y座標を計算
if MAPTLFLAG == 1
    xdist = deg2km(distance(PC_LAT,EQ_LON,PC_LAT,ZERO_LON));
else
    [xdist,flag] = distance2(PC_LAT,EQ_LON,PC_LAT,ZERO_LON);
    if flag == 1
        xdist  = greatCircleDistance(deg2rad(PC_LAT),deg2rad(EQ_LON),deg2rad(PC_LAT),deg2rad(ZERO_LON)); 
    end
end
if EQ_LON < ZERO_LON
    xdist = -xdist;
end
if MAPTLFLAG == 1
    ydist = deg2km(distance(EQ_LAT,PC_LON,ZERO_LAT,PC_LON));
else
    [ydist,flag] = distance2(EQ_LAT,PC_LON,ZERO_LAT,PC_LON);
    if flag == 1
        ydist  = greatCircleDistance(deg2rad(EQ_LAT),deg2rad(PC_LON),deg2rad(ZERO_LAT),deg2rad(PC_LON)); 
    end
end
if EQ_LAT < ZERO_LAT
    ydist = -ydist;
end

% 断層の終点を計算（端部または中央参照）
if fref == 1 % 端部位置参照
    xfn = xdist + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
    yfn = ydist + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
else         % 中央位置参照
    xtemp = xdist;
    ytemp = ydist;
    xdist = xtemp - sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
    ydist = ytemp - cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
    xfn   = xtemp + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
    yfn   = ytemp + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;

   % 断層の傾斜角度（dip-slip direction）に基づいて、始点と終点の調整を行う
    dd = (EQ_WIDTH / 2.) * cos(deg2rad(EQ_DIP));
    theta = atan(abs(yfn-ydist)/abs(xfn-xdist));
    zx = dd * sin(theta);   % x軸方向の調整量（単位距離）
    zy = dd * cos(theta);   % y軸方向の調整量（単位距離）
    if xfn >= xdist
        if yfn >= ydist
            zx = -zx;
            zy = zy;
        else
            zx = zx;
            zy = zy;
        end
    else
        if yfn >= ydist
            zx = -zx;
            zy = -zy;
        else
            zx = zx;
            zy = -zy;
        end
    end 
    xdist = xdist + zx;
    ydist = ydist + zy;
    xfn   = xfn + zx;
    yfn   = yfn + zy;
end

% 断層の始点と終点をGUIに表示し、変数に保存
set(findobj('Tag','edit_fx_start'),'String',num2str(xdist,'%8.2f'));
set(findobj('Tag','edit_fy_start'),'String',num2str(ydist,'%8.2f'));
set(findobj('Tag','edit_fx_finish'),'String',num2str(xfn,'%8.2f'));
set(findobj('Tag','edit_fy_finish'),'String',num2str(yfn,'%8.2f'));
ELEMENT(INUM,1) = xdist;
ELEMENT(INUM,2) = ydist;
ELEMENT(INUM,3) = xfn;
ELEMENT(INUM,4) = yfn;

% モーメントマグニチュードから断層の変位を計算し、表示。
% 剪断モジュール
shr = 3.4e+11;
% 地震モーメント
mo = power(10,(1.5 * EQ_MW + 9.1))*1.0e+7;
slip = mo/(shr * EQ_LENGTH * EQ_WIDTH * 1.0e+10);
rlslip = ((-1.0) * cos(deg2rad(EQ_RAKE)) * slip)/100;
rvslip = (sin(deg2rad(EQ_RAKE)) * slip)/100;
set(findobj('Tag','edit_right_lat'),'String',num2str(rlslip,'%8.2f'));
set(findobj('Tag','edit_rev_lat'),'String',num2str(rvslip,'%8.2f'));
ELEMENT(INUM,5) = rlslip;
ELEMENT(INUM,6) = rvslip;

% 断層の深さを計算
hd = (EQ_WIDTH/2.0) * sin(deg2rad(EQ_DIP));
if fref == 1 % 端部位置参照
    bt = EQ_DEPTH + 2.0 * hd;
else         % 中央位置参照
    tp = EQ_DEPTH - hd;
    bt = EQ_DEPTH + hd;
    if tp < 0.0
        h = warndlg('Fault top depth above the surface (negative). Change the source depth or fault width.');
        waitfor(h);
    end
end
set(findobj('Tag','edit_f_top'),'String',num2str(tp,'%8.2f'));
set(findobj('Tag','edit_f_bottom'),'String',num2str(bt,'%8.2f'));
ELEMENT(INUM,7) = EQ_DIP;
ELEMENT(INUM,8) = tp;
ELEMENT(INUM,9) = bt;

% 計算結果を他のボタンやGUIコンポーネントで利用可能にする
set(findobj('Tag','pushbutton_f_add'),'Enable','on');


%-------------------------------------------------------------------------
%     ADD FAULT：断層の追加 (プッシュボタン)
%-------------------------------------------------------------------------
function pushbutton_f_add_Callback(hObject, eventdata, handles)
% 「Add Fault」ボタンが押されたときに実行されるコールバック関数です。
% グローバル変数を利用して断層に関するデフォルト値を設定し、断層の計算や表示を行います。

global CALC_DEPTH POIS YOUNG KODE FRIC SIZE HEAD R_STRESS H_ELEMENT SECTION
global ID NUM ELEMENT INUM
global EQ_LAT EQ_LON
global ICOORD LON_GRID

% 断層の深さ、ポアソン比、ヤング率のデフォルト値を設定
CALC_DEPTH = (ELEMENT(INUM,8)+ELEMENT(INUM,9)) / 2.0;
POIS = 0.25;
YOUNG = 800000;

% その他のデフォルト値を設定
% KODE = 100;
FRIC = 0.4;
SIZE = [2;1;10000]; % サイズに関する設定

x1 = 'header line 1';
x2 = 'header line 2';

HEAD{1} = x1;  % ヘッダー行1
HEAD{2} = x2;  % ヘッダー行2

% 応力テンソルに関する設定
R_STRESS = [19.00 -0.01 100.0 0.0;
            89.99 89.99  30.0 0.0;
           109.00 -0.01   0.0 0.0];

% セクションに関する設定
SECTION = [-16; -16; 18; 26; 1; 30; 1];

% fault_overlay関数を呼び出して断層を表示
fault_overlay;

% EQ_LAT、EQ_LONを使用して座標変換を行い、UTM座標系でプロット
a = lonlat2xy([EQ_LON EQ_LAT]);
hold on;
% 緯度経度でプロット
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    h = scatter(EQ_LON,EQ_LAT,'filled','bo');
% UTM座標系でプロット
else
    h = scatter(a(1),a(2),'filled','bo');
end

% メニューやボタンを有効化
set(findobj('Tag','menu_grid'),'Enable','On');
set(findobj('Tag','menu_displacement'),'Enable','On');
set(findobj('Tag','menu_strain'),'Enable','On');
set(findobj('Tag','menu_stress'),'Enable','On');
set(findobj('Tag','menu_change_parameters'),'Enable','On');
set(findobj('Tag','edit_all_input_params'),'Enable','on');
set(findobj('Tag','menu_file_save'),'Enable','On');
set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
set(findobj('Tag','menu_map_info'),'Enable','On');

% INUM = INUM + 1：次の断層IDを設定
set(findobj('Tag','edit_id_number'),'String',num2str(INUM,'%2i'));


%-------------------------------------------------------------------------
%     CANCEL：キャンセル (プッシュボタン)
%-------------------------------------------------------------------------
function pushbutton_utm_cancel_Callback(hObject, eventdata, handles)
% 「Cancel」ボタンが押されたときに実行されるコールバック関数です。
% この関数は、UTM座標系のウィンドウを閉じ、メインウィンドウをアクティブにします。

    % ウィンドウを閉じる
    delete(figure(gcf));
    

%-------------------------------------------------------------------------
%     OK (プッシュボタン)
%-------------------------------------------------------------------------
function pushbutton_utm_ok_Callback(hObject, eventdata, handles)
% 「OK」ボタンが押されたときに実行されるコールバック関数です。
% 要素の計算を行い、ウィンドウを閉じます。

    % グリッドやデータなどの要素の計算
    calc_element;
    % ウィンドウを閉じる
    delete(figure(gcf));
    

%-------------------------------------------------------------------------
%     ID number (static text)
%-------------------------------------------------------------------------
function edit_id_number_Callback(hObject, eventdata, handles)
% ID番号のテキストフィールドが変更されたときに実行されるコールバック関数です。
% グローバル変数を利用して、断層要素のIDを管理します。

global NUM INUM ID KODE FCOMMENT ELEMENT

% 入力されたID番号を取得
x = int8(str2double(get(hObject,'String')));

% ID番号が連続していない場合に警告を表示
if x > NUM + 1
    h = warndlg('Fault ID should be sequential.');
    waitfor(h);
    % 現在のID番号にリセット
    set(hObject,'String',num2str(INUM,'%3i'));
    return
% 新しい断層要素を追加する場合の処理
elseif x == NUM + 1
    INUM = x;
    KODE(INUM,1) = 100;
    ID(INUM,1) = 1;
    FCOMMENT(INUM,:).ref = ['Fault ' num2str(INUM,'%3i')];
    ELEMENT(INUM,1) = str2double(get(findobj('Tag','edit_fx_start'),'String'));
    ELEMENT(INUM,2) = str2double(get(findobj('Tag','edit_fy_start'),'String'));
    ELEMENT(INUM,3) = str2double(get(findobj('Tag','edit_fx_finish'),'String'));
    ELEMENT(INUM,4) = str2double(get(findobj('Tag','edit_fy_finish'),'String'));
    ELEMENT(INUM,5) = str2double(get(findobj('Tag','edit_right_lat'),'String'));
    ELEMENT(INUM,6) = str2double(get(findobj('Tag','edit_rev_lat'),'String'));
    ELEMENT(INUM,7) = str2double(get(findobj('Tag','edit_eq_dip'),'String'));
    ELEMENT(INUM,8) = str2double(get(findobj('Tag','edit_f_top'),'String'));
    ELEMENT(INUM,9) = str2double(get(findobj('Tag','edit_f_bottom'),'String'));
    NUM = INUM;
% 既存の断層要素を編集する場合の処理
else
    INUM = x;
    set(findobj('Tag','edit_fx_start'),'String',num2str(ELEMENT(INUM,1),'%8.2f'));
    set(findobj('Tag','edit_fy_start'),'String',num2str(ELEMENT(INUM,2),'%8.2f'));
    set(findobj('Tag','edit_fx_finish'),'String',num2str(ELEMENT(INUM,3),'%8.2f'));
    set(findobj('Tag','edit_fy_finish'),'String',num2str(ELEMENT(INUM,4),'%8.2f'));
    set(findobj('Tag','edit_right_lat'),'String',num2str(ELEMENT(INUM,5),'%8.2f'));
    set(findobj('Tag','edit_rev_lat'),'String',num2str(ELEMENT(INUM,6),'%8.2f'));
    set(findobj('Tag','edit_eq_dip'),'String',num2str(ELEMENT(INUM,7),'%8.2f'));
    set(findobj('Tag','edit_f_top'),'String',num2str(ELEMENT(INUM,8),'%8.2f'));
    set(findobj('Tag','edit_f_bottom'),'String',num2str(ELEMENT(INUM,9),'%8.2f'));    
end


function edit_id_number_CreateFcn(hObject, eventdata, handles)
% ID番号フィールドの初期設定
global INUM
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

INUM = 1; % for counting (initialization) % カウント初期化のため
set(hObject,'String',num2str(1,'%2i'));


%-------------------------------------------------------------------------
%     Edit all input parameters：全ての入力パラメータを編集 (static text)
%-------------------------------------------------------------------------
function edit_all_input_params_Callback(hObject, eventdata, handles)
% 「Edit all input parameters」テキストフィールドが変更されたときに実行されるコールバック関数です。
% この関数は、全ての入力パラメータを編集するためのウィンドウを表示します。

global H_INPUT H_UTM
H_INPUT = input_window;
h = findobj('Tag','utm_window');
if (isempty(h)~=1 & isempty(H_UTM)~=1)
    close(figure(H_UTM))
    H_UTM = [];
end
