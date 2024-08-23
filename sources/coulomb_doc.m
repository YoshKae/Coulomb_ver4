% これは、Coulomb解析を行うためのMATLABメモランダムです。
% グローバル変数の定義と、それぞれの説明を記述する部分です。


% スクリーンサイズに関する情報を格納するグローバル変数
global SCRS

% 入力ファイルから読み込むパラメータを格納するグローバル変数
global HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global GRID SIZE SECTION

% 結果としての剪断力や法線力を格納するためのグローバル変数
global SHEAR NORMAL

% 図のハンドルを格納するグローバル変数
global H_MAIN H_GRID H_SECTION

% 処理の進行状況を追跡するためのフラグを格納するグローバル変数
global IACT

% グローバル変数（主応力や補助計算に関する変数群）
global x y z cl sigs sign xmin xmax xinc nxinc ymin ymax yinc nyinc
global cmin cmax cmean cc
global SHADE_TYPE STRESS_TYPE SEC_FLAG
global AX AY AZ