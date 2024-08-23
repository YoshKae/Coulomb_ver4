global DC3D CALC_DEPTH SHEAR NORMAL R_STRESS
global IACT IACTS
global STRESS_TYPE
global STRIKE DIP RAKE
global COLORSN % 色の飽和値
global H_SECTION H_SEC_WINDOW H_MAIN H_COULOMB
global FLAG_SLIP_LINE
global XYCOORD
global XGRID YGRID
global GRID
global DEPTH_RANGE_TYPE CALC_DEPTH_RANGE
global CC PK_DEPTH
global FLAG_PR_AXES
global INPUT_FILE COAST_DATA EQ_DATA AFAULT_DATA GPS_DATA
global PHII
global OUTFLAG PREF_DIR HOME_DIR
global RECEIVERS % 地域設定のための行列形式（通常は空）

% Figure pointer (busy...)の設定
set(gcf,'Pointer','watch');
set(H_MAIN,'Pointer','watch');
set(H_COULOMB,'Pointer','watch');
set(findobj('Tag','crosssection_toggle'),'Enable','on');

% ユーザーインターフェースから摩擦係数の取得
friction = str2num(get(findobj('Tag','edit_coul_fric'),'String'));
if DEPTH_RANGE_TYPE == 0
    CALC_DEPTH =  str2num(get(findobj('Tag','edit_coul_depth'),'String'));
else
    temp_calc_depth =  CALC_DEPTH;
end

% 摩擦係数が0の場合、微小値に設定
if friction == 0.0
    friction = 0.00001;
end
% 摩擦角度の計算
beta = 0.5 * (atan(1.0/friction));


% *********単一深度計算または最大値・平均値取得のための繰り返し**********
if DEPTH_RANGE_TYPE == 0
    mloop = 1;
elseif DEPTH_RANGE_TYPE == 1
    mloop = length(CALC_DEPTH_RANGE);
    CC = ones(length(YGRID),length(XGRID),'double') * (-10000.0);
    n = length(YGRID) * length(XGRID);
    PK_DEPTH = ones(1,n) * (-1.0);
else
    mloop = length(CALC_DEPTH_RANGE);
    CC = zeros(length(YGRID),length(XGRID),'double');    
end


%**************************************************************************
%	複数の計算層での計算を実行するためのループ (ループの開始)
%**************************************************************************

for kk = 1:mloop
    if DEPTH_RANGE_TYPE ~= 0
        CALC_DEPTH = CALC_DEPTH_RANGE(kk);  % 現在の深度に設定
    end
    if IACT == 0 | kk >= 2
        Okada_halfspace;  % Okadaの半空間モデルによる変位計算
    	IACT = 1;
    end
    a = length(DC3D);  % 変位データの長さを取得
    if a < 14
        h = warndlg('Increase total grid number more than 14.','Warning!');
    end
    
    % 応力テンソルの初期化
    ss = zeros(6,a);
    s9 = reshape(DC3D(:,9),1,a);
    s10 = reshape(DC3D(:,10),1,a);
    s11 = reshape(DC3D(:,11),1,a);
    s12 = reshape(DC3D(:,12),1,a);
    s13 = reshape(DC3D(:,13),1,a);
    s14 = reshape(DC3D(:,14),1,a);
    ss = [s9; s10; s11; s12; s13; s14];


%================= 応力計算のタイプによる切り替え ========================
switch STRESS_TYPE
%  -----指定された断層の計算用
    case 5
        strike = str2num(get(findobj('Tag','edit_spec_strike'),'String'));
        dip = str2num(get(findobj('Tag','edit_spec_dip'),'String'));
        rake = str2num(get(findobj('Tag','edit_spec_rake'),'String'));
        if FLAG_PR_AXES == 1
            d = warndlg('To see the axes, choose one of the opt functions.','Warning!');
        return
        end
        
%  -----最適なストライクスリップ、ディップスリップ断層の場合 
    otherwise
        if DEPTH_RANGE_TYPE == 0
            c_depth = CALC_DEPTH;
        else
            c_depth = CALC_DEPTH_RANGE(kk);
        end

        % 地域応力の計算
        [rs] = regional_stress(R_STRESS,c_depth);
        
        sgx  = zeros(a,1) + rs(1,1) + reshape(ss(1,1:a),a,1);
        sgy  = zeros(a,1) + rs(2,1) + reshape(ss(2,1:a),a,1);
        sgz  = zeros(a,1) + rs(3,1) + reshape(ss(3,1:a),a,1);
        sgyz = zeros(a,1) + rs(4,1) + reshape(ss(4,1:a),a,1);
        sgxz = zeros(a,1) + rs(5,1) + reshape(ss(5,1:a),a,1);
        sgxy = zeros(a,1) + rs(6,1) + reshape(ss(6,1:a),a,1);

        % 主応力軸の計算
        pt_rs = zeros(a,9);    
        for k = 1:a
            [V,D] = eig([sgx(k,1) sgxy(k,1) sgxz(k,1); sgxy(k,1) sgy(k,1) sgyz(k,1);...
                    sgxz(k,1) sgyz(k,1) sgz(k,1)]);
            evc = reshape(V',1,9);
            eva = [D(1,1) D(2,2) D(3,3)];
            pt_rs(k,:) = find_axes(evc,eva);
        end


%===== 平面応力条件下でのσ1とσ3を求める =============
    if STRESS_TYPE ~= 5
        phi = zeros(a,1) + 0.5 * atan((2.0 * sgxy)./(sgx - sgy)) + pi/2.0;
        ct = zeros(a,1) + cos(phi);
        st = zeros(a,1) + sin(phi);
        erad1 = sgx.*ct.*ct+sgy.*st.*st+2.0.*sgx.*st.*ct;
        erad2 = sgx.*st.*st+sgy.*ct.*ct-2.0.*sgx.*st.*ct;
        nn = length(phi);
        for k = 1:nn
            if erad2(k) >= erad1(k)
            else
            end
            phi(k) = deg2rad(pt_rs(k,1));
        end
        PHII = rad2deg(phi); % 計算した角度を度に変換
    end


%===== 最適断層オプションのストライク、ディップ、レークを求める =============

%  -----最適ストライクスリップ断層の場合
    if STRESS_TYPE == 2
        strike = zeros(a,1) + rad2deg(phi) - rad2deg(beta);
        strike2 = zeros(a,1) + rad2deg(phi) + rad2deg(beta);
        cg1 = strike < 0.0; cg2 = strike >= 0.0;
        strike = (180.0 + strike) .* cg1 + strike .* cg2;
        strike = round(strike);
        dip = 90.0;
        rake = 180.0;

%  -----最適逆断層の場合
    elseif STRESS_TYPE == 3
        strike = zeros(a,1) + rad2deg(phi) + 90.0;
        if strike >= 360.0; strike = strike - 360.0; end;
        dip = abs(rad2deg(beta));
        rake = 90.0;

 %  ----最適正断層の場合       
    elseif STRESS_TYPE == 4
        strike = zeros(a,1) + rad2deg(phi);
        dip = abs(90.0-rad2deg(beta));
        rake = -90.0;
    
        % ダミーの場合
    else
        strike = 180;
        dip = 90;
        rake = 0;
    end
end
%================= switch文の終了====================


% 他の関数に変数を引き渡す
STRIKE = strike;
DIP = dip;
RAKE = rake;
FRIC = friction;

%==========================================================================
% === we can remove this part now (Feb. 12, 2008) =========================

% 摩擦のみが変更された場合の処理（スキップ）
if IACT == 2
    coulomb = zeros(a,1);
    c4 = zeros(a,1) + friction;
    coulomb = SHEAR + c4 .* NORMAL;
    b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL];

    % 全データをファイルに書き出す（テキスト形式）
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
        header1 = ['Input file selected: ',INPUT_FILE];
        if STRESS_TYPE == 1
            header2 = 'x y z coulomb shear normal opt-oriented-strike dip rake';
            header3 = '(km) (km) (km) (bar) (bar) (bar) (degree) (degree) (degree)';
        else
            header2 = 'x y z coulomb shear normal';
            header3 = '(km) (km) (km) (bar) (bar) (bar)';
        end
        dlmwrite('dcff.cou',header1,'delimiter',''); 
        dlmwrite('dcff.cou',header2,'-append','delimiter',''); 
        dlmwrite('dcff.cou',header3,'-append','delimiter',''); 
        dlmwrite('dcff.cou',b,'-append','delimiter','\t','precision','%.6f');
        if DEPTH_RANGE_TYPE == 1
            fname2 = ['dcff_' num2str(int32(CALC_DEPTH_RANGE(kk))) 'km.cou'];
            copyfile('dcff.cou',fname2);
        end
% =========================================================================        
%==========================================================================

    cd (HOME_DIR);

% スキップせずに全体の計算を行う場合
else
    SHEAR = zeros(a,1);
    NORMAL = zeros(a,1);
    coulomb = zeros(a,1);

    % 最適断層の場合（複雑なグリッドサーチを行う）
    if STRESS_TYPE == 1
        strike = zeros(a,1);
        dip    = zeros(a,1);
        rake   = zeros(a,1);
        size(rs)
        size(ss)
        for i = 1:a
            optData = calcOptPlanes(rs,ss(:,i),FRIC);
            strike(i,1) = optData(1);
            dip(i,1)    = optData(2);
            rake(i,1)   = optData(3);
        end
     end

     % ユーザーが特定の行列を用意した場合
    if ~isempty(RECEIVERS)
        try
            c1 = zeros(a,1) + RECEIVERS(:,1);
            c2 = zeros(a,1) + RECEIVERS(:,2);
            c3 = zeros(a,1) + RECEIVERS(:,3);
        catch
            disp('Make sure the receiver fault matrix.');
            disp('Now using scalar strike, dip, and rake.');
            c1 = zeros(a,1) + strike;
            c2 = zeros(a,1) + dip;
            c3 = zeros(a,1) + rake;
        end
    else
        c1 = zeros(a,1) + strike;
        c2 = zeros(a,1) + dip;
        c3 = zeros(a,1) + rake;
    end
    c4 = zeros(a,1) + friction;
    [SHEAR,NORMAL,coulomb] = calc_coulomb(c1,c2,c3,c4,ss);
   
        
    if STRESS_TYPE == 1
        b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL strike dip rake];
    else
        b = [DC3D(:,1) DC3D(:,2) -DC3D(:,5) coulomb SHEAR NORMAL];
    end



%======全データをファイルに書き出す（テキスト形式）=========================
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
        header1 = ['Input file selected: ',INPUT_FILE];
        if STRESS_TYPE == 1
            header2 = 'x y z coulomb shear normal opt-oriented-strike dip rake';
            header3 = '(km) (km) (km) (bar) (bar) (bar) (degree) (degree) (degree)';
        else
            header2 = 'x y z coulomb shear normal';
            header3 = '(km) (km) (km) (bar) (bar) (bar)';
        end
        dlmwrite('dcff.cou',header1,'delimiter',''); 
        dlmwrite('dcff.cou',header2,'-append','delimiter',''); 
        dlmwrite('dcff.cou',header3,'-append','delimiter',''); 
        dlmwrite('dcff.cou',b,'-append','delimiter','\t','precision','%.6f');
        if DEPTH_RANGE_TYPE == 1
            fname2 = ['dcff_' num2str(int32(CALC_DEPTH_RANGE(kk))) 'km.cou'];
            copyfile('dcff.cou',fname2);
        end
    cd (HOME_DIR);
end
    h = findobj('Tag','slider_coul_sat');
    COLORSN = get(h,'Value');
    coulomb_open(get(h,'Value'),kk);


%======スリップラインの描画==================================================
    if FLAG_SLIP_LINE == 1 | FLAG_PR_AXES == 1
        slip_line_drawing;
    end

    % 断面ビューウィンドウが存在する場合の処理
    if IACTS ~= 1
    h = findobj('Tag','section_view_window');
    if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    	close(figure(H_SECTION))
        H_SECTION = [];
    end
    h = findobj('Tag','xsec_window');
    if (isempty(h)~=1 && isempty(H_SEC_WINDOW)~=1)
        close(figure(H_SEC_WINDOW))
        H_SEC_WINDOW = [];
    end
    end

end


%**************************************************************************
%	(ループ終了)
%**************************************************************************


% fault_overlay 関数の呼び出し
% 複数層計算後に単層モードに戻すためのリセット処理
if DEPTH_RANGE_TYPE ~= 0
    set(findobj('Tag','edit_coul_depth'),'Enable','on');
    set(findobj('Tag','Slip_line'),'Enable','on');
	CALC_DEPTH = temp_calc_depth;
    set(findobj('Tag','edit_coul_depth'),'String',num2str(CALC_DEPTH,'%6.1f'));
	DEPTH_RANGE_TYPE = 0; % 単層モードに切り替え
	IACT = 0;
end
fault_overlay;
if isempty(COAST_DATA)~=1 | isempty(EQ_DATA)~=1 |...
            isempty(AFAULT_DATA)~=1 | isempty(GPS_DATA)~=1
        hold on;
        overlay_drawing;
end
set(gcf,'Pointer','arrow'); set(H_MAIN,'Pointer','arrow'); set(H_COULOMB,'Pointer','arrow'); 

%----- 断面ビューウィンドウが存在する場合に更新処理を行う
h = findobj('Tag','section_view_window');
if (isempty(h)~=1 && isempty(H_SECTION)~=1)
    draw_dipped_cross_section;
    coulomb_section;
end
