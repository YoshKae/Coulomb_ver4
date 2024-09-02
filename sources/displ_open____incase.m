function displ_open(scl)
% displ_open 関数は、変位ベクトルを描画するための関数です。
% scl: スケールファクタ。入力ファイルやスライダーで指定された値により変位のスケーリングを行います。

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
global F3D_SLIP_TYPE ICOORD LON_GRID LAT_GRID
global LON_PER_X LAT_PER_Y XY_RATIO MIN_LON MIN_LAT MAX_LON MAX_LAT
global OUTFLAG PREF_DIR HOME_DIR
global VIEW_AZ VIEW_EL IACT
global IRAKE IND_RAKE CONT_INTERVAL
global C_SLIP_SAT

% カラーサチュレーションのデフォルト値を設定
if isempty(C_SAT) == 1
    C_SAT = 5;      % デフォルトのカラーサチュレーション値は5バー
end

% FUNC_SWITCH に基づき動作を分岐
if FUNC_SWITCH == 1 || FUNC_SWITCH == 10
    % ダミー変数を生成（使われないが構造の整合性を保つため）
    dummy = zeros(length(YGRID), length(XGRID));
else
    % 出力ディレクトリの設定
    if OUTFLAG == 1 || isempty(OUTFLAG) == 1
        cd output_files; % デフォルト出力ディレクトリ
    else
        cd (PREF_DIR); % ユーザー指定のディレクトリ
    end

    % 変位データを読み込み
    fid = fopen('Displacement.cou','r');
    coul = textscan(fid, '%f %f %f %f %f %f', 'delimiter', '\t', 'headerlines', 3);
    fclose(fid);
    
    cd(HOME_DIR); % ホームディレクトリに戻る

    % セルから行列に変換
    ux = [coul{4}];
    uy = [coul{5}];
    uz = [coul{6}];    
    uux = reshape(ux,length(YGRID),length(XGRID));
    uuy = reshape(uy,length(YGRID),length(XGRID));
    uuz = reshape(uz,length(YGRID),length(XGRID));
    hold on;
end

%----------- 水平変位の描画 (FUNC_SWITCHが2または3の場合) ---------------------------
if FUNC_SWITCH == 2 || FUNC_SWITCH == 3
    grid_drawing; % グリッドを描画
    set(H_MAIN,'NumberTitle','off','Menubar','figure');
    hold on;

    % 入力ファイルの 「Exaggeration 」とスライダーの値(scl)を使ってリサイズ uux、uuy、uuzは 「m 」単位ですが、今は 「km 」に見えるため、「/1000 」を使用。

    % スケーリング（"Exaggeration"に基づいて変位を拡大）
    resz = double((SIZE(3,1)/1000) * scl);

    % 固定点がない場合の処理
    if FIXFLAG == 0
        if FUNC_SWITCH == 2  % ベクトルプロット
            if ICOORD == 2 && ~isempty(LON_GRID)
                a = xy2lonlat([reshape(XGRID, length(XGRID), 1) zeros(length(XGRID), 1)]);
                b = xy2lonlat([zeros(length(YGRID), 1) reshape(YGRID, length(YGRID), 1)]);
                a1 = quiver(a(:,1), b(:,2), uux * LON_PER_X * resz, uuy * LAT_PER_Y * resz, 0);
            else
                a1 = quiver(XGRID, YGRID, uux * resz, uuy * resz, 0);
            end
            hold on;

        else  % FUNC_SWITCH == 3 (歪んだワイヤーフレーム)
            xds = zeros(length(YGRID), length(XGRID));
            yds = zeros(length(YGRID), length(XGRID));
            if ICOORD == 2 && ~isempty(LON_GRID)
                a = xy2lonlat([reshape(XGRID, length(XGRID), 1) zeros(length(XGRID), 1)]);
                b = xy2lonlat([zeros(length(YGRID), 1) reshape(YGRID, length(YGRID), 1)]);
                xds = repmat(reshape(a(:,1), 1, length(a(:,1))), length(b(:,2)), 1);
                yds = repmat(reshape(b(:,2), length(b(:,2)), 1), 1, length(a(:,1)));
            else
                xds = repmat(XGRID, length(YGRID), 1);
                yds = repmat(reshape(YGRID, length(YGRID), 1), 1, length(XGRID));
            end

            % XGRIDの各列ごとにプロット
            for k = 1:length(XGRID)
                hold on;
                if ICOORD == 2 && ~isempty(LON_GRID)
                    a1 = plot(xds(:,k) + uux(:,k) * LON_PER_X * resz, yds(:,k) + uuy(:,k) * LAT_PER_Y * resz, 'Color', 'b');
                else
                    a1 = plot(xds(:,k) + uux(:,k) * resz, yds(:,k) + uuy(:,k) * resz, 'Color', 'b');
                end
            end

            % YGRIDの各行ごとにプロット
            for k = 1:length(YGRID)
                hold on;
                if ICOORD == 2 && ~isempty(LON_GRID)
                    a1 = plot(xds(k,:) + uux(k,:) * LON_PER_X * resz, yds(k,:) + uuy(k,:) * LAT_PER_Y * resz, 'Color', 'b');
                else
                    a1 = plot(xds(k,:) + uux(k,:) * resz, yds(k,:) + uuy(k,:) * resz, 'Color', 'b');
                end
            end
        end
    
    else  % 固定点がある場合の処理
        [m, n] = size(DC3D);
        dc3d_keep = zeros(m, n, 'double');
        dc3d_keep = DC3D;  % 現在の変位データを保持
        Okada_halfspace_one;  % Okadaモデルを適用して変位を計算
        a = DC3D(:,1:2);  % xx, yy
        b = DC3D(:,5:8);  % zz, UX, UY, UZ
        c = horzcat(a, b);  % xx, yy, zz, UX, UY, UZを結合
        DC3D = dc3d_keep;  % 変位データを元に戻す

        % ベクトルプロット（固定点を考慮）
        if FUNC_SWITCH == 2
            if ICOORD == 2 && ~isempty(LON_GRID)
                a = xy2lonlat([reshape(XGRID, length(XGRID), 1) zeros(length(XGRID), 1)]);
                b = xy2lonlat([zeros(length(YGRID), 1) reshape(YGRID, length(YGRID), 1)]);
                a1 = quiver(a(:,1), b(:,2), (uux - c(:,4)) * LON_PER_X * resz, (uuy - c(:,5)) * LAT_PER_Y * resz, 0);
            else
                a1 = quiver(XGRID, YGRID, (uux - c(:,4)) * resz, (uuy - c(:,5)) * resz, 0);
            end
            hold on;

        else  % 歪んだワイヤーフレーム（固定点を考慮）
            xds = zeros(length(YGRID), length(XGRID));
            yds = zeros(length(YGRID), length(XGRID));
            if ICOORD == 2 && ~isempty(LON_GRID)
                a  = xy2lonlat([reshape(XGRID, length(XGRID), 1) reshape(YGRID, length(YGRID), 1)]);
                xds = repmat(reshape(a(:,1), 1, length(a(:,1))), length(a(:,2)), 1);
                yds = repmat(reshape(a(:,2), length(a(:,2)), 1), 1, length(a(:,1)));
            else
                xds = repmat(XGRID, length(YGRID), 1);
                yds = repmat(reshape(YGRID, length(YGRID), 1), 1, length(XGRID));
            end

            % XGRIDの各列ごとにプロット
            for k = 1:length(XGRID)
                hold on;
                if ICOORD == 2 && ~isempty(LON_GRID)
                    a1 = plot(xds(:,k) + (uux(:,k) - c(4)) * LON_PER_X * resz, yds(:,k) + (uuy(:,k) - c(5)) * LAT_PER_Y * resz, 'Color', 'b');
                else
                    a1 = plot(xds(:,k) + (uux(:,k) - c(4)) * resz, yds(:,k) + (uuy(:,k) - c(5)) * resz, 'Color', 'b');
                end
            end

            % YGRIDの各行ごとにプロット
            for k = 1:length(YGRID)
                hold on;
                if ICOORD == 2 && ~isempty(LON_GRID)
                    a1 = plot(xds(k,:) + (uux(k,:) - c(4)) * LON_PER_X * resz, yds(k,:) + (uuy(k,:) - c(5)) * LAT_PER_Y * resz, 'Color', 'b');
                else
                    a1 = plot(xds(k,:) + (uux(k,:) - c(4)) * resz, yds(k,:) + (uuy(k,:) - c(5)) * resz, 'Color', 'b');
                end
            end
        end
        % 固定点のプロット
        plot(FIXX, FIXY, 'ro');
        hold on;
    end
     
    % 座標系の調整とベクトルのスケール表示
    if ICOORD == 2 && ~isempty(LON_GRID)
        a = xy2lonlat([reshape(XGRID, length(XGRID), 1) zeros(length(XGRID), 1)]);
        b = xy2lonlat([zeros(length(YGRID), 1) reshape(YGRID, length(YGRID), 1)]);
        xinc = a(2,1) - a(1,1);
        yinc = b(2,2) - b(1,2);
        [unit, unitText] = check_unit_vector(XGRID(1), XGRID(end), 1.0 * resz, 0.15, 0.4);
        a0 = quiver((a(1,1) + xinc), (b(1,2) + yinc * 1.5), unit * LON_PER_X * resz, 0., 0); % スケールベクトルをプロット
        h = text((a(1,1) + unit * LON_PER_X * resz * 0.5), (b(1,2) + yinc * 2.2), unitText);
    else
        xinc = XGRID(2) - XGRID(1);
        yinc = YGRID(2) - YGRID(1);
        [unit, unitText] = check_unit_vector(XGRID(1), XGRID(end), 1.0 * resz, 0.15, 0.4);
        a0 = quiver((XGRID(1) + xinc), (YGRID(1) + yinc * 1.5), unit * resz, 0., 0); % スケールベクトルをプロット
        h = text(XGRID(1) + unit * resz * 0.5, YGRID(1) + yinc * 2.2, unitText);
    end

    % ベクトルおよびテキストの設定
    set(a1, 'Color', PREF(2,1:3), 'LineWidth', PREF(2,4));
    set(a0, 'Color', 'r', 'LineWidth', 1.2);
    set(h, 'FontName', 'Helvetica', 'FontSize', 14, 'Color', 'r', 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    hold on;
    fault_overlay; % 断層オーバーレイを描画
    hold on;
    A_MAIN = gca;

%----------- 垂直変位の描画 (FUNC_SWITCHが4の場合) ---------------------------
elseif FUNC_SWITCH == 4
    grid_drawing;
    set(H_MAIN,'NumberTitle','off','Menubar','figure');
    hold on;
    a1 = 1; % ダミー変数
    CC = zeros(length(YGRID), length(XGRID), 'double');
    CC = reshape(uuz, length(YGRID), length(XGRID));
    CC = CC(length(YGRID):-1:1, :); % 行を反転させる
    buffer = 1.0;
    cmax = max(reshape(max(abs(CC)), length(XGRID), 1));
    cmin = min(reshape(min(abs(CC)), length(XGRID), 1));
    cmean = mean(reshape(mean(abs(CC)), length(XGRID), 1));

    COLORSN = cmean;
    coulomb_view(cmean);
    hold on;
    fault_overlay;
    hold off;
    a = cmax - cmin;

    % 等高線間隔の設定
    if a > 10.0
        CONT_INTERVAL = 1;
    elseif a > 5.0
        CONT_INTERVAL = 0.5;
    elseif a > 1.0
        CONT_INTERVAL = 0.1;
    else
        CONT_INTERVAL = 0.01;
    end

    H_VERTICAL_DISPL = vertical_displ_window;
    set(findobj('Tag','vd_slider'),'Max',cmax);
    set(findobj('Tag','vd_slider'),'Min',cmin);
    set(findobj('Tag','vd_slider'),'Value',cmean);
    set(findobj('Tag','edit_vd_color_sat'),'String',num2str(cmean,'%6.3f'));
    set(findobj('Tag','pushbutton_vd_crosssection'),'Enable','off');

%----------- 3D変位の描画 (FUNC_SWITCHが1, 5, 5.5, 5.7, 10の場合) ---------------------------
elseif FUNC_SWITCH == 5 || FUNC_SWITCH == 1 || FUNC_SWITCH == 5.5 || FUNC_SWITCH == 5.7 || FUNC_SWITCH == 10
	if ICOORD == 2 && isempty(LON_GRID) ~= 1
        nx = length(XGRID); ny = length(YGRID);
        ax = xy2lonlat([rot90(XGRID) ones(nx,1)*(YGRID(1)+YGRID(end))/2.]);
        ay = xy2lonlat([ones(ny,1)*(XGRID(1)+XGRID(end))/2. rot90(YGRID)]);
        xx = fliplr(rot90(ax(:,1)));
        yy = fliplr(rot90(ay(:,2)));
    else
        xx = XGRID;
        yy = YGRID;
    end

    set(H_MAIN,'NumberTitle','off','Menubar','figure');
    switch PREF(7,1)
        case 1
            set(H_MAIN, 'Colormap', jet);
        case 2
            set(H_MAIN, 'Colormap', ANATOLIA);
        case 3
            set(H_MAIN, 'Colormap', Gray);
    end

    hold on;
    resz = (SIZE(3,1)/1000) * scl;
    if FUNC_SWITCH == 1 || FUNC_SWITCH == 10
        topz = 0.0;
    elseif FUNC_SWITCH == 5.7
        set(H_MAIN, 'Colormap', jet);
        topz = max(rot90(max(uuz * double(resz))));  % 最上部の深さ
        [xm, ym] = meshgrid(xx, yy);
        zm = ones(length(yy), length(xx)) * (-1.0) * CALC_DEPTH;
        hold on;
        mesh(xx, yy, zm); hidden off; hold on;
        if ICOORD == 2 && ~isempty(LON_GRID)
            uux = (uux) * double(resz) * LON_PER_X;
            uuy = (uuy) * double(resz) * LAT_PER_Y;
            quiver3(xm, ym, zm, uux, uuy, uuz * double(resz), 0);
        else
            quiver3(xm, ym, zm, uux * double(resz), uuy * double(resz), uuz * double(resz), 0);
        end
    
    elseif FUNC_SWITCH == 5.5
        topz = max(rot90(max(uuz * double(resz))));  % 最上部の深さ
        hold on;
        mesh(xx, yy, uuz * double(resz) - CALC_DEPTH); hidden off;
    else
        topz = max(rot90(max(uuz * double(resz))));  % 最上部の深さ
        hold on;
        surf(xx, yy, uuz * double(resz) - CALC_DEPTH);
    end

    if ICOORD == 2 && ~isempty(LON_GRID)
        xlim([MIN_LON, MAX_LON]);
        ylim([MIN_LAT, MAX_LAT]);
        xlabel('Lon (deg)'); ylabel('Lat (deg)'); zlabel('Z (km)');
        xyz_aspect = [LON_PER_X LAT_PER_Y 1.0];
    else
        xlim([min(XGRID), max(XGRID)]);
        ylim([min(YGRID), max(YGRID)]);
        xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
        xyz_aspect = [XY_RATIO 1 1];
    end

    try
        % 3Dビューの設定
        view(VIEW_AZ, VIEW_EL);
    catch
        view(15, 40);  % デフォルトビュー（方位角、仰角）
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

    % 断層要素の設定
    depth_max = 0.0;
    if isempty(S_ELEMENT) == 1
        S_ELEMENT = zeros(NUM, 10);
        S_ELEMENT = [ELEMENT double(KODE)];
        m = NUM;
    else
        [m, n] = size(S_ELEMENT);
    end
    if ICOORD == 2 && ~isempty(LON_GRID)
        mm = size(S_ELEMENT, 1);
        temp_element = S_ELEMENT(:,1:4);
        a = xy2lonlat([S_ELEMENT(:,1) S_ELEMENT(:,2)]);
        b = xy2lonlat([S_ELEMENT(:,3) S_ELEMENT(:,4)]);
        S_ELEMENT(:,1) = a(:,1);
        S_ELEMENT(:,2) = a(:,2);
        S_ELEMENT(:,3) = b(:,1);
        S_ELEMENT(:,4) = b(:,2);
    end

%--- 断層スリップの量をグリッド3Dでカラー表示するための処理
    slip_max = 0.0;
    slip_min = 0.0;
    for k = 1:m
        if int16(S_ELEMENT(k,10))==100
            if F3D_SLIP_TYPE == 1
                sl = sqrt(S_ELEMENT(k,5)^2.0 + S_ELEMENT(k,6)^2.0);
            elseif F3D_SLIP_TYPE == 2
                sl = S_ELEMENT(k,5);
            else
                sl = S_ELEMENT(k,6);
            end
            if sl > slip_max
                slip_max = sl;
            end
            if sl < slip_min
                slip_min = sl;
            end
        else
            sl = 0.0;
        end
    end

%============= k loop ================== (start)
    for k = 1:m
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            dist = sqrt((temp_element(k,3)-temp_element(k,1))^2+(temp_element(k,4)...
                -temp_element(k,2))^2);
        else
            dist = sqrt((S_ELEMENT(k,3)-S_ELEMENT(k,1))^2+(S_ELEMENT(k,4)-S_ELEMENT(k,2))^2);
        end

        hh = sin(deg2rad(S_ELEMENT(k,7)));
        if hh == 0.0
            hh = 0.000001;
        end
        ddip_length = (S_ELEMENT(k,9)-S_ELEMENT(k,8))/hh;
        middepth = (S_ELEMENT(k,9)+S_ELEMENT(k,8))/2.0;
        
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            e = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
                temp_element(k,4),S_ELEMENT(k,7),S_ELEMENT(k,8),middepth);
            e1 = fault_corners(temp_element(k,1),temp_element(k,2),temp_element(k,3),...
                temp_element(k,4),S_ELEMENT(k,7),S_ELEMENT(k,8),S_ELEMENT(k,9));
        else
            e = fault_corners(S_ELEMENT(k,1),S_ELEMENT(k,2),S_ELEMENT(k,3),S_ELEMENT(k,4),...
                S_ELEMENT(k,7),S_ELEMENT(k,8),middepth);
        end
        xc = (e(3,1)+e(4,1))/2.0;
        yc = (e(3,2)+e(4,2))/2.0; 
        xcs = xc - ddip_length/2.0;
        xcf = xc + ddip_length/2.0;
        ycs = yc - dist/2.0;
        ycf = yc + dist/2.0;

        % 塗りつぶし色の決定
        if FUNC_SWITCH ~= 10
            c_index = zeros(64, 3);
            switch PREF(7,1)
                case 1
                    c_index = colormap(jet);
                case 2
                    if F3D_SLIP_TYPE == 1 && FUNC_SWITCH == 1
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
                sb = 1.0;  % in case
            end
            if isempty(C_SLIP_SAT)
                C_SLIP_SAT = sb;
            end
            c_unit = (C_SLIP_SAT + C_SLIP_SAT) / 64;


            if F3D_SLIP_TYPE == 1
                c_unit = C_SLIP_SAT / 64;
                rgb = sqrt(S_ELEMENT(k,5)^2.0 + S_ELEMENT(k,6)^2.0) / c_unit;
            elseif F3D_SLIP_TYPE == 2
                rgb = (S_ELEMENT(k,5) + C_SLIP_SAT) / c_unit;
            else
                rgb = (S_ELEMENT(k,6) + C_SLIP_SAT) / c_unit;
            end
            ni = int8(round(rgb));
            if ni == 0
                ni = 1;  % in case
            elseif ni > 64
                ni = 64;  % in case
            elseif ni < 0
                ni = 64;  % in case of other than Kode 100
            end
            fcolor = c_index(ni, :);
        else
            c_index = zeros(64, 3);
            switch PREF(7,1)
                case 1
                    c_index = colormap(jet);
                case 2
                    c_index = colormap(ANATOLIA);
                case 3
                    c_index = colormap(Gray);
            end
            
            c_unit = C_SAT * 2.0 / 64;
            if isempty(EC_STRESS_TYPE)
                EC_STRESS_TYPE = 1;  % default
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
                fcolor = c_index(64, :);
            elseif rgb <= -1.0
                fcolor = c_index(1, :);
            else
                ni = int8(round((rgb * C_SAT + C_SAT) / c_unit)) + 1;
                if ni > 64
                    ni = 64;  % in case
                end
                fcolor = c_index(ni, :);
            end
        end
    
        % 断層面の塗りつぶし
        if ICOORD == 2 && ~isempty(LON_GRID)
            % グローバル座標系を使用する場合
        else
            b = fill([xcs xcf xcf xcs xcs], [ycf ycf ycs ycs ycf], fcolor);
        end
    
        axis equal;
        if S_ELEMENT(k,9) > depth_max
            depth_max = S_ELEMENT(k,9);
        end
        zlim([-depth_max * 2.0 topz + 1]);
    
        % 座標変換および回転行列の設定
        if ICOORD == 2 && ~isempty(LON_GRID)
            denom = temp_element(k,3) - temp_element(k,1);
            numer = temp_element(k,4) - temp_element(k,2);
            if denom == 0
                a = atan((numer) / 0.000001);
            else
                a = atan((numer) / (denom));
            end
            if temp_element(k,1) > temp_element(k,3)
                rstr = 1.5 * pi - a;
            else
                rstr = pi / 2.0 - a;
            end
            rdip = deg2rad(S_ELEMENT(k,7));

        else
            denom = S_ELEMENT(k,3) - S_ELEMENT(k,1);
            if denom == 0
                a = atan((S_ELEMENT(k,4) - S_ELEMENT(k,2)) / 0.000001);
            else
                a = atan((S_ELEMENT(k,4) - S_ELEMENT(k,2)) / (S_ELEMENT(k,3) - S_ELEMENT(k,1)));
            end
            if S_ELEMENT(k,1) > S_ELEMENT(k,3)
                rstr = 1.5 * pi - a;
            else
                rstr = pi / 2.0 - a;
            end
            rdip = deg2rad(S_ELEMENT(k,7));
        end
    
        if ICOORD == 2 && ~isempty(LON_GRID)
            % グローバル座標系を使用する場合
        else
            t = hgtransform;
            set(b, 'Parent', t);
            Rsc = makehgtform('scale', [1, 1, 1]);
            Rsc2 = makehgtform('scale', [1, 1, 1]);
            xshift = (xcf + xcs) / 2.0;
            yshift = (ycf + ycs) / 2.0;
            Rz = makehgtform('zrotate', double(pi - rstr));
            Rx = makehgtform('yrotate', double(-rdip));
            Rt  = makehgtform('translate', [xshift yshift -middepth]);
            Rt2  = makehgtform('translate', [-xshift -yshift 0]);
            set(t, 'Matrix', Rt * Rsc * Rz * Rsc2 * Rx * Rt2);
        end
    
%----- 断層上に矢印（rake arrow）をプロット ----------------------
        adj = 2.0;
        offset = 0.2;
        if ICOORD == 2 && ~isempty(LON_GRID)
            unit_arrow = sqrt((temp_element(k,3) - temp_element(k,1))^2.0 ...
                + (temp_element(k,4) - temp_element(k,2))^2.0) * 0.03;
            z0 = (S_ELEMENT(k,8) + S_ELEMENT(k,9)) / 2.0;
            fc = fault_corners(temp_element(k,1), temp_element(k,2), temp_element(k,3), ...
                temp_element(k,4), S_ELEMENT(k,7), S_ELEMENT(k,8), z0);
        else
            unit_arrow = sqrt((S_ELEMENT(k,3) - S_ELEMENT(k,1))^2.0 ...
                + (S_ELEMENT(k,4) - S_ELEMENT(k,2))^2.0) * 0.03;
            z0 = (S_ELEMENT(k,8) + S_ELEMENT(k,9)) / 2.0;
            fc = fault_corners(S_ELEMENT(k,1), S_ELEMENT(k,2), S_ELEMENT(k,3), S_ELEMENT(k,4), ...
                S_ELEMENT(k,7), S_ELEMENT(k,8), z0);
        end
        deno = fc(4,2) - fc(3,2);
        if deno == 0; deno = 0.0001; end
        x0 = (fc(4,1) + fc(3,1)) / 2.0;
        y0 = (fc(4,2) + fc(3,2)) / 2.0;
        if ICOORD == 2 && ~isempty(LON_GRID)
            a = xy2lonlat([x0 y0]);
            x0 = a(1);
            y0 = a(2);
            offset = (LON_PER_X + LAT_PER_Y)/2.0 * offset;
            unit_arrow = (LON_PER_X + LAT_PER_Y)/2.0 * unit_arrow;
        end
        str = rad2deg(atan((fc(4,1) - fc(3,1)) / deno));
        if deno < 0.0
            c = obj_trans(0, -S_ELEMENT(k,7), str, 0, 0, 0, 1, 1, 1);
        else
            c = obj_trans(0, S_ELEMENT(k,7), str, 0, 0, 0, 1, 1, 1);
        end
        c1 = c.';

        if isempty(EC_STRESS_TYPE) || EC_STRESS_TYPE == 4 || EC_STRESS_TYPE == 5
            if IRAKE == 1
                [latslip dipslip] = rake2comp(IND_RAKE(k,1), unit_arrow);
            else
                [rake netslip] = comp2rake(S_ELEMENT(k,5), S_ELEMENT(k,6));
                [latslip dipslip] = rake2comp(rake, unit_arrow);
            end
        elseif EC_STRESS_TYPE == 1 % right-lat.
            [latslip dipslip] = rake2comp(180.0, unit_arrow);
        elseif EC_STRESS_TYPE == 2 % reverse slip
            [latslip dipslip] = rake2comp(90.0, unit_arrow);
        elseif EC_STRESS_TYPE == 3 % specified rake
            [latslip dipslip] = rake2comp(EC_RAKE, unit_arrow);
        end
        tf1 = c1 * [-dipslip; -latslip; 0];
        tf2 = c1 * [dipslip; latslip; 0];

        hold on;
        quiver3(x0 + offset, y0 + offset, -z0, tf1(1) * adj, tf1(2) * adj, tf1(3) * adj, 2, ...
             'Color', 'b', 'LineWidth', 1.0);  % 矢印を一方にプロット
        hold on;
        quiver3(x0 - offset, y0 - offset, -z0, tf2(1) * adj, tf2(2) * adj, tf2(3) * adj, 2, ...
             'Color', 'b', 'LineWidth', 1.0);  % 矢印をもう一方にプロット
     
%------ ポイントソース計算用の円をプロット -------------   
        if S_ELEMENT(k,10) == 400 || S_ELEMENT(k,10) == 500
            hold on;
            tm = [S_ELEMENT(k,1) S_ELEMENT(k,2) S_ELEMENT(k,3) S_ELEMENT(k,4) S_ELEMENT(k,7) S_ELEMENT(k,8) S_ELEMENT(k,9)];
            fc = zeros(4,2); e_center = zeros(1,3);
            middle = (tm(6) + tm(7)) / 2.0;
            fc = fault_corners(tm(1), tm(2), tm(3), tm(4), tm(5), tm(6), middle);
            e_center(1,1) = (fc(4,1) + fc(3,1)) / 2.0;
            e_center(1,2) = (fc(4,2) + fc(3,2)) / 2.0;
            e_center(1,3) = -middle;
            plot3(e_center(1,1), e_center(1,2), e_center(1,3), 'ko');
        end
    end
    % kループ終了
%============= k loop ================== (end)

%---- タイトルおよび凡例の設定 -------------------------
    if FUNC_SWITCH == 5 || FUNC_SWITCH == 5.5
        title('Vertical displacement (exaggerated depth)', 'FontSize', 18);
        temp = C_SAT;
        dm = max(uuz * double(resz));
        a = isnan(dm);
        ind = find(a > 0);
        dm(ind) = 0;
        C_SAT = max(rot90(dm)) * 0.3;
        if C_SAT < 0
            C_SAT = abs(C_SAT);
        end
        if isnan(C_SAT) == 1
            C_SAT = 1.0;
        end
        caxis([(-1.0) * C_SAT - CALC_DEPTH C_SAT - CALC_DEPTH]);
        colorbar('location', 'SouthOutside');
        C_SAT = temp;
        
    elseif FUNC_SWITCH == 1
        if F3D_SLIP_TYPE == 1
            title('Amount of net slip on each fault (m)', 'FontSize', 18);
            caxis([0.0 C_SLIP_SAT]);
        elseif F3D_SLIP_TYPE == 2
            title('Amount of strike slip on each fault (m). Right lat. positive', 'FontSize', 18);
            caxis([-C_SLIP_SAT C_SLIP_SAT]);
        else
            title('Amount of dip slip on each fault patch (m). Reverse. positive', 'FontSize', 18);
            caxis([-C_SLIP_SAT C_SLIP_SAT]);
        end
        colorbar('location', 'SouthOutside');

    elseif FUNC_SWITCH == 10
        switch EC_STRESS_TYPE
            case 1
                title('Coulomb stress change for right-lat. slip (bar)', 'FontSize', 18);
            case 2
                title('Coulomb stress change for reverse slip (bar)', 'FontSize', 18);
            case 3
                title(['Coulomb stress change for specified rake ' num2str(int16(EC_RAKE)) ' deg. (bar)'], 'FontSize', 18);
            case 4
                title('Coulomb stress change for individual rake (bar)', 'FontSize', 18);
            case 5
                title('Normal stress change (bar, unclamping positive)', 'FontSize', 18);
            otherwise
                title('Coulomb stress change (bar)', 'FontSize', 18);
        end
        caxis([(-1.0) * C_SAT C_SAT]);
        colorbar('location', 'SouthOutside');
    elseif FUNC_SWITCH == 5.7
        title('3D displacement vectors', 'FontSize', 18);
    end

    % X, Y 軸の制限を設定
    if ICOORD == 2 && ~isempty(LON_GRID)
        xlim([MIN_LON, MAX_LON]);
        ylim([MIN_LAT, MAX_LAT]);
    else
        xlim([min(XGRID), max(XGRID)]);
        ylim([min(YGRID), max(YGRID)]);
    end
    daspect(xyz_aspect);

    if ICOORD == 2 && ~isempty(LON_GRID)
        S_ELEMENT(:,1:4) = temp_element;
    end
end
