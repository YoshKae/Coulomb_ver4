function varargout = wait_calc_window(varargin)
    % WAIT_CALC_WINDOW: 計算中に表示される待機ウィンドウを作成するGUI関数
    % 初期設定と状態管理
    gui_Singleton = 1;
    gui_State = struct('gui_Name', mfilename, ...
                       'gui_Singleton', gui_Singleton, ...
                       'gui_OpeningFcn', @wait_calc_window_OpeningFcn, ...
                       'gui_OutputFcn', @wait_calc_window_OutputFcn, ...
                       'gui_LayoutFcn', [] , ...
                       'gui_Callback', []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
end

% --- wait_calc_window が可視化される前に実行される処理
function wait_calc_window_OpeningFcn(hObject, eventdata, handles, varargin)
    global SECTION_VARS

    % メインメニューウィンドウを取得
    h = findobj('Tag', 'wait_calc_window');
    j = get(h, 'Position');  % 現在のウィンドウサイズと位置を取得
    wind_width = j(3);  % ウィンドウの幅
    wind_height = j(4); % ウィンドウの高さ
    
    % メインメニューウィンドウの位置を基準に、待機ウィンドウの位置を調整
    dummy = findobj('Tag', 'main_menu_window2');
    if ~isempty(dummy)
        h = get(dummy, 'Position');
    end
    
    % ウィンドウの中心に待機ウィンドウを配置
    xpos = h(1) + h(3)/2 - wind_width/2 - SECTION_VARS.SCRW_X/2;
    ypos = h(2) + h(4)/2 - wind_height/2;
    set(hObject, 'Position', [xpos, ypos, wind_width, wind_height]);

    % コマンドライン出力のデフォルト値を設定
    handles.output = hObject;
    % ハンドル構造体を更新
    guidata(hObject, handles);
end

% --- この関数はコマンドラインから出力を返す際に使用される
function varargout = wait_calc_window_OutputFcn(hObject, eventdata, handles)
    % デフォルトのコマンドライン出力を返す
    varargout{1} = handles.output;
end
