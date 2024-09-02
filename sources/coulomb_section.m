function coulomb_section
% この関数は、クーロン応力変化の計算結果を断面図に表示するためのものです。

global H_MAIN H_SECTION
global STRESS_TYPE SHADE_TYPE
global DC3D CALC_DEPTH SHEAR NORMAL R_STRESS
global DC3DS
global FRIC
global IACT IACTS
global STRIKE DIP RAKE
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
global SEC_DOWNDIP_INC SEC_DIP
global NSEC NDEPTH AX AY AZ XGRID YGRID
global SEC_FLAG H_SECTION COORD
global COLORSN
global NUM ELEMENT
global PREF
global ANATOLIA
global FUNC_SWITCH
global C_SAT INPUT_FILE
global OUTFLAG PREF_DIR HOME_DIR CURRENT_VERSION
global EQ_DATA
global EQPICK_WIDTH

% 断面の距離を計算し、セクションと深度の分割数を決定
distance = sqrt((SEC_XF-SEC_XS)^2+(SEC_YF-SEC_YS)^2);
NSEC = int32(distance/SEC_INCRE)+1;
NDEPTH = int32(SEC_DEPTH/SEC_DEPTHINC)+1;

% x軸とy軸のデータを計算
x = [1:1:NSEC];
y = [1:1:abs(NDEPTH)];
xt = x;
yt = y;
x = double(x - 1.0) * SEC_INCRE;
ycal = (-1.0) * double(y - 1.0) * SEC_DEPTHINC;
y = (-1.0) * double(y - 1.0) * SEC_DOWNDIP_INC;
xmin = min(x);      % 断面x軸に沿った最小距離
xmax = max(x);      % 断面x軸に沿った最大距離
ymin = min(y);      % 深度軸に沿った最深位置（負）
ymax = max(y);      % 深度軸に沿った最浅位置（通常は0）
SEC_DEPTH = (-1.0) * SEC_DEPTH;

% マップ座標系でのx, y位置を計算
xx = SEC_XS + (SEC_XF-SEC_XS)/double(NSEC-1) * double(xt-1);
yy = SEC_YS + (SEC_YF-SEC_YS)/double(NSEC-1) * double(xt-1);

% 断面図のx, y軸のグリッドを計算
AX = zeros(NDEPTH,length(xt));
AY = zeros(NDEPTH,length(xt));
size(AX);
size(AY);
fc = zeros(4,2);
for m = 1:NDEPTH
    z = double(m) * SEC_DEPTHINC;
    for k = 1:length(xt)
        if k ~= length(xt)
        fc = fault_corners(xx(k),yy(k),xx(k+1),yy(k+1),SEC_DIP,0.0,z);
            AX(m,k) = fc(4,1);
            AY(m,k) = fc(4,2);
        else
        fc = fault_corners(xx(k-1),yy(k-1),xx(k),yy(k),SEC_DIP,0.0,z);
            AX(m,k) = fc(3,1);
            AY(m,k) = fc(3,2);     
        end
    end
end
 
% 深度に沿ったz軸のデータを計算
AZ = repmat(reshape(ycal,abs(NDEPTH),1),1,NSEC);
size(AX);
size(AY);
size(AZ);

% セクションフラグを設定
SEC_FLAG = 1;

% Okadaによる半空間モデルを計算
if IACTS ~= 1        
    Okada_halfspace;
end
IACTS = 1; % Okadaの出力を保持

% DC3DSから応力データを取得
a = length(DC3DS);
if a <= 14
    h = warndlg('Increase total grid number more than 14.','Warning!');
end
ss = zeros(6,a);
s9 = reshape(DC3DS(:,9),1,a);
s10 = reshape(DC3DS(:,10),1,a);
s11 = reshape(DC3DS(:,11),1,a);
s12 = reshape(DC3DS(:,12),1,a);
s13 = reshape(DC3DS(:,13),1,a);
s14 = reshape(DC3DS(:,14),1,a);
ss = [s9; s10; s11; s12; s13; s14];

% クーロン応力、せん断応力、法線応力の計算
if FUNC_SWITCH ~= 6 % 6: strain, Function>Strain
    SHEAR = zeros(a,1);
    NORMAL = zeros(a,1);
    coulomb = zeros(a,1);
    if FRIC == 0
        beta = 0.5 * (atan(1.0/0.0000001));
    else
        beta = 0.5 * (atan(1.0/FRIC));
    end

    % 最適に配向された断層面を求める-------------------------------------   
    [nzinc dum] = size(AZ);
    rss1 = zeros(a,1); rss2 = zeros(a,1); rss3 = zeros(a,1);
    rss4 = zeros(a,1); rss5 = zeros(a,1); rss6 = zeros(a,1); 
    top_az = (-1.0) * max(AZ(:,1));
    bottom_az = (-1.0) * min(AZ(:,1));
    incr_az = AZ(1,1) - AZ(2,1);
    for k = 1:nzinc
        calcd = top_az + (k-1) * incr_az;
        [rs] = regional_stress(R_STRESS,calcd);
        a0 = (k-1) * dum + 1;
        a1 = k * dum;
        rss1(a0:a1) = rss1(a0:a1) + rs(1,1);
        rss2(a0:a1) = rss2(a0:a1) + rs(2,1);
        rss3(a0:a1) = rss3(a0:a1) + rs(3,1);
        rss4(a0:a1) = rss4(a0:a1) + rs(4,1);
        rss5(a0:a1) = rss5(a0:a1) + rs(5,1);
        rss6(a0:a1) = rss6(a0:a1) + rs(6,1);
    end
        sgx  = zeros(a,1) + rss1 + reshape(ss(1,1:a),a,1);
        sgy  = zeros(a,1) + rss2 + reshape(ss(2,1:a),a,1);
        sgz  = zeros(a,1) + rss3 + reshape(ss(3,1:a),a,1);
        sgyz = zeros(a,1) + rss4 + reshape(ss(4,1:a),a,1);
        sgxz = zeros(a,1) + rss5 + reshape(ss(5,1:a),a,1);
        sgxy = zeros(a,1) + rss6 + reshape(ss(6,1:a),a,1);


    %===== Find sigma-1 and sigma-3 for plain stress condition =============
    
    % 平面応力条件下での最大・最小主応力の計算
    if STRESS_TYPE ~= 5
    phi = zeros(a,1) + 0.5 * atan((2.0 * sgxy)./(sgx - sgy)) + pi/2.0;
        ct = zeros(a,1) + cos(phi);
        st = zeros(a,1) + cos(phi);
    erad1 = sgx.*ct.*ct+sgy.*st+2.0.*sgx.*ct.*st;
        ct = zeros(a,1) + cos(phi+pi/2.0);
        st = zeros(a,1) + cos(phi+pi/2.0);
    erad2 = sgx.*ct.*ct+sgy.*st+2.0.*sgx.*ct.*st;
    nn = length(phi);
        for k = 1:nn
            if erad2(k) >= erad1(k)
                phi(k) = pi/2.0 - phi(k);
            end
        end   
    end


    %===== Find strike, dip, and rake for opt faults options =============

    % 最適な断層の走向、傾斜、滑り角を計算
    % 走向すべり（横ずれ）断層の場合-------------------------------------
    if STRESS_TYPE == 2
        strike  = zeros(a,1) + rad2deg(phi) - rad2deg(beta);
        strike2 = zeros(a,1) + rad2deg(phi) + rad2deg(beta);
        cg1 = strike < 0.0; cg2 = strike >= 0.0;
        strike = (180.0 + strike) .* cg1 + strike .* cg2;
        strike = round(strike);
        dip = 90.0;
        rake = 180.0;

    % 逆断層の場合-----------------------------------------------------
    elseif STRESS_TYPE == 3
        strike = zeros(a,1) + rad2deg(phi) + 90.0;
        if strike >= 360.0; strike = strike - 360.0; end;
        dip = abs(rad2deg(beta));
        rake = 90.0;

    % 正断層の場合-----------------------------------------------------       
    elseif STRESS_TYPE == 4
        strike = zeros(a,1) + rad2deg(phi);
        dip = abs(90.0-rad2deg(beta));
        rake = -90.0;
    
    % 指定した断層の場合-----------------------------------------------
    elseif STRESS_TYPE == 5
        strike = str2num(get(findobj('Tag','edit_spec_strike'),'String'));
        dip = str2num(get(findobj('Tag','edit_spec_dip'),'String'));
        rake = str2num(get(findobj('Tag','edit_spec_rake'),'String'));
    
    % その他の場合-----------------------------------------------------
    else
        h = warndlg('Under construction','!!Sorry!!');
        return
    end

    % 計算結果を他の関数に渡すための変数に格納
    STRIKE = strike;
    DIP = dip;
    RAKE = rake;

    % クーロン応力、せん断応力、法線応力を計算
    c1 = zeros(a,1) + double(STRIKE);
    c2 = zeros(a,1) + DIP;
    c3 = zeros(a,1) + RAKE;
    c4 = zeros(a,1) + FRIC;
    [SHEAR,NORMAL,coulomb] = calc_coulomb(c1,c2,c3,c4,ss); % クーロン応力の計算
    b = [DC3DS(:,1) DC3DS(:,2) -DC3DS(:,5) coulomb SHEAR NORMAL];
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z coulomb shear normal';
    header3 = '(km) (km) (km) (bar) (bar,right-lat.positive) (bar,unclamping.positive)';
    dlmwrite('dcff_section.cou',header1,'delimiter',''); 
    dlmwrite('dcff_section.cou',header2,'-append','delimiter',''); 
    dlmwrite('dcff_section.cou',header3,'-append','delimiter',''); 
    dlmwrite('dcff_section.cou',b,'-append','delimiter','\t','precision','%.6f');
    disp(['dcff_section.cou is saved in ' pwd]);
    fid = fopen('dcff_section.cou','r');
    coul = textscan(fid,'%f %f %f %f %f %f','headerlines',3);
    cd (HOME_DIR);

% FUNC_SWITCHが6の場合、膨張応力を計算
else
    dil = reshape((s9 + s10 + s11),a,1);                 % 膨張応力を計算
    b = [DC3DS(:,1) DC3DS(:,2) -DC3DS(:,5) dil dil dil]; % 最後の2つはダミー
    format long;
    if OUTFLAG == 1 | isempty(OUTFLAG) == 1
        cd output_files;
    else
        cd (PREF_DIR);
    end
    header1 = ['Input file selected: ',INPUT_FILE];
    header2 = 'x y z dilatation(ex+ey+ez) dilatation dilatation';
    header3 = '(km) (km) (km) (-) (-) (-)';
    dlmwrite('dilatation_section.cou',header1,'delimiter',''); 
    dlmwrite('dilatation_section.cou',header2,'-append','delimiter',''); 
    dlmwrite('dilatation_section.cou',header3,'-append','delimiter',''); 
    dlmwrite('dilatation_section.cou',b,'-append','delimiter','\t','precision','%.16f');
    disp(['dilatation_section.cou is saved in ' pwd]);
    fid = fopen('dilatation_section.cou','r');
    coul = textscan(fid,'%f %f %f %f %f %f','headerlines',3);
    cd (HOME_DIR);
end
fclose (fid);

% クーロン応力、せん断応力、法線応力の最小値・最大値・平均値を計算
cl = coul{4};
sigs = coul{5};
sign = coul{6};

cmin = min(cl);
cmax = max(cl);
cmean = mean(cl);

% クーロン応力行列を計算
switch FUNC_SWITCH
    case 6          % 膨張応力のプロットの場合
        cc = reshape(cl,abs(NDEPTH),NSEC);        
    case 7
        cc = reshape(sigs,abs(NDEPTH),NSEC);
    case 8
        cc = reshape(sign,abs(NDEPTH),NSEC);
    case 9
        cc = reshape(cl,abs(NDEPTH),NSEC);
    otherwise
end

% インターポレーションによるグリッド補間
if SHADE_TYPE == 2
    n_interp = 10.0;    % 補間のための細かいグリッド数
    nxg = NSEC; xgmin = xmin; xgmax = xmax;
    nyg = NDEPTH; ygmin = ymin; ygmax = ymax;
    xnew_inc = (xgmax - xgmin) / (double(nxg) * n_interp);
    ynew_inc = (ygmax - ygmin) / (double(nyg) * n_interp);
    new_xgrid = [xgmin:xnew_inc:xgmax];
    new_ygrid = rot90([ygmin:ynew_inc:ygmax]);

    new_xgrid_mtr = zeros(length(new_ygrid),length(new_xgrid)); % 初期化
    new_ygrid_mtr = zeros(length(new_ygrid),length(new_xgrid)); % 初期化
    cc_new = zeros(length(new_ygrid),length(new_xgrid));        % 初期化

    new_xgrid_mtr = repmat(new_xgrid,length(new_ygrid),1);
    new_ygrid_mtr = repmat(new_ygrid,1,length(new_xgrid));
    old_xgrid_mtr = repmat(x,NDEPTH,1);
    old_ygrid_mtr = repmat(flipud(rot90(y)),1,NSEC);

    % interp2関数を使用して補間を実行
    cc_new = interp2(old_xgrid_mtr,old_ygrid_mtr,fliplr(cc),new_xgrid_mtr,new_ygrid_mtr);
	cc_new = flipud(fliplr(cc_new));
end

% セクションビューウィンドウを設定
h = findobj('Tag','section_view_window');
if isempty(h)==1 | isempty(H_SECTION)==1
    H_SECTION = figure(section_view_window);
    set(H_SECTION,'Menubar','figure');
    set(H_SECTION,'Toolbar','figure');
else
    figure(H_SECTION);
    ax = get(H_SECTION,'Children');
    cla(ax,'reset');
end

% セクションビューにカラーマップとプロットを設定
set(H_SECTION,'Colormap',ANATOLIA);
hold on;
if SHADE_TYPE == 2
    switch PREF(7,1)
        case 1
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(jet);
        case 2
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(ANATOLIA);
        case 3
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(Gray);
        otherwise
            ac = image(cc_new,'CDataMapping','scaled','XData',[new_xgrid(1) new_xgrid(end)],...
                'YData',[new_ygrid(end) new_ygrid(1)]);colormap(jet);
    end
else
    switch PREF(7,1)
        case 1
    ac = image(cc,'CDataMapping','scaled','XData',[xmin xmax],'YData',...
    [ymax ymin]);colormap(jet);
        case 2
    ac = image(cc,'CDataMapping','scaled','XData',[xmin xmax],'YData',...
    [ymax ymin]);colormap(ANATOLIA);
        case 3
    ac = image(cc,'CDataMapping','scaled','XData',[xmin xmax],'YData',...
    [ymax ymin]);colormap(Gray);
        otherwise
    ac = image(cc,'CDataMapping','scaled','XData',[xmin xmax],'YData',...
    [ymax ymin]);colormap(jet);
    end
    set(gca,'YDir','normal');
end

% -----------------------------------断層ラインを描画-----------------------------------
for n = 1:NUM
    hold on;

    % 断層底が断面の底より浅い場合の処理
    dinc = SEC_DOWNDIP_INC/5.0;
    ninc = (ELEMENT(n,9)-ELEMENT(n,8))/dinc;
    
    fct = fault_corners(SEC_XS,SEC_YS,SEC_XF,SEC_YF,SEC_DIP,0.0,ELEMENT(n,8));
    [x1,y1,xa,ya] = fault_int_sec(fct(4,1),fct(4,2),...
        fct(3,1),fct(3,2),ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
    y1 = y1 / sin(deg2rad(SEC_DIP));
    ya = ya / sin(deg2rad(SEC_DIP));
     
    fcb = fault_corners(SEC_XS,SEC_YS,SEC_XF,SEC_YF,SEC_DIP,0.0,ELEMENT(n,9));
	[xb,yb,x2,y2] = fault_int_sec(fcb(4,1),fcb(4,2),...
        fcb(3,1),fcb(3,2),ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4)ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
    y2 = y2 / sin(deg2rad(SEC_DIP));
    yb = yb / sin(deg2rad(SEC_DIP)); 
  
    % 他のエッジポイントを見つける処理  
    if isempty(x1) == 1 && isempty(x2) ~= 1
        for k = 1:ninc
    fct = fault_corners(SEC_XS,SEC_YS,SEC_XF,SEC_YF,SEC_DIP,0.0,ELEMENT(n,8)+(k-1)*dinc);
    [x1,y1,xa,ya] = fault_int_sec(fct(4,1),fct(4,2),fct(3,1),fct(3,2),ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
    y1 = y1 / sin(deg2rad(SEC_DIP));
    ya = ya / sin(deg2rad(SEC_DIP));
    if isempty(x1) ~= 1; break; end;
        end
    end
    
    if isempty(x2) == 1 && isempty(x1) ~= 1
        for k = 1:ninc
    fcb = fault_corners(SEC_XS,SEC_YS,SEC_XF,SEC_YF,SEC_DIP,0.0,ELEMENT(n,9)-(k-1)*dinc);
	[xb,yb,x2,y2] = fault_int_sec(fcb(4,1),fcb(4,2),fcb(3,1),fcb(3,2),ELEMENT(n,1),ELEMENT(n,2),ELEMENT(n,3),ELEMENT(n,4),ELEMENT(n,7),ELEMENT(n,8),ELEMENT(n,9));
    y2 = y2 / sin(deg2rad(SEC_DIP));
    yb = yb / sin(deg2rad(SEC_DIP)); 
        if isempty(x2) ~= 1
            break;
        end
        end
    end

    fpt0 = plot([x1 x2],[y1 y2]);
    set(fpt0,'LineWidth',PREF(1,4),'Color',PREF(1,1:3)); 
end

%--------------------------断面上にマップビューラインを描画--------------------------
    hold on;
    z = -CALC_DEPTH / sin(deg2rad(SEC_DIP));
    fpt = plot([xmin xmax],[z z]);
        set(fpt,'LineWidth',0.2,'LineStyle','--','Color','b');


%--------------------------ラベルを描画--------------------------
hold on;
text(xmin+SEC_INCRE,ymax-SEC_DEPTHINC,'A','Color','k','FontSize',14,'FontWeight','bold');
text(xmax-SEC_INCRE*2.0,ymax-SEC_DEPTHINC,'B','Color','k','FontSize',14,'FontWeight','bold');

% タイトルを設定
hold on;
if FUNC_SWITCH == 6
    title('Dilatation (exx+eyy+ezz)','FontSize',18);    
elseif FUNC_SWITCH == 7
    title('Shear stress change (bar)','FontSize',18);
elseif FUNC_SWITCH == 8
    title('Normal stress change (bar)','FontSize',18);
else
	title('Coulomb stress change (bar)','FontSize',18);
end

% カラースケールの設定
% if FUNC_SWITCH ~= 6
if FUNC_SWITCH == 6 % ひずみ関数の場合
    C_SAT = abs(power(10,COLORSN));
else
    C_SAT = abs(COLORSN);
end

caxis([(-1.0)*C_SAT C_SAT]);
colorbar('location','EastOutside');
xlabel('Distance(km)','FontSize',14);
ylabel('Down-dip distance (km)','FontSize',14);
shading(gca,'interp');
axis image;
shading interp;

%=================== クロスセクショングリッドを描画 ===================
hold on;
a = plot([xmin xmax xmax xmin xmin],...
    [ymin ymin ymax ymax ymin]);
    set(gca,'DataAspectRatio',[1 1 1],...
    'Color',[0.9 0.9 0.9],...
    'PlotBoxAspectRatio',[1 1 1],...
    'XLim',[xmin,xmax],...
    'YLim',[ymin,ymax],...
    'TickDir','out');
set(a,'Color','k','LineWidth',1);

%=================== 地震データを断面にプロット ===================
if strcmp(get(findobj('Tag','menu_earthquakes'), 'Checked'),'on')
    % プロット幅の設定
    if isempty(EQPICK_WIDTH)
        EQPICK_WIDTH = 10.0; % (+- km)
    end
    
    %------ 地震データの形式 EQ_DATA format (17 columns) ---------------
    % 1)lon, 2)lat, 3)year, 4)month, 5)day, 6)M, 7)depth, 8)hr, 9)min,
    % 10)strike1, 11)dip1, 12)rake1, 13)strike2, 14)dip2, 15)rake2, 
    % 16) x position, 17) y position
    %------------------------------------------------------------------
        neq    = size(EQ_DATA,1);
        secpos = ones(neq,7,'double');
        secpos(:,1) = SEC_XS;
        secpos(:,2) = SEC_YS;
        secpos(:,3) = SEC_XF;
        secpos(:,4) = SEC_YF;
        secpos(:,5) =  0.0;     % top km
        secpos(:,6) = 200.0;    % bottom km
        secpos(:,7) =  90.0;    % dip (90 degree, vertical)
        [c1,c2,c3,c4] = coord_conversion(EQ_DATA(:,16),EQ_DATA(:,17),secpos(:,1),secpos(:,2),secpos(:,3),secpos(:,4),secpos(:,5),secpos(:,6),secpos(:,7));
        wcut = abs(c2) <= ones(neq,1,'double') .* (EQPICK_WIDTH/2.0);
        n = sum(rot90(sum(wcut)));
        c1a    = [(c1 + c3) .* wcut EQ_DATA(:,7)];
        c1flip = flipud(sortrows(c1a));
        c1sort = c1flip(1:n,:);
        hold on;
        h = scatter(c1sort(:,1),-c1sort(:,2),5*PREF(5,4),'MarkerEdgeColor',PREF(5,1:3));
        disp(' ');
        disp(['  Width to collect earthquakes is now ' num2str(EQPICK_WIDTH,'%5.1f') ' km.']); 
        disp(' ');
        disp('  To change the width, change the parameter ''EQPICK_WIDTH''(e.g., EQPICK_WIDTH=15.0)');
        disp('  Note that this earthquake plot function works only when the section is vertical.');
        disp(' ');
end

%----------- データとファイル名のスタンプ --------------
hold on;
x = xmax + (xmax-xmin)/10.0;
y = ymin - (ymax-ymin)/2.0;
lsp = (ymax-ymin)*10.0/100.0;

try
    dm1 = STRIKE(1); dm2 = DIP(1); dm3 = RAKE(1);
catch
    dm1 = 50.; dm2 = 90.; dm3 = 180.;
end

% パラメータを見るには、コマンドウィンドウで "help record_stamp" と入力してください。
record_stamp(H_SECTION,x,y,'SoftwareVersion',CURRENT_VERSION,...
        'FunctionType',FUNC_SWITCH,'Depth',CALC_DEPTH,...
        'StressType',STRESS_TYPE,'Friction',FRIC,...
        'FileName',INPUT_FILE,'LineSpace',lsp,'Strike',dm1,'Dip',dm2,'Rake',dm3,...
        'SectionStartX',SEC_XS,'SectionStartY',SEC_YS,...
        'SectionFinishX',SEC_XF,'SectionFinishY',SEC_YF,...
        'SectionDip',SEC_DIP,'SectionFlag',SEC_FLAG);

%---------- フラグのリセット
SEC_FLAG = 0;
set(H_SECTION,'PaperPositionMode','auto');
