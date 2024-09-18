function fault_overlay()
    % FAULT_OVERLAY draws faults included in an input file.
    % グローバル変数を宣言
    global H_MAIN
    global FNUM_ONOFF   % 断層番号を表示するかどうかを制御するフラグ
    global DEPTH_RANGE_TYPE
    global INPUT_VARS
    global COORD_VARS
    global SYSTEM_VARS

    % 子フィギュアを探してメインウィンドウに戻す処理
    h = findobj('Tag', 'main_menu_window2');
    if ~isempty(h) && ~isempty(H_MAIN)
        figure(H_MAIN);  % メインウィンドウを前面に表示
    else
        warndlg('No window prepared for grid drawing!', '!!Bug!!');
        return;
    end

    hold on;

    % 断層数ループ
    for n = 1:INPUT_VARS.NUM
        % コンテキストメニューを作成
        cmenus(n) = uicontextmenu;
        cmenuf(n) = uicontextmenu;

        % 断層のコーナー情報を取得
        c = fault_corners(INPUT_VARS.ELEMENT(n,1), INPUT_VARS.ELEMENT(n,2), ...
                          INPUT_VARS.ELEMENT(n,3), INPUT_VARS.ELEMENT(n,4), ...
                          INPUT_VARS.ELEMENT(n,7), INPUT_VARS.ELEMENT(n,8), INPUT_VARS.ELEMENT(n,9));

        % 表面プロジェクション用のライン
        d = fault_corners(INPUT_VARS.ELEMENT(n,1), INPUT_VARS.ELEMENT(n,2), ...
                          INPUT_VARS.ELEMENT(n,3), INPUT_VARS.ELEMENT(n,4), ...
                          INPUT_VARS.ELEMENT(n,7), INPUT_VARS.ELEMENT(n,8), 0.0);

        % 計算深度でのプロジェクション
        e = fault_corners(INPUT_VARS.ELEMENT(n,1), INPUT_VARS.ELEMENT(n,2), ...
                          INPUT_VARS.ELEMENT(n,3), INPUT_VARS.ELEMENT(n,4), ...
                          INPUT_VARS.ELEMENT(n,7), INPUT_VARS.ELEMENT(n,8), INPUT_VARS.CALC_DEPTH);

        % 深度範囲が選択されていない場合に計算
        if DEPTH_RANGE_TYPE == 0
            hold on;
            if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
                d1 = xy2lonlat([e(3,1), e(3,2)]);
                d2 = xy2lonlat([e(4,1), e(4,2)]);
                a2 = plot([d1(1), d2(1)], [d1(2), d2(2)]);
            else
                a2 = plot([e(3,1), e(4,1)], [e(3,2), e(4,2)]);
            end
            set(a2, 'Color', 'k', 'LineWidth', 1);
        end

        % 表面プロジェクションの描画
        hold on;
        if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
            d1 = xy2lonlat([c(1,1), c(1,2)]);
            d2 = xy2lonlat([c(2,1), c(2,2)]);
            d3 = xy2lonlat([c(3,1), c(3,2)]);
            d4 = xy2lonlat([c(4,1), c(4,2)]);
            a3 = plot([d1(1), d2(1), d3(1), d4(1), d1(1)], [d1(2), d2(2), d3(2), d4(2), d1(2)]);
        else
            a3 = plot([c(1,1), c(2,1), c(3,1), c(4,1), c(1,1)], [c(1,2), c(2,2), c(3,2), c(4,2), c(1,2)]);
        end
        set(a3, 'Color', 'w', 'LineWidth', 2.0);

        hold on;
        if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
            d1 = xy2lonlat([c(1,1), c(1,2)]);
            d2 = xy2lonlat([c(2,1), c(2,2)]);
            d3 = xy2lonlat([c(3,1), c(3,2)]);
            d4 = xy2lonlat([c(4,1), c(4,2)]);
            a4 = plot([d1(1), d2(1), d3(1), d4(1), d1(1)], [d1(2), d2(2), d3(2), d4(2), d1(2)], 'UIContextMenu', cmenuf(n));
        else
            a4 = plot([c(1,1), c(2,1), c(3,1), c(4,1), c(1,1)], [c(1,2), c(2,2), c(3,2), c(4,2), c(1,2)], 'UIContextMenu', cmenuf(n));
        end
        set(a4, 'Color', SYSTEM_VARS.PREF(1,1:3), 'LineWidth', SYSTEM_VARS.PREF(1,4));

        % 表面交差の描画
        hold on;
        if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
            d1 = xy2lonlat([d(3,1), d(3,2)]);
            d2 = xy2lonlat([d(4,1), d(4,2)]);
            a1 = plot([d1(1), d2(1)], [d1(2), d2(2)], 'UIContextMenu', cmenus(n));
            set(a1, 'Color', 'g', 'LineWidth', 2);
        else
            a1 = plot([d(3,1), d(4,1)], [d(3,2), d(4,2)], 'UIContextMenu', cmenus(n));
            set(a1, 'Color', 'g', 'LineWidth', 2);
        end

        % コンテキストメニューの設定
        items1 = uimenu(cmenus(n), 'Label', 'change parameters', ...
                        'Callback', ['INPUT_VARS.ELEMENT_modification(' num2str(n,'%3i') ')']);
        itemf1 = uimenu(cmenuf(n), 'Label', 'change parameters', ...
                        'Callback', ['INPUT_VARS.ELEMENT_modification(' num2str(n,'%3i') ')']);

        % 断層番号の表示
        if FNUM_ONOFF == 1
            if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
                d1 = xy2lonlat([c(1,1), c(1,2)]);
                htx = text(d1(1), d1(2), num2str(n));
            else
                htx = text(c(1,1), c(1,2), num2str(n));
            end
            set(htx, 'fontsize', 14, 'fontweight', 'bold', 'Color', [0.1, 0.1, 0.6]);
        end

        % Point source (点源) のプロット
        if INPUT_VARS.KODE == 400 || INPUT_VARS.KODE == 500
            ap = plot((e(3,1) + e(4,1)) / 2.0, (e(3,2) + e(4,2)) / 2.0, 'ko');
            set(ap, 'LineWidth', 1.5);
        end
    end

    hold off;
end

