% このスクリプトは、断面図ウィンドウの入力値を確認するために一般的に使用されます。
% （"xsec_window.m"と連動しています）
%
% 注意: 研究領域を確認するには、事前にグローバル変数GRIDを宣言する必要があります。
%    xstart = GRID(1,1);
%    ystart = GRID(2,1);
%    xfinish = GRID(3,1);
%    yfinish = GRID(4,1);

global GRID ICOORD % IACTS = 0;

% UTM座標系を使用していない場合は処理を実行します。
if ICOORD ~= 2
   % 断面の開始点と終了点、その他のパラメータを取得します
   h = findobj('Tag','edit_sec_xs');
   sec_xs = str2double(get(h,'String'));       % 始点のX座標を取得

   h = findobj('Tag','edit_sec_ys');
   sec_ys = str2double(get(h,'String'));       % 始点のY座標を取得
   
   h = findobj('Tag','edit_sec_xf');
   sec_xf = str2double(get(h,'String'));       % 終点のX座標を取得
   
   h = findobj('Tag','edit_sec_yf');
   sec_yf = str2double(get(h,'String'));       % 終点のY座標を取得
   
   h = findobj('Tag','edit_sec_incre');
   sec_incre = str2double(get(h,'String'));    % 断面の増分を取得
   
   h = findobj('Tag','edit_sec_depth');
   sec_depth = str2double(get(h,'String'));    % 断面の深さを取得
   
   h = findobj('Tag','edit_sec_depthinc');
   sec_depthinc = str2double(get(h,'String')); % 断面の深さの増分を取得
   
   % 開始点と終了点の距離を計算します。
   distance = sqrt((sec_xf-sec_xs)^2+(sec_yf-sec_ys)^2);
   % 深さと距離の増分許容範囲を計算します。
   depth_allowance = sec_depth/sec_depthinc;
   distance_allowance = distance/sec_incre;

   % デフォルトの許容値を設定します。
   allowance = 3;

   % 不適切な入力値に対する警告を表示します。

   % 深さが0以下の場合の警告
   if sec_depth <= 0.0
      h = warndlg('Depth should be positive','Warning!');
   end

   % 増分が0以下の場合の警告
   if sec_incre <=0.0
      h = warndlg('Increment should be positive','Warning!');
   end

   % 深さの増分が0以下の場合の警告
   if sec_depthinc <=0.0
      h = warndlg('Increment should be positive','Warning!');
   end

   % 深さの増分が深さより大きい場合の警告
   if depth_allowance < allowance
      h = warndlg('Depth increment should be small enough to the depth','Warning!');
   end

   % 距離の増分が距離より大きい場合の警告
   if distance_allowance < allowance
      h = warndlg('Distance increment should be small enough to the section','Warning!');
   end

   % 開始点と終了点が研究領域外の場合の警告
   if sec_xs < GRID(1,1) | sec_xf > GRID(3,1)
      h = warndlg('Selected point should be within the area','Warning!');
   end
   if sec_ys < GRID(2,1) | sec_yf > GRID(4,1)
      h = warndlg('Selected point should be within the area','Warning!');
   end
end
