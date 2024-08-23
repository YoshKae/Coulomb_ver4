function varargout = vertical_displ_window(varargin)

% GUI（グラフィカルユーザーインターフェース）を初期化および設定する
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vertical_displ_window_OpeningFcn, ...
                   'gui_OutputFcn',  @vertical_displ_window_OutputFcn, ...
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


% --- vertical_displ_window が表示される直前に実行されます。
function vertical_displ_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

global SCRS SCRW_X SCRW_Y % screen size (1x4, [x y width height]) & width
h = findobj('Tag','vertical_displ_window'); % タグがvertical_displ_windowのオブジェクトを取得
j = get(h,'Position'); % オブジェクトの位置を取得
wind_width = j(1,3); % ウィンドウの幅
wind_height = j(1,4); % ウィンドウの高さ
dummy = findobj('Tag','main_menu_window');
if isempty(dummy)~=1
 h = get(dummy,'Position');
end
xpos = h(1,1) + h(1,3) + 5;
ypos = (SCRS(1,4) - SCRW_Y) - wind_height;
set(hObject,'Position',[xpos ypos wind_width wind_height]);

% vertical_displ_windowのデフォルトのコマンドライン出力を選択
handles.output = hObject;

% ハンドル構造体を更新
guidata(hObject, handles);

% --- この関数からの出力はコマンドラインに返されます。
function varargout = vertical_displ_window_OutputFcn(hObject, eventdata, handles) 


% ハンドル構造体からデフォルトのコマンドライン出力を取得
varargout{1} = handles.output;

%-------------------------------------------------------------------------
%       COLOR SATURATION SLIDER (slider) % カラー彩度のスライダー
%-------------------------------------------------------------------------
function vd_slider_Callback(hObject, eventdata, handles) % スライダーが操作されたときのコールバック関数
% この関数は、スライダーの値を取得し、関連するテキストフィールドにその値を表示し、
% 必要に応じて他の関数を呼び出してビューを更新します。
set (handles.edit_vd_color_sat,'String',num2str(get(hObject,'Value'),2));
h = findobj('Tag','main_menu_window');
if isempty(h) ~= 1
    vd_view_button_Callback;
end

function vd_slider_CreateFcn(hObject, eventdata, handles) % スライダーが作成されたときの初期化関数
% スライダーが作成されたときに実行される初期化関数です。この関数は、スライダーの背景色を設定します。
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%-------------------------------------------------------------------------
%       COLOR SATURATION TEXTFIELD (textfield) %
%-------------------------------------------------------------------------
% テキストフィールド (edit_vd_color_sat) に新しい値が入力されたときに実行されるコールバック関数
function edit_vd_color_sat_Callback(hObject, eventdata, handles)
h = str2double(get(hObject,'String')); % テキストフィールドの値を文字列として取得し、それを数値に変換して変数hに格納
set(hObject,'String',num2str(h,'%4.3f')); % その数値を小数点以下3桁までの文字列に変換して再度テキストフィールドに設定
    % スライダー (vd_slider) の最大値 (hmax) と最小値 (hmin) を取得
    % スライダーの値が最大値を超える場合は最大値に、最小値を下回る場合は最小値に設定
	hmax = get(findobj('Tag','vd_slider'),'Max');
	hmin = get(findobj('Tag','vd_slider'),'Min');
    if h > hmax
        h = hmax; set(hObject,'String',num2str(h,'%6.3f'));
    elseif h < hmin
        h = hmin; set(hObject,'String',num2str(h,'%6.3f'));
    else
        set(hObject,'String',num2str(h,'%6.3f'));
   end
    set(findobj('Tag','vd_slider'),'Value',h); % 修正された値hをスライダーの現在の値として設定
    vd_view_button_Callback;

% --- オブジェクトが作成された後、すべてのプロパティが設定されたときに実行されます。
% テキストフィールド (edit_vd_color_sat) が作成されたときに実行される初期化関数
function edit_vd_color_sat_CreateFcn(hObject, eventdata, handles)
% global COLORSN
% 実行環境がPCであり、かつテキストフィールドの背景色がデフォルトのUIコントロールの背景色と同じ場合、
% テキストフィールドの背景色を白に設定
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%       Mosaic (radiobutton) モザイク
%-------------------------------------------------------------------------
function radiobutton_vd_mosaic_Callback(hObject, eventdata, handles)
global SHADE_TYPE
x = get(hObject,'Value');
if x == 1
    SHADE_TYPE = 1;
end
set(findobj('Tag','radiobutton_vd_interp'),'Value',0);
    vd_view_button_Callback;

%-------------------------------------------------------------------------
%       Interpolated (radiobutton)
%-------------------------------------------------------------------------
function radiobutton_vd_interp_Callback(hObject, eventdata, handles)
global SHADE_TYPE
x = get(hObject,'Value');
if x == 1
    SHADE_TYPE = 2;
end
set(findobj('Tag','radiobutton_vd_mosaic'),'Value',0);
    vd_view_button_Callback;

%-------------------------------------------------------------------------
%       CALC. & VIEW (button)
%-------------------------------------------------------------------------
function vd_view_button_Callback(hObject, eventdata, handles)
global XGRID YGRID CC
global COAST_DATA EQ_DATA AFAULT_DATA
cmax = max(reshape(max(abs(CC)),length(XGRID),1));
cmin = min(reshape(min(abs(CC)),length(XGRID),1));
if cmin <= 0.01; cmin = 0.01; end
cmean = mean(reshape(mean(abs(CC)),length(XGRID),1));
set(findobj('Tag','vd_slider'),'Max',cmax);
set(findobj('Tag','vd_slider'),'Min',cmin);

n = get(findobj('Tag','vd_slider'),'Value');
% set(findobj('Tag','edit_vd_colorsat'),'String',num2str(cmean,'%4.1f'));
% To make an image using "cc", sharing it with coulomb functions
coulomb_view(n);
fault_overlay;
% ----- overlay drawing --------------------------------
if isempty(COAST_DATA) ~= 1 | isempty(EQ_DATA) ~= 1 | isempty(AFAULT_DATA) ~= 1
        hold on;
        overlay_drawing;
end

%========================================================================


%-------------------------------------------------------------------------
%       CLEAR (button)
%-------------------------------------------------------------------------
function vd_clear_button_Callback(hObject, eventdata, handles)


%-------------------------------------------------------------------------
%       Contour checkbox (button)
%-------------------------------------------------------------------------
function vd_contour_checkbox_Callback(hObject, eventdata, handles)
global VD_CHECKED
VD_CHECKED = get(hObject,'Value');
% I hate make the global variable but somehow it does not work 'Tag' stuff
% which I have no idea.
if VD_CHECKED == 1
    warndlg('This takes much time, in particular finer interval. Be patient. Otherwise, check it off.');
end

%-------------------------------------------------------------------------
%       Contour interval (textfiel)
%-------------------------------------------------------------------------
function edit_cont_interval_Callback(hObject, eventdata, handles)
global CONT_INTERVAL
h = str2double(get(hObject,'String'));
if h < 0.01
    set(hObject,'String',num2str(0.01,'%4.2f'));    
else
    set(hObject,'String',num2str(h,'%4.2f'));
end
CONT_INTERVAL = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_cont_interval_CreateFcn(hObject, eventdata, handles)
global CONT_INTERVAL
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(CONT_INTERVAL,'%4.2f'));



%-------------------------------------------------------------------------
%       Cross section (button)
%-------------------------------------------------------------------------
function pushbutton_vd_crosssection_Callback(hObject, eventdata, handles)
global H_SEC_WINDOW
H_SEC_WINDOW = xsec_window;
set(findobj('Tag','text_downdip_inc'),'Visible','off');
set(findobj('Tag','edit_downdip_inc'),'Visible','off');
set(findobj('Tag','text_downdip_inc_km'),'Visible','off');
set(findobj('Tag','text_section_dip'),'Visible','off');
set(findobj('Tag','edit_section_dip'),'Visible','off');
set(findobj('Tag','text_section_dip_deg'),'Visible','off');
