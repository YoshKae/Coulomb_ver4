function [U] = UB(XI,ET,Q,DISL1,DISL2,DISL3)
% DIMENSION U(12),DU(12)

% C                                                                       07080000
% C********************************************************************   07090000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH (PART-B)             *****   07100000
% C*****    DUE TO BURIED FINITE FAULT IN A SEMIINFINITE MEDIUM   *****   07110000
% C********************************************************************   07120000
% C                                                                       07130000
% C***** INPUT                                                            07140000
% C*****   XI,ET,Q : STATION COORDINATES IN FAULT SYSTEM                  07150000
% C*****   DISL1-DISL3 : STRIKE-, DIP-, TENSILE-DISLOCATIONS              07160000
% C***** OUTPUT                                                           07170000
% C*****   U(12) : DISPLACEMENT AND THEIR DERIVATIVES                     07180000
% C                                                                       07190000
%       COMMON /C0/ALP1,ALP2,ALP3,ALP4,ALP5,SD,CD,SDSD,CDCD,SDCD,S2D,C2D  07200000
%       COMMON /C2/XI2,ET2,Q2,R,R2,R3,R5,Y,D,TT,ALX,ALE,X11,Y11,X32,Y32,  07210000
%      *           EY,EZ,FY,FZ,GY,GZ,HY,HZ                                07220000
     
global ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global XI2 ET2 Q2 R R2 R3 R5 Y D TT ALX ALE X11 Y11 X32 Y32
global EY EZ FY FZ GY GZ HY HZ
global N_CELL

%       DATA  F0,F1,F2,PI2/0.D0,1.D0,2.D0,6.283185307179586D0/            07230000
F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;

DU = zeros(N_CELL,12,'double');

%C-----                                                                  07240000
      RD=R+D;
      D11=F1./(R.*RD);
      AJ2=XI.*Y./RD.*D11;
      AJ5=-(D+Y.*Y./RD).*D11;
      
% if CD~=F0
   c1 = CD ~= F0;
   c2 = CD == F0;
   s1 = XI == F0;
   s2 = XI ~= F0;

% ----- To avoid 'Inf' and 'nan' troubles (divided by zero) ------
  tempCD = CD;
  tempCDCD = CDCD;
   CD = c1.*CD + c2.*1.0e-12;
   CDCD = c1.*CDCD + c2.*1.0e-12;
   
   X=double(sqrt(XI2+Q2));
   RD2=RD.*RD;
	AI4 = c1.*(s1.*F0 + s2.*(F1./CDCD.*( XI./RD.*SDCD...
                +F2.*atan((ET.*(X+Q.*CD)+X.*(R+X).*SD)./(XI.*(R+X).*CD)))))...
                +c2.*(XI.*Y./RD2./F2);
	AI3 = c1.*((Y.*CD./RD-ALE+SD.*double(log(RD)))./CDCD)...
            +c2.*((ET./RD+Y.*Q./RD2-ALE)./F2);
	AK1 = c1.*(XI.*(D11-Y11.*SD)./CD)+c2.*(XI.*Q./RD.*D11);
	AK3 = c1.*((Q.*Y11-Y.*D11)./CD)+c2.*(SD./RD.*(XI2.*D11-F1));
	AJ3 = c1.*((AK1-AJ2.*SD)./CD)+c2.*(-XI./RD2.*(Q2.*D11-F1./F2));
	AJ6 = c1.*((AK3-AJ5.*SD)./CD)+c2.*(-Y./RD2.*(XI2.*D11-F1./F2));

   CD = tempCD;
   CDCD = tempCDCD;
% -----
      XY=XI.*Y11;
      AI1=-XI./RD.*CD-AI4.*SD;
      AI2= double(log(RD))+AI3.*SD;
      AK2= F1./R+AK3.*SD;
      AK4= XY.*CD-AK1.*SD;
      AJ1= AJ5.*CD-AJ6.*SD;
      AJ4=-XY-AJ2.*CD+AJ3.*SD;
%C=====                                                                  07590000
%    for I=1:1:12
       U(1:N_CELL,1:12) = 0.0; 
%    end
      QX=Q.*X11;
      QY=Q.*Y11;
% C======================================                                 07640000
% C=====  STRIKE-SLIP CONTRIBUTION  =====                                 07650000
% C======================================                                 07660000
%      if DISL1~=F0
          c1 = DISL1 ~= F0;
        DU(:,1)=-XI.*QY-TT -ALP3.*AI1.*SD;
        DU(:,2)=-Q./R      +ALP3.*Y./RD.*SD;
        DU(:,3)= Q.*QY     -ALP3.*AI2.*SD;
        DU(:,4)= XI2.*Q.*Y32 -ALP3.*AJ1.*SD;
        DU(:,5)= XI.*Q./R3   -ALP3.*AJ2.*SD;
        DU(:,6)=-XI.*Q2.*Y32 -ALP3.*AJ3.*SD;
        DU(:,7)=-XI.*FY-D.*X11 +ALP3.*(XY+AJ4).*SD;
        DU(:,8)=-EY          +ALP3.*(F1./R+AJ5).*SD;
        DU(:,9)= Q.*FY        -ALP3.*(QY-AJ6).*SD;
        DU(:,10)=-XI.*FZ-Y.*X11 +ALP3.*AK1.*SD;
        DU(:,11)=-EZ          +ALP3.*Y.*D11.*SD;
        DU(:,12)= Q.*FZ        +ALP3.*AK2.*SD;
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL1./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c1,1,12);
%        end
%      end
% C======================================                                 07830000
% C=====    DIP-SLIP CONTRIBUTION   =====                                 07840000
% C======================================                                 07850000
%      if DISL2~=F0
           c2 = DISL2 ~= F0;
        DU(:,1)=-Q./R      +ALP3.*AI3.*SDCD;
        DU(:,2)=-ET.*QX-TT -ALP3.*XI./RD.*SDCD;
        DU(:,3)= Q.*QX     +ALP3.*AI4.*SDCD;
        DU(:,4)= XI.*Q./R3     +ALP3.*AJ4.*SDCD;
        DU(:,5)= ET.*Q./R3+QY  +ALP3.*AJ5.*SDCD;
        DU(:,6)=-Q2./R3       +ALP3.*AJ6.*SDCD;
        DU(:,7)=-EY          +ALP3.*AJ1.*SDCD;
        DU(:,8)=-ET.*GY-XY.*SD +ALP3.*AJ2.*SDCD;
        DU(:,9)= Q.*GY        +ALP3.*AJ3.*SDCD;
        DU(:,10)=-EZ          -ALP3.*AK3.*SDCD;
        DU(:,11)=-ET.*GZ-XY.*CD -ALP3.*XI.*D11.*SDCD;
        DU(:,12)= Q.*GZ        -ALP3.*AK4.*SDCD;
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL2./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c2,1,12);
%        end
%      end
% C========================================                               08020000
% C=====  TENSILE-FAULT CONTRIBUTION  =====                               08030000
% C========================================                               08040000
%      if DISL3~=F0
           c3 = DISL3 ~= F0;
        DU(:,1)= Q.*QY           -ALP3.*AI3.*SDSD;
        DU(:,2)= Q.*QX           +ALP3.*XI./RD.*SDSD;
        DU(:,3)= ET.*QX+XI.*QY-TT -ALP3.*AI4.*SDSD;
        DU(:,4)=-XI.*Q2.*Y32 -ALP3.*AJ4.*SDSD;
        DU(:,5)=-Q2./R3     -ALP3.*AJ5.*SDSD;
        DU(:,6)= Q.*Q2.*Y32  -ALP3.*AJ6.*SDSD;
        DU(:,7)= Q.*FY -ALP3.*AJ1.*SDSD;
        DU(:,8)= Q.*GY -ALP3.*AJ2.*SDSD;
        DU(:,9)=-Q.*HY -ALP3.*AJ3.*SDSD;
        DU(:,10)= Q.*FZ +ALP3.*AK3.*SDSD;
        DU(:,11)= Q.*GZ +ALP3.*XI.*D11.*SDSD;
        DU(:,12)=-Q.*HZ +ALP3.*AK4.*SDSD;
%        for I=1:1:12
            U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(DISL3./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c3,1,12);
%        end
%      end
%       RETURN                                                            08210000
%       END                                                               08220000
