function coulomb_init
% この関数は、Coulombプログラムが起動された際に、一部のグローバル変数を初期化し、
% いくつかの変数に初期値を設定します。

global HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global FCOMMENT GRID SIZE SECTION
global FIXX FIXY FIXFLAG
global SHADE_TYPE STRESS_TYPE
global SEC_FLAG
global S_ELEMENT
global DEPTH_RANGE_TYPE
global LON_GRID LAT_GRID
global FLAG_PR_AXES
global COAST_DATA AFAULT_DATA EQ_DATA GPS_DATA
global GPS_FLAG GPS_SEQN_FLAG
global IIRET IRAKE
global VIEW_AZ VIEW_EL
global OVERLAY_MARGIN
global IND_RAKE
global IMAXSHEAR

% 特異点を検出するためのフラグ (IIRET > 0の場合、特異点がある)
IIRET = 0;
% 入力ファイルフォーマットを明示するためのフラグ
IRAKE = 0;

% 入力ファイルからのパラメータ初期化
HEAD       = [];  % ヘッダー情報
NUM        = [];  % 数値データ
POIS       = [];  % ポアソン比
CALC_DEPTH = [];  % 計算深度
YOUNG      = [];  % ヤング率
FRIC       = [];  % 摩擦係数
R_STRESS   = [];  % 残留応力
ID         = [];  % ID情報
KODE       = [];  % コード情報
ELEMENT    = [];  % 要素データ
IND_RAKE   = [];  % 考慮されるすべりの方向
FCOMMENT   = struct('ref',[]);  % コメントを格納する構造体
GRID       = [];  % グリッド情報
SIZE       = [];  % サイズ情報
SECTION    = [];  % セクション情報
S_ELEMENT  = [];  % S要素データ

% 水平方向の変位計算のためのフラグ (0: 固定点なし, 1: 固定点あり)
FIXFLAG    = repmat(uint8(0),1,1);  % 初期化：固定点なし
% デフォルトの固定点を設定
FIXX       = 0;
FIXY       = 0;

% 応力タイプとシェーディングタイプの初期化
STRESS_TYPE = repmat(uint8(5),1,1);  % 応力タイプ
SHADE_TYPE  = repmat(uint8(1),1,1);  % シェーディングタイプ
SEC_FLAG    = repmat(uint8(0),1,1);  % セクションフラグ
LON_GRID    = [];  % 経度グリッド
LAT_GRID    = [];  % 緯度グリッド

% 最大剪断応力の計算をスキップするためのフラグ
IMAXSHEAR = 2; % 1: 検索, 2: スキップ

% オーバーレイ機能の初期化
COAST_DATA  = [];  % 海岸線データ
AFAULT_DATA = [];  % 活断層データ
EQ_DATA     = [];  % 地震データ
GPS_DATA    = [];  % GPSデータ
GPS_FLAG      = 'horizontal';  % GPSフラグ（初期値: 水平）
GPS_SEQN_FLAG = 'off';  % GPSシーケンスフラグ（初期値: オフ）

% 3Dビューの指定 (方位角と垂直の角度、度単位)
VIEW_AZ = 15;  % 方位角（初期値）
VIEW_EL = 40;  % 垂直角度（初期値）

% オーバーレイ機能のチェックアイテムをオフにする
set(findobj('Tag','menu_gridlines'),'Checked','off');
set(findobj('Tag','menu_coastlines'),'Checked','off');
set(findobj('Tag','menu_activefaults'),'Checked','off');
set(findobj('Tag','menu_earthquakes'),'Checked','off');

% 深度範囲タイプと軸表示フラグの初期化
DEPTH_RANGE_TYPE = repmat(uint8(0),1,1);
FLAG_PR_AXES = repmat(uint8(0),1,1);
OVERLAY_MARGIN = 5;  % オーバーレイのマージン（初期値）
