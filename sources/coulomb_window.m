function varargout = coulomb_window(varargin)
% COULOMB_WINDOWは、Coulomb応力変化の計算と可視化を行うためのGUIを管理する関数です。

% GUIの初期化コード - 編集しないでください
gui_Singleton = 1; % GUIをシングルトンとして設定（1つのインスタンスのみ）
gui_State = struct('gui_Name',       mfilename, ...                  % 現在のMファイル名を設定
                   'gui_Singleton',  gui_Singleton, ...              % シングルトン設定を適用
                   'gui_OpeningFcn', @coulomb_window_OpeningFcn, ... % GUIの初期化関数を指定
                   'gui_OutputFcn',  @coulomb_window_OutputFcn, ...  % GUIの出力関数を指定
                   'gui_LayoutFcn',  [] , ...                        % レイアウト関数（使用しない）
                   'gui_Callback',   []);                            % コールバック関数の初期設定（使用しない）
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1}); % コールバック関数が文字列で渡された場合、それを関数に変換
end

% 出力引数が指定された場合、GUIを実行し、その結果を返す
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コード終了 - 編集しないでください

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Opening Function
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function coulomb_window_OpeningFcn(hObject, eventdata, handles, varargin)
% GUIが表示される前に実行される初期化関数
global SCRS SCRW_X SCRW_Y % 画面サイズと幅を管理するグローバル変数
global SHADE_TYPE

receivers_matrix_off;                % 受信機行列を無効にする内部関数を呼び出す
h = findobj('Tag','coulomb_window'); % Coulombウィンドウのハンドルを取得
j = get(h,'Position');               % 現在のウィンドウの位置とサイズを取得
wind_width = j(1,3);                 % ウィンドウの幅を取得
wind_height = j(1,4);                % ウィンドウの高さを取得
dummy = findobj('Tag','main_menu_window'); % メインメニューウィンドウのハンドルを取得

if isempty(dummy)~=1
    h = get(dummy,'Position'); % メインメニューウィンドウの位置を取得
end

xpos = h(1,1) + h(1,3) + 5;  % CoulombウィンドウのX座標位置を設定
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;  % CoulombウィンドウのY座標位置を設定
set(hObject,'Position',[xpos ypos wind_width wind_height]);  % Coulombウィンドウの位置とサイズを設定
SHADE_TYPE = 1;  % デフォルトのシェードタイプを設定

% Coulombウィンドウのデフォルトのコマンドライン出力を設定
handles.output = hObject;

% ハンドル構造の更新
guidata(hObject, handles);

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Output Function
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function varargout = coulomb_window_OutputFcn(hObject, eventdata, handles) 
% GUIが閉じられた際に、コマンドラインに返される出力関数

% ハンドル構造からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;

%------------------------------------------------------------------------
%----- RADIOBUTTON SELECTION --------------------------------------------
function uipanel_receiver_SelectionChangeFcn(hObject,eventdata,handles)
% 受信機設定のラジオボタンが変更された際に実行される関数

global STRESS_TYPE

selection = get(hObject,'SelectedObject');  % 選択されたラジオボタンを取得
switch get(selection,'Tag')
    case 'radiobutton_optfault'
        STRESS_TYPE = 1;  % オプティマムフォールト設定 radiobutton_optfault
    case 'radiobutton_optss'
        STRESS_TYPE = 2;  % ストライクスリップ設定 radiobutton_optss
    case 'radiobutton_optth'
        STRESS_TYPE = 3;  % 張力設定 radiobutton_optth
    case 'radiobutton_optno'
        STRESS_TYPE = 4;  % ノーマル設定 radiobutton_optno
    case 'radiobutton_specified'
        STRESS_TYPE = 5;  % 指定設定 radiobutton_specified
end

% ラジオボタンに対応するコールバック関数
function radiobutton_optfault_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off; % 受信機行列を無効にする
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 1; % オプティマムフォールト設定 radiobutton_optfault
end

function radiobutton_optss_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 2; % ストライクスリップ設定 radiobutton_optss
end

function radiobutton_optth_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 3; % 張力設定 radiobutton_optth
end

function radiobutton_optno_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 4; % ノーマル設定 radiobutton_optno
end

function radiobutton_specified_Callback(hObject, eventdata, handles)
global STRESS_TYPE
receivers_matrix_off;
x = get(hObject,'Value');
if x==1
    STRESS_TYPE = 5; % 指定設定 radiobutton_specified
end

%--------------------------------------------------------------------------
%----- RADIOBUTTON SELECTION 2 --------------------------------------------
function image_shading_SelectionChangeFcn(hObject,eventdata,handles)
% シェーディング設定のラジオボタンが変更された際に実行される関数
global SHADE_TYPE
selection = get(hObject,'SelectedObject')
switch get(selection,'Tag')
    case 'mozaic_radiobutton'
        SHADE_TYPE = 1;  % モザイクシェーディング設定
    case 'interpolating_radiobutton'
        SHADE_TYPE = 2;  % 補間シェーディング設定
end

%-------------------------------------------------------------------------
%                    MOZAIC image 
%-------------------------------------------------------------------------
function mozaic_radiobutton_Callback(hObject, eventdata, handles)
% モザイクイメージのラジオボタンに対応するコールバック関数
global SHADE_TYPE
x = get(hObject,'Value');
if x==1
    SHADE_TYPE = 1;  % モザイクシェーディング設定
    pushbutton_coul_calc_Callback;  % Coulomb応力の計算を実行
end

%-------------------------------------------------------------------------
%                   INTERPOLATED image 
%-------------------------------------------------------------------------
function interpolating_radiobutton_Callback(hObject, eventdata, handles)
% 補間イメージのラジオボタンに対応するコールバック関数
global SHADE_TYPE
x = get(hObject,'Value');
if x==1
    SHADE_TYPE = 2;  % 補間シェーディング設定
    pushbutton_coul_calc_Callback;  % Coulomb応力の計算を実行
end

%-------------------------------------------------------------------------
%     PUSHBUTTON2 (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles) 
input_open(1);  % インプットウィンドウを開く

%-------------------------------------------------------------------------
%     COLOR SATURATION SLIDER (slider)  
%-------------------------------------------------------------------------
function slider_coul_sat_Callback(hObject, eventdata, handles) 
% カラー彩度を調整するスライダーのコールバック関数
global COLORSN
set (handles.edit_coul_sat,'String',num2str(get(hObject,'Value'),2));
COLORSN = get(hObject,'Value');  % 彩度値を取得
pushbutton_coul_calc_Callback;  % Coulomb応力の計算を実行

function slider_coul_sat_CreateFcn(hObject, eventdata, handles) 
% カラー彩度スライダーの作成時に実行される関数
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);  % スライダーの背景色を設定
end

%-------------------------------------------------------------------------
%     Color saturation edit (textfield)  
%-------------------------------------------------------------------------
function edit_coul_sat_Callback(hObject, eventdata, handles)
% カラー彩度を手動で入力するテキストフィールドのコールバック関数
global COLORSN
h = str2double(get(hObject,'String'));               % 入力された彩度値を取得
hmax = get(findobj('Tag','slider_coul_sat'),'Max');  % スライダーの最大値を取得
hmin = get(findobj('Tag','slider_coul_sat'),'Min');  % スライダーの最小値を取得
if h > hmax
    set(handles.slider_coul_sat,'Value',hmax);  % 入力が最大値を超えていたら最大値に設定
elseif h <= hmin
    set(handles.slider_coul_sat,'Value',hmin);
    h = hmin + 0.000001;
else
    set(handles.slider_coul_sat,'Value',h);                
end
COLORSN = h;  % 彩度値を設定
pushbutton_coul_calc_Callback;  % Coulomb応力の計算を実行

function edit_coul_sat_CreateFcn(hObject, eventdata, handles)
% カラー彩度テキストフィールドの作成時に実行される関数
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end

%-------------------------------------------------------------------------
%       Contour (checkbox)
%-------------------------------------------------------------------------
function checkbox_coulomb_contour_Callback(hObject, eventdata, handles)
% Coulomb応力のコンターを表示するかを選択するチェックボックスのコールバック関数
x = get(hObject,'Value');
if x == 1
    warndlg('This takes much time, in particular finer interval. Be patient. Otherwise, check it off.');
end

%-------------------------------------------------------------------------
%     Contour interval edit (textfield)  
%-------------------------------------------------------------------------
function edit_stress_cont_interval_Callback(hObject, eventdata, handles)
% コンターの間隔を設定するテキストフィールドのコールバック関数
global CONT_INTERVAL
h = str2double(get(hObject,'String'));
if h > 0.1
    CONT_INTERVAL = h;  % 入力値が0.1を超えていれば設定
else
    CONT_INTERVAL = 0.1;  % デフォルトの間隔を設定
end
set(hObject,'String',num2str(CONT_INTERVAL,'%3.1f'));  % フィールドに設定値を表示

function edit_stress_cont_interval_CreateFcn(hObject, eventdata, handles)
% コンター間隔のテキストフィールドの作成時に実行される関数
global CONT_INTERVAL
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end
CONT_INTERVAL = 1.0;  % デフォルトの間隔を設定
set(hObject,'String',num2str(CONT_INTERVAL,'%3.1f'));  % フィールドにデフォルト値を表示

%-------------------------------------------------------------------------
%       Close button (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_close_Callback(hObject, eventdata, handles)
% Coulombウィンドウを閉じるボタンのコールバック関数
global IACT
IACT = 0;  % アクティブフラグをリセット
h = figure(gcf);
delete(h);  % ウィンドウを削除

%-------------------------------------------------------------------------
%       Specified fault -- strike -- (textfield)
%-------------------------------------------------------------------------
function edit_spec_strike_Callback(hObject, eventdata, handles)
% 指定された断層のストライクを入力するテキストフィールドのコールバック関数
receivers_matrix_off;
strike = str2num(get(hObject,'String'));
set(hObject,'String',num2str(strike,'%6.1f'));  % フィールドにストライク値を表示
check_coul_input;
dummy = findobj('Tag','slider_strike');
if ~isempty(dummy)
    set(dummy,'Value',strike);  % スライダーにストライク値を反映
end

function edit_spec_strike_CreateFcn(hObject, eventdata, handles)
% ストライクテキストフィールドの作成時に実行される関数
global AV_STRIKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end
set(hObject,'String',num2str(AV_STRIKE,'%6.0f'));  % フィールドにデフォルト値を表示

%-------------------------------------------------------------------------
%       Specified fault -- dip -- (textfield)
%-------------------------------------------------------------------------
function edit_spec_dip_Callback(hObject, eventdata, handles)
% 指定された断層のディップを入力するテキストフィールドのコールバック関数
receivers_matrix_off;
dip = str2num(get(hObject,'String'));
set(hObject,'String',num2str(dip,'%6.1f'));  % フィールドにディップ値を表示
check_coul_input;
dummy = findobj('Tag','slider_dip');
if ~isempty(dummy)
    set(dummy,'Value',dip);  % スライダーにディップ値を反映
end

function edit_spec_dip_CreateFcn(hObject, eventdata, handles)
% ディップテキストフィールドの作成時に実行される関数
global AV_DIP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end
set(hObject,'String',num2str(AV_DIP,'%6.0f'));  % フィールドにデフォルト値を表示

%-------------------------------------------------------------------------
%       Specified fault -- rake -- (textfield)
%-------------------------------------------------------------------------
function edit_spec_rake_Callback(hObject, eventdata, handles)
% 指定された断層のレイクを入力するテキストフィールドのコールバック関数
receivers_matrix_off;
rake = str2num(get(hObject,'String'));
set(hObject,'String',num2str(rake,'%6.1f'));  % フィールドにレイク値を表示
check_coul_input;
dummy = findobj('Tag','slider_rake');
if ~isempty(dummy)
    set(dummy,'Value',rake);  % スライダーにレイク値を反映
end

function edit_spec_rake_CreateFcn(hObject, eventdata, handles)
% レイクテキストフィールドの作成時に実行される関数
global AV_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end
set(hObject,'String',num2str(AV_RAKE,'%6.0f'));  % フィールドにデフォルト値を表示

%-------------------------------------------------------------------------
%       Open sliders to control specified slip (pushbutton)
%-------------------------------------------------------------------------
function pushbutton_open_spec_sliders_Callback(hObject, eventdata, handles)
% 指定された断層のスリップを調整するスライダーを開くためのボタンのコールバック関数
global H_SPECIFIED_SLIDER
dummy = findobj('Tag','figure_specified_slider');
if isempty(dummy)==1
    H_SPECIFIED_SLIDER = specified_slider_window;
else
    figure(H_SPECIFIED_SLIDER);
end

%-------------------------------------------------------------------------
%       Calc. depth (textfield)
%-------------------------------------------------------------------------
function edit_coul_depth_Callback(hObject, eventdata, handles)
% Coulomb応力の計算深度を設定するテキストフィールドのコールバック関数
global IACT DEPTH_RANGE_TYPE
IACT = 0;
DEPTH_RANGE_TYPE = 0;
depth = str2num(get(hObject,'String'));
set(hObject,'String',num2str(depth,'%6.1f'));  % フィールドに深度を表示
check_coul_input;

function edit_coul_depth_CreateFcn(hObject, eventdata, handles)
% Coulomb応力の計算深度テキストフィールドの作成時に実行される関数
global CALC_DEPTH
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end
depth = CALC_DEPTH;
set(hObject,'String',num2str(depth,'%6.1f'));  % フィールドにデフォルト深度を表示

%-------------------------------------------------------------------------
%     Depth range (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_depth_range_Callback(hObject, eventdata, handles)
% 深度範囲を設定するウィンドウを開くボタンのコールバック関数
global IACT H_DEPTH DEPTH_RANGE_TYPE
IACT = 0;
DEPTH_RANGE_TYPE = 1;
H_DEPTH = depth_range_window;

%-------------------------------------------------------------------------
%     Coeff. of friction (textfield)  
%-------------------------------------------------------------------------
function edit_coul_fric_Callback(hObject, eventdata, handles)
% 摩擦係数を入力するテキストフィールドのコールバック関数
global IACT FRIC
IACT = 1;  % 再計算フラグをセット
friction = str2double(get(hObject,'String'));
set(hObject,'String',num2str(friction,'%4.2f'));  % フィールドに摩擦係数を表示
check_coul_input;
FRIC = str2double(get(hObject,'String'));
dummy = findobj('Tag','slider_friction');
if ~isempty(dummy)
    set(dummy,'Value',FRIC);  % スライダーに摩擦係数を反映
end

function edit_coul_fric_CreateFcn(hObject, eventdata, handles)
% 摩擦係数テキストフィールドの作成時に実行される関数
global FRIC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');  % テキストフィールドの背景色を設定
end
friction = FRIC;
set(hObject,'String',num2str(friction,'%4.2f'));  % フィールドにデフォルト摩擦係数を表示

%-------------------------------------------------------------------------
%     Cross section button (????)  -- Cross section control window --
%-------------------------------------------------------------------------
function crosssection_toggle_Callback(hObject, eventdata, handles)
% 断面図を表示するためのボタンのコールバック関数

global H_SEC_WINDOW
global ICOORD SECTION GRID
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DIP SEC_DOWNDIP_INC
global AV_DEPTH

if isempty(SECTION) ~= 1
    SEC_XS = SECTION(1);
    SEC_YS = SECTION(2);
    SEC_XF = SECTION(3);
    SEC_YF = SECTION(4);
    SEC_INCRE = SECTION(5);
    SEC_DEPTH = SECTION(6);
    SEC_DEPTHINC = SECTION(7);
    SEC_DIP = 90.0;
    SEC_DOWNDIP_INC = SECTION(7);
else
    SEC_XS = GRID(1,1)+(GRID(3,1)-GRID(1,1))/4.0;
    SEC_YS = GRID(2,1)+(GRID(4,1)-GRID(2,1))/4.0;
    SEC_XF = GRID(1,1)+3.0*(GRID(3,1)-GRID(1,1))/4.0;
    SEC_YF = GRID(2,1)+3.0*(GRID(4,1)-GRID(2,1))/4.0;
    SEC_INCRE = (GRID(5,1)+GRID(6,1))/5.0;
    SEC_DEPTH = AV_DEPTH * 4.0;
    SEC_DEPTHINC = (GRID(5,1)+GRID(6,1))/5.0;
    SEC_DIP = 90.0;
    SEC_DOWNDIP_INC = (GRID(5,1)+GRID(6,1))/5.0;
end

H_SEC_WINDOW = xsec_window;
set(findobj('Tag','text_downdip_inc'),'Visible','on');
set(findobj('Tag','edit_downdip_inc'),'Visible','on');
set(findobj('Tag','text_downdip_inc_km'),'Visible','on');
set(findobj('Tag','text_section_dip'),'Visible','on');
set(findobj('Tag','edit_section_dip'),'Visible','on');
set(findobj('Tag','text_section_dip_deg'),'Visible','on');

%-------------------------------------------------------------------------
%     Slip line option (checkbutton)  
%-------------------------------------------------------------------------
function Slip_line_Callback(hObject, eventdata, handles)
% スリップラインオプションのチェックボックスのコールバック関数
global FLAG_SLIP_LINE FLAG_PR_AXES
FLAG_SLIP_LINE = get(hObject,'Value');
if FLAG_SLIP_LINE == 1
    FLAG_PR_AXES = 0;
    set(findobj('Tag','principal_axes'),'Value',0);
end

%-------------------------------------------------------------------------
%     Principal axes option (checkbutton)  
%-------------------------------------------------------------------------
function principal_axes_Callback(hObject, eventdata, handles)
% 主軸オプションのチェックボックスのコールバック関数
global FLAG_PR_AXES
FLAG_PR_AXES = get(hObject,'Value');
if FLAG_PR_AXES == 1
    set(findobj('Tag','Slip_line'),'Value',0);
end

%-------------------------------------------------------------------------
%     Receivers matrix off (internal function)  
%-------------------------------------------------------------------------
function receivers_matrix_off
% 受信機行列を無効にする内部関数
global RECEIVERS
RECEIVERS = [];

%-------------------------------------------------------------------------
%     CALC & VIEW (pushbutton) 
%-------------------------------------------------------------------------
function pushbutton_coul_calc_Callback(hObject, eventdata, handles)
% Coulomb応力を計算し、結果を表示するボタンのコールバック関数
coulomb_calc_and_view;
