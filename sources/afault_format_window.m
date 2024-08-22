function varargout = afault_format_window(varargin)
% この関数は、活断層データのフォーマットを設定するためのGUIウィンドウを作成します。
% GUIは、新しいウィンドウを作成するか、既存のシングルトンウィンドウを再度表示します。

% H = AFAULT_FORMAT_WINDOWは、新しいウィンドウまたは既存のシングルトンへのハンドルを返します。
% AFAULT_FORMAT_WINDOW('CALLBACK',hObject,eventData,handles,...)は、指定されたコールバックを実行します。

% AFAULT_FORMAT_WINDOW('Property','Value',...)は、新しいウィンドウを作成するか、
% 既存のシングルトンを表示します。プロパティ値のペアは、GUIの初期化前に適用されます。
% 認識できないプロパティ名や無効な値がある場合、プロパティの適用は停止されます。
% すべての入力は、afault_format_window_OpeningFcnに渡されます。

% GUIDE（MATLABのGUI設計ツール）のツールメニューで「GUI allows only one instance to run (singleton)」
% を選択している場合、この関数はシングルトンモードで動作します。

% 初期化コードの開始 - 編集しないでください------------------------------------------
gui_Singleton = 1; % GUIがシングルトンモードで動作するよう設定
gui_State = struct('gui_Name',       mfilename, ...  % 現在のMファイル名を指定
                   'gui_Singleton',  gui_Singleton, ...  % シングルトンモードの設定
                   'gui_OpeningFcn', @afault_format_window_OpeningFcn, ...  % GUIの初期化関数
                   'gui_OutputFcn',  @afault_format_window_OutputFcn, ...  % GUIの出力関数
                   'gui_LayoutFcn',  [] , ...  % レイアウト関数がないことを指定
                   'gui_Callback',   []);  % コールバック関数の設定

% コールバックが文字列で渡された場合、それを関数に変換
if nargin && ischar(varargin{1})   
    gui_State.gui_Callback = str2func(varargin{1});
end

% 出力引数がある場合、GUIを実行して出力を受け取る
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください----------------------------------------


% --- afault_format_windowが表示される直前に実行されます。
function afault_format_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCRS SCRW_X SCRW_Y % スクリーンサイズと幅

% afault_format_windowのデフォルトのコマンドライン出力を設定
% ウィンドウのハンドルをデフォルトの出力に設定
handles.output = hObject;

% ハンドル構造体を更新
guidata(hObject, handles);

% ウィンドウの位置とサイズを調整
h = findobj('Tag','afault_format_window');                  % 'afault_format_window'タグを持つオブジェクトを検索
j = get(h,'Position');                                      % ウィンドウの位置とサイズを取得
wind_width = j(3);                                          % 幅
wind_height = j(4);                                         % 高さ
xpos = SCRW_X;                                              % ウィンドウのx座標位置
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;                  % ウィンドウのy座標位置
set(hObject,'Position',[xpos ypos wind_width wind_height]); % 位置とサイズをウィンドウに適用

% --- この関数の出力がコマンドラインに返されます。
function varargout = afault_format_window_OutputFcn(hObject, eventdata, handles) 

% ハンドル構造体からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;


% ========================================================================
% --- "緯度経度" のラジオボタンが押されたときに実行されます。
function radiobutton_lonlat_Callback(hObject, eventdata, handles)
% hObject    radiobutton_lonlatハンドル（GCBO参照）
% ヒント: get(hObject,'Value')はラジオボタンのトグル状態を返します

% ラジオボタンの状態を取得
x = get(hObject,'Value');
% 他のラジオボタンを解除
if x == 1
    set(findobj('Tag','radiobutton_latlon'),'Value',0);
end

% --- "経度緯度" のラジオボタンが押されたときに実行されます。
function radiobutton_latlon_Callback(hObject, eventdata, handles)

% ラジオボタンの状態を取得
x = get(hObject,'Value');
% 他のラジオボタンを解除
if x == 1
    set(findobj('Tag','radiobutton_lonlat'),'Value',0);
end

% --- キャンセルボタンが押されたときに実行されます。
function pushbutton_af_cancel_Callback(hObject, eventdata, handles)
% 現在のウィンドウを閉じる
delete(figure(gcf));


% --- OKボタンが押されたときに実行されます。
function pushbutton_af_ok_Callback(hObject, eventdata, handles)
global PLATFORM

% 緯度経度のラジオボタンの状態を取得
x = get(findobj('Tag','radiobutton_lonlat'),'Value');
% 現在のウィンドウを閉じる
delete(figure(gcf));

hold on;
% 選択した設定に基づいて活断層を描画する
afault_drawing(x);

%------------------------
% ダミー関数
%------------------------
function dum_intel_mac
% Intel Mac上でEQカタログを読み取るためのダミー関数。
% 何らかの理由で、初回のアクセス時にuigetfileが正常に動作しないため、それを回避するための関数。

% ファイル選択ダイアログを表示
    [filename,pathname] = uigetfile({'*.*'},' Open input file');
    if isequal(filename,0)
        return
    else
        return
    end
