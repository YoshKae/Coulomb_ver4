function varargout = grid_input_window2(varargin)

% 初期化コード - 編集禁止
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @grid_input_window_OpeningFcn, ...
                   'gui_OutputFcn',  @grid_input_window_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Opening Function グリッド入力ウィンドウが表示される直前に実行される初期化関数
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function grid_input_window_OpeningFcn(hObject, eventdata, handles, varargin)
global SCR_SIZE
global INPUT_VARS
% ウィンドウの位置を調整
h = get(hObject,'Position');
wind_width = h(3);
wind_height = h(4);
xpos = SCRW_X;
ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);
% グリッドウィンドウのデフォルトのコマンドライン出力を選択
handles.output = hObject;
% handles構造体を更新
guidata(hObject, handles);
% 初期状態では断層番号を1に設定
INPUT_VARS.INUM = 1;

%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
%     Output Function
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function varargout = grid_input_window_OutputFcn(hObject, eventdata, handles) 
% grid_input_window_OutputFcn はウィンドウの出力を返します
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%     X start (textfield) X開始位置（テキストフィールド）
%-------------------------------------------------------------------------
function edit_xstart_Callback(hObject, eventdata, handles)
% ユーザーがX開始位置を入力したときの処理
global INPUT_VARS
temp = INPUT_VARS.GRID(1);
INPUT_VARS.GRID(1,1) = str2num(get(hObject,'String'));
if INPUT_VARS.GRID(1) >= INPUT_VARS.GRID(3)-INPUT_VARS.GRID(5)*3.0
    h = warndlg('x start should be smaller enough than x finish. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(1) = temp;
    return;
end
set(hObject,'String',num2str(INPUT_VARS.GRID(1,1),'%7.2f'));

%------------------------------------------------------------
function edit_xstart_CreateFcn(hObject, eventdata, handles)
% X開始位置の入力フィールドの初期化
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.GRID(1,1),'%7.2f'));

%-------------------------------------------------------------------------
%     X finish (textfield) X終了位置（テキストフィールド）
%-------------------------------------------------------------------------
function edit_xfinish_Callback(hObject, eventdata, handles)
% ユーザーがX終了位置を入力したときの処理
global INPUT_VARS
temp = INPUT_VARS.GRID(3);
INPUT_VARS.GRID(3,1) = str2num(get(hObject,'String'));
if INPUT_VARS.GRID(3) < INPUT_VARS.GRID(1)+INPUT_VARS.GRID(5)*3.0
    h = warndlg('x finish should be larger enough than x start. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(3) = temp;
    return;
end
set(hObject,'String',num2str(INPUT_VARS.GRID(3,1),'%7.2f'));
%------------------------------------------------------------
function edit_xfinish_CreateFcn(hObject, eventdata, handles)
% X終了位置の入力フィールドの初期化
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.GRID(3,1),'%7.2f'));

%-------------------------------------------------------------------------
%     X increment (textfield) Xインクリメント（テキストフィールド）
%-------------------------------------------------------------------------
function edit_xinc_Callback(hObject, eventdata, handles)
% ユーザーがX軸のインクリメントを入力したときの処理
global INPUT_VARS
temp = INPUT_VARS.GRID(5);
INPUT_VARS.GRID(5,1) = str2num(get(hObject,'String'));
% インクリメントが適切な範囲かチェック
if INPUT_VARS.GRID(5) > (INPUT_VARS.GRID(3)-INPUT_VARS.GRID(1))/3.0 % X終了位置が開始位置に対して適切かチェック
    h = warndlg('The increment is too large. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(5) = temp;
    return;
elseif INPUT_VARS.GRID(5) <= 0.0
    h = warndlg('The increment should be positive. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(5) = temp;
    return;
end
set(hObject,'String',num2str(INPUT_VARS.GRID(5,1),'%7.2f'));

%------------------------------------------------------------
function edit_xinc_CreateFcn(hObject, eventdata, handles) 
% X軸インクリメントの入力フィールドの初期化
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.GRID(5,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Y start (textfield) Y開始位置（テキストフィールド）
%-------------------------------------------------------------------------
function edit_ystart_Callback(hObject, eventdata, handles)
% ユーザーがY開始位置を入力したときの処理
global INPUT_VARS
temp = INPUT_VARS.GRID(2);
INPUT_VARS.GRID(2,1) = str2num(get(hObject,'String'));
% Y開始位置が終了位置に対して適切かチェック
if INPUT_VARS.GRID(2) >= INPUT_VARS.GRID(4)-INPUT_VARS.GRID(6)*3.0
    h = warndlg('y start should be smaller enough than y finish. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(2) = temp;
    return;
end
set(hObject,'String',num2str(INPUT_VARS.GRID(2,1),'%7.2f'));
%------------------------------------------------------------
function edit_ystart_CreateFcn(hObject, eventdata, handles)
% Y開始位置の入力フィールドの初期化
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.GRID(2,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Y finish (textfield) Y終了位置（テキストフィールド）
%-------------------------------------------------------------------------
function edit_yfinish_Callback(hObject, eventdata, handles)
% ユーザーがY終了位置を入力したときの処理
global INPUT_VARS
temp = INPUT_VARS.(4);
INPUT_VARS.GRID(4,1) = str2num(get(hObject,'String'));
% Y終了位置が開始位置に対して適切かチェック
if INPUT_VARS.GRID(4) < INPUT_VARS.GRID(2)+INPUT_VARS.GRID(6)*3.0
    h = warndlg('y finish should be larger enough than y start. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(4) = temp;
    return;
end
set(hObject,'String',num2str(INPUT_VARS.GRID(4,1),'%7.2f'));

%------------------------------------------------------------
function edit_yfinish_CreateFcn(hObject, eventdata, handles) 
% Y終了位置の入力フィールドの初期化
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.GRID(4,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Y increment (textfield) Yインクリメント（テキストフィールド）
%-------------------------------------------------------------------------
function edit_yinc_Callback(hObject, eventdata, handles)
% ユーザーがY軸のインクリメントを入力したときの処理
global INPUT_VARS
temp = INPUT_VARS.GRID(6);
INPUT_VARS.GRID(6,1) = str2num(get(hObject,'String'));
set(hObject,'String',num2str(INPUT_VARS.GRID(6,1),'%7.2f'));
% インクリメントが適切な範囲かチェック
if INPUT_VARS.GRID(6) > (INPUT_VARS.GRID(4)-INPUT_VARS.GRID(2))/3.0
    h = warndlg('The increment is too large. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(6) = temp;
    return;
elseif INPUT_VARS.GRID(6) <= 0.0
    h = warndlg('The increment should be positive. ','!! Warning !!');
    waitfor(h);
    set(hObject,'String',num2str(temp,'%7.2f'));
    INPUT_VARS.GRID(6) = temp;
    return;
end

%------------------------------------------------------------
function edit_yinc_CreateFcn(hObject, eventdata, handles)
% Y軸インクリメントの入力フィールドの初期化
global INPUT_VARS
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(INPUT_VARS.GRID(6,1),'%7.2f'));

%-------------------------------------------------------------------------
%     Cancel (button) キャンセルボタン
%-------------------------------------------------------------------------
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% キャンセルボタンが押されたときの処理
h = figure(gcf);
delete(h);

%-------------------------------------------------------------------------
%     Add lon. lat. info (button) 緯度経度情報を追加（ボタン）
%-------------------------------------------------------------------------
function pushbutton_add_lonlat_Callback(hObject, eventdata, handles)
% 緯度・経度情報を追加するためのボタン
global H_STUDY_AREA H_MAIN
H_STUDY_AREA = study_area;
waitfor(H_STUDY_AREA); % ユーザーの緯度・経度情報の入力を待つ
h = findobj('Tag','main_menu_window2');
if isempty(h)~=1 & isempty(H_MAIN)~=1
    iflag = check_lonlat_info;
    if iflag == 1
        set(findobj('Tag','menu_gridlines'),'Enable','On');
        set(findobj('Tag','menu_coastlines'),'Enable','On');
        set(findobj('Tag','menu_activefaults'),'Enable','On');
        set(findobj('Tag','menu_earthquakes'),'Enable','On');    
    end
end

%-------------------------------------------------------------------------
%     OK (button)
%-------------------------------------------------------------------------
function pushbutton_ok_Callback(hObject, eventdata, handles)
% OKボタンが押されたときの処理
global H_MAIN H_ELEMENT
global DONOTSHOW
global INPUT_VARS
global CALC_CONTROL
global SYSTEM_VARS

% 現在のウィンドウを閉じる
h = figure(gcf);
delete(h);
% グリッド位置を計算し、他の関数に渡すために保持
xstart = INPUT_VARS.GRID(1,1);
ystart = INPUT_VARS.GRID(2,1);
xfinish = INPUT_VARS.GRID(3,1);
yfinish = INPUT_VARS.GRID(4,1);
xinc = INPUT_VARS.GRID(5,1);
yinc = INPUT_VARS.GRID(6,1);
nxinc = int16((xfinish-xstart)/xinc + 1);
nyinc = int16((yfinish-ystart)/yinc + 1);
xpp = 1:1:nxinc;
ypp = 1:1:nyinc;
XGRID = double(xstart) + (double(1:1:(nxinc-1))-1.0) * double(xinc);
YGRID = double(ystart) + (double(1:1:(nyinc-1))-1.0) * double(yinc);

CALC_CONTROL.FUNC_SWITCH = 1;
INPUT_VARS.CALC_DEPTH =  0.0; % grid_drawing関数で使用される一時的な値
grid_drawing2;

% 断層位置の設定
CALC_CONTROL.FUNC_SWITCH = 0;
xy = zeros(2,2);
n = 0;
but = 1;

% マウスクリックで断層の位置を設定
if isempty(DONOTSHOW) == 1
h0 = new_fault_pos_dialog;
waitfor(h0);
else
    if DONOTSHOW ~= 1
        h0 = new_fault_pos_dialog;
        waitfor(h0);
    end
end

%------ mouse clicks マウスクリックで断層位置を選択 -------------------
try
    while (but == 1 && n <= 2)
        h = figure(H_MAIN);
        [xi,yi,but] = ginput(1);
        n = n+1;
        xy(:,n) = [xi;yi];
        xs = xy(1,1); INPUT_VARS.ELEMENT(1,1) = xy(1,1);
        ys = xy(2,1); INPUT_VARS.ELEMENT(1,2) = xy(2,1);
        xf = xy(1,2); INPUT_VARS.ELEMENT(1,3) = xy(1,2);
        yf = xy(2,2); INPUT_VARS.ELEMENT(1,4) = xy(2,2);
    end
catch
    disp('try again choosing NEW from DATA menu');
    return
end

%----------------------------------------
if isempty(findobj('Tag','new_fault_pos_dialog'))~=1
    close(h0);
end
hold on;
h = plot([xs xf],[ys yf]);
set(h,'Tag','new_fault_line'); % 新しい断層を描画
set (h,'Color',SYSTEM_VARS.PREF(1,1:3),'LineWidth',SYSTEM_VARS.PREF(1,4));
h1 = text(xs,ys,'A','FontSize',18);
h2 = text(xf,yf,'B','FontSize',18);
set(h1,'HorizontalAlignment','center');
set(h2,'HorizontalAlignment','center');
set(h1,'Tag','new_fault_A'); %TAG cross_section_A
set(h2,'Tag','new_fault_B'); %TAG cross_section_B

% デフォルト値の設定（初心者向け）
INPUT_VARS.NUM = 1;
INPUT_VARS.ID  = 1;
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5) = 0.0;  % 右横ずれ量 (m)
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6) = 0.0;  % 逆断層すべり量 (m)
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7) = 90.0; % 傾斜角 (degree)
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8) = 0.0;  % 断層上部の深さ (km)
INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9) = 10.0; % 断層下部の深さ (km)
INPUT_VARS.FCOMMENT(INPUT_VARS.INUM).ref = 'added by mouse-click'; % デフォルトのコメント
INPUT_VARS.CALC_DEPTH = (INPUT_VARS.ELEMENT(:,8)+INPUT_VARS.ELEMENT(:,9)) / 2.0;
INPUT_VARS.POIS = 0.25;
INPUT_VARS.YOUNG = 800000;
INPUT_VARS.KODE(INPUT_VARS.INUM,1) = 100;
INPUT_VARS.FRIC = 0.4;
INPUT_VARS.SIZE = [2;1;10000];
INPUT_VARS.HEAD = cell(2,1);
x1 = 'header line 1';
x2 = 'header line 2';
INPUT_VARS.HEAD(1,1) = mat2cell(x1);
INPUT_VARS.HEAD(2,1) = mat2cell(x2);
INPUT_VARS.R_STRESS = [19.00 -0.01 100.0 0.0;
                       89.99 89.99  30.0 0.0;
                      109.00 -0.01   0.0 0.0];
INPUT_VARS.SECTION = [-16; -16; 18; 26; 1; 30; 1];

% 要素入力ウィンドウを表示
H_ELEMENT = element_input_window;
set(findobj('Tag','radiobutton_taper'),'Visible','off');
set(findobj('Tag','radiobutton_split'),'Visible','off');
set(findobj('Tag','text_strike_dist'),'Visible','off');
set(findobj('Tag','text_dip_dist'),'Visible','off');
set(findobj('Tag','text_n_element'),'Visible','off');
set(findobj('Tag','text_x'),'Visible','off');
set(findobj('Tag','text_strike_by_dip'),'Visible','off');
set(findobj('Tag','edit_taper_strike'),'Visible','off');
set(findobj('Tag','edit_taper_dip'),'Visible','off');
set(findobj('Tag','edit_taper_num'),'Visible','off');
set(findobj('Tag','edit_nf_strike'),'Visible','off');
set(findobj('Tag','edit_nf_dip'),'Visible','off');
set(findobj('Tag','text_split_strike'),'Visible','off');
set(findobj('Tag','text_split_dip'),'Visible','off');
set(findobj('Tag','pushbutton_add_fault'),'Visible','on');
waitfor(H_ELEMENT);
calc_element;
