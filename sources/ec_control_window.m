function varargout = ec_control_window(varargin)
% EC_CONTROL_WINDOW は新しい EC_CONTROL_WINDOW を作成するか、既存のシングルトンを表示します。

%    H = EC_CONTROL_WINDOW は、新しい EC_CONTROL_WINDOW または既存のシングルトンへのハンドルを返します。
%    EC_CONTROL_WINDOW('CALLBACK',hObject,eventData,handles,...) は与えられた入力引数を使用して
%    EC_CONTROL_WINDOW.M の CALLBACK 関数を呼び出します。

%    EC_CONTROL_WINDOW('Property','Value',...) は、新しい EC_CONTROL_WINDOW を作成するか、既存の
%    シングルトンを生成します。プロパティと値のペアは ec_control_window_OpeningFunction が
%    呼び出される前に適用されます。すべての入力は ec_control_window_OpeningFcn に渡されます。

% GUIDE（MATLABのGUIデザインツール）のオプションを参照してください。
% シングルトンモードで実行するオプションが選択されています。

% 初期化コード - 編集しないでください。
gui_Singleton = 1;  % シングルトンモードを有効にする
gui_State = struct('gui_Name',       mfilename, ...                      % 現在のファイル名
                   'gui_Singleton',  gui_Singleton, ...                  % シングルトンモードの指定
                   'gui_OpeningFcn', @ec_control_window_OpeningFcn, ...  % ウィンドウが開かれるときに呼び出される関数
                   'gui_OutputFcn',  @ec_control_window_OutputFcn, ...   % 出力関数
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);                                % コールバック関数
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});                      % コールバックが指定されている場合、関数を設定
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); % 出力引数がある場合
else
    gui_mainfcn(gui_State, varargin{:}); % 出力引数がない場合
end
% 初期化コード終了 - 編集しないでください。

% --- ec_control_window が表示される前に実行されます。
function ec_control_window_OpeningFcn(hObject, eventdata, handles, varargin)
% この関数は、ウィンドウが表示される前の初期設定を行います。

global SCRS SCRW_X SCRW_Y % スクリーンサイズと幅を定義するグローバル変数
global EC_STRESS_TYPE % ストレスの種類を表すグローバル変数

% ウィンドウの位置を設定する
h = findobj('Tag','ec_control_window');
j = get(h,'Position');
wind_width = j(1,3);  % ウィンドウ幅
wind_height = j(1,4);  % ウィンドウ高さ
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end

xpos = h(1,1) + h(1,3) + 5;  % X位置
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;  % Y位置
set(hObject,'Position',[xpos ypos wind_width wind_height]);  % ウィンドウ位置を設定

% デフォルトのストレスタイプを設定
EC_STRESS_TYPE = 1;

% ウィンドウのデフォルト出力を設定
handles.output = hObject;

% ハンドル構造を更新
guidata(hObject, handles);

% --- この関数の出力はコマンドラインに返されます。
function varargout = ec_control_window_OutputFcn(hObject, eventdata, handles) 

% ハンドル構造体からデフォルトのコマンドライン出力を取得する
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%     COULOMB 右横ずれ (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_right_lat_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE

x = get(hObject,'Value'); % ラジオボタンの状態を取得
if x == 1
    EC_STRESS_TYPE = 1;  % Coulomb右横ずれモードを設定
    % 他のストレスタイプをオフにする
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
end


%-------------------------------------------------------------------------
%     COULOMB 逆断層 (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_rev_slip_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
    EC_STRESS_TYPE = 2; % Coulomb逆断層モードを設定
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COULOMB 指定されたすべり角 (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_spec_rake_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
	EC_STRESS_TYPE = 3; % Coulomb指定されたすべり角モードを設定
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COULOMB 各すべり角 (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_coul_ind_rake_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
	EC_STRESS_TYPE = 4;
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_normal_stress'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COULOMB 指定されたすべり角の設定 (textfield)   
%-------------------------------------------------------------------------
function edit_coul_spec_rake_Callback(hObject, eventdata, handles)
global EC_RAKE
EC_RAKE = str2num(get(hObject,'String'));  % すべり角の値を取得
if EC_RAKE > 180.0 | EC_RAKE < -180.0  % 値が範囲外の場合、警告
    h = warndlg('Put the number in a range of -180 to 180.','!! Warning !!');
    waitfor(h);
end
set(hObject,'String',num2str(EC_RAKE,'%6.1f'));

function edit_coul_spec_rake_CreateFcn(hObject, eventdata, handles)
global EC_RAKE
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if isempty(EC_RAKE) == 1
    EC_RAKE = 135.0;  % デフォルトのすべり角を設定
end
set(hObject,'String',num2str(EC_RAKE,'%6.1f'));

%-------------------------------------------------------------------------
%     COEFF FRICTION (textfield) 摩擦係数
%-------------------------------------------------------------------------
function edit_ec_friction_Callback(hObject, eventdata, handles)
global FRIC
FRIC = str2num(get(hObject,'String'));  % 摩擦係数の値を取得
if FRIC > 1.0 | FRIC < 0.0  % 範囲外の値の場合、警告
    h = warndlg('Put the number in a range of 0 to 1.','!! Warning !!');
    waitfor(h);
end
set(hObject,'String',num2str(FRIC,'%4.2f'));

function edit_ec_friction_CreateFcn(hObject, eventdata, handles)
global FRIC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(FRIC,'%4.2f'));

%-------------------------------------------------------------------------
%     NORMAL STRESS CHANGE (radiobutton) 正断層応力変化
%-------------------------------------------------------------------------
function radiobutton_normal_stress_Callback(hObject, eventdata, handles)
global EC_STRESS_TYPE
x = get(hObject,'Value');
if x == 1
    EC_STRESS_TYPE = 5; % 正断層モードを設定
    set(findobj('Tag','radiobutton_coul_rev_slip'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_spec_rake'),'Value',0.0);
    set(findobj('Tag','radiobutton_coul_right_lat'),'Value',0.0);
	set(findobj('Tag','radiobutton_coul_ind_rake'),'Value',0.0);
end

%-------------------------------------------------------------------------
%     COLOR SATURATION LIMITS (textfield) カラー飽和限界
%-------------------------------------------------------------------------
function edit_color_bar_sat_Callback(hObject, eventdata, handles)
global C_SAT
C_SAT = str2num(get(hObject,'String'));  % カラー飽和限界の値を取得
if C_SAT >= 100.0 | C_SAT <= 0.0  % 範囲外の値の場合、警告
    h = warndlg('Put the positive number in a range of 0.01 to 99.99','!! Warning !!');
    waitfor(h);
end
set(hObject,'String',num2str(C_SAT,'%5.2f'));

function edit_color_bar_sat_CreateFcn(hObject, eventdata, handles)
global C_SAT
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(C_SAT,'%5.2f'));

%-------------------------------------------------------------------------
%     CALC & VIEW (pushbutton) 計算と表示
%-------------------------------------------------------------------------
function pushbutton_ec_calc_view_Callback(hObject, eventdata, handles)
global ELEMENT POIS YOUNG FRIC ID
global FUNC_SWITCH
global DC3D IACT
global H_MAIN H_EC_CONTROL
global IMAXSHEAR

hc = wait_calc_window;  % 計算中の待機ダイアログを表示
ch = get(H_MAIN,'Children');

FUNC_SWITCH = 10;  % 機能スイッチを設定

tic
element_condition(ELEMENT,POIS,YOUNG,FRIC,ID);
t1 = toc;
disp([' Elapsed time for element stress calculation = ' num2str(t1,'%10.1f') ' sec.']);

% 3Dグラフィック描画を実行
if IMAXSHEAR ~= 3
    tic
    grid_drawing_3d;
    displ_open(2);
    t2 = toc;
    disp([' Elapsed time for 3D graphic rendering = ' num2str(t2,'%10.1f') ' sec.']);
else
    warndlg('Numerical output only','!! Warning !!')
end

close(hc) % 待機ダイアログを閉じる

%-------------------------------------------------------------------------
%     CLOSE (pushbutton)  ウィンドウを閉じる
%-------------------------------------------------------------------------
function pushbutton_ec_close_Callback(hObject, eventdata, handles)
h = figure(gcf);  % 現在のウィンドウを取得
delete(h);  % ウィンドウを閉じる
