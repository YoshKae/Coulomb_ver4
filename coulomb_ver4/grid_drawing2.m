function grid_drawing % グリッド描画
% グリッドオプションのためのグリッドメッシュ描画関数
% この関数は、他のプロット関数の基本地図として頻繁に使用されます。
% coded by Shinji Toda

global H_MAIN A_GRID
global INPUT_VARS
global COORD_VARS
global CALC_CONTROL
global SYSTEM_VARS

xstart = INPUT_VARS.GRID(1,1);
ystart = INPUT_VARS.GRID(2,1);
xfinish = INPUT_VARS.GRID(3,1);
yfinish = INPUT_VARS.GRID(4,1);
% COORD_VARS.ICOORDが2でCOORD_VARS.LON_GRIDが空でない場合
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    a  = xy2lonlat([INPUT_VARS.GRID(1,1) INPUT_VARS.GRID(2,1)]);
    xstart = a(1);
    ystart = a(2);
    a = xy2lonlat([INPUT_VARS.GRID(3,1) INPUT_VARS.GRID(4,1)]);
    xfinish = a(1);
    yfinish = a(2);
else
    COORD_VARS.XY_RATIO = 1;
end

figure(H_MAIN);                                    % 現在の図をアクティブにする
set(H_MAIN,'Menubar','figure','Toolbar','figure'); % メニューバーとツールバーを表示
set(H_MAIN,'Renderer','Painters');                 % レンダラをPaintersに設定
hold off;

A_GRID = plot([xstart xfinish xfinish xstart xstart],[ystart ystart yfinish yfinish ystart]); % グリッド描画
set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],... % データアスペクト比を設定
    'Color',[0.9 0.9 0.9],...                           % 背景色を設定
    'PlotBoxAspectRatio',[1 1 1],...                    % プロットボックスのアスペクト比を設定
    'XLim',[xstart,xfinish],...                         % X軸の範囲を設定
    'YLim',[ystart,yfinish]);                           % Y軸の範囲を設定
h = get(gca,'Parent');                                  % 親オブジェクトを取得
hx = xlabel('X (km)');                                  % X軸ラベルを設定
hy = ylabel('Y (km)');                                  % Y軸ラベルを設定
set(hx,'FontSize',[14]);                                % フォントサイズを設定
set(hy,'FontSize',[14]);                                % フォントサイズを設定 
 
if SYSTEM_VARS.PREF(3,4)~=0.0 % GRIDの線幅が0.0の場合、以下のブロックをスキップします。
    for m = 1:length(COORD_VARS.XGRID) % xgridの長さ(個数)分繰り返す
        hold on;
        % lat/lon座標 (COORD_VARS.ICOORD == 2) 
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            a = xy2lonlat([COORD_VARS.XGRID(m) ystart]); % COORD_VARS.XGRID(m)の値を緯度経度に変換 ystartはダミー値
            gridln1 = plot([a(1) a(1)],[ystart yfinish]); % 縦のグリッド線を描画
        else
            % x/y座標 (COORD_VARS.ICOORD == 1) 
            gridln1 = plot([COORD_VARS.XGRID(m) COORD_VARS.XGRID(m)],[ystart yfinish]);
        end
        if CALC_CONTROL.FUNC_SWITCH == 1 | CALC_CONTROL.FUNC_SWITCH == 11 % CALC_CONTROL.FUNC_SWITCHの値に応じて、グリッド線の幅（LineWidth）と色（Color）を設定
            set(gridln1,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3)); % 線幅と色を設定
        elseif CALC_CONTROL.FUNC_SWITCH == 2 | CALC_CONTROL.FUNC_SWITCH == 3
            set(gridln1,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3)); % 線幅と色を設定
        end
    end

    for n = 1:length(COORD_VARS.YGRID) % ygridの長さ(個数)分繰り返す
        hold on;
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2(緯度経度)でCOORD_VARS.LON_GRIDが空でない場合
            a = xy2lonlat([xstart COORD_VARS.YGRID(n)]);  % COORD_VARS.YGRID(n)の値を緯度経度に変換 xstartはダミー値
            gridln2 = plot([xstart xfinish],[a(2) a(2)]); % 横のグリッド線を描画
        else
            gridln2 = plot([xstart xfinish],[COORD_VARS.YGRID(n) COORD_VARS.YGRID(n)]); % xy座標のとき、横のグリッド線を描画
        end
        if CALC_CONTROL.FUNC_SWITCH == 1 | CALC_CONTROL.FUNC_SWITCH == 11 % CALC_CONTROL.FUNC_SWITCHの値に応じて、グリッド線の幅（LineWidth）と色（Color）を設定
            set(gridln2,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3));
        elseif CALC_CONTROL.FUNC_SWITCH == 2 | CALC_CONTROL.FUNC_SWITCH == 3
            set(gridln2,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3));
        end
    end
end

hold on;
% コンテキストメニューを定義
cmenu = uicontextmenu;
A_GRID = plot([xstart xfinish xfinish xstart xstart],... % グリッド描画
[ystart ystart yfinish yfinish ystart]);                 % グリッド描画
set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],...  % データアスペクト比を設定
    'Color',[0.9 0.9 0.9],...                            % 背景色を設定
    'PlotBoxAspectRatio',[1 1 1],...                     % プロットボックスのアスペクト比を設定
    'XLim',[xstart,xfinish],...                          % X軸の範囲を設定
    'YLim',[ystart,yfinish],'UIContextMenu', cmenu);     % Y軸の範囲を設定
h = get(gca,'Parent');                                   % 親オブジェクトを取得

if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2でCOORD_VARS.LON_GRIDが空でない場合
    hx = xlabel('Longitude (degree)'); % X軸ラベルを設定
    hy = ylabel('Latitude  (degree)'); % Y軸ラベルを設定
else
    hx = xlabel('X (km)'); % X軸ラベルを設定
    hy = ylabel('Y (km)'); % Y軸ラベルを設定
end
set(hx,'FontSize',[14]);
set(hy,'FontSize',[14]);

% メニューアイテムを追加
items1 = uimenu(cmenu, 'Label', 'change study area','Callback','change_study_area');
items2 = uimenu(cmenu, 'Label', 'change coordinates','Callback','change_coordinates');

%----------- data & file name stamp データとファイル名のスタンプを押す -----------
% プロットの余白にテキストを追加するための位置計算と、そのテキストを描画するための関数呼び出し
hold on;
% y方向の範囲とx方向の範囲の比率を計算し、1を超える場合は1に制限します
r = (yfinish-ystart)/(xfinish-xstart);
if r > 1
    r = 1;
end
x = xfinish + ((xfinish-xstart)/(10.0/r));
y = ystart - ((yfinish-ystart)/10.0) / r;
lsp = ((xfinish-xstart)+(yfinish-ystart))/75.0;
try
    record_stamp(H_MAIN,x,y,'SoftwareVersion',SYSTEM_VARS.CURRENT_VERSION,...
        'FunctionType',CALC_CONTROL.FUNC_SWITCH,'Depth',INPUT_VARS.CALC_DEPTH,'Friction',INPUT_VARS.FRIC,...
        'FileName',SYSTEM_VARS.INPUT_FILE,'LineSpace',lsp,...
        'FontSize',9);
catch
    record_stamp(H_MAIN,x,y,'SoftwareVersion',SYSTEM_VARS.CURRENT_VERSION,...
        'FunctionType',CALC_CONTROL.FUNC_SWITCH,'Depth',INPUT_VARS.CALC_DEPTH,...
        'FileName',SYSTEM_VARS.INPUT_FILE,'LineSpace',lsp,...
        'FontSize',9);
end

set(H_MAIN,'PaperPositionMode','auto');
hold off;
