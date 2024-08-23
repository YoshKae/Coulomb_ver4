function [xn,yn,al,aw] = coord_conversion(xgg,ygg,xs,ys,xf,yf,top,bottom,dip)
% 座標変換を行う関数です。グローバル座標系から断層座標系への変換を行います。

% INPUT:
%   xgg, ygg - グローバル座標系のX, Y座標（行列形式）
%   xs, ys - 断層の開始点のX, Y座標（スカラー）
%   xf, yf - 断層の終了点のX, Y座標（スカラー）
%   top - 断層の上部深度（スカラー）
%   bottom - 断層の下部深度（スカラー）
%   dip - 断層の傾斜角（スカラー）

% OUTPUT:
%   xn, yn - 断層座標系でのX, Y座標（行列形式）
%   al - 断層の長さ（スカラー）
%   aw - 断層の幅（スカラー）


% 断層の中心位置を計算
cx = (xf + xs) / 2.0;  % X方向の中心座標
cy = (yf + ys) / 2.0;  % Y方向の中心座標

% 傾斜角に基づく傾斜距離を計算
k = tan(deg2rad(dip));  % 傾斜角のタンジェント値
if k == 0
    k = 0.000001;  % 0除算を避けるための微小値
end
d = h / k;  % 水平方向のシフト距離

% 断層の方位角を計算
b = atan((yf-ys)./(xf-xs));

% 傾斜によるシフト量を計算
ydipshift = abs(d * cos(b));  % Y方向のシフト量
xdipshift = abs(d * sin(b));  % X方向のシフト量

% 断層の中心位置をシフト
if (xf > xs)
    if (yf > ys)
        cx = cx + xdipshift;
        cy = cy - ydipshift;        
    else
        cx = cx - xdipshift;
        cy = cy - ydipshift;        
    end
else
    if (yf > ys)
        cx = cx + xdipshift;
        cy = cy + ydipshift;        
    else
        cx = cx - xdipshift;
        cy = cy + ydipshift;        
    end
end

% グローバル座標系からOkada断層座標系への変換
% xn, yn はOkada断層座標系でのX, Y座標
xn = (xgg-cx).*cos(b)+(ygg-cy).*sin(b);
yn =-(xgg-cx).*sin(b)+(ygg-cy).*cos(b);
if (xf-xs) < 0.0
    xn = -xn;
    yn = -yn;
end

% 断層の長さと幅を計算
al = sqrt((xf - xs) .* (xf - xs) + (yf - ys) .* (yf - ys)) / 2.0;  % 断層の長さ
aw = ((bottom - top) / 2.0) / (sin(deg2rad(dip)));  % 断層の幅
