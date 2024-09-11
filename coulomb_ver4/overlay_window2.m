function varargout = overlay_window2(varargin)
% この関数はGUIで地震や断層のオーバーレイ表示を管理するためのものです。
% GUIの開始、コールバック関数、プロパティの適用、出力管理を行います。

% H = OVERLAY_WINDOW は、新しい OVERLAY_WINDOW のハンドルを返します。
% すべての入力は overlay_window_OpeningFcn を介して渡されます。

% 初期化コード（編集不可）
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
                   'gui_Singleton', gui_Singleton, ...
                   'gui_OpeningFcn', @overlay_window_OpeningFcn, ...
                   'gui_OutputFcn', @overlay_window_OutputFcn, ...
                   'gui_LayoutFcn', [] , ...
                   'gui_Callback', []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- overlay_windowが表示される前に実行される関数
function overlay_window_OpeningFcn(hObject, eventdata, handles, varargin)
% GUIウィンドウが表示される直前に実行されます。
% コマンドライン出力のデフォルト設定
handles.output = hObject;
% ハンドル構造を更新
guidata(hObject, handles);

% --- この関数の出力はコマンドラインに返されます。
function varargout = overlay_window_OutputFcn(hObject, eventdata, handles) 
% デフォルトのコマンドライン出力をハンドル構造から取得
varargout{1} = handles.output;

% --- ラジオボタンでストレスの種類を選択するパネルのコールバック
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
global CALC_CONTROL
selection = get(hObject, 'SelectedObject'); % 選択されたオブジェクトの取得
switch get(selection, 'Tag')
    case 'radiobutton_optfault'
        CALC_CONTROL.STRESS_TYPE = 1; % 最適化された断層のストレス
    case 'radiobutton_optss'
        CALC_CONTROL.STRESS_TYPE = 2; % ストライクスリップ（横ずれ断層）のストレス
    case 'radiobutton_optth'
        CALC_CONTROL.STRESS_TYPE = 3; % スラスト（逆断層）のストレス
    case 'radiobutton_optno'
        CALC_CONTROL.STRESS_TYPE = 4; % ストレスがない場合
    case 'radiobutton_specified'
        CALC_CONTROL.STRESS_TYPE = 5; % 指定されたストレス
end

% ラジオボタンの個別コールバック関数（選択されたストレスタイプを変更）
function radiobutton_optfault_Callback(hObject, eventdata, handles)
global CALC_CONTROL
x = get(hObject, 'Value');
if x == 1
    CALC_CONTROL.STRESS_TYPE = 1;
end

function radiobutton_optss_Callback(hObject, eventdata, handles)
global CALC_CONTROL
x = get(hObject, 'Value');
if x == 1
    CALC_CONTROL.STRESS_TYPE = 2;
end

function radiobutton_optth_Callback(hObject, eventdata, handles)
global CALC_CONTROL
x = get(hObject, 'Value');
if x == 1
    CALC_CONTROL.STRESS_TYPE = 3;
end

function radiobutton_optno_Callback(hObject, eventdata, handles)
global CALC_CONTROL
x = get(hObject, 'Value');
if x == 1
    CALC_CONTROL.STRESS_TYPE = 4;
end

function radiobutton_specified_Callback(hObject, eventdata, handles)
global CALC_CONTROL
x = get(hObject, 'Value');
if x == 1
    CALC_CONTROL.STRESS_TYPE = 5;
end

% --- Coulomb応力の計算を行う関数
function pushbutton_coul_calc_Callback(hObject, eventdata, handles)
% Coulomb応力の計算処理
global SHEAR NORMAL
global INPUT_VARS
global OKADA_OUTPUT
global CALC_CONTROL

% GUIから摩擦係数と計算深度の取得
friction = str2num(get(findobj('Tag', 'edit_coul_fric'), 'String'));
INPUT_VARS.CALC_DEPTH = str2num(get(findobj('Tag', 'edit_coul_depth'), 'String'));

% 深度が0の場合、計算を行わないための最低値を設定
if friction == 0.0
    friction = 0.00001;
end
beta = 0.5 * (atan(1.0 / friction));

% ストレスのタイプに応じて計算を実施
if CALC_CONTROL.STRESS_TYPE == 5
    strike = str2num(get(findobj('Tag', 'edit_spec_strike'), 'String'));
    dip = str2num(get(findobj('Tag', 'edit_spec_dip'), 'String'));
    rake = str2num(get(findobj('Tag', 'edit_spec_rake'), 'String'));
end

% Coulomb応力の計算結果をファイルに書き込む
coulomb = SHEAR + friction * NORMAL;
b = [OKADA_OUTPUT.DC3D(:,1), OKADA_OUTPUT.DC3D(:,2), -OKADA_OUTPUT.DC3D(:,5), coulomb, SHEAR, NORMAL];
dlmwrite('dcff.cou', b, 'delimiter', '\t', 'precision', '%.6f');

% --- Coulomb応力のカラー表示の調整（スライダー）
function slider_coul_sat_Callback(hObject, eventdata, handles)
set(handles.edit_coul_sat, 'String', num2str(get(hObject, 'Value'), 2));
coulomb_view(get(hObject, 'Value'));

% Coulomb応力のカラー表示の調整（テキストボックス）
function edit_coul_sat_Callback(hObject, eventdata, handles)
set(handles.slider_coul_sat, 'Value', str2double(get(hObject, 'String')));
coulomb_view(str2double(get(hObject, 'String')));
