function [shear,normal,coulomb] = calc_coulomb(strike_m,dip_m,rake_m,friction_m,ss)
% 指定された断層のストライク、ディップ、レーキ角に基づいて、せん断応力、法線応力、およびクーロン応力を計算する関数
% この関数は、断層の幾何学的な特性に基づいて応力状態を計算するために使用されます。

% INPUT: 
%   strike_m  - ストライク角の行列（断層の進行方向と北の間の角度）
%   dip_m     - ディップ角の行列（断層面の傾斜角）
%   rake_m    - レーキ角の行列（断層面上の移動方向と水平方向の角度）
%   friction_m- 摩擦係数の行列
%   ss        - 応力テンソルの行列（SXX, SYY, SZZ, SXY, SXZ, SYZ）

% OUTPUT:
%   shear     - せん断応力のベクトル
%   normal    - 法線応力のベクトル
%   coulomb   - クーロン応力のベクトル

% "_m" が付いている変数は行列を示します。このため、条件式ではスカラー値のみ使用できます。
% 以下では、行列内の全ての要素が同じ値であるため、行列をスカラー値に変換します。

% 行列のサイズ（行数）を取得
n = size(strike_m,1);

% 初期化 - 行列をゼロベクトルで初期化
strike = zeros(n,1);
dip    = zeros(n,1);
rake   = zeros(n,1);
% 摩擦係数の行列をスカラーに変換
friction = friction_m(1,1);

% 我々の座標系に合わせるための調整（Aki & Richardsのコンベンションからの変換）
c1 = strike_m >= 180.0; c2 = strike_m < 180.0;      % ストライク角に対する条件
strike = (strike_m - 180.0) .* c1 + strike_m .* c2; % ストライク角の変換
dip    = (-1.0) * dip_m .* c1 + dip_m .* c2;        % ディップ角の変換
rake_m   = rake_m - 90.0;                           % レーキ角の変換
c1 = rake_m <= -180.0; c2 = rake_m > -180.0;        % レーキ角に対する条件
rake = (360.0 + rake_m) .* c1 + rake_m .* c2;       % レーキ角の変換

% CAUTION.....................................
% ストライク、ディップ、レーキ角をラジアンに変換
strike = deg2rad(strike);
dip = deg2rad(dip);
rake = deg2rad(rake);

% レーキ角の回転行列の生成（Zhang ZQによって修正）
for i=1:n
    rsc = -rake(i,1);                % レーキ角の符号を反転
    rr = makehgtform('xrotate',rsc); % レーキ角の回転行列を生成
    mtran(1:3,1:3,i) = rr(1:3,1:3);  % 回転行列を格納
end

% スカラー値を再び行列（n x 1）として取り扱う
% レーキ角の行列を作成
rakem = zeros(n,1) + rake;

% せん断応力、法線応力、およびテンソルの初期化
sn  = zeros(6,length(strike));   % 応力ベクトルの初期化
sn9 = zeros(3,3,length(strike)); % 9成分の応力テンソルの初期化

% ベクトルおよびテンソルの初期化と座標変換
ver = pi/2.0;

c1 = strike>=0.0;  c2 = strike<0.0; c3 = strike<=ver; c4 = strike>ver;
c24 = c2 + c4; cc24 = c24 > 0;
d1 = dip>=0.0; d2 = dip<0.0;
xbeta = (-1.0)*strike .* d1 + (pi - strike) .* d2;
ybeta = (pi-strike).*d1 + (-1.0)*strike.*d2;
zbeta = (ver-strike).*d1 + ((-1.0)*ver-strike).*d2.*c1.*c3 + (pi+ver-strike).*d2.*cc24;
xdel = ver - abs(dip);
ydel = abs(dip);
zdel = 0.0;

% 再びスカラー値を行列（n x 1）に変換
xbetam = zeros(n,1) + xbeta;
ybetam = zeros(n,1) + ybeta;
zbetam = zeros(n,1) + zbeta;
xdelm  = zeros(n,1) + xdel;
ydelm  = zeros(n,1) + ydel;
zdelm  = zeros(n,1) + zdel;

% ベクトルの成分を計算
xl = cos(xdelm) .* cos(xbetam);
xm = cos(xdelm) .* sin(xbetam);
xn = sin(xdelm);
yl = cos(ydelm) .* cos(ybetam);
ym = cos(ydelm) .* sin(ybetam);
yn = sin(ydelm);
zl = cos(zdelm) .* cos(zbetam);
zm = cos(zdelm) .* sin(zbetam);
zn = sin(zdelm);

% 応力テンソルの計算
t(1,1,:) = xl .* xl;
t(1,2,:) = xm .* xm;
t(1,3,:) = xn .* xn;
t(1,4,:) = 2.0 * xm .* xn;
t(1,5,:) = 2.0 * xn .* xl;
t(1,6,:) = 2.0 * xl .* xm;
t(2,1,:) = yl .* yl;
t(2,2,:) = ym .* ym;
t(2,3,:) = yn .* yn;
t(2,4,:) = 2.0 * ym .* yn;
t(2,5,:) = 2.0 * yn .* yl;
t(2,6,:) = 2.0 * yl .* ym;
t(3,1,:) = zl .* zl;
t(3,2,:) = zm .* zm;
t(3,3,:) = zn .* zn;
t(3,4,:) = 2.0 * zm .* zn;
t(3,5,:) = 2.0 * zn .* zl;
t(3,6,:) = 2.0 * zl .* zm;
t(4,1,:) = yl .* zl;
t(4,2,:) = ym .* zm;
t(4,3,:) = yn .* zn;
t(4,4,:) = ym .* zn + zm .* yn;
t(4,5,:) = yn .* zl + zn .* yl;
t(4,6,:) = yl .* zm + zl .* ym;
t(5,1,:) = zl .* xl;
t(5,2,:) = zm .* xm;
t(5,3,:) = zn .* xn;
t(5,4,:) = xm .* zn + zm .* xn;
t(5,5,:) = xn .* zl + zn .* xl;
t(5,6,:) = xl .* zm + zl .* xm;
t(6,1,:) = xl .* yl;
t(6,2,:) = xm .* ym;
t(6,3,:) = xn .* yn;
t(6,4,:) = xm .* yn + ym .* xn;
t(6,5,:) = xn .* yl + yn .* xl;
t(6,6,:) = xl .* ym + yl .* xm;

% せん断応力、法線応力、およびテンソルの成分を計算し、テンソルの回転を適用
for k = 1:n
    sn(:,k) = t(:,:,k) * ss(:,k); % 応力ベクトルの計算
    sn9(1,1,k) = sn(1,k);         % 応力テンソルの成分に値を格納
    sn9(1,2,k) = sn(6,k);
    sn9(1,3,k) = sn(5,k);
    sn9(2,1,k) = sn(6,k);
    sn9(2,2,k) = sn(2,k);
    sn9(2,3,k) = sn(4,k);
    sn9(3,1,k) = sn(5,k);
    sn9(3,2,k) = sn(4,k);
    sn9(3,3,k) = sn(3,k);
    sn9(:,:,k) = sn9(:,:,k) * mtran(:,:,k); % テンソルの回転を適用
end

% せん断応力、法線応力、クーロン応力を計算
shear   = reshape(sn9(1,2,:),n,1);    % せん断応力を計算し、ベクトルに変換
normal  = reshape(sn9(1,1,:),n,1);    % 法線応力を計算し、ベクトルに変換
coulomb = shear + friction .* normal; % クーロン応力を計算
