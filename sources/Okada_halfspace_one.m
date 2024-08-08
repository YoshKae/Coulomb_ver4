function Okada_halfspace_one
% test displacement produced by Okada1992 subroutine
%

%disp('This is Okada_halfspace.m');

% clear all;
global INUM HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global GRID SIZE SECTION
global DC3D
global DC3DS
global SEC_FLAG
global nsec ndepth AX AY AZ
global N_CELL
global XYCOORD NXINC NYINC
global FIXX FIXY FIXFLAG

SEC_FLAG = 0;

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

%  tic

xstart  = GRID(1,1);
ystart  = GRID(2,1);
xfinish = GRID(3,1);
yfinish = GRID(4,1);
xinc    = GRID(5,1);
yinc    = GRID(6,1);

if SEC_FLAG == 1        % cross section
    NXINC = nsec;
    NYINC = abs(ndepth);
else
    NXINC = int16((xfinish-xstart)/xinc);
    NYINC = int16((yfinish-ystart)/yinc);
end

n = NXINC * NYINC;


n = 1;
N_CELL = n;

UX   = zeros(n,1);
UY   = zeros(n,1);
UZ   = zeros(n,1);
UXX  = zeros(n,1);
UYX  = zeros(n,1);
UZX  = zeros(n,1);
UXY  = zeros(n,1);
UYY  = zeros(n,1);
UZY  = zeros(n,1);
UXZ  = zeros(n,1);
UZZ  = zeros(n,1);
IRET = zeros(n,1);

s0   = zeros(6,n);
s1   = zeros(6,n);
XYCOORD = zeros(n,2);

if SEC_FLAG == 1        % for cross section calc (to keep the result of mapview)
    aax = reshape(AX,n,1);
    aay = reshape(AY,n,1);
    DC3DS = zeros(n,14);
    DC3DS0 = zeros(n,14);
else                    % for mapview calc.
    DC3D = zeros(n,14);
    DC3D0 = zeros(n,14);
end

% opposite sign convension for Okada's subroutine
%  left-lat is positive

%%%  ELEMENT(:,5) = (-1.0)*ELEMENT(:,5);

% h = waitbar(0,'Calculating deformation... please wait...');
% ncount = 0; % for waitbar counter
% ntotal = NYINC * NXINC * int16(NUM);
        
for ii = 1:NUM
        depth = (ELEMENT(ii,8)+ELEMENT(ii,9))/2.0;  % depth should be positive
%        dlmwrite('Data.txt',n);
        if SEC_FLAG == 1
            XYCOORD(n,1) = aax(n,1);
            XYCOORD(n,2) = aay(n,1);
        else
            XYCOORD(n,1) = FIXX;
            XYCOORD(n,2) = FIXY;
        end

        if ii == NUM
%        waitbar(fr,h,'Now making image... please wait');
        end
       
        [c1,c2,c3,c4] = coord_conversion(XYCOORD(:,1),XYCOORD(:,2),ELEMENT(ii,1),ELEMENT(ii,2),...
            ELEMENT(ii,3),ELEMENT(ii,4),ELEMENT(ii,8),ELEMENT(ii,9),ELEMENT(ii,7));  
        format long;
        aa = zeros(n,1) + alpha;
        if SEC_FLAG == 1
            zz = zeros(n,1) + reshape(AZ,n,1);
        else
            zz = zeros(n,1) + z;
        end
        dp = zeros(n,1) + depth;
        e7 = zeros(n,1) + ELEMENT(ii,7);
        e5 = zeros(n,1) - ELEMENT(ii,5);        % left-lat positive in Okada's code
        e6 = zeros(n,1) + ELEMENT(ii,6);
        zr = zeros(n,1);
        if KODE(ii) == 200
            e5 = zeros(n,1,'double') + double(ELEMENT(ii,5));
            e6 = zeros(n,1,'double');
            zr = zeros(n,1,'double') + double(ELEMENT(ii,6));    
        elseif KODE(ii) == 300
            e5 = zeros(n,1,'double');
            e6 = zeros(n,1,'double') + double(ELEMENT(ii,6));
            zr = zeros(n,1,'double') + double(ELEMENT(ii,5));   
        end
        x = zeros(n,1) + double(c1);
        y = zeros(n,1) + double(c2);
        al = zeros(n,1) + double(c3);
        aw = zeros(n,1) + double(c4);
%         if KODE(ii) == 400
%             aw = zeros(n,1,'double') - double(ELEMENT(ii,5))./(1.0E+7);
%             e5 = zeros(n,1,'double') + double(ELEMENT(ii,6))./(1.0E+7);
%             e6 = zeros(n,1,'double');
%             zr = zeros(n,1,'double');    
%         elseif KODE(ii) == 500
%             aw = zeros(n,1,'double');
%             e5 = zeros(n,1,'double');
%             e6 = zeros(n,1,'double') + double(ELEMENT(ii,5))./(1.0E+7);
%             zr = zeros(n,1,'double') + double(ELEMENT(ii,6))./(1.0E+7);   
%         end
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
        b = zeros(n,12);
        
if ((ELEMENT(ii,5)~=0.0) | (ELEMENT(ii,6)~= 0.0))  %%%**********(to skip calc for zero slip)
    
if KODE(ii) == 100 | KODE(ii) == 200 | KODE(ii) == 300
    
[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D(a(:,1),a(:,2),a(:,3),...
    a(:,4),a(:,5),a(:,6),...
    a(:,7),a(:,8),a(:,9),...
    a(:,10),a(:,11),a(:,12),a(:,13));

elseif KODE(ii) == 400 | KODE(ii) == 500

[UX(:,1),UY(:,1),UZ(:,1),UXX(:,1),UYX(:,1),UZX(:,1),UXY(:,1),UYY(:,1),UZY(:,1),...
    UXZ(:,1),UYZ(:,1),UZZ(:,1),IRET(:,1)]=Okada_DC3D0(a(:,1),a(:,2),a(:,3),...
    a(:,4),a(:,5),a(:,6),a(:,10),a(:,11),a(:,12),a(:,13));

end

% cell to matrices
    X = a(:,2);
    Y = a(:,3);
    Z = a(:,4);
    
%-- Displacement Conversion from Okada's field to Given field -------------
    sw = sqrt((ELEMENT(ii,4)-ELEMENT(ii,2))^2+(ELEMENT(ii,3)-ELEMENT(ii,1))^2);
%     ang = atan((ELEMENT(ii,4)-ELEMENT(ii,2))/(ELEMENT(ii,3)-ELEMENT(ii,1)));
    sina = (ELEMENT(ii,4)-ELEMENT(ii,2))/sw;
    cosa = (ELEMENT(ii,3)-ELEMENT(ii,1))/sw;
%     UXG = UX*cos(ang)-UY*sin(ang);
%     UYG = UX*sin(ang)+UY*cos(ang);
    UXG = UX*cosa-UY*sina;
    UYG = UX*sina+UY*cosa;
    UZG = UZ;
    if KODE(ii) == 400 | KODE(ii) == 500
        UXG = UXG./1000.0;
        UYG = UYG./1000.0;
        UZG = UZG./1000.0;
    end
%       UXDS=UXBDS*COSB-UYBDS*SINB
%       UXDN=UXBDN*COSB-UYBDN*SINB
%       UYDS=UXBDS*SINB+UYBDS*COSB
%       UYDN=UXBDN*SINB+UYBDN*COSB
%       UZDS=UZBDS
%       UZDN=UZBDN

%--- strain field also need to conver to Given field
%-------------------------
% C-- Strain to Stress for the normal component -----------------------------
% c		SK  = E1/(1.0+PR1)
% c		GK  = PR1/(1.0-2.0*PR1)
% 		VOL = (UXX+UYY+UZZ)
% 	SXXBDN = SK * (GK * VOL + UXX)
% 	SYYBDN = SK * (GK * VOL + UYY)
% 	SZZBDN = SK * (GK * VOL + UZZ)
%       SXYBDN = (E1/(2.0*(1.0+PR1))) * (UXY+UYX) 
%       SXZBDN = (E1/(2.0*(1.0+PR1))) * (UXZ+UZX) 
%       SYZBDN = (E1/(2.0*(1.0+PR1))) * (UYZ+UZY) 

% strain to stress
    sk = YOUNG/(1.0+POIS);
    gk = POIS/(1.0-2.0*POIS);
    vol = UXX + UYY + UZZ;
    % caution! strain dimension is from x,y,z coordinate (should be /1000)
    sxx = sk * (gk * vol + UXX) * 0.001;
    syy = sk * (gk * vol + UYY) * 0.001;
    szz = sk * (gk * vol + UZZ) * 0.001;
    sxy = (YOUNG/(2.0*(1.0+POIS))) * (UXY + UYX) * 0.001;
    sxz = (YOUNG/(2.0*(1.0+POIS))) * (UXZ + UZX) * 0.001;
    syz = (YOUNG/(2.0*(1.0+POIS))) * (UYZ + UZY) * 0.001;
    ssxx = reshape(sxx,1,n);
    ssyy = reshape(syy,1,n);
    sszz = reshape(szz,1,n);
    ssxy = reshape(sxy,1,n);
    ssxz = reshape(sxz,1,n);
    ssyz = reshape(syz,1,n);
    
    s0 = [ssxx; ssyy; sszz; ssyz; ssxz; ssxy];
%     for mm = 1:ngrid
%         s1(1:6,mm) = tensor_trans(sina,s0(1:6,mm),1);
%     end

    s1 = tensor_trans(sina,cosa,s0,1);

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
% close(h);

% toc
