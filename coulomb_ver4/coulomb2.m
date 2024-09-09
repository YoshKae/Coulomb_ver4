%========================================================================
%                           Program Coulomb 
%========================================================================
%  http://www.coulombstress.org/download
%
%       developed by Shinji Toda
%       coding started from March 5, 2005
%
%  To launch this software package, set the current directory coulomb33 and
%  then type 'coulomb' in the command window.
%

%   Copyright 2022 Shinji Toda (toda@irides.tohoku.ac.jp Internal Research 
%   Institute of Disaster Science, Tohoku University)
%   $Revision: 3.4 $  $Date: 2022/04/09$


% ===== Coulombがすでに起動しているか確認 =====================
% すでにCoulombが起動している場合は新たなインスタンスの起動を防ぐ
try
    get(H_MAIN,'HandleVisibility');
    msgbox('You already open Coulomb. Do not lauch another one.');
    return
catch

clear all;
% 全てのグローバル変数を初期化します。グローバル変数はすべて大文字で定義され、プログラム実行中に値を確認できます。

%===== グローバル変数の定義 ============================================
global H_MAIN   % メイングラフィックウィンドウのハンドル
global SCR_SIZE       % スクリーンサイズ制御関連のカテゴリのグローバル変数構造体
SCR_SIZE.SCRS = [];   % 現在のコンピュータの画面サイズ(1行, 4列(1, 1, max_horizontal_res_width, max_vertical_res_height))
SCR_SIZE.SCRW_X = []; % 画面の余白の幅
SCR_SIZE.SCRW_Y = []; % 画面の余白の幅と高さ

% ----- 入力ファイルから読み取る基本的な変数 -----
global INPUT_VARS % 入力ファイルから読み取る基本的な変数のカテゴリのグローバル変数構造体
INPUT_VARS.HEAD = [];       % ヘッダー（入力ファイルの説明書き，2行１列）
INPUT_VARS.NUM = [];        % 総断層数（integer、入力ファイルのデフォルト値は3）
INPUT_VARS.POIS = [];       % ポアソン比（入力ファイルのデフォルト値はPR1 = 0.25）
INPUT_VARS.CALC_DEPTH = []; % 計算深度
INPUT_VARS.YOUNG = [];      % ヤング率（入力ファイルのデフォルト値はE1 = 8.0 * e5）
INPUT_VARS.FRIC = [];       % 破壊摩擦係数（入力ファイルのデフォルト値はFRIC = 0.4）
INPUT_VARS.R_STRESS = [];   % 地域応力（テクトニックストレス，応力場設定，３行(σ1, σ2, σ3)、４列(方位, プランジ, 応力地の初期値, 応力地の深さ方向の勾配)）
INPUT_VARS.ID = [];         % 各入力エレメント（断層）の最初の列の値（通常は１）
INPUT_VARS.INUM = [];       % 断層の総数
INPUT_VARS.KODE = [];       % 計算のタイプを指定するコード（通常の計算では100）
INPUT_VARS.ELEMENT = [];    % 断層の位置情報（x行：入力ファイルの断層数x，９列(断層始点のX座標値, Y座標値, 断層終点のX座標値, Y座標値, 右横ずれ成分, 逆断層変位成分, 断層の傾斜, 断層の上端の深さ, 断層の下端の深さ)）
INPUT_VARS.FCOMMENT = [];   % 個々の断層への短いコメント（構造体として保存）
INPUT_VARS.GRID = [];       % 列ベクトル（6行, 入力ファイルの’Grid Parameters’をそのまま保存）
INPUT_VARS.SIZE = [];       % 列ベクトル（３行, 入力ファイルの’Size Parameters’をそのまま保存）
INPUT_VARS.SECTION = [];    % 列ベクトル（7行, 入力ファイルの’Cross section default’をそのまま保存）

% ----- 調査地域と座標制御用の変数 -----
global COORD_VARS % 調査地域と座標制御用の変数のカテゴリのグローバル変数構造体
COORD_VARS.ICOORD = [];   % 1: xy座標, 2: 経度緯度座標
COORD_VARS.XGRID = [];    % グリッドのx座標、X grid vector (1行，複数列、x の刻み)
COORD_VARS.YGRID = [];    % グリッドのy座標、Y grid vector (1行，複数列、y の刻み)
COORD_VARS.XY_RATIO = []; % 縦横比
COORD_VARS.MIN_LAT = [];  % 対象範囲の最小緯度
COORD_VARS.MAX_LAT = [];  % 対象範囲の最大緯度
COORD_VARS.ZERO_LAT = []; % 対象範囲の緯度の原点（リファレンス（0）となる緯度）
COORD_VARS.MIN_LON = [];  % 対象範囲の最小経度
COORD_VARS.MAX_LON = [];  % 対象範囲の最大経度
COORD_VARS.ZERO_LON = []; % 対象範囲の経度の原点（リファレンス（0）となる経度）
COORD_VARS.LON_GRID = []; % 経度のグリッド、Longitude grid vector (1行，複数列、x の刻み)
COORD_VARS.LAT_GRID = []; % 緯度のグリッド、Latitude grid vector (1行，複数列、y の刻み)

% ----- 計算制御に関する変数 ------
global CALC_CONTROL % 計算制御に関する変数のカテゴリのグローバル変数構造体
CALC_CONTROL.IACT = [];             % Okadaコードの計算が未実施（0）か実施済み（1）かを示す変数
CALC_CONTROL.FUNC_SWITCH = [];      % 計算のタイプ(1~11)
CALC_CONTROL.STRAIN_SWITCH = [];    % 歪みの切り替え(1:EXX, 2:EYY, 3:EZZ, 4:EYZ, 5:EXZ, 6:EXY, 7:Dilatation(EXX+EYY+EZZ), 8:Dilatation cross section)
CALC_CONTROL.SHADE_TYPE = [];       % 計算結果のシェーディングの種類(1:モザイク表示, 2:スムージング表示)
CALC_CONTROL.STRESS_TYPE = [];      % レシーバー断層の種類(1~5)
CALC_CONTROL.DEPTH_RANGE_TYPE = []; % 計算深度の種類(1:単一の深度, 2:幅のある深度)
CALC_CONTROL.STRIKE = [];
CALC_CONTROL.DIP = [];
CALC_CONTROL.RAKE = [];
CALC_CONTROL.IRAKE = [];
CALC_CONTROL.MAPTLFLAG = [];
CALC_CONTROL.RECEIVERS = [];
CALC_CONTROL.IND_RAKE = [];
CALC_CONTROL.IIRET = [];

% ----- メモリ内に保持される出力 -----
global MEMORY_OUTPUT
MEMORY_OUTPUT.DC3D = [];      % 岡田式の計算結果の出力 (N_CELL行, 14列)
MEMORY_OUTPUT.DC3DS = [];     % クロスセクション計算用にDC3Dの上書きを防ぐための複製物
MEMORY_OUTPUT.DC3DE = [];     % エラー計算用にDC3Dの上書きを防ぐための複製物
MEMORY_OUTPUT.S_ELEMENT = [];
MEMORY_OUTPUT.CC = [];

% ----- 断面図に関連する変数 -----
global SEC_VARS
SECTION_VARS.SEC_XS = [];
SECTION_VARS.SEC_YS = [];
SECTION_VARS.SEC_XF = [];
SECTION_VARS.SEC_YF = [];
SECTION_VARS.SEC_INCRE = [];
SECTION_VARS.SEC_DEPTH = [];
SECTION_VARS.SEC_DEPTHINC = [];
SECTION_VARS.SEC_FLAG = [];
SECTION_VARS.SEC_DIP = [];
SECTION_VARS.SEC_DOWNDIP_INC = [];

% ----- オーバーレイデータとオーバーレイ制御に関連する変数 -----
global OVERLAY_VARS % オーバーレイデータと制御に関連する変数のカテゴリのグローバル変数構造体
OVERLAY_VARS.COAST_DATA = [];
OVERLAY_VARS.AFAULT_DATA = [];
OVERLAY_VARS.EQ_DATA = [];
OVERLAY_VARS.GPS_DATA = [];
OVERLAY_VARS.GPS_FLAG = [];
OVERLAY_VARS.GPS_SEQN_FLAG  = [];
OVERLAY_VARS.VOLCANO = [];
OVERLAY_VARS.SEISSTATION = [];
OVERLAY_VARS.OVERLAYFLAG = [];
OVERLAY_VARS.OVERLAY_MARGIN = [];
OVERLAY_VARS.EQPICK_WIDTH = [];

% ----- グラフィック制御に関する変数 ------
global GRAPHICS_VARS % グラフィック制御に関する変数のカテゴリのグローバル変数構造体
GRAPHICS_VARS.ANATOLIA      % カラーコード（紫―白―赤，独自作成のもの）
GRAPHICS_VARS.SEIS_RATE     % カラーコード（青―白―赤，MATLABデフォルト）
GRAPHICS_VARS.C_SAT         % カラーの飽和値（±）
GRAPHICS_VARS.CONT_INTERVAL % 等値線の間隔

% ----- コンピュータID、ディレクトリ制御、設定 ------------------
global SYSTEM_VARS
SYSTEM_VARS.PLATFORM = [];        % コンピュータの種類
SYSTEM_VARS.CURRENT_VERSION = []; % 現行バージョン
SYSTEM_VARS.PREF_DIR = [];        % デフォルトの出力ディレクトリ
SYSTEM_VARS.HOME_DIR = [];        % ユーザのホームディレクトリ
SYSTEM_VARS.INPUT_FILE = [];      % 入力ファイルの名前
SYSTEM_VARS.PREF = [];            % Coulombのpreferences(初期設定),9行4列
SYSTEM_VARS.OUTFLAG = [];         % 0: ユーザフォルダへの出力、1: デフォルトフォルダへの出力
SYSTEM_VARS.C_SLIP_SAT = [];
SYSTEM_VARS.IVECTOR = [];
SYSTEM_VARS.IMAXSHEAR = [];


% 現行バージョンの設定
CURRENT_VERSION = '4.0.0';
% 全ての警告を無効化
warning ('off','all');

%===== ファイルパスの追加 ============================================
% ファイルセパレータと現在の作業ディレクトリを取得
f = filesep;
w = cd;

% 必要なパスを追加
addpath([w f 'sources'],[w f 'sources/eq_format_filter'],[w f 'input_files'],...
    [w f 'coastline_data'],[w f 'gps_data'],...
    [w f 'slides'],[w f 'okada_source_conversion'],[w f 'output_files'],...
    [w f 'resources'],[w f 'resources/ge_toolbox'],[w f 'active_fault_data'],...
    [w f 'earthquake_data'],...
    [w f 'license'],[w f 'utm'],[w f 'preferences2'],[w f 'plug_ins']);

% プラットフォーム依存の処理を行うためにコンピュータの種類を取得
PLATFORM = computer;
if ispc
    addpath([w f 'sources/figures_for_windows']);   % Windowsの場合、Windows専用のパスを追加
else
	addpath([w f 'sources/figures_for_mac']);       % macOSの場合、macOS専用のパスを追加
end

% ユーザのホームディレクトリをメモリに保持
HOME_DIR = pwd;


%====== MATLABのバージョンをチェック ==================================
% MATLABのバージョンを取得
matlabv = version;
% ユーザのホームディレクトリを保持
HOME_DIR = pwd;


%===== 初期化 ====================================================
% 初期化関数を呼び出し
coulomb_init2;

% 追加の初期化
IACT          = repmat(uint8(0),1,1);   % デフォルトでは計算しない
OVERLAYFLAG   = repmat(uint8(0),1,1);   % デフォルトではオーバーレイなし
STRAIN_SWITCH = repmat(uint8(0),1,1);	% デフォルトでsxxを設定
PREF_DIR      = [];                     % デフォルトの出力ディレクトリ
OUTFLAG       = 1;                      % デフォルト設定


%===== Coulomb起動時にカラーマップと地震率のデータをロード ======
load('MyColormaps','ANATOLIA');
load('SEIS_RATE','SEIS_RATE');

% load database/global_coastline_data.mat
% load database/afaultdata_ca_ja_sich.mat
% load database/plate_trench.mat
% load database/plate_ridge.mat
% load database/plate_transform.mat
% load database/volcanoes_NGDC_NOAA.mat
% load database/global_eqs.mat
% load database/border.mat


%===== スクリーンパラメータの取得 ======================================
SCRS = get(0,'ScreenSize');               %スクリーンサイズ [左,下,幅,高さ]
margin_ratio = 0.03;                      % 画面の余白比率
SCRW_X = int16(SCRS(1,3) * margin_ratio); % 余白の幅
SCRW_Y = int16(SCRS(1,4) * margin_ratio); % 余白の高さ

% Windowsの場合、高さを調整
if ispc
     SCRW_Y = SCRW_Y + 50;
end
 % スクリーンサイズが小さい場合、警告を表示
if SCRS(1,3) <= 1000
    warndlg('Sorry that this screen size may not be enough wide to present all results','!!Warning!!');
end


%===== ユーザーがMapping Toolboxを持っているか確認 ====================
% Toolboxがない場合の処理
if exist([matlabroot '/toolbox/map'],'dir')==0
    MAPTLFLAG = 0;
% Toolboxがある場合の処理
else
    MAPTLFLAG = 1;
end


%===== ウェルカムスクリーンの表示 =====================================
h = about_box_window2; % ウェルカムウィンドウを表示
pause(2);             % 2秒間待機
close(h);             % ウィンドウを閉じる


%===== 設定ファイルを開く ============================================
cd preferences2
fid = fopen('preferences2.dat','r');  
if isempty(fid)==1
    % デフォルトの値を作成して保存する
    PREF = [1.0 0.0 0.0 1.2;... % ソース断層
            0.0 0.0 0.0 1.0;... % 変位ベクトル
            0.7 0.7 0.0 0.2;... % グリッドライン
            0.0 0.0 0.0 1.2;... % 海岸線
            1.0 0.5 0.0 3.0;... % 地震プロット
            0.2 0.2 0.2 1.0;... % 活断層
            1.0 0.0 0.0 0.0;... % カラープリファレンス
            1.0 0.0 0.0 0.0;... % 座標プリファレンス
            0.9 0.9 0.1 1.0];   % 火山
else
    % 設定ファイルから値を読み込み
    fault_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    a = [fault_pref{:}];
    vector_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    b = [vector_pref{:}];
    grid_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    c = [grid_pref{:}];
    coast_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    d = [coast_pref{:}];
    eq_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    e = [eq_pref{:}];
    afault_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    f = [afault_pref{:}];
    color_pref  = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    g = [color_pref{:}];
    coord_pref  = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
    h = [coord_pref{:}];
    if size(PREF,1)==8
        i = [0.9 0.9 0.1 1.0];
    else
        volcano_pref = textscan(fid,'%3.1f32 %3.1f32 %3.1f32 %3.1f32',1);
        i = [volcano_pref{:}];
    end
    PREF = [a; b; c; d; e; f; g; h; i];
end

try
    % 追加のバイナリ設定をロード
    load('preferences2.mat');       
    if isempty(OUTFLAG) == 1
        OUTFLAG = 1;
    end
    if isempty(PREF_DIR) == 1
        PREF_DIR = HOME_DIR;
    end
    if isempty(INPUT_FILE) == 1
        INPUT_FILE = 'empty';
    end
catch
    % 設定が存在しない場合、新たに作成
    save preferences2.mat PREF_DIR INPUT_FILE OUTFLAG;
    if isempty(OUTFLAG) == 1
        OUTFLAG = 1;
    end
end 

cd ..

% ICOORDを設定: 1: xy座標, 2: 経度緯度座標
ICOORD = repmat(uint8(PREF(8,1)),1,1);

% 不要なローカル変数をクリア
clear a afault_pref b c coast_pref color_pref d e eq_pref f fault_pref volcano_pref
clear fid g grid_pref h h_grid margin_ratio vector_pref w


%===== コンソールにウェルカムメッセージを表示 ==============
disp('====================================================');
disp(['            Welcome to Coulomb ' CURRENT_VERSION]);
disp('====================================================');
disp('Start from Input menu to read or build an input file.');
disp('  ');


%===== メインウィンドウの表示 ========================================
H_MAIN = main_menu_window;
set(H_MAIN,'Toolbar','figure');                  % メインウィンドウにツールバーを設定
set(H_MAIN,'Name',['Coulomb ',CURRENT_VERSION]); % メインウィンドウの名前を設定
