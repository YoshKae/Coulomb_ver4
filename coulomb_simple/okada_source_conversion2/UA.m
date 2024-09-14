function [U] = UA(XI,ET,Q,DISL1,DISL2,DISL3)
%   DIMENSION U(12),DU(12)                                            06230000
% C                                                                       06240000
% C********************************************************************   06250000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH (PART-A)             *****   06260000
% C*****    DUE TO BURIED FINITE FAULT IN A SEMIINFINITE MEDIUM   *****   06270000
% C********************************************************************   06280000
% C                                                                       06290000
% C***** INPUT                                                            06300000
% C*****   XI,ET,Q : STATION COORDINATES IN FAULT SYSTEM                  06310000
% C*****   DISL1-DISL3 : STRIKE-, DIP-, TENSILE-DISLOCATIONS              06320000
% C***** OUTPUT                                                           06330000
% C*****   U(12) : DISPLACEMENT AND THEIR DERIVATIVES                     06340000
% C                                                                       06350000
%       COMMON /C0/ALP1,ALP2,ALP3,ALP4,ALP5,SD,CD,SDSD,CDCD,SDCD,S2D,C2D  06360000
%       COMMON /C2/XI2,ET2,Q2,R,R2,R3,R5,Y,D,TT,ALX,ALE,X11,Y11,X32,Y32,  06370000
%      *           EY,EZ,FY,FZ,GY,GZ,HY,HZ                                06380000
     
global ALP1 ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global XI2 ET2 Q2 R R2 R3 R5 Y D TT ALX ALE X11 Y11 X32 Y32
global EY EZ FY FZ GY GZ HY HZ
global N_CELL

%       DATA F0,F2,PI2/0.D0,2.D0,6.283185307179586D0/                     06390000
F0 = zeros(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;

DU = zeros(N_CELL,12,'double');
du1 = zeros(N_CELL,12,'double');
du2 = zeros(N_CELL,12,'double');
du3 = zeros(N_CELL,12,'double');

%C----- 
%for I=1:1:12
    U(1:N_CELL,1:12)=0.0;
%end
      XY=XI.*Y11;
      QX=Q .*X11;
      QY=Q .*Y11;
% C======================================                                 06460000
% C=====  STRIKE-SLIP CONTRIBUTION  =====                                 06470000
% C======================================                                 06480000
%      if DISL1~=F0
    c1 = DISL1 ~= F0;
        du1(:,1)=    TT./F2 +ALP2.*XI.*QY;
        du1(:,2)=           ALP2.*Q./R;
        du1(:,3)= ALP1.*ALE -ALP2.*Q.*QY;
        du1(:,4)=-ALP1.*QY  -ALP2.*XI2.*Q.*Y32;
        du1(:,5)=          -ALP2.*XI.*Q./R3;
        du1(:,6)= ALP1.*XY  +ALP2.*XI.*Q2.*Y32;
        du1(:,7)= ALP1.*XY.*SD        +ALP2.*XI.*FY+D./F2.*X11;
        du1(:,8)=                    ALP2.*EY;
        du1(:,9)= ALP1.*(CD./R+QY.*SD) -ALP2.*Q.*FY;
        du1(:,10)= ALP1.*XY.*CD        +ALP2.*XI.*FZ+Y./F2.*X11;
        du1(:,11)=                    ALP2.*EZ;
        du1(:,12)=-ALP1.*(SD./R-QY.*CD) -ALP2.*Q.*FZ;
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL1./PI2,1,12).*du1(1:N_CELL,1:12)...
                .*repmat(c1,1,12);
%        end
%      end
% C======================================                                 06650000
% C=====    DIP-SLIP CONTRIBUTION   =====                                 06660000
% C======================================                                 06670000
%      if DISL2~=F0
    c2 = DISL2 ~= F0;
        du2(:,1)=           ALP2.*Q./R;
        du2(:,2)=    TT./F2 +ALP2.*ET.*QX;
        du2(:,3)= ALP1.*ALX -ALP2.*Q.*QX;
        du2(:,4)=        -ALP2.*XI.*Q./R3;
        du2(:,5)= -QY./F2 -ALP2.*ET.*Q./R3;
        du2(:,6)= ALP1./R +ALP2.*Q2./R3;
        du2(:,7)=                      ALP2.*EY;
        du2(:,8)= ALP1.*D.*X11+XY./F2.*SD +ALP2.*ET.*GY;
        du2(:,9)= ALP1.*Y.*X11          -ALP2.*Q.*GY;
        du2(:,10)=                      ALP2.*EZ;
        du2(:,11)= ALP1.*Y.*X11+XY./F2.*CD +ALP2.*ET.*GZ;
        du2(:,12)=-ALP1.*D.*X11          -ALP2.*Q.*GZ;
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL2./PI2,1,12).*du2(1:N_CELL,1:12)...
                .*repmat(c2,1,12);
%      end
% C========================================                               06840000
% C=====  TENSILE-FAULT CONTRIBUTION  =====                               06850000
% C========================================                               06860000
%      if DISL3~=F0
    c3 = DISL3 ~= F0;
        du3(:,1)=-ALP1.*ALE -ALP2.*Q.*QY;
        du3(:,2)=-ALP1.*ALX -ALP2.*Q.*QX;
        du3(:,3)=    TT./F2 -ALP2.*(ET.*QX+XI.*QY);
        du3(:,4)=-ALP1.*XY  +ALP2.*XI.*Q2.*Y32;
        du3(:,5)=-ALP1./R   +ALP2.*Q2./R3;
        du3(:,6)=-ALP1.*QY  -ALP2.*Q.*Q2.*Y32;
        du3(:,7)=-ALP1.*(CD./R+QY.*SD)  -ALP2.*Q.*FY;
        du3(:,8)=-ALP1.*Y.*X11         -ALP2.*Q.*GY;
        du3(:,9)= ALP1.*(D.*X11+XY.*SD) +ALP2.*Q.*HY;
        du3(:,10)= ALP1.*(SD./R-QY.*CD)  -ALP2.*Q.*FZ;
        du3(:,11)= ALP1.*D.*X11         -ALP2.*Q.*GZ;
        du3(:,12)= ALP1.*(Y.*X11+XY.*CD) +ALP2.*Q.*HZ;
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL3./PI2,1,12).*du3(1:N_CELL,1:12)...
                .*repmat(c3,1,12);
%        end
%      end
% 
%       RETURN                                                            07030000
%       END  