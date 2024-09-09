function varargout = viewpoint3d_window2(varargin)
% viewpoint3d_windowは、新しいVIEWPOINT3D_WINDOWを作成するか、既存のシングルトンをアクティブにします。
% H = viewpoint3d_windowは、新しいviewpoint3d_windowまたは既存のシングルトンへのハンドルを返します。
% VIEWPOINT3D_WINDOW('CALLBACK',hObject,eventData,handles,...)は、指定されたコールバックを実行します。

% VIEWPOINT3D_WINDOW('Property','Value',...)は、新しいVIEWPOINT3D_WINDOWを作成するか、既存のシングルトンをアクティブにします。

% GUIDEオプションに基づいて、GUIの状態を設定
gui_Singleton = 1; % シングルトンモード（単一のインスタンス）
gui_State = struct('gui_Name', mfilename, ...
                   'gui_Singleton', gui_Singleton, ...
                   'gui_OpeningFcn', @viewpoint3d_window_OpeningFcn, ...
                   'gui_OutputFcn', @viewpoint3d_window_OutputFcn, ...
                   'gui_LayoutFcn', [] , ...
                   'gui_Callback', []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1}); % コールバック関数を設定
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); % 結果をコマンドラインに出力
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- VIEWPOINT3D_WINDOWが表示される前に実行される関数
function viewpoint3d_window_OpeningFcn(hObject, eventdata, handles, varargin)
global H_MAIN H_F3D_VIEW
global SCR_SIZE

% ウィンドウの位置とサイズを取得して調整
h = get(hObject,'Position');
wind_width = h(3);  % ウィンドウの幅
wind_height = h(4); % ウィンドウの高さ
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
	h = get(dummy,'Position');
end
xpos = h(1) + h(3) + 5; % x座標の位置を計算
dummy1 = findobj('Tag','f3d_view_control_window');
dummy2 = findobj('Tag','ec_control_window');
if isempty(dummy1)~=1
	h = get(dummy1,'Position');
    ypos = h(2) - wind_height - 30; % y座標の位置を調整
elseif isempty(dummy2)~=1
	h = get(dummy2,'Position');
    ypos = h(2) - wind_height - 30; % 別のウィンドウが存在する場合の調整
else
    ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height;
end
set(hObject,'Position',[xpos ypos wind_width wind_height]); % ウィンドウの新しい位置を設定

% デフォルトのコマンドライン出力を設定
handles.output = hObject;
% ハンドル構造を更新
guidata(hObject, handles);

% --- コマンドラインへの出力を返す関数
function varargout = viewpoint3d_window_OutputFcn(hObject, eventdata, handles) 
% ハンドル構造からデフォルトのコマンドライン出力を取得して返す
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     View (azimuth) - アジマス角の入力を受け付ける
%-------------------------------------------------------------------------
function edit_view_az_Callback(hObject, eventdata, handles)
global VIEW_AZ H_MAIN
global INPUT_VARS
global CALC_CONTROL
VIEW_AZ = str2num(get(hObject,'String'));     % 入力されたアジマス角を取得
set(hObject,'String',num2str(VIEW_AZ,'%4i')); % 取得した値をテキストボックスに表示

% 条件に応じた3D描画の更新
if CALC_CONTROL.FUNC_SWITCH == 1 % 3Dグリッドモデルの場合
    grid_drawing_3d2;
    displ_open2(2);
    flag = check_lonlat_info2;
    if flag == 1
        all_overlay_enable_on;
    end
elseif CALC_CONTROL.FUNC_SWITCH == 10 % 要素条件の計算の場合
    ch = get(H_MAIN,'Children');
    n = length(ch) - 3;
    if n >= 1
        for k = 1:n
            delete(ch(k)); % 古い描画を削除
        end
        set(H_MAIN,'Menubar','figure','Toolbar','none');
    end
    element_condition(INPUT_VARS.ELEMENT,INPUT_VARS.POIS,INPUT_VARS.YOUNG,INPUT_VARS.FRIC,INPUT_VARS.ID); % 要素の状態を計算
    grid_drawing_3d2;
    displ_open2(2);
else % その他の3D表示の処理
	grid_drawing_3d2; hold on;
    displ_open2(2);
    h = findobj('Tag','xlines'); delete(h); % 既存のラインを削除
    h = findobj('Tag','ylines'); delete(h); % 既存のラインを削除
end

% --- edit_view_azのオブジェクトが作成されたときに実行される関数
function edit_view_az_CreateFcn(hObject, eventdata, handles)
global VIEW_AZ
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を設定
end
set(hObject,'String',num2str(VIEW_AZ,'%4i')); % デフォルト値を設定

%-------------------------------------------------------------------------
%     View (vertical elevation) - 仰角の入力を受け付ける
%-------------------------------------------------------------------------
function edit_view_el_Callback(hObject, eventdata, handles)
global VIEW_EL H_MAIN
global INPUT_VARS
global CALC_CONTROL
VIEW_EL = str2num(get(hObject,'String'));     % 入力された仰角を取得
set(hObject,'String',num2str(VIEW_EL,'%4i')); % 取得した値をテキストボックスに表示

% 条件に応じた3D描画の更新
if CALC_CONTROL.FUNC_SWITCH == 1 % 3Dグリッドモデルの場合
    grid_drawing_3d2;
    displ_open2(2);
    flag = check_lonlat_info2;
    if flag == 1
        all_overlay_enable_on;
    end
elseif CALC_CONTROL.FUNC_SWITCH == 10 % 要素条件の計算の場合
    ch = get(H_MAIN,'Children');
    n = length(ch) - 3;
    if n >= 1
        for k = 1:n
            delete(ch(k)); % 古い描画を削除
        end
        set(H_MAIN,'Menubar','figure','Toolbar','none');
    end
    element_condition(INPUT_VARS.ELEMENT,INPUT_VARS.POIS,INPUT_VARS.YOUNG,INPUT_VARS.FRIC,INPUT_VARS.ID); % 要素の状態を計算
    grid_drawing_3d2;
    displ_open2(2);
else % その他の3D表示の処理
	grid_drawing_3d2; hold on;
    displ_open2(2);
    h = findobj('Tag','xlines'); delete(h); % 既存のラインを削除
    h = findobj('Tag','ylines'); delete(h); % 既存のラインを削除
end

% --- edit_view_elのオブジェクトが作成されたときに実行される関数
function edit_view_el_CreateFcn(hObject, eventdata, handles)
global VIEW_EL
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を設定
end
set(hObject,'String',num2str(VIEW_EL,'%4i')); % デフォルト値を設定
