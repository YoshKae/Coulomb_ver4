function varargout = coastline_format(varargin)
% COASTLINE_FORMATは、海岸線のフォーマットを設定するためのGUIを作成または既存のインスタンスを呼び出します。

% H = COASTLINE_FORMATは、新しいCOASTLINE_FORMATまたは既存のシングルトン*へのハンドルを返します。
% COASTLINE_FORMAT('CALLBACK',hObject,eventData,handles,...)は、与えられた入力引数でCOASTLINE_FORMAT.M内のCALLBACKという名前のローカル関数を呼び出します。

% COASTLINE_FORMAT('Property','Value',...)は、新しいCOASTLINE_FORMATを作成するか、既存のシングルトンを生成します。
% 左から順に、プロパティ値のペアがGUIに適用され、coastline_format_OpeningFunctionが呼び出される前に適用されます。
% 認識できないプロパティ名や無効な値はプロパティの適用を停止します。
% すべての入力は、vararginを介してcoastline_format_OpeningFcnに渡されます。


% 初期化コードの開始 - 編集しないでください。--------------------------------

gui_Singleton = 1;                                                     % GUIをシングルトンモードで実行することを指定
gui_State = struct('gui_Name',       mfilename, ...                    % 現在のファイル名を指定
                   'gui_Singleton',  gui_Singleton, ...                % シングルトンモードかどうかを指定
                   'gui_OpeningFcn', @coastline_format_OpeningFcn, ... % 開始時に実行される関数を指定
                   'gui_OutputFcn',  @coastline_format_OutputFcn, ...  % 出力時に実行される関数を指定
                   'gui_LayoutFcn',  [] , ...                          % レイアウト関数が不要であることを指定
                   'gui_Callback',   []);                              % コールバック関数を指定

if nargin && ischar(varargin{1})
    % コールバック関数が指定されている場合、その関数を設定
    gui_State.gui_Callback = str2func(varargin{1});
end

% 出力引数が指定されている場合、GUIを実行してその結果を返す
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    % 出力引数が指定されていない場合、GUIを実行するだけ
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください。-------------------------------


% --- coastline_formatが表示される直前に実行されます。
function coastline_format_OpeningFcn(hObject, eventdata, handles, varargin)
% この関数は、GUIウィンドウが表示される前に実行され、初期設定を行います。

global SCRS SCRW_X SCRW_Y % スクリーンサイズと幅

% 現在のウィンドウ位置とサイズを取得
h = get(hObject,'Position');
wind_width = h(3);            % ウィンドウの幅
wind_height = h(4);           % ウィンドウの高さ

% ウィンドウのX座標とY座標位置を設定
xpos = SCRW_X;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;

% ウィンドウの位置とサイズを適用
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% coastline_formatのデフォルトのコマンドライン出力を設定
handles.output = hObject;

% ハンドル構造体を更新
guidata(hObject, handles);


% --- この関数の出力はコマンドラインに返されます。
function varargout = coastline_format_OutputFcn(hObject, eventdata, handles) 
% この関数は、GUIウィンドウが閉じられたときや、出力を求められたときに実行されます。

% ハンドル構造体からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;
