function varargout = change_study_area_window(varargin)
% この関数は、研究対象領域を変更するためのGUIを管理します。
% GUIはシングルトン（単一インスタンス）として動作し、既存のウィンドウがあればそれをアクティブにします。

% GUIの初期化コード - 編集しないでください。-----------------------------------
% GUIのシングルトンモードを設定
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...                            % 現在のファイル名を指定
                   'gui_Singleton',  gui_Singleton, ...                        % シングルトンモードかどうかを指定
                   'gui_OpeningFcn', @change_study_area_window_OpeningFcn, ... % GUIオープン時に実行される関数を指定
                   'gui_OutputFcn',  @change_study_area_window_OutputFcn, ...  % GUIの出力時に実行される関数を指定
                   'gui_LayoutFcn',  [] , ...                                  % GUIのレイアウト関数を指定
                   'gui_Callback',   []);                                      % GUIのコールバック関数を指定

% コールバック関数が指定されている場合、その関数を設定
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% 出力が要求されている場合、GUIを実行して出力を返す
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% 出力が要求されていない場合、GUIを実行するだけ
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初期化コードの終了 - 編集しないでください。---------------------------------


% --- change_study_area_windowが表示される直前に実行されます。
function change_study_area_window_OpeningFcn(hObject, eventdata, handles, varargin)
% change_study_area_windowが表示される直前に実行されます。

% change_study_area_windowのデフォルトのコマンドライン出力を設定
handles.output = hObject;

% ハンドル構造の更新
guidata(hObject, handles);

% 元のデータを保存するためのグローバル変数を初期化
global TEMP_ELEMENT NUM ELEMENT TEMP_GRID GRID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global MIN_LON MAX_LON MIN_LAT MAX_LAT

% オリジナルデータを保存
TEMP_ELEMENT = zeros(NUM,4,'double');                         % 断層要素の一時保存領域
TEMP_GRID    = zeros(6,1,'double');                           % グリッドデータの一時保存領域
TEMP_ELEMENT(:,1:2) = xy2lonlat([ELEMENT(:,1) ELEMENT(:,2)]); % 断層要素の一時保存領域（x, y座標を緯度・経度に変換して保存）
TEMP_ELEMENT(:,3:4) = xy2lonlat([ELEMENT(:,3) ELEMENT(:,4)]); % 断層要素の一時保存領域（x, y座標を緯度・経度に変換して保存）
TEMP_GRID    = GRID;                                          % グリッドデータを一時保存
TEMP_MINLON = MIN_LON;                                        % 最小経度を一時保存
TEMP_MAXLON = MAX_LON;                                        % 最大経度を一時保存
TEMP_MINLAT = MIN_LAT;                                        % 最小緯度を一時保存
TEMP_MAXLAT = MAX_LAT;                                        % 最大緯度を一時保存

% --- この関数の出力はコマンドラインに返されます。
function varargout = change_study_area_window_OutputFcn(hObject, eventdata, handles) 

% ハンドル構造体からデフォルトのコマンドライン出力を取得し、返す
varargout{1} = handles.output;


%-------------------------------------------------------------------------
%   MIN LON / MIN X (テキストフィールド)
%-------------------------------------------------------------------------
function edit_minlon_rev_Callback(hObject, eventdata, handles)
% 最小経度の入力が変更されたときに呼び出される関数

global TEMP_MINLON ICOORD LON_GRID TEMP_GRID
global TEMP_MINLAT TEMP_MAXLAT GRID MIN_LON

% UTM座標系での処理
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    x = str2double(get(hObject,'String'));
    a1 = lonlat2xy([x TEMP_MINLAT]);
    a2 = lonlat2xy([x TEMP_MAXLAT]);
    GRID(1) = (a1(1) + a2(1))/2.0;         % グリッドの最小X座標を更新
    MIN_LON = x;
    set(hObject,'String',num2str(MIN_LON,'%8.3f')); % テキストフィールドに反映
% 通常の経度・緯度での処理
else
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([x TEMP_GRID(2)]);
        a2 = xy2lonlat([x TEMP_GRID(4)]);
        MIN_LON = (a1(1) + a2(1))/2.0; % グリッドから経度を推定
    end
	GRID(1) = x; % グリッドの最小X座標を更新
    set(hObject,'String',num2str(GRID(1),'%8.3f')); % テキストフィールドに反映
end

% --- オブジェクトの作成時に実行されます。
function edit_minlon_rev_CreateFcn(hObject, eventdata, handles)
% 最小経度入力フィールドの初期設定

global TEMP_MINLON MIN_LON GRID ICOORD LON_GRID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windowsの場合）
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MIN_LON,'%8.3f')); % 初期値として最小経度を表示
    TEMP_MINLON = MIN_LON;                          % 一時保存用変数に最小経度を保存
else
    set(hObject,'String',num2str(GRID(1),'%8.3f')); % 初期値としてグリッドの最小X座標を表示
end

%-------------------------------------------------------------------------
%   MAX LON / MAX X (テキストフィールド)
%-------------------------------------------------------------------------
function edit_maxlon_rev_Callback(hObject, eventdata, handles)
% 最大経度の入力が変更されたときに呼び出される関数

global TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global GRID ICOORD LON_GRID TEMP_GRID MAX_LON

% UTM座標系での処理
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    x = str2double(get(hObject,'String'));
    a1 = lonlat2xy([x TEMP_MINLAT]);
    a2 = lonlat2xy([x TEMP_MAXLAT]);
    GRID(3) = (a1(1) + a2(1))/2.0;                  % グリッドの最大X座標を更新
    MAX_LON = x;                                    % 最大経度を更新
    set(hObject,'String',num2str(MAX_LON,'%8.3f')); % テキストフィールドに反映
% 通常の経度・緯度での処理
else
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([x TEMP_GRID(2)]);
        a2 = xy2lonlat([x TEMP_GRID(4)]);
        MAX_LON = (a1(1) + a2(1))/2.0;    % グリッドから経度を推定
    end
    GRID(3) = x; % グリッドの最大X座標を更新
    set(hObject,'String',num2str(GRID(3),'%8.3f')); % テキストフィールドに反映
end

% --- オブジェクトの作成時に実行されます。
function edit_maxlon_rev_CreateFcn(hObject, eventdata, handles)
% 最大経度入力フィールドの初期設定

global TEMP_MAXLON MAX_LON GRID ICOORD LON_GRID

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windowsの場合）
end

if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MAX_LON,'%8.3f')); % 初期値として最大経度を表示
    TEMP_MAXLON = MAX_LON;                          % 一時保存用変数に最大経度を保存
else
    set(hObject,'String',num2str(GRID(3),'%8.3f')); % 初期値としてグリッドの最大X座標を表示   
end

%-------------------------------------------------------------------------
%   MIN LAT / MIN Y (テキストフィールド)
%-------------------------------------------------------------------------
function edit_minlat_rev_Callback(hObject, eventdata, handles)
% 最小緯度の入力が変更されたときに呼び出される関数

global TEMP_MINLAT GRID ICOORD LON_GRID TEMP_GRID
global TEMP_MINLON TEMP_MAXLON MIN_LAT

% UTM座標系での処理
if ICOORD == 2 && isempty(LON_GRID) ~= 1
        x = str2double(get(hObject,'String'));
        a1 = lonlat2xy([TEMP_MINLON x]);
        a2 = lonlat2xy([TEMP_MAXLON x]);
        GRID(2) = (a1(2) + a2(2))/2.0;              % グリッドの最小Y座標を更新
    MIN_LAT = x;                                    % 最小緯度を更新
    set(hObject,'String',num2str(MIN_LAT,'%8.3f')); % テキストフィールドに反映
% 通常の経度・緯度での処理
else
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([TEMP_GRID(1) x]);
        a2 = xy2lonlat([TEMP_GRID(3) x]);
        MIN_LAT = (a1(2) + a2(2))/2.0;              % グリッドから緯度を推定
    end
    GRID(2) = x;                                    % グリッドの最小Y座標を更新
    set(hObject,'String',num2str(GRID(2),'%8.3f')); % テキストフィールドに反映
end

% --- オブジェクトの作成時に実行されます。
function edit_minlat_rev_CreateFcn(hObject, eventdata, handles)
% 最小緯度入力フィールドの初期設定

global TEMP_MINLAT MIN_LAT GRID ICOORD LON_GRID

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windowsの場合）
end

if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MIN_LAT,'%8.3f')); % 初期値として最小緯度を表示
    TEMP_MINLAT = MIN_LAT;                          % 一時保存用変数に最小緯度を保存
else
    set(hObject,'String',num2str(GRID(2),'%8.3f')); % 初期値としてグリッドの最小Y座標を表示
end

%-------------------------------------------------------------------------
%   MAX LAT / MAX Y (テキストフィールド)
%-------------------------------------------------------------------------
function edit_maxlat_rev_Callback(hObject, eventdata, handles)
% 最大緯度の入力が変更されたときに呼び出される関数

global TEMP_MAXLAT TEMP_MINLON TEMP_MAXLON
global GRID ICOORD LON_GRID TEMP_GRID MAX_LAT

% UTM座標系での処理
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    x = str2double(get(hObject,'String'));
    a1 = lonlat2xy([TEMP_MINLON x]);
    a2 = lonlat2xy([TEMP_MAXLON x]);
    GRID(4) = (a1(2) + a2(2))/2.0;                  % グリッドの最大Y座標を更新
    MAX_LAT = x;                                    % 最大緯度を更新
    set(hObject,'String',num2str(MAX_LAT,'%8.3f')); % テキストフィールドに反映
% 通常の経度・緯度での処理
else   
    x = str2double(get(hObject,'String'));
    if isempty(LON_GRID) ~= 1
        a1 = xy2lonlat([TEMP_GRID(1) x]);
        a2 = xy2lonlat([TEMP_GRID(3) x]);
        MAX_LAT = (a1(2) + a2(2))/2.0;              % グリッドから緯度を推定
    end
    GRID(4) = x;                                    % グリッドの最大Y座標を更新
    set(hObject,'String',num2str(GRID(4),'%8.3f')); % テキストフィールドに反映
end

% --- オブジェクトの作成時に実行されます。
function edit_maxlat_rev_CreateFcn(hObject, eventdata, handles)
% 最大緯度入力フィールドの初期設定

global TEMP_MAXLAT MAX_LAT GRID ICOORD LON_GRID

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); % 背景色を白に設定（Windowsの場合）
end
if ICOORD == 2 && isempty(LON_GRID) ~= 1
    set(hObject,'String',num2str(MAX_LAT,'%8.3f')); % 初期値として最大緯度を表示
    TEMP_MAXLAT = MAX_LAT;                          % 一時保存用変数に最大緯度を保存
else
    set(hObject,'String',num2str(GRID(4),'%8.3f')); % 初期値としてグリッドの最大Y座標を表示
end

%-------------------------------------------------------------------------
%   OK (プッシュボタン)
%-------------------------------------------------------------------------
function pushbutton_ok_rev_Callback(hObject, eventdata, handles)
% OKボタンが押されたときに呼び出される関数

global ELEMENT KODE NUM FCOMMENT
global MIN_LON MAX_LON MIN_LAT MAX_LAT
global TEMP_ELEMENT GRID ID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT TEMP_GRID
global ICOORD LON_GRID IND_RAKE

% 新しい領域外の断層要素を削除するかどうかを尋ねるダイアログ
button = questdlg('Remove fault elements info out of the new area?','Remove fault?','Yes','No','default');
% 削除しない場合、ウィンドウを閉じる
if strcmp(button,'No')
    h = figure(gcf);
    delete(h);
% 削除する場合、領域外の断層要素を削除
elseif strcmp(button,'Yes')    
    flag = zeros(NUM,1,'int8');
    % UTM座標系での処理
    if ICOORD == 2 && isempty(LON_GRID) ~= 1
        for k = 1:NUM
            a = (TEMP_ELEMENT(k,2)-TEMP_ELEMENT(k,4))/(TEMP_ELEMENT(k,1)-TEMP_ELEMENT(k,3));
            b = TEMP_ELEMENT(k,2) - a * TEMP_ELEMENT(k,1);
            x1 = TEMP_MINLON;           y1 = a * TEMP_MINLON + b;
            x2 = TEMP_MAXLON;           y2 = a * TEMP_MAXLON + b;
            x3 = (TEMP_MINLAT - b) / a; y3 = TEMP_MINLAT;
            x4 = (TEMP_MAXLAT - b) / a; y4 = TEMP_MAXLAT;
            if TEMP_ELEMENT(k,1) <= TEMP_MAXLON && TEMP_ELEMENT(k,1) >= TEMP_MINLON...
                    && TEMP_ELEMENT(k,2) <= TEMP_MAXLAT && TEMP_ELEMENT(k,2) >= TEMP_MINLAT
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif TEMP_ELEMENT(k,3) <= TEMP_MAXLON && TEMP_ELEMENT(k,3) >= TEMP_MINLON...
                    && TEMP_ELEMENT(k,4) <= TEMP_MAXLAT && TEMP_ELEMENT(k,4) >= TEMP_MINLAT
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y1 <= TEMP_ELEMENT(k,4) && y1 >= TEMP_ELEMENT(k,2)...
                    && x1 <= TEMP_ELEMENT(k,3) && x1 >= TEMP_ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y2 <= TEMP_ELEMENT(k,4) && y2 >= TEMP_ELEMENT(k,2)...
                    && x2 <= TEMP_ELEMENT(k,3) && x2 >= TEMP_ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y3 <= TEMP_ELEMENT(k,4) && y3 >= TEMP_ELEMENT(k,2)...
                    && x3 <= TEMP_ELEMENT(k,3) && x3 >= TEMP_ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y4 <= TEMP_ELEMENT(k,4) && y4 >= TEMP_ELEMENT(k,2)...
                    && x4 <= TEMP_ELEMENT(k,3) && x4 >= TEMP_ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            end
        end
    % 通常のXYグリッド（デカルト座標系）での処理
    else 
        for k = 1:NUM
            a = (ELEMENT(k,2)-ELEMENT(k,4))/(ELEMENT(k,1)-ELEMENT(k,3));
            b = ELEMENT(k,2) - a * ELEMENT(k,1);
            x1 = GRID(1);           y1 = a * GRID(1) + b;
            x2 = GRID(3);           y2 = a * GRID(3) + b;
            x3 = (GRID(2) - b) / a; y3 = GRID(2);
            x4 = (GRID(4) - b) / a; y4 = GRID(4);
            if ELEMENT(k,1) <= GRID(3) && ELEMENT(k,1) >= GRID(1)...
                    && ELEMENT(k,2) <= GRID(4) && ELEMENT(k,2) >= GRID(2)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif ELEMENT(k,3) <= GRID(3) && ELEMENT(k,3) >= GRID(1)...
                    && ELEMENT(k,4) <= GRID(4) && ELEMENT(k,4) >= GRID(2)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y1 <= ELEMENT(k,4) && y1 >= ELEMENT(k,2)...
                    && x1 <= ELEMENT(k,3) && x1 >= ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y2 <= ELEMENT(k,4) && y2 >= ELEMENT(k,2)...
                    && x2 <= ELEMENT(k,3) && x2 >= ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y3 <= ELEMENT(k,4) && y3 >= ELEMENT(k,2)...
                    && x3 <= ELEMENT(k,3) && x3 >= ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            elseif y4 <= ELEMENT(k,4) && y4 >= ELEMENT(k,2)...
                    && x4 <= ELEMENT(k,3) && x4 >= ELEMENT(k,1)
                flag(k) = 1; % 領域内の断層要素をマーク
                continue;
            end
        end
    end

    % フラグが立っている要素だけを新しいリストに追加
    num_new = sum(flag); % 新しい要素数を計算
    kode_new = zeros(num_new,1,'int16');
    id_new = zeros(num_new,1,'int16');
    element_new = zeros(num_new,9,'double');
    fcomment_new = struct('ref',[]);
    if ~isempty(IND_RAKE)
        ind_rake_new = zeros(num_new,1,'double');
    end
    count = 0;
    for k = 1:NUM
            if flag(k)==1
                count = count + 1;
                kode_new(count) = KODE(k);
                id_new(count) = ID(k);
                element_new(count,:) = ELEMENT(k,:);
                if ~isempty(IND_RAKE)
                    ind_rake_new(count) = IND_RAKE(k);
                end
                fcomment_new(count).ref = FCOMMENT(k).ref;
            end
    end

    % 新しいデータをグローバル変数に反映
    KODE = zeros(num_new,1,'int16');
    KODE = kode_new;
    ID = zeros(num_new,1,'int16');
    ID = id_new;
    ELEMENT = zeros(num_new,9,'double');
    ELEMENT = element_new;
    if ~isempty(IND_RAKE)
        IND_RAKE = zeros(num_new,1,'double');
        IND_RAKE = ind_rake_new;
    end
    FCOMMENT = struct('ref',[]);
    FCOMMENT = fcomment_new;
    NUM = num_new; % 新しい要素数を更新

    h = figure(gcf);
    delete(h); % ウィンドウを閉じる
end


%-------------------------------------------------------------------------
%   Cancel (プッシュボタン)
%-------------------------------------------------------------------------
function pushbutton_cancel_rev_Callback(hObject, eventdata, handles)
% キャンセルボタンが押されたときに呼び出される関数

global TEMP_ELEMENT NUM ELEMENT TEMP_GRID GRID
global TEMP_MINLON TEMP_MAXLON TEMP_MINLAT TEMP_MAXLAT
global MIN_LON MAX_LON MIN_LAT MAX_LAT

% 元のデータに戻す処理
GRID    = TEMP_GRID;
MIN_LON = TEMP_MINLON;
MAX_LON = TEMP_MAXLON;
MIN_LAT = TEMP_MINLAT;
MAX_LAT = TEMP_MAXLAT;

% ウィンドウを閉じる
h = figure(gcf);
delete(h);

