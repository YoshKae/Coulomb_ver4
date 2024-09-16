function coulomb_init2
% この関数は、Coulombプログラムが起動された際に、一部のグローバル変数を初期化し、
% いくつかの変数に初期値を設定します。

global FIXX FIXY FIXFLAG
global FLAG_PR_AXES
global VIEW_AZ VIEW_EL

global INPUT_VARS
global COORD_VARS
global CALC_CONTROL
global OKADA_OUTPUT
global SECTION_VARS
global OVERLAY_VARS
global SYSTEM_VARS

% 特異点を検出するためのフラグ (IIRET > 0の場合、特異点がある)
CALC_CONTROL.IIRET = 0;
% 入力ファイルフォーマットを明示するためのフラグ
CALC_CONTROL.IRAKE = 0;

% 入力ファイルからのパラメータ初期化
INPUT_VARS.HEAD = [];       % ヘッダー情報
INPUT_VARS.NUM = [];        % 数値データ
INPUT_VARS.POIS = [];       % ポアソン比
INPUT_VARS.CALC_DEPTH = []; % 計算深度
INPUT_VARS.YOUNG = [];      % ヤング率
INPUT_VARS.FRIC = [];       % 摩擦係数
INPUT_VARS.R_STRESS = [];   % 残留応力
INPUT_VARS.ID = [];         % ID情報
INPUT_VARS.KODE = [];       % コード情報
INPUT_VARS.ELEMENT = [];    % 要素データ
INPUT_VARS.IND_RAKE = [];   % 考慮されるすべりの方向
INPUT_VARS.FCOMMENT = struct('ref',[]);  % コメントを格納する構造体
INPUT_VARS.GRID = [];       % グリッド情報
INPUT_VARS.SIZE = [];       % サイズ情報
INPUT_VARS.SECTION = [];    % セクション情報
OKADA_OUTPUT.S_ELEMENT = [];  % S要素データ

% 水平方向の変位計算のためのフラグ (0: 固定点なし, 1: 固定点あり)
FIXFLAG = repmat(uint8(0),1,1);  % 初期化：固定点なし
% デフォルトの固定点を設定
FIXX = 0;
FIXY = 0;

% 応力タイプとシェーディングタイプの初期化
CALC_CONTROL.STRESS_TYPE = repmat(uint8(5),1,1); % 応力タイプ
CALC_CONTROL.SHADE_TYPE = repmat(uint8(1),1,1);  % シェーディングタイプ
SECTION_VARS.SEC_FLAG = repmat(uint8(0),1,1);    % セクションフラグ
COORD_VARS.LON_GRID = [];                        % 経度グリッド
COORD_VARS.LAT_GRID = [];                        % 緯度グリッド

% 最大剪断応力の計算をスキップするためのフラグ
SYSTEM_VARS.IMAXSHEAR = 2; % 1: 検索, 2: スキップ

% オーバーレイ機能の初期化
OVERLAY_VARS.COAST_DATA  = [];  % 海岸線データ
OVERLAY_VARS.AFAULT_DATA = [];  % 活断層データ
OVERLAY_VARS.EQ_DATA     = [];  % 地震データ
OVERLAY_VARS.PS_DATA    = [];  % GPSデータ
OVERLAY_VARS.GPS_FLAG      = 'horizontal'; % GPSフラグ（初期値: 水平）
OVERLAY_VARS.GPS_SEQN_FLAG = 'off';        % GPSシーケンスフラグ（初期値: オフ）

% 3Dビューの指定 (方位角と垂直の角度、度単位)
VIEW_AZ = 15;  % 方位角（初期値）
VIEW_EL = 40;  % 垂直角度（初期値）

% オーバーレイ機能のチェックアイテムをオフにする
set(findobj('Tag','menu_gridlines'),'Checked','off');
set(findobj('Tag','menu_coastlines'),'Checked','off');
set(findobj('Tag','menu_activefaults'),'Checked','off');
set(findobj('Tag','menu_earthquakes'),'Checked','off');

% 深度範囲タイプと軸表示フラグの初期化
CALC_CONTROL.DEPTH_RANGE_TYPE = repmat(uint8(0),1,1);
OVERLAY_VARS.OVERLAY_MARGIN = 5;  % オーバーレイのマージン（初期値）
FLAG_PR_AXES = repmat(uint8(0),1,1);
