function varargout = depth_range_window(varargin)
% この関数は、深さ範囲を指定するためのGUIウィンドウを作成・管理します。
% GUIウィンドウの作成、コールバックの設定、プロパティの初期化を行います。

% 初期化コード - ここは編集しないでください。
gui_Singleton = 1;  % シングルトンモードを設定
gui_State = struct('gui_Name',       mfilename, ...                      % 現在のファイル名
                   'gui_Singleton',  gui_Singleton, ...                  % シングルトンモードを指定
                   'gui_OpeningFcn', @depth_range_window_OpeningFcn, ... % ウィンドウが開かれるときに実行される関数を指定
                   'gui_OutputFcn',  @depth_range_window_OutputFcn, ...  % 出力用の関数を指定
                   'gui_LayoutFcn',  [] , ...                            % レイアウト関数を指定（今回は不要）
                   'gui_Callback',   []);                                % コールバック関数を指定

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});  % コールバック関数を設定
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});  % 出力引数がある場合、GUIを実行して結果を返す
else
    gui_mainfcn(gui_State, varargin{:});  % 出力引数がない場合、GUIを実行するだけ
end
% 初期化コード - ここは編集しないでください。

% --- depth_range_windowが表示される直前に実行
function depth_range_window_OpeningFcn(hObject, eventdata, handles, varargin)
% depth_range_windowが表示される直前に実行される関数です。
% ウィンドウの位置やサイズを設定し、初期設定を行います。

global SCRS SCRW_X SCRW_Y % スクリーンサイズとウィンドウ幅を管理するグローバル変数

h = findobj('Tag','depth_range_window');    % depth_range_windowのハンドルを取得
j = get(h,'Position');                      % ウィンドウの位置とサイズを取得
wind_width = j(3);                          % ウィンドウの幅を取得
wind_height = j(4);                         % ウィンドウの高さを取得
dummy = findobj('Tag','main_menu_window');  % メインメニューウィンドウのハンドルを取得
if isempty(dummy)~=1
    h = get(dummy,'Position');              % メインメニューウィンドウの位置を取得
end
xpos = h(1,1) + h(1,3) + 5;                 % 新しいウィンドウのX座標を計算
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;  % 新しいウィンドウのY座標を計算
set(hObject,'Position',[xpos ypos wind_width wind_height]);  % ウィンドウの位置とサイズを設定

% depth_range_windowのデフォルトのコマンドライン出力を選択
handles.output = hObject;

% ハンドル構造を更新
guidata(hObject, handles);


% --- この関数の出力はコマンドラインに返される。
function varargout = depth_range_window_OutputFcn(hObject, eventdata, handles) 
% この関数は、depth_range_windowの出力をコマンドラインに返すために実行されます。

% ハンドル構造からデフォルトのコマンドライン出力を取得して返す
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     TOP DEPTH (textfield)  
%-------------------------------------------------------------------------
function edit_top_calc_depth_Callback(hObject, eventdata, handles)
% ユーザーが上部の深さを入力または変更したときに実行される関数です。
% 上部の深さの値を取得し、負の値の場合は警告を表示します。

global CALC_DEPTH_TOP
CALC_DEPTH_TOP = str2double(get(hObject,'String'));  % 入力された値を取得
if CALC_DEPTH_TOP < 0.0
    h = warndlg('depth should be positive.','!!Warning!!');  % 負の値の場合は警告を表示
    waitfor(h);  % 警告ダイアログが閉じられるのを待つ
end
set(hObject,'String',num2str(CALC_DEPTH_TOP,'%5.1f'));  % 値をフィールドに設定
check_depth_range;  % 深さ範囲のチェックを実行

% --- オブジェクト作成時に、すべてのプロパティを設定した後に実行される。
function edit_top_calc_depth_CreateFcn(hObject, eventdata, handles)
% 上部の深さの入力フィールドが作成される際に実行される関数です。
% 初期値を設定します。

global CALC_DEPTH_TOP
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CALC_DEPTH_TOP = 0.0;  % 初期値を0.0に設定
set(hObject,'String',num2str(CALC_DEPTH_TOP,'%5.1f'));  % フィールドに初期値を設定

%-------------------------------------------------------------------------
%     BOTTOM DEPTH (textfield)  
%-------------------------------------------------------------------------
function edit_bottom_calc_depth_Callback(hObject, eventdata, handles)
% ユーザーが下部の深さを入力または変更したときに実行される関数です。
% 下部の深さが上部の深さより大きいことを確認します。

global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP
CALC_DEPTH_BOTTOM = str2double(get(hObject,'String'));  % 入力された値を取得
if CALC_DEPTH_BOTTOM <= CALC_DEPTH_TOP
    h = warndlg('The bottom depth should be larger than the top one.','!!Warning!!');  % 不正な値の場合は警告を表示
    waitfor(h);  % 警告ダイアログが閉じられるのを待つ
end
set(hObject,'String',num2str(CALC_DEPTH_TOP,'%5.1f'));  % 値をフィールドに設定
check_depth_range;  % 深さ範囲のチェックを実行

% --- オブジェクト作成時に、すべてのプロパティを設定した後に実行される。
function edit_bottom_calc_depth_CreateFcn(hObject, eventdata, handles)
% 下部の深さの入力フィールドが作成される際に実行される関数です。
% 初期値を設定します。

global CALC_DEPTH_BOTTOM
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CALC_DEPTH_BOTTOM = 20.0;  % 初期値を20.0に設定
set(hObject,'String',num2str(CALC_DEPTH_BOTTOM,'%5.1f'));  % フィールドに初期値を設定

%-------------------------------------------------------------------------
%     DEPTH INC. (textfield)  
%-------------------------------------------------------------------------
function edit_calc_depth_inc_Callback(hObject, eventdata, handles)
% ユーザーが深さの増分を入力または変更したときに実行される関数です。
% 深さの増分が正の値であることを確認します。

global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP CALC_DEPTH_INC CALC_DEPTH_RANGE
CALC_DEPTH_INC = str2double(get(hObject,'String'));  % 入力された値を取得
if CALC_DEPTH_INC <= 0.0
    h = warndlg('The increment should be greater than 0.0.','!!Warning!!');  % 不正な値の場合は警告を表示
    waitfor(h);  % 警告ダイアログが閉じられるのを待つ
end
set(hObject,'String',num2str(CALC_DEPTH_INC,'%5.1f'));  % 値をフィールドに設定
check_depth_range;  % 深さ範囲のチェックを実行

% --- オブジェクト作成時に、すべてのプロパティを設定した後に実行される。
function edit_calc_depth_inc_CreateFcn(hObject, eventdata, handles)
% 深さの増分の入力フィールドが作成される際に実行される関数です。
% 初期値を設定します。

global CALC_DEPTH_INC
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
CALC_DEPTH_INC = 5.0;  % 初期値を5.0に設定
set(hObject,'String',num2str(CALC_DEPTH_INC,'%5.1f'));  % フィールドに初期値を設定

%-------------------------------------------------------------------------
%	--- CHECK ---	
%-------------------------------------------------------------------------
function check_depth_range
% 深さ範囲が正しく設定されているか確認する関数です。
% 増分が範囲を均等に分割するかどうかを確認し、警告を表示することもあります。

global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP CALC_DEPTH_INC CALC_DEPTH_RANGE
mcd = mod((CALC_DEPTH_BOTTOM - CALC_DEPTH_TOP),CALC_DEPTH_INC);  % 増分で割った余りを計算
n_slice = int8((CALC_DEPTH_BOTTOM - CALC_DEPTH_TOP) / CALC_DEPTH_INC - mcd/CALC_DEPTH_INC) + 1;  % スライス数を計算
CALC_DEPTH_RANGE = ones(1,n_slice);  % 深さ範囲のスライス数分の配列を初期化

if mcd ~= 0.0
    h = warndlg('The increment does not split the depth range equally. It automatically shift the bottom.','!!Warning!!');  % 不均等分割の場合は警告を表示
    waitfor(h);  % 警告ダイアログが閉じられるのを待つ
end

for k = 1:n_slice
    CALC_DEPTH_RANGE(1,k) = CALC_DEPTH_TOP + (k - 1) * CALC_DEPTH_INC;  % 各スライスの深さを計算
end
set(findobj('Tag','edit_bottom_calc_depth'),'String',num2str(CALC_DEPTH_RANGE(n_slice),'%5.1f'));  % フィールドに最終的な深さを設定

%-------------------------------------------------------------------------
%     MAXIMUM VALUES (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_max_value_Callback(hObject, eventdata, handles)
% ユーザーが「最大値」ラジオボタンを選択したときに実行される関数です。

global DEPTH_RANGE_TYPE
x = get(hObject,'Value');  % ラジオボタンの値を取得
if x == 1
    DEPTH_RANGE_TYPE = 1;  % 深さ範囲のタイプを「最大値」に設定
    set(findobj('Tag','radiobutton_mean_value'),'Value',0.0);  % 「平均値」ラジオボタンをオフに設定
end

%-------------------------------------------------------------------------
%     MEAN VALUES (radiobutton)  
%-------------------------------------------------------------------------
function radiobutton_mean_value_Callback(hObject, eventdata, handles)
% ユーザーが「平均値」ラジオボタンを選択したときに実行される関数です。

global DEPTH_RANGE_TYPE
x = get(hObject,'Value');  % ラジオボタンの値を取得
if x == 1
    DEPTH_RANGE_TYPE = 2;  % 深さ範囲のタイプを「平均値」に設定
    set(findobj('Tag','radiobutton_max_value'),'Value',0.0);  % 「最大値」ラジオボタンをオフに設定
end

%-------------------------------------------------------------------------
%     OK (pushbutton)  
%-------------------------------------------------------------------------
function pushbutton_depth_range_ok_Callback(hObject, eventdata, handles)
% ユーザーが「OK」ボタンを押したときに実行される関数です。
% 深さ範囲を確定し、GUIウィンドウを閉じます。

global CALC_DEPTH_RANGE
global CALC_DEPTH_BOTTOM CALC_DEPTH_TOP
check_depth_range;  % 深さ範囲のチェックを再度実行
drange = [num2str(int32(CALC_DEPTH_TOP)) '-' num2str(int32(CALC_DEPTH_BOTTOM))];  % 深さ範囲の文字列を作成
set(findobj('Tag','edit_coul_depth'),'String',drange);  % フィールドに深さ範囲を設定
set(findobj('Tag','edit_coul_depth'),'Enable','off');  % フィールドを無効化
set(findobj('Tag','edit_coul_depth'),'Enable','off');  % 再度無効化（2度設定している可能性あり）
set(findobj('Tag','Slip_line'),'Enable','off');  % 「Slip_line」フィールドを無効化
h = figure(gcf);  % 現在のウィンドウを取得
delete(h);  % 現在のウィンドウを閉じる
