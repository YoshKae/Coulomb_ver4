% これは、他の関数やスクリプトで共有されるべき要素とグリッドの基本情報を計算するためのスクリプトです。
% このコードは、入力ファイルの読み込み（input_open）の後に配置する必要があります。
function calc_element()
    % calc_element: 要素のストライク角、傾斜角、すべり角、深度を計算し、
    % グリッドや座標に関するデータを計算・保持する関数

    % グローバル変数
    global ELE_STRIKE
    global AV_STRIKE AV_DIP AV_RAKE
    global AV_DEPTH
    global INPUT_VARS
    global COORD_VARS
    global CALC_CONTROL

    % 初期化
    ELE_STRIKE = [];
    AV_STRIKE = [];
    AV_DIP = [];
    AV_RAKE = [];

    % グリッドの位置を計算し、それらを他の関数で使用できるように保持する
    xstart = INPUT_VARS.GRID(1,1);
    ystart = INPUT_VARS.GRID(2,1);
    xfinish = INPUT_VARS.GRID(3,1);
    yfinish = INPUT_VARS.GRID(4,1);
    xinc = INPUT_VARS.GRID(5,1);
    yinc = INPUT_VARS.GRID(6,1);
    nxinc = int32((xfinish-xstart)/xinc + 1);
    nyinc = int32((yfinish-ystart)/yinc + 1);
    COORD_VARS.XGRID= double(xstart) + (double(1:nxinc)-1.0) * double(xinc);
    COORD_VARS.YGRID = double(ystart) + (double(1:nyinc)-1.0) * double(yinc);

    %===== 地図情報が存在する場合の処理
    if ~isempty(COORD_VARS.MIN_LON) && ~isempty(COORD_VARS.MAX_LON)
        if ~isempty(COORD_VARS.MIN_LAT) && ~isempty(COORD_VARS.MAX_LAT)
            if ~isempty(COORD_VARS.ZERO_LON) && ~isempty(COORD_VARS.ZERO_LAT)
                % 緯度経度のグリッド情報を計算
                xstart = double(COORD_VARS.MIN_LON);
                ystart = double(COORD_VARS.MIN_LAT);
                xfinish = double(COORD_VARS.MAX_LON);
                yfinish = double(COORD_VARS.MAX_LAT);
                xinc = (COORD_VARS.MAX_LON - COORD_VARS.MIN_LON) / double(nxinc-1);
                yinc = (COORD_VARS.MAX_LAT - COORD_VARS.MIN_LAT) / double(nyinc-1);
                COORD_VARS.LON_GRID = double(xstart) + (double(1:nxinc)-1.0) * double(xinc);
                COORD_VARS.LAT_GRID = double(ystart) + (double(1:nyinc)-1.0) * double(yinc);
            end
        end
    end
    %=====

    % 要素データが存在しない場合は処理を終了
    if isempty(INPUT_VARS.NUM)
        return;
    end

    % 各要素のストライク角（断層の走向角）を計算
    for n = 1:INPUT_VARS.NUM
        % ELEMENT: xs, ys, xf, yf, latslip, dipslip, dip, top, bottom
        xs = INPUT_VARS.ELEMENT(n,1);
        ys = INPUT_VARS.ELEMENT(n,2);
        xf = INPUT_VARS.ELEMENT(n,3);
        yf = INPUT_VARS.ELEMENT(n,4);
        % ストライク角を計算
        a = rad2deg(atan((yf-ys)/(xf-xs)));  
        if xs > xf
            ELE_STRIKE(n) = 270.0 - a;  % ストライク角を調整
        else
            ELE_STRIKE(n) = 90.0 - a;  % ストライク角を調整
        end
    end

    % 平均ストライク角、傾斜角、すべり角、深度を計算
    AV_STRIKE = sum(ELE_STRIKE) / double(INPUT_VARS.NUM);
    AV_DIP = sum(INPUT_VARS.ELEMENT(:,7)) / double(INPUT_VARS.NUM);
    av_lat_slip = sum(INPUT_VARS.ELEMENT(:,5)) / double(INPUT_VARS.NUM);
    av_dip_slip = sum(INPUT_VARS.ELEMENT(:,6)) / double(INPUT_VARS.NUM);
    AV_DEPTH = (sum(INPUT_VARS.ELEMENT(:,8)) + sum(INPUT_VARS.ELEMENT(:,9))) / (2 * double(INPUT_VARS.NUM));

    % 平均すべり角の計算（ゼロ除算を回避）
    if av_lat_slip == 0.0
        % ゼロ除算を避けるために小さい値を設定
        av_lat_slip = 0.000001;
    end

    b = rad2deg(atan(av_dip_slip / av_lat_slip));
    if av_lat_slip >= 0.0
        if av_dip_slip >= 0.0
            AV_RAKE = 180.0 - b;
        else
            AV_RAKE = -180.0 - b;
        end
    else
        AV_RAKE = -b;
    end

    % マップ座標のパラメータを取得するためのダミー計算
    if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
        % XY座標を緯度経度に変換
        a = xy2lonlat([INPUT_VARS.GRID(1,1), INPUT_VARS.GRID(2,1)]);
    end

    % IACTフラグを再計算モードに設定
    CALC_CONTROL.IACT = 0;
end
