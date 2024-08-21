% 関数の役割: メインメニューウィンドウのエントリポイント。GUIの初期化を行う。
% varargout: 可変長出力引数
% varargin: 可変長入力引数
function varargout = main_menu_window(varargin)

% GUIの状態を設定

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0; % gui_Singleton: GUIのインスタンスが1つだけかどうかを指定。0は複数のインスタンスを許可。
% gui_State: GUIの状態を管理する構造体
gui_State = struct('gui_Name',       mfilename, ... % gui_Name: GUIの名前。mファイル名と同じ。
                   'gui_Singleton',  gui_Singleton, ... % gui_Singleton: GUIのインスタンスが1つだけかどうかを指定。
                   'gui_OpeningFcn', @main_menu_window_OpeningFcn, ... % gui_OpeningFcn: GUIが開かれるときに呼び出される関数。
                   'gui_OutputFcn',  @main_menu_window_OutputFcn, ... % gui_OutputFcn: GUIが閉じられるときに呼び出される関数。
                   'gui_LayoutFcn',  [] , ... % gui_LayoutFcn: GUIのレイアウト関数。
                   'gui_Callback',   []); % gui_Callback: GUIのコールバック関数。
if nargin && ischar(varargin{1}) % nargin: 関数に渡された引数の数。ischar: 文字列かどうかを判定。
    gui_State.gui_Callback = str2func(varargin{1}); % str2func: 文字列を関数ハンドルに変換。
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

% Choose default command line output for main_menu_window
global SCRS SCRW_X SCRW_Y
% global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width スクリーンサイズとウィンドウ位置を設定。

handles.output = hObject; % handles.output: GUIの出力を設定。

guidata(hObject, handles); % guidata: handles構造体を更新。

    h = findobj('Tag','main_menu_window'); % findobj: オブジェクトを検索。
    j = get(h,'Position'); % get: プロパティの値を取得。
    wind_width = j(1,3); % ウィンドウの幅
    wind_height = j(1,4); % ウィンドウの高さ
    xpos = SCRW_X; % ウィンドウのx座標
    ypos = (SCRS(1,4) - SCRW_Y) - wind_height; % ウィンドウのy座標
    set(hObject,'Position',[xpos ypos wind_width wind_height]); % set: プロパティの値を設定。



%-------------------------------------------------------------------------
%   Main menu closing function　メインメニューを閉じる関数
%-------------------------------------------------------------------------
function varargout = main_menu_window_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output; % handles.output: GUIの出力を取得。



%=========================================================================
%    DATA (menu) データメニュー
%=========================================================================
function data_menu_Callback(hObject, eventdata, handles) % データメニューをクリックしたときのコールバック関数



%-------------------------------------------------------------------------
%           ABOUT (submenu) アバウトサブメニュー
%-------------------------------------------------------------------------
function menu_about_Callback(hObject, eventdata, handles) % アバウトサブメニューをクリックしたときのコールバック関数
global CURRENT_VERSION % グローバル変数の定義
cd slides % slidesディレクトリに移動
str = ['About_image.jpg']; % 画像ファイル名
[x,imap] = imread(str); % imread: 画像ファイルを読み込む。
if exist('x')==1 % if the image file exists
    h = figure('Menubar','none','NumberTitle','off'); % figure: 新しい図を作成。
    axes('position',[0 0 1 1]); % axes: 軸を作成。
    axis image; % axis: 軸の設定。
    image(x) % image: 画像を表示。
    drawnow % drawnow: グラフィックスの更新。

    %===== version check バージョンチェック ===========================

    try
%         temp  = urlread('http://www.coulombstress.org/version/version.txt');
        temp  = '3.2.01'; % temporal for Sep. 12 2010 SCEC class % urlreadが使えないため、一時的にバージョンを設定
        idx   = strfind(temp,'.'); % strfind: 文字列内の特定の文字列の位置を検索。
        newvs = str2num([temp(1:idx(1)-1) temp(idx(1)+1:idx(2)-1) temp(idx(2)+1:end)]);
        idx   = strfind(CURRENT_VERSION,'.'); % strfind: 文字列内の特定の文字列の位置を検索。
        curvs = str2num([CURRENT_VERSION(1:idx(1)-1) CURRENT_VERSION(idx(1)+1:idx(2)-1) CURRENT_VERSION(idx(2)+1:end)]);

        if newvs > curvs % 新しいのがあれば更新表示
            versionmsg = [' New version ' temp ' is found. Visit the following website.'];
        else
            versionmsg = '';
        end
    catch
        % インターネットとつながっていなかった場合、あとでバージョンをチェックするようにメッセージを表示
            versionmsg = 'No internet connection. Check the version later.'; 
    end
    
    th = text(460.0,385.0,['  version ' CURRENT_VERSION '  ']); % 現在のバージョンを表示
    set(th,'fontsize',16,'fontweight','b','Color','w',... % set: プロパティの値を設定。
        'horizontalalignment','center','verticalalignment','middle',...
        'backgroundcolor','none','edgecolor','none')
    th1 = text(305.0,420.0,versionmsg); % 新しいバージョンがある場合、メッセージを表示
    set(th1,'fontsize',14,'fontweight','b','Color','w',... % set: プロパティの値を設定。
        'horizontalalignment','center','verticalalignment','middle',...
        'backgroundcolor','k','edgecolor','none')
    th2 = text(320.0,420.0,' http://earthquake.usgs.gov/research/modeling/coulomb/ '); % USGSのサイトへのリンク
    set(th2,'fontsize',12,'fontweight','b','Color','w',... % set: プロパティの値を設定。
        'horizontalalignment','center','verticalalignment','middle',...
        'backgroundcolor','none','edgecolor','none')

% http://earthquake.usgs.gov/research/modeling/coulomb/
%     new_version =
%     urlread('http://www.coulombstress.org/version/version.txt');
    
end
cd .. % 一つ上のディレクトリに移動



%-------------------------------------------------------------------------
%           NEW (submenu)  新規作成サブメニュー
%-------------------------------------------------------------------------
function menu_new_Callback(hObject, eventdata, handles) % 新規作成サブメニューをクリックしたときのコールバック関数
global GRID FUNC_SWITCH ICOORD % 直交座標か緯度経度のスイッチの定義
global H_GRID_INPUT COAST_DATA AFAULT_DATA % グリッド入力ウィンドウのハンドル
global ELEMENT IACT S_ELEMENT INPUT_FILE INUM % 要素、IACT、S_ELEMENT、入力ファイル、INUM
coulomb_init; % coulomb_init: グローバル変数の初期化
clear_obj_and_subfig; % clear_obj_and_subfig: オブジェクトとサブフィギュアをクリア
IACT = 0; % IACT: アクティブな要素のインデックス
INUM = 0; % INUM: 要素の数
ELEMENT = []; S_ELEMENT = []; % 要素の初期化
GRID = []; % グリッドの初期化
COAST_DATA = []; AFAULT_DATA = []; % 海岸データ、断層データの初期化
INPUT_FILE = 'untitled'; % 入力ファイル名
if ICOORD == 2          % in case the current coordinates mode is 'Lon & lat' (ICOORD=2) % 現在の座標モードが「経度と緯度」の場合
    h = warndlg('Coordinates mode automatically changes to ''Cartesian'' now','!! Warning !!'); % warndlg: 警告ダイアログを表示
    waitfor(h); % waitfor: モーダルダイアログボックスの終了を待つ
    ICOORD = 1;         % change to x & y cartesian coordinates % xとyの直交座標に変更
end
if isempty(GRID) % グリッドが空の場合
    % default values
    GRID(1,1) = -50.01; % x start
    GRID(2,1) = -50.01; % y start
    GRID(3,1) =  50.00; % x finish
    GRID(4,1) =  50.00; % y finish
    GRID(5,1) =   5.00; % x increment % xの増分
    GRID(6,1) =   5.00; % y increment % yの増分
end
H_GRID_INPUT = grid_input_window; % grid_input_window: グリッド入力ウィンドウ
FUNC_SWITCH = 0; % 関数スイッチを0に設定
if ~isempty(GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on; % すべての関数を有効にする
    set(findobj('Tag','menu_file_save'),'Enable','On'); % ファイル保存メニュー
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On'); % ファイル保存メニュー
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On'); % ファイル保存メニュー
    set(findobj('Tag','menu_map_info'),'Enable','On'); % マップ情報メニュー
    all_overlay_enable_off; % すべてのオーバーレイを無効にする
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On');  % トレースプットフォルトメニュー
end

%-------------------------------------------------------------------------
%           NEW from Map (submenu)  地図から新規作成サブメニュー
%-------------------------------------------------------------------------
function menu_new_map_Callback(hObject, eventdata, handles) % 地図から新規作成サブメニューをクリックしたときのコールバック関数
global H_UTM GRID COAST_DATA AFAULT_DATA % UTMウィンドウ、グリッド、海岸データ、断層データ
global IACT INPUT_FILE INUM % IACT、入力ファイル、INUM
coulomb_init; % グローバル変数の初期化
clear_obj_and_subfig; % オブジェクトとサブフィギュアをクリア
IACT = 0;
INUM = 0;
COAST_DATA = []; AFAULT_DATA = []; % 海岸データ、断層データの初期化
INPUT_FILE = 'untitled'; % 入力ファイル名
% all off
set(findobj('Tag','menu_file_save'),'Enable','Off'); % ファイル保存メニュー
set(findobj('Tag','menu_file_save_ascii'),'Enable','Off'); % ファイル保存メニュー
set(findobj('Tag','menu_file_save_ascii2'),'Enable','Off'); % ファイル保存メニュー
all_functions_enable_off; % すべての関数を無効にする
all_overlay_enable_off; % すべてのオーバーレイを無効にする
%
H_UTM = utm_window; % utm_window: UTMウィンドウ
waitfor(H_UTM); % waitfor: モーダルダイアログボックスの終了を待つ
if ~isempty(GRID) % グリッドが空でない場合、下のメニューを使えるようにする
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
function menu_most_recent_file_Callback(hObject, eventdata, handles) % 最近使用したファイルを開くサブメニューをクリックしたときのコールバック関数
global GRID % グリッド
global FUNC_SWITCH DIALOG_SKIP % 関数スイッチ、ダイアログスキップ
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA % 海岸データ、断層データ、地震データ、GPSデータ
global VOLCANO % 火山データ
coulomb_init;
clear_obj_and_subfig;
DIALOG_SKIP = 0;
last_input;
FUNC_SWITCH = 0;
if ~isempty(GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on;
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_off;
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end
if isempty(EQ_DATA) % 地震データが空の場合
    set(findobj('Tag','menu_focal_mech'),'Enable','Off'); % フォーカルメカニズムメニューを無効にする
else
    set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
end
% ---- making grid map view グリッドマップビューを作成する -----------------
% put try-catch-end in case user push "cancel button" キャンセルボタンを押した場合のtry-catch-endを入れる
% try % 例外処理
%     check_overlay_items; % オーバーレイアイテムをチェック
%     menu_grid_mapview_Callback; % グリッドマップビューをクリックしたときのコールバック関数
% catch % 例外処理
%     return
% end

%-------------------------------------------------------------------------
%           OPEN (submenu) サブメニューを開く
%-------------------------------------------------------------------------
function menu_file_open_Callback(hObject, eventdata, handles) % サブメニューを開く
global GRID % グリッド
global H_MAIN FUNC_SWITCH EQ_DATA DIALOG_SKIP % メインウィンドウ、関数スイッチ、地震データ、ダイアログスキップ
% coulomb_init;
% clear_obj_and_subfig;
DIALOG_SKIP = 0; % ダイアログスキップを0に設定
input_open(1); % input_open: 入力を開く

% FUNC_SWITCH = 0; % 関数スイッチを0に設定
if ~isempty(GRID) % グリッドが空でない場合、下のメニューを使えるようにする
    all_functions_enable_on;
    set(findobj('Tag','menu_file_save'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
    set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
    set(findobj('Tag','menu_map_info'),'Enable','On');
    all_overlay_enable_off;
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end
% menu_clear_overlay_Callback;
check_overlay_items; % オーバーレイアイテムをチェック

%-------------------------------------------------------------------------
%           OPEN/SKIPPING DIALOG (submenu) ダイアログをスキップして開くサブメニュー
%-------------------------------------------------------------------------
function menu_open_skipping_Callback(hObject, eventdata, handles) % ダイアログをスキップして開くサブメニューをクリックしたときのコールバック関数
global GRID FUNC_SWITCH % グリッド、関数スイッチ
global DIALOG_SKIP IACT % ダイアログスキップ、IACT
% coulomb_init;
% clear_obj_and_subfig;
DIALOG_SKIP = 0;
input_open(3); % 3はオープンウィンドウをスキップすることを意味する

% FUNC_SWITCH = 0;
if ~isempty(GRID) % グリッドが空でない場合、下のメニューを使えるようにする
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
    if IACT == 0 % ユーザーがキャンセルを選択した場合、IACTは1から 'input_open.m' に転送される
    menu_grid_mapview_Callback;
    FUNC_SWITCH = 0;
    end
catch
    return
end

%-------------------------------------------------------------------------
%           SAVE  AS .MAT(submenu) .MAT形式で保存するサブメニュー  
%-------------------------------------------------------------------------
function menu_file_save_Callback(hObject, eventdata, handles) % .MAT形式で保存するサブメニューをクリックしたときのコールバック関数
global INUM HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global FCOMMENT GRID SIZE SECTION 
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global PREF
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global VOLCANO SEISSTATION
global HOME_DIR PREF_DIR
    if isempty(PREF)==1 % prefが空の場合
       % デフォルト値を作成して保存する
       PREF = [1.0 0.0 0.0 1.2;...
               0.0 0.0 0.0 1.0;...
               0.7 0.7 0.0 0.2;...
               0.0 0.0 0.0 1.2;...
               1.0 0.5 0.0 3.0;...
               0.2 0.2 0.2 1.0;...
               2.0 0.0 0.0 0.0;...
               1.0 0.0 0.0 0.0;...
               0.9 0.9 0.1 1.0];    % volcano 火山のデフォルト値
    end
    if isempty(PREF_DIR) ~= 1 % PREF_DIRが空でない場合
        try
            cd(PREF_DIR); % PREF_DIRに移動
        catch
            cd(HOME_DIR); % HOME_DIRに移動
        end
    else
        try
            cd('input_files'); % input_filesに移動
        catch
            cd(HOME_DIR); % HOME_DIRに移動
        end    
    end
    [filename,pathname] = uiputfile('*.mat',... % uiputfile: ファイルを保存するダイアログボックスを表示
        ' Save Input File As'); % ファイルを保存するダイアログボックスを表示
    if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
        disp('User selected Cancel') % ユーザーがキャンセルを選択
    else
        disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
    end
    save(fullfile(pathname,filename), 'HEAD','NUM','POIS','CALC_DEPTH',... % save: ファイルに変数を保存
        'YOUNG','FRIC','R_STRESS','ID','KODE','ELEMENT','FCOMMENT',...
        'GRID','SIZE','SECTION','PREF','MIN_LAT','MAX_LAT','ZERO_LAT',...
        'MIN_LON','MAX_LON','ZERO_LON','COAST_DATA','AFAULT_DATA',...
        'EQ_DATA','GPS_DATA','VOLCANO','SEISSTATION',...
        '-mat');
    cd(HOME_DIR); % HOME_DIRに移動
    
%-------------------------------------------------------------------------
%           SAVE AS ASCII (submenu) ASCII形式で保存するサブメニュー  
%-------------------------------------------------------------------------
function menu_file_save_ascii_Callback(hObject, eventdata, handles) % ASCII形式で保存するサブメニューをクリックしたときのコールバック関数
global PREF HOME_DIR PREF_DIR IRAKE
    IRAKE = 0; % IRAKEを0に設定
    if isempty(PREF)==1 % prefが空の場合
       % デフォルト値を作成して保存する
       PREF = [1.0 0.0 0.0 1.2;...
               0.0 0.0 0.0 1.0;...
               0.7 0.7 0.0 0.2;...
               0.0 0.0 0.0 1.2;...
               1.0 0.5 0.0 3.0;...
               0.2 0.2 0.2 1.0;...
               2.0 0.0 0.0 0.0;...
               1.0 0.0 0.0 0.0]; % デフォルト値
    end
    if isempty(PREF_DIR) ~= 1 % PREF_DIRが空でない場合
        try
            cd(PREF_DIR); % PREF_DIRに移動
        catch
            cd(HOME_DIR); % HOME_DIRに移動
        end
    else
        try
            cd('input_files'); % input_filesに移動
        catch
            cd(HOME_DIR); % HOME_DIRに移動
        end    
    end
    [filename,pathname] = uiputfile('*.inp',... % uiputfile: ファイルを保存するダイアログボックスを表示
        ' Save Input File As'); 
    if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
        disp('User selected Cancel') % ユーザーがキャンセルを選択
    else
        disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
    end
    cd(pathname); % pathnameに移動
    input_save_ascii; % ASCII形式で保存
    cd(HOME_DIR); % HOME_DIRに移動
     
%-------------------------------------------------------------------------
%           SAVE AS ASCII2 (submenu)  - save as "rake" & "net slip" ASCII形式で保存するサブメニュー rakeとネットスリップとして保存
%-------------------------------------------------------------------------
function menu_file_save_ascii2_Callback(hObject, eventdata, handles)
global PREF HOME_DIR PREF_DIR IRAKE
    IRAKE = 1;
    if isempty(PREF)==1
       % デフォルト値を作成して保存する
       PREF = [1.0 0.0 0.0 1.2;...
               0.0 0.0 0.0 1.0;...
               0.7 0.7 0.0 0.2;...
               0.0 0.0 0.0 1.2;...
               1.0 0.5 0.0 3.0;...
               0.2 0.2 0.2 1.0;...
               2.0 0.0 0.0 0.0;...
               1.0 0.0 0.0 0.0];
    end
    if isempty(PREF_DIR) ~= 1 % PREF_DIRが空でない場合
        try
            cd(PREF_DIR);
        catch
            cd(HOME_DIR);
        end
    else
        try
            cd('input_files');
        catch
            cd(HOME_DIR);
        end    
    end
    [filename,pathname] = uiputfile('*.inr',... % ファイルを保存するダイアログボックスを表示
        ' Save Input File As');
    if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
        disp('User selected Cancel') % ユーザーがキャンセルを選択
        cd(HOME_DIR); return
    else
        disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
        cd(pathname); % pathnameに移動
        input_save_ascii; % ASCII形式で保存
        cd(HOME_DIR);
    end


%-------------------------------------------------------------------------
%           PUT MAP INFO (submenu) マップ情報を入力するサブメニュー
%-------------------------------------------------------------------------
function menu_map_info_Callback(hObject, eventdata, handles) % マップ情報を入力するサブメニューをクリックしたときのコールバック関数
global H_STUDY_AREA H_MAIN % スタディエリア、メインウィンドウ
H_STUDY_AREA = study_area; % study_area: スタディエリア
waitfor(H_STUDY_AREA);      % ユーザーの緯度と経度情報の入力を待つ
h = findobj('Tag','main_menu_window'); % main_menu_windowのハンドルを取得
if isempty(h)~=1 & isempty(H_MAIN)~=1 % main_menu_windowのハンドルが空でない場合、H_MAINが空でない場合
    iflag = check_lonlat_info; % 経度と緯度の情報をチェック
    if iflag == 1 % iflagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
%    set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
    end
end

%-------------------------------------------------------------------------
%           PREFERENCES (submenu) プリファレンスサブメニュー
%-------------------------------------------------------------------------
function menu_preferences_Callback(hObject, eventdata, handles) % プリファレンスサブメニューをクリックしたときのコールバック関数
global OUTFLAG
preference_window; % プリファレンスウィンドウ
if OUTFLAG == 1
    h = findobj('Tag','Radiobutton_output'); % Radiobutton_outputのハンドルを取得
    set(h,'Value',1); % Valueを1に設定
    h = findobj('Tag','Radiobutton_input'); % Radiobutton_inputのハンドルを取得
    set(h,'Value',0); % Valueを0に設定
else
    h = findobj('Tag','Radiobutton_output'); % Radiobutton_outputのハンドルを取得
    set(h,'Value',0); % Valueを0に設定
    h = findobj('Tag','Radiobutton_input'); % Radiobutton_inputのハンドルを取得
    set(h,'Value',1); % Valueを1に設定
end

%-------------------------------------------------------------------------
%           QUIT (submenu) 終了サブメニュー
%-------------------------------------------------------------------------
function menu_quit_Callback(hObject, eventdata, handles) % 終了サブメニューをクリックしたときのコールバック関数
global PREF OUTFLAG PREF_DIR HOME_DIR H_HELP INPUT_FILE FNUM_ONOFF % プリファレンス、OUTFLAG、PREF_DIR、HOME_DIR、H_HELP、INPUT_FILE、FNUM_ONOFF
subfig_clear; % サブフィギュアをクリア
tempdir = pwd; % 現在のディレクトリを取得
if ~strcmp(tempdir,HOME_DIR) % tempdirとHOME_DIRが異なる場合
    cd(HOME_DIR);
end
cd preferences
    dlmwrite('preferences.dat',PREF,'delimiter',' ','precision','%3.1f'); % プリファレンスを保存 delimiter: 区切り文字
            if isempty(OUTFLAG) == 1 % OUTFLAGが空の場合
                OUTFLAG = 1;
            end
            if isempty(PREF_DIR) == 1 % PREF_DIRが空の場合
                PREF_DIR = HOME_DIR;
            end
            if isempty(INPUT_FILE) == 1 % INPUT_FILEが空の場合
                INPUT_FILE = 'empty';
            end
    save preferences2.mat PREF_DIR INPUT_FILE OUTFLAG FNUM_ONOFF; % プリファレンスを保存
cd ..
h = figure(gcf); % 現在の図を取得
delete(h); % 図を削除
% ヘルプウィンドウ（H_HELP）のため
h = findobj('Tag','coulomb_help_window'); % coulomb_help_windowのハンドルを取得
if (isempty(h)~=1 && isempty(H_HELP)~=1) % hが空でなく、H_HELPが空でない場合
    close(figure(H_HELP)) % ヘルプウィンドウを閉じる
    H_HELP = []; % H_HELPを空にする
end

%=========================================================================
%    FUNCTIONS (menu) 関数メニュー
%=========================================================================
function function_menu_Callback(hObject, eventdata, handles) % 関数メニューをクリックしたときのコールバック関数

%-------------------------------------------------------------------------
%           GRID (submenu) グリッドサブメニュー
%-------------------------------------------------------------------------
function menu_grid_Callback(hObject, eventdata, handles) % グリッドサブメニューをクリックしたときのコールバック関数

% --------------------------------------------------------------------
function menu_grid_mapview_Callback(hObject, eventdata, handles) % グリッドマップビューをクリックしたときのコールバック関数
global FUNC_SWITCH ICOORD LON_GRID COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA % 関数スイッチ、ICOORD、LON_GRID、COAST_DATA、EQ_DATA、GPS_DATA、AFAULT_DATA
global ELEMENT ID KODE % 要素、ID、KODE
% global H_MAIN
subfig_clear;
FUNC_SWITCH = 1;
grid_drawing;
fault_overlay;
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1 % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
        hold on; % 現在の図を保持
        overlay_drawing; % オーバーレイの描画
    end
%end
FUNC_SWITCH = 0; %reset to 0
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1 % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
%    set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
end

% --------------------------------------------------------------------
function menu_grid_3d_Callback(hObject, eventdata, handles) % 3Dグリッドをクリックしたときのコールバック関数
global FUNC_SWITCH F3D_SLIP_TYPE H_F3D_VIEW % 関数スイッチ、F3D_SLIP_TYPE、H_F3D_VIEW
global ELEMENT POIS YOUNG FRIC ID H_MAIN H_VIEWPOINT % 要素、POIS、YOUNG、FRIC、ID、H_MAIN、H_VIEWPOINT
global ICOORD LON_GRID
global C_SLIP_SAT
% これまでの3Dプロットで「注釈」を使用することはできません
if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2で、LON_GRIDが空でない場合
    h = warndlg('Sorry this is not available for lat/lon coordinates. Change to Cartesian coordinates.',... % 警告ダイアログを表示
        '!! Warning !!'); % 警告ダイアログを表示
    waitfor(h); % モーダルダイアログボックスの終了を待つ
    return
end
subfig_clear; % サブフィギュアをクリア
hc = wait_calc_window; % wait_calc_window: 計算ウィンドウを待つ
FUNC_SWITCH = 1; % 関数スイッチを1に設定
F3D_SLIP_TYPE = 1;  % ネットスリップ
element_condition(ELEMENT,POIS,YOUNG,FRIC,ID); % 要素条件

C_SLIP_SAT = []; % C_SLIP_SATを空にする
grid_drawing_3d; % 3Dグリッドの描画
displ_open(2); % 2を開く

H_F3D_VIEW = f3d_view_control_window;
% figure(H_MAIN); % H_MAINの図を表示
% menu_gps_Callback; % GPSをクリックしたときのコールバック関数
gps_3d_overlay; % GPS 3Dオーバーレイ

flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
end
close(hc); % hcを閉じる

%-------------------------------------------------------------------------
%           DISPLACEMENT (submenu)  with sub-submenu ディスプレイスメントサブメニュー
%-------------------------------------------------------------------------
function menu_displacement_Callback(hObject, eventdata, handles) % ディスプレイスメントサブメニューをクリックしたときのコールバック関数

%-------------------------------------------------------------------------
%                       VECTORS (sub-submenu) ベクトルサブサブメニュー
%-------------------------------------------------------------------------
function menu_vectors_Callback(hObject, eventdata, handles) % ベクトルサブサブメニューをクリックしたときのコールバック関数
global FUNC_SWITCH % 関数スイッチ
global DC3D IACT % DC3D、IACT
global H_DISPL ICOORD FIXFLAG INPUT_FILE
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global GPS_FLAG GPS_SEQN_FLAG
global OUTFLAG PREF_DIR HOME_DIR H_MAIN
subfig_clear; % サブフィギュアをクリア
FUNC_SWITCH = 2; % 関数スイッチを2に設定
FIXFLAG = 0; % FIXFLAGを0に設定
% Okadaハーフスペースの再計算を回避するため
if IACT ~= 1        
    Okada_halfspace; % Okadaハーフスペースを計算
end
IACT = 1; % Okadaの出力を保持するため
    a = DC3D(:,1:2); % DC3Dの1から2列を取得
    b = DC3D(:,5:8); % DC3Dの5から8列を取得
    c = horzcat(a,b); % aとbを水平に連結
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1 % OUTFLAGが1または空の場合
	    cd output_files; % output_filesに移動
    else
	    cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE]; % 選択された入力ファイル
    header2 = 'x y z UX UY UZ'; % ヘッダー
    header3 = '(km) (km) (km) (m) (m) (m)'; % ヘッダー
    dlmwrite('Displacement.cou',header1,'delimiter',''); % Displacement.couにheader1を書き込む
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); % Displacement.couにheader2を追加
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); % Displacement.couにheader3を追加
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f'); % Displacement.couにcを追加
    disp(['Displacement.cou is saved in ' pwd]); % Displacement.couが保存されました
    cd (HOME_DIR);
displ_open(2); % 2を開く
H_DISPL = displ_h_window;
if ICOORD == 1 % ICOORDが1の場合 → 経度と緯度のメニューを非表示
    set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off'); % radiobutton_fixlonlatを非表示
    set(findobj('Tag','text_disp_lon'),'Visible','off'); % text_disp_lonを非表示
    set(findobj('Tag','text_disp_lat'),'Visible','off'); % text_disp_latを非表示
    set(findobj('Tag','edit_fixlon'),'Visible','off'); % edit_fixlonを非表示
    set(findobj('Tag','edit_fixlat'),'Visible','off'); % edit_fixlatを非表示
else % ICOORDが1でない場合 → カートジアン座標のメニューを非表示
    set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
    set(findobj('Tag','text_cart_x'),'Visible','off');
    set(findobj('Tag','text_cart_y'),'Visible','off'); 
    set(findobj('Tag','text_x_km'),'Visible','off');
    set(findobj('Tag','text_y_km'),'Visible','off');
    set(findobj('Tag','edit_fixx'),'Visible','off');
    set(findobj('Tag','edit_fixy'),'Visible','off');    
end
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1 % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
%	set(findobj('Tag','menu_focal_mech'),'Enable','On');
end
% ----- overlay drawing オーバーレイの描画 --------------------------------
%if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2で、LON_GRIDが空でない場合
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1 % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
        figure(H_MAIN); hold on; % H_MAINの図を保持
        overlay_drawing; % オーバーレイの描画
end

%-------------------------------------------------------------------------
%                       WIREFRAME (sub-submenu) ワイヤフレームサブサブメニュー
%-------------------------------------------------------------------------
function menu_wireframe_Callback(hObject, eventdata, handles) % ワイヤフレームサブサブメニューをクリックしたときのコールバック関数
global FUNC_SWITCH FIXFLAG % 関数スイッチ、FIXFLAG
global DC3D IACT
global H_DISPL ICOORD INPUT_FILE
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global OUTFLAG PREF_DIR HOME_DIR H_MAIN
subfig_clear; % サブフィギュアをクリア
FUNC_SWITCH = 3; % 関数スイッチを3に設定
FIXFLAG    = 0; % FIXFLAGを0に設定
% Okadaハーフスペースの再計算を回避するため
if IACT ~= 1
Okada_halfspace; % Okadaハーフスペースを計算
end
IACT = 1; % Okadaの出力を保持するため
    a = DC3D(:,1:2); % DC3Dの1から2列を取得
    b = DC3D(:,5:8); % DC3Dの5から8列を取得
    c = horzcat(a,b); % aとbを水平に連結
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1 % OUTFLAGが1または空の場合
	cd output_files; % output_filesに移動
    else
	cd (PREF_DIR); % PREF_DIRに移動
    end
    % Displacement.couをASCII形式で保存
    header1 = ['Input file selected: ',INPUT_FILE]; % 選択された入力ファイル
    header2 = 'x y z UX UY UZ'; % ヘッダー
    header3 = '(km) (km) (km) (m) (m) (m)'; % ヘッダー
    dlmwrite('Displacement.cou',header1,'delimiter',''); % Displacement.couにheader1を書き込む
    dlmwrite('Displacement.cou',header2,'-append','delimiter','\t'); % Displacement.couにheader2を追加
    dlmwrite('Displacement.cou',header3,'-append','delimiter','\t'); % Displacement.couにheader3を追加
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f'); % Displacement.couにcを追加
    disp(['Displacement.cou is saved in ' pwd]); % Displacement.couが保存されました
    cd (HOME_DIR); % HOME_DIRに移動
displ_open(2); % 2を開く
H_DISPL = displ_h_window; % ディスプレイスメントウィンドウ
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
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1 % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
%    set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
end
% ----- overlay drawing オーバーレイの描画 --------------------------------
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1 % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
        figure(H_MAIN); hold on; % H_MAINの図を保持
        overlay_drawing; % オーバーレイの描画
end

%-------------------------------------------------------------------------
%                       CONTOURS (sub-submenu) コンターサブサブメニュー
%-------------------------------------------------------------------------
function menu_contours_Callback(hObject, eventdata, handles) % コンターサブサブメニューをクリックしたときのコールバック関数
global FUNC_SWITCH
global DC3D IACT VD_CHECKED SHADE_TYPE INPUT_FILE
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global OUTFLAG PREF_DIR HOME_DIR H_MAIN
subfig_clear; % サブフィギュアをクリア
FUNC_SWITCH = 4; % 関数スイッチを4に設定
VD_CHECKED = 0; % default
SHADE_TYPE = 1; % default
grid_drawing; % グリッドの描画
% to escape recalculation of Okada half space
if IACT ~= 1
Okada_halfspace; % Okadaハーフスペースを計算
end
IACT = 1; % to keep okada output
    a = DC3D(:,1:2); % DC3Dの1から2列を取得
    b = DC3D(:,5:8); % DC3Dの5から8列を取得
    c = horzcat(a,b); % aとbを水平に連結
    format long;
    % save Displacement.cou a -ascii
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files; % output_filesに移動
    else
	cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z UX UY UZ';
    header3 = '(km) (km) (km) (m) (m) (m)';
    dlmwrite('Displacement.cou',header1,'delimiter',''); 
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
    disp(['Displacement.cou is saved in ' pwd]);
    cd (HOME_DIR);
displ_open(2);
fault_overlay; % フォルトオーバーレイ
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1 % flagが1の場合
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
%    set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
end
% ----- overlay drawing オーバーレイの描画 --------------------------------
%if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2で、LON_GRIDが空でない場合
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1 % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
        figure(H_MAIN); hold on; % H_MAINの図を保持
        overlay_drawing; % オーバーレイの描画
end

%-------------------------------------------------------------------------
%                       3D IMAGE (sub-submenu) 3Dイメージサブサブメニュー
%-------------------------------------------------------------------------
function menu_3d_Callback(hObject, eventdata, handles)
global FUNC_SWITCH
global DC3D IACT INPUT_FILE ICOORD LON_GRID
global OUTFLAG PREF_DIR HOME_DIR H_VIEWPOINT
subfig_clear;
FUNC_SWITCH = 5;
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.',...
        '!! Warning !!'); % 警告ダイアログを表示
    waitfor(h);
end
% Okadaハーフスペースの再計算を回避するため
if IACT ~= 1        
Okada_halfspace;
end
IACT = 1;           % to keep okada output
    a = DC3D(:,1:2);
    b = DC3D(:,5:8);
    c = horzcat(a,b);
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files;
    else
	cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z UX UY UZ';
    header3 = '(km) (km) (km) (m) (m) (m)';
    dlmwrite('Displacement.cou',header1,'delimiter',''); 
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
    disp(['Displacement.cou is saved in ' pwd]);
    cd (HOME_DIR);
grid_drawing_3d; hold on;
displ_open(2);
h = findobj('Tag','xlines'); delete(h);
h = findobj('Tag','ylines'); delete(h);
% FUNC_SWITCH = 0; %reset
% H_VIEWPOINT = viewpoint3d_window;

% --------------------------------------------------------------------
function menu_3d_wire_Callback(hObject, eventdata, handles) % 3Dワイヤをクリックしたときのコールバック関数
global FUNC_SWITCH
global DC3D IACT INPUT_FILE ICOORD LON_GRID
global OUTFLAG PREF_DIR HOME_DIR H_VIEWPOINT
subfig_clear;
FUNC_SWITCH = 5.5; % 関数スイッチを5.5に設定
if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2で、LON_GRIDが空でない場合
    h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.',...
        '!! Warning !!'); % 警告ダイアログを表示
    waitfor(h);
end
% Okadaハーフスペースの再計算を回避するため
if IACT ~= 1        
Okada_halfspace; % Okadaハーフスペースを計算
end
IACT = 1;           % to keep okada output
    a = DC3D(:,1:2); % DC3Dの1から2列を取得
    b = DC3D(:,5:8); % DC3Dの5から8列を取得
    c = horzcat(a,b); % aとbを水平に連結
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1 % OUTFLAGが1または空の場合
	cd output_files; % output_filesに移動
    else
	cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z UX UY UZ';
    header3 = '(km) (km) (km) (m) (m) (m)';
    dlmwrite('Displacement.cou',header1,'delimiter','');
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
    disp(['Displacement.cou is saved in ' pwd]);
    cd (HOME_DIR);

grid_drawing_3d; hold on; % 3Dグリッドの描画
displ_open(2); % 2を開く
h = findobj('Tag','xlines'); delete(h); % xlinesを削除
h = findobj('Tag','ylines'); delete(h); % ylinesを削除
% FUNC_SWITCH = 0; %reset
% H_VIEWPOINT = viewpoint3d_window;

% --------------------------------------------------------------------
function menu_3d_vectors_Callback(hObject, eventdata, handles) % 3Dベクトルをクリックしたときのコールバック関数
global FUNC_SWITCH
global DC3D IACT INPUT_FILE ICOORD LON_GRID
global OUTFLAG PREF_DIR HOME_DIR H_VIEWPOINT
subfig_clear; % サブフィギュアをクリア
FUNC_SWITCH = 5.7; % 関数スイッチを5.7に設定
if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2で、LON_GRIDが空でない場合
    h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.',...
        '!! Warning !!'); % 警告ダイアログを表示
    waitfor(h); % モーダルダイアログボックスの終了を待つ
end
% to escape recalculation of Okada half space
if IACT ~= 1        
Okada_halfspace;
end
IACT = 1;           % to keep okada output
    a = DC3D(:,1:2);
    b = DC3D(:,5:8);
    c = horzcat(a,b);
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
	cd output_files;
    else
	cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z UX UY UZ';
    header3 = '(km) (km) (km) (m) (m) (m)';
    dlmwrite('Displacement.cou',header1,'delimiter',''); 
    dlmwrite('Displacement.cou',header2,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',header3,'-append','delimiter',''); 
    dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
    disp(['Displacement.cou is saved in ' pwd]);
    cd (HOME_DIR);
grid_drawing_3d; hold on;
displ_open(2);
h = findobj('Tag','xlines'); delete(h);
h = findobj('Tag','ylines'); delete(h);
% FUNC_SWITCH = 0; %reset
% H_VIEWPOINT = viewpoint3d_window;

%-------------------------------------------------------------------------
%           STRAIN (submenu) ひずみサブメニュー 
%-------------------------------------------------------------------------
function menu_strain_Callback(hObject, eventdata, handles)
global H_STRAIN IACT H_MAIN
global FUNC_SWITCH SHADE_TYPE STRAIN_SWITCH
global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
subfig_clear; IACT = 0;
FUNC_SWITCH = 6;
SHADE_TYPE = 1; % default
STRAIN_SWITCH = 1; % default sig XX
H_STRAIN = strain_window; % strain_windowを開く
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on; % すべてのオーバーレイを有効にする
%    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end
% ----- overlay drawing --------------------------------
%if ICOORD == 2 && isempty(LON_GRID) ~= 1
    if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        figure(H_MAIN); hold on;
        overlay_drawing;
end

%-------------------------------------------------------------------------
%           STRESS (submenu)        with sub-submenu 応力サブメニュー
%-------------------------------------------------------------------------
function menu_stress_Callback(hObject, eventdata, handles) % 応力サブメニューをクリックしたときのコールバック関数

% --------------------------------------------------------------------
function menu_shear_stress_change_Callback(hObject, eventdata, handles)
global FUNC_SWITCH IACT
global STRESS_TYPE
global H_COULOMB
subfig_clear;   IACT = 0;
FUNC_SWITCH = 7;    STRESS_TYPE = 5;
H_COULOMB = coulomb_window;
set(findobj('Tag','text_fric'),'Visible','off'); % text_fricを非表示
set(findobj('Tag','edit_coul_fric'),'Visible','off'); % edit_coul_fricを非表示
flag = check_lonlat_info;
if flag == 1
    all_overlay_enable_on;
%    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end

% --------------------------------------------------------------------
function menu_normal_stress_change_Callback(hObject, eventdata, handles)
global FUNC_SWITCH IACT
global STRESS_TYPE
global H_COULOMB
subfig_clear; IACT = 0;
FUNC_SWITCH = 8; STRESS_TYPE = 5;
H_COULOMB = coulomb_window; % coulomb_windowを開く
set(findobj('Tag','text_fric'),'Visible','off');
set(findobj('Tag','edit_coul_fric'),'Visible','off');
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;
%    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end

% --------------------------------------------------------------------
function menu_coulomb_stress_change_Callback(hObject, eventdata, handles)
global FUNC_SWITCH IACT
global STRESS_TYPE
global H_COULOMB
subfig_clear;   IACT = 0;
FUNC_SWITCH = 9;    STRESS_TYPE = 5;
H_COULOMB = coulomb_window; % coulomb_windowを開く
set(findobj('Tag','crosssection_toggle'),'Enable','off');
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;
%    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end

% --------------------------------------------------------------------
function menu_stress_on_faults_Callback(hObject, eventdata, handles) % フォルト上の応力をクリックしたときのコールバック関数
global ELEMENT POIS YOUNG FRIC ID
global FUNC_SWITCH ICOORD LON_GRID
global h_grid
global DC3D IACT
global H_MAIN H_EC_CONTROL H_VIEWPOINT
if ICOORD == 2 && isempty(LON_GRID) ~= 1 % ICOORDが2で、LON_GRIDが空でない場合
    h = warndlg('Sorry this is not available for lat/lon coordinates. Change to Cartesian coordinates.',...
        '!! Warning !!');
    waitfor(h);
    return
end
% hc = wait_calc_window;   % custom waiting dialog % カスタム待機ダイアログ
subfig_clear;
% clear_obj_and_subfig
FUNC_SWITCH = 10;
% element_condition(ELEMENT,POIS,YOUNG,FRIC,ID);
% grid_drawing_3d;
% displ_open(2);
H_EC_CONTROL = ec_control_window; % ec_control_windowを開く
% close(hc);

% --------------------------------------------------------------------
function menu_stress_on_a_fault_Callback(hObject, eventdata, handles)
global FUNC_SWITCH H_POINT IACT
IACT = 0;
if FUNC_SWITCH ~= 7 && FUNC_SWITCH ~= 8 && FUNC_SWITCH ~= 9
    subfig_clear;
    FUNC_SWITCH = 1;
    grid_drawing;
    fault_overlay;
end
H_POINT = point_calc_window; % point_calc_windowを開く
flag = check_lonlat_info; % 経度と緯度の情報をチェック
if flag == 1
    all_overlay_enable_on;
%    set(findobj('Tag','menu_focal_mech'),'Enable','On');
end

% --------------------------------------------------------------------
function menu_focal_mech_Callback(hObject, eventdata, handles)
global FUNC_SWITCH NODAL_ACT NODAL_STRESS HOME_DIR
FUNC_SWITCH = 11; % 関数スイッチを11に設定
NODAL_ACT = 0; % NODAL_ACTを0に設定
NODAL_STRESS = []; % NODAL_STRESSを空にする
cd (HOME_DIR); % HOME_DIRに移動
focal_mech_calc; % フォーカルメカニズム計算

%-------------------------------------------------------------------------
%           CHANGE PARAMETERS (submenu) with sub-submenu パラメータ変更サブメニュー
%-------------------------------------------------------------------------
function menu_change_parameters_Callback(hObject, eventdata, handles) % パラメータ変更サブメニューをクリックしたときのコールバック関数

% --------------------------------------------------------------------
function menu_all_parameters_Callback(hObject, eventdata, handles) % すべてのパラメータをクリックしたときのコールバック関数
global H_INPUT IACT
H_INPUT = input_window;
waitfor(H_INPUT);
IACT = 0;
menu_grid_mapview_Callback;     % redraw the renewed grid

% --------------------------------------------------------------------
function menu_grid_size_Callback(hObject, eventdata, handles)
global GRID
global IACT ICOORD LON_GRID LON_PER_X LAT_PER_Y XY_RATIO
temp1 = GRID(5,1); temp2 = GRID(6,1);
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    prompt = {'Enter new lon. increment(deg):','Enter new lat. increment(deg):'}; % 新しい経度の増分(度)を入力してください
    defc1 = num2str(GRID(5,1)*LON_PER_X,'%9.3f'); % defc1を設定
    defc2 = num2str(GRID(6,1)*LAT_PER_Y,'%9.3f'); % defc2を設定
else
    prompt = {'Enter new x increment(km):','Enter new y increment(km):'}; % 新しいxの増分(km)を入力してください
    defc1 = num2str(GRID(5,1),'%9.3f'); % defc1を設定
    defc2 = num2str(GRID(6,1),'%9.3f'); % defc2を設定
end
name = 'Grid Size'; % グリッドサイズ
numlines = 1; % numlinesを1に設定
options.Resize = 'on'; % オプションのリサイズをオンに設定
options.WindowStyle = 'normal'; % オプションのウィンドウスタイルを通常に設定
answer = inputdlg(prompt,name,numlines,{defc1,defc2},options); % ダイアログボックスに入力する
answer = [answer]; % answerを[answer]に設定
    n = 5;
    xlim = (GRID(3)-GRID(1))/n; % xlimを(GRID(3)-GRID(1))/nに設定
    ylim = (GRID(4)-GRID(2))/n; % ylimを(GRID(4)-GRID(2))/nに設定
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    GRID(5,1) = str2double(answer(1))/LON_PER_X;
    GRID(6,1) = str2double(answer(2))/LAT_PER_Y;
    xlim = xlim/LON_PER_X;
    ylim = ylim/LAT_PER_Y;
else
    GRID(5,1) = str2double(answer(1));
    GRID(6,1) = str2double(answer(2));
end
if str2double(answer(1)) > xlim
    warndlg('The x increment might be large relative to the study area. Not acceptable.'); % xの増分が研究領域に対して大きい可能性があります。受け入れられません。
    return
end
if str2double(answer(2)) > xlim
    warndlg('The y increment might be large relative to the study area. Not acceptable.'); % yの増分が研究領域に対して大きい可能性があります。受け入れられません。
    return
end
if isnan(GRID(5,1)) == 1 | isempty(GRID(5,1)) == 1
    GRID(5,1) = temp1;
end
if isnan(GRID(6,1)) == 1 | isempty(GRID(6,1)) == 1
    GRID(6,1) = temp2;
end
% to calculate and save numbers for basic info
calc_element; % 要素を計算
IACT = 0; % IACTを0に設定
menu_grid_mapview_Callback; % 更新されたグリッドを再描画

% --------------------------------------------------------------------
function menu_calc_depth_Callback(hObject, eventdata, handles) % 計算深度をクリックしたときのコールバック関数
global CALC_DEPTH
global IACT
global H_DISPL
temp = CALC_DEPTH; % tempをCALC_DEPTHに設定
prompt = 'Enter new calculation depth (positive):'; % 新しい計算深度(正)を入力してください
name = 'Calc. Depth'; % Calc. Depth
numlines = 1; % numlinesを1に設定
options.Resize = 'on'; % オプションのリサイズをオンに設定
options.WindowStyle = 'normal'; % オプションのウィンドウスタイルを通常に設定
defc = num2str(CALC_DEPTH,'%6.2f'); % defcをCALC_DEPTHに設定
answer = inputdlg(prompt,name,numlines,{defc},options); % ダイアログボックスに入力する
if str2double(answer) < 0.0
    warndlg('Put positive number. Not acceptable'); % 正の数を入力してください。受け入れられません。
	return
end
CALC_DEPTH = str2double(answer);
if isnan(CALC_DEPTH) == 1 | isempty(CALC_DEPTH) == 1
    CALC_DEPTH = temp;
end
h = findobj('Tag','displ_h_window');
if (isempty(h)~=1 && isempty(H_DISPL)~=1)
    set(findobj('Tag','edit_displdepth'),'String',num2str(CALC_DEPTH,'%5.2f')); % edit_displdepthにCALC_DEPTHを設定
end
IACT = 0;
menu_grid_mapview_Callback;     % redraw the renewed grid

% --------------------------------------------------------------------
function menu_coeff_friction_Callback(hObject, eventdata, handles) % 摩擦係数をクリックしたときのコールバック関数
global FRIC
temp = FRIC;
prompt = 'Enter new friction (positive):'; % 新しい摩擦(正)を入力してください
name = 'Coeff. Friction'; % Coeff. Friction
numlines = 1;
options.Resize = 'on';
options.WindowStyle = 'normal';
defc = num2str(FRIC,'%4.3f');
answer = inputdlg(prompt,name,numlines,{defc},options);
if str2double(answer) < 0.0
    warndlg('Put positive number. Not acceptable'); % 正の数を入力してください。受け入れられません。
	return
end
FRIC = str2double(answer); % FRICをanswerに設定
if isnan(FRIC) == 1 | isempty(FRIC) == 1
    FRIC = temp;
end

% --------------------------------------------------------------------
function menu_exaggeration_Callback(hObject, eventdata, handles) % 誇張をクリックしたときのコールバック関数
global SIZE
temp = SIZE(3);
prompt = 'Enter new displ. exaggeration:'; % 新しいdispl. exaggerationを入力してください
name = 'Displ. exaggeration'; % Displ. exaggeration
numlines = 1;
options.Resize = 'on';
options.WindowStyle = 'normal';
defc = num2str(SIZE(3)); % defcをSIZE(3)に設定
answer = inputdlg(prompt,name,numlines,{defc},options); % ダイアログボックスに入力する
SIZE(3) = str2double(answer); % SIZE(3)をanswerに設定
if isnan(SIZE(3)) == 1 | isempty(SIZE(3)) == 1
    SIZE(3) = temp;
end

%-------------------------------------------------------------------------
%           TAPER & SPLIT (submenu) テーパーとスプリットサブメニュー
%-------------------------------------------------------------------------
function menu_taper_split_Callback(hObject, eventdata, handles) % テーパーとスプリットサブメニューをクリックしたときのコールバック関数
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
    warndlg('Since you do not have mapping toolbox, this menu is unavailable. Sorry.',...
        '!!Warning!!');
    return;
end
H_UTM = utm_window;
UTM_FLAG = 0; % just a tool
set(findobj('Tag','pushbutton_add'),'Visible','off');
set(findobj('Tag','pushbutton_f_add'),'Visible','off');
set(findobj('Tag','edit_all_input_params'),'Visible','off');

%-------------------------------------------------------------------------
%           CALC. PROPER PRINCIPAL AXES (submenu) 適切な主軸を計算するサブメニュー
%-------------------------------------------------------------------------
function menu_calc_principal_Callback(hObject, eventdata, handles) % 主軸を計算するサブメニューをクリックしたときのコールバック関数
global H_CALC_PRINCIPAL
H_CALC_PRINCIPAL = calc_principals_window; % calc_principals_windowを開く

%-------------------------------------------------------------------------
%           HELP (submenu) ヘルプサブメニュー 
%-------------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
global H_HELP
H_HELP = coulomb_help_window;
% hObject    handle to menu_help (see GCBO) % menu_helpへのハンドル(参照)
% eventdata  reserved - to be defined in a future version of MATLAB % 予約済み - MATLABの将来のバージョンで定義される予定
% handles    structure with handles and user data (see GUIDATA) % handlesとユーザーデータを持つ構造体(参照)

%=========================================================================
%    OVERLAY (menu) オーバーレイメニュー
%=========================================================================
function overlay_menu_Callback(hObject, eventdata, handles)

%-------------------------------------------------------------------------
%           COASTLINES (submenu) 海岸線サブメニュー
%-------------------------------------------------------------------------
function menu_coastlines_Callback(hObject, eventdata, handles) % 海岸線サブメニューをクリックしたときのコールバック関数
global H_MAIN COAST_DATA
    if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
        set(gcbo, 'Checked', 'off'); % gcboをoffに設定
        figure(H_MAIN); % H_MAINの図
        try
            h = findobj('Tag','CoastlineObj'); % 'Tag'が'CoastlineObj'のオブジェクトを検索
            delete(h);
        catch
            return
        end
    else 
        set(gcbo, 'Checked', 'on'); % gcboをonに設定
        hold off;
        coastline_drawing; % 海岸線の描画
        hold on;
    end

%-------------------------------------------------------------------------
%           ACTIVE FAULTS (submenu) アクティブフォールトサブメニュー
%-------------------------------------------------------------------------
function menu_activefaults_Callback(hObject, eventdata, handles) % アクティブフォールトサブメニューをクリックしたときのコールバック関数
global H_MAIN AFAULT_DATA
    if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
        set(gcbo, 'Checked', 'off'); % gcboをoffに設定
        figure(H_MAIN); % H_MAINの図
        try
            h = findobj('Tag','AfaultObj'); % 'Tag'が'AfaultObj'のオブジェクトを検索
            delete(h);
        catch
            return
        end
    else 
        set(gcbo, 'Checked', 'on'); % gcboをonに設定
        hold off;
        if isempty(AFAULT_DATA) == 1 % AFAULT_DATAが空の場合
            afault_format_window; % afault_format_windowを開く
        else
 %           hold off;
            afault_drawing; % afault_drawingを実行
        end
        hold on;
    end
    
%-------------------------------------------------------------------------
%           EARTHQUAKES (submenu) 地震サブメニュー
%-------------------------------------------------------------------------
function menu_earthquakes_Callback(hObject, eventdata, handles)
global H_MAIN H_F3D_VIEW H_EC_CONTROL
    if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
        set(gcbo, 'Checked', 'off'); % gcboをoffに設定
        figure(H_MAIN); % H_MAINの図
        try
            h = findobj('Tag','EqObj'); % 'Tag'が'EqObj'のオブジェクトを検索
            delete(h); % hを削除
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
        earthquake_plot; % 地震プロット
%         if ~isempty(H_F3D_VIEW) | ~isempty(H_EC_CONTROL)
%             
%         else
            fault_overlay; % フォルトを再度プロット
%         end
        hold on;
    end


%-------------------------------------------------------------------------
%           VOLCANOES (submenu) 火山サブメニュー 
%-------------------------------------------------------------------------
function menu_volcanoes_Callback(hObject, eventdata, handles)
global H_MAIN PREF
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
        figure(H_MAIN);
        try
            h = findobj('Tag','VolcanoObj');
            delete(h);
        catch
            return
        end
    else 
        set(gcbo, 'Checked', 'on');
        hold off;
        volcano_overlay('MarkerSize',PREF(9,4)*14); % 火山オーバーレイ ('MarkerSize',PREF(9,4)*14)
        hold on;
    end

    
%-------------------------------------------------------------------------
%           GPS stations (submenu) GPSステーションサブメニュー
%-------------------------------------------------------------------------
function menu_gps_Callback(hObject, eventdata, handles) % GPSステーションサブメニューをクリックしたときのコールバック関数
global H_MAIN ICOORD LON_GRID PREF
global H_F3D_VIEW % グラフィックが2Dか3Dかを識別する識別子
global GPS_DATA SIZE

%     ck = get(findobj('Tag','menu_gps'),'Checked'); % 'Tag'が'menu_gps'のオブジェクトを取得
   if strcmp(get(gcbo, 'Checked'),'on')
%     if strcmp(ck,'on')
        set(gcbo, 'Checked', 'off');
        set(findobj('Tag','menu_gps'),'Checked','off'); 
        figure(H_MAIN);
        try
            delete(findobj('Tag','GPSObj'));
            delete(findobj('Tag','GPSOBSObj'));
            delete(findobj('Tag','GPSCALCObj'));
            delete(findobj('Tag','UNITObj'));
            delete(findobj('Tag','UNITTEXTObj'));
            delete(findobj('Tag','GPS3D_OBS_Obj'));
            delete(findobj('Tag','GPS3D_CALC_Obj'));
        catch
            return
        end
    else 
        set(gcbo, 'Checked', 'on');
%         set(findobj('Tag','menu_gps'),'Checked','on'); 
        hold off;
        if isempty(H_F3D_VIEW)
            gps_plot;
            fault_overlay;  % plot fault again
        else   
            gps_3d_overlay; % 3Dオーバーレイ
        end
        hold on;
   end

%-------------------------------------------------------------------------
%           Trace faults and put them into input file (submenu) 断層をトレースして入力ファイルに入れるサブメニュー
%-------------------------------------------------------------------------
function menu_trace_put_faults_Callback(hObject, eventdata, handles) % 断層をトレースして入力ファイルに入れるサブメニューをクリックしたときのコールバック関数
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
set(findobj('Tag','menu_volcanoes'),'Enable','On');
set(findobj('Tag','menu_gps'),'Enable','On'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','On');
set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 

%----------------------------------------------------------
function all_overlay_enable_off
set(findobj('Tag','menu_coastlines'),'Enable','Off');
set(findobj('Tag','menu_activefaults'),'Enable','Off');
set(findobj('Tag','menu_earthquakes'),'Enable','Off');
set(findobj('Tag','menu_volcanoes'),'Enable','Off');
set(findobj('Tag','menu_gps'),'Enable','Off'); 
set(findobj('Tag','menu_clear_overlay'),'Enable','Off'); 
set(findobj('Tag','menu_trace_put_faults'),'Enable','Off'); 

% % --------------------------------------------------------------------
function menu_tools_Callback(hObject, eventdata, handles)
% % hObject    handle to menu_tools (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


%-------------------------------------------------------------------------
%	Clear overlay data (submenu) オーバーレイデータをクリアするサブメニュー
%-------------------------------------------------------------------------
function menu_clear_overlay_Callback(hObject, eventdata, handles) % オーバーレイデータをクリアするサブメニューをクリックしたときのコールバック関数
% hObject    handle to menu_clear_overlay (see GCBO) % menu_clear_overlayへのハンドル(参照)
% eventdata  reserved - to be defined in a future version of MATLAB % 予約済み - MATLABの将来のバージョンで定義される予定
% handles    structure with handles and user data (see GUIDATA) % handlesとユーザーデータを持つ構造体(参照)
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global VOLCANO
if isempty(COAST_DATA)==1
    set(findobj('Tag','submenu_clear_coastlines'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_coastlines'),'Enable','On');
end
if isempty(AFAULT_DATA)==1
    set(findobj('Tag','submenu_clear_afaults'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_afaults'),'Enable','On');
end
if isempty(EQ_DATA)==1
    set(findobj('Tag','submenu_clear_earthquakes'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_earthquakes'),'Enable','On');
end
if isempty(VOLCANO)==1
    set(findobj('Tag','submenu_clear_volcanoes'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_volcanoes'),'Enable','On');
end
if isempty(GPS_DATA)==1
    set(findobj('Tag','submenu_clear_gps'),'Enable','Off');
else
    set(findobj('Tag','submenu_clear_gps'),'Enable','On');
end

%-------------------------------------------------------------------------
%       Submenu clear coastline data (submenu) 海岸線データをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_coastlines_Callback(hObject, eventdata, handles)
global COAST_DATA H_MAIN
COAST_DATA = [];
set(findobj('Tag','menu_coastlines'),'Checked','Off'); % 'Tag'が'menu_coastlines'のオブジェクトを取得
        figure(H_MAIN);
        try
            h = findobj('Tag','CoastlineObj');
            delete(h);
        catch
            return
        end
% hObject    handle to submenu_clear_coastlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------
%       Submenu clear active fault data (submenu) アクティブフォールトデータをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_afaults_Callback(hObject, eventdata, handles)
global AFAULT_DATA H_MAIN
AFAULT_DATA = [];
set(findobj('Tag','menu_activefaults'),'Checked','Off');
        figure(H_MAIN);        
        try
            h = findobj('Tag','AfaultObj');
            delete(h);
        catch
            return
        end
% hObject    handle to submenu_clear_afaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------
%       Submenu clear earthquake data (submenu) 地震データをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_earthquakes_Callback(hObject, eventdata, handles)
global EQ_DATA H_MAIN
EQ_DATA = [];
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

% hObject    handle to submenu_clear_earthquakes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------
%       Submenu clear volcano data (submenu) 火山データをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_volcanoes_Callback(hObject, eventdata, handles)
global VOLCANO H_MAIN
VOLCANO = [];
set(findobj('Tag','menu_volcanoes'),'Checked','Off');
        figure(H_MAIN);        
        try
            h = findobj('Tag','VolcanoObj');
            delete(h);
        catch
            return
        end

%-------------------------------------------------------------------------
%       Submenu clear gps data (submenu) GPSデータをクリアするサブメニュー
%-------------------------------------------------------------------------
function submenu_clear_gps_Callback(hObject, eventdata, handles)
global GPS_DATA H_MAIN
GPS_DATA = [];
set(findobj('Tag','menu_gps'),'Checked','Off');
        figure(H_MAIN);        
        try
            delete(findobj('Tag','GPSObj'));
            delete(findobj('Tag','GPSOBSObj'));
            delete(findobj('Tag','GPSCALCObj'));
            delete(findobj('Tag','UNITObj'));
            delete(findobj('Tag','UNITTEXTObj'));
        catch
            return
        end
% hObject    handle to submenu_clear_earthquakes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function uimenu_fault_modifications_Callback(hObject, eventdata, handles) % uimenu_fault_modificationsをクリックしたときのコールバック関数
% hObject    handle to uimenu_fault_modifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('under construction')

% --------------------------------------------------------------------
function Context_functions_Callback(hObject, eventdata, handles) % Context_functionsをクリックしたときのコールバック関数
% hObject    handle to Context_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function check_overlay_items % オーバーレイアイテムをチェックする
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global VOLCANO
    if ~isempty(COAST_DATA)
        set(findobj('Tag','menu_coastlines'),'Checked','On');
    else
        set(findobj('Tag','menu_coastlines'),'Checked','Off');
    end
    if ~isempty(AFAULT_DATA)
        set(findobj('Tag','menu_activefaults'),'Checked','On');
    else
        set(findobj('Tag','menu_activefaults'),'Checked','Off');
    end
    if ~isempty(EQ_DATA)
        set(findobj('Tag','menu_earthquakes'),'Checked','On');
    else
        set(findobj('Tag','menu_earthquakes'),'Checked','Off');
    end
    if ~isempty(VOLCANO)
        set(findobj('Tag','menu_volcanoes'),'Checked','On');
    else
        set(findobj('Tag','menu_volcanoes'),'Checked','Off');
    end
    if ~isempty(GPS_DATA)
        set(findobj('Tag','menu_gps'),'Checked','On');
    else
        set(findobj('Tag','menu_gps'),'Checked','Off');
    end