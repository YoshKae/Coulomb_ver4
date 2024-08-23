% Coulomb応力のレンダリングを行うためのメインスクリプト

% すべての変数をクリア
clear all

global ha1 ha2
global x y z cl sigs sign xmin xmax xinc nxinc ymin ymax yinc nyinc % グリッドや計算に使用する変数
global cmin cmax cmean cc                                           % カラースケールの範囲を設定するための変数

N = 1;   % カラー飽和ストレス値のデフォルト設定
ha2 = 0; % figureウィンドウの初期値（0に設定）

ha1 = figure('Name','Coulomb rendering',...  % Coulomb応力のレンダリング用の新しいウィンドウを作成
    'NumberTitle','off',...  % ウィンドウのタイトルバーに番号を表示しない
    'Position',[100,300,330,100]);  % ウィンドウの位置とサイズを設定（左, 下, 幅, 高さ）


%===============Coulombデータを開くボタンの作成================
PBOpen1 = uicontrol(gcf,...            % 現在のウィンドウにUIコントロールを追加
    'Style','Pushbutton',...           % ボタンとして作成
    'Position',[20 50 80 20],...       % ボタンの位置とサイズを設定（左, 下, 幅, 高さ）
    'String','Open Coulomb',...        % ボタンに表示されるテキスト
    'Callback',...                     % ボタンが押されたときに実行されるコールバック関数を設定
    ['coulomb_button(''Open1'',N)']... % コールバック関数として `coulomb_button` 関数を呼び出す
    );


%===============入力データを開くボタンの作成================
PBOpen1 = uicontrol(gcf,...            % 現在のウィンドウにUIコントロールを追加
    'Style','Pushbutton',...           % ボタンとして作成
    'Position',[110 50 80 20],...      % ボタンの位置とサイズを設定（左, 下, 幅, 高さ）
    'String','Open Input',...          % ボタンに表示されるテキスト
    'Callback',...                     % ボタンが押されたときに実行されるコールバック関数を設定
    ['coulomb_button(''Open2'',N)']... % コールバック関数として `coulomb_button` 関数を呼び出す
    );


%===============終了ボタンの作成=================
PBExit = uicontrol(gcf,...            % 現在のウィンドウにUIコントロールを追加
    'Style','Pushbutton',...          % ボタンとして作成
    'Position',[200 50 50 20],...     % ボタンの位置とサイズを設定（左, 下, 幅, 高さ）
    'String','Exit',...               % ボタンに表示されるテキスト
    'Callback',...                    % ボタンが押されたときに実行されるコールバック関数を設定
    ['coulomb_button(''Exit'',N)']... % コールバック関数として `coulomb_button` 関数を呼び出す
    );


%===============カラー飽和値を設定するためのテキスト編集フィールドの作成================
EDColor = uicontrol(gcf,...                            % 現在のウィンドウにUIコントロールを追加
    'BackGroundColor','w',...                          % テキストフィールドの背景色を白に設定
    'Style','edit',...                                 % テキスト編集フィールドとして作成
    'String','5',...                                   % デフォルトのテキスト値を5に設定
    'Position',[280 20 20 20],...                      % テキストフィールドの位置とサイズを設定（左, 下, 幅, 高さ）
    'CallBack','N=str2num(get(EDColor,''String''))'... % コールバックでテキストの内容を数値に変換し、Nに格納
    );


%===============スライダーの作成================
SDbar = uicontrol(gcf,...           % 現在のウィンドウにUIコントロールを追加
    'Style','Slider',...            % スライダーとして作成
    'Position',[150 20 100 20],...  % スライダーの位置とサイズを設定（左, 下, 幅, 高さ）
    'Min',0,'Max',10,'Value',5,...  % スライダーの最小値、最大値、初期値を設定
    'Callback',...                  % スライダーの値が変更されたときに実行されるコールバック関数を設定
    'SDbar=get(SDbar,''Value'');coulomb_view(SDbar);set(SDbar,''Value'',SDbar)'...  % `coulomb_view` 関数で値を表示
    );

    
%===============テキストフィールドの横に配置する説明用のテキスト================
txt1 = uicontrol(gcf,...             % 現在のウィンドウにUIコントロールを追加
     'BackGroundColor','default',... % テキストの背景色をシステムデフォルトに設定
    'Style','Text',...               % テキストラベルとして作成
    'String','Saturation',...        % 表示するテキスト
    'Position',[20 20 80 10],...     % テキストラベルの位置とサイズを設定（左, 下, 幅, 高さ）
    'HorizontalAlignment','left'...  % テキストの配置を左揃えに設定
    );
