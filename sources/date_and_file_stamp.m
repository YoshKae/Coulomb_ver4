function date_and_file_stamp(hw,fname,xp,yp,lspace,ftype,depth,stype,fric,dtype,...
    depthrange,strike,dip,rake,isec_flag,xs,ys,xf,yf,sdip);
% この関数は、日付、ファイル名、およびその他の情報を図にスタンプとして追加します。

% INPUT
%   hw: 現在のウィンドウハンドル（スタンプを表示するウィンドウ）
%   fname: 入力ファイル名（文字列）
%   xp, yp: スタンプの位置
%   lspace: 行間の幅
%   ftype: 計算の種類を表すFUNC_TYPE
%   stype: 応力の種類を表すSTRESS_TYPE
%   dtype: 深さ範囲の種類を表すDEPTH_RANGE_TYPE
%   fric: 摩擦係数
%   depth: 計算深度（CALC_DEPTH）
%   depthrange: DEPTH_RANGE_TYPEが1の場合の計算深度範囲
%   strike, dip, rake: 断層のストライク、ディップ、レイクの角度
%   isec_flag: 断層がセクションであるかどうかのフラグ
%   xs, ys, xf, yf: セクションの開始点と終了点の座標
%   sdip: セクションのディップ角度

% OUTPUT
%   スタンプは指定されたウィンドウ（hw）に表示されます。

% ファイル名が空の場合は関数を終了
if isempty(fname)==1
    return
end

% 引数が14個以下の場合、セクションフラグをデフォルトの0に設定
if (nargin <= 14)
    isec_flag = 0;
end

% スタンプのフォントサイズとフォント名の設定
psize = 10;
pname = 'Arial';

% アプリケーション名と現在の日付を取得
app_name = 'Coulomb 3.0.1   ';
date_stamp = datestr(now,0);

% 計算の種類に応じてスタンプ内容を作成
if ftype >= 1 && ftype <= 6
    % マップビュー、水平ベクトル、変形ワイヤーフレームなどの場合
    if ftype == 1
        calc_stamp = 'Map view grid';
    elseif ftype == 2
        calc_stamp = 'Horizontal vectors';
    elseif ftype == 3
        calc_stamp = 'Deformed wireframe';
    elseif ftype == 4
        calc_stamp = 'Vertical displecement';
    elseif ftype == 6
        calc_stamp = 'Strain calc.';
    else
        calc_stamp = '---';
    end
    % 深さ情報を追加
    depth_stamp = ['  Depth: ',num2str(depth,'%6.2f'),' km'];
    h3_stamp = [calc_stamp,depth_stamp];

elseif ftype >= 7 && ftype <=9
    % 最適方位断層、ストライクスリップ断層、スラスト断層などの場合
    switch stype
        case 1
            calc_stamp = 'Opt. oriented faults';
        case 2
            calc_stamp = 'Opt. strike-slip faults';
        case 3
            calc_stamp = 'Opt. thrust faults';
        case 4
            calc_stamp = 'Opt. normal faults';
        case 5
            calc_stamp = ['Specified faults: ',num2str(strike),'/',num2str(dip),'/',num2str(rake)];            
        otherwise
            calc_stamp = '---';    
    end

    % 摩擦係数を追加
    fric_stamp  = ['  Friction: ',num2str(fric,'%4.2f')];
    if isec_flag == 0
        % 深さ情報を追加
        depth_stamp = ['  Depth: ',num2str(depth,'%6.2f'),' km'];
        if dtype == 1
            depth_stamp = ['  Depth: ',num2str(depthrange(1)),'-',num2str(depthrange(end)),' km'];  
        end
    else
        % セクション情報を追加
        depth_stamp = [' A(',num2str(xs),',',num2str(ys),') --- B(',num2str(xf),',',num2str(yf),') dip ',num2str(sdip),' deg.'];
    end
    h3_stamp = [calc_stamp,depth_stamp,fric_stamp];
else
    % その他の計算タイプ
    calc_stamp = 'Stress on nodal planes';
    depth_stamp = ['  Depth: --- km'];
    h3_stamp = [calc_stamp];    
end

% ウィンドウ（hw）にスタンプを表示
figure(hw);
hold on;
h1 = text(xp,yp,[app_name,date_stamp, '  ' ,fname]);
h2 = text(xp,yp-1.0*lspace,h3_stamp);
set(h1,'HorizontalAlignment','right','FontSize',psize,'FontName',pname);
set(h2,'HorizontalAlignment','right','FontSize',psize,'FontName',pname);
