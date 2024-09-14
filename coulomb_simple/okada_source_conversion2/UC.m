function [U] = UC(XI,ET,Q,Z,DISL1,DISL2,DISL3)
%
%      DIMENSION U(12),DU(12)                                            08250000
% C                                                                       08260000
% C********************************************************************   08270000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH (PART-C)             *****   08280000
% C*****    DUE TO BURIED FINITE FAULT IN A SEMIINFINITE MEDIUM   *****   08290000
% C********************************************************************   08300000
% C                                                                       08310000
% C***** INPUT                                                            08320000
% C*****   XI,ET,Q,Z   : STATION COORDINATES IN FAULT SYSTEM              08330000
% C*****   DISL1-DISL3 : STRIKE-, DIP-, TENSILE-DISLOCATIONS              08340000
% C***** OUTPUT                                                           08350000
% C*****   U(12) : DISPLACEMENT AND THEIR DERIVATIVES                     08360000
% C                                                                       08370000
%       COMMON /C0/ALP1,ALP2,ALP3,ALP4,ALP5,SD,CD,SDSD,CDCD,SDCD,S2D,C2D  08380000
%       COMMON /C2/XI2,ET2,Q2,R,R2,R3,R5,Y,D,TT,ALX,ALE,X11,Y11,X32,Y32,  08390000
%      *           EY,EZ,FY,FZ,GY,GZ,HY,HZ                                08400000
     
global ALP1 ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global XI2 ET2 Q2 R R2 R3 R5 Y D TT ALX ALE X11 Y11 X32 Y32
global EY EZ FY FZ GY GZ HY HZ
global N_CELL

%      DATA F0,F1,F2,F3,PI2/0.D0,1.D0,2.D0,3.D0,6.283185307179586D0/     08410000
%F0 = double(0.0);
F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
F3 = ones(N_CELL,1,'double').*3.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;

DU = zeros(N_CELL,12,'double');

%C-----                                                                  08420000
      C=D+Z;                                                             %08430000
      X53=(double(8.0).*R2+double(9.0).*R.*XI+F3.*XI2).*X11.*X11.*X11./R2;
      Y53=(double(8.0).*R2+double(9.0).*R.*ET+F3.*ET2).*Y11.*Y11.*Y11./R2;
      H=Q.*CD-Z;
      Z32=SD./R3-H.*Y32;
      Z53=F3.*SD./R5-H.*Y53;
      Y0=Y11-XI2.*Y32;
      Z0=Z32-XI2.*Z53;
      PPY=CD./R3+Q.*Y32.*SD;
      PPZ=SD./R3-Q.*Y32.*CD;
      QQ=Z.*Y32+Z32+Z0;
      QQY=F3.*C.*D./R5-QQ.*SD;
      QQZ=F3.*C.*Y./R5-QQ.*CD+Q.*Y32;
      XY=XI.*Y11;
      QX=Q.*X11;
      QY=Q.*Y11;
      QR=F3.*Q./R5;
      CQX=C.*Q.*X53;
      CDR=(C+D)./R3;
      YY0=Y./R3-Y0.*CD;
%C=====
%    for I=1:1:12
        U(1:N_CELL,1:12)=0.0;
%    end
% C======================================                                 08660000
% C=====  STRIKE-SLIP CONTRIBUTION  =====                                 08670000
% C======================================                                 08680000
%      if DISL1~=F0
           c1 = DISL1 ~= F0;
        DU(:,1)= ALP4.*XY.*CD           -ALP5.*XI.*Q.*Z32;
        DU(:,2)= ALP4.*(CD./R+F2.*QY.*SD) -ALP5.*C.*Q./R3;
        DU(:,3)= ALP4.*QY.*CD           -ALP5.*(C.*ET./R3-Z.*Y11+XI2.*Z32);
        DU(:,4)= ALP4.*Y0.*CD                  -ALP5.*Q.*Z0;
        DU(:,5)=-ALP4.*XI.*(CD./R3+F2.*Q.*Y32.*SD) +ALP5.*C.*XI.*QR;
        DU(:,6)=-ALP4.*XI.*Q.*Y32.*CD            +ALP5.*XI.*(F3.*C.*ET./R5-QQ);
        DU(:,7)=-ALP4.*XI.*PPY.*CD    -ALP5.*XI.*QQY;
        DU(:,8)= ALP4.*F2.*(D./R3-Y0.*SD).*SD-Y./R3.*CD...
                -ALP5.*(CDR.*SD-ET./R3-C.*Y.*QR);
        DU(:,9)=-ALP4.*Q./R3+YY0.*SD  +ALP5.*(CDR.*CD+C.*D.*QR-(Y0.*CD+Q.*Z0).*SD);
        DU(:,10)= ALP4.*XI.*PPZ.*CD    -ALP5.*XI.*QQZ;
        DU(:,11)= ALP4.*F2.*(Y./R3-Y0.*CD).*SD+D./R3.*CD -ALP5.*(CDR.*CD+C.*D.*QR);
        DU(:,12)=         YY0.*CD    -ALP5.*(CDR.*SD-C.*Y.*QR-Y0.*SDSD+Q.*Z0.*CD);
 %       for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL1./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c1,1,12);
 %       end
 %     end
% C======================================                                 08860000
% C=====    DIP-SLIP CONTRIBUTION   =====                                 08870000
% C======================================                                 08880000
%      if DISL2~=F0
           c2 = DISL2 ~= F0;
        DU(:,1)= ALP4.*CD./R -QY.*SD -ALP5.*C.*Q./R3;
        DU(:,2)= ALP4.*Y.*X11       -ALP5.*C.*ET.*Q.*X32;
        DU(:,3)=     -D.*X11-XY.*SD -ALP5.*C.*(X11-Q2.*X32);
        DU(:,4)=-ALP4.*XI./R3.*CD +ALP5.*C.*XI.*QR +XI.*Q.*Y32.*SD;
        DU(:,5)=-ALP4.*Y./R3     +ALP5.*C.*ET.*QR;
        DU(:,6)=    D./R3-Y0.*SD +ALP5.*C./R3.*(F1-F3.*Q2./R2);
        DU(:,7)=-ALP4.*ET./R3+Y0.*SDSD -ALP5.*(CDR.*SD-C.*Y.*QR);
        DU(:,8)= ALP4.*(X11-Y.*Y.*X32) -ALP5.*C.*((D+F2.*Q.*CD).*X32-Y.*ET.*Q.*X53);
        DU(:,9)=  XI.*PPY.*SD+Y.*D.*X32 +ALP5.*C.*((Y+F2.*Q.*SD).*X32-Y.*Q2.*X53);
        DU(:,10)=      -Q./R3+Y0.*SDCD -ALP5.*(CDR.*CD+C.*D.*QR);
        DU(:,11)= ALP4.*Y.*D.*X32       -ALP5.*C.*((Y-F2.*Q.*SD).*X32+D.*ET.*Q.*X53);
        DU(:,12)=-XI.*PPZ.*SD+X11-D.*D.*X32-ALP5.*C.*((D-F2.*Q.*CD).*X32-D.*Q2.*X53);
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL2./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c2,1,12);
%        end
 %     end
% C========================================                               09050000
% C=====  TENSILE-FAULT CONTRIBUTION  =====                               09060000
% C========================================                               09070000
%      if DISL3~=F0
          c3 = DISL3 ~= F0;
        DU(:,1)=-ALP4.*(SD./R+QY.*CD)   -ALP5.*(Z.*Y11-Q2.*Z32);
        DU(:,2)= ALP4.*F2.*XY.*SD+D.*X11 -ALP5.*C.*(X11-Q2.*X32);
        DU(:,3)= ALP4.*(Y.*X11+XY.*CD)  +ALP5.*Q.*(C.*ET.*X32+XI.*Z32);
        DU(:,4)= ALP4.*XI./R3.*SD+XI.*Q.*Y32.*CD+ALP5.*XI.*(F3.*C.*ET./R5-F2.*Z32-Z0);
        DU(:,5)= ALP4.*F2.*Y0.*SD-D./R3 +ALP5.*C./R3.*(F1-F3.*Q2./R2);
        DU(:,6)=-ALP4.*YY0           -ALP5.*(C.*ET.*QR-Q.*Z0);
        DU(:,7)= ALP4.*(Q./R3+Y0.*SDCD)   +ALP5.*(Z./R3.*CD+C.*D.*QR-Q.*Z0.*SD);
        DU(:,8)=-ALP4.*F2.*XI.*PPY.*SD-Y.*D.*X32...
                +ALP5.*C.*((Y+F2.*Q.*SD).*X32-Y.*Q2.*X53);
        DU(:,9)=-ALP4.*(XI.*PPY.*CD-X11+Y.*Y.*X32)...
                +ALP5.*(C.*((D+F2.*Q.*CD).*X32-Y.*ET.*Q.*X53)+XI.*QQY);
        DU(:,10)=  -ET./R3+Y0.*CDCD -ALP5.*(Z./R3.*SD-C.*Y.*QR-Y0.*SDSD+Q.*Z0.*CD);
        DU(:,11)= ALP4.*F2.*XI.*PPZ.*SD-X11+D.*D.*X32...
                -ALP5.*C.*((D-F2.*Q.*CD).*X32-D.*Q2.*X53);
        DU(:,12)= ALP4.*(XI.*PPZ.*CD+Y.*D.*X32)...
                +ALP5.*(C.*((Y-F2.*Q.*SD).*X32+D.*ET.*Q.*X53)+XI.*QQZ);
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL3./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c3,1,12);
%        end
%      end
%       RETURN                                                            09280000
%       END                                                               09290000
