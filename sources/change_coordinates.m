% 座標系の切り替えと、地図上に様々なデータをオーバーレイするための処理を行うスクリプト
% change_coordinates スクリプト：座標系の変更とその確認
% menu_grid_mapview_Callback 関数：グリッドや地図要素（海岸線、活断層、地震、GPSデータなど）の描画やオーバーレイの管理

% --------------------------------------------------------------------------------
% change_coordinates (script)
% 座標系を1から2に変更（デカルト → 緯度経度）
if ICOORD == 1
    ICOORD = 2;
    % 緯度経度情報がない場合、警告を表示して終了
    if isempty(LON_GRID)
        h = warndlg('No lon. & lat. information');
        % 警告ダイアログが閉じられるまで待機
        waitfor(h);
        return
    end
% 座標系を2から1に戻す（緯度経度 → デカルト）
else
    ICOORD = 1;
end

% --------------------------------------------------------------------------------
% function menu_grid_mapview_Callback(hObject, eventdata, handles)
% グリッドと地図ビューのオーバーレイを管理するコールバック関数

global FUNC_SWITCH ICOORD LON_GRID COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
subfig_clear;    % 既存のサブフィギュア（グラフィックス）をクリア
FUNC_SWITCH = 1; % 関数の状態を切り替え（描画のためのフラグ設定）
grid_drawing;    % グリッドを描画
fault_overlay;   % 活断層データをオーバーレイ

% 各種データ（海岸線、地震、活断層、GPS）のいずれかが存在する場合、オーバーレイ描画を行う
if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
        isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
    hold on;
    % オーバーレイの描画
    overlay_drawing;
end

    
% 状態をリセット（描画終了）
FUNC_SWITCH = 0;
% 緯度経度情報の確認
flag = check_lonlat_info;
if flag == 1
    % 各メニュー項目を有効にする
    set(findobj('Tag','menu_coastlines'),'Enable','On');
    set(findobj('Tag','menu_activefaults'),'Enable','On');
    set(findobj('Tag','menu_earthquakes'),'Enable','On');
    set(findobj('Tag','menu_gps'),'Enable','On'); 
    set(findobj('Tag','menu_annotations'),'Enable','On'); 
    set(findobj('Tag','menu_clear_overlay'),'Enable','On');
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); 
end
