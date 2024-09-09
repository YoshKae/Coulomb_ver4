function grid_drawing_3d2
% 3Dプロット環境でグリッドや地理データ（海岸線、活断層、地震）を描画するための関数
% グリッドオプションのためのグリッドメッシュ描画関数
% この関数は、他のプロット関数の基本地図として頻繁に使用されます。
global H_MAIN A_GRID

global INPUT_VARS
global COORD_VARS
global CALC_CONTROL
global SYSTEM_VARS
global OVERLAY_VARS

xstart  = INPUT_VARS.GRID(1,1);
ystart  = INPUT_VARS.GRID(2,1);
xfinish = INPUT_VARS.GRID(3,1);
yfinish = INPUT_VARS.GRID(4,1);

% 次のコメント行は、緯度経度座標の3D回転問題が解決されたときにコメント解除する必要があります。
% 座標系が緯度経度（ICOORD == 2）の場合、座標変換
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    a  = xy2lonlat([INPUT_VARS.GRID(1,1) INPUT_VARS.GRID(2,1)]);
    xstart = a(1);
    ystart = a(2);
    a = xy2lonlat([INPUT_VARS.GRID(3,1) INPUT_VARS.GRID(4,1)]);
    xfinish = a(1);
    yfinish = a(2);
end

if COORD_VARS.ICOORD == 1
    COORD_VARS.XY_RATIO = 1;
end

% if FUNC_SWITCH ~= 1 プロットの初期設定
figure(H_MAIN);
set(H_MAIN,'Menubar','figure','Toolbar','figure');
set(gcf,'Renderer','painters')
hold off;
% グリッドを3Dで描画し、軸のラベルを設定
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
    [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
    set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],...
    'YLim',[ystart,yfinish]);
    h = get(gca,'Parent');
    hx = xlabel('Longitude (degree)');
    hy = ylabel('Latitude  (degree)');
else
    A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
    [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
    set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],...
    'YLim',[ystart,yfinish]);
    h = get(gca,'Parent');
    hx = xlabel('X (km)');
    hy = ylabel('Y (km)');
end
set(hx,'FontSize',[18]);
set(hy,'FontSize',[18]);

% グリッド線の描画
if SYSTEM_VARS.PREF(3,4)~=0.0 % GRIDの線幅が0.0の場合、以下のブロックをスキップします。
    for m = 1:length(COORD_VARS.XGRID)
        hold on;
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            a = xy2lonlat([COORD_VARS.XGRID(m) ystart]); % ystart is dummy
            gridln1 = plot3([a(1) a(1)],[ystart yfinish],[0.0 0.0]);
        else
            gridln1 = plot3([COORD_VARS.XGRID(m) COORD_VARS.XGRID(m)],[ystart yfinish],[0.0 0.0]);
        end
        if CALC_CONTROL.FUNC_SWITCH == 1 | CALC_CONTROL.FUNC_SWITCH == 10
            set(gridln1,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3));
        elseif CALC_CONTROL.FUNC_SWITCH == 2 | CALC_CONTROL.FUNC_SWITCH == 3
            set(gridln1,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3));
        else
            set(gridln1,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',[0.5 0.5 0.5]);
        end
        set(gridln1,'Tag','ylines');
    end

    for n = 1:length(COORD_VARS.YGRID)
        hold on;
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            a = xy2lonlat([xstart COORD_VARS.YGRID(n)]); % xstart is dummy
            gridln2 = plot3([xstart xfinish],[a(2) a(2)],[0.0 0.0]);
        else
            gridln2 = plot3([xstart xfinish],[COORD_VARS.YGRID(n) COORD_VARS.YGRID(n)],[0.0 0.0]);
        end
        if CALC_CONTROL.FUNC_SWITCH == 1 | CALC_CONTROL.FUNC_SWITCH == 10
            set(gridln2,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3));
        elseif CALC_CONTROL.FUNC_SWITCH == 2 | CALC_CONTROL.FUNC_SWITCH == 3
            set(gridln2,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',SYSTEM_VARS.PREF(3,1:3));
        else
            set(gridln2,'LineWidth',SYSTEM_VARS.PREF(3,4),'Color',[0.5 0.5 0.5]);
        end
        set(gridln2,'Tag','xlines');
    end
end

hold on;
% プロットにコンテキストメニューを追加し、メニュー項目を定義
cmenu = uicontextmenu;
if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
    A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
    [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
    set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],...
    'YLim',[ystart,yfinish],...
    'UIContextMenu', cmenu);
    h = get(gca,'Parent');
    hx = xlabel('Longitude (degree)');
    hy = ylabel('Latitude  (degree)');
else
    A_GRID = plot3([xstart xfinish xfinish xstart xstart],...
    [ystart ystart yfinish yfinish ystart],[0.0 0.0 0.0 0.0 0.0]);
    set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],...
    'YLim',[ystart,yfinish],...
    'UIContextMenu', cmenu);
    h = get(gca,'Parent');
    hx = xlabel('X (km)');
    hy = ylabel('Y (km)');
end
set(hx,'FontSize',[18]);
set(hy,'FontSize',[18]);
    
% コンテキストメニューの項目を定義
items1 = uimenu(cmenu, 'Label', 'change study area','Callback','change_study_area');
items2 = uimenu(cmenu, 'Label', 'change coordinates','Callback','change_coordinates');

%---------------------------------------------
%	Coast line plot in 3D 海岸線のプロット
%---------------------------------------------
h = findobj('Tag','menu_coastlines'); % タグがmenu_coastlinesであるオブジェクトを探します。
h1 = get(h,'Checked'); % そのオブジェクトのCheckedプロパティの値を取得し、h1に格納
if isempty(OVERLAY_VARS.COAST_DATA)~=1 && strcmp(h1,'on')
    [m,n] = size(OVERLAY_VARS.COAST_DATA);
    if n == 9 % 列数が9である場合は古いフォーマット
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            % 座標系が緯度経度（ICOORD == 2）の場合、COAST_DATAの列2と4を使ってx座標を、列3と5を使ってy座標を設定(rot90で配列を90度回転させながら)
            x1 = [rot90(OVERLAY_VARS.COAST_DATA(:,2));rot90(OVERLAY_VARS.COAST_DATA(:,4))];
            y1 = [rot90(OVERLAY_VARS.COAST_DATA(:,3));rot90(OVERLAY_VARS.COAST_DATA(:,5))];
        else
            % それ以外の場合、COAST_DATAの列6と8を使ってx座標を、列7と9を使ってy座標を設定
            x1 = [rot90(OVERLAY_VARS.COAST_DATA(:,6));rot90(OVERLAY_VARS.COAST_DATA(:,8))];
            y1 = [rot90(OVERLAY_VARS.COAST_DATA(:,7));rot90(OVERLAY_VARS.COAST_DATA(:,9))];
        end
    else % new format
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            x1 = OVERLAY_VARS.COAST_DATA(:,1);
            y1 = OVERLAY_VARS.COAST_DATA(:,2);
        else
            x1 = OVERLAY_VARS.COAST_DATA(:,3);
            y1 = OVERLAY_VARS.COAST_DATA(:,4);
        end
    end
	[mm,nn] = size(x1);
	z1 = zeros(mm,nn);
	hold on;    
    h = plot3(gca,x1,y1,z1,'Color',SYSTEM_VARS.PREF(4,1:3),'LineWidth',SYSTEM_VARS.PREF(4,4)); % 海岸線のプロット
    set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],... % データアスペクト比を設定
    'Color',[0.9 0.9 0.9],...                         % 背景色を設定
    'PlotBoxAspectRatio',[1 1 1],...                  % プロットボックスのアスペクト比を設定
    'XLim',[xstart,xfinish],'YLim',[ystart,yfinish]); % X軸とY軸の範囲を設定
    set(h,'Tag','CoastlineObj');                      % タグを付けて後で削除します
	hold on;
end

%---------------------------------------------
%	Active fault plot in 3D 活断層のプロット
%---------------------------------------------
h = findobj('Tag','menu_activefaults');
h1 = get(h,'Checked');
if isempty(OVERLAY_VARS.AFAULT_DATA)~=1 && strcmp(h1,'on')
    [m,n] = size(OVERLAY_VARS.AFAULT_DATA);
    if n == 9 % old format
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            x1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,2));rot90(OVERLAY_VARS.AFAULT_DATA(:,4))];
            y1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,3));rot90(OVERLAY_VARS.AFAULT_DATA(:,5))];
        else
            x1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,6));rot90(OVERLAY_VARS.AFAULT_DATA(:,8))];
            y1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,7));rot90(OVERLAY_VARS.AFAULT_DATA(:,9))];
        end
    else % new format
        if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
            x1 = OVERLAY_VARS.AFAULT_DATA(:,1);
            y1 = OVERLAY_VARS.AFAULT_DATA(:,2);
        else
            x1 = OVERLAY_VARS.AFAULT_DATA(:,3);
            y1 = OVERLAY_VARS.AFAULT_DATA(:,4);
        end
    end
	[mm,nn] = size(x1);
    z1 = zeros(mm,nn);
    hold on;
    h = plot3(gca,x1,y1,z1,'Color',SYSTEM_VARS.PREF(6,1:3),'LineWidth',SYSTEM_VARS.PREF(6,4));
    set(gca,'DataAspectRatio',[COORD_VARS.XY_RATIO 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xstart,xfinish],'YLim',[ystart,yfinish]);
    set(h,'Tag','AfaultObj');        % put a tag to remove them later 
    hold on;
end

%---------------------------------------------
%	Earthquake plot in 3D 地震のプロット
%---------------------------------------------
h = findobj('Tag','menu_earthquakes'); % タグがmenu_earthquakesであるオブジェクトを探します。
h1 = get(h,'Checked'); % そのオブジェクトのCheckedプロパティの値を取得し、h1に格納
if isempty(OVERLAY_VARS.EQ_DATA)~=1 && strcmp(h1,'on') % EQ_DATAが空でなく、h1が'on'である場合
    hold on;
    dummy1 = 0;
    if dummy1 == 1
        depLim = 20.0;
        b = OVERLAY_VARS.EQ_DATA(:,7)./depLim;
        c1 = b <= 1.0;   c2 = b > 1.0;
        b = b .* c1 + c2;
        c3 = b <= 0.5;  c4 = b > 0.5;
        g  = b.*c3*2.0 + abs(0.5-(b-0.5)).*c4*2.0;
        r = (1.0 - b);
    end
    
    if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % lon.lat.coordinates 経度緯度座標
        h = scatter3(OVERLAY_VARS.EQ_DATA(:,1),OVERLAY_VARS.EQ_DATA(:,2),-OVERLAY_VARS.EQ_DATA(:,7),5*SYSTEM_VARS.PREF(5,4));
    else
        if dummy1 == 1
            for k = 1:size(OVERLAY_VARS.EQ_DATA,1)
                hold on;
                h = scatter3(OVERLAY_VARS.EQ_DATA(k,16),OVERLAY_VARS.EQ_DATA(k,17),-OVERLAY_VARS.EQ_DATA(k,7),20.0,[r(k) g(k) b(k)]);
            end
        else
            h = scatter3(OVERLAY_VARS.EQ_DATA(:,16),OVERLAY_VARS.EQ_DATA(:,17),-OVERLAY_VARS.EQ_DATA(:,7),5*SYSTEM_VARS.PREF(5,4));
        end
    end
    set(h,'MarkerEdgeColor',SYSTEM_VARS.PREF(5,1:3)); % 地震のための白いエッジカラー
    set(h,'Tag','EqObj'); % 後で削除するためのタグを付ける
    hold on;
end
