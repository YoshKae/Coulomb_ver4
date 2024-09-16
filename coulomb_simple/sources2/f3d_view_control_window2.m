function varargout = f3d_view_control_window2(varargin)
% 3Dビューの制御を行うためのGUIウィンドウを作成または既存のものを表示する。

% H = F3D_VIEW_CONTROL_WINDOWは、新しいF3D_VIEW_CONTROL_WINDOWを作成するか、既存のシングルトン*を表示する。
% F3D_VIEW_CONTROL_WINDOW('CALLBACK',hObject,eventData,handles,...)は、
% 指定されたコールバック関数を実行する。
% F3D_VIEW_CONTROL_WINDOW('Property','Value',...)は、新しいウィンドウを作成するか、
% 既存のシングルトンを表示する。プロパティ名と値のペアが適用される。

% --- 初期化コード - 編集しないでください。
gui_Singleton = 1;  % GUIをシングルトンとして動作させる設定
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @f3d_view_control_window_OpeningFcn, ...
                   'gui_OutputFcn',  @f3d_view_control_window_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});  % コールバック関数が指定されている場合、その関数を設定
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});  % 出力がある場合は実行結果を返す
else
    gui_mainfcn(gui_State, varargin{:});  % 出力がない場合はGUIを表示するだけ
end
% --- 初期化コード終了 - 編集しないでください。

% --- f3d_view_control_windowが表示される前に実行される関数
function f3d_view_control_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCR_SIZE % スクリーンサイズ（1x4, [x y width height]）と幅

% ウィンドウの位置を設定
h = findobj('Tag','f3d_view_control_window2');  % f3d_view_control_windowのハンドルを取得
j = get(h,'Position');  % ウィンドウの位置とサイズを取得
wind_width = j(1,3);  % ウィンドウの幅
wind_height = j(1,4);  % ウィンドウの高さ
dummy = findobj('Tag','main_menu_window2');  % メインメニューウィンドウのハンドルを取得
if isempty(dummy)~=1
    h = get(dummy,'Position');  % メインメニューウィンドウの位置を取得
end
xpos = h(1,1) + h(1,3) + 5;  % メインメニューの横に配置
ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height;  % ウィンドウのY座標を計算
set(hObject,'Position',[xpos ypos wind_width wind_height]);  % 新しい位置とサイズを設定

% f3d_view_control_windowのデフォルトのコマンドライン出力を設定
handles.output = hObject;
% ハンドル構造体を更新
guidata(hObject, handles);  % 更新されたハンドルデータを保存

% --- コマンドラインへの出力を返す
function varargout = f3d_view_control_window_OutputFcn(hObject, eventdata, handles) 
% デフォルトのコマンドライン出力をハンドル構造体から取得して返す
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     Net slip (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_net_slip_Callback(hObject, eventdata, handles)
% Net slip（総スリップ量）を選択したときのコールバック
global F3D_SLIP_TYPE
x = get(hObject,'Value');  % ボタンの状態を取得
if x == 1
    F3D_SLIP_TYPE = 1;  % 総スリップ量を選択
    set(findobj('Tag','radiobutton_strike_slip'),'Value',0.0);  % 他のラジオボタンをオフにする
    set(findobj('Tag','radiobutton_dip_slip'),'Value',0.0);  % 他のラジオボタンをオフにする
end

%-------------------------------------------------------------------------
%     Strike-slip slip (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_strike_slip_Callback(hObject, eventdata, handles)
% ストライクスリップを選択したときのコールバック
global F3D_SLIP_TYPE
x = get(hObject,'Value');  % ボタンの状態を取得
if x == 1
    F3D_SLIP_TYPE = 2;  % ストライクスリップを選択
    set(findobj('Tag','radiobutton_net_slip'),'Value',0.0);  % 他のラジオボタンをオフにする
    set(findobj('Tag','radiobutton_dip_slip'),'Value',0.0);  % 他のラジオボタンをオフにする
end

%-------------------------------------------------------------------------
%     Dip slip slip (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_dip_slip_Callback(hObject, eventdata, handles)
% ディップスリップを選択したときのコールバック
global F3D_SLIP_TYPE
x = get(hObject,'Value');  % ボタンの状態を取得
if x == 1
    F3D_SLIP_TYPE = 3;  % ディップスリップを選択
    set(findobj('Tag','radiobutton_net_slip'),'Value',0.0);  % 他のラジオボタンをオフにする
    set(findobj('Tag','radiobutton_strike_slip'),'Value',0.0);  % 他のラジオボタンをオフにする
end


%-------------------------------------------------------------------------
%     Saturation slip (text box)  
%-------------------------------------------------------------------------
function edit_slip_color_sat_Callback(hObject, eventdata, handles)
% スリップの色の飽和度を変更する際のコールバック
global SYSTEM_VARS
SYSTEM_VARS.C_SLIP_SAT = str2double(get(hObject,'String'));  % 入力された値を取得し、数値に変換
set(hObject,'String',num2str(SYSTEM_VARS.C_SLIP_SAT,'%6.2f'));  % 数値をフォーマットして表示

%--------------------
function edit_slip_color_sat_CreateFcn(hObject, eventdata, handles)
% スリップの飽和度を初期設定する関数
global SYSTEM_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SYSTEM_VARS.C_SLIP_SAT,'%6.2f'));  

%-------------------------------------------------------------------------
%     Redrawing (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_redraw_Callback(hObject, eventdata, handles)
% 再描画ボタンが押されたときのコールバック
global CALC_CONTROL
CALC_CONTROL.FUNC_SWITCH = 1;  % 再描画フラグを設定
grid_drawing_3d2;  % 3Dグリッドを描画
displ_open2(2);  % 表示を更新
flag = check_lonlat_info2;  % 経度緯度情報を確認
if flag == 1
    all_overlay_enable_on;  % 全てのオーバーレイを有効化
end

%----------------------------------------------------------
function all_overlay_enable_on
% オーバーレイ機能を全て有効にする
set(findobj('Tag','menu_gridlines'),'Enable','On');  % グリッド線を有効化
set(findobj('Tag','menu_coastlines'),'Enable','On');  % 海岸線を有効化
set(findobj('Tag','menu_activefaults'),'Enable','On');  % 活断層を有効化
set(findobj('Tag','menu_earthquakes'),'Enable','On');  % 地震の情報を有効化
