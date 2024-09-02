%----------------------------------------------------
% dc3de_calc (内部関数)
%----------------------------------------------------
function [dc3de] = dc3de_calc(xx,yy)

global H_MAIN
global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID
global PREF
global ICOORD
global EQ_DATA
global NUM ELEMENT YOUNG POIS FRIC
global ANATOLIA
global N_CELL
global OUTFLAG PREF_DIR HOME_DIR
global INODAL H_NODAL NODAL_ACT NODAL_STRESS

% 入力のxx, yy座標のサイズを取得
[m,n] = size(xx);
N_CELL = m; % セルの数を設定

% 初期化
zz = zeros(m,1,'double'); % 地表面での計算のためzを0に設定
dc3de = zeros(m,14,'double'); % 出力結果を格納する行列を初期化
dc3de0 = zeros(m,14,'double'); % 一時的な結果を格納する行列を初期化
UX  = zeros(m,1,'double'); % x方向の変位
UY  = zeros(m,1,'double'); % y方向の変位
UZ  = zeros(m,1,'double'); % z方向の変位
UXX = zeros(m,1,'double'); % x方向の変位の微分
UYX = zeros(m,1,'double');
UZX = zeros(m,1,'double');
UXY = zeros(m,1,'double');
UYY = zeros(m,1,'double');
UZY = zeros(m,1,'double');
UXZ = zeros(m,1,'double');
UZZ = zeros(m,1,'double');
IRET = zeros(m,1); % 計算結果のリターンコード

% すべての要素（断層面）についてループ
for k = 1:NUM
    % 要素の深さを計算（正の値に設定）
    depth = (ELEMENT(k,8)+ELEMENT(k,9))/2.0;
    % 座標変換（地理座標系から局所座標系への変換）
    [c1,c2,c3,c4] = coord_conversion(xx,yy,ELEMENT(k,1),ELEMENT(k,2),ELEMENT(k,3),ELEMENT(k,4),ELEMENT(k,8),ELEMENT(k,9),ELEMENT(k,7));
    alpha  =  1.0/(2.0*(1.0-POIS)); % ポアソン比に基づく係数
    z  = double(zz) * (-1.0); % 深さを負の値に変換
    aa = zeros(m,1,'double') + double(alpha); % ポアソン比の係数配列
    zc = zeros(m,1,'double') + double(z); % z座標
    dp = zeros(m,1,'double') + double(depth); % 深さ
    e7 = zeros(m,1,'double') + double(ELEMENT(k,7)); % 要素の7番目のパラメータ
    e5 = zeros(m,1,'double') - double(ELEMENT(k,5)); % 左横ずれ正の符号（Okadaのコードに合わせる）
    e6 = zeros(m,1,'double') + double(ELEMENT(k,6)); % 要素の6番目のパラメータ
    zr = zeros(m,1,'double'); % 初期化
    x  = zeros(m,1,'double') + double(c1); % x座標
    y  = zeros(m,1,'double') + double(c2); % y座標
    al = zeros(m,1,'double') + double(c3); % 局所座標系での回転角
    aw = zeros(m,1,'double') + double(c4); % 局所座標系での回転角
    % Okadaの計算に使用するパラメータ配列
    a = [aa x y zc dp e7 al al aw aw e5 e6 zr];

    % Okadaのモデルに基づいて変位場を計算
    [UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
        UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
        a(:,4),a(:,5),a(:,6),...
        a(:,7),a(:,8),a(:,9),...
        a(:,10),a(:,11),a(:,12),a(:,13));

    % 配列aの2, 3, 4列目の値をX, Y, Zに格納
    X = a(:,2);
    Y = a(:,3);
    Z = a(:,4);
    
    %-- Okadaの座標系から与えられた座標系への変位の変換 -------------
    sw = sqrt((ELEMENT(k,4)-ELEMENT(k,2))^2+(ELEMENT(k,3)-ELEMENT(k,1))^2); % 長さの計算
    sina = (ELEMENT(k,4)-ELEMENT(k,2))/double(sw); % 正弦値
    cosa = (ELEMENT(k,3)-ELEMENT(k,1))/double(sw); % 余弦値
    UXG = UX*cosa-UY*sina; % x方向の変位を変換
    UYG = UX*sina+UY*cosa; % y方向の変位を変換
    UZG = UZ; % z方向の変位はそのまま

    % C-- 正規応力成分に対するひずみから応力への変換 -----------------------------
    sk = YOUNG/(1.0+POIS); % 弾性係数に基づく係数
    gk = POIS/(1.0-2.0*POIS); % ポアソン比に基づく係数
    vol = UXX + UYY + UZZ; % 体積ひずみの計算
    % 注意！ひずみの次元はx, y, z座標系に依存（1000で割る必要あり）
    sxx = sk * (gk * vol + UXX) * 0.001;
    syy = sk * (gk * vol + UYY) * 0.001;
    szz = sk * (gk * vol + UZZ) * 0.001;
    sxy = (YOUNG/(2.0*(1.0+POIS))) * (UXY + UYX) * 0.001;
    sxz = (YOUNG/(2.0*(1.0+POIS))) * (UXZ + UZX) * 0.001;
    syz = (YOUNG/(2.0*(1.0+POIS))) * (UYZ + UZY) * 0.001;

    % ひずみテンソルをストレステンソルに変換
    ssxx = reshape(sxx,1,m);
    ssyy = reshape(syy,1,m);
    sszz = reshape(szz,1,m);
    ssxy = reshape(sxy,1,m);
    ssxz = reshape(sxz,1,m);
    ssyz = reshape(syz,1,m);    
    s0 = [ssxx; ssyy; sszz; ssyz; ssxz; ssxy];

%-- Okadaの座標系から与えられた座標系へのひずみテンソルの変換 -------------
    s1 = tensor_trans(sina,cosa,s0,m);
    SXX = reshape(s1(1,:),m,1);
    SYY = reshape(s1(2,:),m,1);
    SZZ = reshape(s1(3,:),m,1);
    SYZ = reshape(s1(4,:),m,1);
    SXZ = reshape(s1(5,:),m,1);
    SXY = reshape(s1(6,:),m,1);

    % kが1のとき、dc3deに初期の結果を格納
    if k == 1
        dc3de = horzcat(xx,yy,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
    else
        % kが2以上のとき、初期化したdc3de0に結果を格納し、dc3deに加算
        dc3de0 = horzcat(zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),zeros(m,1),UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
        dc3de = dc3de + dc3de0;
    end
end
