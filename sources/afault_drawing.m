% ASCIIファイルから活断層データを読み取り、そのデータを基に活断層の位置を地図上に描画するためのMATLAB関数
function afault_drawing(flag)
% ASCII入力ファイルを使った活断層の簡単な描画
% input: flag = 1, lon (1st column) and lat (2nd column)
%        flag = 0, lat (1st column) and lon (2nd column)
% output:

% グローバル変数の定義
global MIN_LAT MAX_LAT MIN_LON MAX_LON
global GRID
global PREF
global H_MAIN
global AFAULT_DATA
global ICOORD LON_GRID
global HOME_DIR OVERLAY_MARGIN
persistent AFAULT_DIR

% 描画用の座標系の設定
xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);   
xinc = (xf - xs)/(MAX_LON-MIN_LON);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);

% 活断層データが保存されているディレクトリに移動
try
    cd(AFAULT_DIR);
catch
    try
        cd('active_fault_data');
    catch
        cd(HOME_DIR);
    end
end

% 活断層データがまだ読み込まれていない場合は、ユーザーにファイルを選択させる
if isempty(AFAULT_DATA)==1
    [filename,pathname] = uigetfile('*.*',' Open fault line data file');
    if isequal(filename,0)
        disp('  User selected Cancel')
        return
    else
        disp('  ----- active fault data -----');
        disp(['  User selected', fullfile(pathname, filename)])
    end
    AFAULT_DIR = pathname;
    fid = fopen(fullfile(pathname, filename),'r');
    n = 2000000;
    count = 0;
    hm = wait_calc_window;

    % ファイルからデータを読み込み
    for m = 1:n
        count = count + 1;
        if m == 1
            a = textscan(fid,'%f %f','headerlines', 2);
            if flag == 0
                y{m} = a{1};
                x{m} = a{2};
            elseif flag == 1
                x{m} = a{1};
                y{m} = a{2};
            end
        else
            a = textscan(fid,'%f %f','headerlines', 1);
            if flag == 0
                y{m} = a{1};
                x{m} = a{2};
            elseif flag == 1
                x{m} = a{1};
                y{m} = a{2};
            end
        end
        if isempty(a{1}) && isempty(a{2})
            break
        end
    end
    fclose(fid);

    % 調査地域より少し大きい海岸線情報を選択するためのダミー（バッファー）の幅
    dummy = OVERLAY_MARGIN;
    disp(['   * Extra margin width of the data screening is ' num2str(int16(dummy)) ' km']);
    disp(['   * If you want to trim more, change the value OVERLAY_MARGIN in this']);
    disp(['   * command window and then read it again. It is useful for 3D view.']);
    disp(' ');
    disp('   * To save the areal active fault data as binary, use the following command');
    disp('   * in the Command Window.');
    disp('   * save filename AFAULT_DATA (e.g., save myacault.mat AFAULT_DATA)');
    disp('   * To read the .mat formatted active fault data, use ''File -> Open...'' menu later.');
    disp(' ');
    
    icount = 0;
    temp = 0;
    nn = 0;

    if isempty(H_MAIN) ~= 1
        figure(H_MAIN);
        hold on;
    end

    % 各セグメントのデータを地図上に描画可能な座標系に変換
    for m = 1:count
        xx = [x{m}];
        yy = [y{m}];
        xx = xs + (xx - MIN_LON) * xinc;
        yy = ys + (yy - MIN_LAT) * yinc;
        nkeep = nn;
        hold on;

        % 地図範囲内にあるデータのみ描画用データとして保持
        for k = 1:length(xx)
            if xx(k) >= (xs-dummy) 
                if xx(k) <= (xf+dummy)
                    if yy(k) >= (ys-dummy)
                        if yy(k) <= (yf+dummy)
                            nn = nn + 1;
                            if m ~= temp
                                icount = icount + 1;
                                temp = m;
                            end
                            a = xy2lonlat([xx(k) yy(k)]);
                            AFAULT_DATA(nn,1) = a(1);  % lon. (start)
                            AFAULT_DATA(nn,2) = a(2);  % lat. (start)
                            AFAULT_DATA(nn,3) = xx(k);
                            AFAULT_DATA(nn,4) = yy(k);
                            hold on;
                        end
                    end
                end
            end
        end

        % セグメント間をNaNで区切る
        if nn > nkeep
            nn = nn + 1;
            AFAULT_DATA(nn,1) = NaN;
            AFAULT_DATA(nn,2) = NaN;
            AFAULT_DATA(nn,3) = NaN;
            AFAULT_DATA(nn,4) = NaN;
        end
    end
    close(hm);
end

% メモリ使用量を削減するためにデータを single 型に変換
AFAULT_DATA = single(AFAULT_DATA);

% ---------------------------- 実際の描画処理 -----------------
if isempty(AFAULT_DATA)~=1
    hm = wait_calc_window;
    if isempty(H_MAIN) ~= 1
    figure(H_MAIN);
    hold on;
    end
    [m,n] = size(AFAULT_DATA);
    % 古いデータフォーマットの対応------------------------------
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This active fault data AFAULT_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = [rot90(AFAULT_DATA(:,2));rot90(AFAULT_DATA(:,4))];
            y1 = [rot90(AFAULT_DATA(:,3));rot90(AFAULT_DATA(:,5))];
        else
            x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
            y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
        end
    else
        % 新しいデータフォーマットの対応
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = AFAULT_DATA(:,1);
            y1 = AFAULT_DATA(:,2);
        else
            x1 = AFAULT_DATA(:,3);
            y1 = AFAULT_DATA(:,4);
        end
    end
	h = plot(gca,x1,y1,'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
    set(h,'Tag','AfaultObj');
    hold on;
    close(hm);
end

% 作業ディレクトリをホームディレクトリに戻す
cd(HOME_DIR);
