function coulomb2gmt(varargin)
% coulomb2gmt 関数は、日付、ファイル名、その他の情報を記述したスタンプを生成し、それを基にGMTスクリプトを作成します。
% AuthorizedOptions = {'SoftwareVersion',...
%                     'FileName',...
%                     'FunctionType',...
%                     'ProjectionType',...
%                     'StudyArea',...
%                     'MapSize',...
%                     'XShift',...
%                     'YShift'};

% 認証済みのオプションを定義
AuthorizedOptions = {'SoftwareVersion',...
                    'FileName',...
                    'Title',...
                    'FunctionType',...
                    'ProjectionType',...
                    'StudyArea',...
                    'MapSize',...
                    'XShift',...
                    'YShift',...
                    'XIncrement',...
                    'YIncrement',...
                    'FaultClip',... % 断層線のクリップデータ（経度・緯度）
                    'OutputFName'};

% ユーザーからの入力パラメータを検証
for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        error(['Unauthorized parameter name ' 39 varargin{k} 39 'in' 21,...
            'parameter/value passed to ' 39 mfilename 39 '.']);
    end
end


% --- デフォルト値の設定 ----------------
SoftwareVersion = '3.X.X';      % ソフトウェアのバージョン
FileName        = 'Untitled';   % ファイル名
Title           = 'Untitled';   % タイトル
FunctionType    = 1;             % 関数の種類
StressType      = 5;             % ストレスタイプ
ProjectionType  = 'JM';          % 投影法の種類（例: ジョンソン投影）
StudyArea       = '136.0/140.0/36.0/39.0'; % 研究領域の経度/緯度
MapSize         = 5;             % 地図のサイズ
XShift          = 0.0;           % X軸のシフト
YShift          = 0.0;           % Y軸のシフト
XIncrement      = 0.1;           % X軸の刻み（度）
YIncrement      = 0.1;           % Y軸の刻み（度）
Pen1            = '1/0/0/0';     % ペンのスタイル1
Pen2            = '2/255/1/1';   % ペンのスタイル2
LandColor       = '255/200/125'; % 陸地の色
SeaColor        = '80/130/180';  % 海の色
CoastlineRes    = 'Df';          % 海岸線の解像度
FaultClip       = [136.8 36.5; 137.7 37.9; 137.2 38.65; 139.0 38.3; 136.8 36.5]; % 断層線のクリップ座標
OutputFName     = 'out.gmt';     % 出力ファイル名
% -----------------------------------

% パラメータの解析
v = parse_pairs(varargin);  % 内部関数を呼び出してパラメータを解析
for j = 1:length(v)
    eval(v{j});             % 解析されたパラメータを変数に割り当て（MATLABコンパイラ用に変更の可能性あり）
end

%----- GMTスクリプトの書き込み --------------------------
% pscoastコマンドの作成
timestamp = date; % 現在の日付を取得
header1  = ['# GMT script converted from Coulomb ' timestamp];
pscoast1 = ['pscoast -R' StudyArea ' -' ProjectionType num2str(MapSize,'%3i') ' '];
pscoast2 = ['-G' LandColor ' -S' SeaColor ' -' CoastlineRes]; 
pscoast3 = [' -Ba1.0f0.5g0.1:"Longitude"::,"��":/a1.0f0.5g0.1:"Latitude"::,"��":'];
pscoastend = [' -K -P -U > out.ps'];
% ヘッダーを書き込む
dlmwrite(OutputFName, header1, 'delimiter','');
% pscoastコマンドを続けて書き込む
dlmwrite(OutputFName,[pscoast1 pscoast2 pscoast3 pscoastend],'-append','delimiter','');

% psxyコマンドで断層線をプロット
psxy1    = ['psxy -R -' ProjectionType ' -W' Pen2 ' -P -O -K << END >> out.ps'];
psxyend  = 'END';
% psxyコマンドの開始部分を書き込む
dlmwrite(OutputFName, psxy1, '-append', 'delimiter','');
% 断層線の座標を書き込む
dlmwrite(OutputFName, FaultClip, '-append', 'delimiter',' ');
% psxyコマンドの終了部分を書き込む
dlmwrite(OutputFName, psxyend, '-append', 'delimiter','');

%=======================================================================
function v = parse_pairs(pairs)
% parse_pairs 関数は、パラメータ/値のペアを解析し、評価可能な文字列を生成します
v = {}; 
for ii=1:2:length(pairs(:))  
    if isnumeric(pairs{ii+1})
        % 値が数値の場合
        str = [ pairs{ii} ' = ' num2str(pairs{ii+1}) ';'  ];
    else
        % 値が文字列の場合
        str = [ pairs{ii} ' = ' 39 pairs{ii+1} 39 ';'  ];
    end
    % 生成した文字列をセル配列に格納
    v{(ii+1)/2,1} = str;
end
