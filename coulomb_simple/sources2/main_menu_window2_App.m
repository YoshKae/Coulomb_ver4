classdef main_menu_window2_App < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        main_menu_window            matlab.ui.Figure
        data_menu                   matlab.ui.container.Menu
        menu_about                  matlab.ui.container.Menu
        menu_most_recent_file       matlab.ui.container.Menu
        menu_open_skipping          matlab.ui.container.Menu
        menu_file_open              matlab.ui.container.Menu
        menu_new                    matlab.ui.container.Menu
        menu_new_map                matlab.ui.container.Menu
        menu_file_save_ascii        matlab.ui.container.Menu
        menu_file_save_ascii2       matlab.ui.container.Menu
        menu_file_save              matlab.ui.container.Menu
        menu_map_info               matlab.ui.container.Menu
        menu_preferences            matlab.ui.container.Menu
        menu_quit                   matlab.ui.container.Menu
        function_menu               matlab.ui.container.Menu
        menu_grid                   matlab.ui.container.Menu
        menu_grid_mapview           matlab.ui.container.Menu
        menu_grid_3d                matlab.ui.container.Menu
        menu_displacement           matlab.ui.container.Menu
        menu_vectors                matlab.ui.container.Menu
        menu_wireframe              matlab.ui.container.Menu
        menu_contours               matlab.ui.container.Menu
        menu_3d                     matlab.ui.container.Menu
        menu_3d_wire                matlab.ui.container.Menu
        menu_3d_vectors             matlab.ui.container.Menu
        menu_strain                 matlab.ui.container.Menu
        menu_stress                 matlab.ui.container.Menu
        menu_shear_stress_change    matlab.ui.container.Menu
        menu_normal_stress_change   matlab.ui.container.Menu
        menu_coulomb_stress_change  matlab.ui.container.Menu
        menu_stress_on_faults       matlab.ui.container.Menu
        menu_stress_on_a_fault      matlab.ui.container.Menu
        menu_focal_mech             matlab.ui.container.Menu
        menu_change_parameters      matlab.ui.container.Menu
        menu_all_parameters         matlab.ui.container.Menu
        menu_grid_size              matlab.ui.container.Menu
        menu_calc_depth             matlab.ui.container.Menu
        menu_coeff_friction         matlab.ui.container.Menu
        menu_exaggeration           matlab.ui.container.Menu
        menu_tools                  matlab.ui.container.Menu
        menu_taper_split            matlab.ui.container.Menu
        menu_cartesian              matlab.ui.container.Menu
        menu_calc_principal         matlab.ui.container.Menu
        menu_help                   matlab.ui.container.Menu
        overlay_menu                matlab.ui.container.Menu
        menu_coastlines             matlab.ui.container.Menu
        menu_activefaults           matlab.ui.container.Menu
        menu_earthquakes            matlab.ui.container.Menu
        menu_volcanoes              matlab.ui.container.Menu
        menu_gps                    matlab.ui.container.Menu
        menu_clear_overlay          matlab.ui.container.Menu
        submenu_clear_coastlines    matlab.ui.container.Menu
        submenu_clear_afaults       matlab.ui.container.Menu
        submenu_clear_earthquakes   matlab.ui.container.Menu
        submenu_clear_volcanoes     matlab.ui.container.Menu
        submenu_clear_gps           matlab.ui.container.Menu
        menu_trace_put_faults       matlab.ui.container.Menu
    end

    
    methods (Access = private)
        function all_functions_enable_off(app)
            %----------------------------------------------------------
            
            set(findobj('Tag','menu_grid'),'Enable','Off');
            set(findobj('Tag','menu_displacement'),'Enable','Off');
            set(findobj('Tag','menu_strain'),'Enable','Off');
            set(findobj('Tag','menu_stress'),'Enable','Off');
            set(findobj('Tag','menu_taper_split'),'Enable','Off');
        end
        
        function all_functions_enable_on(app)
            %----------------------------------------------------------
            
            set(findobj('Tag','menu_grid'),'Enable','On');
            set(findobj('Tag','menu_displacement'),'Enable','On');
            set(findobj('Tag','menu_strain'),'Enable','On');
            set(findobj('Tag','menu_stress'),'Enable','On');
            set(findobj('Tag','menu_change_parameters'),'Enable','On');
            set(findobj('Tag','menu_taper_split'),'Enable','On');
        end
        
        function all_overlay_enable_off(app)
            %----------------------------------------------------------
            
            set(findobj('Tag','menu_coastlines'),'Enable','Off');
            set(findobj('Tag','menu_activefaults'),'Enable','Off');
            set(findobj('Tag','menu_earthquakes'),'Enable','Off');
            set(findobj('Tag','menu_clear_overlay'),'Enable','Off');
            set(findobj('Tag','menu_trace_put_faults'),'Enable','Off');
        end
        
        function all_overlay_enable_on(app)
            %----------------------------------------------------------
            
            set(findobj('Tag','menu_coastlines'),'Enable','On');
            set(findobj('Tag','menu_activefaults'),'Enable','On');
            set(findobj('Tag','menu_earthquakes'),'Enable','On');
            set(findobj('Tag','menu_clear_overlay'),'Enable','On');
            set(findobj('Tag','menu_trace_put_faults'),'Enable','On');
        end
        
        function check_overlay_items(app)
            % --------------------------------------------------------------------
            
            global OVERLAY_VARS
            if ~isempty(OVERLAY_VARS.COAST_DATA)
                set(findobj('Tag','menu_coastlines'),'Checked','On');
            else
                set(findobj('Tag','menu_coastlines'),'Checked','Off');
            end
            if ~isempty(OVERLAY_VARS.AFAULT_DATA)
                set(findobj('Tag','menu_activefaults'),'Checked','On');
            else
                set(findobj('Tag','menu_activefaults'),'Checked','Off');
            end
            if ~isempty(OVERLAY_VARS.EQ_DATA)
                set(findobj('Tag','menu_earthquakes'),'Checked','On');
            else
                set(findobj('Tag','menu_earthquakes'),'Checked','Off');
            end
        end
        
        function uimenu_fault_modifications_Callback(app, hObject, eventdata, handles)
            % --------------------------------------------------------------------
            
            % uimenu_fault_modificationsをクリックしたときのコールバック関数
            disp('under construction')
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function main_menu_window_OpeningFcn(app, varargin)
            %-------------------------------------------------------------------------
            %   Main menu opening function メインメニューを開く関数
            %-------------------------------------------------------------------------
            
            % Ensure that the app appears on screen when run
            movegui(app.main_menu_window, 'onscreen');
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>
            
            % hObject: GUIのハンドル。handles: GUIのハンドルを格納する構造体。
            % main_menu_window2のデフォルトのコマンドライン出力を選択
            global SCR_SIZE
            
            handles.output = hObject;              % handles.output: GUIの出力を設定。
            guidata(hObject, handles);             % guidata: handles構造体を更新。
            % main_menu_window2.fig ファイルを開く
            hFig = openfig('main_menu_window2.fig', 'reuse');
            
            % タグを設定
            set(hFig, 'Tag', 'main_menu_window2');
            
            % オブジェクトの位置情報を取得
            j = get(hFig, 'Position');  % オブジェクトの位置情報を取得
            
            % ウィンドウの幅と高さを取得
            wind_width = j(3);  % ウィンドウの幅
            wind_height = j(4);  % ウィンドウの高さ
            xpos = SCR_SIZE.SCRW_X;                % ウィンドウのx座標
            ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height; % ウィンドウのy座標
            set(hObject,'Position',[xpos ypos wind_width wind_height]);
        end

        % Menu selected function: menu_3d
        function menu_3d_Callback(app, event)
            %-------------------------------------------------------------------------
            %                       3D IMAGE (sub-submenu) 3Dイメージサブサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global COORD_VARS
            global CALC_CONTROL
            global OKADA_OUTPUT
            global SYSTEM_VARS
            
            subfig_clear;
            CALC_CONTROL.FUNC_SWITCH = 5;
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
                waitfor(h);
            end
            % Okadaハーフスペースの再計算を回避するため
            if CALC_CONTROL.IACT ~= 1
            Okada_halfspace;
            end
            CALC_CONTROL.IACT = 1;
            a = OKADA_OUTPUT.DC3D(:,1:2);
            b = OKADA_OUTPUT.DC3D(:,5:8);
            c = horzcat(a,b);
            format long;
            if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
                cd output_files;
            else
                cd (SYSTEM_VARS.PREF_DIR);
            end
            header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
            header2 = 'x y z UX UY UZ';
            header3 = '(km) (km) (km) (m) (m) (m)';
            dlmwrite('Displacement.cou',header1,'delimiter','');
            dlmwrite('Displacement.cou',header2,'-append','delimiter','');
            dlmwrite('Displacement.cou',header3,'-append','delimiter','');
            dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
            disp(['Displacement.cou is saved in ' pwd]);
            cd (SYSTEM_VARS.HOME_DIR);
            grid_drawing_3d2;
            hold on;
            displ_open2(2);
            h = findobj('Tag','xlines'); delete(h);
            h = findobj('Tag','ylines'); delete(h);
        end

        % Menu selected function: menu_3d_vectors
        function menu_3d_vectors_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 3Dベクトルをクリックしたときのコールバック関数
            global COORD_VARS
            global CALC_CONTROL
            global OKADA_OUTPUT
            global SYSTEM_VARS
            
            subfig_clear; % サブフィギュアをクリア
            CALC_CONTROL.FUNC_SWITCH = 5.7; % 関数スイッチを5.7に設定
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
                h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
                waitfor(h); % モーダルダイアログボックスの終了を待つ
            end
            if CALC_CONTROL.IACT ~= 1
                Okada_halfspace;
            end
            CALC_CONTROL.IACT = 1;
            a = OKADA_OUTPUT.DC3D(:,1:2);
            b = OKADA_OUTPUT.DC3D(:,5:8);
            c = horzcat(a,b);
            format long;
            if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
                cd output_files;
            else
                cd (SYSTEM_VARS.PREF_DIR);
            end
            header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
            header2 = 'x y z UX UY UZ';
            header3 = '(km) (km) (km) (m) (m) (m)';
            dlmwrite('Displacement.cou',header1,'delimiter','');
            dlmwrite('Displacement.cou',header2,'-append','delimiter','');
            dlmwrite('Displacement.cou',header3,'-append','delimiter','');
            dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
            disp(['Displacement.cou is saved in ' pwd]);
            cd (SYSTEM_VARS.HOME_DIR);
            grid_drawing_3d2;
            hold on;
            displ_open2(2);
            h = findobj('Tag','xlines'); delete(h);
            h = findobj('Tag','ylines'); delete(h);
        end

        % Menu selected function: menu_3d_wire
        function menu_3d_wire_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 3Dワイヤをクリックしたときのコールバック関数
            global COORD_VARS
            global CALC_CONTROL
            global OKADA_OUTPUT
            global SYSTEM_VARS
            
            subfig_clear;
            CALC_CONTROL.FUNC_SWITCH = 5.5; % 関数スイッチを5.5に設定
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
                h = warndlg('Sorry faults would be invisible so far. To see complete view, change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
                waitfor(h);
            end
            % Okadaハーフスペースの再計算を回避するため
            if CALC_CONTROL.IACT ~= 1
                Okada_halfspace; % Okadaハーフスペースを計算
            end
            CALC_CONTROL.IACT = 1;        % to keep okada output
            a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
            b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
            c = horzcat(a,b);             % aとbを水平に連結
            format long;
            if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが1または空の場合
                cd output_files; % output_filesに移動
            else
                cd (SYSTEM_VARS.PREF_DIR);
            end
            header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
            header2 = 'x y z UX UY UZ';
            header3 = '(km) (km) (km) (m) (m) (m)';
            dlmwrite('Displacement.cou',header1,'delimiter','');
            dlmwrite('Displacement.cou',header2,'-append','delimiter','');
            dlmwrite('Displacement.cou',header3,'-append','delimiter','');
            dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
            disp(['Displacement.cou is saved in ' pwd]);
            cd (SYSTEM_VARS.HOME_DIR);
            
            grid_drawing_3d2;
            hold on;                                % 3Dグリッドの描画
            displ_open2(2);                         % 2を開く
            h = findobj('Tag','xlines'); delete(h); % xlinesを削除
            h = findobj('Tag','ylines'); delete(h);
        end

        % Menu selected function: menu_about
        function menu_about_Callback(app, event)
            %-------------------------------------------------------------------------
            %           ABOUT (submenu) アバウトサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % アバウトサブメニューをクリックしたときのコールバック関数
            global SYSTEM_VARS
            cd slides2                  % slidesディレクトリに移動
            str = About_image2.jpg; % 画像ファイル名
            [x,imap] = imread(str);     % imread: 画像ファイルを読み込む。
            if exist('x')==1
                h = figure('Menubar','none','NumberTitle','off'); % figure: 新しい図を作成。
                axes('position',[0 0 1 1]); % 軸を作成。
                axis image;                 % 軸の設定。
                image(x);                   % 画像を表示。
                drawnow;                    % グラフィックスの更新。
            
                %===== version check バージョンチェック ===========================
                try
                    temp  = '3.2.01';          % temporal for Sep. 12 2010 SCEC class % urlreadが使えないため、一時的にバージョンを設定
                    idx   = strfind(temp,'.'); % strfind: 文字列内の特定の文字列の位置を検索。
                    newvs = str2num([temp(1:idx(1)-1) temp(idx(1)+1:idx(2)-1) temp(idx(2)+1:end)]);
                    idx   = strfind(SYSTEM_VARS.CURRENT_VERSION,'.'); % strfind: 文字列内の特定の文字列の位置を検索。
                    curvs = str2num([SYSTEM_VARS.CURRENT_VERSION(1:idx(1)-1) SYSTEM_VARS.CURRENT_VERSION(idx(1)+1:idx(2)-1) SYSTEM_VARS.CURRENT_VERSION(idx(2)+1:end)]);
                    if newvs > curvs % 新しいのがあれば更新表示
                        versionmsg = [' New version ' temp ' is found. Visit the following website.'];
                    else
                        versionmsg = '';
                    end
                catch
                    % インターネットとつながっていなかった場合、あとでバージョンをチェックするようにメッセージを表示
                    versionmsg = 'No internet connection. Check the version later.';
                end
            
                th = text(460.0,385.0,['  version ' SYSTEM_VARS.CURRENT_VERSION '  ']); % 現在のバージョンを表示
                set(th,'fontsize',16,'fontweight','b','Color','w',...                   % set: プロパティの値を設定。
                    'horizontalalignment','center','verticalalignment','middle','backgroundcolor','none','edgecolor','none')
                th1 = text(305.0,420.0,versionmsg);                                     % 新しいバージョンがある場合、メッセージを表示
                set(th1,'fontsize',14,'fontweight','b','Color','w',...                  % set: プロパティの値を設定。
                    'horizontalalignment','center','verticalalignment','middle','backgroundcolor','k','edgecolor','none')
                th2 = text(320.0,420.0,' http://earthquake.usgs.gov/research/modeling/coulomb/ '); % USGSのサイトへのリンク
                set(th2,'fontsize',12,'fontweight','b','Color','w',...                             % set: プロパティの値を設定。
                    'horizontalalignment','center','verticalalignment','middle','backgroundcolor','none','edgecolor','none')
            end
            cd .. % 一つ上のディレクトリに移動
        end

        % Menu selected function: menu_activefaults
        function menu_activefaults_Callback(app, event)
            %-------------------------------------------------------------------------
            %           ACTIVE FAULTS (submenu) アクティブフォールトサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_MAIN
            global OVERLAY_VARS
            if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
                set(gcbo, 'Checked', 'off');     % gcboをoffに設定
                figure(H_MAIN);                  % H_MAINの図
                try
                    h = findobj('Tag','AfaultObj'); % 'Tag'が'AfaultObj'のオブジェクトを検索
                    delete(h);
                catch
                    return
                end
            else
                set(gcbo, 'Checked', 'on'); % gcboをonに設定
                hold off;
                if isempty(OVERLAY_VARS.AFAULT_DATA) == 1 % AFAULT_DATAが空の場合
                    afault_format_window;                 % afault_format_windowを開く
                else
                    afault_drawing;                       % afault_drawingを実行
                end
                hold on;
            end
        end

        % Menu selected function: menu_all_parameters
        function menu_all_parameters_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % すべてのパラメータをクリックしたときのコールバック関数
            global H_INPUT
            global CALC_CONTROL
            H_INPUT = input_window;
            waitfor(H_INPUT);
            CALC_CONTROL.IACT = 0;
            menu_grid_mapview_Callback;
        end

        % Menu selected function: menu_calc_depth
        function menu_calc_depth_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 計算深度をクリックしたときのコールバック関数
            global H_DISPL
            global INPUT_VARS
            global CALC_CONTROL
            
            temp = INPUT_VARS.CALC_DEPTH;                       % tempをCALC_DEPTHに設定
            prompt = 'Enter new calculation depth (positive):'; % 新しい計算深度(正)を入力してください
            name = 'Calc. Depth';                               % Calc. Depth
            numlines = 1;                                       % numlinesを1に設定
            options.Resize = 'on';                              % オプションのリサイズをオンに設定
            options.WindowStyle = 'normal';                     % オプションのウィンドウスタイルを通常に設定
            defc = num2str(CALC_DEPTH,'%6.2f');                 % defcをCALC_DEPTHに設定
            answer = inputdlg(prompt,name,numlines,{defc},options); % ダイアログボックスに入力する
            if str2double(answer) < 0.0
                warndlg('Put positive number. Not acceptable'); % 正の数を入力してください。受け入れられません。
            	return
            end
            INPUT_VARS.CALC_DEPTH = str2double(answer);
            if isnan(INPUT_VARS.CALC_DEPTH) == 1 | isempty(INPUT_VARS.CALC_DEPTH) == 1
                INPUT_VARS.CALC_DEPTH = temp;
            end
            h = findobj('Tag','displ_h_window');
            if (isempty(h)~=1 && isempty(H_DISPL)~=1)
                set(findobj('Tag','edit_displdepth'),'String',num2str(INPUT_VARS.CALC_DEPTH,'%5.2f')); % edit_displdepthにCALC_DEPTHを設定
            end
            CALC_CONTROL.IACT = 0;
            menu_grid_mapview_Callback;
        end

        % Menu selected function: menu_calc_principal
        function menu_calc_principal_Callback(app, event)
            %-------------------------------------------------------------------------
            %           CALC. PROPER PRINCIPAL AXES (submenu) 適切な主軸を計算するサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 主軸を計算するサブメニューをクリックしたときのコールバック関数
            global H_CALC_PRINCIPAL
            H_CALC_PRINCIPAL = calc_principals_window;
        end

        % Menu selected function: menu_cartesian
        function menu_cartesian_Callback(app, event)
            %-------------------------------------------------------------------------
            %           CALC. CARTESIAN GRID (submenu) カルテシアングリッドを計算するサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_UTM
            global UTM_FLAG  % UTM_FLAG is used to identify if this is just a tool to know the coordinate (0) to make an input file from this (1)
                             % UTM_FLAGは、座標を知るためのツールであるかどうかを識別するために使用されます(0)、このツールから入力ファイルを作成します(1)
            %===== ユーザーがマッピングツールボックスを持っているかどうかを確認する =====
            if exist([matlabroot '/toolbox/map'],'dir')==0
                warndlg('Since you do not have mapping toolbox, this menu is unavailable. Sorry.','!!Warning!!');
                return;
            end
            H_UTM = utm_window;
            UTM_FLAG = 0;
            set(findobj('Tag','pushbutton_add'),'Visible','off');
            set(findobj('Tag','pushbutton_f_add'),'Visible','off');
            set(findobj('Tag','edit_all_input_params'),'Visible','off');
        end

        % Menu selected function: menu_clear_overlay
        function menu_clear_overlay_Callback(app, event)
            %-------------------------------------------------------------------------
            %	Clear overlay data (submenu) オーバーレイデータをクリアするサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % オーバーレイデータをクリアするサブメニューをクリックしたときのコールバック関数
            global OVERLAY_VARS
            if isempty(OVERLAY_VARS.COAST_DATA)==1
                set(findobj('Tag','submenu_clear_coastlines'),'Enable','Off');
            else
                set(findobj('Tag','submenu_clear_coastlines'),'Enable','On');
            end
            if isempty(OVERLAY_VARS.AFAULT_DATA)==1
                set(findobj('Tag','submenu_clear_afaults'),'Enable','Off');
            else
                set(findobj('Tag','submenu_clear_afaults'),'Enable','On');
            end
            if isempty(OVERLAY_VARS.EQ_DATA)==1
                set(findobj('Tag','submenu_clear_earthquakes'),'Enable','Off');
            else
                set(findobj('Tag','submenu_clear_earthquakes'),'Enable','On');
            end
        end

        % Menu selected function: menu_coastlines
        function menu_coastlines_Callback(app, event)
            %-------------------------------------------------------------------------
            %           COASTLINES (submenu) 海岸線サブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 海岸線サブメニューをクリックしたときのコールバック関数
            global H_MAIN
            if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
                set(gcbo, 'Checked', 'off');     % gcboをoffに設定
                figure(H_MAIN);                  % H_MAINの図
                try
                    h = findobj('Tag','CoastlineObj'); % 'Tag'が'CoastlineObj'のオブジェクトを検索
                    delete(h);
                catch
                    return
                end
            else
                set(gcbo, 'Checked', 'on'); % gcboをonに設定
                hold off;
                coastline_drawing;          % 海岸線の描画
                hold on;
            end
        end

        % Menu selected function: menu_coeff_friction
        function menu_coeff_friction_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 摩擦係数をクリックしたときのコールバック関数
            global INPUT_VARS
            temp = INPUT_VARS.FRIC;
            prompt = 'Enter new friction (positive):'; % 新しい摩擦(正)を入力してください
            name = 'Coeff. Friction';                  % Coeff. Friction
            numlines = 1;
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            defc = num2str(FRIC,'%4.3f');
            answer = inputdlg(prompt,name,numlines,{defc},options);
            if str2double(answer) < 0.0
                warndlg('Put positive number. Not acceptable'); % 正の数を入力してください。受け入れられません。
            	return
            end
            INPUT_VARS.FRIC = str2double(answer); % FRICをanswerに設定
            if isnan(INPUT_VARS.FRIC) == 1 | isempty(INPUT_VARS.FRIC) == 1
                INPUT_VARS.FRIC = temp;
            end
        end

        % Menu selected function: menu_contours
        function menu_contours_Callback(app, event)
            %-------------------------------------------------------------------------
            %              CONTOURS (sub-submenu) コンターサブサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % コンターサブサブメニューをクリックしたときのコールバック関数
            global VD_CHECKED H_MAIN
            global CALC_CONTROL
            global OKADA_OUTPUT
            global OVERLAY_VARS
            global SYSTEM_VARS
            
            subfig_clear;                 % サブフィギュアをクリア
            CALC_CONTROL.FUNC_SWITCH = 4; % 関数スイッチを4に設定
            VD_CHECKED = 0;               % default
            CALC_CONTROL.SHADE_TYPE = 1;  % default
            grid_drawing2;                % グリッドの描画
            if CALC_CONTROL.IACT ~= 1
                Okada_halfspace;          % Okadaハーフスペースを計算
            end
            CALC_CONTROL.IACT = 1;        % to keep okada output
            a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
            b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
            c = horzcat(a,b);             % aとbを水平に連結
            format long;
            % save Displacement.cou a -ascii
            if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1
                cd output_files; % output_filesに移動
            else
                cd (SYSTEM_VARS.PREF_DIR);
            end
            header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE];
            header2 = 'x y z UX UY UZ';
            header3 = '(km) (km) (km) (m) (m) (m)';
            dlmwrite('Displacement.cou',header1,'delimiter','');
            dlmwrite('Displacement.cou',header2,'-append','delimiter','');
            dlmwrite('Displacement.cou',header3,'-append','delimiter','');
            dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f');
            disp(['Displacement.cou is saved in ' pwd]);
            cd (SYSTEM_VARS.HOME_DIR);
            displ_open2(2);
            fault_overlay;             % フォルトオーバーレイ
            flag = check_lonlat_info2; % 経度と緯度の情報をチェック
            if flag == 1               % flagが1の場合
                all_overlay_enable_on(app); % すべてのオーバーレイを有効にする
            end
            % ----- overlay drawing オーバーレイの描画 --------------------------------
            if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
                isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1  % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
                figure(H_MAIN); hold on; % H_MAINの図を保持
                overlay_drawing;         % オーバーレイの描画
            end
        end

        % Menu selected function: menu_coulomb_stress_change
        function menu_coulomb_stress_change_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_COULOMB
            global CALC_CONTROL
            subfig_clear;
            CALC_CONTROL.IACT = 0;
            CALC_CONTROL.FUNC_SWITCH = 9;
            CALC_CONTROL.STRESS_TYPE = 5;
            H_COULOMB = coulomb_window; % coulomb_windowを開く
            set(findobj('Tag','crosssection_toggle'),'Enable','off');
            flag = check_lonlat_info2; % 経度と緯度の情報をチェック
            if flag == 1
                all_overlay_enable_on(app);
            end
        end

        % Menu selected function: menu_earthquakes
        function menu_earthquakes_Callback(app, event)
            %-------------------------------------------------------------------------
            %           EARTHQUAKES (submenu) 地震サブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_MAIN
            if strcmp(get(gcbo, 'Checked'),'on') % gcboのCheckedがonの場合
                set(gcbo, 'Checked', 'off');     % gcboをoffに設定
                figure(H_MAIN);                  % H_MAINの図
                try
                    h = findobj('Tag','EqObj');  % 'Tag'が'EqObj'のオブジェクトを検索
                    delete(h);                   % hを削除
                catch
                    return
                end
                try
                    h = findobj('Tag','EqObj2'); % 'Tag'が'EqObj2'のオブジェクトを検索
                    delete(h);
                catch
                    return
                end
            else
                set(gcbo, 'Checked', 'on'); % gcboをonに設定
                hold off;
                earthquake_plot;            % 地震プロット
                fault_overlay;              % フォルトを再度プロット
                hold on;
            end
        end

        % Menu selected function: menu_exaggeration
        function menu_exaggeration_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 誇張をクリックしたときのコールバック関数
            global INPUT_VARS
            temp = INPUT_VARS.SIZE(3);
            prompt = 'Enter new displ. exaggeration:'; % 新しいdispl. exaggerationを入力してください
            name = 'Displ. exaggeration';
            numlines = 1;
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            defc = num2str(INPUT_VARS.SIZE(3));                     % defcをSIZE(3)に設定
            answer = inputdlg(prompt,name,numlines,{defc},options); % ダイアログボックスに入力する
            INPUT_VARS.SIZE(3) = str2double(answer);                % SIZE(3)をanswerに設定
            if isnan(INPUT_VARS.SIZE(3)) == 1 | isempty(INPUT_VARS.SIZE(3)) == 1
                INPUT_VARS.SIZE(3) = temp;
            end
        end

        % Menu selected function: menu_file_open
        function menu_file_open_Callback(app, event)
            %-------------------------------------------------------------------------
            %           OPEN (submenu) サブメニューを開く
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global DIALOG_SKIP % ダイアログスキップ
            global INPUT_VARS
            
            DIALOG_SKIP = 0;             % ダイアログスキップを0に設定
            input_open(1);               % input_open: 入力を開く
            if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
                all_functions_enable_on(app);
                set(findobj('Tag','menu_file_save'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
                set(findobj('Tag','menu_map_info'),'Enable','On');
                all_overlay_enable_off(app);
                set(findobj('Tag','menu_trace_put_faults'),'Enable','On');
            end
            check_overlay_items(app);
        end

        % Menu selected function: menu_file_save
        function menu_file_save_Callback(app, event)
            %-------------------------------------------------------------------------
            %           SAVE  AS .MAT(submenu) .MAT形式で保存するサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % .MAT形式で保存するサブメニューをクリックしたときのコールバック関数
            global SYSTEM_VARS
            
            if isempty(SYSTEM_VARS.PREF)==1 % prefが空の場合
                % デフォルト値を作成して保存する
                SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                                    0.0 0.0 0.0 1.0;...
                                    0.7 0.7 0.0 0.2;...
                                    0.0 0.0 0.0 1.2;...
                                    1.0 0.5 0.0 3.0;...
                                    0.2 0.2 0.2 1.0;...
                                    2.0 0.0 0.0 0.0;...
                                    1.0 0.0 0.0 0.0;...
                                    0.9 0.9 0.1 1.0];    % volcano 火山のデフォルト値
            end
            if isempty(SYSTEM_VARS.PREF_DIR) ~= 1 % PREF_DIRが空でない場合
                try
                    cd(SYSTEM_VARS.PREF_DIR); % PREF_DIRに移動
                catch
                    cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
                end
            else
                try
                    cd('input_files'); % input_filesに移動
                catch
                    cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
                end
            end
            [filename,pathname] = uiputfile('*.mat',' Save Input File As'); % ファイルを保存するダイアログボックスを表示
            if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
                disp('User selected Cancel')             % ユーザーがキャンセルを選択
            else
                disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
            end
            save(fullfile(pathname,filename), 'INPUT_VARS.HEAD','INPUT_VARS.NUM','INPUT_VARS.POIS','INPUT_VARS.CALC_DEPTH',... % save: ファイルに変数を保存
                'INPUT_VARS.YOUNG','INPUT_VARS.FRIC','INPUT_VARS.R_STRESS','INPUT_VARS.ID','INPUT_VARS.KODE','INPUT_VARS.ELEMENT','INPUT_VARS.FCOMMENT',...
                'INPUT_VARS.GRID','INPUT_VARS.SIZE','INPUT_VARS.SECTION','SYSTEM_VARS.PREF','COORD_VARS.MIN_LAT','COORD_VARS.MAX_LAT','COORD_VARS.ZERO_LAT',...
                'COORD_VARS.MIN_LON','COORD_VARS.MAX_LON','COORD_VARS.ZERO_LON','OVERLAY_VARS.COAST_DATA','OVERLAY_VARS.FAULT_DATA',...
                'OVERLAY_VARS.EQ_DATA','OVERLAY_VARS.GPS_DATA','OVERLAY_VARS.VOLCANO','OVERLAY_VARS.SEISSTATION','-mat');
            cd(SYSTEM_VARS.HOME_DIR);
        end

        % Menu selected function: menu_file_save_ascii2
        function menu_file_save_ascii2_Callback(app, event)
            %-------------------------------------------------------------------------
            %           SAVE AS ASCII2 (submenu)  - save as "rake" & "net slip" ASCII形式で保存するサブメニュー rakeとネットスリップとして保存
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global CALC_CONTROL
            global SYSTEM_VARS
            
            CALC_CONTROL.IRAKE = 1;
            if isempty(SYSTEM_VARS.PREF)==1
                % デフォルト値を作成して保存する
                SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                                    0.0 0.0 0.0 1.0;...
                                    0.7 0.7 0.0 0.2;...
                                    0.0 0.0 0.0 1.2;...
                                    1.0 0.5 0.0 3.0;...
                                    0.2 0.2 0.2 1.0;...
                                    2.0 0.0 0.0 0.0;...
                                    1.0 0.0 0.0 0.0];
            end
            if isempty(SYSTEM_VARS.PREF_DIR) ~= 1 % PREF_DIRが空でない場合
                try
                    cd(SYSTEM_VARS.PREF_DIR);
                catch
                    cd(SYSTEM_VARS.HOME_DIR);
                end
            else
                try
                    cd('input_files');
                catch
                    cd(SYSTEM_VARS.HOME_DIR);
                end
            end
            [filename,pathname] = uiputfile('*.inr',' Save Input File As');
            if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
                disp('User selected Cancel')             % ユーザーがキャンセルを選択
                cd(SYSTEM_VARS.HOME_DIR); return
            else
                disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
                cd(pathname);     % pathnameに移動
                input_save_ascii; % ASCII形式で保存
                cd(SYSTEM_VARS.HOME_DIR);
            end
        end

        % Menu selected function: menu_file_save_ascii
        function menu_file_save_ascii_Callback(app, event)
            %-------------------------------------------------------------------------
            %           SAVE AS ASCII (submenu) ASCII形式で保存するサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % ASCII形式で保存するサブメニューをクリックしたときのコールバック関数
            global CALC_CONTROL
            global SYSTEM_VARS
            
            CALC_CONTROL.IRAKE = 0;         % IRAKEを0に設定
            if isempty(SYSTEM_VARS.PREF)==1 % prefが空の場合
                % デフォルト値を作成して保存する
                SYSTEM_VARS.PREF = [1.0 0.0 0.0 1.2;...
                                    0.0 0.0 0.0 1.0;...
                                    0.7 0.7 0.0 0.2;...
                                    0.0 0.0 0.0 1.2;...
                                    1.0 0.5 0.0 3.0;...
                                    0.2 0.2 0.2 1.0;...
                                    2.0 0.0 0.0 0.0;...
                                    1.0 0.0 0.0 0.0]; % デフォルト値
            end
            if isempty(SYSTEM_VARS.PREF_DIR) ~= 1 % PREF_DIRが空でない場合
                try
                    cd(SYSTEM_VARS.PREF_DIR); % PREF_DIRに移動
                catch
                    cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
                end
            else
                try
                    cd('input_files');        % input_filesに移動
                catch
                    cd(SYSTEM_VARS.HOME_DIR); % HOME_DIRに移動
                end
            end
            [filename,pathname] = uiputfile('*.inp',' Save Input File As');
            if isequal(filename,0) | isequal(pathname,0) % ファイル名が0またはパス名が0の場合
                disp('User selected Cancel')             % ユーザーがキャンセルを選択
            else
                disp(['User saved as ', fullfile(pathname,filename)]) % ユーザーが保存した
            end
            cd(pathname);             % pathnameに移動
            input_save_ascii;         % ASCII形式で保存
            cd(SYSTEM_VARS.HOME_DIR);
        end

        % Menu selected function: menu_focal_mech
        function menu_focal_mech_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global NODAL_ACT NODAL_STRESS
            global CALC_CONTROL
            global SYSTEM_VARS
            CALC_CONTROL.FUNC_SWITCH = 11; % 関数スイッチを11に設定
            NODAL_ACT = 0;                 % NODAL_ACTを0に設定
            NODAL_STRESS = [];             % NODAL_STRESSを空にする
            cd (SYSTEM_VARS.HOME_DIR);     % HOME_DIRに移動
            focal_mech_calc;
        end

        % Menu selected function: menu_grid_3d
        function menu_grid_3d_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 3Dグリッドをクリックしたときのコールバック関数
            global F3D_SLIP_TYPE H_F3D_VIEW
            global INPUT_VARS
            global COORD_VARS
            global SYSTEM_VARS
            global CALC_CONTROL
            
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
                h = warndlg('Sorry this is not available for lat/lon coordinates. Change to Cartesian coordinates.','!! Warning !!'); % 警告ダイアログを表示
                waitfor(h); % モーダルダイアログボックスの終了を待つ
                return
            end
            subfig_clear;                 % サブフィギュアをクリア
            hc = wait_calc_window;        % wait_calc_window: 計算ウィンドウを待つ
            CALC_CONTROL.FUNC_SWITCH = 1; % 関数スイッチを1に設定
            F3D_SLIP_TYPE = 1;            % ネットスリップ
            element_condition(INPUT_VARS.ELEMENT, INPUT_VARS.POIS, INPUT_VARS.YOUNG, INPUT_VARS.FRIC, INPUT_VARS.ID); % 要素条件
            SYSTEM_VARS.C_SLIP_SAT = [];  % C_SLIP_SATを空にする
            grid_drawing_3d2;             % 3Dグリッドの描画
            displ_open2(2);               % 2を開く
            H_F3D_VIEW = f3d_view_control_window2;
            gps_3d_overlay;               % GPS 3Dオーバーレイ
            flag = check_lonlat_info2;    % 経度と緯度の情報をチェック
            if flag == 1
                all_overlay_enable_on(app);    % すべてのオーバーレイを有効にする
            end
            close(hc);
        end

        % Menu selected function: menu_grid_mapview
        function menu_grid_mapview_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドマップビューをクリックしたときのコールバック関数
            global CALC_CONTROL
            global OVERLAY_VARS
            
            subfig_clear;
            CALC_CONTROL.FUNC_SWITCH = 1;
            grid_drawing2;
            fault_overlay;
            if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
                isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1   % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
                hold on;         % 現在の図を保持
                overlay_drawing; % オーバーレイの描画
            end
            CALC_CONTROL.FUNC_SWITCH = 0; %reset to 0
            flag = check_lonlat_info2;    % 経度と緯度の情報をチェック
            if flag == 1                  % flagが1の場合
                all_overlay_enable_on(app);    % すべてのオーバーレイを有効にする
            end
        end

        % Menu selected function: menu_grid_size
        function menu_grid_size_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global LON_PER_X LAT_PER_Y
            global INPUT_VARS
            global COORD_VARS
            global CALC_CONTROL
            
            temp1 = INPUT_VARS.GRID(5,1); temp2 = INPUT_VARS.GRID(6,1);
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                prompt = {'Enter new lon. increment(deg):','Enter new lat. increment(deg):'}; % 新しい経度の増分(度)を入力してください
                defc1 = num2str(INPUT_VARS.GRID(5,1)*LON_PER_X,'%9.3f'); % defc1を設定
                defc2 = num2str(INPUT_VARS.GRID(6,1)*LAT_PER_Y,'%9.3f'); % defc2を設定
            else
                prompt = {'Enter new x increment(km):','Enter new y increment(km):'}; % 新しいxの増分(km)を入力してください
                defc1 = num2str(INPUT_VARS.GRID(5,1),'%9.3f'); % defc1を設定
                defc2 = num2str(INPUT_VARS.GRID(6,1),'%9.3f'); % defc2を設定
            end
            name = 'Grid Size';             % グリッドサイズ
            numlines = 1;                   % numlinesを1に設定
            options.Resize = 'on';          % オプションのリサイズをオンに設定
            options.WindowStyle = 'normal'; % オプションのウィンドウスタイルを通常に設定
            answer = inputdlg(prompt,name,numlines,{defc1,defc2},options); % ダイアログボックスに入力する
            answer = [answer];
            n = 5;
            xlim = (INPUT_VARS.GRID(3)-INPUT_VARS.GRID(1))/n; % xlimを(INPUT_VARS.GRID(3)-INPUT_VARS.GRID(1))/nに設定
            ylim = (INPUT_VARS.GRID(4)-INPUT_VARS.GRID(2))/n; % ylimを(INPUT_VARS.GRID(4)-INPUT_VARS.GRID(2))/nに設定
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                INPUT_VARS.GRID(5,1) = str2double(answer(1))/LON_PER_X;
                INPUT_VARS.GRID(6,1) = str2double(answer(2))/LAT_PER_Y;
                xlim = xlim/LON_PER_X;
                ylim = ylim/LAT_PER_Y;
            else
                INPUT_VARS.GRID(5,1) = str2double(answer(1));
                INPUT_VARS.GRID(6,1) = str2double(answer(2));
            end
            if str2double(answer(1)) > xlim
                warndlg('The x increment might be large relative to the study area. Not acceptable.'); % xの増分が研究領域に対して大きい可能性があります。受け入れられません。
                return
            end
            if str2double(answer(2)) > xlim
                warndlg('The y increment might be large relative to the study area. Not acceptable.'); % yの増分が研究領域に対して大きい可能性があります。受け入れられません。
                return
            end
            if isnan(INPUT_VARS.GRID(5,1)) == 1 | isempty(INPUT_VARS.GRID(5,1)) == 1
                INPUT_VARS.GRID(5,1) = temp1;
            end
            if isnan(INPUT_VARS.GRID(6,1)) == 1 | isempty(INPUT_VARS.GRID(6,1)) == 1
                INPUT_VARS.GRID(6,1) = temp2;
            end
            calc_element;               % 要素を計算
            CALC_CONTROL.IACT = 0;      % CALC_CONTROL.IACTを0に設定
            menu_grid_mapview_Callback;
        end

        % Menu selected function: menu_map_info
        function menu_map_info_Callback(app, event)
            %-------------------------------------------------------------------------
            %           PUT MAP INFO (submenu) マップ情報を入力するサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % マップ情報を入力するサブメニューをクリックしたときのコールバック関数
            global H_STUDY_AREA H_MAIN % スタディエリア、メインウィンドウ
            H_STUDY_AREA = study_area; % study_area: スタディエリア
            waitfor(H_STUDY_AREA);     % ユーザーの緯度と経度情報の入力を待つ
            h = findobj('Tag','main_menu_window2'); % main_menu_windowのハンドルを取得
            if isempty(h)~=1 & isempty(H_MAIN)~=1   % main_menu_windowのハンドル、H_MAINが空でない場合
                iflag = check_lonlat_info2;         % 経度と緯度の情報をチェック
                if iflag == 1                       % iflagが1の場合
                    all_overlay_enable_on(app);          % すべてのオーバーレイを有効にする
                end
            end
        end

        % Menu selected function: menu_most_recent_file
        function menu_most_recent_file_Callback(app, event)
            %-------------------------------------------------------------------------
            %           OPEN/most recent file (submenu) 最近使用したファイルを開くサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 最近使用したファイルを開くサブメニューをクリックしたときのコールバック関数
            
            global DIALOG_SKIP % ダイアログスキップ
            global INPUT_VARS
            global CALC_CONTROL
            global OVERLAY_VARS
            
            coulomb_init2;
            clear_obj_and_subfig;
            
            DIALOG_SKIP = 0;
            last_input;
            CALC_CONTROL.FUNC_SWITCH = 0;
            if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
                all_functions_enable_on(app);
                set(findobj('Tag','menu_file_save'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
                set(findobj('Tag','menu_map_info'),'Enable','On');
                all_overlay_enable_off(app);
                set(findobj('Tag','menu_trace_put_faults'),'Enable','On');
            end
            if isempty(OVERLAY_VARS.EQ_DATA) % 地震データが空の場合
                set(findobj('Tag','menu_focal_mech'),'Enable','Off'); % フォーカルメカニズムメニューを無効にする
            else
                set(findobj('Tag','menu_focal_mech'),'Enable','On'); % フォーカルメカニズムメニューを有効にする
            end
        end

        % Menu selected function: menu_new
        function menu_new_Callback(app, event)
            %-------------------------------------------------------------------------
            %           NEW (submenu)  新規作成サブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 新規作成サブメニューをクリックしたときのコールバック関数
            
            global H_GRID_INPUT % グリッド入力ウィンドウのハンドル
            global INPUT_VARS
            global COORD_VARS
            global OVERLAY_VARS
            global CALC_CONTROL
            global SYSTEM_VARS
            global OKADA_OUTPUT
            
            coulomb_init2;
            clear_obj_and_subfig;
            
            OKADA_OUTPUT.S_ELEMENT = []; % 要素の初期化
            CALC_CONTROL.IACT = 0;
            INPUT_VARS.INUM = 0;         % INUM: 要素の数
            INPUT_VARS.ELEMENT = [];
            INPUT_VARS.GRID = [];        % グリッドの初期化
            OVERLAY_VARS.COAST_DATA = [];
            OVERLAY_VARS.AFAULT_DATA = [];       % 海岸データ、断層データの初期化
            SYSTEM_VARS.INPUT_FILE = 'untitled'; % 入力ファイル名
            
            if COORD_VARS.ICOORD == 2  % 現在の座標モードが「経度と緯度」の場合
                h = warndlg('Coordinates mode automatically changes to ''Cartesian'' now','!! Warning !!'); % warndlg: 警告ダイアログを表示
                waitfor(h);            % waitfor: モーダルダイアログボックスの終了を待つ
                COORD_VARS.ICOORD = 1; % xとyの直交座標に変更
            end
            if isempty(INPUT_VARS.GRID) % グリッドが空の場合
                INPUT_VARS.GRID(1,1) = -50.01; % x start
                INPUT_VARS.GRID(2,1) = -50.01; % y start
                INPUT_VARS.GRID(3,1) =  50.00; % x finish
                INPUT_VARS.GRID(4,1) =  50.00; % y finish
                INPUT_VARS.GRID(5,1) =   5.00; % x increment % xの増分
                INPUT_VARS.GRID(6,1) =   5.00; % y increment % yの増分
            end
            
            H_GRID_INPUT = grid_input_window2;
            CALC_CONTROL.FUNC_SWITCH = 0; % 関数スイッチを0に設定
            if ~isempty(INPUT_VARS.GRID)  % グリッドが空でない場合、下のメニューを使えるようにする
                all_functions_enable_on(app);  % すべての関数を有効にする
                set(findobj('Tag','menu_file_save'),'Enable','On');        % ファイル保存メニュー
                set(findobj('Tag','menu_file_save_ascii'),'Enable','On');  % ファイル保存メニュー
                set(findobj('Tag','menu_file_save_ascii2'),'Enable','On'); % ファイル保存メニュー
                set(findobj('Tag','menu_map_info'),'Enable','On');         % マップ情報メニュー
                all_overlay_enable_off(app);                                    % すべてのオーバーレイを無効にする
                set(findobj('Tag','menu_trace_put_faults'),'Enable','On'); % トレースプットフォルトメニュー
            end
        end

        % Menu selected function: menu_new_map
        function menu_new_map_Callback(app, event)
            %-------------------------------------------------------------------------
            %           NEW from Map (submenu)  地図から新規作成サブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 地図から新規作成サブメニューをクリックしたときのコールバック関数
            
            global H_UTM % UTMウィンドウ
            global INPUT_VARS
            global CALC_CONTROL
            global OVERLAY_VARS
            global SYSTEM_VARS
            
            coulomb_init2;        % グローバル変数の初期化
            clear_obj_and_subfig; % オブジェクトとサブフィギュアをクリア
            
            CALC_CONTROL.IACT = 0;
            INPUT_VARS.INUM = 0;
            OVERLAY_VARS.COAST_DATA = [];
            OVERLAY_VARS.AFAULT_DATA = [];       % 海岸データ、断層データの初期化
            SYSTEM_VARS.INPUT_FILE = 'untitled'; % 入力ファイル名
            
            set(findobj('Tag','menu_file_save'),'Enable','Off');
            set(findobj('Tag','menu_file_save_ascii'),'Enable','Off');
            set(findobj('Tag','menu_file_save_ascii2'),'Enable','Off');
            all_functions_enable_off(app); % すべての関数を無効にする
            all_overlay_enable_off(app);   % すべてのオーバーレイを無効にする
            
            H_UTM = utm_window;
            waitfor(H_UTM);              % waitfor: モーダルダイアログボックスの終了を待つ
            if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
                all_functions_enable_on(app); % すべての関数を有効にする
                set(findobj('Tag','menu_file_save'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
                set(findobj('Tag','menu_map_info'),'Enable','On');
                all_overlay_enable_on(app);
                set(findobj('Tag','menu_focal_mech'),'Enable','On');
            end
        end

        % Menu selected function: menu_normal_stress_change
        function menu_normal_stress_change_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_COULOMB
            global CALC_CONTROL
            subfig_clear;
            CALC_CONTROL.IACT = 0;
            CALC_CONTROL.FUNC_SWITCH = 8;
            CALC_CONTROL.STRESS_TYPE = 5;
            H_COULOMB = coulomb_window; % coulomb_windowを開く
            set(findobj('Tag','text_fric'),'Visible','off');
            set(findobj('Tag','edit_coul_fric'),'Visible','off');
            flag = check_lonlat_info2; % 経度と緯度の情報をチェック
            if flag == 1
                all_overlay_enable_on(app);
            end
        end

        % Menu selected function: menu_open_skipping
        function menu_open_skipping_Callback(app, event)
            %-------------------------------------------------------------------------
            %           OPEN/SKIPPING DIALOG (submenu) ダイアログをスキップして開くサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % ダイアログをスキップして開くサブメニューをクリックしたときのコールバック関数
            global DIALOG_SKIP % ダイアログスキップ
            global INPUT_VARS
            global CALC_CONTROL
            
            DIALOG_SKIP = 0;
            input_open(3); % 3はオープンウィンドウをスキップすることを意味する
            if ~isempty(INPUT_VARS.GRID) % グリッドが空でない場合、下のメニューを使えるようにする
                all_functions_enable_on(app);
                set(findobj('Tag','menu_file_save'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
                set(findobj('Tag','menu_file_save_ascii2'),'Enable','On');
                set(findobj('Tag','menu_map_info'),'Enable','On');
                all_overlay_enable_off(app);
                set(findobj('Tag','menu_trace_put_faults'),'Enable','On');
            end
            try % 例外処理
                check_overlay_items(app); % オーバーレイアイテムをチェック
                if CALC_CONTROL.IACT == 0 % ユーザーがキャンセルを選択した場合、CALC_CONTROL.IACTは1から 'input_open.m' に転送される
                menu_grid_mapview_Callback;
                CALC_CONTROL.FUNC_SWITCH = 0;
                end
            catch
                return
            end
        end

        % Menu selected function: menu_preferences
        function menu_preferences_Callback(app, event)
            %-------------------------------------------------------------------------
            %           PREFERENCES (submenu) プリファレンスサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % プリファレンスサブメニューをクリックしたときのコールバック関数
            global SYSTEM_VARS
            preference_window; % プリファレンスウィンドウ
            if SYSTEM_VARS.OUTFLAG == 1
                h = findobj('Tag','Radiobutton_output'); % Radiobutton_outputのハンドルを取得
                set(h,'Value',1);                        % Valueを1に設定
                h = findobj('Tag','Radiobutton_input');  % Radiobutton_inputのハンドルを取得
                set(h,'Value',0);                        % Valueを0に設定
            else
                h = findobj('Tag','Radiobutton_output'); % Radiobutton_outputのハンドルを取得
                set(h,'Value',0);                        % Valueを0に設定
                h = findobj('Tag','Radiobutton_input');  % Radiobutton_inputのハンドルを取得
                set(h,'Value',1);                        % Valueを1に設定
            end
        end

        % Menu selected function: menu_quit
        function menu_quit_Callback(app, event)
            %-------------------------------------------------------------------------
            %           QUIT (submenu) 終了サブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 終了サブメニューをクリックしたときのコールバック関数
            global H_HELP FNUM_ONOFF
            global SYSTEM_VARS
            subfig_clear;  % サブフィギュアをクリア
            tempdir = pwd; % 現在のディレクトリを取得
            if ~strcmp(tempdir,SYSTEM_VARS.HOME_DIR) % tempdirとHOME_DIRが異なる場合
                cd(SYSTEM_VARS.HOME_DIR);
            end
            cd preferences2
                dlmwrite('preferences2.dat',SYSTEM_VARS.PREF,'delimiter',' ','precision','%3.1f'); % プリファレンスを保存 delimiter: 区切り文字
                        if isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが空の場合
                            SYSTEM_VARS.OUTFLAG = 1;
                        end
                        if isempty(SYSTEM_VARS.PREF_DIR) == 1 % PREF_DIRが空の場合
                            SYSTEM_VARS.PREF_DIR = SYSTEM_VARS.HOME_DIR;
                        end
                        if isempty(SYSTEM_VARS.INPUT_FILE) == 1 % INPUT_FILEが空の場合
                            SYSTEM_VARS.INPUT_FILE = 'empty';
                        end
                save preferences2.mat SYSTEM_VARS.PREF_DIR SYSTEM_VARS.INPUT_FILE SYSTEM_VARS.OUTFLAG FNUM_ONOFF; % プリファレンスを保存
            cd ..
            h = figure(gcf); % 現在の図を取得
            delete(h); % 図を削除
            % ヘルプウィンドウ（H_HELP）のため
            h = findobj('Tag','coulomb_help_window'); % coulomb_help_windowのハンドルを取得
            if (isempty(h)~=1 && isempty(H_HELP)~=1)  % hが空でなく、H_HELPが空でない場合
                close(figure(H_HELP))                 % ヘルプウィンドウを閉じる
                H_HELP = [];                          % H_HELPを空にする
            end
        end

        % Menu selected function: menu_shear_stress_change
        function menu_shear_stress_change_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_COULOMB
            global CALC_CONTROL
            subfig_clear;
            CALC_CONTROL.IACT = 0;
            CALC_CONTROL.FUNC_SWITCH = 7;
            CALC_CONTROL.STRESS_TYPE = 5;
            H_COULOMB = coulomb_window;
            set(findobj('Tag','text_fric'),'Visible','off');      % text_fricを非表示
            set(findobj('Tag','edit_coul_fric'),'Visible','off'); % edit_coul_fricを非表示
            flag = check_lonlat_info2;
            if flag == 1
                all_overlay_enable_on(app);
            end
        end

        % Menu selected function: menu_strain
        function menu_strain_Callback(app, event)
            %-------------------------------------------------------------------------
            %           STRAIN (submenu) ひずみサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_STRAIN H_MAIN
            global CALC_CONTROL
            global OVERLAY_VARS
            
            subfig_clear;
            CALC_CONTROL.IACT = 0;
            CALC_CONTROL.FUNC_SWITCH = 6;
            CALC_CONTROL.SHADE_TYPE = 1;    % default
            CALC_CONTROL.STRAIN_SWITCH = 1; % default sig XX
            H_STRAIN = strain_window;       % strain_windowを開く
            flag = check_lonlat_info2;      % 経度と緯度の情報をチェック
            if flag == 1
                all_overlay_enable_on(app);      % すべてのオーバーレイを有効にする
            end
            % ----- overlay drawing --------------------------------
            if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |...
                isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1
                figure(H_MAIN);
                hold on;
                overlay_drawing;
            end
        end

        % Menu selected function: menu_stress_on_a_fault
        function menu_stress_on_a_fault_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_POINT
            global CALC_CONTROL
            CALC_CONTROL.IACT = 0;
            if CALC_CONTROL.FUNC_SWITCH ~= 7 && CALC_CONTROL.FUNC_SWITCH ~= 8 && CALC_CONTROL.FUNC_SWITCH ~= 9
                subfig_clear;
                CALC_CONTROL.FUNC_SWITCH = 1;
                grid_drawing2;
                fault_overlay;
            end
            H_POINT = point_calc_window; % point_calc_windowを開く
            flag = check_lonlat_info2;   % 経度と緯度の情報をチェック
            if flag == 1
                all_overlay_enable_on(app);
            end
        end

        % Menu selected function: menu_stress_on_faults
        function menu_stress_on_faults_Callback(app, event)
            % --------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_EC_CONTROL
            global COORD_VARS
            global CALC_CONTROL
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1 % COORD_VARS.ICOORDが2で、COORD_VARS.LON_GRIDが空でない場合
                h = warndlg('Sorry this is not available for lat/lon coordinates. Change to Cartesian coordinates.','!! Warning !!');
                waitfor(h);
                return
            end
            subfig_clear;
            CALC_CONTROL.FUNC_SWITCH = 10;
            H_EC_CONTROL = ec_control_window2;
        end

        % Menu selected function: menu_taper_split
        function menu_taper_split_Callback(app, event)
            %-------------------------------------------------------------------------
            %           TAPER & SPLIT (submenu) テーパーとスプリットサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % テーパーとスプリットサブメニューをクリックしたときのコールバック関数
            global H_ELEMENT TAPER_CALLED
            H_ELEMENT = element_input_window;
            TAPER_CALLED = 1;
        end

        % Menu selected function: menu_trace_put_faults
        function menu_trace_put_faults_Callback(app, event)
            %-------------------------------------------------------------------------
            %           Trace faults and put them into input file (submenu) 断層をトレースして入力ファイルに入れるサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層をトレースして入力ファイルに入れるサブメニューをクリックしたときのコールバック関数
            new_fault_mouse_clicks;
        end

        % Menu selected function: menu_vectors
        function menu_vectors_Callback(app, event)
            %-------------------------------------------------------------------------
            %                       VECTORS (sub-submenu) ベクトルサブサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % ベクトルサブサブメニューをクリックしたときのコールバック関数
            global H_DISPL FIXFLAG H_MAIN
            global COORD_VARS
            global CALC_CONTROL
            global OKADA_OUTPUT
            global OVERLAY_VARS
            global SYSTEM_VARS
            
            subfig_clear;                 % サブフィギュアをクリア
            CALC_CONTROL.FUNC_SWITCH = 2; % 関数スイッチを2に設定
            FIXFLAG = 0;                  % FIXFLAGを0に設定
            % Okadaハーフスペースの再計算を回避するため
            if CALC_CONTROL.IACT ~= 1
                Okada_halfspace; % Okadaハーフスペースを計算
            end
            CALC_CONTROL.IACT = 1;            % Okadaの出力を保持するため
                a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
                b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
                c = horzcat(a,b);             % aとbを水平に連結
                format long;
                if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが1または空の場合
            	    cd output_files; % output_filesに移動
                else
            	    cd (PSYSTEM_VARS.REF_DIR);
                end
                header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE]; % 選択された入力ファイル
                header2 = 'x y z UX UY UZ';             % ヘッダー
                header3 = '(km) (km) (km) (m) (m) (m)'; % ヘッダー
                dlmwrite('Displacement.cou',header1,'delimiter','');           % Displacement.couにheader1を書き込む
                dlmwrite('Displacement.cou',header2,'-append','delimiter',''); % Displacement.couにheader2を追加
                dlmwrite('Displacement.cou',header3,'-append','delimiter',''); % Displacement.couにheader3を追加
                dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f'); % Displacement.couにcを追加
                disp(['Displacement.cou is saved in ' pwd]);                                  % Displacement.couが保存されました
                cd (SYSTEM_VARS.HOME_DIR);
            displ_open2(2); % 2を開く
            H_DISPL = displ_h_window2;
            if COORD_VARS.ICOORD == 1 % COORD_VARS.ICOORDが1の場合 → 経度と緯度のメニューを非表示
                set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off'); % radiobutton_fixlonlatを非表示
                set(findobj('Tag','text_disp_lon'),'Visible','off');         % text_disp_lonを非表示
                set(findobj('Tag','text_disp_lat'),'Visible','off');         % text_disp_latを非表示
                set(findobj('Tag','edit_fixlon'),'Visible','off');           % edit_fixlonを非表示
                set(findobj('Tag','edit_fixlat'),'Visible','off');           % edit_fixlatを非表示
            else % COORD_VARS.ICOORDが1でない場合 → カートジアン座標のメニューを非表示
                set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
                set(findobj('Tag','text_cart_x'),'Visible','off');
                set(findobj('Tag','text_cart_y'),'Visible','off');
                set(findobj('Tag','text_x_km'),'Visible','off');
                set(findobj('Tag','text_y_km'),'Visible','off');
                set(findobj('Tag','edit_fixx'),'Visible','off');
                set(findobj('Tag','edit_fixy'),'Visible','off');
            end
            flag = check_lonlat_info2; % 経度と緯度の情報をチェック
            if flag == 1 % flagが1の場合
                all_overlay_enable_on(app); % すべてのオーバーレイを有効にする
            end
            % ----- overlay drawing オーバーレイの描画 --------------------------------
            if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
                isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1  % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
                figure(H_MAIN);
                hold on;
                overlay_drawing; % オーバーレイの描画
            end
        end

        % Menu selected function: menu_wireframe
        function menu_wireframe_Callback(app, event)
            %-------------------------------------------------------------------------
            %          WIREFRAME (sub-submenu) ワイヤフレームサブサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % ワイヤフレームサブサブメニューをクリックしたときのコールバック関数
            global FIXFLAG H_DISPL H_MAIN
            global CALC_CONTROL
            global OKADA_OUTPUT
            global OVERLAY_VARS
            global SYSTEM_VARS
            
            subfig_clear;                 % サブフィギュアをクリア
            CALC_CONTROL.FUNC_SWITCH = 3; % 関数スイッチを3に設定
            FIXFLAG = 0;                  % FIXFLAGを0に設定
            % Okadaハーフスペースの再計算を回避するため
            if CALC_CONTROL.IACT ~= 1
                Okada_halfspace;          % Okadaハーフスペースを計算
            end
            CALC_CONTROL.IACT = 1;        % Okadaの出力を保持するため
            a = OKADA_OUTPUT.DC3D(:,1:2); % DC3Dの1から2列を取得
            b = OKADA_OUTPUT.DC3D(:,5:8); % DC3Dの5から8列を取得
            c = horzcat(a,b);             % aとbを水平に連結
            format long;
            if SYSTEM_VARS.OUTFLAG == 1 | isempty(SYSTEM_VARS.OUTFLAG) == 1 % OUTFLAGが1または空の場合
                cd output_files;           % output_filesに移動
            else
                cd (SYSTEM_VARS.PREF_DIR); % PREF_DIRに移動
            end
            % Displacement.couをASCII形式で保存
            header1 = ['Input file selected: ',SYSTEM_VARS.INPUT_FILE]; % 選択された入力ファイル
            header2 = 'x y z UX UY UZ';             % ヘッダー
            header3 = '(km) (km) (km) (m) (m) (m)'; % ヘッダー
            dlmwrite('Displacement.cou',header1,'delimiter','');             % Displacement.couにheader1を書き込む
            dlmwrite('Displacement.cou',header2,'-append','delimiter','\t'); % Displacement.couにheader2を追加
            dlmwrite('Displacement.cou',header3,'-append','delimiter','\t'); % Displacement.couにheader3を追加
            dlmwrite('Displacement.cou',c,'-append','delimiter','\t','precision','%.8f'); % Displacement.couにcを追加
            disp(['Displacement.cou is saved in ' pwd]);                                  % Displacement.couが保存されました
            cd (SYSTEM_VARS.HOME_DIR);                                                    % HOME_DIRに移動
            
            displ_open2(2); % 2を開く
            H_DISPL = displ_h_window2; % ディスプレイスメントウィンドウ
            set(findobj('Tag','radiobutton_fixlonlat'),'Visible','off'); % radiobutton_fixlonlatを非表示
            set(findobj('Tag','radiobutton_fixcart'),'Visible','off');
            set(findobj('Tag','text_cart_x'),'Visible','off');
            set(findobj('Tag','text_cart_y'),'Visible','off');
            set(findobj('Tag','edit_fixx'),'Visible','off');
            set(findobj('Tag','edit_fixy'),'Visible','off');
            set(findobj('Tag','text_x_km'),'Visible','off');
            set(findobj('Tag','text_y_km'),'Visible','off');
            set(findobj('Tag','text_disp_lon'),'Visible','off');
            set(findobj('Tag','text_disp_lat'),'Visible','off');
            set(findobj('Tag','edit_fixlon'),'Visible','off');
            set(findobj('Tag','edit_fixlat'),'Visible','off');
            set(findobj('Tag','Mouse_click'),'Visible','off');
            flag = check_lonlat_info2; % 経度と緯度の情報をチェック
            if flag == 1 % flagが1の場合
                all_overlay_enable_on(app); % すべてのオーバーレイを有効にする
            end
            % ----- overlay drawing オーバーレイの描画 --------------------------------
            if isempty(OVERLAY_VARS.COAST_DATA)~=1 | isempty(OVERLAY_VARS.EQ_DATA)~=1 |... % COAST_DATAが空でない場合、EQ_DATAが空でない場合
                isempty(OVERLAY_VARS.AFAULT_DATA)~=1 | isempty(OVERLAY_VARS.GPS_DATA)~=1  % AFAULT_DATAが空でない場合、GPS_DATAが空でない場合
                figure(H_MAIN);
                hold on;         % H_MAINの図を保持
                overlay_drawing; % オーバーレイの描画
            end
        end

        % Menu selected function: submenu_clear_afaults
        function submenu_clear_afaults_Callback(app, event)
            %-------------------------------------------------------------------------
            %       Submenu clear active fault data (submenu) アクティブフォールトデータをクリアするサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_MAIN
            global OVERLAY_VARS
            OVERLAY_VARS.AFAULT_DATA = [];
            set(findobj('Tag','menu_activefaults'),'Checked','Off');
            figure(H_MAIN);
            try
                h = findobj('Tag','AfaultObj');
                delete(h);
            catch
                return
            end
        end

        % Menu selected function: submenu_clear_coastlines
        function submenu_clear_coastlines_Callback(app, event)
            %-------------------------------------------------------------------------
            %       Submenu clear coastline data (submenu) 海岸線データをクリアするサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_MAIN
            global OVERLAY_VARS
            OVERLAY_VARS.COAST_DATA = [];
            set(findobj('Tag','menu_coastlines'),'Checked','Off'); % 'Tag'が'menu_coastlines'のオブジェクトを取得
            figure(H_MAIN);
            try
                h = findobj('Tag','CoastlineObj');
                delete(h);
            catch
                return
            end
        end

        % Menu selected function: submenu_clear_earthquakes
        function submenu_clear_earthquakes_Callback(app, event)
            %-------------------------------------------------------------------------
            %       Submenu clear earthquake data (submenu) 地震データをクリアするサブメニュー
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            global H_MAIN
            global OVERLAY_VARS
            OVERLAY_VARS.EQ_DATA = [];
            set(findobj('Tag','menu_earthquakes'),'Checked','Off');
            set(findobj('Tag','menu_focal_mech'),'Enable','Off');
            figure(H_MAIN);
            try
                h = findobj('Tag','EqObj');
                delete(h);
            catch
                return
            end
            try
                h = findobj('Tag','EqObj2');
                delete(h);
            catch
                return
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create main_menu_window and hide until all components are created
            app.main_menu_window = uifigure('Visible', 'off');
            app.main_menu_window.IntegerHandle = 'on';
            app.main_menu_window.Color = [1 1 1];
            colormap(app.main_menu_window, 'parula');
            app.main_menu_window.Position = [1 756 600 625];
            app.main_menu_window.Name = 'Coulomb 3.1';
            app.main_menu_window.HandleVisibility = 'callback';
            app.main_menu_window.Tag = 'main_menu_window';

            % Create data_menu
            app.data_menu = uimenu(app.main_menu_window);
            app.data_menu.Checked = 'on';
            app.data_menu.Text = 'Input';
            app.data_menu.Tag = 'data_menu';

            % Create menu_about
            app.menu_about = uimenu(app.data_menu);
            app.menu_about.MenuSelectedFcn = createCallbackFcn(app, @menu_about_Callback, true);
            app.menu_about.Text = 'About Coulomb 3.3';
            app.menu_about.Tag = 'menu_about';

            % Create menu_most_recent_file
            app.menu_most_recent_file = uimenu(app.data_menu);
            app.menu_most_recent_file.MenuSelectedFcn = createCallbackFcn(app, @menu_most_recent_file_Callback, true);
            app.menu_most_recent_file.Separator = 'on';
            app.menu_most_recent_file.Accelerator = 'J';
            app.menu_most_recent_file.Text = 'Open most recent input file';
            app.menu_most_recent_file.Tag = 'menu_most_recent_file';

            % Create menu_open_skipping
            app.menu_open_skipping = uimenu(app.data_menu);
            app.menu_open_skipping.MenuSelectedFcn = createCallbackFcn(app, @menu_open_skipping_Callback, true);
            app.menu_open_skipping.Accelerator = 'O';
            app.menu_open_skipping.Text = 'Open existing input file';
            app.menu_open_skipping.Tag = 'menu_open_skipping';

            % Create menu_file_open
            app.menu_file_open = uimenu(app.data_menu);
            app.menu_file_open.MenuSelectedFcn = createCallbackFcn(app, @menu_file_open_Callback, true);
            app.menu_file_open.Accelerator = 'K';
            app.menu_file_open.Text = 'Open & edit input file';
            app.menu_file_open.Tag = 'menu_file_open';

            % Create menu_new
            app.menu_new = uimenu(app.data_menu);
            app.menu_new.MenuSelectedFcn = createCallbackFcn(app, @menu_new_Callback, true);
            app.menu_new.Separator = 'on';
            app.menu_new.Accelerator = 'N';
            app.menu_new.Text = 'Build input file from x & y map';
            app.menu_new.Tag = 'menu_new';

            % Create menu_new_map
            app.menu_new_map = uimenu(app.data_menu);
            app.menu_new_map.MenuSelectedFcn = createCallbackFcn(app, @menu_new_map_Callback, true);
            app.menu_new_map.Accelerator = 'M';
            app.menu_new_map.Text = 'Build input file from lon. & lat. map';
            app.menu_new_map.Tag = 'menu_new_map';

            % Create menu_file_save_ascii
            app.menu_file_save_ascii = uimenu(app.data_menu);
            app.menu_file_save_ascii.MenuSelectedFcn = createCallbackFcn(app, @menu_file_save_ascii_Callback, true);
            app.menu_file_save_ascii.Enable = 'off';
            app.menu_file_save_ascii.Separator = 'on';
            app.menu_file_save_ascii.Accelerator = 'S';
            app.menu_file_save_ascii.Text = 'Save input file as .inp (ASCII)';
            app.menu_file_save_ascii.Tag = 'menu_file_save_ascii';

            % Create menu_file_save_ascii2
            app.menu_file_save_ascii2 = uimenu(app.data_menu);
            app.menu_file_save_ascii2.MenuSelectedFcn = createCallbackFcn(app, @menu_file_save_ascii2_Callback, true);
            app.menu_file_save_ascii2.Enable = 'off';
            app.menu_file_save_ascii2.Text = 'Save input file as .inr (ASCII)';
            app.menu_file_save_ascii2.Tag = 'menu_file_save_ascii2';

            % Create menu_file_save
            app.menu_file_save = uimenu(app.data_menu);
            app.menu_file_save.MenuSelectedFcn = createCallbackFcn(app, @menu_file_save_Callback, true);
            app.menu_file_save.Enable = 'off';
            app.menu_file_save.Text = 'Save input file as .mat (binary)';
            app.menu_file_save.Tag = 'menu_file_save';

            % Create menu_map_info
            app.menu_map_info = uimenu(app.data_menu);
            app.menu_map_info.MenuSelectedFcn = createCallbackFcn(app, @menu_map_info_Callback, true);
            app.menu_map_info.Enable = 'off';
            app.menu_map_info.Separator = 'on';
            app.menu_map_info.Text = 'Add coord''s to input file';
            app.menu_map_info.Tag = 'menu_map_info';

            % Create menu_preferences
            app.menu_preferences = uimenu(app.data_menu);
            app.menu_preferences.MenuSelectedFcn = createCallbackFcn(app, @menu_preferences_Callback, true);
            app.menu_preferences.Separator = 'on';
            app.menu_preferences.Text = 'Preferences...';
            app.menu_preferences.Tag = 'menu_preferences';

            % Create menu_quit
            app.menu_quit = uimenu(app.data_menu);
            app.menu_quit.MenuSelectedFcn = createCallbackFcn(app, @menu_quit_Callback, true);
            app.menu_quit.Separator = 'on';
            app.menu_quit.Accelerator = 'W';
            app.menu_quit.Text = 'Quit';
            app.menu_quit.Tag = 'menu_quit';

            % Create function_menu
            app.function_menu = uimenu(app.main_menu_window);
            app.function_menu.Text = 'Functions';
            app.function_menu.Tag = 'function_menu';

            % Create menu_grid
            app.menu_grid = uimenu(app.function_menu);
            app.menu_grid.Enable = 'off';
            app.menu_grid.Text = 'Grid';
            app.menu_grid.Tag = 'menu_grid';

            % Create menu_grid_mapview
            app.menu_grid_mapview = uimenu(app.menu_grid);
            app.menu_grid_mapview.MenuSelectedFcn = createCallbackFcn(app, @menu_grid_mapview_Callback, true);
            app.menu_grid_mapview.Accelerator = 'G';
            app.menu_grid_mapview.Text = '2D map view';
            app.menu_grid_mapview.Tag = 'menu_grid_mapview';

            % Create menu_grid_3d
            app.menu_grid_3d = uimenu(app.menu_grid);
            app.menu_grid_3d.MenuSelectedFcn = createCallbackFcn(app, @menu_grid_3d_Callback, true);
            app.menu_grid_3d.Accelerator = 'T';
            app.menu_grid_3d.Text = '3D view';
            app.menu_grid_3d.Tag = 'menu_grid_3d';

            % Create menu_displacement
            app.menu_displacement = uimenu(app.function_menu);
            app.menu_displacement.Enable = 'off';
            app.menu_displacement.Text = 'Displacements';
            app.menu_displacement.Tag = 'menu_displacement';

            % Create menu_vectors
            app.menu_vectors = uimenu(app.menu_displacement);
            app.menu_vectors.MenuSelectedFcn = createCallbackFcn(app, @menu_vectors_Callback, true);
            app.menu_vectors.Accelerator = 'R';
            app.menu_vectors.Text = 'Horizontal displ. (vectors)';
            app.menu_vectors.Tag = 'menu_vectors';

            % Create menu_wireframe
            app.menu_wireframe = uimenu(app.menu_displacement);
            app.menu_wireframe.MenuSelectedFcn = createCallbackFcn(app, @menu_wireframe_Callback, true);
            app.menu_wireframe.Text = 'Horizontal displ. (wireframe)';
            app.menu_wireframe.Tag = 'menu_wireframe';

            % Create menu_contours
            app.menu_contours = uimenu(app.menu_displacement);
            app.menu_contours.MenuSelectedFcn = createCallbackFcn(app, @menu_contours_Callback, true);
            app.menu_contours.Text = 'Vertical displ. (color & contours)';
            app.menu_contours.Tag = 'menu_contours';

            % Create menu_3d
            app.menu_3d = uimenu(app.menu_displacement);
            app.menu_3d.MenuSelectedFcn = createCallbackFcn(app, @menu_3d_Callback, true);
            app.menu_3d.Text = '3D image drape';
            app.menu_3d.Tag = 'menu_3d';

            % Create menu_3d_wire
            app.menu_3d_wire = uimenu(app.menu_displacement);
            app.menu_3d_wire.MenuSelectedFcn = createCallbackFcn(app, @menu_3d_wire_Callback, true);
            app.menu_3d_wire.Text = '3D image wireframed surface';
            app.menu_3d_wire.Tag = 'menu_3d_wire';

            % Create menu_3d_vectors
            app.menu_3d_vectors = uimenu(app.menu_displacement);
            app.menu_3d_vectors.MenuSelectedFcn = createCallbackFcn(app, @menu_3d_vectors_Callback, true);
            app.menu_3d_vectors.Text = '3D vectors';
            app.menu_3d_vectors.Tag = 'menu_3d_vectors';

            % Create menu_strain
            app.menu_strain = uimenu(app.function_menu);
            app.menu_strain.MenuSelectedFcn = createCallbackFcn(app, @menu_strain_Callback, true);
            app.menu_strain.Enable = 'off';
            app.menu_strain.Text = 'Strain';
            app.menu_strain.Tag = 'menu_strain';

            % Create menu_stress
            app.menu_stress = uimenu(app.function_menu);
            app.menu_stress.Enable = 'off';
            app.menu_stress.Text = 'Stress';
            app.menu_stress.Tag = 'menu_stress';

            % Create menu_shear_stress_change
            app.menu_shear_stress_change = uimenu(app.menu_stress);
            app.menu_shear_stress_change.MenuSelectedFcn = createCallbackFcn(app, @menu_shear_stress_change_Callback, true);
            app.menu_shear_stress_change.Text = 'Shear stress change';
            app.menu_shear_stress_change.Tag = 'menu_shear_stress_change';

            % Create menu_normal_stress_change
            app.menu_normal_stress_change = uimenu(app.menu_stress);
            app.menu_normal_stress_change.MenuSelectedFcn = createCallbackFcn(app, @menu_normal_stress_change_Callback, true);
            app.menu_normal_stress_change.Text = 'Normal stress change';
            app.menu_normal_stress_change.Tag = 'menu_normal_stress_change';

            % Create menu_coulomb_stress_change
            app.menu_coulomb_stress_change = uimenu(app.menu_stress);
            app.menu_coulomb_stress_change.MenuSelectedFcn = createCallbackFcn(app, @menu_coulomb_stress_change_Callback, true);
            app.menu_coulomb_stress_change.Accelerator = 'L';
            app.menu_coulomb_stress_change.Text = 'Coulomb stress change';
            app.menu_coulomb_stress_change.Tag = 'menu_coulomb_stress_change';

            % Create menu_stress_on_faults
            app.menu_stress_on_faults = uimenu(app.menu_stress);
            app.menu_stress_on_faults.MenuSelectedFcn = createCallbackFcn(app, @menu_stress_on_faults_Callback, true);
            app.menu_stress_on_faults.Separator = 'on';
            app.menu_stress_on_faults.Accelerator = 'E';
            app.menu_stress_on_faults.Text = 'Calc. stress on faults';
            app.menu_stress_on_faults.Tag = 'menu_stress_on_faults';

            % Create menu_stress_on_a_fault
            app.menu_stress_on_a_fault = uimenu(app.menu_stress);
            app.menu_stress_on_a_fault.MenuSelectedFcn = createCallbackFcn(app, @menu_stress_on_a_fault_Callback, true);
            app.menu_stress_on_a_fault.Separator = 'on';
            app.menu_stress_on_a_fault.Text = 'Calc. stress on a point';
            app.menu_stress_on_a_fault.Tag = 'menu_stress_on_a_fault';

            % Create menu_focal_mech
            app.menu_focal_mech = uimenu(app.menu_stress);
            app.menu_focal_mech.MenuSelectedFcn = createCallbackFcn(app, @menu_focal_mech_Callback, true);
            app.menu_focal_mech.Enable = 'off';
            app.menu_focal_mech.Text = 'Calc. stress on nodal planes';
            app.menu_focal_mech.Tag = 'menu_focal_mech';

            % Create menu_change_parameters
            app.menu_change_parameters = uimenu(app.function_menu);
            app.menu_change_parameters.Enable = 'off';
            app.menu_change_parameters.Separator = 'on';
            app.menu_change_parameters.Text = 'Change parameters';
            app.menu_change_parameters.Tag = 'menu_change_parameters';

            % Create menu_all_parameters
            app.menu_all_parameters = uimenu(app.menu_change_parameters);
            app.menu_all_parameters.MenuSelectedFcn = createCallbackFcn(app, @menu_all_parameters_Callback, true);
            app.menu_all_parameters.Accelerator = 'A';
            app.menu_all_parameters.Text = 'All input parameters';
            app.menu_all_parameters.Tag = 'menu_all_parameters';

            % Create menu_grid_size
            app.menu_grid_size = uimenu(app.menu_change_parameters);
            app.menu_grid_size.MenuSelectedFcn = createCallbackFcn(app, @menu_grid_size_Callback, true);
            app.menu_grid_size.Separator = 'on';
            app.menu_grid_size.Accelerator = 'B';
            app.menu_grid_size.Text = 'Grid size';
            app.menu_grid_size.Tag = 'menu_grid_size';

            % Create menu_calc_depth
            app.menu_calc_depth = uimenu(app.menu_change_parameters);
            app.menu_calc_depth.MenuSelectedFcn = createCallbackFcn(app, @menu_calc_depth_Callback, true);
            app.menu_calc_depth.Accelerator = 'D';
            app.menu_calc_depth.Text = 'Calculation depth';
            app.menu_calc_depth.Tag = 'menu_calc_depth';

            % Create menu_coeff_friction
            app.menu_coeff_friction = uimenu(app.menu_change_parameters);
            app.menu_coeff_friction.MenuSelectedFcn = createCallbackFcn(app, @menu_coeff_friction_Callback, true);
            app.menu_coeff_friction.Accelerator = 'F';
            app.menu_coeff_friction.Text = 'Coeff. friction';
            app.menu_coeff_friction.Tag = 'menu_coeff_friction';

            % Create menu_exaggeration
            app.menu_exaggeration = uimenu(app.menu_change_parameters);
            app.menu_exaggeration.MenuSelectedFcn = createCallbackFcn(app, @menu_exaggeration_Callback, true);
            app.menu_exaggeration.Accelerator = 'V';
            app.menu_exaggeration.Text = 'Displ. exaggeration';
            app.menu_exaggeration.Tag = 'menu_exaggeration';

            % Create menu_tools
            app.menu_tools = uimenu(app.function_menu);
            app.menu_tools.Separator = 'on';
            app.menu_tools.Text = 'Tools';
            app.menu_tools.Tag = 'menu_tools';

            % Create menu_taper_split
            app.menu_taper_split = uimenu(app.menu_tools);
            app.menu_taper_split.MenuSelectedFcn = createCallbackFcn(app, @menu_taper_split_Callback, true);
            app.menu_taper_split.Enable = 'off';
            app.menu_taper_split.Accelerator = 'U';
            app.menu_taper_split.Text = 'Taper or subdivide fault slip';
            app.menu_taper_split.Tag = 'menu_taper_split';

            % Create menu_cartesian
            app.menu_cartesian = uimenu(app.menu_tools);
            app.menu_cartesian.MenuSelectedFcn = createCallbackFcn(app, @menu_cartesian_Callback, true);
            app.menu_cartesian.Text = 'Convert lat/lon to Cartesian';
            app.menu_cartesian.Tag = 'menu_cartesian';

            % Create menu_calc_principal
            app.menu_calc_principal = uimenu(app.menu_tools);
            app.menu_calc_principal.MenuSelectedFcn = createCallbackFcn(app, @menu_calc_principal_Callback, true);
            app.menu_calc_principal.Text = 'Principal axes calculator';
            app.menu_calc_principal.Tag = 'menu_calc_principal';

            % Create menu_help
            app.menu_help = uimenu(app.function_menu);
            app.menu_help.Separator = 'on';
            app.menu_help.Text = 'Help';
            app.menu_help.Tag = 'menu_help';

            % Create overlay_menu
            app.overlay_menu = uimenu(app.main_menu_window);
            app.overlay_menu.Text = 'Overlay';
            app.overlay_menu.Tag = 'overlay_menu';

            % Create menu_coastlines
            app.menu_coastlines = uimenu(app.overlay_menu);
            app.menu_coastlines.MenuSelectedFcn = createCallbackFcn(app, @menu_coastlines_Callback, true);
            app.menu_coastlines.Enable = 'off';
            app.menu_coastlines.Text = 'Coast lines';
            app.menu_coastlines.Tag = 'menu_coastlines';

            % Create menu_activefaults
            app.menu_activefaults = uimenu(app.overlay_menu);
            app.menu_activefaults.MenuSelectedFcn = createCallbackFcn(app, @menu_activefaults_Callback, true);
            app.menu_activefaults.Enable = 'off';
            app.menu_activefaults.Text = 'Active faults';
            app.menu_activefaults.Tag = 'menu_activefaults';

            % Create menu_earthquakes
            app.menu_earthquakes = uimenu(app.overlay_menu);
            app.menu_earthquakes.MenuSelectedFcn = createCallbackFcn(app, @menu_earthquakes_Callback, true);
            app.menu_earthquakes.Enable = 'off';
            app.menu_earthquakes.Text = 'Earthquakes';
            app.menu_earthquakes.Tag = 'menu_earthquakes';

            % Create menu_volcanoes
            app.menu_volcanoes = uimenu(app.overlay_menu);
            app.menu_volcanoes.Enable = 'off';
            app.menu_volcanoes.Text = 'Volcanoes';
            app.menu_volcanoes.Tag = 'menu_volcanoes';

            % Create menu_gps
            app.menu_gps = uimenu(app.overlay_menu);
            app.menu_gps.Enable = 'off';
            app.menu_gps.Text = 'GPS stations';
            app.menu_gps.Tag = 'menu_gps';

            % Create menu_clear_overlay
            app.menu_clear_overlay = uimenu(app.overlay_menu);
            app.menu_clear_overlay.MenuSelectedFcn = createCallbackFcn(app, @menu_clear_overlay_Callback, true);
            app.menu_clear_overlay.Enable = 'off';
            app.menu_clear_overlay.Separator = 'on';
            app.menu_clear_overlay.Text = 'Clear overlay data from memory';
            app.menu_clear_overlay.Tag = 'menu_clear_overlay';

            % Create submenu_clear_coastlines
            app.submenu_clear_coastlines = uimenu(app.menu_clear_overlay);
            app.submenu_clear_coastlines.MenuSelectedFcn = createCallbackFcn(app, @submenu_clear_coastlines_Callback, true);
            app.submenu_clear_coastlines.Text = 'Clear coastline data';
            app.submenu_clear_coastlines.Tag = 'submenu_clear_coastlines';

            % Create submenu_clear_afaults
            app.submenu_clear_afaults = uimenu(app.menu_clear_overlay);
            app.submenu_clear_afaults.MenuSelectedFcn = createCallbackFcn(app, @submenu_clear_afaults_Callback, true);
            app.submenu_clear_afaults.Text = 'Clear active faults data';
            app.submenu_clear_afaults.Tag = 'submenu_clear_afaults';

            % Create submenu_clear_earthquakes
            app.submenu_clear_earthquakes = uimenu(app.menu_clear_overlay);
            app.submenu_clear_earthquakes.MenuSelectedFcn = createCallbackFcn(app, @submenu_clear_earthquakes_Callback, true);
            app.submenu_clear_earthquakes.Text = 'Clear earthquake data';
            app.submenu_clear_earthquakes.Tag = 'submenu_clear_earthquakes';

            % Create submenu_clear_volcanoes
            app.submenu_clear_volcanoes = uimenu(app.menu_clear_overlay);
            app.submenu_clear_volcanoes.Text = 'Clear volcanoes';
            app.submenu_clear_volcanoes.Tag = 'submenu_clear_volcanoes';

            % Create submenu_clear_gps
            app.submenu_clear_gps = uimenu(app.menu_clear_overlay);
            app.submenu_clear_gps.Text = 'Clear GPS data';
            app.submenu_clear_gps.Tag = 'submenu_clear_gps';

            % Create menu_trace_put_faults
            app.menu_trace_put_faults = uimenu(app.overlay_menu);
            app.menu_trace_put_faults.MenuSelectedFcn = createCallbackFcn(app, @menu_trace_put_faults_Callback, true);
            app.menu_trace_put_faults.Enable = 'off';
            app.menu_trace_put_faults.Separator = 'on';
            app.menu_trace_put_faults.Text = 'Trace and put faults into input';
            app.menu_trace_put_faults.Tag = 'menu_trace_put_faults';

            % Show the figure after all components are created
            app.main_menu_window.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main_menu_window2_App(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.main_menu_window)

                % Execute the startup function
                runStartupFcn(app, @(app)main_menu_window_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.main_menu_window)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.main_menu_window)
        end
    end
end