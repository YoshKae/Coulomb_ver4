function Okada_halfspace()
    % Okada_halfspace: 岡田1992年のサブルーチンを使用して変位の計算を行う
    % グローバル変数を使用して、変位の計算と表示を行う

    % グローバル変数の宣言
    global INPUT_VARS
    global COORD_VARS
    global OKADA_OUTPUT
    global SECTION_VARS
    global N_CELL XYCOORD NXINC NYINC
    global CALC_CONTROL
    global NSEC NDEPTH AX AY AZ
    global CALC_DEPTH_RANGE
    persistent H_WAITBR

    % 岡田モデルのパラメータ初期化
    CALC_CONTROL.IIRET = 0;
    alpha = 1.0 / (2.0 * (1.0 - INPUT_VARS.POIS));
    z = INPUT_VARS.CALC_DEPTH * (-1.0);

    % グリッド情報の設定
    xstart = INPUT_VARS.GRID(1,1);
    ystart = INPUT_VARS.GRID(2,1);
    xfinish = INPUT_VARS.GRID(3,1);
    yfinish = INPUT_VARS.GRID(4,1);
    xinc = INPUT_VARS.GRID(5,1);
    yinc = INPUT_VARS.GRID(6,1);

    if SECTION_VARS.SEC_FLAG == 1  % 断面計算の場合
        temp = zeros(1,2);
        temp(1) = NXINC;
        temp(2) = NYINC;
        NXINC = NSEC;
        NYINC = abs(NDEPTH);
    else  % マップビュー計算の場合
        NXINC = length(COORD_VARS.XGRID);
        NYINC = length(COORD_VARS.YGRID);
    end

    % 計算用変数の初期化
    n = NXINC * NYINC;
    N_CELL = n;
    UX = zeros(n,1,'double');
    UY = zeros(n,1,'double');
    UZ = zeros(n,1,'double');
    UXX = zeros(n,1,'double');
    UYX = zeros(n,1,'double');
    UZX = zeros(n,1,'double');
    UXY = zeros(n,1,'double');
    UYY = zeros(n,1,'double');
    UZY = zeros(n,1,'double');
    UXZ = zeros(n,1,'double');
    UYZ = zeros(n,1,'double');
    UZZ = zeros(n,1,'double');
    IRET = zeros(n,1);

    s0 = zeros(6, n, 'double');
    s1 = zeros(6, n, 'double');
    XYCOORD = zeros(n, 2, 'double');

    if SECTION_VARS.SEC_FLAG == 1
        aax = reshape(AX, n, 1);
        aay = reshape(AY, n, 1);
        OKADA_OUTPUT.DC3DS = zeros(n, 14, 'double');
        OKADA_OUTPUT.DC3DS0 = zeros(n, 14, 'double');
    else
        OKADA_OUTPUT.DC3D = zeros(n, 14, 'double');
        OKADA_OUTPUT.DC3D0 = zeros(n, 14, 'double');
    end

    % 変位の計算
    if CALC_CONTROL.DEPTH_RANGE_TYPE == 0
        h = waitbar(0, 'Calculating deformation... please wait...');
        ncount = 0;
        ntotal = NYINC * NXINC * int32(INPUT_VARS.NUM);
    else
        if INPUT_VARS.CALC_DEPTH == CALC_DEPTH_RANGE(1)
            H_WAITBR = waitbar(0, 'Calculating deformation... please wait...');
            NCOUNT = 0;
        end
        ntotal = NYINC * NXINC * int16(INPUT_VARS.NUM) * length(CALC_DEPTH_RANGE);
    end

    % 各要素について計算
    for ii = 1:INPUT_VARS.NUM
        depth = (INPUT_VARS.ELEMENT(ii,8) + INPUT_VARS.ELEMENT(ii,9)) / 2.0;

        for k = 1:NXINC
            xx = xstart + double(k-1) * xinc;
            for m = 1:NYINC
                yy = ystart + double(m-1) * yinc;
                nn = m + (k - 1) * NYINC;

                if SECTION_VARS.SEC_FLAG == 1
                    XYCOORD(nn,1) = aax(nn,1);
                    XYCOORD(nn,2) = aay(nn,1);
                else
                    XYCOORD(nn,1) = xx;
                    XYCOORD(nn,2) = yy;
                end
            end
        end

        [c1, c2, c3, c4] = coord_conversion(XYCOORD(:,1), XYCOORD(:,2), INPUT_VARS.ELEMENT(ii,1), INPUT_VARS.ELEMENT(ii,2), ...
            INPUT_VARS.ELEMENT(ii,3), INPUT_VARS.ELEMENT(ii,4), INPUT_VARS.ELEMENT(ii,8), INPUT_VARS.ELEMENT(ii,9), INPUT_VARS.ELEMENT(ii,7));
        
        % 岡田モデルの計算パラメータ
        aa = zeros(n, 1, 'double') + double(alpha);
        if SECTION_VARS.SEC_FLAG == 1
            zz = zeros(n, 1, 'double') + reshape(double(AZ), n, 1);
        else
            zz = zeros(n, 1, 'double') + double(z);
        end

        dp = zeros(n, 1, 'double') + double(depth);
        e7 = zeros(n, 1, 'double') + double(INPUT_VARS.ELEMENT(ii,7));
        e5 = zeros(n, 1, 'double') - double(INPUT_VARS.ELEMENT(ii,5));
        e6 = zeros(n, 1, 'double') + double(INPUT_VARS.ELEMENT(ii,6));
        zr = zeros(n, 1, 'double');

        % 岡田サブルーチンの実行
        if (INPUT_VARS.ELEMENT(ii,5) ~= 0.0 || INPUT_VARS.ELEMENT(ii,6) ~= 0.0 || ii == 1)
            if INPUT_VARS.KODE(ii) == 100 || INPUT_VARS.KODE(ii) == 200 || INPUT_VARS.KODE(ii) == 300
                [UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
                    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
                        a(:,4),a(:,5),a(:,6),a(:,7),a(:,8),a(:,9),a(:,10),a(:,11),a(:,12),a(:,13));
            end
        end
    end

    % 終了処理
    if CALC_CONTROL.DEPTH_RANGE_TYPE == 0
        close(h);
    else
        if INPUT_VARS.CALC_DEPTH == CALC_DEPTH_RANGE(end)
            close(H_WAITBR);
        end
    end

    % 計算が正常終了していない場合の警告
    if CALC_CONTROL.IIRET > 0
        disp('Warning! A calculation node is on a singular point.');
        warndlg('A calc. point is on a fault! A node met a singular point!', '!! Warning !!');
    end

    if SECTION_VARS.SEC_FLAG == 1
        NXINC = temp(1);
        NYINC = temp(2);
    end
end

%       SUBROUTINE  DC3D(ALPHA,X,Y,Z,DEPTH,DIP,                           04610000
%      *              AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3,                  04620002
%      *              UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ,IRET)  04630002
%       IMPLICIT REAL*8 (A-H,O-Z)                                         04640000
%       REAL*4   ALPHA,X,Y,Z,DEPTH,DIP,AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3, 04650000
%      *         UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ             04660000
% C                                                                       04670000
% C********************************************************************
% 04680000
% C*****                                                          *****   04690000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH                      *****   04700000
% C*****    DUE TO BURIED FINITE FAULT IN A SEMIINFINITE MEDIUM   *****   04710000
% C*****                         CODED BY  Y.OKADA ... SEP 1991   *****   04720002
% C*****                         REVISED   Y.OKADA ... NOV 1991   *****   04730002
% C*****                                                          *****   04740000
% C********************************************************************   04750000
% C                                                                       04760000
% C***** INPUT                                                            04770000
% C*****   ALPHA : MEDIUM CONSTANT  (LAMBDA+MYU)/(LAMBDA+2*MYU)           04780000
% C*****   X,Y,Z : COORDINATE OF OBSERVING POINT                          04790000
% C*****   DEPTH : SOURCE DEPTH                                           04800000
% C*****   DIP   : DIP-ANGLE (DEGREE)                                     04810000
% C*****   AL1,AL2   : FAULT LENGTH (-STRIKE,+STRIKE)                     04820000
% C*****   AW1,AW2   : FAULT WIDTH  ( DOWNDIP, UPDIP)                     04830000
% C*****   DISL1-DISL3 : STRIKE-, DIP-, TENSILE-DISLOCATIONS              04840000
% C                                                                       04850000
% C***** OUTPUT                                                           04860000
% C*****   UX, UY, UZ  : DISPLACEMENT ( UNIT=(UNIT OF DISL)               04870000
% C*****   UXX,UYX,UZX : X-DERIVATIVE ( UNIT=(UNIT OF DISL) /             04880000
% C*****   UXY,UYY,UZY : Y-DERIVATIVE        (UNIT OF X,Y,Z,DEPTH,AL,AW) )04890000
% C*****   UXZ,UYZ,UZZ : Z-DERIVATIVE                                     04900000
% C*****   IRET        : RETURN CODE  ( =0....NORMAL,   =1....SINGULAR )  04910002
