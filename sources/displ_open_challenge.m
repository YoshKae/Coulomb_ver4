function displ_open(scl)
% 変位ベクトルを描画するための関数

global XGRID YGRID CALC_DEPTH
global SIZE KODE
global H_MAIN A_MAIN
global FUNC_SWITCH
global FIXX FIXY FIXFLAG
global DC3D CC
global PREF
global H_VERTICAL_DISPL COLORSN
global ELEMENT NUM
global COULOMB_RIGHT COULOMB_UP COULOMB_PREF COULOMB_RAKE EC_NORMAL
global EC_RAKE EC_STRESS_TYPE
global C_SAT
global ANATOLIA SEIS_RATE
global S_ELEMENT
global F3D_SLIP_TYPE ICOORD LON_GRID
global LON_PER_X LAT_PER_Y XY_RATIO
global OUTFLAG PREF_DIR HOME_DIR
global VIEW_AZ VIEW_EL IACT
global IRAKE IND_RAKE

% カラーの飽和値の初期設定
if isempty(C_SAT) == 1
    C_SAT = 5;  % デフォルトのカラー飽和値は5
end

% 特定の計算モードに応じて、変位データを読み込むか新規に作成する
if FUNC_SWITCH == 1 || FUNC_SWITCH == 10
    dummy = zeros(length(YGRID),length(XGRID));  % グリッドのサイズに応じたダミー行列を作成
else
    if OUTFLAG == 1 || isempty(OUTFLAG) == 1
        cd output_files;  % 出力ファイルディレクトリに移動
    else
        cd (PREF_DIR);  % プリファレンスディレクトリに移動
    end
    fid = fopen('Displacement.cou','r');  % 変位データを含むファイルを開く
    coul = textscan(fid,'%f %f %f %f %f %f','delimiter','\t','headerlines',3);  % ファイルの内容を読み込む
    fclose (fid);  % ファイルを閉じる

    cd (HOME_DIR);  % ホームディレクトリに戻る
    % データを行列に変換
    ux = [coul{4}];
    uy = [coul{5}];
    uz = [coul{6}];
    uux = reshape(ux,length(YGRID),length(XGRID));  % X方向の変位を再整形
    uuy = reshape(uy,length(YGRID),length(XGRID));  % Y方向の変位を再整形
    uuz = reshape(uz,length(YGRID),length(XGRID));  % Z方向の変位を再整形
    hold on;  % 現在の図を保持
end

%-----------    水平変位のマップビュー  ---------------------------
if FUNC_SWITCH == 2 || FUNC_SWITCH == 3
    grid_drawing;  % グリッド描画を行う
    set(H_MAIN,'NumberTitle','off','Menubar','figure');  % メインウィンドウの設定を変更

hold on;
% 入力ファイルとスライダーの値 (scl) を使用してサイズを調整
% uux, uuy, uuz は "m" 単位だが、現在は "km" 単位に変換されているため "/1000" を使用
resz = (SIZE(3,1)/1000)*scl;
if FIXFLAG == 0       % 固定点がない場合
    if FUNC_SWITCH == 2  % ベクトルプロットの場合
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
            b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
            a1 = quiver(a(:,1),b(:,2),uux*LON_PER_X*resz,uuy*LAT_PER_Y*resz,0);
        else
            a1 = quiver(XGRID,YGRID,uux*resz,uuy*resz,0);  % ベクトルプロットを描画
        end
        hold on;
    else  % FUNC_SWITCH == 3 (歪んだワイヤーフレーム)
        xds = zeros(length(YGRID),length(XGRID));
        yds = zeros(length(YGRID),length(XGRID));
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
            b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
            xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(b(:,2)),1);
            yds = repmat(reshape(b(:,2),length(b(:,2)),1),1,length(a(:,1)));   
        else
            xds = repmat(XGRID,length(YGRID),1);
            yds = repmat(reshape(YGRID,length(YGRID),1),1,length(XGRID));
        end
        for k = 1:length(XGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(:,k)+uux(:,k)*LON_PER_X*resz,yds(:,k)+uuy(:,k)*LAT_PER_Y*resz);
            else
                a1 = plot(xds(:,k)+uux(:,k)*resz,yds(:,k)+uuy(:,k)*resz);
            end
        end
        for k = 1:length(YGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(k,:)+uux(k,:)*LON_PER_X*resz,yds(k,:)+uuy(k,:)*LAT_PER_Y*resz);
            else
                a1 = plot(xds(k,:)+uux(k,:)*resz,yds(k,:)+uuy(k,:)*resz);
            end
        end
    end
else  % 固定点がある場合の変位の再計算
        [m n] = size(DC3D);
        dc3d_keep = zeros(m,n,'double');
        dc3d_keep = DC3D;
    Okada_halfspace_one;
    a = DC3D(:,1:2);    %xx, yy
    b = DC3D(:,5:8);    %zz, UX, UY, UZ
    c = horzcat(a,b);   %now 1x6 matrix
    DC3D = dc3d_keep;
    if FUNC_SWITCH == 2  % VECTOR PLOT
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
            b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
            a1 = quiver(a(:,1),b(:,2),(uux-c(:,4))*LON_PER_X*resz,(uuy-c(:,5))*LAT_PER_Y*resz,0);
        else
            a1 = quiver(XGRID,YGRID,(uux-c(:,4))*resz,(uuy-c(:,5))*resz,0);
        end
        hold on;
    else                % FUNC_SWITCH == 3 (distorted wireframe)
        xds = zeros(length(YGRID),length(XGRID));
        yds = zeros(length(YGRID),length(XGRID));
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a  = xy2lonlat([reshape(XGRID,length(XGRID),1) reshape(YGRID,length(YGRID),1)]);
                xds = repmat(reshape(a(:,1),1,length(a(:,1))),length(a(:,2)),1);
                yds = repmat(reshape(a(:,2),length(a(:,2)),1),1,length(a(:,1)));           
            else
                xds = repmat(XGRID,length(YGRID),1);
                yds = repmat(reshape(YGRID,length(YGRID),1),1,length(XGRID));
            end
        for k = 1:length(XGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(:,k) + (uux(:,k)-c(4))*LON_PER_X*resz,...
                    yds(:,k) + (uuy(:,k)-c(5))*LAT_PER_Y*resz);
            else
                a1 = plot(xds(:,k) + (uux(:,k)-c(4))*resz,...
                    yds(:,k) + (uuy(:,k)-c(5))*resz);
            end
            set(a1,'Color',PREF(2,1:3),'LineWidth',PREF(2,4));
        end
        for k = 1:length(YGRID)
            hold on;
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                a1 = plot(xds(k,:) + (uux(k,:)-c(4))*LON_PER_X*resz,...
                yds(k,:) + (uuy(k,:)-c(5))*LAT_PER_Y*resz);
            else
                a1 = plot(xds(k,:) + (uux(k,:)-c(4))*resz,...
                yds(k,:) + (uuy(k,:)-c(5))*resz);
            end
        end
    end
    plot(FIXX,FIXY,'ro');
    hold on;
end

if ICOORD == 2 && isempty(LON_GRID) ~= 1
	a = xy2lonlat([reshape(XGRID,length(XGRID),1) zeros(length(XGRID),1)]);
	b = xy2lonlat([zeros(length(YGRID),1) reshape(YGRID,length(YGRID),1)]);
    xinc = a(2,1)-a(1,1);
    yinc = b(2,2)-b(1,2);
    a0 = quiver((a(1,1)+xinc),(b(1,2)+yinc*1.5),1.0*LON_PER_X*resz,0.,0); %scale vector (1m)
    h = text((a(1,1)+2.0*xinc),(b(1,2)+yinc*3.0),'1m');
else
    xinc = XGRID(2)-XGRID(1);
    yinc = YGRID(2)-YGRID(1);
	a0 = quiver((XGRID(1)+xinc),(YGRID(1)+yinc*1.5),1.0*resz,0.,0); %scale vector (1m)
    h = text((XGRID(1)+2.0*xinc),(YGRID(1)+yinc*2.2),'1m');
end

set(a1,'Color',PREF(2,1:3),'LineWidth',PREF(2,4));
set(a0,'Color','r','LineWidth',1.2);
set(h,'FontName','Helvetica','Fontsize',18,'Color','r','FontWeight','bold');
hold on;
fault_overlay;
hold on;
A_MAIN = gca;

%-----------    Vertical displ. mapview  ---------------------------
elseif FUNC_SWITCH == 4
grid_drawing;

set(H_MAIN,'NumberTitle','off','Menubar','figure');
hold on;
a1 = 1; %dummy

CC = zeros(length(YGRID),length(XGRID),'double');
CC = reshape(uuz,length(YGRID),length(XGRID));
CC = CC(length(YGRID):-1:1,:);
buffer = 1.0;
cmax = max(reshape(max(abs(CC)),length(XGRID),1));
cmin = min(reshape(min(abs(CC)),length(XGRID),1));
cmean = mean(reshape(mean(abs(CC)),length(XGRID),1));
COLORSN = cmean;
coulomb_view(cmean);
hold on;
fault_overlay;
hold off;
H_VERTICAL_DISPL = vertical_displ_window;
set(findobj('Tag','vd_slider'),'Max',cmax);
set(findobj('Tag','vd_slider'),'Min',cmin);
set(findobj('Tag','vd_slider'),'Value',cmean);
set(findobj('Tag','edit_vd_color_sat'),'String',num2str(cmean,'%6.3f'));
set(findobj('Tag','pushbutton_vd_crosssection'),'Enable','off');

%-----------    3 dimensional displ. view  ---------------------------
elseif FUNC_SWITCH == 5 || FUNC_SWITCH == 1 ...
        || FUNC_SWITCH == 5.5 || FUNC_SWITCH == 5.7 ...
        || FUNC_SWITCH == 10
    
set(H_MAIN,'NumberTitle','off','Menubar','figure');
        switch PREF(7,1)
            case 1
                set(H_MAIN,'Colormap',jet);
            case 2
                set(H_MAIN,'Colormap',ANATOLIA);              
            case 3
                set(H_MAIN,'Colormap',Gray);                
        end
hold on;
resz = (SIZE(3,1)/1000)*scl;
if FUNC_SWITCH == 1 || FUNC_SWITCH == 10
    topz = 0.0;
elseif FUNC_SWITCH == 5.7
    set(H_MAIN,'Colormap',jet);
    topz = max(rot90(max(uuz*double(resz))));   %top depth
    [xm,ym] = meshgrid(XGRID,YGRID);
    zm = ones(length(YGRID),length(XGRID))*(-1.0)*CALC_DEPTH;
	hold on;
    mesh(XGRID,YGRID,zm); hidden off; hold on;
    quiver3(xm,ym,zm,uux*double(resz),uuy*double(resz),uuz*double(resz),0);
elseif FUNC_SWITCH == 5.5
    topz = max(rot90(max(uuz*double(resz))));   %top depth
    hold on;
    mesh(XGRID,YGRID,uuz*double(resz)-CALC_DEPTH); hidden off;
else
    topz = max(rot90(max(uuz*double(resz))));   %top depth
    hold on;
	surf(XGRID,YGRID,uuz*double(resz)-CALC_DEPTH);
end
    xlim([min(XGRID),max(XGRID)]);
	ylim([min(YGRID),max(YGRID)]);
	xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
    try

% for some reason it does not work so I cannot help using global variable.
        view(VIEW_AZ,VIEW_EL);
    catch

        view(15,40); % default veiw parameters (azimuth,elevation)
    end
hold on;
% ELEMENT
% Each fault element
%       ELEMENT(:,1) xstart (km)
%       ELEMENT(:,2) ystart (km)
%       ELEMENT(:,3) xfinish (km)
%       ELEMENT(:,4) yfinish (km)
%       ELEMENT(:,5) right-lat. slip (m)
%       ELEMENT(:,6) reverse slip (m)
%       ELEMENT(:,7) dip (degree)
%       ELEMENT(:,8) fault top depth (km)
%       ELEMENT(:,9) fault bottom depth (km)
    depth_max = 0.0;

if isempty(S_ELEMENT) == 1
    S_ELEMENT = zeros(NUM,10);
    S_ELEMENT = [ELEMENT double(KODE)];
    m = NUM;
else
    [m n] = size(S_ELEMENT);
end

%--- for coloring amount of fault slip for grid 3D
sl = zeros(m,1);
a1 = zeros(m,1);
c1 = int16(S_ELEMENT(:,10)) == 100;
c2 = int16(S_ELEMENT(:,10)) ~= 100;
    if F3D_SLIP_TYPE == 1
        a1 = sqrt(S_ELEMENT(:,5).^2.0 + S_ELEMENT(:,6).^2.0);
    elseif F3D_SLIP_TYPE == 2
        a1 = S_ELEMENT(:,5);
    else
        a1 = S_ELEMENT(:,6);
    end
   
sl = c1 .* a1 + c2 .* zeros(m,1);
slip_max = max(sl);
slip_min = min(sl);

%---

%============= k loop ================== (start)
for k = 1:m
    dist = sqrt((S_ELEMENT(k,3)-S_ELEMENT(k,1))^2+(S_ELEMENT(k,4)-S_ELEMENT(k,2))^2);
    hh = sin(deg2rad(S_ELEMENT(k,7)));
    if hh == 0.0
        hh = 0.000001;
    end
    ddip_length = (S_ELEMENT(k,9)-S_ELEMENT(k,8))/hh;
    middepth = (S_ELEMENT(k,9)+S_ELEMENT(k,8))/2.0;
	e = fault_corners(S_ELEMENT(k,1),S_ELEMENT(k,2),S_ELEMENT(k,3),S_ELEMENT(k,4),...
        S_ELEMENT(k,7),S_ELEMENT(k,8),middepth);
    xc = (e(3,1)+e(4,1))/2.0;
    yc = (e(3,2)+e(4,2))/2.0; 
    xcs = xc - ddip_length/2.0;
    xcf = xc + ddip_length/2.0;
    ycs = yc - dist/2.0;
    ycf = yc + dist/2.0;
% determin fill color
    if FUNC_SWITCH ~= 10
        c_index = zeros(64,3);
        switch PREF(7,1)
            case 1
            	c_index = colormap(jet);
            case 2
                if F3D_SLIP_TYPE == 1 & FUNC_SWITCH == 1
            	c_index = colormap(SEIS_RATE);
                else
            	c_index = colormap(ANATOLIA);
                end
            case 3
            	c_index = colormap(Gray);                  
        end

        if abs(slip_min) > abs(slip_max)
                    sb = abs(slip_min);
        else
                    sb = abs(slip_max);
        end
        if slip_max == 0.0 && slip_min == 0.0

            sb = 1.0;           % in case
        end
        
            c_unit = (sb + sb) / 64;
            if F3D_SLIP_TYPE == 1
                c_unit = sb / 64;
            	rgb = sqrt(S_ELEMENT(k,5)^2.0 + S_ELEMENT(k,6)^2.0) / c_unit;
            elseif F3D_SLIP_TYPE == 2
            	rgb = (S_ELEMENT(k,5) + sb) / c_unit;
            else
            	rgb = (S_ELEMENT(k,6) + sb) / c_unit;
            end
        ni = int8(round(rgb));
        if ni == 0
            ni = 1;    % in case
        elseif ni > 64
            ni = 64;    % in case
        elseif ni < 0
            ni = 64;    % in caseof other than Kode 100
        end
% FUNC_SWITCH
% F3D_SLIP_TYPE
% S_ELEMENT(k,5)
% S_ELEMENT(k,6)
% ni
            fcolor = c_index(ni,:);
    else
        c_index = zeros(64,3);
        switch PREF(7,1)
            case 1
            	c_index = colormap(jet);
            case 2
            	c_index = colormap(ANATOLIA);                
            case 3
            	c_index = colormap(Gray);                  
        end
        c_unit = C_SAT * 2.0 / 64;
        if isempty(EC_STRESS_TYPE)==1
            EC_STRESS_TYPE = 1;         % default
        end
        if EC_STRESS_TYPE == 1
            rgb = COULOMB_RIGHT(k) / C_SAT;
        elseif EC_STRESS_TYPE == 2
            rgb = COULOMB_UP(k) / C_SAT;
        elseif EC_STRESS_TYPE == 3
            rgb = COULOMB_PREF(k) / C_SAT;
        elseif EC_STRESS_TYPE == 4
            temp = isnan(COULOMB_RAKE(k));
            rgb = COULOMB_RAKE(k) / C_SAT;
            if temp == 1
                rgb = 0.0;
            end
        else
            rgb = EC_NORMAL(k) / C_SAT;
        end
        
        if rgb > 1.0
                    fcolor = c_index(64,:);
        elseif rgb <= -1.0
                    fcolor = c_index(1,:); 
        else
                    ni = int8(round((rgb*C_SAT + C_SAT) / c_unit))+1;
                    if ni > 64
                        ni = 64;    % in case
                    end
                    fcolor = c_index(ni,:);
        end
    end
    b  = fill([xcs xcf xcf xcs xcs],[ycf ycf ycs ycs ycf],fcolor);
	axis equal;
    if S_ELEMENT(k,9) > depth_max
        depth_max = S_ELEMENT(k,9);
    end
    zlim([-depth_max*2.0 topz+1]);
    denom = S_ELEMENT(k,3)-S_ELEMENT(k,1);
    if denom == 0
    a = atan((S_ELEMENT(k,4)-S_ELEMENT(k,2))/0.000001);        
    else
    a = atan((S_ELEMENT(k,4)-S_ELEMENT(k,2))/(S_ELEMENT(k,3)-S_ELEMENT(k,1)));
    end
    if S_ELEMENT(k,1) > S_ELEMENT(k,3)
        rstr = 1.5 * pi - a;
    else
        rstr = pi / 2.0 - a;
    end
	rdip = deg2rad(S_ELEMENT(k,7));
    t = hgtransform;
    set(b,'Parent',t);
    Rz = makehgtform('zrotate',double(pi-rstr));
    Rx = makehgtform('yrotate',double(-rdip));
    xshift = (xcf + xcs) / 2.0;
    yshift = (ycf + ycs) / 2.0;
    Rt  = makehgtform('translate',[xshift yshift -middepth]);
	Rt2  = makehgtform('translate',[-xshift -yshift 0]);
    set(t,'Matrix',Rt*Rz*Rx*Rt2);

%----- to plot arrows on the fault (rake arrow) ----------------------
    adj = 2.0;
    offset = 0.2;
    unit_arrow = sqrt((S_ELEMENT(k,3)-S_ELEMENT(k,1))^2.0...
        +(S_ELEMENT(k,4)-S_ELEMENT(k,2))^2.0) * 0.03;
    z0 = (S_ELEMENT(k,8)+S_ELEMENT(k,9))/2.0;
    fc = fault_corners(S_ELEMENT(k,1),S_ELEMENT(k,2),S_ELEMENT(k,3),S_ELEMENT(k,4),...
        S_ELEMENT(k,7),S_ELEMENT(k,8),z0);
    deno = fc(4,2) - fc(3,2);
    if deno == 0; deno = 0.0001; end
    x0 = (fc(4,1) + fc(3,1)) / 2.0;
    y0 = (fc(4,2) + fc(3,2)) / 2.0;
    str = rad2deg(atan((fc(4,1) - fc(3,1)) / deno));
    if deno < 0.0
    c = obj_trans(0,-S_ELEMENT(k,7),str,0,0,0,1,1,1);
    else
    c = obj_trans(0,S_ELEMENT(k,7),str,0,0,0,1,1,1);
    end
    c1 = c.';
% if rake is specified even without any slip (the case of IRAKE = 1)
    if isempty(EC_STRESS_TYPE) || EC_STRESS_TYPE == 4
        if IRAKE == 1
            [latslip dipslip] = rake2comp(IND_RAKE(k,1),unit_arrow);
        else
            [rake netslip] = comp2rake(S_ELEMENT(k,5),S_ELEMENT(k,6));
            [latslip dipslip] = rake2comp(rake,unit_arrow);
        end
    elseif EC_STRESS_TYPE == 1 % right-lat.
            [latslip dipslip] = rake2comp(180.0,unit_arrow);
    elseif EC_STRESS_TYPE == 2 % reverse slip
            [latslip dipslip] = rake2comp(90.0,unit_arrow);
    elseif EC_STRESS_TYPE == 3 % specified rake
            [latslip dipslip] = rake2comp(EC_RAKE,unit_arrow);
    end
        tf1 = c1 * [-dipslip; -latslip; 0];
        tf2 = c1 * [dipslip; latslip; 0];
    hold on;
	quiver3(x0+offset,y0+offset,-z0,tf1(1)*adj,tf1(2)*adj,tf1(3)*adj,2,...
         'Color','b','LineWidth',1.0); % plot an arrow on one side
    hold on;
	quiver3(x0-offset,y0-offset,-z0,tf2(1)*adj,tf2(2)*adj,tf2(3)*adj,2,...
         'Color','b','LineWidth',1.0); % plot an arrow on the other side  
     
%------ plot a circle in 'plot3d' for point source calculation -------------   
    if S_ELEMENT(k,10)==400 || S_ELEMENT(k,10)==500
        hold on;
        tm = [S_ELEMENT(k,1) S_ELEMENT(k,2) S_ELEMENT(k,3) S_ELEMENT(k,...
            4) S_ELEMENT(k,7) S_ELEMENT(k,8) S_ELEMENT(k,9)];
        fc = zeros(4,2); e_center = zeros(1,3);
        middle = (tm(6) + tm(7))/2.0;
        fc = fault_corners(tm(1),tm(2),tm(3),tm(4),tm(5),tm(6),middle);
        e_center(1,1) = (fc(4,1) + fc(3,1)) / 2.0;
        e_center(1,2) = (fc(4,2) + fc(3,2)) / 2.0;
        e_center(1,3) = -middle; 
        plot3(e_center(1,1),e_center(1,2),e_center(1,3),'ko');
    end
end
%============= k loop ================== (end)

%    ---- title and legend bar -------------------------
if FUNC_SWITCH == 5 || FUNC_SWITCH == 5.5
            	title('Vertical displacement (exaggerated depth)','FontSize',18);
                temp = C_SAT;
                dm = max(uuz*double(resz));
                a = isnan(dm);
                ind = find(a>0);
                dm(ind) = 0;
                C_SAT = max(rot90(dm)) * 0.3;
                %---in case (temporal solution, need to be fixed) !!!!
                if C_SAT < 0    % in case (temporal solution, need to be fixed) !!!!
                    C_SAT = abs(C_SAT);
                end
                %---------
                if isnan(C_SAT)==1
                    C_SAT = 1.0;
                end
                % C_SAT-CALC_DEPTH
                caxis([(-1.0)*C_SAT-CALC_DEPTH C_SAT-CALC_DEPTH]);
                colorbar('location','SouthOutside');
                C_SAT = temp;
elseif FUNC_SWITCH == 1
            if F3D_SLIP_TYPE == 1
            	title('Amount of net slip on each fault (m)','FontSize',18); 
                caxis([0.0 sb]);
            elseif F3D_SLIP_TYPE == 2
            	title('Amount of strike slip on each fault (m). Right lat. positive','FontSize',18); 
                caxis([-sb sb]);
            else
            	title('Amount of dip slip on each fault patch (m). Reverse. positive','FontSize',18); 
                caxis([-sb sb]);
            end
                colorbar('location','SouthOutside');
elseif FUNC_SWITCH == 10
        switch EC_STRESS_TYPE
            case 1
            	title('Coulomb stress change for right-lat. slip (bar)','FontSize',18);
            case 2
            	title('Coulomb stress change for reverse slip (bar)','FontSize',18);
            case 3
            	title(['Coulomb stress change for specified rake ' num2str(int16(EC_RAKE)) ' deg. (bar)'],'FontSize',18);
            case 4
            	title('Coulomb stress change for individual rake (bar)','FontSize',18);
            case 5
            	title('Normal stress change (bar, unclamping positive)','FontSize',14);
            otherwise
                title('Coulomb stress change (bar)','FontSize',18);
        end
        caxis([(-1.0)*C_SAT C_SAT]);
        colorbar('location','SouthOutside');
end
end
