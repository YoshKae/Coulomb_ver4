function [ output_args ] = coulomb_in_3D(input_args)
% クーロン応力転移を3次元でプロットするための代替手法を提供する関数。
% 現在はスクリプトとして始めているが、最終的には関数に適応させる予定。
    
global ELEMENT
global GRID
global ANATOLIA
global COULOMB_RAKE
    
% ELEMENT変数から入力データを読み取る
xstart = ELEMENT(:,1);  % 開始X座標
ystart = ELEMENT(:,2);  % 開始Y座標
xend = ELEMENT(:,3);    % 終了X座標
yend = ELEMENT(:,4);    % 終了Y座標
dip = ELEMENT(:,7);     % 傾斜角
top = ELEMENT(:,8);     % 上部深度
bottom = ELEMENT(:,9);  % 下部深度
    
% 各要素についての処理
for j=1:size(ELEMENT,1)
    % セグメントのストライク（方位角）を計算
    if xstart(j)<=xend(j)
        el_strike(j)=90+atand((ystart(j)-yend(j))/(xend(j)-xstart(j)));
    elseif xstart(j)>xend(j)
            el_strike(j)=270+atand((ystart(j)-yend(j))/(xend(j)-xstart(j)));
    else
        disp('Error in strike calculations')
    end
    
    % ボックスの下部点を計算
    projdir = el_strike(j) + 90;
    if projdir > 360
        projdir = projdir - 360;
    end
    
    % 表面からの距離を計算
    del_surf = (bottom(j) - top(j)) / tand(dip(j));
    x(1,j) = xstart(j);
    x(2,j) = xend(j);
    y(1,j) = ystart(j);
    y(2,j) = yend(j);
    
    % 投影方向に応じてボックスの座標を計算
    if projdir < 90
        dx = del_surf * sind(projdir);
        dy = del_surf * cosd(projdir);
        x(4,j) = xstart(j) + dx;
        x(3,j) = xend(j) + dx;
        y(4,j) = ystart(j) + dy;
        y(3,j) = yend(j) + dy;
    elseif projdir < 180 & projdir >= 90
        dx = del_surf * sind(180 - projdir);
        dy = del_surf * cosd(180 - projdir);
        x(4,j) = xstart(j) + dx;
        x(3,j) = xend(j) + dx;
        y(4,j) = ystart(j) - dy;
        y(3,j) = yend(j) - dy;
    elseif projdir < 270 & projdir >= 180 
        dx = del_surf * sind(projdir - 180);
        dy = del_surf * cosd(projdir - 180);
        x(4,j) = xstart(j) - dx;
        x(3,j) = xend(j) - dx;
        y(4,j) = ystart(j) - dy;
        y(3,j) = yend(j) - dy;
    elseif projdir < 360 & projdir >= 270 
        dy = del_surf * sind(projdir - 270);
        dx = del_surf * cosd(projdir - 270);
        x(4,j) = xstart(j) - dx;
        x(3,j) = xend(j) - dx;
        y(4,j) = ystart(j) + dy;
        y(3,j) = yend(j) + dy;
    else
        disp('Error: box coordinates cannot be calculated')
    end
        
    % 深度情報の設定
    z(1,j) = -top(j);
    z(2,j) = -top(j);
    z(3,j) = -bottom(j);
    z(4,j) = -bottom(j);
end
    
% 3Dプロットの作成
figure
p = patch(x, y, z, COULOMB_RAKE);  % 3Dパッチの作成
set(gca, 'Color', [0.9 0.9 0.9], ...  % 軸の背景色の設定
        'PlotBoxAspectRatio', [1 1 1]);

view(3)                                 % 3Dビューの設定
colormap(ANATOLIA)                      % カラーマップの設定
cb = colorbar('southoutside');          % カラーバーの表示
title(cb, 'Transferred stress (bars)'); % カラーバーのタイトル設定
caxis([-0.1 0.1])                       % カラースケールの範囲設定
xlabel('UTM x')                         % X軸ラベル
ylabel('UTM y')                         % Y軸ラベル
zlabel('Depth (km)')                    % Z軸ラベル
axis equal                              % 軸のスケールを均等に設定
hold on

% グリッド線の描画
for i = GRID(1,1):GRID(5,1):GRID(3,1)
    line([i i], [GRID(2,1) GRID(4,1)], 'Color', [0.5 0.5 0.5])  % X軸のグリッド線
end
for i = GRID(2,1):GRID(6,1):GRID(4,1)
    line([GRID(1,1) GRID(3,1)], [i i], 'Color', [0.5 0.5 0.5])  % Y軸のグリッド線
end
