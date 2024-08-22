function varargout = calc_principals_window(varargin)
% この関数は、主応力を計算するためのGUIウィンドウを作成・管理します。
% 地質学や構造力学における主応力（Principal Stress）を計算・表示するためのGUIウィンドウを作成します。
% このウィンドウを通じてSigma1（最大主応力）、Sigma2（中間主応力）、Sigma3（最小主応力）の各方向と傾斜を入力し、それらの計算結果を表示します。
% GUI内で行われる計算は、地質構造の分析において重要な役割を果たす、地域的な応力軸の方向を設定するものです。

%    H = CALC_PRINCIPALS_WINDOW は、新しい CALC_PRINCIPALS_WINDOW または既存のシングルトンへのハンドルを返します。
%    CALC_PRINCIPALS_WINDOW('CALLBACK',hObject,eventData,handles,...) は、指定されたコールバック関数を呼び出します。
%    CALC_PRINCIPALS_WINDOW('Property','Value',...) は、新しい CALC_PRINCIPALS_WINDOW を作成するか、既存のシングルトンを生成します。
%    すべての入力は、calc_principals_window_OpeningFcn に渡されます。

% 初期化コードの開始 - 編集しないでください。--------------------------------
% シングルトンモードでGUIを実行する
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calc_principals_window_OpeningFcn, ...
                   'gui_OutputFcn',  @calc_principals_window_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
% コールバック関数が指定されている場合は設定
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% 出力引数が指定されている場合、GUIのメイン関数を実行
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% 出力引数がない場合も、GUIのメイン関数を実行
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください。------------------------------


% --- calc_principals_windowが表示される前に実行されます。
function calc_principals_window_OpeningFcn(hObject, eventdata, handles, varargin)
% この関数は、GUIウィンドウが表示される前に実行され、初期設定を行います。

% 一部のGUIコンポーネントを無効化（Step 2の入力項目など）
set(findobj('Tag','pushbutton_calc_step2'),'Enable','Off');
set(findobj('Tag','edit_d2'),'Enable','Off');
set(findobj('Tag','text_s2_dip'),'Enable','Off');
set(findobj('Tag','text_dip_range'),'Enable','Off');

% calc_principals_windowのデフォルトのコマンドライン出力を設定
handles.output = hObject;

% ハンドル構造の更新
guidata(hObject, handles);


% --- この関数の出力はコマンドラインに返されます。
function varargout = calc_principals_window_OutputFcn(hObject, eventdata, handles) 
% この関数は、GUIが閉じられるか、結果が必要なときに実行されます。
% ハンドル構造体からデフォルトのコマンドライン出力を取得して返す
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%	Sigma 1 のストライクを入力するための関数（Step 1）
%-------------------------------------------------------------------------
function edit_s1_Callback(hObject, eventdata, handles)
% Sigma 1のストライク値を入力後、その値が適切かどうかを確認します。

x = str2num(get(hObject,'String'));
% 範囲外の場合、警告を表示し、値をクリア
if x < 0.0 | x >= 180.0
    h = warndlg('Strike should be 0?s<180 here','!! Warnimg !!');
    waitfor(h);
    set(hObject,'String',''); return;
end

 % 有効な場合、値を表示形式で更新
set(hObject,'String',num2str(x,'%6.1f'));
% 入力値に応じて、次のステップのボタンや入力フィールドを無効化
if isempty(get(findobj('Tag','edit_s1'),'String'))~=1
    set(findobj('Tag','pushbutton_calc_step2'),'Enable','Off');
    set(findobj('Tag','edit_d2'),'Enable','Off');
    set(findobj('Tag','text_s2_dip'),'Enable','Off');
    set(findobj('Tag','text_dip_range'),'Enable','Off');
end

function edit_s1_CreateFcn(hObject, eventdata, handles)
% Sigma 1 のストライク入力フィールドの作成時に実行される関数
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windows用）
end

%-------------------------------------------------------------------------
%	Sigma 1 のディップを入力するための関数（Step 1）
%-------------------------------------------------------------------------
function edit_d1_Callback(hObject, eventdata, handles)
% Sigma 1のディップ値を入力後、その値が適切かどうかを確認します。

x = str2num(get(hObject,'String'));
% 範囲外の場合、警告を表示し、値をクリア
if x < -90.0 | x > 90.0
    h = warndlg('Dip should be -90<s?90 here','!! Warnimg !!');
    waitfor(h);
    set(hObject,'String',''); return;
end

% 有効な場合、値を表示形式で更新
set(hObject,'String',num2str(x,'%6.1f'));
% 入力値に応じて、次のステップのボタンや入力フィールドを無効化
if isempty(get(findobj('Tag','edit_s1'),'String'))~=1
    set(findobj('Tag','pushbutton_calc_step2'),'Enable','Off');
    set(findobj('Tag','edit_d2'),'Enable','Off');
    set(findobj('Tag','text_s2_dip'),'Enable','Off');
    set(findobj('Tag','text_dip_range'),'Enable','Off');
end

function edit_d1_CreateFcn(hObject, eventdata, handles)
% Sigma 1 のディップ入力フィールドの作成時に実行される関数
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windows用）
end

%-------------------------------------------------------------------------
%	計算ボタン（Step 1）
%-------------------------------------------------------------------------
function pushbutton_calc_step1_Callback(hObject, eventdata, handles)
% Step 1 の計算ボタンが押されたときに実行される関数

% グローバル変数を使用してディップ範囲を保持
global S2D_MINMAX

rsin = ones(3,2)*(-1000);
rsin(1,1) = str2num(get(findobj('Tag','edit_s1'),'String'));                 % Sigma 1 ストライク値を取得
rsin(1,2) = str2num(get(findobj('Tag','edit_d1'),'String'));                 % Sigma 1 ディップ値を取得
iflag = 1;
[rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsin,iflag); % 応力軸を計算
S2D_MINMAX = minmax;                                                         % ディップ範囲を保存

% Step 2 のボタンや入力フィールドを有効化
set(findobj('Tag','pushbutton_calc_step2'),'Enable','On');
set(findobj('Tag','edit_d2'),'Enable','On');
set(findobj('Tag','text_s2_dip'),'Enable','On');
set(findobj('Tag','text_dip_range'),'Enable','On');

% ディップ範囲を表示
set(findobj('Tag','text_dip_range'),'String',['Dip range: ',...
    num2str(minmax(1),'%6.1f'),' to ',num2str(minmax(2),'%6.1f'),'��']);

%-------------------------------------------------------------------------
%	計算ボタン（Step 2）
%-------------------------------------------------------------------------
function pushbutton_calc_step2_Callback(hObject, eventdata, handles)
% Step 2 の計算ボタンが押されたときに実行される関数

rsin = ones(3,2)*(-1000);
rsin(1,1) = str2num(get(findobj('Tag','edit_s1'),'String'));                 % Sigma 1 ストライク値を取得
rsin(1,2) = str2num(get(findobj('Tag','edit_d1'),'String'));                 % Sigma 1 ディップ値を取得
rsin(2,2) = str2num(get(findobj('Tag','edit_d2'),'String'));                 % Sigma 2 ディップ値を取得
iflag = 2;
[rsout1,rsout2,rsout3,rsout4,minmax] = set_regional_stress_axes(rsin,iflag); % 応力軸を計算

% 計算結果をGUIの対応するフィールドに表示
set(findobj('Tag','edit_11s'),'String',num2str(rsout1(1,1),'%6.1f'));
set(findobj('Tag','edit_11d'),'String',num2str(rsout1(1,2),'%6.1f'));
set(findobj('Tag','edit_12s'),'String',num2str(rsout1(2,1),'%6.1f'));
set(findobj('Tag','edit_12d'),'String',num2str(rsout1(2,2),'%6.1f'));
set(findobj('Tag','edit_13s'),'String',num2str(rsout1(3,1),'%6.1f'));
set(findobj('Tag','edit_13d'),'String',num2str(rsout1(3,2),'%6.1f'));
set(findobj('Tag','edit_21s'),'String',num2str(rsout2(1,1),'%6.1f'));
set(findobj('Tag','edit_21d'),'String',num2str(rsout2(1,2),'%6.1f'));
set(findobj('Tag','edit_22s'),'String',num2str(rsout2(2,1),'%6.1f'));
set(findobj('Tag','edit_22d'),'String',num2str(rsout2(2,2),'%6.1f'));
set(findobj('Tag','edit_23s'),'String',num2str(rsout2(3,1),'%6.1f'));
set(findobj('Tag','edit_23d'),'String',num2str(rsout2(3,2),'%6.1f'));
set(findobj('Tag','edit_31s'),'String',num2str(rsout3(1,1),'%6.1f'));
set(findobj('Tag','edit_31d'),'String',num2str(rsout3(1,2),'%6.1f'));
set(findobj('Tag','edit_32s'),'String',num2str(rsout3(2,1),'%6.1f'));
set(findobj('Tag','edit_32d'),'String',num2str(rsout3(2,2),'%6.1f'));
set(findobj('Tag','edit_33s'),'String',num2str(rsout3(3,1),'%6.1f'));
set(findobj('Tag','edit_33d'),'String',num2str(rsout3(3,2),'%6.1f'));
set(findobj('Tag','edit_41s'),'String',num2str(rsout4(1,1),'%6.1f'));
set(findobj('Tag','edit_41d'),'String',num2str(rsout4(1,2),'%6.1f'));
set(findobj('Tag','edit_42s'),'String',num2str(rsout4(2,1),'%6.1f'));
set(findobj('Tag','edit_42d'),'String',num2str(rsout4(2,2),'%6.1f'));
set(findobj('Tag','edit_43s'),'String',num2str(rsout4(3,1),'%6.1f'));
set(findobj('Tag','edit_43d'),'String',num2str(rsout4(3,2),'%6.1f'));

%-------------------------------------------------------------------------
%	Sigma 2 のディップを入力するための関数（Step 2）
%-------------------------------------------------------------------------
function edit_d2_Callback(hObject, eventdata, handles)
% Sigma 2のディップ値を入力後、その値が適切かどうかを確認します。

% グローバル変数からディップ範囲を取得
global S2D_MINMAX

x = str2num(get(hObject,'String'));
% 範囲外の場合、警告を表示し、値をクリア
if x < S2D_MINMAX(1) | x > S2D_MINMAX(2)
    h = warndlg('Out of possible dip range','!! Warnimg !!');
    waitfor(h);
    set(hObject,'String',''); return;
end
% 有効な場合、値を表示形式で更新
set(hObject,'String',num2str(x,'%6.1f'));

function edit_d2_CreateFcn(hObject, eventdata, handles)
% Sigma 2 のディップ入力フィールドの作成時に実行される関数

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windows用）
end


%-------------------------------------------------------------------------
%	Close button
%-------------------------------------------------------------------------
function pushbutton_close_Callback(hObject, eventdata, handles)
delete(gcf);


%-------------------------------------------------------------------------
%	Combination 1
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_11s_Callback(hObject, eventdata, handles)

function edit_11s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_11d_Callback(hObject, eventdata, handles)

function edit_11d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_12s_Callback(hObject, eventdata, handles)

function edit_12s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_12d_Callback(hObject, eventdata, handles)

function edit_12d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_13s_Callback(hObject, eventdata, handles)

function edit_13s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_13d_Callback(hObject, eventdata, handles)

function edit_13d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	Combination 2
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_21s_Callback(hObject, eventdata, handles)

function edit_21s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_21d_Callback(hObject, eventdata, handles)

function edit_21d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_22s_Callback(hObject, eventdata, handles)

function edit_22s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_22d_Callback(hObject, eventdata, handles)

function edit_22d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_23s_Callback(hObject, eventdata, handles)

function edit_23s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_23d_Callback(hObject, eventdata, handles)

function edit_23d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	Combination 3
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_31s_Callback(hObject, eventdata, handles)

function edit_31s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_31d_Callback(hObject, eventdata, handles)

function edit_31d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_32s_Callback(hObject, eventdata, handles)

function edit_32s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_32d_Callback(hObject, eventdata, handles)

function edit_32d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_33s_Callback(hObject, eventdata, handles)

function edit_33s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_33d_Callback(hObject, eventdata, handles)

function edit_33d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%	Combination 4
%-------------------------------------------------------------------------
% === S1 strike ===
function edit_41s_Callback(hObject, eventdata, handles)

function edit_41s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S1 dip ===
function edit_41d_Callback(hObject, eventdata, handles)

function edit_41d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 strike ===
function edit_42s_Callback(hObject, eventdata, handles)

function edit_42s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S2 dip ===
function edit_42d_Callback(hObject, eventdata, handles)

function edit_42d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 strike ===
function edit_43s_Callback(hObject, eventdata, handles)

function edit_43s_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% === S3 dip ===
function edit_43d_Callback(hObject, eventdata, handles)

function edit_43d_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
