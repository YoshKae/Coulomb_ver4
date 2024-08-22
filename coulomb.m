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
    % Coulombが起動していない場合は続行
end

clear all;
% 全てのグローバル変数を初期化します。グローバル変数はすべて大文字で定義され、プログラム実行中に値を確認できます。
% 詳細については 'global_variable_explanatio.m' を参照してください。

%===== グローバル変数の定義 ============================================
global H_MAIN                           % メイングラフィックウィンドウのハンドル
global SCRS SCRW_X SCRW_Y               % スクリーンサイズ制御用の変数

% ----- 入力ファイルから読み取る基本的な変数 -----
global HEAD NUM POIS CALC_DEPTH YOUNG FRIC 
global R_STRESS ID INUM KODE ELEMENT
global FCOMMENT GRID SIZE SECTION

% ----- 調査地域と座標制御用の変数 -----
global ICOORD
global XGRID YGRID XY_RATIO
global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
global LON_GRID LAT_GRID

% ----- 計算制御に関する変数 ------
global IACT
global FUNC_SWITCH STRAIN_SWITCH
global SHADE_TYPE STRESS_TYPE DEPTH_RANGE_TYPE
global STRIKE DIP RAKE
global IRAKE
global MAPTLFLAG RECEIVERS
global IND_RAKE
global IIRET

% ----- メモリ内に保持される出力 -----
global DC3D DC3DS DC3DE S_ELEMENT CC

% ----- 断面図に関連する変数 -----
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_FLAG SEC_DIP SEC_DOWNDIP_INC

% ----- オーバーレイデータとオーバーレイ制御に関連する変数 -----
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global GPS_FLAG                                % 'horizontal' または 'vertical'
global GPS_SEQN_FLAG                           % 'on' で連続番号を表示
global VOLCANO SEISSTATION
global OVERLAYFLAG OVERLAY_MARGIN EQPICK_WIDTH

% ----- グラフィック制御に関する変数 ------
global ANATOLIA SEIS_RATE                      % カラーマップ用の変数（このファイルでロード）
global C_SAT CONT_INTERVAL

% ----- コンピュータID、ディレクトリ制御、設定 ------------------
global PLATFORM CURRENT_VERSION PREF_DIR HOME_DIR INPUT_FILE PREF 
global OUTFLAG                                 % 0: ユーザフォルダへの出力、1: デフォルトフォルダへの出力
global C_SLIP_SAT
global IVECTOR
global IMAXSHEAR

% 現行バージョンの設定
CURRENT_VERSION = '3.4.2';
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
    [w f 'license'],[w f 'utm'],[w f 'preferences'],[w f 'plug_ins']);

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
coulomb_init;

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
h = about_box_window; % ウェルカムウィンドウを表示
pause(2);             % 2秒間待機
close(h);             % ウィンドウを閉じる


%===== 設定ファイルを開く ============================================
cd preferences
fid = fopen('preferences.dat','r');  
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


%===== メインウィンドウの表示 ========================================
H_MAIN = main_menu_window;
set(H_MAIN,'Toolbar','figure');                  % メインウィンドウにツールバーを設定
set(H_MAIN,'Name',['Coulomb ',CURRENT_VERSION]); % メインウィンドウの名前を設定


%===== コンソールにウェルカムメッセージを表示 ==============
disp('====================================================');
disp(['            Welcome to Coulomb ' CURRENT_VERSION]);
disp('====================================================');
disp('Start from Input menu to read or build an input file.');
disp('  ');
