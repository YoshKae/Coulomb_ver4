function overlay_drawing()
    % overlay_drawing: 各オーバーレイを描画する関数
    % グローバル変数を宣言
    global OVERLAY_VARS
    global COORD_VARS
    global SYSTEM_VARS
    global H_MAIN

    % ----- 海岸線の描画 -----
    h = findobj('Tag', 'menu_coastlines');
    h1 = get(h, 'Checked');
    if ~isempty(OVERLAY_VARS.COAST_DATA) && strcmp(h1, 'on')
        coastline_drawing();  % 海岸線を描画
    end

    % ----- 活断層の描画 -----
    h = findobj('Tag', 'menu_activefaults');
    h1 = get(h, 'Checked');
    if ~isempty(OVERLAY_VARS.AFAULT_DATA) && strcmp(h1, 'on')
        afault_drawing();  % 活断層を描画
    end

    % --- 地震データの描画 ---
    h = findobj('Tag', 'menu_earthquakes');
    h1 = get(h, 'Checked');
    if ~isempty(OVERLAY_VARS.EQ_DATA) && strcmp(h1, 'on')
        earthquake_plot();  % 地震データを描画
    end
end
