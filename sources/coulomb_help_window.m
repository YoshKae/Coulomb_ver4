function varargout = coulomb_help_window(varargin)
% COULOMB_HELP_WINDOWは、新しいCOULOMB_HELP_WINDOWウィンドウを作成するか、既存のウィンドウをアクティブにします。
%
% H = COULOMB_HELP_WINDOWは、新しいCOULOMB_HELP_WINDOWのハンドルを返すか、既存のシングルトンのハンドルを返します。
%
% COULOMB_HELP_WINDOW('CALLBACK',hObject,eventData,handles,...)は、指定された入力引数でCOULOMB_HELP_WINDOW.M内のCALLBACKという名前のローカル関数を呼び出します。
%
% COULOMB_HELP_WINDOW('Property','Value',...)は、新しいCOULOMB_HELP_WINDOWを作成するか、既存のシングルトンを生成します。
% 左から順に、プロパティと値のペアが適用され、coulomb_help_window_OpeningFunctionが呼び出される前にGUIに適用されます。
% 認識できないプロパティ名や無効な値が指定された場合、プロパティの適用は停止されます。
% すべての入力は、vararginを介してcoulomb_help_window_OpeningFcnに渡されます。


% 初期化コードの開始 - 編集しないでください。--------------------------------

gui_Singleton = 1; % GUIのシングルトンモードを設定
gui_State = struct('gui_Name',       mfilename, ...                       % GUIの名前を設定
                   'gui_Singleton',  gui_Singleton, ...                   % シングルトンモードを適用
                   'gui_OpeningFcn', @coulomb_help_window_OpeningFcn, ... % GUIの開始時に実行される関数を設定
                   'gui_OutputFcn',  @coulomb_help_window_OutputFcn, ...  % 出力時に実行される関数を設定
                   'gui_LayoutFcn',  [] , ...                             % レイアウト関数がないことを示す
                   'gui_Callback',   []);                                 % コールバック関数がないことを示す

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});                       % コールバック関数が指定されている場合、その関数を設定
end

% 出力が要求されている場合、GUIを実行してその結果を返す
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% 出力が要求されていない場合、GUIを実行するだけ
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください。--------------------------------


% --- coulomb_help_windowが表示される直前に実行される。
function coulomb_help_window_OpeningFcn(hObject, eventdata, handles, varargin)
% この関数は、GUIが表示される前に実行され、ウィンドウの初期設定を行います。

global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
global SHADE_TYPE

j = get(hObject,'Position');               % 現在のウィンドウの位置とサイズを取得
wind_width = j(1,3);                       % ウィンドウの幅を取得
wind_height = j(1,4);                      % ウィンドウの高さを取得
dummy = findobj('Tag','main_menu_window'); % メインメニューウィンドウのハンドルを取得

if isempty(dummy)~=1
    % メインメニューウィンドウの位置を取得
    h = get(dummy,'Position');
end

xpos = h(1,1) + h(1,3) + 5;                % ウィンドウのX座標位置を設定
ypos = (SCRS(1,4) - SCRW_Y) - wind_height; % ウィンドウのY座標位置を設定
set(hObject,'Position',[xpos ypos wind_width wind_height]); % ウィンドウの位置とサイズを設定


% デフォルトのコマンドライン出力を設定
handles.output = hObject;

% ハンドル構造を更新して、GUIデータを保存
guidata(hObject, handles);


% --- この関数の出力はコマンドラインに返される。
function varargout = coulomb_help_window_OutputFcn(hObject, eventdata, handles) 

% ハンドル構造からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%   閉じるボタンの処理
%-------------------------------------------------------------------------
function pushbutton_help_close_Callback(hObject, eventdata, handles)

    h = figure(gcf); % 現在のウィンドウのハンドルを取得
close(h); % ウィンドウを閉じる


%-------------------------------------------------------------------------
%   検索結果を出力
%-------------------------------------------------------------------------
function edit_search_result_Callback(hObject, eventdata, handles)

% --- オブジェクトの作成時に実行され、すべてのプロパティ設定後に実行される。
function edit_search_result_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を設定（通常、Windowsでは白）
end


%-------------------------------------------------------------------------
%   検索ワードの入力（テキストフィールド）
%-------------------------------------------------------------------------
function edit_search_word_Callback(hObject, eventdata, handles)

% MATLABのバージョンを確認し、検索ワードに一致するヘルプ情報を表示する処理
srcword = get(hObject,'String'); % 入力された検索ワードを取得
n = 500;                         % ヘルプリストの最大数
c = cell(n);                     % ヘルプリストのセル配列を初期化
hresult = cell(n);               % 検索結果のセル配列を初期化
help_list;                       % ヘルプリストを取得するスクリプトを実行
help_result;                     % 検索結果を処理するスクリプトを実行
x = strmatch(srcword,hlist);     % 検索ワードに一致するリスト項目を検索

if isempty(x) ~= 1
    m = length(x);
    a = cellstr(hlist);
    for k = 1:m
        c{k} = a{x(k)};
    end
     % 検索結果をリストボックスに表示
    set(findobj('Tag','listbox_help_title'),'String',strvcat(c{:}));
    else
        dummy = ['No match found';'              '];
        % 一致する項目がない場合のメッセージを表示
        set(findobj('Tag','listbox_help_title'),'String',dummy);
    end

x = 1;
% リストボックスから選択された項目を取得
y = deblank(get(findobj('Tag','listbox_help_title'),'String'));

if isempty(y) ~= 1
    keyword0 = y(x,1:end);        % 選択された項目を取得
    z = strmatch(keyword0,hlist); % 選択された項目に一致するヘルプリスト項目を検索
    if isempty(z) ~= 1
        m = length(z);
        for k = 1:m
            b = [hresult{z}];
            set(findobj('Tag','edit_search_result'),'String',b); % 検索結果をテキストフィールドに表示
        end
    else
        set(findobj('Tag','edit_search_result'),'String','No match found'); % 一致する結果がない場合のメッセージを表示
        if ~isempty(dummy)
            set(findobj('Tag','edit_search_result'),'String','              ');
        end
    end
end

% --- オブジェクトの作成時に実行され、すべてのプロパティ設定後に実行される。
function edit_search_word_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を設定（通常、Windowsでは白）
end


%-------------------------------------------------------------------------
%   検索結果のタイトルを出力（リストボックス）
%-------------------------------------------------------------------------
function listbox_help_title_Callback(hObject, eventdata, handles)

% リストボックスで選択されたタイトルに対応するヘルプ情報を表示する処理
x = get(hObject,'Value'); % リストボックスで選択されたインデックスを取得
n = 500;                  % ヘルプリストの最大数
hresult = cell(n);        % 検索結果のセル配列を初期化
help_list;                % ヘルプリストを取得するスクリプトを実行
help_result;              % 検索結果を処理するスクリプトを実行
y = deblank(get(findobj('Tag','listbox_help_title'),'String')); % リストボックスから選択された項目を取得

if isempty(y) ~= 1
    keyword0 = y(x,1:end);        % 選択された項目を取得
    z = strmatch(keyword0,hlist); % 選択された項目に一致するヘルプリスト項目を検索
    if isempty(z) ~= 1
        m = length(z);
        for k = 1:m
            b = [hresult{z}];
            set(findobj('Tag','edit_search_result'),'String',b); % 検索結果をテキストフィールドに表示
        end
    else
        set(findobj('Tag','edit_search_result'),'String','No match found'); % 一致する結果がない場合のメッセージを表示
    end
end


% --- オブジェクトの作成時に実行され、すべてのプロパティ設定後に実行される。
function listbox_help_title_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を設定（通常、Windowsでは白）
end
