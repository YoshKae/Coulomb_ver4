%-------------------------------------------------------------------------
%     モーメント計算関数
%-------------------------------------------------------------------------
function [mo,mw] = calc_seis_moment(x1,y1,x2,y2,right,reverse,dip,top,bot,poisson,young)
% この関数は、地震モーメント（Mo）とモーメントマグニチュード（Mw）を計算します。

% 断層の長さを計算
flength = sqrt((x1-x2)^2.+(y1-y2)^2.);

% 断層の幅を計算（断層面の深度差を、傾斜角sin(dip)で割って幅を求める）
fwidth  = (bot - top) / sin(deg2rad(dip));

% 断層の滑り量を計算（水平および垂直の滑り量の合成、ネットスリップ）
slip    = sqrt(right*right + reverse*reverse);

% 剛性率を計算（地盤の物理的特性を反映）
shearmod = young / (2.0 * (1.0 + poisson));

% 地震モーメント（Mo）の計算：Mo　＝　剛性率 * 断層長 * 断層幅 * スリップ量
mo = shearmod * flength * fwidth * slip * 1.0e+18;


% 地震モーメントからモーメントマグニチュード（Mw）を計算
% モーメントがゼロの場合、Mwもゼロとする
if mo == 0
    mw = 0.0;
else
    % モーメントマグニチュードの計算式：Mw = (2/3) * (log10(mo)-16.1);
    mw = (2/3) * log10(mo) - 10.7;
end