    function input_open(N)
    % Coulomb形式の入力ファイルを読み込む関数
    % input_open はCoulomb形式の入力ファイルをMATLABに読み込みます。
    %
    % Nは、ファイル内容を表示するかどうかを決定するための番号です。
    %   N=1: ダイアログを表示してパラメータの確認と変更を行う
    %   N=2: 新しいファイルを作成する
    %   N=3: ダイアログを表示せずにスキップする
    
    % グローバル変数の宣言（多数の設定やデータを格納する）
    global H_INPUT
    global INUM HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
    global FCOMMENT GRID SIZE SECTION
    global IACT IACTS
    global FLAG_SLIP_LINE
    global PREF_DIR HOME_DIR INPUT_FILE
    global MIN_LAT MAX_LAT ZERO_LAT MIN_LON MAX_LON ZERO_LON
    global COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA VOLCANO
    global S_ELEMENT
    global IRAKE % 入力ファイルのスタイルを示すフラグ (0: lateral/reverse, 1: rake/netslip)
    global IND_RAKE % 個々のrake情報を保持するための変数
    global DIALOG_SKIP % 入力ダイアログをスキップするかどうかの信号 (1: スキップ, その他: スキップしない)
    global PREF
    global SEC_XS SEC_XF SEC_YS SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
    global SEC_DIP SEC_DOWNDIP_INC
    global LAT_GRID LON_GRID
    
    % 初期化
    IACT  = 0;
    IACTS = 0;
    FLAG_SLIP_LINE = 0;
    num_buffer = 100; % NUMを調整するためのバッファ
    
    % ダイアログがスキップされていない場合、またはDIALOG_SKIPが空の場合
    if DIALOG_SKIP ~= 1 || isempty(DIALOG_SKIP)
        % デフォルトのディレクトリに移動する処理
        if isempty(PREF_DIR) ~= 1
            try
                cd(PREF_DIR);
            catch
                cd(HOME_DIR);
            end
        else
            try
                cd('input_files');
            catch
                cd(HOME_DIR);
            end
        end
        
        % ユーザーにファイルを選択させるダイアログを表示
        try
            [filename,pathname] = uigetfile( ...
                    {'*.inp;*.inr;*.mat','Open input file (*.inp,*.inr,*.mat)'; ...
                     '*.inp',  'ascii input (*.inp)'; ...
                     '*.inr',  'ascii input (*.inr)'; ...
                     '*.mat','binary input (*.mat)'}, ...
                     'Pick a file');
            % キャンセルが選択された場合の処理
            if isequal(filename,0)
                disp('---------------------------------------------------');
                disp('User selected Cancel');
                cd(HOME_DIR);
                IACT = 1; % 前回のセッション情報を保持するため
                return
            else
                disp('---------------------------------------------------');
                disp(['User selected', fullfile(pathname, filename)]);
            end
        catch
            errordlg('ファイル形式が正しくない可能性があります。');
            return;
        end
    else
        % DIALOG_SKIPが1のとき、つまり直前の入力ファイルを再読み込みする場合
        pathname = PREF_DIR;
        filename = INPUT_FILE;
        if strcmp(filename,'empty')
            disp('最近使用されたファイルがありません。メニューから既存の入力ファイルを開いてください。');
            return
        end
        disp('---------------------------------------------------');
        disp(['User selected', fullfile(pathname, filename)]);
    end
    
    % 初期化（以前のセッションのデータをリセット）
    HEAD=[]; NUM=[]; POIS=[]; CALC_DEPTH=[]; YOUNG=[];
    FRIC=[]; R_STRESS=[]; ID=[]; KODE=[]; ELEMENT=[];
    FCOMMENT=[]; GRID=[]; SIZE=[]; SECTION=[];
    MIN_LAT = []; MAX_LAT = []; ZERO_LAT = [];
    MIN_LON = []; MAX_LON = []; ZERO_LON = [];
    COAST_DATA = []; AFAULT_DATA = []; EQ_DATA = []; VOLCANO = [];
    GPS_DATA = []; S_ELEMENT = [];
    LAT_GRID = []; LON_GRID = [];
    
    % ファイルの読み込み（.matファイルの場合）
    try
        load(fullfile(pathname, filename)); % .matファイルを読み込む
    catch
        % ASCIIファイルの場合
        try
            fid = fopen(fullfile(pathname, filename),'r'); % ASCIIファイルを開く
        catch
            errordlg('ファイルが破損しているか、形式が間違っている可能性があります。');
            return;
        end
    end
    
    % .matファイルの場合の処理
    if isempty(HEAD) ~= 1
        disp('mat形式のファイルが読み込まれました。');
        if size(PREF,1)==8
            dummy = PREF;
            PREF  = [dummy; [0.9 0.9 0.1 1.0]];
        end
        calc_element; % 基本情報を計算
        if N == 1
            H_INPUT = input_window;
        end
        PREF_DIR   = pathname;
        INPUT_FILE = filename;
        cd(HOME_DIR);
        INUM = repmat(uint8(1),1,1);
        return
    end
    
    % ASCIIファイルの読み込み処理
    PREF_DIR   = pathname;
    INPUT_FILE = filename;
    cd(HOME_DIR);
    
    % デフォルトの断層番号
    INUM = repmat(int16(1),1,1);
    
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
        c1 = cellstr([deblank(b1(1,:)) sp deblank(b1(2,:)) sp deblank(b1(3,:)) ...
            sp deblank(b1(4,:)) sp deblank(b1(5,:)) sp deblank(b1(6,:)) ...
            sp deblank(b1(7,:)) sp deblank(b1(8,:)) sp deblank(b1(9,:)) ...
            sp deblank(b1(10,:)) sp deblank(b1(11,:)) sp deblank(b1(12,:)) ...
            sp deblank(b1(13,:)) sp deblank(b1(14,:)) sp deblank(b1(15,:))]);    
        b2 = char(a(2,:));
        c2 = cellstr([deblank(b2(1,:)) sp deblank(b2(2,:)) sp deblank(b2(3,:)) ...
            sp deblank(b2(4,:)) sp deblank(b2(5,:)) sp deblank(b2(6,:)) ...
            sp deblank(b2(7,:)) sp deblank(b2(8,:)) sp deblank(b2(9,:)) ...
            sp deblank(b2(10,:)) sp deblank(b2(11,:)) sp deblank(b2(12,:)) ...
            sp deblank(b2(13,:)) sp deblank(b2(14,:)) sp deblank(b2(15,:))]);
        HEAD = [c1; c2];
    
        % 断層数の読み込み
        d = textscan(fid,'%*s %*s %*s %*s %*s %4u16 %*s %*s',1);
        NUM = int32([d{1}]) + num_buffer; % 最大の要素数は65,535
    
        % ポアソン比と計算深度の読み込み
        e = textscan(fid,'%*s %15.3f32 %*s %*s %*s %15.3f32',1);
        POIS = double([e{1}]);
        CALC_DEPTH = double([e{2}]);
    
        % ヤング率の読み込み
        f = textscan(fid,'%*s %n %*s %*s',1);
        YOUNG = double([f{1}]);
    
        % 対称性パラメータ（Coulombでは使用されない）の読み込み
        g = textscan(fid,'%*s %*s %*s %*s', 1);
    
        % 摩擦係数の読み込み
        h = textscan(fid,'%*s %15.3f32', 1);
        FRIC = double([h{1}]);
    
        % 広域応力場の読み込み
        s = textscan(fid,'%*s %15.6f32 %*s %15.6f32 %*s %15.6f32 %*s %15.6f32',3);
        R_STRESS = [s{:}];
    
        % スリップ成分のタイプを検出（通常は「right-lat」と「reverse」）
        dum0 = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
        IRAKE = 0;
        IND_RAKE = [];
        for k = 1:20
            if isempty(strmatch('rake',dum0{k}(:))) ~= 1
                IRAKE = 1;
            end
        end

    % ファイルの読み込み処理続行（要素の読み込みなど）
    dum = textscan(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',1);
    flt = textscan(fid,...
        '%3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %3u16 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %10.9f32 %s %s %s %s %s %s %s %s %s %s', NUM);
    ID = uint16([flt{1}]);
    if length(ID) ~= NUM - num_buffer
        disp('************************************************************************');
        disp('**  入力ファイルの3行目の#fixedを後で変更してください。  **');
        disp('************************************************************************');
    end
    NUM = length(ID);
    KODE = uint16([flt{6}]);
    ELEMENT = [flt{2:5} flt{7:11}];
    ELEMENT = double(ELEMENT);

    % 要素に付属するコメントの読み込み
    a = [flt{12:21}];
    for k = 1:NUM
        b = char(a(k,:));
        c = cellstr([deblank(b(1,:)) sp deblank(b(2,:)) sp deblank(b(3,:)) ...
            sp deblank(b(4,:)) sp deblank(b(5,:)) sp deblank(b(6,:)) ...
            sp deblank(b(7,:)) sp deblank(b(8,:)) sp deblank(b(9,:))]);    
        FCOMMENT(k).ref = [c];
    end

    % グリッドパラメータの読み込み
    dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
    gr = textscan(fid,'%*45c %16.7f32',6);
    GRID = double([gr{:}]);

    % サイズの読み込み
    dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
    sz = textscan(fid,'%*45c %16.7f32',3);
    SIZE = [sz{:}];

    % 断面データの読み込み
    dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
    cs = textscan(fid,'%*45c %16.7f32',7);
    SECTION = [cs{:}];
    if isempty(SECTION) == 1
        disp('入力ファイルに断面情報が含まれていません。');
    end

    % 地図情報の読み込み
    dum = textscan(fid,'%*s %*s %*s %*s %*s %*s',1);
    mi = textscan(fid,'%*45c %16.7f32',6);
    mapinfo = double([mi{:}]);
    if isempty(mapinfo) ~= 1
        MIN_LON = mapinfo(1,1); MAX_LON = mapinfo(2,1); ZERO_LON = mapinfo(3,1);
        MIN_LAT = mapinfo(4,1); MAX_LAT = mapinfo(5,1); ZERO_LAT = mapinfo(6,1);
    else
        disp('入力ファイルに緯度・経度情報が含まれていません。');
    end

    % すべてのパラメータが正しく読み込まれたかをチェック
    if isempty(NUM) == 1
        errordlg('断層数が読み込まれていません。入力ファイルを確認してください。');
        return;
    end
    if isempty(POIS) == 1
        errordlg('ポアソン比が読み込まれていません。入力ファイルを確認してください。');
        return;
    end
    if isempty(YOUNG) == 1
        errordlg('ヤング率が読み込まれていません。入力ファイルを確認してください。');
        return;
    end
    if isempty(FRIC) == 1
        errordlg('摩擦係数が読み込まれていません。入力ファイルを確認してください。');
        return;
    end
    if isempty(R_STRESS) == 1
        errordlg('広域応力が読み込まれていません。入力ファイルを確認してください。');
        return;
    end
    if isempty(GRID) == 1
        errordlg('スタディエリアのグリッド情報が正しく読み込まれていません。入力ファイルを確認してください。');
        return;
    end
    fclose(fid); % ファイルを閉じる

    clear a b1 b2 c1 c2 d e f g h s dum flt gr sz cd mi;
end

% "rake"と"net slip"のタイプを"right-lat"と"reverse"タイプに変更する処理
if IRAKE == 1
    if mean(KODE) == 100
        count = 0;
        for j = 1:NUM
            for i = 1:ID(j)
                count = count + 1;
                IND_RAKE(count,1) = ELEMENT(j,5); % rake情報を保持
            end
        end
        [ELEMENT(:,5), ELEMENT(:,6)] = rake2comp(ELEMENT(:,5), ELEMENT(:,6));
    else
        h = warndlg('Rake & net slipスタイルはKode 100であるべきです', '!! Warning !!');
        waitfor(h);
        return
    end
end

% 基本情報の計算
calc_element;
if ~isempty(SECTION)
   a = xy2lonlat([SECTION(1), SECTION(2)]);
   SEC_XS = a(1,1);          
   SEC_XF = a(1,2);
   a = xy2lonlat([SECTION(3), SECTION(4)]);
   SEC_YS = a(1,1); 
   SEC_YF = a(1,2);
   SEC_INCRE = SECTION(5);
   SEC_DEPTH = SECTION(6);
   SEC_DEPTHINC = SECTION(7);
   SEC_DIP = 90.0;
   SEC_DOWNDIP_INC = SECTION(7);
end

if N == 1
    % 入力ウィンドウダイアログを開く
    H_INPUT = input_window;
end

% モーメントの計算を行う
seis_moment;
disp('---> 変形を計算するには、"Functions"メニューからサブメニューを選択してください。');
disp(' ');
