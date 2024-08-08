function Okada_halfspace_one
% half space calc. for one point
%

% disp('This is Okada_halfspace_one.m');

% clear all;
global INUM HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global GRID SIZE SECTION
global DC3D
% case for calculating one point instead of matrix
global FIXX FIXY FIXFLAG
% global     ssxx ssyy sszz ssxy ssxz ssyz sk gk vol


alpha  =  1.0/(2.0*(1.0-POIS));
z = CALC_DEPTH * (-1.0);


% depth = -10.0;
% dip = 50.0;
% al1 = 20.0;
% al2 = 20.0;
% aw1 = 10.0;
% aw2 = 10.0;
% disl1 = 0.0;
% disl2 = 3.0;
% disl3 = 0.0;

%       SUBROUTINE  DC3D(ALPHA,X,Y,Z,DEPTH,DIP,                           04610000
%      *              AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3,                  04620002
%      *              UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ,IRET)  04630002
%       IMPLICIT REAL*8 (A-H,O-Z)                                         04640000
%       REAL*4   ALPHA,X,Y,Z,DEPTH,DIP,AL1,AL2,AW1,AW2,DISL1,DISL2,DISL3, 04650000
%      *         UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ             04660000
% C                                                                       04670000
% C********************************************************************   04680000
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

n = 1;

s0 = zeros(6,n);
s1 = zeros(6,n);
DC3D = zeros(n,14);
DC3D0 = zeros(n,14);
xycoord = zeros(n,2);
% xx = zeros(n,1);
% yy = zeros(n,1);
% opposite sign convension for Okada's subroutine
%  left-lat is positive

%%%  ELEMENT(:,5) = (-1.0)*ELEMENT(:,5);
        
for ii = 1:NUM
        depth = (ELEMENT(ii,8)+ELEMENT(ii,9))/2.0;  % depth should be positive
        dlmwrite('Data.txt',n);
        xycoord(n,1) = FIXX;
        xycoord(n,2) = FIXY;
        [c1,c2,c3,c4] = coord_conversion(xycoord(:,1),xycoord(:,2),ELEMENT(ii,1),ELEMENT(ii,2),...
            ELEMENT(ii,3),ELEMENT(ii,4),ELEMENT(ii,8),ELEMENT(ii,9),ELEMENT(ii,7));   
        format long;
        aa = zeros(n,1) + alpha;
        zz = zeros(n,1) + z;
        dp = zeros(n,1) + depth;
        e7 = zeros(n,1) + ELEMENT(ii,7);
        e5 = zeros(n,1) - ELEMENT(ii,5);        % left-lat positive in Okada's code
        e6 = zeros(n,1) + ELEMENT(ii,6);
        zr = zeros(n,1);
        x = zeros(n,1) + c1;
        y = zeros(n,1) + c2;
        al = zeros(n,1) + c3;
        aw = zeros(n,1) + c4;

        a = [aa x y zz dp e7 al al aw aw e5 e6 zr];
        dlmwrite('Data.txt',a,'-append','precision','%.6f');
        
        unix('external/Okada1992.out');

        fid = fopen('Okada_out.dat','r');
        a = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
        fclose (fid);
        
        % we have to convert UX ... UZZ to the global coordinate
        % here
        
% cell to matrices
% if ii==1
    X = a{1};
    Y = a{2};
    Z = a{3};
    UX = a{4};
    UY = a{5};
    UZ = a{6};
    UXX = a{7};
    UYX = a{8};
    UZX = a{9};
    UXY = a{10};
    UYY = a{11};
    UZY = a{12};
    UXZ = a{13};
    UYZ = a{14};
    UZZ = a{15};
    
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

    s1 = tensor_trans(sina,s0,1);

    SXX = reshape(s1(1,:),n,1);
    SYY = reshape(s1(2,:),n,1);
    SZZ = reshape(s1(3,:),n,1);
    SYZ = reshape(s1(4,:),n,1);
    SXZ = reshape(s1(5,:),n,1);
    SXY = reshape(s1(6,:),n,1);
          
 %   DC3D0 = [XX YY X Y Z UX UY UZ UXX UYX UZX UXY UYY UZY UXZ UYZ UZZ];
 if ii == 1
    DC3D0 = horzcat(xycoord,X,Y,Z,UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
 else
    DC3D0 = horzcat(zeros(n,1),zeros(n,1),zeros(n,1),zeros(n,1),zeros(n,1),...
    UXG,UYG,UZG,SXX,SYY,SZZ,SYZ,SXZ,SXY);
 end
    DC3D = DC3D + DC3D0;
end


