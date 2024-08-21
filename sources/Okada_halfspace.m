function Okada_halfspace
% test displacement produced by Okada1992 subroutine
% 岡田1992年のサブルーチンによる変位のテスト

global INUM HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global GRID SIZE SECTION XGRID YGRID
global DC3D
global DC3DS
global SEC_FLAG
global NSEC NDEPTH AX AY AZ
global N_CELL
global XYCOORD NXINC NYINC
global FUNC_SWITCH
global IIRET
global DEPTH_RANGE_TYPE CALC_DEPTH_RANGE
persistent NCOUNT H_WAITBR

IIRET = 0;
alpha  =  1.0/(2.0*(1.0-POIS));
z = CALC_DEPTH * (-1.0);

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

% tic



xstart = GRID(1,1);
ystart = GRID(2,1);
xfinish = GRID(3,1);
yfinish = GRID(4,1);
xinc = GRID(5,1);
yinc = GRID(6,1);

if SEC_FLAG == 1        % cross section
    temp = zeros(1,2);
    temp(1) = NXINC; temp(2) = NYINC;
    NXINC = NSEC;
    NYINC = abs(NDEPTH);
else
%     NXINC = int32((xfinish-xstart)/xinc)+1;
%     NYINC = int32((yfinish-ystart)/yinc)+1;
    NXINC = length(XGRID);
    NYINC = length(YGRID);   % NXINC & NYINC are really needed???
end

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

s0 = zeros(6,n,'double');
s1 = zeros(6,n,'double');
XYCOORD = zeros(n,2,'double');

if SEC_FLAG == 1        % for cross section calc (to keep the result of mapview)
    aax = reshape(AX,n,1);
    aay = reshape(AY,n,1);
    DC3DS = zeros(n,14,'double');
    DC3DS0 = zeros(n,14,'double');
else                    % for mapview calc.
    DC3D = zeros(n,14,'double');
    DC3D0 = zeros(n,14,'double');
end


if DEPTH_RANGE_TYPE == 0
    h = waitbar(0,'Calculating deformation... please wait...');
% progressbar('start',10,'A progressbar demonstration','EstTimeLeft','on');
    ncount = 0; % for waitbar counter
    ntotal = NYINC * NXINC * int32(NUM);
else
    if CALC_DEPTH == CALC_DEPTH_RANGE(1)
        H_WAITBR = waitbar(0,'Calculating deformation... please wait...');
        NCOUNT = 0; % for waitbar counter
    end
    ntotal = NYINC * NXINC * int16(NUM) * length(CALC_DEPTH_RANGE);
end
        
for ii = 1:NUM
        depth = (ELEMENT(ii,8)+ELEMENT(ii,9))/2.0;  % depth should be positive
for k = 1:NXINC
    xx = xstart + double(k-1) * xinc;
    for m = 1:NYINC
        yy = ystart + double(m-1) * yinc;
        nn = m + (k - 1) * NYINC;
        if SEC_FLAG == 1
            XYCOORD(nn,1) = aax(nn,1);
            XYCOORD(nn,2) = aay(nn,1);
        else
            XYCOORD(nn,1) = xx;
            XYCOORD(nn,2) = yy;
        end
        if DEPTH_RANGE_TYPE == 0
            ncount = ncount + 1;
        else
            NCOUNT = NCOUNT + 1;
        end
%         fr = double(ncount)/double(ntotal);   % make it slow
%         waitbar(fr);
    end
        if DEPTH_RANGE_TYPE == 0
         fr = double(ncount)/double(ntotal);
        else
         fr = double(NCOUNT)/double(ntotal);
        end
         waitbar(fr);
end
%-        fr = double(ncount)/double(ntotal);
%-        waitbar(fr);
        if ii == NUM
            if DEPTH_RANGE_TYPE == 0
                waitbar(fr,h,'Now making image... please wait');
            end
        end
        
        [c1,c2,c3,c4] = coord_conversion(XYCOORD(:,1),XYCOORD(:,2),ELEMENT(ii,1),ELEMENT(ii,2),...
            ELEMENT(ii,3),ELEMENT(ii,4),ELEMENT(ii,8),ELEMENT(ii,9),ELEMENT(ii,7));   
        format long;
        aa = zeros(n,1,'double') + double(alpha);
        if SEC_FLAG == 1
            zz = zeros(n,1,'double') + reshape(double(AZ),n,1);
        else
            zz = zeros(n,1,'double') + double(z);
        end
        dp = zeros(n,1,'double') + double(depth);
        e7 = zeros(n,1,'double') + double(ELEMENT(ii,7));
        e5 = zeros(n,1,'double') - double(ELEMENT(ii,5));    % left-lat positive in Okada's code
        e6 = zeros(n,1,'double') + double(ELEMENT(ii,6));
        zr = zeros(n,1,'double');
        if KODE(ii) == 200
            e5 = zeros(n,1,'double') - double(ELEMENT(ii,5));
            e6 = zeros(n,1,'double');
            zr = zeros(n,1,'double') + double(ELEMENT(ii,6));    
        elseif KODE(ii) == 300
            e5 = zeros(n,1,'double');
            e6 = zeros(n,1,'double') + double(ELEMENT(ii,6));
            zr = zeros(n,1,'double') + double(ELEMENT(ii,5));   
        end
        x = zeros(n,1,'double') + double(c1);
        y = zeros(n,1,'double') + double(c2);
        al = zeros(n,1,'double') + double(c3);
        aw = zeros(n,1,'double') + double(c4);
%         % for point source calculation (unit: input m**3, output
%         % m**3/km**2 -> m => thus ./(1.0E+3)
        if KODE(ii) == 400
            aw = zeros(n,1,'double') - double(ELEMENT(ii,5));
            e5 = zeros(n,1,'double') + double(ELEMENT(ii,6));
            e6 = zeros(n,1,'double');
            zr = zeros(n,1,'double');    
        elseif KODE(ii) == 500
            aw = zeros(n,1,'double');
            e5 = zeros(n,1,'double');
            e6 = zeros(n,1,'double') + double(ELEMENT(ii,5));
            zr = zeros(n,1,'double') + double(ELEMENT(ii,6));   
        end

        a = [aa x y zz dp e7 al al aw aw e5 e6 zr];
        b = zeros(n,12,'double');
        
if (ELEMENT(ii,5)~=0.0 | ELEMENT(ii,6)~= 0.0 | ii == 1) %%%**********(to skip calc for zero slip)

if KODE(ii) == 100 | KODE(ii) == 200 | KODE(ii) == 300
%     Okada_DC3D(ALPHA,...
%                 X,Y,Z,DEPTH,DIP,...
%                 AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3)
[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
    a(:,4),a(:,5),a(:,6),...
    a(:,7),a(:,8),a(:,9),...
    a(:,10),a(:,11),a(:,12),a(:,13));
elseif KODE(ii) == 400 | KODE(ii) == 500
%     Okada_DC3D0(ALPHA,...
%                 X,Y,Z,DEPTH,DIP,POT1,POT2,POT3,POT4)
[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D0(a(:,1),a(:,2),a(:,3),...
    a(:,4),a(:,5),a(:,6),a(:,10),a(:,11),a(:,12),a(:,13));    
end
% to detect singular point
IIRET = IIRET + sum(IRET);

 % cell to matrices
    X = a(:,2);
    Y = a(:,3);
    Z = a(:,4);
    
%-- Displacement Conversion from Okada's field to Given field -------------
%    ELEMENT = double(ELEMENT);
    sw = sqrt((ELEMENT(ii,4)-ELEMENT(ii,2))^2+(ELEMENT(ii,3)-ELEMENT(ii,1))^2);
    sina = (ELEMENT(ii,4)-ELEMENT(ii,2))/double(sw);
    cosa = (ELEMENT(ii,3)-ELEMENT(ii,1))/double(sw);
    UXG = UX*cosa-UY*sina;
    UYG = UX*sina+UY*cosa;
    UZG = UZ;
% for point source calculation (unit: input m**3, output
% m**3/km**2 -> m => thus ./(1.0E+3)
    if KODE(ii) == 400 | KODE(ii) == 500
        UXG = UXG./1000.0;
        UYG = UYG./1000.0;
        UZG = UZG./1000.0;
    end

% C-- Strain to Stress for the normal component -----------------------------
% strain to stress
    sk = YOUNG/(1.0+POIS);
    gk = POIS/(1.0-2.0*POIS);
    vol = UXX + UYY + UZZ;
    if FUNC_SWITCH ~= 6         % converted to Stress
    % caution! strain dimension is from x,y,z coordinate (should be /1000)
    sxx = sk * (gk * vol + UXX) * 0.001;
    syy = sk * (gk * vol + UYY) * 0.001;
    szz = sk * (gk * vol + UZZ) * 0.001;
    sxy = (YOUNG/(2.0*(1.0+POIS))) * (UXY + UYX) * 0.001;
    sxz = (YOUNG/(2.0*(1.0+POIS))) * (UXZ + UZX) * 0.001;
    syz = (YOUNG/(2.0*(1.0+POIS))) * (UYZ + UZY) * 0.001;
    else                        % remain strain
    % caution! strain dimension is from x,y,z coordinate (should be /1000)
%     sxx = UXX * 0.001;
%     syy = UYY * 0.001;
%     szz = UZZ * 0.001;
%     sxy = UXY * 0.001;
%     sxz = UXZ * 0.001;
%     syz = UYZ * 0.001;
    sxx = UXX * 0.001;
    syy = UYY * 0.001;
    szz = UZZ * 0.001;
    sxy = (UXY+UYX)/2.0 * 0.001;
    sxz = (UXZ+UZX)/2.0 * 0.001;
    syz = (UYZ+UZY)/2.0 * 0.001;
    end
    ssxx = reshape(sxx,1,n);
    ssyy = reshape(syy,1,n);
    sszz = reshape(szz,1,n);
    ssxy = reshape(sxy,1,n);
    ssxz = reshape(sxz,1,n);
    ssyz = reshape(syz,1,n);
    
    s0 = [ssxx; ssyy; sszz; ssyz; ssxz; ssxy];
%-- Strain Conversion from Okada's field to Given field -------------
    s1 = tensor_trans(sina,cosa,s0,n);

    SXX = reshape(s1(1,:),n,1);
    SYY = reshape(s1(2,:),n,1);
    SZZ = reshape(s1(3,:),n,1);
    SYZ = reshape(s1(4,:),n,1);
    SXZ = reshape(s1(5,:),n,1);
    SXY = reshape(s1(6,:),n,1); 
 %   DC3D0 = [XX YY X Y Z UX UY UZ UXX UYX UZX UXY UYY UZY UXZ UYZ UZZ];
	if ii == 1
        if SEC_FLAG == 1
            DC3DS0 = horzcat(XYCOORD,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
        else
            DC3D0 = horzcat(XYCOORD,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
        end
    else
        if SEC_FLAG == 1
            DC3DS0 = horzcat(zeros(n,1),zeros(n,1),zeros(n,1),zeros(n,1),zeros(n,1),...
                    UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
        else
            DC3D0 = horzcat(zeros(n,1),zeros(n,1),zeros(n,1),zeros(n,1),zeros(n,1),...
                    UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
        end
    end
	if SEC_FLAG == 1
        DC3DS = DC3DS + DC3DS0;
    else
        DC3D = DC3D + DC3D0;
	end
end                                     %%%**********(to skip calc for zero slip)
end
% DC3D = double(DC3D);


if DEPTH_RANGE_TYPE == 0
        close(h);
else
    if CALC_DEPTH == CALC_DEPTH_RANGE(end)
        close(H_WAITBR);
    end
end

if IIRET > 0
    disp('Warning! At least one calculation node is on one of the singular points');
    disp('Shift all nodes very slightly to escape the point.');
    warndlg('A calc. point is on a fault! A node met a singular point!','!! Warning !!');
end

if SEC_FLAG == 1        % cross section
    NXINC = temp(1); NYINC = temp(2);   % return to the map matrix
end
    
% toc
