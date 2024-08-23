% グローバル変数に設定された緯度と経度の情報が適切に定義されているかをチェックし、その結果を iflag というフラグで返します。

function iflag = check_lonlat_info
% check_lonlat_info - 緯度経度の情報が適切に設定されているかを確認する関数
% 出力：iflag = 1 （全ての情報が設定されている場合）
%      iflag = 0 （いずれかの情報が不足している場合）

global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON

% 最小緯度または最大緯度が設定されていない場合
if isempty(MIN_LAT)==1 | isempty(MAX_LAT)==1
   iflag = 0;
% 最小経度または最大経度が設定されていない場合
elseif isempty(MIN_LON)==1 | isempty(MAX_LON)==1
   iflag = 0;
% ゼロポイントの緯度または経度が設定されていない場合
elseif isempty(ZERO_LAT)==1 | isempty(ZERO_LON)==1
   iflag = 0;
% すべての緯度経度情報が適切に設定されている場合 
else
   iflag = 1;
end