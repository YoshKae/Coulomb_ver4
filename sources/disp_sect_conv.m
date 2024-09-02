function [uu] = disp_sect_conv(x0,y0,x1,y1,uux,uuy)
% disp_sect_conv 関数は、与えられた水平単位変位 (uux, uuy) を
% 特定の断面平面上に投影し、その結果を uu として返します。
% **** 注意 **** すべてのパラメータはスカラーである必要があります。

% 入力パラメータ:
%   x0, y0 : 始点の座標
%   x1, y1 : 終点の座標
%   uux, uuy : 水平単位変位
% x0 = 0;
% y0 = 0;
% x1 = 40;
% y1 = -40;
% uux = -0.7;
% uuy = 1.0;

% y1がy0と同じ場合に対処（ゼロ除算を避けるためにy1をわずかに調整）
if y1 == y0
    y1 = y1 + 0.0001;
end

% 断面のストライク角を計算
strk = rad2deg(atan((x1 - x0) / (y1 - y0)));
% 水平変位のストライク角を計算
u_strk = rad2deg(atan(uux / uuy));
% 水平変位の大きさを計算
uxy = sqrt(uux * uux + uuy * uuy);

% 始点と終点の位置関係に応じて角度を計算
if x1 > x0
    if y1 > y0          % X+ & Y+ の場合
        if uux > 0
            if uuy > 0
                ang = abs(u_strk - strk); % 変位角と断面角の差の絶対値を計算
            else
                ang = abs(u_strk+180. - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        end        
    else                % X+ & Y- の場合
        if uux < 0
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        end  
    end
else
    if y1 > y0          % X- & Y+ の場合

       if uux > 0
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        end     
    else                % X- & Y- の場合
        if uux > 0
            if uuy > 0
                ang = abs(u_strk+180. - strk);
            else
                ang = abs(u_strk - strk);
            end
        else
            if uuy > 0
                ang = abs(u_strk - strk);
            else
                ang = abs(u_strk+180. - strk);
            end
        end  
        
    end
end

% 断面平面上に投影された変位の大きさを計算
uu = cos(deg2rad(ang)) * uxy;

% 水平単位変位のx成分が負の場合、符号を反転
if uux < 0.0
    uu = -uu;
end
