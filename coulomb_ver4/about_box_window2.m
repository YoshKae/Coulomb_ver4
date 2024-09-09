function varargout = about_box_window(varargin)
% ABOUT_BOX_WINDOW M-file for about_box_window.fig
% この関数は、アプリケーションの「About」ボックスを表示するためのGUIウィンドウを作成・管理します。
% GUIは、ユーザーが選択したオプションや表示する情報を管理し、ウィンドウの表示位置や内容を制御します。

%    H = ABOUT_BOX_WINDOWは、新しいABOUT_BOX_WINDOWまたは既存のシングルトンへのハンドルを返す。
%    ABOUT_BOX_WINDOW('CALLBACK',hObject,eventData,handles,...)は、指定されたコールバックを実行します。
%    ABOUT_BOX_WINDOW('Property','Value',...)は、新しいABOUT_BOX_WINDOWを作成するか、既存のシングルトンを生成します。


% 初期化コードの開始 - 編集しないでください.-----------------------------------
% GUIの状態を定義し、関数の振る舞いを設定する.
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @about_box_window_OpeningFcn, ...
                   'gui_OutputFcn',  @about_box_window_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% 出力がある場合、GUIを実行して出力を受け取る
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください.-------------------------------------


% --- about_box_windowが表示される前に実行されます。----------------------------
function about_box_window_OpeningFcn(hObject, eventdata, handles, varargin)
% この関数は、GUIウィンドウが表示される前に実行されます。
% ウィンドウの初期設定を行い、表示位置や内容を設定します。

% hObject    図のハンドル
% eventdata  将来のバージョンの MATLAB で定義される予定のイベントデータ
% handles    ハンドルとユーザーデータを持つ構造体（GUIDATA参照）
% varargin   about_box_window へのコマンドライン引数 (VARARGIN 参照)

% about_box_windowのデフォルトのコマンドライン出力を設定
handles.output = hObject;

% ハンドル構造の更新
guidata(hObject, handles);

%---- ウィンドウの表示位置をスクリーンの右上に設定する
global SCRS SCRW_X SCRW_Y % スクリーンサイズと幅 (1x4, [x y width height])
global SHADE_TYPE
j = get(hObject,'Position');
wind_width = j(3);
wind_height = j(4);
xpos = SCRW_X;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

%---- イメージの設定
cd slides
str = ['About_image.jpg'];
[x,imap] = imread(str);
cd ..
b = image(x);

% --- この関数の出力はコマンドラインに返される。
function varargout = about_box_window_OutputFcn(hObject, eventdata, handles) 

% この関数は、GUIが閉じられたときに呼び出され、出力をコマンドラインに返します。
% GUIウィンドウで設定された出力を取得し、返す。
varargout{1} = handles.output;
