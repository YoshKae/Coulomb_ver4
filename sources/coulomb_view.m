function coulomb_view(N)
    % この関数は、メインウィンドウにクーロン応力変化（または他の計算結果）を表示するためのものです。
    % 入力: N（カラーバーの飽和値の範囲を指定する値）
    
    % グローバル変数の定義
    global H_MAIN
    global XGRID YGRID FRIC CALC_DEPTH DEPTH_RANGE_TYPE CALC_DEPTH_RANGE
    global CC
    global ICOORD
    global SHADE_TYPE STRESS_TYPE STRIKE DIP RAKE
    global PREF
    global FUNC_SWITCH STRAIN_SWITCH
    global ANATOLIA
    global VD_CHECKED
    global C_SAT
    global LON_PER_X LAT_PER_Y XY_RATIO
    global LON_GRID LAT_GRID
    global INPUT_FILE CURRENT_VERSION
    global CONT_INTERVAL
    
    % メインウィンドウをアクティブにして描画設定を行う
    figure(H_MAIN)
    set(H_MAIN,'Menubar','figure','Toolbar','figure');
    hold off;
    
    % NがNaN（Not a Number）の場合、エラーメッセージを表示して処理を終了する
    if isnan(N) == 1
        h = errordlg('A calculation point hits a singular point. Shift the grid slightly.','!!Warning!!');
        return;
    end
    
    % 機能が "strain function" の場合は N を10のN乗に変換する
    if FUNC_SWITCH == 6     
        N = power(10,N);
    else
        N = abs(N);
    end
    C_SAT = N;
    
    % ICOORD が1の場合、XY比を1に設定
    if ICOORD == 1
        XY_RATIO = 1;
    end
    
    % メインウィンドウのカラーマップをANATOLIAに設定
    set(H_MAIN,'Colormap',ANATOLIA);
    
    % SHADE_TYPEが2の場合、細かいグリッドを作成し、補間を行う
    if SHADE_TYPE == 2
        n_interp = 10.0;    % グリッドの細かさを設定
        nxg = length(XGRID); xgmin = min(XGRID); xgmax = max(XGRID);
        nyg = length(YGRID); ygmin = min(YGRID); ygmax = max(YGRID);
        xnew_inc = (xgmax - xgmin) / (double(nxg) * n_interp);
        ynew_inc = (ygmax - ygmin) / (double(nyg) * n_interp);
        new_xgrid = [xgmin:xnew_inc:xgmax];
        new_ygrid = rot90([ygmin:ynew_inc:ygmax]);
        new_xgrid_mtr = zeros(length(new_ygrid),length(new_xgrid));    % 初期化
        new_ygrid_mtr = zeros(length(new_ygrid),length(new_xgrid));    % 初期化
        cc_new = zeros(length(new_ygrid),length(new_xgrid));           % 初期化
        new_xgrid_mtr = repmat(new_xgrid,length(new_ygrid),1);
        new_ygrid_mtr = repmat(new_ygrid,1,length(new_xgrid));
        old_xgrid_mtr = repmat(XGRID,length(YGRID),1);
        old_ygrid_mtr = repmat(flipud(rot90(YGRID)),1,length(XGRID));
        cc_new = zeros(length(new_ygrid),length(new_xgrid));           % 初期化
        % interp2関数を使って補間を行う
        cc_new = interp2(old_xgrid_mtr,old_ygrid_mtr,fliplr(CC),new_xgrid_mtr,new_ygrid_mtr);
        cc_new = fliplr(cc_new);
        % CCデータを保持
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            tempx = XGRID;
            tempy = YGRID;
            new_xgrid(1) = LON_GRID(1);  new_xgrid(end) = LON_GRID(end);
            new_ygrid(1) = LAT_GRID(1);  new_ygrid(end) = LAT_GRID(end);
            cc_new = flipud(cc_new);
        end
    else
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            tempx = XGRID;
            tempy = YGRID;
            XGRID = LON_GRID;
            YGRID = LAT_GRID;
        end
    end
    
    % 生成されたデータを描画する
    if SHADE_TYPE == 2
        switch PREF(7,1)
        case 1
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(jet);
        case 2
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
        case 3
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(gray);
        otherwise
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(jet);
        end
        set(gca,'YDir','normal');
    else
        switch PREF(7,1)
        case 1
            ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
                'YData',[YGRID(end) YGRID(1)]);colormap(jet);
        case 2
            ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
                'YData',[YGRID(end) YGRID(1)]);colormap(ANATOLIA);
        case 3
            ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
                'YData',[YGRID(end) YGRID(1)]);colormap(gray);
        otherwise
            ac = image(CC,'CDataMapping','scaled','XData',[XGRID(1) XGRID(end)],...
                'YData',[YGRID(end) YGRID(1)]);colormap(jet);
        end
        set(gca,'YDir','normal');
    end
    
    hold on;
    shading(gca,'interp');
    
    % カラーバーの範囲を設定
    caxis([-N N]);
    axis image;
    
    % ICOORDが2でLON_GRIDが存在する場合、アスペクト比を設定
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        set(gca,'DataAspectRatio',[XY_RATIO 1 1]);
    end
    shading interp;
    
    % XとYのラベルを設定
    hold on;
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        hx = xlabel('Longitude (degree)','FontSize',14);
        hy = ylabel('Latitude  (degree)','FontSize',14);
    else
        hx = xlabel('X (km)','FontSize',14);
        hy = ylabel('Y (km)','FontSize',14);
    end
    
    % タイトルを設定（FUNC_SWITCHの値によって変わる）
    switch FUNC_SWITCH
        case 4
            ht = title('Vertical displacement (m)','FontSize',18);            
        case 6  % ひずみ関数の場合
            switch STRAIN_SWITCH
                case 1  % SXX
                    ht = title('Strain SXX component','FontSize',18);  
                case 2  % SYY
                    ht = title('Strain SYY component','FontSize',18);  
                case 3  % SZZ
                    ht = title('Strain SZZ component','FontSize',18);  
                case 4  % SXY
                    ht = title('Strain SYZ component','FontSize',18);  
                case 5  % SXZ
                    ht = title('Strain SXZ component','FontSize',18);  
                case 6  % SYZ
                    ht = title('Strain SXY component','FontSize',18);  
                case 7  % 膨張
                    ht = title('Dilatation','FontSize',18);  
                otherwise
                    ht = title('Strain','FontSize',18);  
            end          
        case 7  % せん断応力の変化
            ht = title('Shear stress change (bar,right-lat. positive)','FontSize',14);
        case 8  % 垂直応力の変化
            ht = title('Normal stress change (bar,unclamping positive)','FontSize',14);
        case 9  % クーロン応力の変化
            ht = title('Coulomb stress change (bar)','FontSize',18);
        otherwise
    end
    
    % カラーバーを表示
    colorbar('location','EastOutside');
    hold on;
    
    %-----------    せん断応力関数のための等高線オーバーレイ    ---------------------------
    if FUNC_SWITCH == 7 || FUNC_SWITCH == 8 || FUNC_SWITCH == 9
        h = get(findobj('Tag','checkbox_coulomb_contour'),'Value');
        if h == 1
            hold on;
            [m, n] = size(CC);
            cmax = max(reshape(max(CC),length(XGRID),1));
            cmin = min(reshape(min(CC),length(XGRID),1));
            a = cmax - cmin;
            if isempty(CONT_INTERVAL)
                if a > 10.0
                    CONT_INTERVAL = 1;
                elseif a > 5.0
                    CONT_INTERVAL = 0.5;
                else
                    CONT_INTERVAL = 0.1;
                end
                set(findobj('Tag','edit_stress_cont_interval'),'String',num2str(CONT_INTERVAL,'%3.1f'));
            end
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                [C,h] = contour(LON_GRID,LAT_GRID,flipud(CC));
            else
                [C,h] = contour(XGRID,YGRID,flipud(CC));
            end
            set(h,'LineColor','k','ShowText','on','LevelStep',CONT_INTERVAL);
    
            i = findobj('Type','patch');
            set(i,'LineWidth',1);
            hold off;
        end
    end
    
    %-----------    ひずみ関数のための等高線オーバーレイ    ---------------------------
    if FUNC_SWITCH == 6
        h = get(findobj('Tag','contour_checkbox'),'Value');
        if h == 1
            hold on;
            [m, n] = size(CC);
            dd = zeros(m,n);
            dd = (CC./abs(CC)).*log10(abs(CC));
    
            cmax = round(max(reshape(max(dd),length(XGRID),1)));
            cmin = round(min(reshape(min(dd),length(XGRID),1)));
    
            if isempty(CONT_INTERVAL)
                CONT_INTERVAL = cmax - cmin + 1;
            end
    
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                [C,h] = contour(LON_GRID,LAT_GRID,flipud(dd));
            else
                [C,h] = contour(XGRID,YGRID,flipud(dd));
            end
    
            set(h,'LineColor','k','ShowText','on','LevelStep',CONT_INTERVAL);
    
            i = findobj('Type','patch');
            set(i,'LineWidth',1);
            hold off;
        end
    end
    
    %-----------    垂直変位関数のための等高線オーバーレイ    ---------------------------
    if FUNC_SWITCH == 4
        if VD_CHECKED == 1
            hold on;
            [m, n] = size(CC);
            cmax = max(reshape(max(CC),length(XGRID),1));
            cmin = min(reshape(min(CC),length(XGRID),1));
            a = cmax - cmin;
            if isempty(CONT_INTERVAL)
                if a > 10.0
                    CONT_INTERVAL = 1;
                elseif a > 5.0
                    CONT_INTERVAL = 0.5;
                elseif a > 1.0
                    CONT_INTERVAL = 0.1;
                else
                    CONT_INTERVAL = 0.01;
                end
            end
            if ICOORD == 2 && isempty(LON_GRID) ~= 1
                [C,h] = contour(LON_GRID,LAT_GRID,flipud(CC));
            else
                [C,h] = contour(XGRID,YGRID,flipud(CC));
            end    
            set(h,'LineColor','k','ShowText','on','LevelStep',CONT_INTERVAL);
            i = findobj('Type','patch');
            set(i,'LineWidth',1);
            hold off;
        end
    end
    
    %-----------    グリッドを元の値に戻す    ---------------------------
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        XGRID = tempx;
        YGRID = tempy;
    end
    
    %----------- データとファイル名のスタンプ    --------------
    hold on;
    
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        r = (LAT_GRID(end)-LAT_GRID(1))/(LON_GRID(end)-LON_GRID(1));
        if r > 1
            r = 1;
        end
        x = LON_GRID(end) + (LON_GRID(end)-LON_GRID(1))/(10.0/r);
        y = LAT_GRID(1)-((LAT_GRID(end)-LAT_GRID(1))/10.0)/r;
        lsp = ((LAT_GRID(end)-LAT_GRID(1))+(LON_GRID(end)-LON_GRID(1)))/75.0;
    else
        r = (YGRID(end)-YGRID(1))/(XGRID(end)-XGRID(1));
        if r > 1
            r = 1;
        end
        x = XGRID(end) + (XGRID(end)-XGRID(1))/(10.0/r);
        y = YGRID(1)-((YGRID(end)-YGRID(1))/10.0)/r;
        lsp = ((YGRID(end)-YGRID(1))+(XGRID(end)-XGRID(1)))/75.0;
    end
    
    if isempty(CALC_DEPTH_RANGE)
        CALC_DEPTH_RANGE = [0:5:10];
    end
    
    % タイトルやラベル、計算情報を描画
    try
        dm1 = STRIKE(1); dm2 = DIP(1); dm3 = RAKE(1);
    catch
        dm1 = 90; dm2 = 90; dm3 = 0;
    end
    
    record_stamp(H_MAIN,x,y,'SoftwareVersion',CURRENT_VERSION,...
            'FunctionType',FUNC_SWITCH,'Depth',CALC_DEPTH,...
            'DepthType',DEPTH_RANGE_TYPE,'DepthMin',CALC_DEPTH_RANGE(1),...
            'DepthMax',CALC_DEPTH_RANGE(end),...
            'StressType',STRESS_TYPE,'Friction',FRIC,...
            'FileName',INPUT_FILE,'LineSpace',lsp,'Strike',dm1,'Dip',dm2,'Rake',dm3,...
            'FontSize',9);
    CALC_DEPTH_RANGE = [];
