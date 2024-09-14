function varargout = displ_h_window2(varargin)
% 初期化コードの開始
% GUIのシングルトンインスタンスと状態を定義し、コールバック関数を設定します
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @displ_h_window_OpeningFcn, ...
                   'gui_OutputFcn',  @displ_h_window_OutputFcn, ...
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
% 初期化コードの終了


% この関数は、displ_h_window が表示される直前に実行されます。
function displ_h_window_OpeningFcn(hObject, eventdata, handles, varargin)
% この関数は、GUI が作成されるときに呼び出されます。
global SCR_SIZE % スクリーンサイズ (1x4, [x y width height]) と幅・高さを定義

set(findobj('Tag','Mouse_click'),'Enable','Off'); % マウスクリックを無効にする
h = findobj('Tag','displ_h_window2');
j = get(h,'Position');
wind_width = j(1,3);
wind_height = j(1,4);
dummy = findobj('Tag','main_menu_window2');
if isempty(dummy)~=1
    h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]); % ウィンドウの位置を設定

% displ_h_window のデフォルトのコマンドライン出力を選択
handles.output = hObject;
% ハンドル構造体の更新
guidata(hObject, handles);
% UIRESUME が呼び出されるまで、displ_h_window はユーザーの応答を待ちます

% --- この関数からの出力がコマンドラインに返されます。
function varargout = displ_h_window_OutputFcn(hObject, eventdata, handles) 
% ハンドル構造体からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;

%-------------------------------------------------------------------------
% Calculations are only done by pushing 計算は以下を押すことによってのみ行われる。
%       1) "Calc. & view" button       「計算と表示 」ボタン
%       2) changing the slider movement スライダーの動きを変える
%       3) "Mouse click"                マウスクリック
% (collect all input information when doing the above two excutions)
% 上記2つの操作を行う際、すべての入力情報を収集する。
%-------------------------------------------------------------------------

%=========================================================================
%	  SLIDER MOVEMENT スライダーの動きに対応するコールバック関数
%=========================================================================
function slider_displ_Callback(hObject, eventdata, handles)
% スライダーを動かしたときの処理
global H_MAIN DISP_SCALE
global CALC_CONTROL
global INPUT_VARS

temp_reserve = CALC_CONTROL.FUNC_SWITCH; % 現在の関数スイッチの状態を一時的に保存
h = findobj('Tag','exaggeration');
v = get(hObject,'Value') * INPUT_VARS.SIZE(3,1); % スライダーの値に基づいてスケールを設定
set(h,'String',num2str(v,'%6.0f')); % スケール値を表示
figure(H_MAIN);
delete(axes('Parent',H_MAIN)); % メインウィンドウの既存のグラフを削除

hold on;
CALC_CONTROL.FUNC_SWITCH = temp_reserve; % 関数スイッチの状態を復元
DISP_SCALE = get(hObject,'Value'); % スケールを更新
calc_button_Callback; % 計算を実行

%-----
function slider_displ_CreateFcn(hObject, eventdata, handles)
% スライダーが作成されたときの初期設定
global DISP_SCALE
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]); % スライダーの背景色を設定
end
DISP_SCALE = get(hObject,'Value'); % スケールの初期値を設定

%-------------------------------------------------------------------------
%	  UIPANEL SELECTION CHANGE パネルの選択変更に対応するコールバック関数
%-------------------------------------------------------------------------
function uipanel_reference_SelectionChangeFcn(hObject,eventdata,handles)
% パネルの選択が変更されたときの処理
global COORD_VARS
selection = get(hObject,'SelectedObject')
switch get(selection,'Tag')
    case 'radiobutton_nofix'
        radiobutton_nofix_Callback;
        COORD_VARS.ICOORD = 1; % デカルト座標系を選択
    case 'radiobutton_fixcart'
        radiobutton_fixcart_Callback;
        COORD_VARS.ICOORD = 1; % デカルト座標系を選択
    case 'radiobutton_fixlonlat'
        COORD_VARS.ICOORD = 2; % 経度・緯度座標系を選択
end

%-------------------------------------------------------------------------
%	  NO FIX (radiobutton) 座標の固定に対応するラジオボタンのコールバック関数
%-------------------------------------------------------------------------
function radiobutton_nofix_Callback(hObject, eventdata, handles)
% "No Fix"が選択されたときの処理
global H_MAIN FIXFLAG
global CALC_CONTROL 
set(findobj('Tag','Mouse_click'),'Enable','off'); % マウスクリックを無効にする
x = get(hObject,'Value');
if x==1;
    temp_reserve = CALC_CONTROL.FUNC_SWITCH;
    FIXFLAG = 0;
    figure(H_MAIN);
    delete(axes('Parent',H_MAIN)); % メインウィンドウの既存のグラフを削除
    hold on;
    CALC_CONTROL.FUNC_SWITCH = temp_reserve;
    h = findobj('Tag','slider_displ');
    displ_open(get(h,'Value')); % 表示を更新
end

%-------------------------------------------------------------------------
%	  FIXED CARTESIAN (radiobutton) 固定されたカルテシアン座標系に対応するラジオボタンのコールバック関数
%-------------------------------------------------------------------------
function radiobutton_fixcart_Callback(hObject, eventdata, handles)
% "Fixed Cartesian"が選択されたときの処理
global FIXFLAG FIXX FIXY
global CALC_CONTROL
set(findobj('Tag','Mouse_click'),'Enable','on'); % マウスクリックを有効にする
x = get(hObject,'Value');
if x==1;
    CALC_CONTROL.ICOORD = 1;
    FIXFLAG = 1;
    h = findobj('Tag','edit_fixx');
    FIXX = str2double(get(h,'String'));
    h = findobj('Tag','edit_fixy');
    FIXY = str2double(get(h,'String'));
end

%-------------------------------------------------------------------------
%	  FIXED LON & LAT (radiobutton) 固定された経度・緯度座標系に対応するラジオボタンのコールバック関数
%-------------------------------------------------------------------------
function radiobutton_fixlonlat_Callback(hObject, eventdata, handles)
% "Fixed Lon & Lat"が選択されたときの処理
global FIXFLAG FIXX FIXY
global COORD_VARS
set(findobj('Tag','Mouse_click'),'Enable','on'); % マウスクリックを有効にする
x = get(hObject,'Value');
if x==1;
    FIXFLAG = 2;
    mid_lon = (COORD_VARS.MIN_LON + COORD_VARS.MAX_LON) / 2.0; % 中央経度を計算
    mid_lat = (COORD_VARS.MIN_LAT + COORD_VARS.MAX_LAT) / 2.0; % 中央緯度を計算
    h = findobj('Tag','edit_fixlon');
    set(h,'String',num2str(mid_lon,'%7.2f'));
    h = findobj('Tag','edit_fixlat');
    set(h,'String',num2str(mid_lat,'%6.2f'));
    a = lonlat2xy([mid_lon mid_lat]); % 中央点をXY座標に変換
    FIXX = a(1);
    FIXY = a(2);
end

%-------------------------------------------------------------------------
%	  FIXED X POSITION (textfield) 固定X座標に対応するテキストフィールドのコールバック関数
%-------------------------------------------------------------------------
function edit_fixx_Callback(hObject, eventdata, handles)
% 固定されたX座標が入力されたときの処理
global FIXFLAG FIXX FIXY
global CALC_CONTROL
FIXX = str2double(get(hObject,'String'));
CALC_CONTROL.ICOORD = 1;
FIXFLAG = 1;
h = findobj('Tag','edit_fixy');
FIXY = str2double(get(h,'String'));
    
% --- テキストフィールドが作成されたときの初期設定
function edit_fixx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global FIXX
FIXX = str2double(get(hObject,'String'));

%-------------------------------------------------------------------------
%	  FIXED Y POSITION (textfield) 固定Y座標に対応するテキストフィールドのコールバック関数
%-------------------------------------------------------------------------
function edit_fixy_Callback(hObject, eventdata, handles)
% 固定されたY座標が入力されたときの処理
global FIXFLAG FIXX FIXY
FIXY = str2double(get(hObject,'String'));
h = findobj('Tag','edit_fixx');
FIXX = str2double(get(h,'String'));

% --- テキストフィールドが作成されたときの初期設定
function edit_fixy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global FIXY
FIXY = str2double(get(hObject,'String'));

%-------------------------------------------------------------------------
%	  FIXED LON POSITION (textfield) 固定経度に対応するテキストフィールドのコールバック関数
%-------------------------------------------------------------------------
function edit_fixlon_Callback(hObject, eventdata, handles)
% 固定された経度が入力されたときの処理
global FIXX FIXY
target_lon = str2double(get(hObject,'String'));
target_lat = str2double(get(findobj('Tag','edit_fixlat'),'String'));
set(hObject,'String',num2str(target_lon,'%7.2f'));
a = lonlat2xy([target_lon target_lat]);
FIXX = a(1);
FIXY = a(2);
    
% --- テキストフィールドが作成されたときの初期設定
function edit_fixlon_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	  FIXED LAT POSITION (textfield) 固定緯度に対応するテキストフィールドのコールバック関数
%-------------------------------------------------------------------------
function edit_fixlat_Callback(hObject, eventdata, handles)
% 固定された緯度が入力されたときの処理
global FIXX FIXY
target_lon = str2double(get(findobj('Tag','edit_fixlon'),'String'));
target_lat = str2double(get(hObject,'String'));
set(hObject,'String',num2str(target_lat,'%7.2f'));
a = lonlat2xy([target_lon target_lat]);
FIXX = a(1);
FIXY = a(2);
    
% --- テキストフィールドが作成されたときの初期設定
function edit_fixlat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	  CALC DEPTH 計算深度に対応するテキストフィールドのコールバック関数
%-------------------------------------------------------------------------
function edit_displdepth_Callback(hObject, eventdata, handles)
% 計算深度が入力されたときの処理
global FLAG_DEPTH
global INPUT_VARS
global CALC_CONTROL
INPUT_VARS.CALC_DEPTH = str2num(get(hObject,'String'));
FLAG_DEPTH = 1;
CALC_CONTROL.IACT = 0;

% --- テキストフィールドが作成されたときの初期設定
function edit_displdepth_CreateFcn(hObject, eventdata, handles)
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.CALC_DEPTH,'%5.2f'));

%=========================================================================
%	  Executes on button press in Mouse_click. マウスクリックに対応するコールバック関数
%=========================================================================
function Mouse_click_Callback(hObject, eventdata, handles)
% マウスクリックに対応する処理
global FIXX FIXY FIXFLAG
global H_MAIN A_MAIN
global CALC_CONTROL

temp_reserve = CALC_CONTROL.FUNC_SWITCH;
xy = [];
n = 0;
figure(H_MAIN);
[xi,yi,but] = ginput(1); % クリックした位置の座標を取得
xy(:,1) = [xi;yi];
FIXX = xy(1,1);
FIXY = xy(2,1);

if FIXFLAG == 1
    h = findobj('Tag','edit_fixx');
    set(h,'String',num2str(xi,'%7.2f'));
    h = findobj('Tag','edit_fixy');
    set(h,'String',num2str(yi,'%7.2f'));
    plot(A_MAIN,xi,yi,'ro'); 
elseif FIXFLAG == 2
    h = findobj('Tag','edit_fixlon');
    set(h,'String',num2str(xi,'%7.2f'));
    h = findobj('Tag','edit_fixlat');
    set(h,'String',num2str(yi,'%7.2f'));
    plot(A_MAIN,xi,yi,'ro');
    a = lonlat2xy([xi yi]);
    FIXX = a(1);
    FIXY = a(2);
end

figure(H_MAIN);
delete(axes('Parent',H_MAIN));
hold on;
CALC_CONTROL.FUNC_SWITCH = temp_reserve;

calc_button_Callback
hold on;
plot(A_MAIN, xi, yi, 'ro');
    
%=========================================================================
%	  CALC & VIEW BUTTON 計算および表示ボタンに対応するコールバック関数
%=========================================================================
function calc_button_Callback(hObject, eventdata, handles)
% 計算および表示ボタンが押されたときの処理
global FIXFLAG H_MAIN A_MAIN FIXX FIXY
global FLAG_DEPTH H_SECTION
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global SYSTEM_VARS
global OVERLAY_VARS

temp_reserve = CALC_CONTROL.FUNC_SWITCH;
%--- 深度が変更されたときの処理 -----------

if CALC_CONTROL.IACT ~= 1        
    Okada_halfspace2;
end

CALC_CONTROL.IACT = 1; % Okadaの結果を保持
a = OKADA_OUTPUT.DC3D(:,1:2);
b = OKADA_OUTPUT.DC3D(:,5:8);
c = horzcat(a,b);
format long;

if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
    cd output_files;
else
    cd (SYSTEM_VARS.PREF_DIR);
end

header1 = ['Input file selected: ', SYSTEM_VARS.INPUT_FILE];
header2 = 'x y z UX UY UZ';
header3 = '(km) (km) (km) (m) (m) (m)';
dlmwrite('Displacement.cou',header1,'delimiter',''); 
dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
disp(['Displacement.cou is saved in ' pwd]);
cd (SYSTEM_VARS.HOME_DIR);

FLAG_DEPTH = 0;

%------------------------------------------------------
% カルテシアン座標系での計算
if FIXFLAG == 1
    h = findobj('Tag','edit_fixx');
    FIXX = str2double(get(h,'String'));
    h = findobj('Tag','edit_fixy');
    FIXY = str2double(get(h,'String'));
    figure(H_MAIN);
    delete(axes('Parent',H_MAIN));
    hold on;
    CALC_CONTROL.FUNC_SWITCH = temp_reserve;
    h = findobj('Tag','slider_displ');
	displ_open2(get(h,'Value'));
    hold on;
    plot(A_MAIN, FIXX, FIXY, 'ro');  

% 経度・緯度座標系での計算
elseif FIXFLAG == 2
    h1 = findobj('Tag','edit_fixlon');
    h2 = findobj('Tag','edit_fixlat');
    if isempty(get(h1,'String'))~=1 & isempty(get(h2,'String'))~=1
        b1 = str2double(get(h1,'String'));
        b2 = str2double(get(h2,'String'));
        a = lonlat2xy([b1 b2]);
        FIXX = a(1);
        FIXY = a(2);
        figure(H_MAIN);
        delete(axes('Parent',H_MAIN));
        hold on;
    	CALC_CONTROL.FUNC_SWITCH = temp_reserve;
        h = findobj('Tag','slider_displ');
        displ_open2(get(h,'Value'));
        hold on;
        plot(A_MAIN,b1,b2,'ro');
    else
        warndlg('Put number in Lon & Lat textboxes');
    end   

% 固定点なしの計算
else
    figure(H_MAIN);
    delete(axes('Parent',H_MAIN));
    hold on;
    CALC_CONTROL.FUNC_SWITCH = temp_reserve;
    h = findobj('Tag','slider_displ');
    displ_open2(get(h,'Value'));
end

% ----- オーバーレイ描画 --------------------------------
if isempty(OVERLAY_VARS.COAST_DATA) ~= 1 | isempty(OVERLAY_VARS.EQ_DATA) ~= 1 | isempty(OVERLAY_VARS.AFAULT_DATA) ~= 1
    hold on;
    overlay_drawing2;
end

% ----- 断面ウィンドウが存在する場合の更新処理 ------------
h = findobj('Tag','section_view_window');
if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    draw_dipped_cross_section;
    displacement_section;
end

% ----- 表示をカルテシアンまたは経度・緯度座標系で更新
if CALC_CONTROL.IACT == 0
    if COORD_VARS.ICOORD == 1
        set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off');
        set(findobj('Tag','text_disp_lon'),'Visible','off');
        set(findobj('Tag','text_disp_lat'),'Visible','off');
        set(findobj('Tag','edit_fixlon'),'Visible','off');
        set(findobj('Tag','edit_fixlat'),'Visible','off');
        set(findobj('Tag','radiobutton_fixcart'),'Visible','on');
        set(findobj('Tag','text_cart_x'),'Visible','on');
        set(findobj('Tag','text_cart_y'),'Visible','on');
        set(findobj('Tag','text_x_km'),'Visible','on');
        set(findobj('Tag','text_y_km'),'Visible','on');
        set(findobj('Tag','edit_fixx'),'Visible','on');
        set(findobj('Tag','edit_fixy'),'Visible','on');  
    else
        set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
        set(findobj('Tag','text_cart_x'),'Visible','off');
        set(findobj('Tag','text_cart_y'),'Visible','off');
        set(findobj('Tag','text_x_km'),'Visible','off');
        set(findobj('Tag','text_y_km'),'Visible','off');
        set(findobj('Tag','edit_fixx'),'Visible','off');
        set(findobj('Tag','edit_fixy'),'Visible','off');  
        set(findobj('Tag','radiobutton_fixlonlat'),'Visible','on');
        set(findobj('Tag','text_disp_lon'),'Visible','on');
        set(findobj('Tag','text_disp_lat'),'Visible','on');
        set(findobj('Tag','edit_fixlon'),'Visible','on');
        set(findobj('Tag','edit_fixlat'),'Visible','on');
    end 
end

%-------------------------------------------------------------------------
%	  CROSS SECTION BUTTON (Button) 断面ウィンドウボタンに対応するコールバック関数
%-------------------------------------------------------------------------
function cross_section_w_Callback(hObject, eventdata, handles)
% 断面ウィンドウボタンが押されたときの処理
global H_SEC_WINDOW
global CALC_CONTROL

temp_reserve = CALC_CONTROL.FUNC_SWITCH;
H_SEC_WINDOW = xsec_window; % 断面ウィンドウを表示
set(findobj('Tag','text_downdip_inc'),'Visible','off');
set(findobj('Tag','edit_downdip_inc'),'Visible','off');
set(findobj('Tag','text_downdip_inc_km'),'Visible','off');
set(findobj('Tag','text_section_dip'),'Visible','off');
set(findobj('Tag','edit_section_dip'),'Visible','off');
set(findobj('Tag','text_section_dip_deg'),'Visible','off');
CALC_CONTROL.FUNC_SWITCH = temp_reserve; % 状態をリセット

%-------------------------------------------------------------------------
%	  EXAGGERATION (Textfield) 誇張（Exaggeration）に対応するテキストフィールドのコールバック関数
%-------------------------------------------------------------------------
function exaggeration_Callback(hObject, eventdata, handles)
% 誇張が変更されたときの処理
global INPUT_VARS
global DISP_SCALE

ds = str2num(get(hObject,'String'));
DISP_SCALE = int32(ds/INPUT_VARS.SIZE(3,1)); % 誇張スケールを設定
set(hObject,'String',num2str(ds,'%6.0f'));
h = findobj('Tag','slider_displ');
mx = get(h,'Max');
if DISP_SCALE >= mx
    set(h,'Value',mx);
    set(hObject,'String',num2str(mx*INPUT_VARS.SIZE(3,1),'%6.0f'));
else
    set(h,'Value',DISP_SCALE);
end
calc_button_Callback;

function exaggeration_CreateFcn(hObject, eventdata, handles)
% テキストフィールドが作成されたときの初期設定
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.SIZE(3,1),'%6.0f')); % 初期の誇張スケールを設定
