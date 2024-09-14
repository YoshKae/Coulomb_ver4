function varargout = main_menu_window2(varargin)
% 関数の役割: メインメニューウィンドウのエントリポイント。GUIの初期化を行う。
% varargout: 可変長出力引数
% varargin: 可変長入力引数

% GUIの状態を設定
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0; % gui_Singleton: GUIのインスタンスが1つだけかどうかを指定。0は複数のインスタンスを許可。
% gui_State: GUIの状態を管理する構造体
gui_State = struct('gui_Name',       mfilename, ...                    % gui_Name: GUIの名前。mファイル名と同じ。
                   'gui_Singleton',  gui_Singleton, ...                % gui_Singleton: GUIのインスタンスが1つだけかどうかを指定。
                   'gui_OpeningFcn', @main_menu_window_OpeningFcn, ... % gui_OpeningFcn: GUIが開かれるときに呼び出される関数。
                   'gui_OutputFcn',  @main_menu_window_OutputFcn, ...  % gui_OutputFcn: GUIが閉じられるときに呼び出される関数。
                   'gui_LayoutFcn',  [] , ...                          % gui_LayoutFcn: GUIのレイアウト関数。
                   'gui_Callback',   []);                              % gui_Callback: GUIのコールバック関数。
if nargin && ischar(varargin{1})                                       % nargin: 関数に渡された引数の数。ischar: 文字列かどうかを判定。
    gui_State.gui_Callback = str2func(varargin{1});                    % str2func: 文字列を関数ハンドルに変換。
end
if nargout % nargout: 出力引数の数。gui_mainfcnはメイン関数を呼び出して、GUIの初期化や操作を行う。
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); % gui_mainfcn: GUIのメイン関数。
else
    gui_mainfcn(gui_State, varargin{:}); % gui_mainfcn: GUIのメイン関数。
end
% End initialization code - DO NOT EDIT

%-------------------------------------------------------------------------
%   Main menu opening function メインメニューを開く関数
%-------------------------------------------------------------------------
function main_menu_window_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject: GUIのハンドル。handles: GUIのハンドルを格納する構造体。
% main_menu_window2のデフォルトのコマンドライン出力を選択
global SCR_SIZE

handles.output = hObject;              % handles.output: GUIの出力を設定。
guidata(hObject, handles);             % guidata: handles構造体を更新。
% main_menu_window2.fig ファイルを開く
hFig = openfig('main_menu_window2.fig', 'reuse');

% タグを設定
set(hFig, 'Tag', 'main_menu_window2');

% オブジェクトの位置情報を取得
j = get(hFig, 'Position');  % オブジェクトの位置情報を取得

% ウィンドウの幅と高さを取得
wind_width = j(3);  % ウィンドウの幅
wind_height = j(4);  % ウィンドウの高さ
xpos = SCR_SIZE.SCRW_X;                % ウィンドウのx座標
ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height; % ウィンドウのy座標
set(hObject,'Position',[xpos ypos wind_width wind_height]);  % set: プロパティの値を設定。

%-------------------------------------------------------------------------
%   Main menu closing function　メインメニューを閉じる関数
%-------------------------------------------------------------------------
function varargout = main_menu_window_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output; % handles.output: GUIの出力を取得。

%=========================================================================
%    DATA (menu) データメニュー
%=========================================================================
function data_menu_Callback(hObject, eventdata, handles)
% データメニューをクリックしたときのコールバック関数

%-------------------------------------------------------------------------
%           ABOUT (submenu) アバウトサブメニュー
%-------------------------------------------------------------------------
function menu_about_Callback(hObject, eventdata, handles)
% アバウトサブメニューをクリックしたときのコールバック関数
global SYSTEM_VARS
cd slides2                  % slidesディレクトリに移動
str = 'About_image2.jpg'; % 画像ファイル名
[x,imap] = imread(str);     % imread: 画像ファイルを読み込む。
if exist('x')==1
    h = figure('Menubar','none','NumberTitle','off'); % figure: 新しい図を作成。
    axes('position',[0 0 1 1]); % 軸を作成。
    axis image;                 % 軸の設定。
    image(x);                   % 画像を表示。
    drawnow;                    % グラフィックスの更新。

    %===== version check バージョンチェック ===========================
    try
        temp  = '3.2.01';          % temporal for Sep. 12 2010 SCEC class % urlreadが使えないため、一時的にバージョンを設定
        idx   = strfind(temp,'.'); % strfind: 文字列内の特定の文字列の位置を検索。
        newvs = str2num([temp(1:idx(1)-1) temp(idx(1)+1:idx(2)-1) temp(idx(2)+1:end)]);
        idx   = strfind(SYSTEM_VARS.CURRENT_VERSION,'.'); % strfind: 文字列内の特定の文字列の位置を検索。
        curvs = str2num([SYSTEM_VARS.CURRENT_VERSION(1:idx(1)-1) SYSTEM_VARS.CURRENT_VERSION(idx(1)+1:idx(2)-1) SYSTEM_VARS.CURRENT_VERSION(idx(2)+1:end)]);
        if newvs > curvs % 新しいのがあれば更新表示
            versionmsg = [' New version ' temp ' is found. Visit the following website.'];
        else
            versionmsg = '';
        end
    catch
        % インターネットとつながっていなかった場合、あとでバージョンをチェックするようにメッセージを表示
        versionmsg = 'No internet connection. Check the version later.'; 
    end
    
    th = text(460.0,385.0,['  version ' SYSTEM_VARS.CURRENT_VERSION '  ']); % 現在のバージョンを表示
    set(th,'fontsize',16,'fontweight','b','Color','w',...                   % set: プロパティの値を設定。
        'horizontalalignment','center','verticalalignment','middle','backgroundcolor','none','edgecolor','none')
    th1 = text(305.0,420.0,versionmsg);                                     % 新しいバージョンがある場合、メッセージを表示
    set(th1,'fontsize',14,'fontweight','b','Color','w',...                  % set: プロパティの値を設定。
        'horizontalalignment','center','verticalalignment','middle','backgroundcolor','k','edgecolor','none')
    th2 = text(320.0,420.0,' http://earthquake.usgs.gov/research/modeling/coulomb/ '); % USGSのサイトへのリンク
    set(th2,'fontsize',12,'fontweight','b','Color','w',...                             % set: プロパティの値を設定。
        'horizontalalignment','center','verticalalignment','middle','backgroundcolor','none','edgecolor','none')
end
cd .. % 一つ上のディレクトリに移動

%-------------------------------------------------------------------------
%           NEW (submenu)  新規作成サブメニュー
%-------------------------------------------------------------------------
function menu_new_Callback(hObject, eventdata, handles)
% 新規作成サブメニューをクリックしたときのコールバック関数

global H_GRID_INPUT % グリッド入力ウィンドウのハンドル
global INPUT_VARS
global COORD_VARS
global OVERLAY_VARS
global CALC_CONTROL
global SYSTEM_VARS
global OKADA_OUTPUT

coulomb_init2;
clear_obj_and_subfig;

OKADA_OUTPUT.S_ELEMENT = []; % 要素の初期化
CALC_CONTROL.IACT = 0;
INPUT_VARS.INUM = 0;         % INUM: 要素の数
INPUT_VARS.ELEMENT = []; 
INPUT_VARS.GRID = [];        % グリッドの初期化
OVERLAY_VARS.COAST_DATA = [];
OVERLAY_VARS.AFAULT_DATA = [];       % 海岸データ、断層データの初期化
SYSTEM_VARS.INPUT_FILE = 'untitled'; % 入力ファイル名

if COORD_VARS.ICOORD == 2  % 現在の座標モードが「経度と緯度」の場合
    h = warndlg('Coordinates mode automatically changes to ''Cartesian'' now','!! Warning !!'); % warndlg: 警告ダイアログを表示
    waitfor(h);            % waitfor: モーダルダイアログボックスの終了を待つ
    COORD_VARS.ICOORD = 1; % xとyの直交座標に変更
end
if isempty(INPUT_VARS.GRID) % グリッドが空の場合
    INPUT_VARS.GRID(1,1) = -50.01; % x start
    INPUT_VARS.GRID(2,1) = -50.01; % y start
    INPUT_VARS.GRID(3,1) =  50.00; % x finish
    INPUT_VARS.GRID(4,1) =  50.00; % y finish
    INPUT_VARS.GRID(5,1) =   5.00; % x increment % xの増分
    INPUT_VARS.GRID(6,1) =   5.00; % y increment % yの増分
end

H_GRID_INPUT = grid_input_window2;
CALC_CONTROL.FUNC_SWITCH = 0; % 関数スイッチを0に設定
if ~isempty(INPUT_VARS.GRID)  % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on;  % すべての関数を有効にする
    set(findobj('Tag','menu_file_save'),'Enable','On');        % ファイル保存メニュー
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');  % ファイル保存メニュー
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On'); % ファイル保存メニュー
    set(findobj('Tag','menu_map_info'),'Enable','On');         % マップ情報メニュー
    all_overlay_enable_off;                                    % すべてのオーバーレイを無効にする
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); % トレースプットフォルトメニュー
end

%-------------------------------------------------------------------------
%           NEW from Map (submenu)  地図から新規作成サブメニュー
%-------------------------------------------------------------------------
function menu_new_map_Callback(hObject, eventdata, handles)
% 地図から新規作成サブメニューをクリックしたときのコールバック関数

global H_UTM % UTMウィンドウ
global INPUT_VARS
global CALC_CONTROL
global OVERLAY_VARS
global SYSTEM_VARS

coulomb_init2;        % グローバル変数の初期化
clear_obj_and_subfig; % オブジェクトとサブフィギュアをクリア

CALC_CONTROL.IACT = 0;
INPUT_VARS.INUM = 0;
OVERLAY_VARS.COAST_DATA = [];
OVERLAY_VARS.AFAULT_DATA = [];       % 海岸データ、断層データの初期化
SYSTEM_VARS.INPUT_FILE = 'untitled'; % 入力ファイル名

set(findobj('Tag','menu_file_save'),'Enable','Off');
set(findobj('Tag','menu_file_save_ascii'),'Enable','Off');
set(findobj('Tag','menu_file_save_ascii2'),'Enable','Off');
all_functions_enable_off; % すべての関数を無効にする
all_overlay_enable_off;   % すべてのオーバーレイを無効にする

H_UTM = utm_window;
waitfor(H_UTM);              % waitfor: モーダルダイアログボックスの終了を待つ
if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on; % すべての関数を有効にする
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_on;
    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end

%-------------------------------------------------------------------------
%           OPEN/most recent file (submenu) 最近使用したファイルを開くサブメニュー
%-------------------------------------------------------------------------
function menu_most_recent_file_Callback(hObject, eventdata, handles)
% 最近使用したファイルを開くサブメニューをクリックしたときのコールバック関数

global DIALOG_SKIP % ダイアログスキップ
global INPUT_VARS
global CALC_CONTROL
global OVERLAY_VARS

coulomb_init2;
clear_obj_and_subfig;

DIALOG_SKIP = 0;
last_input;
CALC_CONTROL.FUNC_SWITCH = 0;
if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on;
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_off;
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end
if isempty(OVERLAY_VARS.EQ_DATA) % 地震データが空の場合
    set(findobj('Tag','menu_focal_mech'),'Enable','Off'); % フォーカルメカニズムメニューを無効にする
else
    set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
end

%-------------------------------------------------------------------------
%           OPEN (submenu) サブメニューを開く
%-------------------------------------------------------------------------
function menu_file_open_Callback(hObject, eventdata, handles) % サブメニューを開く
global DIALOG_SKIP % ダイアログスキップ
global INPUT_VARS

DIALOG_SKIP = 0;             % ダイアログスキップを0に設定
input_open(1);               % input_open: 入力を開く
if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on;
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_off;
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end
check_overlay_items; % オーバーレイアイテムをチェック

%-------------------------------------------------------------------------
%           OPEN/SKIPPING DIALOG (submenu) ダイアログをスキップして開くサブメニュー
%-------------------------------------------------------------------------
function menu_open_skipping_Callback(hObject, eventdata, handles)
% ダイアログをスキップして開くサブメニューをクリックしたときのコールバック関数
global DIALOG_SKIP % ダイアログスキップ
global INPUT_VARS
global CALC_CONTROL

DIALOG_SKIP = 0;
input_open(3); % 3はオープンウィンドウをスキップすることを意味する
if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on;
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_off;
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end
try % 例外処理
    check_overlay_items; % オーバーレイアイテムをチェック
    if CALC_CONTROL.IACT == 0 % ユーザーがキャンセルを選択した場合、CALC_CONTROL.IACTは1から 'input_open.m' に転送される
    menu_grid_mapview_Callback;
    CALC_CONTROL.FUNC_SWITCH = 0;
    end
catch
    return
end

%-------------------------------------------------------------------------
%           SAVE  AS .MAT(submenu) .MAT形式で保存するサブメニュー  
%-------------------------------------------------------------------------
function menu_file_save_Callback(hObject, eventdata, handles)
% .MAT形式で保存するサブメニューをクリックしたときのコールバック関数
global INPUT_VARS
global COORD_VARS
global OVERLAY_VARS
global SYSTEM_VARS

if isempty(SYSTEM_VARS.PREF)==1 % prefが空の場合
    % デフォルト値を作成して保存する
    SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                        0.0 0.0 0.0 1.0;...
                        0.7 0.7 0.0 0.2;...
                        0.0 0.0 0.0 1.2;...
                        1.0 0.5 0.0 3.0;...
                        0.2 0.2 0.2 1.0;...
                        2.0 0.0 0.0 0.0;...
                        1.0 0.0 0.0 0.0;...
                        0.9 0.9 0.1 1.0];    % volcano 火山のデフォルト値
end
if isempty(SYSTEM_VARS.PREF_DIR) ~= 1 % PREF_DIRが空でない場合
    try
        cd(SYSTEM_VARS.PREF_DIR); % PREF_DIRに移動
    catch
        cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
    end
else
    try
        cd('input_files'); % input_filesに移動
    catch
        cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
    end    
end
[filename,pathname] = uiputfile('*.mat',' Save Input File As'); % ファイルを保存するダイアログボックスを表示
if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
    disp('User selected Cancel')             % ユーザーがキャンセルを選択
else
    disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
end
save(fullfile(pathname,filename), 'INPUT_VARS.HEAD','INPUT_VARS.NUM','INPUT_VARS.POIS','INPUT_VARS.CALC_DEPTH',... % save: ファイルに変数を保存
    'INPUT_VARS.YOUNG','INPUT_VARS.FRIC','INPUT_VARS.R_STRESS','INPUT_VARS.ID','INPUT_VARS.KODE','INPUT_VARS.ELEMENT','INPUT_VARS.FCOMMENT',...
    'INPUT_VARS.GRID','INPUT_VARS.SIZE','INPUT_VARS.SECTION','SYSTEM_VARS.PREF','COORD_VARS.MIN_LAT','COORD_VARS.MAX_LAT','COORD_VARS.ZERO_LAT',...
    'COORD_VARS.MIN_LON','COORD_VARS.MAX_LON','COORD_VARS.ZERO_LON','OVERLAY_VARS.COAST_DATA','OVERLAY_VARS.FAULT_DATA',...
    'OVERLAY_VARS.EQ_DATA','OVERLAY_VARS.GPS_DATA','OVERLAY_VARS.VOLCANO','OVERLAY_VARS.SEISSTATION','-mat');
cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
    
%-------------------------------------------------------------------------
%           SAVE AS ASCII (submenu) ASCII形式で保存するサブメニュー  
%-------------------------------------------------------------------------
function menu_file_save_ascii_Callback(hObject, eventdata, handles)
% ASCII形式で保存するサブメニューをクリックしたときのコールバック関数
global CALC_CONTROL
global SYSTEM_VARS

CALC_CONTROL.IRAKE = 0;         % IRAKEを0に設定
if isempty(SYSTEM_VARS.PREF)==1 % prefが空の場合
    % デフォルト値を作成して保存する
    SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                        0.0 0.0 0.0 1.0;...
                        0.7 0.7 0.0 0.2;...
                        0.0 0.0 0.0 1.2;...
                        1.0 0.5 0.0 3.0;...
                        0.2 0.2 0.2 1.0;...
                        2.0 0.0 0.0 0.0;...
                        1.0 0.0 0.0 0.0]; % デフォルト値
end
if isempty(SYSTEM_VARS.PREF_DIR) ~= 1 % PREF_DIRが空でない場合
    try
        cd(SYSTEM_VARS.PREF_DIR); % PREF_DIRに移動
    catch
        cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
    end
else
    try
        cd('input_files');        % input_filesに移動
    catch
        cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
    end    
end
[filename,pathname] = uiputfile('*.inp',' Save Input File As'); 
if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
    disp('User selected Cancel')             % ユーザーがキャンセルを選択
else
    disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
end
cd(pathname);             % pathnameに移動
input_save_ascii;         % ASCII形式で保存
cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
     
%-------------------------------------------------------------------------
%           SAVE AS ASCII2 (submenu)  - save as "rake" & "net slip" ASCII形式で保存するサブメニュー rakeとネットスリップとして保存
%-------------------------------------------------------------------------
function menu_file_save_ascii2_Callback(hObject, eventdata, handles)
global CALC_CONTROL
global SYSTEM_VARS

CALC_CONTROL.IRAKE = 1;
if isempty(SYSTEM_VARS.PREF)==1
    % デフォルト値を作成して保存する
    SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                        0.0 0.0 0.0 1.0;...
                        0.7 0.7 0.0 0.2;...
                        0.0 0.0 0.0 1.2;...
                        1.0 0.5 0.0 3.0;...
                        0.2 0.2 0.2 1.0;...
                        2.0 0.0 0.0 0.0;...
                        1.0 0.0 0.0 0.0];
end
if isempty(SYSTEM_VARS.PREF_DIR) ~= 1 % PREF_DIRが空でない場合
    try
        cd(SYSTEM_VARS.PREF_DIR);
    catch
        cd(SYSTEM_VARS.HOME_DIR);
    end
else
    try
        cd('input_files');
    catch
        cd(SYSTEM_VARS.HOME_DIR);
    end    
end
[filename,pathname] = uiputfile('*.inr',' Save Input File As');
if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
    disp('User selected Cancel')             % ユーザーがキャンセルを選択
    cd(SYSTEM_VARS.HOME_DIR); return
else
    disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
    cd(pathname);     % pathnameに移動
    input_save_ascii; % ASCII形式で保存
    cd(SYSTEM_VARS.HOME_DIR);
end

%-------------------------------------------------------------------------
%           PUT MAP INFO (submenu) マップ情報を入力するサブメニュー
%-------------------------------------------------------------------------
function menu_map_info_Callback(hObject, eventdata, handles)
% マップ情報を入力するサブメニューをクリックしたときのコールバック関数
global H_STUDY_AREA H_MAIN % スタディエリア、メインウィンドウ
H_STUDY_AREA = study_area; % study_area: スタディエリア
waitfor(H_STUDY_AREA);     % ユーザーの緯度と経度情報の入力を待つ
h = findobj('Tag','main_menu_window2'); % main_menu_windowのハンドルを取得
if isempty(h)~=1 & isempty(H_MAIN)~=1   % main_menu_windowのハンドル、H_MAINが空でない場合
    iflag = check_lonlat_info2;         % 経度と緯度の情報をチェック
    if iflag == 1                       % iflagが1の場合
        all_overlay_enable_on;          % すべてのオーバーレイを有効にする
    end
end

%-------------------------------------------------------------------------
%           PREFERENCES (submenu) プリファレンスサブメニュー
%-------------------------------------------------------------------------
function menu_preferences_Callback(hObject, eventdata, handles)
% プリファレンスサブメニューをクリックしたときのコールバック関数
global SYSTEM_VARS
preference_window; % プリファレンスウィンドウ
if SYSTEM_VARS.OUTFLAG == 1
    h = findobj('Tag','Radiobutton_output'); % Radiobutton_outputのハンドルを取得
    set(h,'Value',1);                        % Valueを1に設定
    h = findobj('Tag','Radiobutton_input');  % Radiobutton_inputのハンドルを取得
    set(h,'Value',0);                        % Valueを0に設定
else
    h = findobj('Tag','Radiobutton_output'); % Radiobutton_outputのハンドルを取得
    set(h,'Value',0);                        % Valueを0に設定
    h = findobj('Tag','Radiobutton_input');  % Radiobutton_inputのハンドルを取得
    set(h,'Value',1);                        % Valueを1に設定
end

%-------------------------------------------------------------------------
%           QUIT (submenu) 終了サブメニュー
%-------------------------------------------------------------------------
function menu_quit_Callback(hObject, eventdata, handles)
% 終了サブメニューをクリックしたときのコールバック関数
global H_HELP FNUM_ONOFF 
global SYSTEM_VARS
subfig_clear;  % サブフィギュアをクリア
tempdir = pwd; % 現在のディレクトリを取得
if ~strcmp(tempdir,SYSTEM_VARS.HOME_DIR) % tempdirとHOME_DIRが異なる場合
    cd(SYSTEM_VARS.HOME_DIR);
end
cd preferences2
    dlmwrite('preferences2.dat',SYSTEM_VARS.PREF,'delimiter',' ','precision','%3.1f'); % プリファレンスを保存 delimiter: 区切り文字
            if isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが空の場合
                SYSTEM_VARS.OUTFLAG = 1;
            end
            if isempty(SYSTEM_VARS.PREF_DIR) == 1 % PREF_DIRが空の場合
                SYSTEM_VARS.PREF_DIR = SYSTEM_VARS.HOME_DIR;
            end
            if isempty(SYSTEM_VARS.INPUT_FILE) == 1 % INPUT_FILEが空の場合
                SYSTEM_VARS.INPUT_FILE = 'empty';
            end
    save preferences2.mat SYSTEM_VARS.PREF_DIR SYSTEM_VARS.INPUT_FILE SYSTEM_VARS.OUTFLAG FNUM_ONOFF; % プリファレンスを保存
cd ..
h = figure(gcf); % 現在の図を取得
delete(h); % 図を削除
% ヘルプウィンドウ（H_HELP）のため
h = findobj('Tag','coulomb_help_window'); % coulomb_help_windowのハンドルを取得
if (isempty(h)~=1 && isempty(H_HELP)~=1)  % hが空でなく、H_HELPが空でない場合
    close(figure(H_HELP))                 % ヘルプウィンドウを閉じる
    H_HELP = [];                          % H_HELPを空にする
end

%=========================================================================
%    FUNCTIONS (menu) 関数メニュー
%=========================================================================
function function_menu_Callback(hObject, eventdata, handles)
% 関数メニューをクリックしたときのコールバック関数

%-------------------------------------------------------------------------
%           GRID (submenu) グリッドサブメニュー
%-------------------------------------------------------------------------
function menu_grid_Callback(hObject, eventdata, handles)
% グリッドサブメニューをクリックしたときのコールバック関数

% --------------------------------------------------------------------
function menu_grid_mapview_Callback(hObject, eventdata, handles)
% グリッドマップビューをクリックしたときのコールバック関数
global COORD_VARS
global CALC_CONTROL
global OVERLAY_VARS

subfig_clear;
CALC_CONTROL.FUNC_SWITCH = 1;
grid_drawing2;
fault_overlay;
if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
    isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1   % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
    hold on;         % 現在の図を保持
    overlay_drawing; % オーバーレイの描画
end
CALC_CONTROL.FUNC_SWITCH = 0; %reset to 0
flag = check_lonlat_info2;    % 経度と緯度の情報をチェック
if flag == 1                  % flagが1の場合
    all_overlay_enable_on;    % すべてのオーバーレイを有効にする
end

% --------------------------------------------------------------------
function menu_grid_3d_Callback(hObject, eventdata, handles)
% 3Dグリッドをクリックしたときのコールバック関数
global F3D_SLIP_TYPE H_F3D_VIEW
global INPUT_VARS
global COORD_VARS
global SYSTEM_VARS
global CALC_CONTROL

if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
    h = warndlg('Sorry this is not available for lat/lon coordinates. Change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
    waitfor(h); % モーダルダイアログボックスの終了を待つ
    return
end
subfig_clear;                 % サブフィギュアをクリア
hc = wait_calc_window;        % wait_calc_window: 計算ウィンドウを待つ
CALC_CONTROL.FUNC_SWITCH = 1; % 関数スイッチを1に設定
F3D_SLIP_TYPE = 1;            % ネットスリップ
element_condition(INPUT_VARS.ELEMENT, INPUT_VARS.POIS, INPUT_VARS.YOUNG, INPUT_VARS.FRIC, INPUT_VARS.ID); % 要素条件
SYSTEM_VARS.C_SLIP_SAT = [];  % C_SLIP_SATを空にする
grid_drawing_3d2;             % 3Dグリッドの描画
displ_open2(2);               % 2を開く
H_F3D_VIEW = f3d_view_control_window2;
gps_3d_overlay;               % GPS 3Dオーバーレイ
flag = check_lonlat_info2;    % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;    % すべてのオーバーレイを有効にする
end
close(hc);                    % hcを閉じる

%-------------------------------------------------------------------------
%           DISPLACEMENT (submenu)  with sub-submenu ディスプレイスメントサブメニュー
%-------------------------------------------------------------------------
function menu_displacement_Callback(hObject, eventdata, handles)
% ディスプレイスメントサブメニューをクリックしたときのコールバック関数

%-------------------------------------------------------------------------
%                       VECTORS (sub-submenu) ベクトルサブサブメニュー
%-------------------------------------------------------------------------
function menu_vectors_Callback(hObject, eventdata, handles)
% ベクトルサブサブメニューをクリックしたときのコールバック関数
global H_DISPL FIXFLAG H_MAIN
global INPUT_VARS
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global OVERLAY_VARS
global SYSTEM_VARS

subfig_clear;                 % サブフィギュアをクリア
CALC_CONTROL.FUNC_SWITCH = 2; % 関数スイッチを2に設定
FIXFLAG = 0;                  % FIXFLAGを0に設定
% Okadaハーフスペースの再計算を回避するため
if CALC_CONTROL.IACT ~= 1        
    Okada_halfspace; % Okadaハーフスペースを計算
end
CALC_CONTROL.IACT = 1;            % Okadaの出力を保持するため
    a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
    b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
    c = horzcat(a,b);             % aとbを水平に連結
    format long;
    if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが1または空の場合
	    cd output_files; % output_filesに移動
    else
	    cd (PSYSTEM_VARS.REF_DIR);
    end
    header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE]; % 選択された入力ファイル
    header2 = 'x y z UX UY UZ';             % ヘッダー
    header3 = '(km) (km) (km) (m) (m) (m)'; % ヘッダー
    dlmwrite('Displacement.cou',header1,'delimiter','');           % Displacement.couにheader1を書き込む
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); % Displacement.couにheader2を追加
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); % Displacement.couにheader3を追加
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f'); % Displacement.couにcを追加
    disp(['Displacement.cou is saved in ' pwd]);                                  % Displacement.couが保存されました
    cd (SYSTEM_VARS.HOME_DIR);
displ_open2(2); % 2を開く
H_DISPL = displ_h_window2;
if COORD_VARS.ICOORD == 1 % COORD_VARS.ICOORDが1の場合 → 経度と緯度のメニューを非表示
    set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off'); % radiobutton_fixlonlatを非表示
    set(findobj('Tag','text_disp_lon'),'Visible','off');         % text_disp_lonを非表示
    set(findobj('Tag','text_disp_lat'),'Visible','off');         % text_disp_latを非表示
    set(findobj('Tag','edit_fixlon'),'Visible','off');           % edit_fixlonを非表示
    set(findobj('Tag','edit_fixlat'),'Visible','off');           % edit_fixlatを非表示
else % COORD_VARS.ICOORDが1でない場合 → カートジアン座標のメニューを非表示
    set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
    set(findobj('Tag','text_cart_x'),'Visible','off');
    set(findobj('Tag','text_cart_y'),'Visible','off'); 
    set(findobj('Tag','text_x_km'),'Visible','off');
    set(findobj('Tag','text_y_km'),'Visible','off');
    set(findobj('Tag','edit_fixx'),'Visible','off');
    set(findobj('Tag','edit_fixy'),'Visible','off');    
end
flag = check_lonlat_info2; % 経度と緯度の情報をチェック
if flag == 1 % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
end
% ----- overlay drawing オーバーレイの描画 --------------------------------
if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
    isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1  % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
    figure(H_MAIN);
    hold on;
    overlay_drawing; % オーバーレイの描画
end

%-------------------------------------------------------------------------
%          WIREFRAME (sub-submenu) ワイヤフレームサブサブメニュー
%-------------------------------------------------------------------------
function menu_wireframe_Callback(hObject, eventdata, handles)
% ワイヤフレームサブサブメニューをクリックしたときのコールバック関数
global FIXFLAG H_DISPL H_MAIN
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global OVERLAY_VARS
global SYSTEM_VARS

subfig_clear;                 % サブフィギュアをクリア
CALC_CONTROL.FUNC_SWITCH = 3; % 関数スイッチを3に設定
FIXFLAG = 0;                  % FIXFLAGを0に設定
% Okadaハーフスペースの再計算を回避するため
if CALC_CONTROL.IACT ~= 1
    Okada_halfspace;          % Okadaハーフスペースを計算
end
CALC_CONTROL.IACT = 1;        % Okadaの出力を保持するため
a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
c = horzcat(a,b);             % aとbを水平に連結
format long;
if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが1または空の場合
    cd output_files;           % output_filesに移動
else
    cd (SYSTEM_VARS.PREF_DIR); % PREF_DIRに移動
end
% Displacement.couをASCII形式で保存
header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE]; % 選択された入力ファイル
header2 = 'x y z UX UY UZ';             % ヘッダー
header3 = '(km) (km) (km) (m) (m) (m)'; % ヘッダー
dlmwrite('Displacement.cou',header1,'delimiter','');             % Displacement.couにheader1を書き込む
dlmwrite('Displacement.cou',header2,'-append','delimiter','\t'); % Displacement.couにheader2を追加
dlmwrite('Displacement.cou',header3,'-append','delimiter','\t'); % Displacement.couにheader3を追加
dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f'); % Displacement.couにcを追加
disp(['Displacement.cou is saved in ' pwd]);                                  % Displacement.couが保存されました
cd (SYSTEM_VARS.HOME_DIR);                                                    % HOME_DIRに移動

displ_open2(2); % 2を開く
H_DISPL = displ_h_window2; % ディスプレイスメントウィンドウ
set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off'); % radiobutton_fixlonlatを非表示
set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
set(findobj('Tag','text_cart_x'),'Visible','off');
set(findobj('Tag','text_cart_y'),'Visible','off');
set(findobj('Tag','edit_fixx'),'Visible','off');
set(findobj('Tag','edit_fixy'),'Visible','off');
set(findobj('Tag','text_x_km'),'Visible','off');
set(findobj('Tag','text_y_km'),'Visible','off');
set(findobj('Tag','text_disp_lon'),'Visible','off');
set(findobj('Tag','text_disp_lat'),'Visible','off');
set(findobj('Tag','edit_fixlon'),'Visible','off');
set(findobj('Tag','edit_fixlat'),'Visible','off');
set(findobj('Tag','Mouse_click'),'Visible','off');
flag = check_lonlat_info2; % 経度と緯度の情報をチェック
if flag == 1 % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
end
% ----- overlay drawing オーバーレイの描画 --------------------------------
if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
    isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1  % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
    figure(H_MAIN);
    hold on;         % H_MAINの図を保持
    overlay_drawing; % オーバーレイの描画
end

%-------------------------------------------------------------------------
%              CONTOURS (sub-submenu) コンターサブサブメニュー
%-------------------------------------------------------------------------
function menu_contours_Callback(hObject, eventdata, handles)
% コンターサブサブメニューをクリックしたときのコールバック関数
global VD_CHECKED H_MAIN
global CALC_CONTROL
global OKADA_OUTPUT
global OVERLAY_VARS
global SYSTEM_VARS

subfig_clear;                 % サブフィギュアをクリア
CALC_CONTROL.FUNC_SWITCH = 4; % 関数スイッチを4に設定
VD_CHECKED = 0;               % default
CALC_CONTROL.SHADE_TYPE = 1;  % default
grid_drawing2;                % グリッドの描画
if CALC_CONTROL.IACT ~= 1
    Okada_halfspace;          % Okadaハーフスペースを計算
end
CALC_CONTROL.IACT = 1;        % to keep okada output
a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
c = horzcat(a,b);             % aとbを水平に連結
format long;
% save Displacement.cou a -ascii
if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
    cd output_files; % output_filesに移動
else
    cd (SYSTEM_VARS.PREF_DIR);
end
header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
header2 = 'x y z UX UY UZ';
header3 = '(km) (km) (km) (m) (m) (m)';
dlmwrite('Displacement.cou',header1,'delimiter',''); 
dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
disp(['Displacement.cou is saved in ' pwd]);
cd (SYSTEM_VARS.HOME_DIR);
displ_open2(2);
fault_overlay;             % フォルトオーバーレイ
flag = check_lonlat_info2; % 経度と緯度の情報をチェック
if flag == 1               % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
end
% ----- overlay drawing オーバーレイの描画 --------------------------------
if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
    isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1  % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
    figure(H_MAIN); hold on; % H_MAINの図を保持
    overlay_drawing;         % オーバーレイの描画
end

%-------------------------------------------------------------------------
%                       3D IMAGE (sub-submenu) 3Dイメージサブサブメニュー
%-------------------------------------------------------------------------
function menu_3d_Callback(hObject, eventdata, handles)
global H_VIEWPOINT
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global SYSTEM_VARS

subfig_clear;
CALC_CONTROL.FUNC_SWITCH = 5;
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
    waitfor(h);
end
% Okadaハーフスペースの再計算を回避するため
if CALC_CONTROL.IACT ~= 1        
Okada_halfspace;
end
CALC_CONTROL.IACT = 1;
a = OKADA_OUTPUT.DC3D(:,1:2);
b = OKADA_OUTPUT.DC3D(:,5:8);
c = horzcat(a,b);
format long;
if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
    cd output_files;
else
    cd (SYSTEM_VARS.PREF_DIR);
end
header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
header2 = 'x y z UX UY UZ';
header3 = '(km) (km) (km) (m) (m) (m)';
dlmwrite('Displacement.cou',header1,'delimiter',''); 
dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
disp(['Displacement.cou is saved in ' pwd]);
cd (SYSTEM_VARS.HOME_DIR);
grid_drawing_3d2;
hold on;
displ_open2(2);
h = findobj('Tag','xlines'); delete(h);
h = findobj('Tag','ylines'); delete(h);

% --------------------------------------------------------------------
function menu_3d_wire_Callback(hObject, eventdata, handles)
% 3Dワイヤをクリックしたときのコールバック関数
global H_VIEWPOINT
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global SYSTEM_VARS

subfig_clear;
CALC_CONTROL.FUNC_SWITCH = 5.5; % 関数スイッチを5.5に設定
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
    h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
    waitfor(h);
end
% Okadaハーフスペースの再計算を回避するため
if CALC_CONTROL.IACT ~= 1        
    Okada_halfspace; % Okadaハーフスペースを計算
end
CALC_CONTROL.IACT = 1;        % to keep okada output
a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
c = horzcat(a,b);             % aとbを水平に連結
format long;
if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが1または空の場合
    cd output_files; % output_filesに移動
else
    cd (SYSTEM_VARS.PREF_DIR);
end
header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
header2 = 'x y z UX UY UZ';
header3 = '(km) (km) (km) (m) (m) (m)';
dlmwrite('Displacement.cou',header1,'delimiter','');
dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
disp(['Displacement.cou is saved in ' pwd]);
cd (SYSTEM_VARS.HOME_DIR);

grid_drawing_3d2;
hold on;                                % 3Dグリッドの描画
displ_open2(2);                         % 2を開く
h = findobj('Tag','xlines'); delete(h); % xlinesを削除
h = findobj('Tag','ylines'); delete(h); % ylinesを削除

% --------------------------------------------------------------------
function menu_3d_vectors_Callback(hObject, eventdata, handles)
% 3Dベクトルをクリックしたときのコールバック関数
global H_VIEWPOINT
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global SYSTEM_VARS

subfig_clear; % サブフィギュアをクリア
CALC_CONTROL.FUNC_SWITCH = 5.7; % 関数スイッチを5.7に設定
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
    h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
    waitfor(h); % モーダルダイアログボックスの終了を待つ
end
if CALC_CONTROL.IACT ~= 1        
    Okada_halfspace;
end
CALC_CONTROL.IACT = 1;
a = OKADA_OUTPUT.DC3D(:,1:2);
b = OKADA_OUTPUT.DC3D(:,5:8);
c = horzcat(a,b);
format long;
if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
    cd output_files;
else
    cd (SYSTEM_VARS.PREF_DIR);
end
header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
header2 = 'x y z UX UY UZ';
header3 = '(km) (km) (km) (m) (m) (m)';
dlmwrite('Displacement.cou',header1,'delimiter',''); 
dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
disp(['Displacement.cou is saved in ' pwd]);
cd (SYSTEM_VARS.HOME_DIR);
grid_drawing_3d2;
hold on;
displ_open2(2);
h = findobj('Tag','xlines'); delete(h);
h = findobj('Tag','ylines'); delete(h);

%-------------------------------------------------------------------------
%           STRAIN (submenu) ひずみサブメニュー 
%-------------------------------------------------------------------------
function menu_strain_Callback(hObject, eventdata, handles)
global H_STRAIN H_MAIN
global CALC_CONTROL
global OVERLAY_VARS

subfig_clear;
CALC_CONTROL.IACT = 0;
CALC_CONTROL.FUNC_SWITCH = 6;
CALC_CONTROL.SHADE_TYPE = 1;    % default
CALC_CONTROL.STRAIN_SWITCH = 1; % default sig XX
H_STRAIN = strain_window;       % strain_windowを開く
flag = check_lonlat_info2;      % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;      % すべてのオーバーレイを有効にする
end
% ----- overlay drawing --------------------------------
if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |...
    isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1
    figure(H_MAIN);
    hold on;
    overlay_drawing;
end

%-------------------------------------------------------------------------
%           STRESS (submenu)        with sub-submenu 応力サブメニュー
%-------------------------------------------------------------------------
function menu_stress_Callback(hObject, eventdata, handles)
% 応力サブメニューをクリックしたときのコールバック関数

% --------------------------------------------------------------------
function menu_shear_stress_change_Callback(hObject, eventdata, handles)
global H_COULOMB
global CALC_CONTROL
subfig_clear;
CALC_CONTROL.IACT = 0;
CALC_CONTROL.FUNC_SWITCH = 7;
CALC_CONTROL.STRESS_TYPE = 5;
H_COULOMB = coulomb_window;
set(findobj('Tag','text_fric'),'Visible','off');      % text_fricを非表示
set(findobj('Tag','edit_coul_fric'),'Visible','off'); % edit_coul_fricを非表示
flag = check_lonlat_info2;
if flag == 1
    all_overlay_enable_on;
end

% --------------------------------------------------------------------
function menu_normal_stress_change_Callback(hObject, eventdata, handles)
global H_COULOMB
global CALC_CONTROL
subfig_clear;
CALC_CONTROL.IACT = 0;
CALC_CONTROL.FUNC_SWITCH = 8;
CALC_CONTROL.STRESS_TYPE = 5;
H_COULOMB = coulomb_window; % coulomb_windowを開く
set(findobj('Tag','text_fric'),'Visible','off');
set(findobj('Tag','edit_coul_fric'),'Visible','off');
flag = check_lonlat_info2; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;
end

% --------------------------------------------------------------------
function menu_coulomb_stress_change_Callback(hObject, eventdata, handles)
global H_COULOMB
global CALC_CONTROL
subfig_clear;
CALC_CONTROL.IACT = 0;
CALC_CONTROL.FUNC_SWITCH = 9;
CALC_CONTROL.STRESS_TYPE = 5;
H_COULOMB = coulomb_window; % coulomb_windowを開く
set(findobj('Tag','crosssection_toggle'),'Enable','off');
flag = check_lonlat_info2; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;
end

% --------------------------------------------------------------------
function menu_stress_on_faults_Callback(hObject, eventdata, handles)
global H_EC_CONTROL
global COORD_VARS
global CALC_CONTROL
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
    h = warndlg('Sorry this is not available for lat/lon coordinates. Change to Cartesian coordinates.','!! Warning !!');
    waitfor(h);
    return
end
subfig_clear;
CALC_CONTROL.FUNC_SWITCH = 10;
H_EC_CONTROL = ec_control_window2; % ec_control_windowを開く

% --------------------------------------------------------------------
function menu_stress_on_a_fault_Callback(hObject, eventdata, handles)
global H_VIEWPOINT
global CALC_CONTROL
CALC_CONTROL.IACT = 0;
if CALC_CONTROL.FUNC_SWITCH ~= 7 && CALC_CONTROL.FUNC_SWITCH ~= 8 && CALC_CONTROL.FUNC_SWITCH ~= 9
    subfig_clear;
    CALC_CONTROL.FUNC_SWITCH = 1;
    grid_drawing2;
    fault_overlay;
end
H_POINT = point_calc_window; % point_calc_windowを開く
flag = check_lonlat_info2;   % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;
end

% --------------------------------------------------------------------
function menu_focal_mech_Callback(hObject, eventdata, handles)
global NODAL_ACT NODAL_STRESS
global CALC_CONTROL
global SYSTEM_VARS
CALC_CONTROL.FUNC_SWITCH = 11; % 関数スイッチを11に設定
NODAL_ACT = 0;                 % NODAL_ACTを0に設定
NODAL_STRESS = [];             % NODAL_STRESSを空にする
cd (SYSTEM_VARS.HOME_DIR);     % HOME_DIRに移動
focal_mech_calc;               % フォーカルメカニズム計算

%-------------------------------------------------------------------------
%           CHANGE PARAMETERS (submenu) with sub-submenu パラメータ変更サブメニュー
%-------------------------------------------------------------------------
function menu_change_parameters_Callback(hObject, eventdata, handles)
% パラメータ変更サブメニューをクリックしたときのコールバック関数

% --------------------------------------------------------------------
function menu_all_parameters_Callback(hObject, eventdata, handles)
% すべてのパラメータをクリックしたときのコールバック関数
global H_INPUT
global CALC_CONTROL
H_INPUT = input_window;
waitfor(H_INPUT);
CALC_CONTROL.IACT = 0;
menu_grid_mapview_Callback;

% --------------------------------------------------------------------
function menu_grid_size_Callback(hObject, eventdata, handles)
global LON_PER_X LAT_PER_Y
global INPUT_VARS
global COORD_VARS
global CALC_CONTROL

temp1 = INPUT_VARS.GRID(5,1); temp2 = INPUT_VARS.GRID(6,1);
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    prompt = {'Enter new lon. increment(deg):','Enter new lat. increment(deg):'}; % 新しい経度の増分(度)を入力してください
    defc1 = num2str(INPUT_VARS.GRID(5,1)*LON_PER_X,'%9.3f'); % defc1を設定
    defc2 = num2str(INPUT_VARS.GRID(6,1)*LAT_PER_Y,'%9.3f'); % defc2を設定
else
    prompt = {'Enter new x increment(km):','Enter new y increment(km):'}; % 新しいxの増分(km)を入力してください
    defc1 = num2str(INPUT_VARS.GRID(5,1),'%9.3f'); % defc1を設定
    defc2 = num2str(INPUT_VARS.GRID(6,1),'%9.3f'); % defc2を設定
end
name = 'Grid Size';             % グリッドサイズ
numlines = 1;                   % numlinesを1に設定
options.Resize = 'on';          % オプションのリサイズをオンに設定
options.WindowStyle = 'normal'; % オプションのウィンドウスタイルを通常に設定
answer = inputdlg(prompt,name,numlines,{defc1,defc2},options); % ダイアログボックスに入力する
answer = answer;
n = 5;
xlim = (INPUT_VARS.GRID(3)-INPUT_VARS.GRID(1))/n; % xlimを(INPUT_VARS.GRID(3)-INPUT_VARS.GRID(1))/nに設定
ylim = (INPUT_VARS.GRID(4)-INPUT_VARS.GRID(2))/n; % ylimを(INPUT_VARS.GRID(4)-INPUT_VARS.GRID(2))/nに設定
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    INPUT_VARS.GRID(5,1) = str2double(answer(1))/LON_PER_X;
    INPUT_VARS.GRID(6,1) = str2double(answer(2))/LAT_PER_Y;
    xlim = xlim/LON_PER_X;
    ylim = ylim/LAT_PER_Y;
else
    INPUT_VARS.GRID(5,1) = str2double(answer(1));
    INPUT_VARS.GRID(6,1) = str2double(answer(2));
end
if str2double(answer(1)) > xlim
    warndlg('The x increment might be large relative to the study area. Not acceptable.'); % xの増分が研究領域に対して大きい可能性があります。受け入れられません。
    return
end
if str2double(answer(2)) > xlim
    warndlg('The y increment might be large relative to the study area. Not acceptable.'); % yの増分が研究領域に対して大きい可能性があります。受け入れられません。
    return
end
if isnan(INPUT_VARS.GRID(5,1)) == 1 | isempty(INPUT_VARS.GRID(5,1)) == 1
    INPUT_VARS.GRID(5,1) = temp1;
end
if isnan(INPUT_VARS.GRID(6,1)) == 1 | isempty(INPUT_VARS.GRID(6,1)) == 1
    INPUT_VARS.GRID(6,1) = temp2;
end
calc_element;               % 要素を計算
CALC_CONTROL.IACT = 0;      % CALC_CONTROL.IACTを0に設定
menu_grid_mapview_Callback; % 更新されたグリッドを再描画

% --------------------------------------------------------------------
function menu_calc_depth_Callback(hObject, eventdata, handles)
% 計算深度をクリックしたときのコールバック関数
global H_DISPL
global INPUT_VARS
global CALC_CONTROL

temp = INPUT_VARS.CALC_DEPTH;                       % tempをCALC_DEPTHに設定
prompt = 'Enter new calculation depth (positive):'; % 新しい計算深度(正)を入力してください
name = 'Calc. Depth';                               % Calc. Depth
numlines = 1;                                       % numlinesを1に設定
options.Resize = 'on';                              % オプションのリサイズをオンに設定
options.WindowStyle = 'normal';                     % オプションのウィンドウスタイルを通常に設定
defc = num2str(CALC_DEPTH,'%6.2f');                 % defcをCALC_DEPTHに設定
answer = inputdlg(prompt,name,numlines,{defc},options); % ダイアログボックスに入力する
if str2double(answer) < 0.0
    warndlg('Put positive number. Not acceptable'); % 正の数を入力してください。受け入れられません。
	return
end
INPUT_VARS.CALC_DEPTH = str2double(answer);
if isnan(INPUT_VARS.CALC_DEPTH) == 1 | isempty(INPUT_VARS.CALC_DEPTH) == 1
    INPUT_VARS.CALC_DEPTH = temp;
end
h = findobj('Tag','displ_h_window');
if (isempty(h)~=1 && isempty(H_DISPL)~=1)
    set(findobj('Tag','edit_displdepth'),'String',num2str(INPUT_VARS.CALC_DEPTH,'%5.2f')); % edit_displdepthにCALC_DEPTHを設定
end
CALC_CONTROL.IACT = 0;
menu_grid_mapview_Callback;

% --------------------------------------------------------------------
function menu_coeff_friction_Callback(hObject, eventdata, handles)
% 摩擦係数をクリックしたときのコールバック関数
global INPUT_VARS
temp = INPUT_VARS.FRIC;
prompt = 'Enter new friction (positive):'; % 新しい摩擦(正)を入力してください
name = 'Coeff. Friction';                  % Coeff. Friction
numlines = 1;
options.Resize = 'on';
options.WindowStyle = 'normal';
defc = num2str(FRIC,'%4.3f');
answer = inputdlg(prompt,name,numlines,{defc},options);
if str2double(answer) < 0.0
    warndlg('Put positive number. Not acceptable'); % 正の数を入力してください。受け入れられません。
	return
end
INPUT_VARS.FRIC = str2double(answer); % FRICをanswerに設定
if isnan(INPUT_VARS.FRIC) == 1 | isempty(INPUT_VARS.FRIC) == 1
    INPUT_VARS.FRIC = temp;
end

% --------------------------------------------------------------------
function menu_exaggeration_Callback(hObject, eventdata, handles)
% 誇張をクリックしたときのコールバック関数
global INPUT_VARS
temp = INPUT_VARS.SIZE(3);
prompt = 'Enter new displ. exaggeration:'; % 新しいdispl. exaggerationを入力してください
name = 'Displ. exaggeration';
numlines = 1;
options.Resize = 'on';
options.WindowStyle = 'normal';
defc = num2str(INPUT_VARS.SIZE(3));                     % defcをSIZE(3)に設定
answer = inputdlg(prompt,name,numlines,{defc},options); % ダイアログボックスに入力する
INPUT_VARS.SIZE(3) = str2double(answer);                % SIZE(3)をanswerに設定
if isnan(INPUT_VARS.SIZE(3)) == 1 | isempty(INPUT_VARS.SIZE(3)) == 1
    INPUT_VARS.SIZE(3) = temp;
end

%-------------------------------------------------------------------------
%           TAPER & SPLIT (submenu) テーパーとスプリットサブメニュー
%-------------------------------------------------------------------------
function menu_taper_split_Callback(hObject, eventdata, handles)
% テーパーとスプリットサブメニューをクリックしたときのコールバック関数
global H_ELEMENT TAPER_CALLED
H_ELEMENT = element_input_window;
TAPER_CALLED = 1;

%-------------------------------------------------------------------------
%           CALC. CARTESIAN GRID (submenu) カルテシアングリッドを計算するサブメニュー
%-------------------------------------------------------------------------
function menu_cartesian_Callback(hObject, eventdata, handles)
global H_UTM
global UTM_FLAG  % UTM_FLAG is used to identify if this is just a tool to know the coordinate (0) to make an input file from this (1) 
                 % UTM_FLAGは、座標を知るためのツールであるかどうかを識別するために使用されます(0)、このツールから入力ファイルを作成します(1)
%===== ユーザーがマッピングツールボックスを持っているかどうかを確認する =====
if exist([matlabroot '/toolbox/map'],'dir')==0
    warndlg('Since you do not have mapping toolbox, this menu is unavailable. Sorry.','!!Warning!!');
    return;
end
H_UTM = utm_window;
UTM_FLAG = 0;
set(findobj('Tag','pushbutton_add'),'Visible','off');
set(findobj('Tag','pushbutton_f_add'),'Visible','off');
set(findobj('Tag','edit_all_input_params'),'Visible','off');

%-------------------------------------------------------------------------
%           CALC. PROPER PRINCIPAL AXES (submenu) 適切な主軸を計算するサブメニュー
%-------------------------------------------------------------------------
function menu_calc_principal_Callback(hObject, eventdata, handles)
% 主軸を計算するサブメニューをクリックしたときのコールバック関数
global H_CALC_PRINCIPAL
H_CALC_PRINCIPAL = calc_principals_window; % calc_principals_windowを開く

%=========================================================================
%    OVERLAY (menu) オーバーレイメニュー
%=========================================================================
function overlay_menu_Callback(hObject, eventdata, handles)

%-------------------------------------------------------------------------
%           COASTLINES (submenu) 海岸線サブメニュー
%-------------------------------------------------------------------------
function menu_coastlines_Callback(hObject, eventdata, handles)
% 海岸線サブメニューをクリックしたときのコールバック関数
global H_MAIN
if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
    set(gcbo, 'Checked', 'off');     % gcboをoffに設定
    figure(H_MAIN);                  % H_MAINの図
    try
        h = findobj('Tag','CoastlineObj'); % 'Tag'が'CoastlineObj'のオブジェクトを検索
        delete(h);
    catch
        return
    end
else 
    set(gcbo, 'Checked', 'on'); % gcboをonに設定
    hold off;
    coastline_drawing;          % 海岸線の描画
    hold on;
end

%-------------------------------------------------------------------------
%           ACTIVE FAULTS (submenu) アクティブフォールトサブメニュー
%-------------------------------------------------------------------------
function menu_activefaults_Callback(hObject, eventdata, handles) % アクティブフォールトサブメニューをクリックしたときのコールバック関数
global H_MAIN
global OVERLAY_VARS
if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
    set(gcbo, 'Checked', 'off');     % gcboをoffに設定
    figure(H_MAIN);                  % H_MAINの図
    try
        h = findobj('Tag','AfaultObj'); % 'Tag'が'AfaultObj'のオブジェクトを検索
        delete(h);
    catch
        return
    end
else 
    set(gcbo, 'Checked', 'on'); % gcboをonに設定
    hold off;
    if isempty(OVERLAY_VARS.AFAULT_DATA) == 1 % AFAULT_DATAが空の場合
        afault_format_window;                 % afault_format_windowを開く
    else
        afault_drawing;                       % afault_drawingを実行
    end
    hold on;
end
    
%-------------------------------------------------------------------------
%           EARTHQUAKES (submenu) 地震サブメニュー
%-------------------------------------------------------------------------
function menu_earthquakes_Callback(hObject, eventdata, handles)
global H_MAIN H_F3D_VIEW H_EC_CONTROL
if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
    set(gcbo, 'Checked', 'off');     % gcboをoffに設定
    figure(H_MAIN);                  % H_MAINの図
    try
        h = findobj('Tag','EqObj');  % 'Tag'が'EqObj'のオブジェクトを検索
        delete(h);                   % hを削除
    catch
        return
    end
    try
        h = findobj('Tag','EqObj2'); % 'Tag'が'EqObj2'のオブジェクトを検索
        delete(h);
    catch
        return
    end
else 
    set(gcbo, 'Checked', 'on'); % gcboをonに設定
    hold off;
    earthquake_plot;            % 地震プロット
    fault_overlay;              % フォルトを再度プロット
    hold on;
end

%-------------------------------------------------------------------------
%           Trace faults and put them into input file (submenu) 断層をトレースして入力ファイルに入れるサブメニュー
%-------------------------------------------------------------------------
function menu_trace_put_faults_Callback(hObject, eventdata, handles)
% 断層をトレースして入力ファイルに入れるサブメニューをクリックしたときのコールバック関数
new_fault_mouse_clicks; % 新しい断層をマウスクリック

%----------------------------------------------------------
function all_functions_enable_on
set(findobj('Tag','menu_grid'),'Enable','On');
set(findobj('Tag','menu_displacement'),'Enable','On');
set(findobj('Tag','menu_strain'),'Enable','On');
set(findobj('Tag','menu_stress'),'Enable','On');
set(findobj('Tag','menu_change_parameters'),'Enable','On');
set(findobj('Tag','menu_taper_split'),'Enable','On');

%----------------------------------------------------------
function all_functions_enable_off
set(findobj('Tag','menu_grid'),'Enable','Off');
set(findobj('Tag','menu_displacement'),'Enable','Off');
set(findobj('Tag','menu_strain'),'Enable','Off');
set(findobj('Tag','menu_stress'),'Enable','Off');
set(findobj('Tag','menu_taper_split'),'Enable','Off');

%----------------------------------------------------------
function all_overlay_enable_on
set(findobj('Tag','menu_coastlines'),'Enable','On');
set(findobj('Tag','menu_activefaults'),'Enable','On');
set(findobj('Tag','menu_earthquakes'),'Enable','On');
set(findobj('Tag','menu_clear_overlay'),'Enable','On');
set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 

%----------------------------------------------------------
function all_overlay_enable_off
set(findobj('Tag','menu_coastlines'),'Enable','Off');
set(findobj('Tag','menu_activefaults'),'Enable','Off');
set(findobj('Tag','menu_earthquakes'),'Enable','Off');
set(findobj('Tag','menu_clear_overlay'),'Enable','Off'); 
set(findobj('Tag','menu_trace_put_faults'),'Enable','Off'); 

% % --------------------------------------------------------------------
function menu_tools_Callback(hObject, eventdata, handles)

%-------------------------------------------------------------------------
%	Clear overlay data (submenu) オーバーレイデータをクリアするサブメニュー
%-------------------------------------------------------------------------
function menu_clear_overlay_Callback(hObject, eventdata, handles)
% オーバーレイデータをクリアするサブメニューをクリックしたときのコールバック関数
global OVERLAY_VARS
if isempty(OVERLAY_VARS.COAST_DATA)==1
    set(findobj('Tag','submenu_clear_coastlines'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_coastlines'),'Enable','On');
end
if isempty(OVERLAY_VARS.AFAULT_DATA)==1
    set(findobj('Tag','submenu_clear_afaults'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_afaults'),'Enable','On');
end
if isempty(OVERLAY_VARS.EQ_DATA)==1
    set(findobj('Tag','submenu_clear_earthquakes'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_earthquakes'),'Enable','On');
end

%-------------------------------------------------------------------------
%       Submenu clear coastline data (submenu) 海岸線データをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_coastlines_Callback(hObject, eventdata, handles)
global H_MAIN
global OVERLAY_VARS
OVERLAY_VARS.COAST_DATA = [];
set(findobj('Tag','menu_coastlines'),'Checked','Off'); % 'Tag'が'menu_coastlines'のオブジェクトを取得
figure(H_MAIN);
try
    h = findobj('Tag','CoastlineObj');
    delete(h);
catch
    return
end

%-------------------------------------------------------------------------
%       Submenu clear active fault data (submenu) アクティブフォールトデータをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_afaults_Callback(hObject, eventdata, handles)
global H_MAIN
global OVERLAY_VARS
OVERLAY_VARS.AFAULT_DATA = [];
set(findobj('Tag','menu_activefaults'),'Checked','Off');
figure(H_MAIN);        
try
    h = findobj('Tag','AfaultObj');
    delete(h);
catch
    return
end

%-------------------------------------------------------------------------
%       Submenu clear earthquake data (submenu) 地震データをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_earthquakes_Callback(hObject, eventdata, handles)
global H_MAIN
global OVERLAY_VARS
OVERLAY_VARS.EQ_DATA = [];
set(findobj('Tag','menu_earthquakes'),'Checked','Off');
set(findobj('Tag','menu_focal_mech'),'Enable','Off');
figure(H_MAIN);        
try
    h = findobj('Tag','EqObj');
    delete(h);
catch
    return
end
try
    h = findobj('Tag','EqObj2');
    delete(h);
catch
    return
end

% --------------------------------------------------------------------
function uimenu_fault_modifications_Callback(hObject, eventdata, handles)
% uimenu_fault_modificationsをクリックしたときのコールバック関数
disp('under construction')

% --------------------------------------------------------------------
function check_overlay_items % オーバーレイアイテムをチェックする
global OVERLAY_VARS
if ~isempty(OVERLAY_VARS.COAST_DATA)
    set(findobj('Tag','menu_coastlines'),'Checked','On');
else
    set(findobj('Tag','menu_coastlines'),'Checked','Off');
end
if ~isempty(OVERLAY_VARS.AFAULT_DATA)
    set(findobj('Tag','menu_activefaults'),'Checked','On');
else
    set(findobj('Tag','menu_activefaults'),'Checked','Off');
end
if ~isempty(OVERLAY_VARS.EQ_DATA)
    set(findobj('Tag','menu_earthquakes'),'Checked','On');
else
    set(findobj('Tag','menu_earthquakes'),'Checked','Off');
end
    