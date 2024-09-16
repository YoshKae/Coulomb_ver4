classdef utm_window_App < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        utm_window             matlab.ui.Figure
        text54                 matlab.ui.control.Label
        pushbutton_utm_ok      matlab.ui.control.Button
        pushbutton_utm_cancel  matlab.ui.control.Button
        edit_all_input_params  matlab.ui.control.Button
        uipanel2               matlab.ui.container.Panel
        text35                 matlab.ui.control.Label
        text34                 matlab.ui.control.Label
        text33                 matlab.ui.control.Label
        text32                 matlab.ui.control.Label
        text31                 matlab.ui.control.Label
        text30                 matlab.ui.control.Label
        text29                 matlab.ui.control.Label
        text28                 matlab.ui.control.Label
        text26                 matlab.ui.control.Label
        text25                 matlab.ui.control.Label
        text27                 matlab.ui.control.Label
        text24                 matlab.ui.control.Label
        text22                 matlab.ui.control.Label
        text53                 matlab.ui.control.Label
        text40                 matlab.ui.control.Label
        pushbutton_f_add       matlab.ui.control.Button
        pushbutton_f_calc      matlab.ui.control.Button
        edit_id_number         matlab.ui.control.EditField
        edit_f_bottom          matlab.ui.control.EditField
        edit_f_top             matlab.ui.control.EditField
        edit_rev_lat           matlab.ui.control.EditField
        edit_right_lat         matlab.ui.control.EditField
        edit_fy_finish         matlab.ui.control.EditField
        edit_fx_finish         matlab.ui.control.EditField
        edit_fy_start          matlab.ui.control.EditField
        edit_fx_start          matlab.ui.control.EditField
        uipanel3               matlab.ui.container.Panel
        text48                 matlab.ui.control.Label
        text20                 matlab.ui.control.Label
        text19                 matlab.ui.control.Label
        text21                 matlab.ui.control.Label
        edit_eq_depth          matlab.ui.control.EditField
        edit_eq_lat            matlab.ui.control.EditField
        edit_eq_lon            matlab.ui.control.EditField
        edit_eq_rake           matlab.ui.control.EditField
        edit_eq_dip            matlab.ui.control.EditField
        edit_eq_strike         matlab.ui.control.EditField
        edit_eq_mo             matlab.ui.control.EditField
        pushbutton_empirical   matlab.ui.control.Button
        edit_eq_width          matlab.ui.control.EditField
        edit_eq_length         matlab.ui.control.EditField
        uipanel1               matlab.ui.container.Panel
        text14                 matlab.ui.control.Label
        text13                 matlab.ui.control.Label
        text12                 matlab.ui.control.Label
        text11                 matlab.ui.control.Label
        text10                 matlab.ui.control.Label
        text9                  matlab.ui.control.Label
        text8                  matlab.ui.control.Label
        text7                  matlab.ui.control.Label
        text6                  matlab.ui.control.Label
        text5                  matlab.ui.control.Label
        text4                  matlab.ui.control.Label
        text47                 matlab.ui.control.Label
        text46                 matlab.ui.control.Label
        text45                 matlab.ui.control.Label
        text44                 matlab.ui.control.Label
        text43                 matlab.ui.control.Label
        text42                 matlab.ui.control.Label
        text39                 matlab.ui.control.Label
        text38                 matlab.ui.control.Label
        text37                 matlab.ui.control.Label
        text36                 matlab.ui.control.Label
        pushbutton_add         matlab.ui.control.Button
        edit_y_inc             matlab.ui.control.EditField
        edit_x_inc             matlab.ui.control.EditField
        edit_y_finish          matlab.ui.control.EditField
        edit_x_finish          matlab.ui.control.EditField
        edit_y_start           matlab.ui.control.EditField
        edit_x_start           matlab.ui.control.EditField
        edit_inc_lat           matlab.ui.control.EditField
        edit_max_lat           matlab.ui.control.EditField
        edit_min_lat           matlab.ui.control.EditField
        edit_inc_lon           matlab.ui.control.EditField
        edit_max_lon           matlab.ui.control.EditField
        edit_min_lon           matlab.ui.control.EditField
        edit_center_lat        matlab.ui.control.EditField
        edit_center_lon        matlab.ui.control.EditField
        pushbutton_calc        matlab.ui.control.Button
        text2                  matlab.ui.control.Label
        text1                  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function utm_window_OpeningFcn(app, varargin)
            % --- utm_windowが表示される前に実行されます。
            
            % Ensure that the app appears on screen when run
            movegui(app.utm_window, 'onscreen');
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>
            
            % UTMウィンドウが表示される前に実行される初期化関数。
            % この関数は、ウィンドウがスクリーンの中央に配置されるようにします。
            
            global SCR_SIZE % スクリーンサイズと幅を管理するグローバル変数
            
            % ウィンドウの位置とサイズを設定
            h = get(hObject,'Position');
            wind_width = h(3);
            wind_height = h(4);
            dummy = findobj('Tag','main_menu_window2');
            if isempty(dummy)~=1
                h = get(dummy,'Position');
            end
            xpos = h(1,1) + h(1,3) + 5;
            ypos = (SCR_SIZE.SCRS(1,4) - SCR_SIZE.SCRW_Y) - wind_height;
            set(hObject,'Position',[xpos ypos wind_width wind_height]);
            
            % UTMウィンドウのデフォルトのコマンドライン出力を設定
            handles.output = hObject;
            % ハンドル構造を更新
            guidata(hObject, handles);
            
            % セットアップの有効/無効化を設定
            set(findobj('Tag','pushbutton_add'),'Enable','off');
            set(findobj('Tag','edit_eq_lon'),'Enable','off');
            set(findobj('Tag','edit_eq_lat'),'Enable','off');
            set(findobj('Tag','edit_eq_depth'),'Enable','off');
            set(findobj('Tag','edit_eq_length'),'Enable','off');
            set(findobj('Tag','edit_eq_width'),'Enable','off');
            set(findobj('Tag','edit_eq_mo'),'Enable','off');
            set(findobj('Tag','edit_eq_strike'),'Enable','off');
            set(findobj('Tag','edit_eq_dip'),'Enable','off');
            set(findobj('Tag','edit_eq_rake'),'Enable','off');
            set(findobj('Tag','edit_id_number'),'Enable','off');
            set(findobj('Tag','edit_fx_start'),'Enable','off');
            set(findobj('Tag','edit_fx_finish'),'Enable','off');
            set(findobj('Tag','edit_fy_start'),'Enable','off');
            set(findobj('Tag','edit_fy_finish'),'Enable','off');
            set(findobj('Tag','edit_right_lat'),'Enable','off');
            set(findobj('Tag','edit_rev_lat'),'Enable','off');
            set(findobj('Tag','edit_f_top'),'Enable','off');
            set(findobj('Tag','edit_f_bottom'),'Enable','off');
            set(findobj('Tag','pushbutton_empirical'),'Enable','off');
            set(findobj('Tag','pushbutton_f_add'),'Enable','off');
            set(findobj('Tag','pushbutton_f_calc'),'Enable','off');
            set(findobj('Tag','edit_all_input_params'),'Enable','off');
        end

        % Button pushed function: edit_all_input_params
        function edit_all_input_params_Callback(app, event)
            %-------------------------------------------------------------------------
            %     Edit all input parameters：全ての入力パラメータを編集 (static text)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 「Edit all input parameters」テキストフィールドが変更されたときに実行されるコールバック関数です。
            % この関数は、全ての入力パラメータを編集するためのウィンドウを表示します。
            global H_INPUT H_UTM
            H_INPUT = input_window;
            h = findobj('Tag','utm_window');
            if (isempty(h)~=1 & isempty(H_UTM)~=1)
                close(figure(H_UTM))
                H_UTM = [];
            end
        end

        % Value changed function: edit_center_lat
        function edit_center_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     CENTER LATITUDE：中心緯度 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 中心緯度を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数ZERO_LATに設定します。
            global COORD_VARS
            COORD_VARS.ZERO_LAT = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(COORD_VARS.ZERO_LAT,'%8.3f'));
        end

        % Value changed function: edit_center_lon
        function edit_center_lon_Callback(app, event)
            %-------------------------------------------------------------------------
            %     CENTER LONGITUDE：中心経度 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 中心経度を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数ZERO_LONに設定します。
            global COORD_VARS
            COORD_VARS.ZERO_LON = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(COORD_VARS.ZERO_LON,'%8.3f'));
        end

        % Value changed function: edit_eq_depth
        function edit_eq_depth_Callback(app, event)
            %-------------------------------------------------------------------------
            %     地震の深さを設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 地震の深さを設定するためのコールバック関数。
            global EQ_DEPTH
            EQ_DEPTH = str2num(get(hObject,'String'));
            if EQ_DEPTH < 0.0
                h = warndlg('The depth should be positive.');
                EQ_DEPTH = 0.0;
            end
            set(hObject,'String',num2str(EQ_DEPTH,'%6.2f'));
        end

        % Value changed function: edit_eq_dip
        function edit_eq_dip_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層のディップ（傾斜角）を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層のディップ（傾斜角）を設定するためのコールバック関数。
            global EQ_DIP
            x = str2num(get(hObject,'String'));
            if x >= 0 && x <= 90
                EQ_DIP = str2num(get(hObject,'String'));
            else
                h = warndlg('Out of dip range. It should be between 0 and 90.');
                waitfor(h);
            end
            set(hObject,'String',num2str(EQ_DIP,'%6.1f'));
        end

        % Value changed function: edit_eq_lat
        function edit_eq_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     地震位置の緯度を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 地震位置の緯度を設定するためのコールバック関数。
            global EQ_LAT
            EQ_LAT = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(EQ_LAT,'%8.3f'));
        end

        % Value changed function: edit_eq_length
        function edit_eq_length_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層の長さを設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層の長さを設定するためのコールバック関数。
            global EQ_LENGTH
            EQ_LENGTH = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(EQ_LENGTH,'%7.2f'));
        end

        % Value changed function: edit_eq_lon
        function edit_eq_lon_Callback(app, event)
            %-------------------------------------------------------------------------
            %     地震位置の経度を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 地震位置の経度を設定するためのコールバック関数。
            global EQ_LON
            EQ_LON = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(EQ_LON,'%8.3f'));
        end

        % Value changed function: edit_eq_mo
        function edit_eq_mo_Callback(app, event)
            %-------------------------------------------------------------------------
            %     モーメントマグニチュードを設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % モーメントマグニチュードを設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数EQ_MWに設定します。
            global EQ_MW
            EQ_MW = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(EQ_MW,'%3.1f'));
        end

        % Value changed function: edit_eq_rake
        function edit_eq_rake_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層のレイク（すべり角）を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層のレイク（すべり角）を設定するためのコールバック関数。
            global EQ_RAKE
            x = str2num(get(hObject,'String'));
            if x >= -180.0 && x <= 180
                EQ_RAKE = str2num(get(hObject,'String'));
            else
                h = warndlg('Out of rake range. It should be between -180 and 180');
                waitfor(h);
            end
            set(hObject,'String',num2str(EQ_RAKE,'%6.1f'));
        end

        % Value changed function: edit_eq_strike
        function edit_eq_strike_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層の走行（方位角）を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層の走行（方位角）を設定するためのコールバック関数。
            global EQ_STRIKE
            x = str2num(get(hObject,'String'));
            if x >= 0 && x <= 360
                EQ_STRIKE = str2num(get(hObject,'String'));
                if x == 360
                    EQ_STRIKE = 0.0;
                end
            else
                h = warndlg('Out of strike range. It should be between 0 and 360.');
                waitfor(h);
            end
            set(hObject,'String',num2str(EQ_STRIKE,'%6.1f'));
        end

        % Value changed function: edit_eq_width
        function edit_eq_width_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層の幅を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層の幅を設定するためのコールバック関数。
            global EQ_WIDTH
            EQ_WIDTH = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(EQ_WIDTH,'%7.2f'));
        end

        % Value changed function: edit_f_bottom
        function edit_f_bottom_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層の下端の深さを設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層の下端の深さを設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_f_top
        function edit_f_top_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層の上端の深さを設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層の上端の深さを設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INUM,8) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_fx_finish
        function edit_fx_finish_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層終点のX座標を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層終点のX座標を設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_fx_start
        function edit_fx_start_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層始点のX座標を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層始点のX座標を設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_fy_finish
        function edit_fy_finish_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層終点のY座標を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層終点のY座標を設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_fy_start
        function edit_fy_start_Callback(app, event)
            %-------------------------------------------------------------------------
            %     断層始点のY座標 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層始点のY座標を設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_id_number
        function edit_id_number_Callback(app, event)
            %-------------------------------------------------------------------------
            %     ID number (static text)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % ID番号のテキストフィールドが変更されたときに実行されるコールバック関数です。
            % グローバル変数を利用して、断層要素のIDを管理します。
            global INPUT_VARS
            % 入力されたID番号を取得
            x = int8(str2double(get(hObject,'String')));
            % ID番号が連続していない場合に警告を表示
            if x > INPUT_VARS.NUM + 1
                h = warndlg('Fault ID should be sequential.');
                waitfor(h);
                % 現在のID番号にリセット
                set(hObject,'String',num2str(INPUT_VARS.INUM,'%3i'));
                return
            % 新しい断層要素を追加する場合の処理
            elseif x == INPUT_VARS.NUM + 1
                INPUT_VARS.INUM = x;
                INPUT_VARS.KODE(INPUT_VARS.INUM,1) = 100;
                INPUT_VARS.ID(INPUT_VARS.INUM,1) = 1;
                INPUT_VARS.FCOMMENT(INPUT_VARS.INUM,:).ref = ['Fault ' num2str(INPUT_VARS.INUM,'%3i')];
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1) = str2double(get(findobj('Tag','edit_fx_start'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2) = str2double(get(findobj('Tag','edit_fy_start'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3) = str2double(get(findobj('Tag','edit_fx_finish'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4) = str2double(get(findobj('Tag','edit_fy_finish'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5) = str2double(get(findobj('Tag','edit_right_lat'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6) = str2double(get(findobj('Tag','edit_rev_lat'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7) = str2double(get(findobj('Tag','edit_eq_dip'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8) = str2double(get(findobj('Tag','edit_f_top'),'String'));
                INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9) = str2double(get(findobj('Tag','edit_f_bottom'),'String'));
                INPUT_VARS.NUM = INPUT_VARS.INUM;
            % 既存の断層要素を編集する場合の処理
            else
                INPUT_VARS.INUM = x;
                set(findobj('Tag','edit_fx_start'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1),'%8.2f'));
                set(findobj('Tag','edit_fy_start'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2),'%8.2f'));
                set(findobj('Tag','edit_fx_finish'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3),'%8.2f'));
                set(findobj('Tag','edit_fy_finish'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4),'%8.2f'));
                set(findobj('Tag','edit_right_lat'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5),'%8.2f'));
                set(findobj('Tag','edit_rev_lat'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6),'%8.2f'));
                set(findobj('Tag','edit_eq_dip'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7),'%8.2f'));
                set(findobj('Tag','edit_f_top'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8),'%8.2f'));
                set(findobj('Tag','edit_f_bottom'),'String',num2str(INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9),'%8.2f'));
            end
        end

        % Value changed function: edit_inc_lat
        function edit_inc_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     LATITUDE INCREMENT：緯度の増分 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 緯度の増分を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数INC_LATに設定します。
            global INC_LAT
            INC_LAT = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(INC_LAT,'%8.3f'));
        end

        % Value changed function: edit_inc_lon
        function edit_inc_lon_Callback(app, event)
            %-------------------------------------------------------------------------
            %     LONGITUDE INCREMENT：経度の増分 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 経度の増分を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数INC_LONに設定します。
            global INC_LON
            INC_LON = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(INC_LON,'%8.3f'));
        end

        % Value changed function: edit_max_lat
        function edit_max_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     MAXIMUM LATITUDE：最大緯度 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 最大緯度を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数MAX_LATに設定します。
            global COORD_VARS
            COORD_VARS.MAX_LAT = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(COORD_VARS.MAX_LAT,'%8.3f'));
        end

        % Value changed function: edit_max_lon
        function edit_max_lon_Callback(app, event)
            %-------------------------------------------------------------------------
            %     MAXIMUM LONGITUDE：最大経度 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 最大経度を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数MAX_LONに設定します。
            global COORD_VARS
            COORD_VARS.MAX_LON = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(COORD_VARS.MAX_LON,'%8.3f'));
        end

        % Value changed function: edit_min_lat
        function edit_min_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     MINIMUM LATITUDE：最小緯度 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 最小緯度を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数MIN_LATに設定します。
            global COORD_VARS
            COORD_VARS.MIN_LAT = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(COORD_VARS.MIN_LAT,'%8.3f'));
        end

        % Value changed function: edit_min_lon
        function edit_min_lon_Callback(app, event)
            %-------------------------------------------------------------------------
            %     MINIMUM LONGITUDE：最小経度 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 最小経度を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数MIN_LONに設定します。
            global COORD_VARS
            COORD_VARS.MIN_LON = str2num(get(hObject,'String'));
            set(hObject,'String',num2str(COORD_VARS.MIN_LON,'%8.3f'));
        end

        % Value changed function: edit_rev_lat
        function edit_rev_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     Disp slip：逆断層変位成分を設定(テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 逆断層変位成分を設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_right_lat
        function edit_right_lat_Callback(app, event)
            %-------------------------------------------------------------------------
            %     右横ずれ量を設定 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 右横ずれ量を設定するためのコールバック関数。
            global INPUT_VARS
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5) = str2double(get(hObject,'String'));
        end

        % Value changed function: edit_x_finish
        function edit_x_finish_Callback(app, event)
            %-------------------------------------------------------------------------
            %     GRID X FINISH：グリッドのX軸の終了位 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドのX軸の終了位置を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(3,1)に設定します。
            global INPUT_VARS
            INPUT_VARS.GRID(3,1) = str2double(get(hObject,'String'));
            set(hObject,'String',num2str(INPUT_VARS.GRID(3,1),'%8.2f'));
        end

        % Value changed function: edit_x_inc
        function edit_x_inc_Callback(app, event)
            %-------------------------------------------------------------------------
            %     GRID X INCREMENT：X軸の増分 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドのX軸の増分を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(5,1)に設定します。
            global INPUT_VARS
            INPUT_VARS.GRID(5,1) = str2double(get(hObject,'String'));
            set(hObject,'String',num2str(INPUT_VARS.GRID(5,1),'%8.2f'));
        end

        % Value changed function: edit_x_start
        function edit_x_start_Callback(app, event)
            %-------------------------------------------------------------------------
            %     GRID X START：グリッドのX軸の開始位置 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドのX軸の開始位置を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(1,1)に設定します。
            global INPUT_VARS
            INPUT_VARS.GRID(1,1) = str2double(get(hObject,'String'));
            set(hObject,'String',num2str(INPUT_VARS.GRID(1,1),'%8.2f'));
        end

        % Value changed function: edit_y_finish
        function edit_y_finish_Callback(app, event)
            %-------------------------------------------------------------------------
            %     GRID Y FINISH：グリッドY軸の終了位置 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドY軸の終了位置を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(4,1)に設定します。
            global INPUT_VARS
            INPUT_VARS.GRID(4,1) = str2double(get(hObject,'String'));
            set(hObject,'String',num2str(INPUT_VARS.GRID(4,1),'%8.2f'));
        end

        % Value changed function: edit_y_inc
        function edit_y_inc_Callback(app, event)
            %-------------------------------------------------------------------------
            %     INPUT_VARS.GRID Y INCREMENT：Y軸の増分 (textfield)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドのY軸の増分を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数INPUT_VARS.GRID(6,1)に設定します。
            global INPUT_VARS
            INPUT_VARS.GRID(6,1) = str2double(get(hObject,'String'));
            set(hObject,'String',num2str(INPUT_VARS.GRID(6,1),'%8.2f'));
        end

        % Value changed function: edit_y_start
        function edit_y_start_Callback(app, event)
            %-------------------------------------------------------------------------
            %     GRID Y START：グリッドY軸の開始位置 (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % グリッドY軸の開始位置を設定するためのコールバック関数。
            % この関数は、テキストフィールドに入力された値を取得し、グローバル変数GRID(2,1)に設定します。
            global INPUT_VARS
            INPUT_VARS.GRID(2,1) = str2double(get(hObject,'String'));
            set(hObject,'String',num2str(INPUT_VARS.GRID(2,1),'%8.2f'));
        end

        % Button pushed function: pushbutton_add
        function pushbutton_add_Callback(app, event)
            %-------------------------------------------------------------------------
            %     追加ボタン：main_menu_windowへ計算情報の追加
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % メインメニューウィンドウにすべての計算情報を追加するためのボタン。
            % 追加ボタンが押されたときに実行される関数。main_menu_windowへ計算情報を追加する。
            
            global INPUT_VARS
            global COORD_VARS
            global CALC_CONTROL
            
            % グリッド位置を計算し、他のすべての関数で使用できるように保持
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
            COORD_VARS.XGRID = double(xstart) + (double(1:1:(nxinc-1))-1.0) * double(xinc);
            COORD_VARS.YGRID = double(ystart) + (double(1:1:(nyinc-1))-1.0) * double(yinc);
            CALC_CONTROL.FUNC_SWITCH = 1;
            INPUT_VARS.CALC_DEPTH  = 0; % グリッド描画機能のための一時的な値
            
            
            %===== マップ情報が存在する場合の処理
            if isempty(COORD_VARS.MIN_LON) ~= 1 && isempty(COORD_VARS.MAX_LON) ~= 1
                if isempty(COORD_VARS.MIN_LAT) ~= 1 && isempty(COORD_VARS.MAX_LAT) ~= 1
                    if isempty(COORD_VARS.ZERO_LON) ~= 1 && isempty(COORD_VARS.ZERO_LAT) ~= 1
                        xinc = double(COORD_VARS.MAX_LON - COORD_VARS.MIN_LON) / double(nxinc-1);
                        yinc = double(COORD_VARS.MAX_LAT - COORD_VARS.MIN_LAT) / double(nyinc-1);
                        COORD_VARS.LON_GRID = double(COORD_VARS.MIN_LON) + (double(1:1:nxinc)-1.0) * double(xinc);
                        COORD_VARS.LAT_GRID = double(COORD_VARS.MIN_LAT) + (double(1:1:nyinc)-1.0) * double(yinc);
                    end
                end
            end
            %=====
            % グリッド描画
            grid_drawing2;
            CALC_CONTROL.FUNC_SWITCH = 0;
            
            set(findobj('Tag','pushbutton_f_calc'),'Enable','on');
            set(findobj('Tag','menu_gridlines'),'Enable','On');
            set(findobj('Tag','menu_coastlines'),'Enable','On');
            set(findobj('Tag','menu_activefaults'),'Enable','On');
            set(findobj('Tag','menu_earthquakes'),'Enable','On');
        end

        % Button pushed function: pushbutton_calc
        function pushbutton_calc_Callback(app, event)
            %-------------------------------------------------------------------------
            %     CALC. BUTTON (計算ボタン)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 計算ボタンが押されたときに実行される関数。UTM座標に基づいた計算を行う。
            
            global COORD_VARS
            global INC_LON INC_LAT
            global XS YS XF YF
            global PC_LON PC_LAT
            global CALC_CONTROL
            global INPUT_VARS
            global UTM_FLAG  % UTM_FLAGが0の場合は座標の確認のみ、1の場合は入力ファイルを作成
            
            % 警告ダイアログ：座標の大小関係を確認し、問題がある場合は警告を表示
            if COORD_VARS.MIN_LAT >= COORD_VARS.MAX_LAT
                errordlg('max lat should be larger than min lat','Alignment Error!');
            end
            if COORD_VARS.MIN_LON >= COORD_VARS.MAX_LON
                errordlg('max lon should be larger than min lon','Alignment Error!');
            end
            if COORD_VARS.ZERO_LON > COORD_VARS.MAX_LON || COORD_VARS.ZERO_LON < COORD_VARS.MIN_LON
                errordlg('ref lon should be in the study area','Alignment Error!');
            end
            if COORD_VARS.ZERO_LAT > COORD_VARS.MAX_LAT || COORD_VARS.ZERO_LAT < COORD_VARS.MIN_LAT
                errordlg('ref lat should be in the study area','Alignment Error!');
            end
            
            % グリッドの設定
            ndlon = int16((COORD_VARS.MAX_LON - COORD_VARS.MIN_LON) / INC_LON);
            ndlat = int16((COORD_VARS.MAX_LAT - COORD_VARS.MIN_LAT) / INC_LAT);
            modlon = mod((COORD_VARS.MAX_LON - COORD_VARS.MIN_LON),INC_LON);
            modlat = mod((COORD_VARS.MAX_LAT - COORD_VARS.MIN_LAT),INC_LAT);
            if ndlon <= 5 | ndlat <= 5
                 warndlg('grid interval is so wide','Warning!');
            end
            
            pcent_lon = (COORD_VARS.MAX_LON + COORD_VARS.MIN_LON)/2.0;
            pcent_lat = (COORD_VARS.MAX_LAT + COORD_VARS.MIN_LAT)/2.0;
            % 総距離の計算（X軸およびY軸）
            if CALC_CONTROL.MAPTLFLAG == 1
                xdeg  = distance(pcent_lat,COORD_VARS.MIN_LON,pcent_lat,COORD_VARS.MAX_LON);
                ydeg  = distance(COORD_VARS.MIN_LAT,pcent_lon,COORD_VARS.MAX_LAT,pcent_lon);
                xdist = deg2km(xdeg);
                ydist = deg2km(ydeg);
                xmin  = deg2km(distance(pcent_lat,COORD_VARS.MIN_LON,pcent_lat,COORD_VARS.ZERO_LON));
                ymin  = deg2km(distance(COORD_VARS.MIN_LAT,pcent_lon,COORD_VARS.ZERO_LAT,pcent_lon));
                xmax  = deg2km(distance(pcent_lat,COORD_VARS.MAX_LON,pcent_lat,COORD_VARS.ZERO_LON));
                ymax  = deg2km(distance(COORD_VARS.MAX_LAT,pcent_lon,COORD_VARS.ZERO_LAT,pcent_lon));
            else
            	[xdist,flag1] = distance2(pcent_lat,COORD_VARS.MIN_LON,pcent_lat,COORD_VARS.MAX_LON);
            	[ydist,flag2] = distance2(COORD_VARS.MIN_LAT,pcent_lon,COORD_VARS.MAX_LAT,pcent_lon);
                [xmin, flag3] = distance2(pcent_lat,COORD_VARS.MIN_LON,pcent_lat,COORD_VARS.ZERO_LON);
                [ymin, flag4] = distance2(COORD_VARS.MIN_LAT,pcent_lon,COORD_VARS.ZERO_LAT,pcent_lon);
                [xmax, flag5] = distance2(pcent_lat,COORD_VARS.MAX_LON,pcent_lat,COORD_VARS.ZERO_LON);
                [ymax, flag6] = distance2(COORD_VARS.MAX_LAT,pcent_lon,COORD_VARS.ZERO_LAT,pcent_lon);
                dummy = flag1+flag2+flag3+flag4+flag5+flag6;
                if dummy >= 1
                    msgbox('The points are over two UTM zones. It will be switched to simple great circle calc.','Notice','warn');
                    xdist = greatCircleDistance(deg2rad(pcent_lat),deg2rad(COORD_VARS.MIN_LON),deg2rad(pcent_lat),deg2rad(COORD_VARS.MAX_LON));
                    ydist = greatCircleDistance(deg2rad(COORD_VARS.MIN_LAT),deg2rad(pcent_lon),deg2rad(COORD_VARS.MAX_LAT),deg2rad(pcent_lon));
                    xmin  = greatCircleDistance(deg2rad(pcent_lat),deg2rad(COORD_VARS.MIN_LON),deg2rad(pcent_lat),deg2rad(COORD_VARS.ZERO_LON));
                    ymin  = greatCircleDistance(deg2rad(COORD_VARS.MIN_LAT),deg2rad(pcent_lon),deg2rad(COORD_VARS.ZERO_LAT),deg2rad(pcent_lon));
                    xmax  = greatCircleDistance(deg2rad(pcent_lat),deg2rad(COORD_VARS.MAX_LON),deg2rad(pcent_lat),deg2rad(COORD_VARS.ZERO_LON));
                    ymax  = greatCircleDistance(deg2rad(COORD_VARS.MAX_LAT),deg2rad(pcent_lon),deg2rad(COORD_VARS.ZERO_LAT),deg2rad(pcent_lon));
                end
            end
            
            if COORD_VARS.ZERO_LON > COORD_VARS.MIN_LON
                xmin = -xmin;
            end
            if COORD_VARS.ZERO_LAT > COORD_VARS.MIN_LAT
                ymin = -ymin;
            end
            if COORD_VARS.ZERO_LON > COORD_VARS.MAX_LON
                xmax = -xmax;
            end
            if COORD_VARS.ZERO_LAT > COORD_VARS.MAX_LAT
                ymax = -ymax;
            end
            
            set(findobj('Tag','edit_x_start'),'String',num2str(xmin,'%8.2f'));
            set(findobj('Tag','edit_y_start'),'String',num2str(ymin,'%8.2f'));
            set(findobj('Tag','edit_x_finish'),'String',num2str(xmax,'%8.2f'));
            set(findobj('Tag','edit_y_finish'),'String',num2str(ymax,'%8.2f'));
            
            % グリッドの設定
            XS = xmin; INPUT_VARS.GRID(1,1) = xmin;
            XF = xmax; INPUT_VARS.GRID(3,1) = xmax;
            YS = ymin; INPUT_VARS.GRID(2,1) = ymin;
            YF = ymax; INPUT_VARS.GRID(4,1) = ymax;
            INPUT_VARS.GRID(5,1) = (xmax - xmin) / double(ndlon);
            INPUT_VARS.GRID(6,1) = (ymax - ymin) / double(ndlat);
            set(findobj('Tag','edit_x_inc'),'String',num2str(INPUT_VARS.GRID(5,1),'%8.2f'));
            set(findobj('Tag','edit_y_inc'),'String',num2str(INPUT_VARS.GRID(6,1),'%8.2f'));
            PC_LON = pcent_lon;
            PC_LAT = pcent_lat;
            
            set(findobj('Tag','pushbutton_add'),'Enable','on');
            set(findobj('Tag','edit_eq_lon'),'Enable','on');
            set(findobj('Tag','edit_eq_lat'),'Enable','on');
            set(findobj('Tag','edit_eq_depth'),'Enable','on');
            set(findobj('Tag','edit_eq_length'),'Enable','on');
            set(findobj('Tag','edit_eq_width'),'Enable','on');
            set(findobj('Tag','edit_eq_mo'),'Enable','on');
            set(findobj('Tag','edit_eq_strike'),'Enable','on');
            set(findobj('Tag','edit_eq_dip'),'Enable','on');
            set(findobj('Tag','edit_eq_rake'),'Enable','on');
            set(findobj('Tag','edit_id_number'),'Enable','on');
            set(findobj('Tag','edit_fx_start'),'Enable','on');
            set(findobj('Tag','edit_fx_finish'),'Enable','on');
            set(findobj('Tag','edit_fy_start'),'Enable','on');
            set(findobj('Tag','edit_fy_finish'),'Enable','on');
            set(findobj('Tag','edit_right_lat'),'Enable','on');
            set(findobj('Tag','edit_rev_lat'),'Enable','on');
            set(findobj('Tag','edit_f_top'),'Enable','on');
            set(findobj('Tag','edit_f_bottom'),'Enable','on');
            set(findobj('Tag','pushbutton_empirical'),'Enable','on');
            set(findobj('Tag','pushbutton_f_add'),'Enable','off');
            
            % 座標の確認ツールとして使用する場合
            if UTM_FLAG == 0
                set(findobj('Tag','pushbutton_f_calc'),'Enable','on');
            else
                set(findobj('Tag','pushbutton_f_calc'),'Enable','off');
            end
            set(findobj('Tag','edit_all_input_params'),'Enable','off');
        end

        % Button pushed function: pushbutton_empirical
        function pushbutton_empirical_Callback(app, event)
            %-------------------------------------------------------------------------
            %     wells & coppersmithの経験式に基づく計算 (ボタン)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % wells & coppersmithの経験式に基づく計算を行うボタンのコールバック関数。
            global H_WC
            H_WC = wells_coppersmith_window;
        end

        % Button pushed function: pushbutton_f_add
        function pushbutton_f_add_Callback(app, event)
            %-------------------------------------------------------------------------
            %     ADD FAULT：断層の追加 (プッシュボタン)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 「Add Fault」ボタンが押されたときに実行されるコールバック関数です。
            % グローバル変数を利用して断層に関するデフォルト値を設定し、断層の計算や表示を行います。
            
            global INPUT_VARS
            global EQ_LAT EQ_LON
            global COORD_VARS
            
            % 断層の深さ、ポアソン比、ヤング率のデフォルト値を設定
            INPUT_VARS.CALC_DEPTH = (INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8)+INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9)) / 2.0;
            INPUT_VARS.POIS = 0.25;
            INPUT_VARS.YOUNG = 800000;
            
            % その他のデフォルト値を設定
            INPUT_VARS.FRIC = 0.4;
            INPUT_VARS.SIZE = [2;1;10000]; % サイズに関する設定
            x1 = 'header line 1';
            x2 = 'header line 2';
            INPUT_VARS.HEAD{1} = x1;  % ヘッダー行1
            INPUT_VARS.HEAD{2} = x2;  % ヘッダー行2
            
            % 応力テンソルに関する設定
            INPUT_VARS.R_STRESS = [19.00 -0.01 100.0 0.0;
                        89.99 89.99  30.0 0.0;
                       109.00 -0.01   0.0 0.0];
            
            % セクションに関する設定
            INPUT_VARS.SECTION = [-16; -16; 18; 26; 1; 30; 1];
            
            % fault_overlay関数を呼び出して断層を表示
            fault_overlay;
            
            % EQ_LAT、EQ_LONを使用して座標変換を行い、UTM座標系でプロット
            a = lonlat2xy([EQ_LON EQ_LAT]);
            hold on;
            % 緯度経度でプロット
            if COORD_VARS.ICOORD == 2 && isempty(COORD_VARS.LON_GRID) ~= 1
                h = scatter(EQ_LON,EQ_LAT,'filled','bo');
            % UTM座標系でプロット
            else
                h = scatter(a(1),a(2),'filled','bo');
            end
            
            % メニューやボタンを有効化
            set(findobj('Tag','menu_grid'),'Enable','On');
            set(findobj('Tag','menu_displacement'),'Enable','On');
            set(findobj('Tag','menu_strain'),'Enable','On');
            set(findobj('Tag','menu_stress'),'Enable','On');
            set(findobj('Tag','menu_change_parameters'),'Enable','On');
            set(findobj('Tag','edit_all_input_params'),'Enable','on');
            set(findobj('Tag','menu_file_save'),'Enable','On');
            set(findobj('Tag','menu_file_save_ascii'),'Enable','On');
            set(findobj('Tag','menu_map_info'),'Enable','On');
            
            % INUM = INUM + 1：次の断層IDを設定
            set(findobj('Tag','edit_id_number'),'String',num2str(INPUT_VARS.INUM,'%2i'));
        end

        % Button pushed function: pushbutton_f_calc
        function pushbutton_f_calc_Callback(app, event)
            %-------------------------------------------------------------------------
            %     CALCULATION FOR FAULT：断層に関する計算を行うボタン (テキストフィールド)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 断層に関する計算を行うボタンのコールバック関数。
            % ユーザーがGUIで入力した地震断層のパラメータを使用して、断層の位置や変位量を計算します。
            
            global COORD_VARS
            global EQ_LON EQ_LAT EQ_DEPTH
            global PC_LON PC_LAT
            global EQ_LENGTH EQ_WIDTH EQ_STRIKE EQ_DIP EQ_RAKE EQ_MW
            global INPUT_VARS
            global CALC_CONTROL
            
            % 保険：断層の長さ、幅、モーメントマグニチュードをGUIから取得
            EQ_LENGTH = str2double(get(findobj('Tag','edit_eq_length'),'String'));
            EQ_WIDTH  = str2double(get(findobj('Tag','edit_eq_width'),'String'));
            EQ_MW     = str2double(get(findobj('Tag','edit_eq_mo'),'String'));
            
            % 断層のID番号を更新
            set(findobj('Tag','edit_id_number'),'String',num2str(INUM,'%2i'));
            % 断層の総数
            INPUT_VARS.NUM = INPUT_VARS.INUM;
            % Kode：計算のタイプを指定するコード，通常の計算では100
            INPUT_VARS.KODE(INPUT_VARS.INUM,1) = 100;
            INPUT_VARS.ID(INPUT_VARS.INUM,1) = 1;
            INPUT_VARS.FCOMMENT(INPUT_VARS.INUM,:).ref = ['Fault ' num2str(INPUT_VARS.INUM,'%3i')];
            
            % 断層の位置参照方法を取得（中央または端部）
            % fref = 0：中心の位置参照、fref = 1：端部の位置参照
            fref = get(handles.radiobutton_edgepos,'Value');
            
            % Each fault element
            %       ELEMENT(:,1) 断層始点のX座標値 (km)
            %       ELEMENT(:,2) 断層始点のY座標値 (km)
            %       ELEMENT(:,3) 断層終点のX座標値 (km)
            %       ELEMENT(:,4) 断層終点のY座標値 (km)
            %       ELEMENT(:,5) 右横ずれ成分（rt.lat, m）左横ずれはマイナス
            %       ELEMENT(:,6) 逆断層変位成分（reverse, m）正断層はマイナス
            %       ELEMENT(:,7) dip 断層の傾斜（0°-90°）
            %       ELEMENT(:,8) 断層の上端の深さ（km）
            %       ELEMENT(:,9) 断層の下端の深さ（km）
            %  !!! NEED readjustment for dipping fault !!!!!!!!!!!!!!!!!!
            
            % 地震の震源位置に基づいて断層の始点と終点のX, Y座標を計算
            if CALC_CONTROL.MAPTLFLAG == 1
                xdist = deg2km(distance(PC_LAT,EQ_LON,PC_LAT,COORD_VARS.ZERO_LON));
            else
                [xdist,flag] = distance2(PC_LAT,EQ_LON,PC_LAT,COORD_VARS.ZERO_LON);
                if flag == 1
                    xdist  = greatCircleDistance(deg2rad(PC_LAT),deg2rad(EQ_LON),deg2rad(PC_LAT),deg2rad(COORD_VARS.ZERO_LON));
                end
            end
            if EQ_LON < ZERO_LON
                xdist = -xdist;
            end
            if CALC_CONTROL.MAPTLFLAG == 1
                ydist = deg2km(distance(EQ_LAT,PC_LON,COORD_VARS.ZERO_LAT,PC_LON));
            else
                [ydist,flag] = distance2(EQ_LAT,PC_LON,COORD_VARS.ZERO_LAT,PC_LON);
                if flag == 1
                    ydist  = greatCircleDistance(deg2rad(EQ_LAT),deg2rad(PC_LON),deg2rad(COORD_VARS.ZERO_LAT),deg2rad(PC_LON));
                end
            end
            if EQ_LAT < ZERO_LAT
                ydist = -ydist;
            end
            
            % 断層の終点を計算（端部または中央参照）
            if fref == 1 % 端部位置参照
                xfn = xdist + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
                yfn = ydist + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH;
            else         % 中央位置参照
                xtemp = xdist;
                ytemp = ydist;
                xdist = xtemp - sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
                ydist = ytemp - cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
                xfn   = xtemp + sin(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
                yfn   = ytemp + cos(deg2rad(EQ_STRIKE)) * EQ_LENGTH / 2.0;
            
               % 断層の傾斜角度（dip-slip direction）に基づいて、始点と終点の調整を行う
                dd = (EQ_WIDTH / 2.) * cos(deg2rad(EQ_DIP));
                theta = atan(abs(yfn-ydist)/abs(xfn-xdist));
                zx = dd * sin(theta);   % x軸方向の調整量（単位距離）
                zy = dd * cos(theta);   % y軸方向の調整量（単位距離）
                if xfn >= xdist
                    if yfn >= ydist
                        zx = -zx;
                    end
                else
                    if yfn >= ydist
                        zx = -zx;
                        zy = -zy;
                    else
                        zy = -zy;
                    end
                end
                xdist = xdist + zx;
                ydist = ydist + zy;
                xfn   = xfn + zx;
                yfn   = yfn + zy;
            end
            
            % 断層の始点と終点をGUIに表示し、変数に保存
            set(findobj('Tag','edit_fx_start'),'String',num2str(xdist,'%8.2f'));
            set(findobj('Tag','edit_fy_start'),'String',num2str(ydist,'%8.2f'));
            set(findobj('Tag','edit_fx_finish'),'String',num2str(xfn,'%8.2f'));
            set(findobj('Tag','edit_fy_finish'),'String',num2str(yfn,'%8.2f'));
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,1) = xdist;
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,2) = ydist;
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,3) = xfn;
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,4) = yfn;
            
            % モーメントマグニチュードから断層の変位を計算し、表示。
            % 剪断モジュール
            shr = 3.4e+11;
            % 地震モーメント
            mo = power(10,(1.5 * EQ_MW + 9.1))*1.0e+7;
            slip = mo/(shr * EQ_LENGTH * EQ_WIDTH * 1.0e+10);
            rlslip = ((-1.0) * cos(deg2rad(EQ_RAKE)) * slip)/100;
            rvslip = (sin(deg2rad(EQ_RAKE)) * slip)/100;
            set(findobj('Tag','edit_right_lat'),'String',num2str(rlslip,'%8.2f'));
            set(findobj('Tag','edit_rev_lat'),'String',num2str(rvslip,'%8.2f'));
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,5) = rlslip;
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,6) = rvslip;
            
            % 断層の深さを計算
            hd = (EQ_WIDTH/2.0) * sin(deg2rad(EQ_DIP));
            if fref == 1 % 端部位置参照
                bt = EQ_DEPTH + 2.0 * hd;
            else         % 中央位置参照
                tp = EQ_DEPTH - hd;
                bt = EQ_DEPTH + hd;
                if tp < 0.0
                    h = warndlg('Fault top depth above the surface (negative). Change the source depth or fault width.');
                    waitfor(h);
                end
            end
            set(findobj('Tag','edit_f_top'),'String',num2str(tp,'%8.2f'));
            set(findobj('Tag','edit_f_bottom'),'String',num2str(bt,'%8.2f'));
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,7) = EQ_DIP;
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,8) = tp;
            INPUT_VARS.ELEMENT(INPUT_VARS.INUM,9) = bt;
            
            % 計算結果を他のボタンやGUIコンポーネントで利用可能にする
            set(findobj('Tag','pushbutton_f_add'),'Enable','on');
        end

        % Button pushed function: pushbutton_utm_cancel
        function pushbutton_utm_cancel_Callback(app, event)
            %-------------------------------------------------------------------------
            %     CANCEL：キャンセル (プッシュボタン)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 「Cancel」ボタンが押されたときに実行されるコールバック関数です。
            % この関数は、UTM座標系のウィンドウを閉じ、メインウィンドウをアクティブにします。
            % ウィンドウを閉じる
            delete(figure(gcf));
        end

        % Button pushed function: pushbutton_utm_ok
        function pushbutton_utm_ok_Callback(app, event)
            %-------------------------------------------------------------------------
            %     OK (プッシュボタン)
            %-------------------------------------------------------------------------
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % 「OK」ボタンが押されたときに実行されるコールバック関数です。
            % 要素の計算を行い、ウィンドウを閉じます。
            % グリッドやデータなどの要素の計算
            calc_element;
            % ウィンドウを閉じる
            delete(figure(gcf));
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create utm_window and hide until all components are created
            app.utm_window = uifigure('Visible', 'off');
            colormap(app.utm_window, 'parula');
            app.utm_window.Position = [520 9 458 730];
            app.utm_window.Name = 'Build input from CMT or focal mech. data';
            app.utm_window.Resize = 'off';
            app.utm_window.HandleVisibility = 'callback';
            app.utm_window.Tag = 'utm_window';

            % Create uipanel1
            app.uipanel1 = uipanel(app.utm_window);
            app.uipanel1.Title = '  Study area  ';
            app.uipanel1.Tag = 'uipanel1';
            app.uipanel1.FontSize = 16;
            app.uipanel1.Position = [23 411 417 289];

            % Create text1
            app.text1 = uilabel(app.uipanel1);
            app.text1.Tag = 'text1';
            app.text1.HorizontalAlignment = 'center';
            app.text1.VerticalAlignment = 'top';
            app.text1.WordWrap = 'on';
            app.text1.FontSize = 12;
            app.text1.Position = [206 227 49.9757869249395 23.7547445255474];
            app.text1.Text = 'lon.(°E)';

            % Create text2
            app.text2 = uilabel(app.uipanel1);
            app.text2.Tag = 'text2';
            app.text2.HorizontalAlignment = 'center';
            app.text2.VerticalAlignment = 'top';
            app.text2.WordWrap = 'on';
            app.text2.FontSize = 12;
            app.text2.Position = [275 227 49.9757869249395 23.7547445255474];
            app.text2.Text = 'lat.(°N)';

            % Create pushbutton_calc
            app.pushbutton_calc = uibutton(app.uipanel1, 'push');
            app.pushbutton_calc.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_calc_Callback, true);
            app.pushbutton_calc.Tag = 'pushbutton_calc';
            app.pushbutton_calc.BackgroundColor = [0.702 0.702 0.702];
            app.pushbutton_calc.FontSize = 12;
            app.pushbutton_calc.FontWeight = 'bold';
            app.pushbutton_calc.Position = [313 137 84.9588377723971 29.6934306569343];
            app.pushbutton_calc.Text = '1) Calc.';

            % Create edit_center_lon
            app.edit_center_lon = uieditfield(app.uipanel1, 'text');
            app.edit_center_lon.ValueChangedFcn = createCallbackFcn(app, @edit_center_lon_Callback, true);
            app.edit_center_lon.Tag = 'edit_center_lon';
            app.edit_center_lon.HorizontalAlignment = 'center';
            app.edit_center_lon.FontSize = 12;
            app.edit_center_lon.Position = [204 205 53.9738498789346 23.7547445255474];
            app.edit_center_lon.Value = '130.200';

            % Create edit_center_lat
            app.edit_center_lat = uieditfield(app.uipanel1, 'text');
            app.edit_center_lat.ValueChangedFcn = createCallbackFcn(app, @edit_center_lat_Callback, true);
            app.edit_center_lat.Tag = 'edit_center_lat';
            app.edit_center_lat.HorizontalAlignment = 'center';
            app.edit_center_lat.FontSize = 12;
            app.edit_center_lat.Position = [273 205 53.9738498789346 23.7547445255474];
            app.edit_center_lat.Value = '33.800';

            % Create edit_min_lon
            app.edit_min_lon = uieditfield(app.uipanel1, 'text');
            app.edit_min_lon.ValueChangedFcn = createCallbackFcn(app, @edit_min_lon_Callback, true);
            app.edit_min_lon.Tag = 'edit_min_lon';
            app.edit_min_lon.HorizontalAlignment = 'center';
            app.edit_min_lon.FontSize = 12;
            app.edit_min_lon.Position = [98 148 53.9738498789346 23.7547445255474];
            app.edit_min_lon.Value = '129.500';

            % Create edit_max_lon
            app.edit_max_lon = uieditfield(app.uipanel1, 'text');
            app.edit_max_lon.ValueChangedFcn = createCallbackFcn(app, @edit_max_lon_Callback, true);
            app.edit_max_lon.Tag = 'edit_max_lon';
            app.edit_max_lon.HorizontalAlignment = 'center';
            app.edit_max_lon.FontSize = 12;
            app.edit_max_lon.Position = [162 148 53.9738498789346 23.7547445255474];
            app.edit_max_lon.Value = '131.000';

            % Create edit_inc_lon
            app.edit_inc_lon = uieditfield(app.uipanel1, 'text');
            app.edit_inc_lon.ValueChangedFcn = createCallbackFcn(app, @edit_inc_lon_Callback, true);
            app.edit_inc_lon.Tag = 'edit_inc_lon';
            app.edit_inc_lon.HorizontalAlignment = 'center';
            app.edit_inc_lon.FontSize = 12;
            app.edit_inc_lon.Position = [224 148 53.9738498789346 23.7547445255474];
            app.edit_inc_lon.Value = '0.050';

            % Create edit_min_lat
            app.edit_min_lat = uieditfield(app.uipanel1, 'text');
            app.edit_min_lat.ValueChangedFcn = createCallbackFcn(app, @edit_min_lat_Callback, true);
            app.edit_min_lat.Tag = 'edit_min_lat';
            app.edit_min_lat.HorizontalAlignment = 'center';
            app.edit_min_lat.FontSize = 12;
            app.edit_min_lat.Position = [98 89 53.9738498789346 23.7547445255474];
            app.edit_min_lat.Value = '33.000';

            % Create edit_max_lat
            app.edit_max_lat = uieditfield(app.uipanel1, 'text');
            app.edit_max_lat.ValueChangedFcn = createCallbackFcn(app, @edit_max_lat_Callback, true);
            app.edit_max_lat.Tag = 'edit_max_lat';
            app.edit_max_lat.HorizontalAlignment = 'center';
            app.edit_max_lat.FontSize = 12;
            app.edit_max_lat.Position = [162 89 53.9738498789346 23.7547445255474];
            app.edit_max_lat.Value = '34.500';

            % Create edit_inc_lat
            app.edit_inc_lat = uieditfield(app.uipanel1, 'text');
            app.edit_inc_lat.ValueChangedFcn = createCallbackFcn(app, @edit_inc_lat_Callback, true);
            app.edit_inc_lat.Tag = 'edit_inc_lat';
            app.edit_inc_lat.HorizontalAlignment = 'center';
            app.edit_inc_lat.FontSize = 12;
            app.edit_inc_lat.Position = [224 90 53.9738498789346 23.7547445255474];
            app.edit_inc_lat.Value = '0.050';

            % Create edit_x_start
            app.edit_x_start = uieditfield(app.uipanel1, 'text');
            app.edit_x_start.ValueChangedFcn = createCallbackFcn(app, @edit_x_start_Callback, true);
            app.edit_x_start.Tag = 'edit_x_start';
            app.edit_x_start.HorizontalAlignment = 'center';
            app.edit_x_start.FontSize = 12;
            app.edit_x_start.BackgroundColor = [1 0.9 0.5];
            app.edit_x_start.Position = [18 27 53.9738498789346 23.7547445255474];

            % Create edit_y_start
            app.edit_y_start = uieditfield(app.uipanel1, 'text');
            app.edit_y_start.ValueChangedFcn = createCallbackFcn(app, @edit_y_start_Callback, true);
            app.edit_y_start.Tag = 'edit_y_start';
            app.edit_y_start.HorizontalAlignment = 'center';
            app.edit_y_start.FontSize = 12;
            app.edit_y_start.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_y_start.Position = [82 27 53.9738498789346 23.7547445255474];

            % Create edit_x_finish
            app.edit_x_finish = uieditfield(app.uipanel1, 'text');
            app.edit_x_finish.ValueChangedFcn = createCallbackFcn(app, @edit_x_finish_Callback, true);
            app.edit_x_finish.Tag = 'edit_x_finish';
            app.edit_x_finish.HorizontalAlignment = 'center';
            app.edit_x_finish.FontSize = 12;
            app.edit_x_finish.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_x_finish.Position = [146 27 53.9738498789346 23.7547445255474];

            % Create edit_y_finish
            app.edit_y_finish = uieditfield(app.uipanel1, 'text');
            app.edit_y_finish.ValueChangedFcn = createCallbackFcn(app, @edit_y_finish_Callback, true);
            app.edit_y_finish.Tag = 'edit_y_finish';
            app.edit_y_finish.HorizontalAlignment = 'center';
            app.edit_y_finish.FontSize = 12;
            app.edit_y_finish.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_y_finish.Position = [213 27 53.9738498789346 23.7547445255474];

            % Create edit_x_inc
            app.edit_x_inc = uieditfield(app.uipanel1, 'text');
            app.edit_x_inc.ValueChangedFcn = createCallbackFcn(app, @edit_x_inc_Callback, true);
            app.edit_x_inc.Tag = 'edit_x_inc';
            app.edit_x_inc.HorizontalAlignment = 'center';
            app.edit_x_inc.FontSize = 12;
            app.edit_x_inc.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_x_inc.Position = [279 27 53.9738498789346 23.7547445255474];

            % Create edit_y_inc
            app.edit_y_inc = uieditfield(app.uipanel1, 'text');
            app.edit_y_inc.ValueChangedFcn = createCallbackFcn(app, @edit_y_inc_Callback, true);
            app.edit_y_inc.Tag = 'edit_y_inc';
            app.edit_y_inc.HorizontalAlignment = 'center';
            app.edit_y_inc.FontSize = 12;
            app.edit_y_inc.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_y_inc.Position = [344 27 53.9738498789346 23.7547445255474];

            % Create pushbutton_add
            app.pushbutton_add = uibutton(app.uipanel1, 'push');
            app.pushbutton_add.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_add_Callback, true);
            app.pushbutton_add.Tag = 'pushbutton_add';
            app.pushbutton_add.BackgroundColor = [0.702 0.702 0.702];
            app.pushbutton_add.FontSize = 10.6666666666667;
            app.pushbutton_add.FontWeight = 'bold';
            app.pushbutton_add.Enable = 'off';
            app.pushbutton_add.Position = [313 90 84.9588377723971 29.6934306569343];
            app.pushbutton_add.Text = '2) Add to map';

            % Create text36
            app.text36 = uilabel(app.uipanel1);
            app.text36.Tag = 'text36';
            app.text36.HorizontalAlignment = 'center';
            app.text36.VerticalAlignment = 'top';
            app.text36.WordWrap = 'on';
            app.text36.FontSize = 12;
            app.text36.Position = [226 173 49.9757869249395 23.7547445255474];
            app.text36.Text = 'incr.(°)';

            % Create text37
            app.text37 = uilabel(app.uipanel1);
            app.text37.Tag = 'text37';
            app.text37.HorizontalAlignment = 'center';
            app.text37.VerticalAlignment = 'top';
            app.text37.WordWrap = 'on';
            app.text37.FontSize = 12;
            app.text37.Position = [226 115 50 21];
            app.text37.Text = 'incr.(°)';

            % Create text38
            app.text38 = uilabel(app.uipanel1);
            app.text38.Tag = 'text38';
            app.text38.HorizontalAlignment = 'center';
            app.text38.VerticalAlignment = 'top';
            app.text38.WordWrap = 'on';
            app.text38.FontSize = 12;
            app.text38.Position = [280 52 49.9757869249395 23.7547445255475];
            app.text38.Text = 'x incr.';

            % Create text39
            app.text39 = uilabel(app.uipanel1);
            app.text39.Tag = 'text39';
            app.text39.HorizontalAlignment = 'center';
            app.text39.VerticalAlignment = 'top';
            app.text39.WordWrap = 'on';
            app.text39.FontSize = 12;
            app.text39.Position = [347 52 49.9757869249395 23.7547445255475];
            app.text39.Text = 'y incr.';

            % Create text42
            app.text42 = uilabel(app.uipanel1);
            app.text42.Tag = 'text42';
            app.text42.HorizontalAlignment = 'center';
            app.text42.VerticalAlignment = 'top';
            app.text42.WordWrap = 'on';
            app.text42.FontSize = 12;
            app.text42.Position = [25 6 44.9782082324455 18.8058394160584];
            app.text42.Text = '(km)';

            % Create text43
            app.text43 = uilabel(app.uipanel1);
            app.text43.Tag = 'text43';
            app.text43.HorizontalAlignment = 'center';
            app.text43.VerticalAlignment = 'top';
            app.text43.WordWrap = 'on';
            app.text43.FontSize = 12;
            app.text43.Position = [92 6 44.9782082324455 18.8058394160584];
            app.text43.Text = '(km)';

            % Create text44
            app.text44 = uilabel(app.uipanel1);
            app.text44.Tag = 'text44';
            app.text44.HorizontalAlignment = 'center';
            app.text44.VerticalAlignment = 'top';
            app.text44.WordWrap = 'on';
            app.text44.FontSize = 12;
            app.text44.Position = [152 6 44.9782082324455 18.8058394160584];
            app.text44.Text = '(km)';

            % Create text45
            app.text45 = uilabel(app.uipanel1);
            app.text45.Tag = 'text45';
            app.text45.HorizontalAlignment = 'center';
            app.text45.VerticalAlignment = 'top';
            app.text45.WordWrap = 'on';
            app.text45.FontSize = 12;
            app.text45.Position = [219 6 44.9782082324456 18.8058394160584];
            app.text45.Text = '(km)';

            % Create text46
            app.text46 = uilabel(app.uipanel1);
            app.text46.Tag = 'text46';
            app.text46.HorizontalAlignment = 'center';
            app.text46.VerticalAlignment = 'top';
            app.text46.WordWrap = 'on';
            app.text46.FontSize = 12;
            app.text46.Position = [283 6 44.9782082324455 18.8058394160584];
            app.text46.Text = '(km)';

            % Create text47
            app.text47 = uilabel(app.uipanel1);
            app.text47.Tag = 'text47';
            app.text47.HorizontalAlignment = 'center';
            app.text47.VerticalAlignment = 'top';
            app.text47.WordWrap = 'on';
            app.text47.FontSize = 12;
            app.text47.Position = [350 6 44.9782082324455 18.8058394160584];
            app.text47.Text = '(km)';

            % Create text4
            app.text4 = uilabel(app.uipanel1);
            app.text4.Tag = 'text4';
            app.text4.HorizontalAlignment = 'center';
            app.text4.VerticalAlignment = 'top';
            app.text4.WordWrap = 'on';
            app.text4.FontSize = 12;
            app.text4.Position = [28 210 149.927360774818 27.12];
            app.text4.Text = 'Reference point (x,y) = (0,0)';

            % Create text5
            app.text5 = uilabel(app.uipanel1);
            app.text5.Tag = 'text5';
            app.text5.VerticalAlignment = 'top';
            app.text5.WordWrap = 'on';
            app.text5.FontSize = 12;
            app.text5.Position = [27 150 71.9651331719128 22.7649635036496];
            app.text5.Text = 'Lon.(°E)';

            % Create text6
            app.text6 = uilabel(app.uipanel1);
            app.text6.Tag = 'text6';
            app.text6.VerticalAlignment = 'top';
            app.text6.WordWrap = 'on';
            app.text6.FontSize = 12;
            app.text6.Position = [27 90 49.9757869249395 23.7547445255474];
            app.text6.Text = 'Lat.(°N)';

            % Create text7
            app.text7 = uilabel(app.uipanel1);
            app.text7.Tag = 'text7';
            app.text7.HorizontalAlignment = 'center';
            app.text7.VerticalAlignment = 'top';
            app.text7.WordWrap = 'on';
            app.text7.FontSize = 12;
            app.text7.Position = [100 173 49.9757869249395 23.7547445255474];
            app.text7.Text = 'min(°)';

            % Create text8
            app.text8 = uilabel(app.uipanel1);
            app.text8.Tag = 'text8';
            app.text8.HorizontalAlignment = 'center';
            app.text8.VerticalAlignment = 'top';
            app.text8.WordWrap = 'on';
            app.text8.FontSize = 12;
            app.text8.Position = [164 173 49.9757869249395 23.7547445255474];
            app.text8.Text = 'max(°)';

            % Create text9
            app.text9 = uilabel(app.uipanel1);
            app.text9.Tag = 'text9';
            app.text9.HorizontalAlignment = 'center';
            app.text9.VerticalAlignment = 'top';
            app.text9.WordWrap = 'on';
            app.text9.FontSize = 12;
            app.text9.Position = [100 115 49.9757869249395 21.7751824817518];
            app.text9.Text = 'min(°)';

            % Create text10
            app.text10 = uilabel(app.uipanel1);
            app.text10.Tag = 'text10';
            app.text10.HorizontalAlignment = 'center';
            app.text10.VerticalAlignment = 'top';
            app.text10.WordWrap = 'on';
            app.text10.FontSize = 12;
            app.text10.Position = [164 115 49.9757869249395 21.7751824817518];
            app.text10.Text = 'max(°)';

            % Create text11
            app.text11 = uilabel(app.uipanel1);
            app.text11.Tag = 'text11';
            app.text11.HorizontalAlignment = 'center';
            app.text11.VerticalAlignment = 'top';
            app.text11.WordWrap = 'on';
            app.text11.FontSize = 12;
            app.text11.Position = [18 52 49.9757869249395 23.7547445255474];
            app.text11.Text = 'x start';

            % Create text12
            app.text12 = uilabel(app.uipanel1);
            app.text12.Tag = 'text12';
            app.text12.HorizontalAlignment = 'center';
            app.text12.VerticalAlignment = 'top';
            app.text12.WordWrap = 'on';
            app.text12.FontSize = 12;
            app.text12.Position = [83 52 49.9757869249395 23.7547445255474];
            app.text12.Text = 'y start';

            % Create text13
            app.text13 = uilabel(app.uipanel1);
            app.text13.Tag = 'text13';
            app.text13.HorizontalAlignment = 'center';
            app.text13.VerticalAlignment = 'top';
            app.text13.WordWrap = 'on';
            app.text13.FontSize = 12;
            app.text13.Position = [147 52 49.9757869249395 23.7547445255474];
            app.text13.Text = 'x finish';

            % Create text14
            app.text14 = uilabel(app.uipanel1);
            app.text14.Tag = 'text14';
            app.text14.HorizontalAlignment = 'center';
            app.text14.VerticalAlignment = 'top';
            app.text14.WordWrap = 'on';
            app.text14.FontSize = 12;
            app.text14.Position = [215 52 49.9757869249395 23.7547445255474];
            app.text14.Text = 'y finish';

            % Create uipanel2
            app.uipanel2 = uipanel(app.utm_window);
            app.uipanel2.Title = '  Fault elements  ';
            app.uipanel2.Tag = 'uipanel2';
            app.uipanel2.FontSize = 16;
            app.uipanel2.Position = [23 40 418 365];

            % Create edit_eq_length
            app.edit_eq_length = uieditfield(app.uipanel2, 'text');
            app.edit_eq_length.ValueChangedFcn = createCallbackFcn(app, @edit_eq_length_Callback, true);
            app.edit_eq_length.Tag = 'edit_eq_length';
            app.edit_eq_length.HorizontalAlignment = 'center';
            app.edit_eq_length.FontSize = 12;
            app.edit_eq_length.Position = [62 214 54.0521739130434 23.808];
            app.edit_eq_length.Value = '20.00';

            % Create edit_eq_width
            app.edit_eq_width = uieditfield(app.uipanel2, 'text');
            app.edit_eq_width.ValueChangedFcn = createCallbackFcn(app, @edit_eq_width_Callback, true);
            app.edit_eq_width.Tag = 'edit_eq_width';
            app.edit_eq_width.HorizontalAlignment = 'center';
            app.edit_eq_width.FontSize = 12;
            app.edit_eq_width.Position = [177 212 54.0521739130435 23.808];
            app.edit_eq_width.Value = '10.00';

            % Create pushbutton_empirical
            app.pushbutton_empirical = uibutton(app.uipanel2, 'push');
            app.pushbutton_empirical.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_empirical_Callback, true);
            app.pushbutton_empirical.Tag = 'pushbutton_empirical';
            app.pushbutton_empirical.FontSize = 12;
            app.pushbutton_empirical.FontAngle = 'italic';
            app.pushbutton_empirical.Position = [246 209 158.152657004831 29.76];
            app.pushbutton_empirical.Text = 'From empirical relations';

            % Create edit_eq_mo
            app.edit_eq_mo = uieditfield(app.uipanel2, 'text');
            app.edit_eq_mo.ValueChangedFcn = createCallbackFcn(app, @edit_eq_mo_Callback, true);
            app.edit_eq_mo.Tag = 'edit_eq_mo';
            app.edit_eq_mo.HorizontalAlignment = 'center';
            app.edit_eq_mo.FontSize = 12;
            app.edit_eq_mo.Position = [62 178 54.0521739130434 23.808];
            app.edit_eq_mo.Value = '6.6';

            % Create edit_eq_strike
            app.edit_eq_strike = uieditfield(app.uipanel2, 'text');
            app.edit_eq_strike.ValueChangedFcn = createCallbackFcn(app, @edit_eq_strike_Callback, true);
            app.edit_eq_strike.Tag = 'edit_eq_strike';
            app.edit_eq_strike.HorizontalAlignment = 'center';
            app.edit_eq_strike.FontSize = 12;
            app.edit_eq_strike.Position = [62 141 54.0521739130434 23.808];
            app.edit_eq_strike.Value = '303.0';

            % Create edit_eq_dip
            app.edit_eq_dip = uieditfield(app.uipanel2, 'text');
            app.edit_eq_dip.ValueChangedFcn = createCallbackFcn(app, @edit_eq_dip_Callback, true);
            app.edit_eq_dip.Tag = 'edit_eq_dip';
            app.edit_eq_dip.HorizontalAlignment = 'center';
            app.edit_eq_dip.FontSize = 12;
            app.edit_eq_dip.Position = [159 141 54.0521739130434 23.808];
            app.edit_eq_dip.Value = '81.0';

            % Create edit_eq_rake
            app.edit_eq_rake = uieditfield(app.uipanel2, 'text');
            app.edit_eq_rake.ValueChangedFcn = createCallbackFcn(app, @edit_eq_rake_Callback, true);
            app.edit_eq_rake.Tag = 'edit_eq_rake';
            app.edit_eq_rake.HorizontalAlignment = 'center';
            app.edit_eq_rake.FontSize = 12;
            app.edit_eq_rake.Position = [257 141 54.0521739130435 23.808];
            app.edit_eq_rake.Value = '4.0';

            % Create uipanel3
            app.uipanel3 = uipanel(app.uipanel2);
            app.uipanel3.Title = '   Fault reference point   ';
            app.uipanel3.Tag = 'uipanel3';
            app.uipanel3.FontSize = 12;
            app.uipanel3.Position = [10 252 398 83];

            % Create edit_eq_lon
            app.edit_eq_lon = uieditfield(app.uipanel3, 'text');
            app.edit_eq_lon.ValueChangedFcn = createCallbackFcn(app, @edit_eq_lon_Callback, true);
            app.edit_eq_lon.Tag = 'edit_eq_lon';
            app.edit_eq_lon.HorizontalAlignment = 'center';
            app.edit_eq_lon.FontSize = 12;
            app.edit_eq_lon.Position = [68 9 54.0548223350254 24.2666666666667];
            app.edit_eq_lon.Value = '130.178';

            % Create edit_eq_lat
            app.edit_eq_lat = uieditfield(app.uipanel3, 'text');
            app.edit_eq_lat.ValueChangedFcn = createCallbackFcn(app, @edit_eq_lat_Callback, true);
            app.edit_eq_lat.Tag = 'edit_eq_lat';
            app.edit_eq_lat.HorizontalAlignment = 'center';
            app.edit_eq_lat.FontSize = 12;
            app.edit_eq_lat.Position = [185 9 54.0548223350254 24.2666666666667];
            app.edit_eq_lat.Value = '33.741';

            % Create edit_eq_depth
            app.edit_eq_depth = uieditfield(app.uipanel3, 'text');
            app.edit_eq_depth.ValueChangedFcn = createCallbackFcn(app, @edit_eq_depth_Callback, true);
            app.edit_eq_depth.Tag = 'edit_eq_depth';
            app.edit_eq_depth.HorizontalAlignment = 'center';
            app.edit_eq_depth.FontSize = 12;
            app.edit_eq_depth.Position = [302 9 54.0548223350254 24.2666666666667];
            app.edit_eq_depth.Value = '7.50';

            % Create text21
            app.text21 = uilabel(app.uipanel3);
            app.text21.Tag = 'text21';
            app.text21.HorizontalAlignment = 'center';
            app.text21.VerticalAlignment = 'top';
            app.text21.WordWrap = 'on';
            app.text21.FontSize = 13.3333333333333;
            app.text21.Position = [253 5 46 38];
            app.text21.Text = {'depth to'; 'source'};

            % Create text19
            app.text19 = uilabel(app.uipanel3);
            app.text19.Tag = 'text19';
            app.text19.HorizontalAlignment = 'center';
            app.text19.VerticalAlignment = 'top';
            app.text19.WordWrap = 'on';
            app.text19.FontSize = 12;
            app.text19.Position = [135 6 49.0497461928934 25.2777777777778];
            app.text19.Text = 'lat.(°N)';

            % Create text20
            app.text20 = uilabel(app.uipanel3);
            app.text20.Tag = 'text20';
            app.text20.HorizontalAlignment = 'center';
            app.text20.VerticalAlignment = 'top';
            app.text20.WordWrap = 'on';
            app.text20.FontSize = 12;
            app.text20.Position = [17 6 46.0467005076142 25.2777777777778];
            app.text20.Text = 'lon.(°E)';

            % Create text48
            app.text48 = uilabel(app.uipanel3);
            app.text48.Tag = 'text48';
            app.text48.HorizontalAlignment = 'center';
            app.text48.VerticalAlignment = 'top';
            app.text48.WordWrap = 'on';
            app.text48.FontSize = 16;
            app.text48.Position = [358 3 31.0314720812183 25.2777777777778];
            app.text48.Text = 'km';

            % Create edit_fx_start
            app.edit_fx_start = uieditfield(app.uipanel2, 'text');
            app.edit_fx_start.ValueChangedFcn = createCallbackFcn(app, @edit_fx_start_Callback, true);
            app.edit_fx_start.Tag = 'edit_fx_start';
            app.edit_fx_start.HorizontalAlignment = 'center';
            app.edit_fx_start.FontSize = 12;
            app.edit_fx_start.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_fx_start.Position = [50 80 54.0521739130435 23.808];

            % Create edit_fy_start
            app.edit_fy_start = uieditfield(app.uipanel2, 'text');
            app.edit_fy_start.ValueChangedFcn = createCallbackFcn(app, @edit_fy_start_Callback, true);
            app.edit_fy_start.Tag = 'edit_fy_start';
            app.edit_fy_start.HorizontalAlignment = 'center';
            app.edit_fy_start.FontSize = 12;
            app.edit_fy_start.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_fy_start.Position = [117 80 54.0521739130435 23.808];

            % Create edit_fx_finish
            app.edit_fx_finish = uieditfield(app.uipanel2, 'text');
            app.edit_fx_finish.ValueChangedFcn = createCallbackFcn(app, @edit_fx_finish_Callback, true);
            app.edit_fx_finish.Tag = 'edit_fx_finish';
            app.edit_fx_finish.HorizontalAlignment = 'center';
            app.edit_fx_finish.FontSize = 12;
            app.edit_fx_finish.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_fx_finish.Position = [182 80 54.0521739130434 23.808];

            % Create edit_fy_finish
            app.edit_fy_finish = uieditfield(app.uipanel2, 'text');
            app.edit_fy_finish.ValueChangedFcn = createCallbackFcn(app, @edit_fy_finish_Callback, true);
            app.edit_fy_finish.Tag = 'edit_fy_finish';
            app.edit_fy_finish.HorizontalAlignment = 'center';
            app.edit_fy_finish.FontSize = 12;
            app.edit_fy_finish.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_fy_finish.Position = [247 80 54.0521739130435 23.808];

            % Create edit_right_lat
            app.edit_right_lat = uieditfield(app.uipanel2, 'text');
            app.edit_right_lat.ValueChangedFcn = createCallbackFcn(app, @edit_right_lat_Callback, true);
            app.edit_right_lat.Tag = 'edit_right_lat';
            app.edit_right_lat.HorizontalAlignment = 'center';
            app.edit_right_lat.FontSize = 12;
            app.edit_right_lat.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_right_lat.Position = [49 26 54.0521739130435 23.808];

            % Create edit_rev_lat
            app.edit_rev_lat = uieditfield(app.uipanel2, 'text');
            app.edit_rev_lat.ValueChangedFcn = createCallbackFcn(app, @edit_rev_lat_Callback, true);
            app.edit_rev_lat.Tag = 'edit_rev_lat';
            app.edit_rev_lat.HorizontalAlignment = 'center';
            app.edit_rev_lat.FontSize = 12;
            app.edit_rev_lat.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_rev_lat.Position = [116 26 54.0521739130435 23.808];

            % Create edit_f_top
            app.edit_f_top = uieditfield(app.uipanel2, 'text');
            app.edit_f_top.ValueChangedFcn = createCallbackFcn(app, @edit_f_top_Callback, true);
            app.edit_f_top.Tag = 'edit_f_top';
            app.edit_f_top.HorizontalAlignment = 'center';
            app.edit_f_top.FontSize = 12;
            app.edit_f_top.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_f_top.Position = [181 25 54.0521739130435 23.808];

            % Create edit_f_bottom
            app.edit_f_bottom = uieditfield(app.uipanel2, 'text');
            app.edit_f_bottom.ValueChangedFcn = createCallbackFcn(app, @edit_f_bottom_Callback, true);
            app.edit_f_bottom.Tag = 'edit_f_bottom';
            app.edit_f_bottom.HorizontalAlignment = 'center';
            app.edit_f_bottom.FontSize = 12;
            app.edit_f_bottom.BackgroundColor = [1 0.899999976158142 0.5];
            app.edit_f_bottom.Position = [247 25 54.0521739130435 23.808];

            % Create edit_id_number
            app.edit_id_number = uieditfield(app.uipanel2, 'text');
            app.edit_id_number.ValueChangedFcn = createCallbackFcn(app, @edit_id_number_Callback, true);
            app.edit_id_number.Tag = 'edit_id_number';
            app.edit_id_number.HorizontalAlignment = 'center';
            app.edit_id_number.FontSize = 12;
            app.edit_id_number.FontWeight = 'bold';
            app.edit_id_number.BackgroundColor = [1 0.9 0.5];
            app.edit_id_number.Position = [337 108 54.0521739130435 23.808];
            app.edit_id_number.Value = '1';

            % Create pushbutton_f_calc
            app.pushbutton_f_calc = uibutton(app.uipanel2, 'push');
            app.pushbutton_f_calc.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_f_calc_Callback, true);
            app.pushbutton_f_calc.Tag = 'pushbutton_f_calc';
            app.pushbutton_f_calc.BackgroundColor = [0.702 0.702 0.702];
            app.pushbutton_f_calc.FontSize = 12;
            app.pushbutton_f_calc.FontWeight = 'bold';
            app.pushbutton_f_calc.Enable = 'off';
            app.pushbutton_f_calc.Position = [317 63 85.0821256038648 29.76];
            app.pushbutton_f_calc.Text = '3) Calc.';

            % Create pushbutton_f_add
            app.pushbutton_f_add = uibutton(app.uipanel2, 'push');
            app.pushbutton_f_add.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_f_add_Callback, true);
            app.pushbutton_f_add.Tag = 'pushbutton_f_add';
            app.pushbutton_f_add.BackgroundColor = [0.702 0.702 0.702];
            app.pushbutton_f_add.FontSize = 10.6666666666667;
            app.pushbutton_f_add.FontWeight = 'bold';
            app.pushbutton_f_add.Enable = 'off';
            app.pushbutton_f_add.Position = [317 23 85.0821256038647 29.76];
            app.pushbutton_f_add.Text = '4) Add to map';

            % Create text40
            app.text40 = uilabel(app.uipanel2);
            app.text40.Tag = 'text40';
            app.text40.HorizontalAlignment = 'center';
            app.text40.VerticalAlignment = 'top';
            app.text40.WordWrap = 'on';
            app.text40.FontSize = 12;
            app.text40.Position = [329 135 70.0676328502415 15.872];
            app.text40.Text = 'ID number';

            % Create text53
            app.text53 = uilabel(app.uipanel2);
            app.text53.Tag = 'text53';
            app.text53.HorizontalAlignment = 'center';
            app.text53.VerticalAlignment = 'top';
            app.text53.WordWrap = 'on';
            app.text53.FontSize = 12;
            app.text53.Position = [134 206 43.0415458937198 33.728];
            app.text53.Text = {'width'; '(km)'};

            % Create text22
            app.text22 = uilabel(app.uipanel2);
            app.text22.Tag = 'text22';
            app.text22.HorizontalAlignment = 'center';
            app.text22.VerticalAlignment = 'top';
            app.text22.WordWrap = 'on';
            app.text22.FontSize = 12;
            app.text22.Position = [15 207 43.0415458937198 33.728];
            app.text22.Text = {'length'; '(km)'};

            % Create text24
            app.text24 = uilabel(app.uipanel2);
            app.text24.Tag = 'text24';
            app.text24.HorizontalAlignment = 'center';
            app.text24.VerticalAlignment = 'top';
            app.text24.WordWrap = 'on';
            app.text24.FontSize = 12;
            app.text24.Position = [25 172 30.0289855072464 23.808];
            app.text24.Text = 'Mw';

            % Create text27
            app.text27 = uilabel(app.uipanel2);
            app.text27.Tag = 'text27';
            app.text27.HorizontalAlignment = 'center';
            app.text27.VerticalAlignment = 'top';
            app.text27.WordWrap = 'on';
            app.text27.FontSize = 12;
            app.text27.Position = [228 136 30.0289855072464 23.808];
            app.text27.Text = 'rake';

            % Create text25
            app.text25 = uilabel(app.uipanel2);
            app.text25.Tag = 'text25';
            app.text25.HorizontalAlignment = 'center';
            app.text25.VerticalAlignment = 'top';
            app.text25.WordWrap = 'on';
            app.text25.FontSize = 12;
            app.text25.Position = [26 137 30.0289855072464 23.808];
            app.text25.Text = 'strike';

            % Create text26
            app.text26 = uilabel(app.uipanel2);
            app.text26.Tag = 'text26';
            app.text26.HorizontalAlignment = 'center';
            app.text26.VerticalAlignment = 'top';
            app.text26.WordWrap = 'on';
            app.text26.FontSize = 12;
            app.text26.Position = [129 135 30.0289855072464 23.808];
            app.text26.Text = 'dip';

            % Create text28
            app.text28 = uilabel(app.uipanel2);
            app.text28.Tag = 'text28';
            app.text28.HorizontalAlignment = 'center';
            app.text28.VerticalAlignment = 'top';
            app.text28.WordWrap = 'on';
            app.text28.FontSize = 12;
            app.text28.Position = [53 104 50.0483091787439 23.808];
            app.text28.Text = 'x start';

            % Create text29
            app.text29 = uilabel(app.uipanel2);
            app.text29.Tag = 'text29';
            app.text29.HorizontalAlignment = 'center';
            app.text29.VerticalAlignment = 'top';
            app.text29.WordWrap = 'on';
            app.text29.FontSize = 12;
            app.text29.Position = [118 104 50.0483091787439 23.808];
            app.text29.Text = 'y start';

            % Create text30
            app.text30 = uilabel(app.uipanel2);
            app.text30.Tag = 'text30';
            app.text30.HorizontalAlignment = 'center';
            app.text30.VerticalAlignment = 'top';
            app.text30.WordWrap = 'on';
            app.text30.FontSize = 12;
            app.text30.Position = [186 104 50.0483091787439 23.808];
            app.text30.Text = 'x finish';

            % Create text31
            app.text31 = uilabel(app.uipanel2);
            app.text31.Tag = 'text31';
            app.text31.HorizontalAlignment = 'center';
            app.text31.VerticalAlignment = 'top';
            app.text31.WordWrap = 'on';
            app.text31.FontSize = 12;
            app.text31.Position = [247 104 50.048309178744 23.808];
            app.text31.Text = 'y finish';

            % Create text32
            app.text32 = uilabel(app.uipanel2);
            app.text32.Tag = 'text32';
            app.text32.HorizontalAlignment = 'center';
            app.text32.VerticalAlignment = 'top';
            app.text32.WordWrap = 'on';
            app.text32.FontSize = 12;
            app.text32.Position = [183 51 50.0483091787439 23.808];
            app.text32.Text = 'top';

            % Create text33
            app.text33 = uilabel(app.uipanel2);
            app.text33.Tag = 'text33';
            app.text33.HorizontalAlignment = 'center';
            app.text33.VerticalAlignment = 'top';
            app.text33.WordWrap = 'on';
            app.text33.FontSize = 12;
            app.text33.Position = [248 51 50.0483091787439 23.808];
            app.text33.Text = 'bottom';

            % Create text34
            app.text34 = uilabel(app.uipanel2);
            app.text34.Tag = 'text34';
            app.text34.HorizontalAlignment = 'center';
            app.text34.VerticalAlignment = 'top';
            app.text34.WordWrap = 'on';
            app.text34.FontSize = 12;
            app.text34.Position = [53 51 50.048309178744 23.808];
            app.text34.Text = 'right lat.';

            % Create text35
            app.text35 = uilabel(app.uipanel2);
            app.text35.Tag = 'text35';
            app.text35.HorizontalAlignment = 'center';
            app.text35.VerticalAlignment = 'top';
            app.text35.WordWrap = 'on';
            app.text35.FontSize = 12;
            app.text35.Position = [119 51 50.0483091787439 23.808];
            app.text35.Text = 'rev. slip';

            % Create edit_all_input_params
            app.edit_all_input_params = uibutton(app.utm_window, 'push');
            app.edit_all_input_params.ButtonPushedFcn = createCallbackFcn(app, @edit_all_input_params_Callback, true);
            app.edit_all_input_params.Tag = 'edit_all_input_params';
            app.edit_all_input_params.FontSize = 12;
            app.edit_all_input_params.Enable = 'off';
            app.edit_all_input_params.Position = [91 6 160 30];
            app.edit_all_input_params.Text = 'Edit all input parameters';

            % Create pushbutton_utm_cancel
            app.pushbutton_utm_cancel = uibutton(app.utm_window, 'push');
            app.pushbutton_utm_cancel.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_utm_cancel_Callback, true);
            app.pushbutton_utm_cancel.Tag = 'pushbutton_utm_cancel';
            app.pushbutton_utm_cancel.FontSize = 16;
            app.pushbutton_utm_cancel.Position = [288 6 70 30];
            app.pushbutton_utm_cancel.Text = 'Cancel';

            % Create pushbutton_utm_ok
            app.pushbutton_utm_ok = uibutton(app.utm_window, 'push');
            app.pushbutton_utm_ok.ButtonPushedFcn = createCallbackFcn(app, @pushbutton_utm_ok_Callback, true);
            app.pushbutton_utm_ok.Tag = 'pushbutton_utm_ok';
            app.pushbutton_utm_ok.FontSize = 16;
            app.pushbutton_utm_ok.FontWeight = 'bold';
            app.pushbutton_utm_ok.Position = [369 6 70 30];
            app.pushbutton_utm_ok.Text = 'OK';

            % Create text54
            app.text54 = uilabel(app.utm_window);
            app.text54.Tag = 'text54';
            app.text54.BackgroundColor = [0.702 0.702 0.702];
            app.text54.HorizontalAlignment = 'center';
            app.text54.VerticalAlignment = 'top';
            app.text54.WordWrap = 'on';
            app.text54.FontSize = 12;
            app.text54.Position = [27 704 409 20];
            app.text54.Text = 'Follow the sequential procedure 1), 2), 3), and 4) to complete the input file.';

            % Show the figure after all components are created
            app.utm_window.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = utm_window_App(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.utm_window)

                % Execute the startup function
                runStartupFcn(app, @(app)utm_window_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.utm_window)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.utm_window)
        end
    end
end