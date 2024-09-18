function afault_drawing(flag)
    % afault_drawing: 活断層データを読み込み、地図上に描画する関数
    % flag: 活断層データの座標系の設定 (0: 通常, 1: 反転)

    % グローバル変数の定義
    global COORD_VARS
    global INPUT_VARS
    global OVERLAY_VARS
    global SYSTEM_VARS
    global H_MAIN
    persistent AFAULT_DIR

    % 描画用の座標系の設定
    xs = INPUT_VARS.GRID(1,1);
    xf = INPUT_VARS.GRID(3,1);
    ys = INPUT_VARS.GRID(2,1);
    yf = INPUT_VARS.GRID(4,1);   
    xinc = (xf - xs) / (COORD_VARS.MAX_LON - COORD_VARS.MIN_LON);
    yinc = (yf - ys) / (COORD_VARS.MAX_LAT - COORD_VARS.MIN_LAT);

    % 活断層データが保存されているディレクトリに移動
    try
        cd(OVERLAY_VARS.AFAULT_DIR);
    catch
        try
            cd('active_fault_data');
        catch
            cd(SYSTEM_VARS.HOME_DIR);
        end
    end

    % 活断層データがまだ読み込まれていない場合は、ユーザーにファイルを選択させる
    if isempty(OVERLAY_VARS.AFAULT_DATA)
        [filename, pathname] = uigetfile('*.*', 'Open fault line data file');
        if isequal(filename, 0)
            disp('User selected Cancel');
            return;
        else
            disp('----- active fault data -----');
            disp(['User selected: ', fullfile(pathname, filename)]);
        end
        AFAULT_DIR = pathname;
        fid = fopen(fullfile(pathname, filename), 'r');
        n = 2000000;  % 読み込み行数の上限
        count = 0;
        hm = wait_calc_window();  % 計算中ウィンドウを表示

        % ファイルからデータを読み込み
        for m = 1:n
            count = count + 1;
            if m == 1
                a = textscan(fid, '%f %f', 'HeaderLines', 2);
                if flag == 0
                    y{m} = a{1};
                    x{m} = a{2};
                elseif flag == 1
                    x{m} = a{1};
                    y{m} = a{2};
                end
            else
                a = textscan(fid, '%f %f', 'HeaderLines', 1);
                if flag == 0
                    y{m} = a{1};
                    x{m} = a{2};
                elseif flag == 1
                    x{m} = a{1};
                    y{m} = a{2};
                end
            end
            if isempty(a{1}) && isempty(a{2})
                break;
            end
        end
        fclose(fid);

        % 調査地域より少し大きい海岸線情報を選択するためのダミー（バッファー）の幅
        dummy = OVERLAY_VARS.OVERLAY_MARGIN;
        disp(['* Extra margin width of the data screening is ' num2str(int16(dummy)) ' km']);
        disp('* To save the areal active fault data as binary, use the save command.');
        disp('* Example: save myfault.mat AFAULT_DATA');
        disp(' ');

        icount = 0;
        temp = 0;
        nn = 0;

        if ~isempty(H_MAIN)
            figure(H_MAIN);
            hold on;
        end

        % 各セグメントのデータを地図上に変換
        for m = 1:count
            xx = [x{m}];
            yy = [y{m}];
            xx = xs + (xx - COORD_VARS.MIN_LON) * xinc;
            yy = ys + (yy - COORD_VARS.MIN_LAT) * yinc;
            nkeep = nn;
            hold on;

            % 地図範囲内のデータを保持
            for k = 1:length(xx)
                if xx(k) >= (xs - dummy) && xx(k) <= (xf + dummy) && yy(k) >= (ys - dummy) && yy(k) <= (yf + dummy)
                    nn = nn + 1;
                    if m ~= temp
                        icount = icount + 1;
                        temp = m;
                    end
                    a = xy2lonlat([xx(k), yy(k)]);
                    OVERLAY_VARS.AFAULT_DATA(nn,1) = a(1);  % 経度
                    OVERLAY_VARS.AFAULT_DATA(nn,2) = a(2);  % 緯度
                    OVERLAY_VARS.AFAULT_DATA(nn,3) = xx(k);
                    OVERLAY_VARS.AFAULT_DATA(nn,4) = yy(k);
                    hold on;
                end
            end

            % セグメント間をNaNで区切る
            if nn > nkeep
                nn = nn + 1;
                OVERLAY_VARS.AFAULT_DATA(nn,1) = NaN;
                OVERLAY_VARS.AFAULT_DATA(nn,2) = NaN;
                OVERLAY_VARS.AFAULT_DATA(nn,3) = NaN;
                OVERLAY_VARS.AFAULT_DATA(nn,4) = NaN;
            end
        end
        close(hm);
    end

    % メモリ節約のため、データを single 型に変換
    OVERLAY_VARS.AFAULT_DATA = single(OVERLAY_VARS.AFAULT_DATA);

    % ---------------------------- 実際の描画処理 -----------------
    if ~isempty(OVERLAY_VARS.AFAULT_DATA)
        hm = wait_calc_window();
        if ~isempty(H_MAIN)
            figure(H_MAIN);
            hold on;
        end
        [m, n] = size(OVERLAY_VARS.AFAULT_DATA);

        % 古いデータフォーマットの対応
        if n == 9
            disp('!!! Warning !!!');
            disp('This active fault data is from an old version.');
            if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.LON_GRID)
                x1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,2)); rot90(OVERLAY_VARS.AFAULT_DATA(:,4))];
                y1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,3)); rot90(OVERLAY_VARS.AFAULT_DATA(:,5))];
            else
                x1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,6)); rot90(OVERLAY_VARS.AFAULT_DATA(:,8))];
                y1 = [rot90(OVERLAY_VARS.AFAULT_DATA(:,7)); rot90(OVERLAY_VARS.AFAULT_DATA(:,9))];
            end
        else
            % 新しいデータフォーマットの対応
            if COORD_VARS.ICOORD == 2 && ~isempty(COORD_VARS.ON_GRID)
                x1 = OVERLAY_VARS.AFAULT_DATA(:,1);
                y1 = OVERLAY_VARS.AFAULT_DATA(:,2);
            else
                x1 = OVERLAY_VARS.AFAULT_DATA(:,3);
                y1 = OVERLAY_VARS.AFAULT_DATA(:,4);
            end
        end
        h = plot(gca, x1, y1, 'Color', SYSTEM_VARS.PREF(6,1:3), 'LineWidth', SYSTEM_VARS.PREF(6,4));
        set(h, 'Tag', 'AfaultObj');
        hold on;
        close(hm);
    end

    % 作業ディレクトリをホームディレクトリに戻す
    cd(SYSTEM_VARS.HOME_DIR);
end
