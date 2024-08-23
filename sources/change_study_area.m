% Change study area
% 研究対象領域を変更する処理を行う

global ICOORD LON_GRID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global FUNC_SWITCH COAST_DATA EQ_DATA GPS_DATA AFAULT_DATA
global MIN_LON MAX_LON MIN_LAT MAX_LAT

% 最初に、メインウィンドウのハンドルの可視性を「on」に設定
set(H_MAIN,'HandleVisibility','on');
% メインウィンドウのハンドルを取得
h = figure(H_MAIN);

% 研究対象領域を変更するための新しいウィンドウを開く
h1 = change_study_area_window;

% 座標系が経度・緯度か、X軸・Y軸かで表示を切り替える
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(findobj('Tag','text_study_area_x'),'String','Longitude (degree)');
    set(findobj('Tag','text_study_area_y'),'String','Latitude  (degree)'); 
else
    set(findobj('Tag','text_study_area_x'),'String','X axis (km)');
    set(findobj('Tag','text_study_area_y'),'String','Y axis (km)');
end
% ウィンドウが閉じられるまで待機
waitfor(h1);

% 要素の再計算を実行
calc_element;

% ----- メインメニューウィンドウでのグリッド描画機能からの呼び出し
subfig_clear;    % サブフィギュアをクリア
FUNC_SWITCH = 1;
grid_drawing;    % グリッドの再描画
fault_overlay;   % 断層オーバーレイの描画

% 必要に応じて、他のデータ（海岸線、地震、活断層、GPS）のオーバーレイを描画
if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
        isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
    hold on;
    overlay_drawing;
end

% 処理完了後にリセット
FUNC_SWITCH = 0;

% 経度・緯度情報が正しいか確認
flag = check_lonlat_info;
% メニューオプションを有効化
if flag == 1
    set(findobj('Tag','menu_coastlines'),'Enable','On');
    set(findobj('Tag','menu_activefaults'),'Enable','On');
    set(findobj('Tag','menu_earthquakes'),'Enable','On');
    set(findobj('Tag','menu_gps'),'Enable','On'); 
    set(findobj('Tag','menu_annotations'),'Enable','On'); 
    set(findobj('Tag','menu_clear_overlay'),'Enable','On');
    set(findobj('Tag','menu_trace_put_faults'),'Enable','On');
    % オーバーレイの正確な位置を保持したい場合、元データから再読み込みするよう促すメッセージを表示
    h = msgbox('If you want to keep precise locations of the overlays, reload them from original data.','Notice','warn');
end

% ------------------------------------------------------------------

% 一部の変数をクリアし、メインウィンドウのハンドル可視性を「callback」に設定
set(H_MAIN,'HandleVisibility','callback');

