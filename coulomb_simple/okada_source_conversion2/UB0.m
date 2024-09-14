function [U] = UB0(X,Y,D,Z,POT1,POT2,POT3,POT4)
%       SUBROUTINE  UB0(X,Y,D,Z,POT1,POT2,POT3,POT4,U)                    02150000
%       IMPLICIT REAL*8 (A-H,O-Z)                                         02160000
%       DIMENSION U(12),DU(12)                                            02170000
% C                                                                       02180000
% C********************************************************************   02190000
% C*****    DISPLACEMENT AND STRAIN AT DEPTH (PART-B)             *****   02200000
% C*****    DUE TO BURIED POINT SOURCE IN A SEMIINFINITE MEDIUM   *****   02210000
% C********************************************************************   02220000
% C                                                                       02230000
% C***** INPUT                                                            02240000
% C*****   X,Y,D,Z : STATION COORDINATES IN FAULT SYSTEM                  02250000
% C*****   POT1-POT4 : STRIKE-, DIP-, TENSILE- AND INFLATE-POTENCY        02260000
% C***** OUTPUT                                                           02270000
% C*****   U(12) : DISPLACEMENT AND THEIR DERIVATIVES                     02280000
% C                                                                       02290000
global ALP1 ALP2 ALP3 ALP4 ALP5 SD CD SDSD CDCD SDCD S2D C2D
global P Q S T XY X2 Y2 D2 R R2 R3 R5 QR QRX A3 A5 B3 C3 UY VY WY UZ VZ WZ
global N_CELL
F0 = zeros(N_CELL,1,'double');
F1 = ones(N_CELL,1,'double');
F2 = ones(N_CELL,1,'double').*2.0;
F3 = ones(N_CELL,1,'double').*3.0;
F4 = ones(N_CELL,1,'double').*4.0;
F5 = ones(N_CELL,1,'double').*5.0;
F8 = ones(N_CELL,1,'double').*8.0;
F9 = ones(N_CELL,1,'double').*9.0;
PI2 = ones(N_CELL,1,'double').*6.283185307179586;

%       COMMON /C0/ALP1,ALP2,ALP3,ALP4,ALP5,SD,CD,SDSD,CDCD,SDCD,S2D,C2D  02300000
%       COMMON /C1/P,Q,S,T,XY,X2,Y2,D2,R,R2,R3,R5,QR,QRX,A3,A5,B3,C3,     02310000
%      *           UY,VY,WY,UZ,VZ,WZ                                      02320000
%       DATA F0,F1,F2,F3,F4,F5,F8,F9                                      02330000
%      *        /0.D0,1.D0,2.D0,3.D0,4.D0,5.D0,8.D0,9.D0/                 02340000
%       DATA PI2/6.283185307179586D0/                                     02350000
% C-----                                                                  02360000
	C=D+Z;
	RD=R+D;
	D12=F1./(R.*RD.*RD);
	D32=D12.*(F2.*R+D)./R2;
	D33=D12.*(F3.*R+D)./(R2.*RD);
	D53=D12.*(F8.*R2+F9.*R.*D+F3.*D2)./(R2.*R2.*RD);
	D54=D12.*(F5.*R2+F4.*R.*D+D2)./R3.*D12;
% C-----                                                                  02440000
	FI1= Y.*(D12-X2.*D33);
	FI2= X.*(D12-Y2.*D33);
	FI3= X./R3-FI2;
	FI4=-XY.*D32;
	FI5= F1./(R.*RD)-X2.*D32;
	FJ1=-F3.*XY.*(D33-X2.*D54);
	FJ2= F1./R3-F3.*D12+F3.*X2.*Y2.*D54;
	FJ3= A3./R3-FJ2;
	FJ4=-F3.*XY./R5-FJ1;
	FK1=-Y.*(D32-X2.*D53);
	FK2=-X.*(D32-Y2.*D53);
	FK3=-F3.*X.*D./R5-FK2;
% C-----                                                                  02570000
%       DO 111  I=1,12
%   111 U(I)=F0                                                           02590000
    U  = zeros(N_CELL,12,'double');
% C======================================                                 02600000
% C=====  STRIKE-SLIP CONTRIBUTION  =====                                 02610000
% C======================================                                 02620000
%       IF(POT1.NE.F0) THEN                                               02630000
c1 = POT1 ~= F0;
	DU(:,1)=-X2.*QR  -ALP3.*FI1.*SD;
	DU(:,2)=-XY.*QR  -ALP3.*FI2.*SD;
	DU(:,3)=-C.*X.*QR -ALP3.*FI4.*SD;
	DU(:,4)=-X.*QR.*(F1+A5) -ALP3.*FJ1.*SD;
	DU(:,5)=-Y.*QR.*A5      -ALP3.*FJ2.*SD;
	DU(:,6)=-C.*QR.*A5      -ALP3.*FK1.*SD;
	DU(:,7)=-F3.*X2./R5.*UY      -ALP3.*FJ2.*SD;
	DU(:,8)=-F3.*XY./R5.*UY-X.*QR -ALP3.*FJ4.*SD;
	DU(:,9)=-F3.*C.*X./R5.*UY     -ALP3.*FK2.*SD;
	DU(:,10)=-F3.*X2./R5.*UZ  +ALP3.*FK1.*SD;
	DU(:,11)=-F3.*XY./R5.*UZ  +ALP3.*FK2.*SD;
	DU(:,12)= F3.*X./R5.*(-C.*UZ +ALP3.*Y.*SD);
%         DO 222 I=1,12                                                   02760000
%   222   U(I)=U(I)+POT1/PI2*DU(I)                                        02770000
%       ENDIF 
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT1./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c1,1,12);
% C===================================                                    02790000
% C=====  DIP-SLIP CONTRIBUTION  =====                                    02800000
% C===================================                                    02810000
%       IF(POT2.NE.F0) THEN                                               02820000
c2 = POT2 ~= F0;
	DU(:,1)=-X.*P.*QR +ALP3.*FI3.*SDCD;
	DU(:,2)=-Y.*P.*QR +ALP3.*FI1.*SDCD;
	DU(:,3)=-C.*P.*QR +ALP3.*FI5.*SDCD;
	DU(:,4)=-P.*QR.*A5 +ALP3.*FJ3.*SDCD;
	DU(:,5)= Y.*P.*QRX +ALP3.*FJ1.*SDCD;
	DU(:,6)= C.*P.*QRX +ALP3.*FK3.*SDCD;
	DU(:,7)=-F3.*X./R5.*VY      +ALP3.*FJ1.*SDCD;
	DU(:,8)=-F3.*Y./R5.*VY-P.*QR +ALP3.*FJ2.*SDCD;
	DU(:,9)=-F3.*C./R5.*VY      +ALP3.*FK1.*SDCD;
	DU(:,10)=-F3.*X./R5.*VZ -ALP3.*FK3.*SDCD;
	DU(:,11)=-F3.*Y./R5.*VZ -ALP3.*FK1.*SDCD;
	DU(:,12)=-F3.*C./R5.*VZ +ALP3.*A3./R3.*SDCD;
%         DO 333 I=1,12                                                   02950000
%   333   U(I)=U(I)+POT2/PI2*DU(I)                                        02960000
%       ENDIF                                                             02970000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT2./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c2,1,12);

% C========================================                               02980000
% C=====  TENSILE-FAULT CONTRIBUTION  =====                               02990000
% C========================================                               03000000
%       IF(POT3.NE.F0) THEN                                               03010000
c3 = POT3 ~= F0;
	DU(:,1)= X.*Q.*QR -ALP3.*FI3.*SDSD;
	DU(:,2)= Y.*Q.*QR -ALP3.*FI1.*SDSD;
	DU(:,3)= C.*Q.*QR -ALP3.*FI5.*SDSD;
	DU(:,4)= Q.*QR.*A5 -ALP3.*FJ3.*SDSD;
	DU(:,5)=-Y.*Q.*QRX -ALP3.*FJ1.*SDSD;
	DU(:,6)=-C.*Q.*QRX -ALP3.*FK3.*SDSD;
	DU(:,7)= X.*QR.*WY     -ALP3.*FJ1.*SDSD;
	DU(:,8)= QR.*(Y.*WY+Q) -ALP3.*FJ2.*SDSD;
	DU(:,9)= C.*QR.*WY     -ALP3.*FK1.*SDSD;
	DU(:,10)= X.*QR.*WZ +ALP3.*FK3.*SDSD;
	DU(:,11)= Y.*QR.*WZ +ALP3.*FK1.*SDSD;
	DU(:,12)= C.*QR.*WZ -ALP3.*A3./R3.*SDSD;
%	DO 444 I=1,12                                                   03140000
%   444   U(I)=U(I)+POT3/PI2*DU(I)                                        03150000
%       ENDIF 
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT3./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c3,1,12);
% C=========================================                              03170000
% C=====  INFLATE SOURCE CONTRIBUTION  =====                              03180000
% C=========================================                              03190000
%       IF(POT4.NE.F0) THEN                                               03200000
c4 = POT4 ~= F0;
	DU(:,1)= ALP3.*X./R3;
	DU(:,2)= ALP3.*Y./R3;
	DU(:,3)= ALP3.*D./R3;
	DU(:,4)= ALP3.*A3./R3;
	DU(:,5)=-ALP3.*F3.*XY./R5;
	DU(:,6)=-ALP3.*F3.*X.*D./R5;
	DU(:,7)= DU(:,5);
	DU(:,8)= ALP3.*B3./R3;
	DU(:,9)=-ALP3.*F3.*Y.*D./R5;
	DU(:,10)=-DU(:,6);
	DU(:,11)=-DU(:,9);
	DU(:,12)=-ALP3.*C3./R3;
%         DO 555 I=1,12                                                   03330000
%   555   U(I)=U(I)+POT4/PI2*DU(I)                                        03340000
%       ENDIF                                                             03350000
    U(1:N_CELL,1:12)=U(1:N_CELL,1:12)...
                +repmat(POT4./PI2,1,12).*DU(1:N_CELL,1:12)...
                .*repmat(c4,1,12);
%       RETURN                                                            03360000
%       END                                                               03370000
