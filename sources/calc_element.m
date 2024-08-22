% これは、他の関数やスクリプトで共有されるべき要素とグリッドの基本情報を計算するためのスクリプトです。
% このコードは、入力ファイルの読み込み（input_open）の後に配置する必要があります。

global ELE_STRIKE
global AV_STRIKE AV_DIP AV_RAKE
global AV_DEPTH
global GRID XGRID YGRID
global ELEMENT
global NUM
global MIN_LAT MAX_LAT MIN_LON MAX_LON ZERO_LON ZERO_LAT
global LON_GRID LAT_GRID ICOORD
global IACT % =0: 再計算  =1: 現在のDC3D値を使用

% 初期化
ELE_STRIKE = [];
AV_STRIKE = [];
AV_DIP = [];
AV_RAKE = [];

% グリッドの位置を計算し、それらを他の関数で使用できるように保持する
xstart = GRID(1,1);
ystart = GRID(2,1);
xfinish = GRID(3,1);
yfinish = GRID(4,1);
xinc = GRID(5,1);
yinc = GRID(6,1);
nxinc = int32((xfinish-xstart)/xinc + 1);
nyinc = int32((yfinish-ystart)/yinc + 1);
xpp = [1:1:nxinc];
ypp = [1:1:nyinc];
XGRID = double(xstart) + (double(1:1:nxinc)-1.0) * double(xinc);
YGRID = double(ystart) + (double(1:1:nyinc)-1.0) * double(yinc);

%===== 地図情報が存在する場合の処理
if isempty(MIN_LON) ~= 1 && isempty(MAX_LON) ~= 1
    if isempty(MIN_LAT) ~= 1 && isempty(MAX_LAT) ~= 1
        if isempty(ZERO_LON) ~= 1 && isempty(ZERO_LAT) ~= 1
            % 緯度経度のグリッド情報を計算
            xstart = double(MIN_LON);
            ystart = double(MIN_LAT);
            xfinish = double(MAX_LON);
            yfinish = double(MAX_LAT);
            xinc = double(MAX_LON - MIN_LON) / double(nxinc-1);
            yinc = double(MAX_LAT - MIN_LAT) / double(nyinc-1);
            LON_GRID = double(xstart) + (double(1:1:nxinc)-1.0) * double(xinc);
            LAT_GRID = double(ystart) + (double(1:1:nyinc)-1.0) * double(yinc);
        end
    end
end
%=====

% 要素データが存在しない場合は処理を終了
if isempty(NUM); return; end

% 各要素のストライク角（断層の走向角）を計算
for n = 1:NUM
    % ELEMENT: xs, ys, xf, yf, latslip, dipslip, dip, top, bottom
    xs = ELEMENT(n,1);
    ys = ELEMENT(n,2);
    xf = ELEMENT(n,3);
    yf = ELEMENT(n,4);
    %
    a = rad2deg(atan((yf-ys)/(xf-xs)));  % ストライク角を計算
    if xs > xf
        ELE_STRIKE(n) = 270.0 - a;  % ストライク角を調整
    else
        ELE_STRIKE(n) = 90.0 - a;  % ストライク角を調整
    end
end

% 平均ストライク角、傾斜角、すべり角、深度を計算
AV_STRIKE = sum(ELE_STRIKE)/double(NUM);
AV_DIP = sum(ELEMENT(:,7))/double(NUM);
av_lat_slip = sum(ELEMENT(:,5))/double(NUM);
av_dip_slip = sum(ELEMENT(:,6))/double(NUM);
AV_DEPTH = (sum(ELEMENT(:,8))+sum(ELEMENT(:,9)))/(2*double(NUM));

% latslip = -15;
% dipslip = 7;
% 平均すべり角の計算（ゼロ除算を回避）
if av_lat_slip == 0.0
    % ゼロ除算を避けるために小さい値を設定
    av_lat_slip = 0.000001;
end

b = rad2deg(atan(av_dip_slip/av_lat_slip));
if av_lat_slip >= 0.0
    if av_dip_slip >= 0.0
        AV_RAKE = 180.0 - b;
    else
        AV_RAKE = -180.0 - b;
    end
else
    if av_dip_slip >= 0.0
        AV_RAKE = -b;
    else
        AV_RAKE = -b;     
    end
end

% マップ座標のパラメータを取得するためのダミー計算
% LON_GRID

if ICOORD == 2 && isempty(LON_GRID) ~= 1
    % XY座標を緯度経度に変換
    a  = xy2lonlat([GRID(1,1) GRID(2,1)]);
end

% IACTフラグを再計算モードに設定
IACT = 0;
