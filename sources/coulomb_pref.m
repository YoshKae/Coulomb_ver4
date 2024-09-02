% ユーザーの設定を読み込むためのスクリプト

global COUL_COLOR  % カラーマップを格納する変数
global mycmap  % カスタムカラーマップを格納する変数

% 'MyColormaps' というファイルからカスタムカラーマップを読み込む
load('MyColormaps', 'mycmap');  % 'mycmap' 変数にデータを読み込む

% COUL_COLOR に 'mycmap' を設定
COUL_COLOR = 'mycmap';  % カラーマップの設定をCOUL_COLORに適
