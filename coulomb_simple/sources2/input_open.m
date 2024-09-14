function input_open(N)
    % Coulomb形式の入力ファイルを読み込む関数
    % input_open はCoulomb形式の入力ファイルをMATLABに読み込みます。
    
    % Nは、ファイル内容を表示するかどうかを決定するための番号です。
    %   N=1: ダイアログを表示してパラメータの確認と変更を行う
    %   N=2: 新しいファイルを作成する
    %   N=3: ダイアログを表示せずにスキップする
    
    global H_INPUT IACTS FLAG_SLIP_LINE DIALOG_SKIP
    global INPUT_VARS
    global COORD_VARS
    global CALC_CONTROL
    global SECTION_VARS
    global OVERLAY_VARS
    global SYSTEM_VARS
    
    % 初期化
    CALC_CONTROL.IACT  = 0;
    IACTS = 0;
    FLAG_SLIP_LINE = 0;
    num_buffer = 100; % NUMを調整するためのバッファ
     
    % ダイアログがスキップされていない場合、またはDIALOG_SKIPが空の場合
    if DIALOG_SKIP ~= 1 || isempty(DIALOG_SKIP)
        % デフォルトのディレクトリに移動する処理
        if isempty(SYSTEM_VARS.PREF_DIR) ~= 1
            try
                cd(SYSTEM_VARS.PREF_DIR);
            catch
                cd(SYSTEM_VARS.HOME_DIR);
            end
        else
            try
                cd('input_files2');
            catch
                cd(SYSTEM_VARS.HOME_DIR);
            end
        end
    
        % ユーザーにファイルを選択させるダイアログを表示
        try
            [filename,pathname] = uigetfile( ...
                    {'*.inp;*.inr;*.mat;*.csv','Open input file (*.inp,*.inr,*.mat,*.csv)'; ...
                     '*.inp',  'ascii input (*.inp)'; ...
                     '*.inr',  'ascii input (*.inr)'; ...
                     '*.mat','binary input (*.mat)'; ...
                     '*.csv', 'CSV input (*.csv)'}, ...
                     'Pick a file');
            % キャンセルが選択された場合の処理
            if isequal(filename,0)
                disp('---------------------------------------------------');
                disp('User selected Cancel');
                cd(SYSTEM_VARS.HOME_DIR);
                CALC_CONTROL.IACT = 1; % 前回のセッション情報を保持するため
                return
            else
                disp('---------------------------------------------------');
                disp(['User selected', fullfile(pathname, filename)]);
            end
        catch
            errordlg('You might have opened wrong formatted file');
            return;
        end
    else
        % DIALOG_SKIPが1のとき、つまり直前の入力ファイルを再読み込みする場合
        pathname = SYSTEM_VARS.PREF_DIR;
        filename = SYSTEM_VARS.INPUT_FILE;
        if strcmp(filename,'empty')
            disp('No file most recently used. Use menu ''Open existing input file''');
            return
        end
        disp('---------------------------------------------------');
        disp(['User selected', fullfile(pathname, filename)]);
    end
    
    % 拡張子によって処理を分ける
    [~,~,ext] = fileparts(filename); % ファイル拡張子を取得
    
    % 初期化（以前のセッションのデータをリセット）
    INPUT_VARS = [];
    COORD_VARS = [];
    OVERLAY_VARS = [];
    
    if strcmp(ext, '.csv')
        % ------------------CSVファイルの場合の処理------------------
        disp('CSV file detected. Reading data from CSV...');
        
        % CSVファイルの読み込み
        opts = detectImportOptions(fullfile(pathname, filename));
        csv_data = readtable(fullfile(pathname, filename), opts);
    
        % 最後の2行を無視するため、行数を確認
        total_rows = height(csv_data);
        csv_data = csv_data(1:total_rows-2, :); % 最後の2行を削除
    
        % タイトルに基づいて対応するデータを変数に保存
        try
            INPUT_VARS.POIS = csv_data{strcmp(csv_data.Var1, 'PR1'), 2}; % ポアソン比 PR1
            INPUT_VARS.CALC_DEPTH = csv_data{strcmp(csv_data.Var1, 'DEPTH'), 2}; % 計算深度
            INPUT_VARS.YOUNG = csv_data{strcmp(csv_data.Var1, 'E1'), 2}; % ヤング率 E1
            INPUT_VARS.FRIC = csv_data{strcmp(csv_data.Var1, 'FRIC'), 2}; % 摩擦係数
            INPUT_VARS.GRID = csv_data{contains(csv_data.Var1, 'Start-x') | contains(csv_data.Var1, 'Start-y') | contains(csv_data.Var1, 'Finish-x') | contains(csv_data.Var1, 'Finish-y') | contains(csv_data.Var1, 'x-increment') | contains(csv_data.Var1, 'y-increment'), 2}; % グリッドパラメータ
            INPUT_VARS.SIZE = csv_data{contains(csv_data.Var1, 'Plot size') | contains(csv_data.Var1, 'Shade/Color increment') | contains(csv_data.Var1, 'Exaggeration'), 2}; % サイズパラメータ
            INPUT_VARS.SECTION = csv_data{contains(csv_data.Var1, 'Start-x') | contains(csv_data.Var1, 'Start-y') | contains(csv_data.Var1, 'Finish-x') | contains(csv_data.Var1, 'Finish-y') | contains(csv_data.Var1, 'Distant-increment') | contains(csv_data.Var1, 'Z-depth') | contains(csv_data.Var1, 'Z-increment'), 2}; % 断面データ
    
            % FCOMMENTに該当するコメント列を処理
            comment_idx = find(contains(csv_data.Var1, 'Comment')); % "Comment"というタイトルの列を見つける
            if ~isempty(comment_idx)
                INPUT_VARS.FCOMMENT = csv_data{comment_idx, 2}; % コメントデータをFCOMMENTに格納
            else
                INPUT_VARS.FCOMMENT = []; % コメントがない場合は空にする
            end
            
        catch ME
            disp(['Error processing CSV file: ' ME.message]);
            return;
        end
    else
        % ------------------その他のファイル形式の処理------------------
        % ASCII or MATファイルの処理
        try
            load(fullfile(pathname, filename)); % .matファイルを読み込む
        catch
            try
                fid = fopen(fullfile(pathname, filename),'r');
                if fid == -1
                    errordlg('The file might be corrupted or wrong one');
                    return;
                end
            catch
                errordlg('The file might be corrupted. Check the content.');
                return;
            end
        end
        
        % --------------.matファイルの場合の処理の読み込み処理-----------------
        if isempty(INPUT_VARS.HEAD) ~= 1
            disp('mat formatted file was read.');
            if size(SYSTEM_VARS.PREF,1)==8
                dummy = SYSTEM_VARS.PREF;
                SYSTEM_VARS.PREF  = [dummy; [0.9 0.9 0.1 1.0]];
            end
            calc_element; % 基本情報を計算
            if N == 1
                H_INPUT = input_window;
            end
            SYSTEM_VARS.PREF_DIR   = pathname;
            SYSTEM_VARS.INPUT_FILE = filename;
            cd(SYSTEM_VARS.HOME_DIR);
            CALC_CONTROL.INUM = repmat(uint8(1),1,1);
            return
        end
    
        % --------------ASCIIファイルの読み込み処理-----------------
        SYSTEM_VARS.PREF_DIR   = pathname;
        SYSTEM_VARS.INPUT_FILE = filename;
        cd(SYSTEM_VARS.HOME_DIR);
    
        % デフォルトの断層番号
        INPUT_VARS.INUM = repmat(int16(1),1,1);
    
        % Nが2でない場合、つまり既存のファイルを開く場合
        if N~=2
            % ヘッダ情報の読み込み
            sp = ' ';
            head1 = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1);
            head1{:};
            head2 = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1);
            head2{:};
            a = [head1{:};head2{:}];
            b1 = char(a(1,:));  
            c1 = cellstr([deblank(b1(5,:)) sp deblank(b1(6,:)) sp deblank(b1(9,:)) sp...
                deblank(b1(10,:)) sp deblank(b1(11,:)) sp deblank(b1(12,:)) sp...
                deblank(b1(13,:)) sp deblank(b1(14,:)) sp deblank(b1(15,:))]);    
            b2 = char(a(2,:));
            c2 = cellstr([deblank(b2(5,:)) sp deblank(b2(6,:)) sp deblank(b2(9,:)) sp...
                deblank(b2(10,:)) sp deblank(b2(11,:)) sp deblank(b2(12,:)) sp...
                deblank(b2(13,:)) sp deblank(b2(14,:)) sp deblank(b2(15,:))]);
            INPUT_VARS.HEAD = [c1; c2];
    
            % 断層数の読み込み
            d = textscan(fid,'%*s %*s %*s %*s %*s %4u16 %*s %*s',1);
            INPUT_VARS.NUM = int32([d{1}]) + num_buffer; % 最大の要素数は65,535
    
            % ポアソン比と計算深度の読み込み
            e = textscan(fid,'%*s %15.3f32 %*s %*s %*s %*s',1); % PR2は読み込まない
            INPUT_VARS.POIS = double([e{1}]);
            INPUT_VARS.CALC_DEPTH = double([e{2}]);
    
            % ヤング率の読み込み
            f = textscan(fid,'%*s %n %*s',1); % E2は読み込まない
            INPUT_VARS.YOUNG = double([f{1}]);
    
            % 摩擦係数の読み込み
            h = textscan(fid,'%*s %15.3f32', 1);
            INPUT_VARS.FRIC = double([h{1}]);
    
            % 広域応力場の読み込み
            s = textscan(fid,'%*s %15.6f32 %*s %15.6f32 %*s %15.6f32 %*s %15.6f32',3);
            INPUT_VARS.R_STRESS = [s{:}];
    
            % スリップ成分のタイプを検出（通常は「right-lat」と「reverse」）
            dum0 = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
            CALC_CONTROL.IRAKE = 0;
            CALC_CONTROL.IND_RAKE = [];
            for k = 1:20
                if isempty(strmatch('rake',dum0{k}(:))) ~= 1
                    CALC_CONTROL.IRAKE = 1;
                end
            end
    
            % ファイルの読み込み処理続行（要素の読み込みなど）
            dum = textscan(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',1);
            flt = textscan(fid,'%3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %s %s %s %s %s %s %s %s %s %s', INPUT_VARS.NUM);
            INPUT_VARS.ID = uint16([flt{1}]);
            if length(INPUT_VARS.ID) ~= INPUT_VARS.NUM - num_buffer
                disp('************************************************************************');
                disp('**  Please change #fixed in the 3rd row in the input file afterward.  **');
                disp('**  入力ファイルの3行目の#fixedを後で変更してください。  **');
                disp('************************************************************************');
            end
            INPUT_VARS.NUM = length(INPUT_VARS.ID);
            INPUT_VARS.KODE = uint16([flt{6}]);
            INPUT_VARS.ELEMENT = [flt{2:5} flt{7:11}];
            INPUT_VARS.ELEMENT = double(INPUT_VARS.ELEMENT);
    
            % 要素に付属するコメントの読み込み
            a = [flt{12:21}];
            for k = 1:INPUT_VARS.NUM
                b = char(a(k,:));
                c = cellstr([deblank(b(1,:)) sp deblank(b(2,:)) sp deblank(b(3,:)) ...
                    sp deblank(b(4,:)) sp deblank(b(5,:)) sp deblank(b(6,:)) ...
                    sp deblank(b(7,:)) sp deblank(b(8,:)) sp deblank(b(9,:))]);    
                    INPUT_VARS.FCOMMENT(k).ref = c;
            end
    
            % グリッドパラメータの読み込み
            dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
            gr = textscan(fid,'%*45c %16.7f32',6);
            INPUT_VARS.GRID = double([gr{:}]);
    
            % サイズの読み込み
            dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
            sz = textscan(fid,'%*45c %16.7f32',3);
            INPUT_VARS.SIZE = [sz{:}];
    
            % 断面データの読み込み
            dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
            cs = textscan(fid,'%*45c %16.7f32',7);
            INPUT_VARS.SECTION = [cs{:}];
            if isempty(INPUT_VARS.SECTION) == 1
                disp('No info for a cross section line is included in the input file.');
            end
    
            % 地図情報の読み込み
            dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
            mi = textscan(fid,'%*45c %16.7f32',6);
            mapinfo = double([mi{:}]);
            if isempty(mapinfo) ~= 1
                COORD_VARS.MIN_LON = mapinfo(1,1);
                COORD_VARS.MAX_LON = mapinfo(2,1);
                COORD_VARS.ZERO_LON = mapinfo(3,1);
                COORD_VARS.MIN_LAT = mapinfo(4,1);
                COORD_VARS.MAX_LAT = mapinfo(5,1);
                COORD_VARS.ZERO_LAT = mapinfo(6,1);
            else
                disp('No lat. & lon. information is included in the input file.');
            end
    
            % ------------------すべてのパラメータが正しく読み込まれたかをチェック--------------------
            % エラーチェック
            check_input_field(INPUT_VARS.NUM, 'Number of faults is not read. Make sure the input file.');
            check_input_field(INPUT_VARS.POIS, 'Poisson ratio is not read. Make sure the input file.');
            check_input_field(INPUT_VARS.YOUNG, 'Young modulus is not read. Make sure the input file.');
            check_input_field(INPUT_VARS.FRIC, 'Coefficient of friction is not read. Make sure the input file.');
            check_input_field(INPUT_VARS.R_STRESS, 'Regional stress values are not read. Make sure the input file.');
            check_input_field(INPUT_VARS.GRID, 'Grid info for study area is not read properly. Make sure the input file.');
            fclose(fid); % ファイルを閉じる
            clear a b1 b2 c1 c2 d e f g h s dum flt gr sz cd mi;
    
        end
    
        % "rake"と"net slip"のタイプを"right-lat"と"reverse"タイプに変更する処理
        if CALC_CONTROL.IRAKE == 1
            if mean(INPUT_VARS.KODE) == 100
                count = 0;
                for j = 1:INPUT_VARS.NUM
                    for i = 1:INPUT_VARS.ID(j)
                        count = count + 1;
                        CALC_CONTROL.IND_RAKE(count,1) = INPUT_VARS.ELEMENT(j,5); % rake情報を保持
                    end
                end
                [INPUT_VARS.ELEMENT(:,5), INPUT_VARS.ELEMENT(:,6)] = rake2comp(INPUT_VARS.ELEMENT(:,5), INPUT_VARS.ELEMENT(:,6));
            else
                h = warndlg('Rake & net slip style should be with Kode 100','!! Warning !!');
                waitfor(h);
                return
            end
        end
    end
    
    % 基本情報の計算
    calc_element;
    if ~isempty(INPUT_VARS.SECTION)
       a = xy2lonlat([INPUT_VARS.SECTION(1), INPUT_VARS.SECTION(2)]);
       SECTION_VARS.SEC_XS = a(1,1);          
       SECTION_VARS.SEC_XF = a(1,2);
       a = xy2lonlat([INPUT_VARS.SECTION(3), INPUT_VARS.SECTION(4)]);
       SECTION_VARS.SEC_YS = a(1,1); 
       SECTION_VARS.SEC_YF = a(1,2);
       SECTION_VARS.SEC_INCRE = INPUT_VARS.SECTION(5);
       SECTION_VARS.SEC_DEPTH = INPUT_VARS.SECTION(6);
       SECTION_VARS.SEC_DEPTHINC = INPUT_VARS.SECTION(7);
       SECTION_VARS.SEC_DIP = 90.0;
       SECTION_VARS.SEC_DOWNDIP_INC = INPUT_VARS.SECTION(7);
    end
    
    if N == 1
        % 入力ウィンドウダイアログを開く
        H_INPUT = input_window;
    end
    
    % モーメントの計算を行う
    seis_moment;
    disp('---> To calculate deformation, select one of the submenus from ''Functions''.');
    disp(' ');
end

% ------------------すべてのパラメータが正しく読み込まれたかをチェック--------------------
% ---- ネスト関数の定義（親関数の最後に置く） ----
function check_input_field(field, message)
    if isempty(field)
        errordlg(message);
        return;
    end
end