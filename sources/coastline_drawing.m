function coastline_drawing
% 海岸線データを使用して簡単に海岸線を描画する関数
% グローバル変数を使用して、描画範囲やデータの読み込み先を管理します。

global MIN_LAT MAX_LAT MIN_LON MAX_LON ZERO_LON
global GRID
global PREF
global H_MAIN
global ICOORD LON_GRID
global COAST_DATA
global HOME_DIR
global OVERLAY_MARGIN
persistent COAST_DIR

% 描画のための座標系の設定
xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);

% 自動的に選択されたディレクトリ 'coastline_data' に移動
try
    cd(COAST_DIR);
catch
    try
        cd('coastline_data');
    catch
        cd(HOME_DIR);
    end
end
    
% デフォルトのダイアログでデータファイルを選択
if isempty(COAST_DATA)==1

    [filename,pathname] = uigetfile('*.*',' Open coastline data file');
    if isequal(filename,0)
        disp('  User selected Cancel')
        return
    else
        disp('  ----- coastline data -----');
        disp(['  User selected', fullfile(pathname, filename)])
    end
    fid = fopen(filename,'r');
    COAST_DIR = pathname;


    % *****  % 西半球のデータかどうかをテストするために読み込む *****************
    n = 10000;  % ダミーの数値（後で 'end' を使用する予定）
    count = 0;
    for m = 1:n
        count = count + 1;
        if m == 1
            test = textscan(fid,'%f %f','headerlines', 2);
            aa{m} = test{1};
            bb{m} = test{2};
        else
            test = textscan(fid,'%f %f','headerlines', 1);
            aa{m} = test{1};
            bb{m} = test{2};
        end
        check_test = [test{1}];
        if length(check_test) <= 1
            break
        end 
    end
    for i = 1:size(aa,1);
        aaa = [aa{i}];
    end
    if max(aaa) > 180.0
        but = 'plus';
    else
        but = 'minus';
    end

    % ****************************************************************

    % 西半球がプラスかマイナスかによって、経度を調整
    if length(but) == 4       % 'plus' W 半球をプラスとして扱う
        if MIN_LON < 0.0
            minlon = 360.0 + MIN_LON;
        else
            minlon = MIN_LON;
        end
        if MAX_LON < 0.0
            maxlon = 360.0 + MAX_LON;
        else
            maxlon = MAX_LON;
        end
        if ZERO_LON < 0.0
            zerolon = 360.0 + ZERO_LON;
        else
            erolon = ZERO_LON;
        end
    elseif length(but) == 5    % 'minus' (負の値として扱う)
        minlon = MIN_LON;
        maxlon = MAX_LON;
        zerolon = ZERO_LON;
    else                       % 無効な値の場合
        warndlg('Check your coastline file.','!! Warning !!');
        return
    end
    xinc = (xf - xs)/(maxlon-minlon);
    yinc = (yf - ys)/(MAX_LAT-MIN_LAT);
end


%---------------------

% 計算ウィンドウの表示
hm = wait_calc_window;

%---------------------

% 海岸線データがまだ読み込まれていない場合の処理
if isempty(COAST_DATA)==1
    n = 10000;  % ダミーの数値
    count = 0;
    fid = fopen(fullfile(pathname, filename),'r');

    for m = 1:n
        count = count + 1;
        if m == 1
            a = textscan(fid,'%f %f','headerlines', 2);
            x{m} = a{1};
            y{m} = a{2};
        else
            a = textscan(fid,'%f %f','headerlines', 1);
            x{m} = a{1};
            y{m} = a{2};
        end
        checka = [a{1}];

        if length(checka) <= 1
            break
        end
        
    end

    fclose(fid);

end
%-----------

if isempty(H_MAIN) ~= 1
    figure(H_MAIN);
    hold on;
end

%---------------------

% 海岸線データの処理
if isempty(COAST_DATA)==1
    dummy = OVERLAY_MARGIN;
    disp(['   * Extra margin width of the data screening is ' num2str(int16(dummy)) ' km']);
    disp(['   * If you want to trim more, change the value OVERLAY_MARGIN in this']);
    disp(['   * command window and then read it again. It is useful for 3D view.']);
    disp(' ');
    disp('   * To save the areal coastline data as binary, use the following command');
    disp('   * in the Command Window.');
    disp('   * save filename COAST_DATA (e.g., save mycoastline.mat COAST_DATA)');
    disp('   * To read the .mat formatted coastline data, use ''File -> Open...'' menu later.');
    disp(' ');

    icount = 0;
    temp = 0;
    nn = 0;
    nlength = size(x,1);

    if count <= 2 % NOAA形式 ('nan nan') の場合の処理
        for m = 1:nlength
            xx = [x{m}];
            yy = [y{m}];
            xx = xs + (xx - minlon) * xinc;
            yy = ys + (yy - MIN_LAT) * yinc;
            hold on;
            for k = 1:length(xx)
                if isnan(xx(k))
                    nn = nn + 1;
                    COAST_DATA(nn,1) = NaN;
                    COAST_DATA(nn,2) = NaN;
                    COAST_DATA(nn,3) = NaN;
                    COAST_DATA(nn,4) = NaN;
                    continue
                else
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
                                    COAST_DATA(nn,1) = a(1);
                                    COAST_DATA(nn,2) = a(2);
                                    COAST_DATA(nn,3) = xx(k);
                                    COAST_DATA(nn,4) = yy(k);
                                    hold on;
                                end
                            end
                        end
                    end
                end
            end
        end
    else            % デリミタ形式 ('<') の場合の処理
        for m = 1:count
            xx = [x{m}];
            yy = [y{m}];
            xx = xs + (xx - minlon) * xinc;
            yy = ys + (yy - MIN_LAT) * yinc;
            nkeep = nn;
            hold on;
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
                                COAST_DATA(nn,1) = a(1);
                                COAST_DATA(nn,2) = a(2);
                                COAST_DATA(nn,3) = xx(k);
                                COAST_DATA(nn,4) = yy(k);
                                hold on;
                            end
                        end
                    end
                end
            end
            % 描画ペンを上げるためにNaNタグを付与（海岸線セグメントを分ける）
            if nn > nkeep
                nn = nn + 1;
                COAST_DATA(nn,1) = NaN;
                COAST_DATA(nn,2) = NaN;
                COAST_DATA(nn,3) = NaN;
                COAST_DATA(nn,4) = NaN;
            end
        end
    end
end

% メモリサイズを削減するための処理
COAST_DATA = single(COAST_DATA);


% ---------------------------- 実際の描画処理 --------------

if isempty(COAST_DATA)~=1
    [m,n] = size(COAST_DATA);   % 古いフォーマットか新しいフォーマットかを判別

    % ===== 古いフォーマット plotting =================
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This coastline data COAST_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = [rot90(COAST_DATA(:,2));rot90(COAST_DATA(:,4))];
            y1 = [rot90(COAST_DATA(:,3));rot90(COAST_DATA(:,5))];
        else
            x1 = [rot90(COAST_DATA(:,6));rot90(COAST_DATA(:,8))];
            y1 = [rot90(COAST_DATA(:,7));rot90(COAST_DATA(:,9))];
        end
% ===== 新しいフォーマット plotting =================
    else
        if ICOORD == 2 && isempty(LON_GRID) ~= 1
            x1 = COAST_DATA(:,1);
            y1 = COAST_DATA(:,2);
        else
            x1 = COAST_DATA(:,3);
            y1 = COAST_DATA(:,4);
        end
    end
        hold on;
        h = plot(gca,x1,y1,'Color',PREF(4,1:3),'LineWidth',PREF(4,4));
        set(h,'Tag','CoastlineObj');
        hold on;
end
% -------------------------------------------------------------

close(hm); % 計算ウィンドウを閉じる
cd(HOME_DIR); % ホームディレクトリに戻る
