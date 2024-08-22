function varargout = annotation_window(varargin)
% ANNOTATION_WINDOW M-file for annotation_window.fig
% この関数は、注釈を追加するためのGUIウィンドウを作成します。
% この関数は、MATLAB GUI ウィンドウを通じて、グラフや図に注釈を追加するためのインターフェースを提供します。
% ユーザーは注釈テキストとフォントサイズを指定し、それを確定（OK）またはキャンセル（Cancel）することができます。
% この関数は、特に図やグラフに対してユーザーが注釈を付ける必要がある場合に使用されるものであり、データの視覚化やプレゼンテーションに役立ちます。


% H = ANNOTATION_WINDOWは、新しいANNOTATION_WINDOWまたは既存のシングルトンへのハンドルを返します。
% ANNOTATION_WINDOW('CALLBACK',hObject,eventData,handles,...)は、指定されたコールバックを実行します。

% ANNOTATION_WINDOW('Property','Value',...)は、新しいANNOTATION_WINDOWを作成するか、既存のシングルトンを表示します。
% プロパティ値のペアは、GUIの初期化前に適用されます。
% 認識できないプロパティ名や無効な値がある場合、プロパティの適用は停止されます。
% すべての入力は、annotation_window_OpeningFcnに渡されます。


% 初期化コードの開始 - 編集しないでください------------------------------------------
gui_Singleton = 1;                                                      % GUIがシングルトンモードで動作するよう設定
gui_State = struct('gui_Name',       mfilename, ...                     % 現在のMファイル名を指定
                   'gui_Singleton',  gui_Singleton, ...                 % シングルトンモードの設定
                   'gui_OpeningFcn', @annotation_window_OpeningFcn, ... % GUIの初期化関数
                   'gui_OutputFcn',  @annotation_window_OutputFcn, ...  % GUIの出力関数
                   'gui_LayoutFcn',  [] , ...                           % レイアウト関数がないことを指定
                   'gui_Callback',   []);                               % コールバック関数の設定

% コールバックが文字列で渡された場合、それを関数に変換
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% 出力引数がある場合、GUIを実行して出力を受け取る
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% 出力引数がない場合、単にGUIを実行
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください----------------------------------------


% --- annotation_windowが表示される直前に実行されます。
function annotation_window_OpeningFcn(hObject, eventdata, handles, varargin)

% annotation_windowのデフォルトのコマンドライン出力を設定
% ウィンドウのハンドルをデフォルトの出力に設定
handles.output = hObject;

% ハンドル構造体を更新
guidata(hObject, handles);


% --- この関数の出力がコマンドラインに返されます。
function varargout = annotation_window_OutputFcn(hObject, eventdata, handles) 

% ハンドル構造体からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%	注釈のテキスト入力フィールド：ユーザーが入力した注釈テキストを処理
%-------------------------------------------------------------------------
function edit_annotation_Callback(hObject, eventdata, handles)
global GTEXT_DATA % 注釈データを保存するためのグローバル変数

%     GTEXT_DATA(n+1).x = 0.0;
%     GTEXT_DATA(n+1).y = 0.0;
%     GTEXT_DATA(n+1).handle = 0.00;
%     GTEXT_DATA(n+1).text = [];
%     GTEXT_DATA(n+1).font = 10.0;

% ヒント: get(hObject,'String')はテキスト入力フィールドの内容を文字列として返します
% str2double(get(hObject,'String'))はテキスト入力フィールドの内容を数値として返します


% --- オブジェクトの作成後にプロパティが設定された際に実行されます。
function edit_annotation_CreateFcn(hObject, eventdata, handles)
% handles    ハンドルが作成される前は空のまま
% ヒント: 編集コントロールは通常、Windows上では白い背景を持ちます。
% Windows環境でのデフォルトの背景色を設定
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%	フォントサイズ入力フィールド：ユーザーが指定したフォントサイズを処理
%-------------------------------------------------------------------------
function edit_fontsize_Callback(hObject, eventdata, handles)

% ヒント: get(hObject,'String')はテキスト入力フィールドの内容を文字列として返します
% str2double(get(hObject,'String'))はテキスト入力フィールドの内容を数値として返します

% --- オブジェクトの作成後にプロパティが設定された際に実行されます。
function edit_fontsize_CreateFcn(hObject, eventdata, handles)

% ヒント: 編集コントロールは通常、Windows上では白い背景を持ちます。
% Windows環境でのデフォルトの背景色を設定
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%	キャンセルボタン：キャンセルが押された場合の処理、注釈の追加がキャンセルされ、ウィンドウが閉じる
%-------------------------------------------------------------------------
function pushbutton_an_cancel_Callback(hObject, eventdata, handles)
global ANNOTATION_CANCELED
% キャンセル状態を設定
ANNOTATION_CANCELED = 1;
% 現在のウィンドウを閉じる
delete(figure(gcf));

%-------------------------------------------------------------------------
%	OKボタン：ユーザーが入力したテキストとフォントサイズを GTEXT_DATA に保存し、ウィンドウを閉じる
%-------------------------------------------------------------------------
function pushbutton_an_ok_Callback(hObject, eventdata, handles)
global GTEXT_DATA

    n = length(GTEXT_DATA);                                              % 現在の注釈データの数を取得
    GTEXT_DATA(n+1).text = get(handles.edit_annotation,'String');        % テキスト入力フィールドの内容を取得
    GTEXT_DATA(n+1).font = str2num(get(handles.edit_fontsize,'String')); % フォントサイズ入力フィールドの内容を取得
    delete(figure(gcf));                                                 % 現在のウィンドウを閉じる
