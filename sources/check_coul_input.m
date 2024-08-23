% このスクリプトは、Coulombウィンドウの入力値をチェックするために一般的に使用される小さなスクリプトです。
% ("xsec_window.m" と連携しています)

% GUIの指定されたタグに対応する値を取得し、それらを数値に変換して変数に格納します。
h = findobj('Tag','edit_spec_strike'); % ストライク角の入力フィールドを検索
strike = str2double(get(h,'String'));  % 文字列を数値に変換して取得

h = findobj('Tag','edit_spec_dip');    % ディップ角の入力フィールドを検索
dip = str2double(get(h,'String'));     % 文字列を数値に変換して取得

h = findobj('Tag','edit_spec_rake');   % レーキ角の入力フィールドを検索
rake = str2double(get(h,'String'));    % 文字列を数値に変換して取得

h = findobj('Tag','edit_coul_depth');  % 深さの入力フィールドを検索
depth = str2double(get(h,'String'));   % 文字列を数値に変換して取得

h = findobj('Tag','edit_coul_fric');   % 摩擦係数の入力フィールドを検索
fric = str2double(get(h,'String'));    % 文字列を数値に変換して取得

% 入力値が許容範囲外の場合の警告を表示し、フィールドにデフォルト値を設定します。
% ストライク角が0〜360度の範囲外の場合
if (strike > 360.0 | strike < 0.0)
   h = warndlg('strike should be 0-360 deg.','Warning!');                % 警告ダイアログを表示
   set(findobj('Tag','edit_spec_strike'),'String',num2str(0.0,'%6.1f')); % ディップ角に90.0を設定
end
% ディップ角が0〜90度の範囲外の場合
if (dip <= 0.0 | dip > 90.0)
   h = warndlg('Dip should be 0-90 deg','Warning!');                    % 警告ダイアログを表示
    set(findobj('Tag','edit_spec_dip'),'String',num2str(90.0,'%6.1f')); % ディップ角に90.0を設定
end
% 深さが負の場合
if depth < 0.0
   h = warndlg('Depth should be positive','Warning!');                  % 警告ダイアログを表示
   set(findobj('Tag','edit_coul_depth'),'String',num2str(0.0,'%6.1f')); % 深さに0.0を設定
end
% 摩擦係数が0〜1の範囲外の場合
if (fric < 0.0 | fric > 1.0)
   h = warndlg('Friction should be 0-1','Warning!');                    % 警告ダイアログを表示
   set(findobj('Tag','edit_coul_fric'),'String',num2str(0.0,'%6.1f'));  % 摩擦係数に0.0を設定 
end
